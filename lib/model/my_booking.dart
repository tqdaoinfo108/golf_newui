import 'booking.dart';

class MyBooking {
  int? date;
  List<Booking>? lstBooking;

  MyBooking({this.date, this.lstBooking});
}

// class Booking {
//   String shopName;
//   String adress;
//   int statusID;

//   Booking({this.shopName, this.adress, this.statusID});
// }

// List<MyBooking> initData() {
//   var list = List<MyBooking>();

//   var listBooking = List<Booking>();
//   listBooking.add(new Booking(
//       shopName: "Địa chỉ Viện nghiên cứu hỗ trợ qui hoạch",
//       adress:
//           "Tầng 3-4 Tòa nhà, 125 Đồng Văn Cống, Phường Thạnh Mỹ Lợi, Quận 2, Thành phố Hồ Chí Minh",
//       statusID: 0));
//   listBooking.add(new Booking(
//       shopName: "Địa chỉ Viện nghiên cứu hỗ trợ qui hoạch",
//       adress:
//           "Tầng 3-4 Tòa nhà, 125 Đồng Văn Cống, Phường Thạnh Mỹ Lợi, Quận 2, Thành phố Hồ Chí Minh",
//       statusID: 1));
//   list.add(new MyBooking(date: 1614758987, lstBooking: listBooking));
//   list.add(new MyBooking(date: 1614758987, lstBooking: listBooking));
//   list.add(new MyBooking(date: 1614758987, lstBooking: listBooking));

//   return list;
// }
