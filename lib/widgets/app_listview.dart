import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef LoadMoreCallback = void Function();

class AppListView extends StatelessWidget {
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final int itemCount;
  final Widget? header;
  final Widget? footer;
  final RefreshCallback? onRefresh;
  final LoadMoreCallback? onLoadMore;
  final Color? refreshIndicatorBackgroundColor;
  final Color? refreshIndicatorColor;
  final bool hasPinHeader;

  const AppListView({
    Key? key,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.physics,
    this.padding,
    required this.itemBuilder,
    this.separatorBuilder,
    this.itemCount = 0,
    this.header,
    this.footer,
    this.onRefresh,
    this.onLoadMore,
    this.refreshIndicatorBackgroundColor,
    this.refreshIndicatorColor,
    this.hasPinHeader = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _scrollController =
        _mountLoadmoreListenerToController(controller, onLoadMore);
    final _itemCount = _caluculateItemCount(itemCount);
    final _itemBuilder =
        _mountHeaderFooterBuilder(itemBuilder, header, footer, _itemCount);
    final _seperatorBuilder =
        _cleanSeperatorBuilder(separatorBuilder, header, footer, _itemCount);

    return Stack(children: [
      RefreshIndicator(
          notificationPredicate: onRefresh == null
              ? (notification) => false
              : defaultScrollNotificationPredicate,
          color: refreshIndicatorColor,
          backgroundColor: refreshIndicatorBackgroundColor,
          child: ListView.separated(
            controller: _scrollController,
            itemBuilder: _itemBuilder,
            itemCount: _itemCount,
            separatorBuilder: _seperatorBuilder,
            scrollDirection: scrollDirection,
            reverse: reverse,
            physics: physics,
            padding: padding,
          ),
          onRefresh: onRefresh ??
              () async {
                await Future.delayed(Duration(seconds: 5));
              }),
      Column(
        children: [
          (header != null && hasPinHeader)
              ? _PinnedHeader(
                  key: GlobalKey(),
                  controller: _scrollController,
                  header: header,
                )
              : Container()
        ],
      )
    ]);
  }

  ScrollController _mountLoadmoreListenerToController(
      ScrollController? _scrollScontroller, LoadMoreCallback? _loadMoreCallback) {
    final _controller = (_scrollScontroller ?? ScrollController());
    return _controller
      ..addListener(() {
        _loadMoreListener(_controller, _loadMoreCallback);
      });
  }

  void _loadMoreListener(
      ScrollController _scrollScontroller, LoadMoreCallback? _loadMoreCallback) {
    if (_loadMoreCallback != null &&
        _scrollScontroller.position.userScrollDirection ==
            ScrollDirection.reverse &&
        _scrollScontroller.position.extentAfter < 300) {
      _loadMoreCallback();
    }
  }

  int _caluculateItemCount(int currentCount) {
    return currentCount + (header == null ? 0 : 1) + (footer == null ? 0 : 1);
  }

  IndexedWidgetBuilder _mountHeaderFooterBuilder(
      IndexedWidgetBuilder _itemBuilder,
      Widget? _header,
      Widget? _footer,
      int _itemCount) {
    return (context, position) {
      if (position == 0) {
        return _header ?? _itemBuilder(context, position);
      }
      if (position == (_itemCount - 1) && _footer != null) {
        return _footer;
      }
      return _itemBuilder(context, position - (_header == null ? 0 : 1));
    };
  }

  IndexedWidgetBuilder _cleanSeperatorBuilder(
      IndexedWidgetBuilder? _seperatorBuilder,
      Widget? _header,
      Widget? _footer,
      int _itemCount) {
    return (context, position) {
      if (_seperatorBuilder == null) {
        return Container();
      }
      if (position == 0) {
        return (_header != null)
            ? Container()
            : _seperatorBuilder(context, position);
      }
      if (position == (_itemCount - 2) && _footer != null) {
        return Container();
      }
      return _seperatorBuilder(context, position - (_header == null ? 0 : 1));
    };
  }
}

class _PinnedHeader extends StatefulWidget {
  final Widget? header;
  final ScrollController? controller;
  final GlobalKey? key;

  const _PinnedHeader({
    this.key,
    this.header,
    this.controller,
  }) : super(key: key);

  @override
  __PinnedHeaderState createState() => __PinnedHeaderState();
}

class __PinnedHeaderState extends State<_PinnedHeader>
    with TickerProviderStateMixin {
  late bool showPinnedHeader;
  late Animation _translateAnimation;
  late AnimationController _pinnedHeaderAnimationController;
  double? pinnedHeight;

  @override
  void initState() {
    super.initState();
    showPinnedHeader = false;
    pinnedHeight = 0;
    WidgetsBinding.instance!.addPostFrameCallback(_afterLayout);

    _pinnedHeaderAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _mountAnimationToHeader();
  }

  @override
  void dispose() {
    _unmountHeaderAniamtion();
    _unmountHeaderStateListenerToController();
    super.dispose();
  }

  _afterLayout(_) {
    if (pinnedHeight == 0) {
      final RenderBox? _pinnedHeaderRenderObject =
          widget.key?.currentContext?.findRenderObject() as RenderBox?;
      final _pinnedHeaderSize = _pinnedHeaderRenderObject?.size;

      setState(() {
        pinnedHeight = _pinnedHeaderSize?.height ?? 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _mountHeaderStateListenerToController();
    _translateAnimation = Tween(begin: 0.0, end: -(pinnedHeight! + 20))
        .animate(_pinnedHeaderAnimationController);

    return AnimatedBuilder(
      animation: _pinnedHeaderAnimationController,
      builder: (context, child) => Transform.translate(
        offset: Offset(0.0, _translateAnimation.value),
        child: Opacity(
          opacity: showPinnedHeader ? 1 : 0,
          child: Card(
            color: Colors.white,
            margin: EdgeInsets.all(0),
            child: widget.header,
            elevation: 5,
          ),
        ),
      ),
    );
  }

  void _mountAnimationToHeader() {
    _pinnedHeaderAnimationController.addListener(_animationListener);
  }

  void _unmountHeaderAniamtion() {
    _pinnedHeaderAnimationController.removeListener(_animationListener);
  }

  void _mountHeaderStateListenerToController() {
    widget.controller!.addListener(_headerStateListener);
  }

  void _unmountHeaderStateListenerToController() {
    widget.controller!.removeListener(_headerStateListener);
  }

  _animationListener() {
    /// Hide Pinned header after tranlate up animation complete
    if ((_pinnedHeaderAnimationController.isCompleted ||
            _pinnedHeaderAnimationController.isDismissed) &&
        _pinnedHeaderAnimationController.value == 1) {
      setState(() {
        showPinnedHeader = false;
      });
    }

    /// Show Pinned heder when it is hiding and translate down animation be started
    if (!showPinnedHeader && _pinnedHeaderAnimationController.value < 1) {
      setState(() {
        showPinnedHeader = true;
      });
    }
  }

  void _headerStateListener() {
    if (showPinnedHeader) {
      if (widget.controller!.position.userScrollDirection ==
          ScrollDirection.reverse) {
        _pinnedHeaderAnimationController.forward();
      }
      if (widget.controller!.position.extentBefore <= 0) {
        _pinnedHeaderAnimationController.forward(from: pinnedHeight);
      }
    } else {
      if (widget.controller!.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (widget.controller!.position.extentBefore > 0) {
          _pinnedHeaderAnimationController.reverse(from: pinnedHeight);
        } else {
          _pinnedHeaderAnimationController.forward(from: pinnedHeight);
        }
      }
    }
  }
}
