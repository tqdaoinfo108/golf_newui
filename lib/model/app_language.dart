class AppLanguage {
  String code;
  String? name;

  AppLanguage(this.code, this.name);

  @override
  bool operator ==(Object other) {
    return other is AppLanguage && this.code == other.code;
  }

  @override
  int get hashCode => super.hashCode;
}
