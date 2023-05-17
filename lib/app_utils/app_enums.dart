enum AuthType {
  facebook,
  google,
  phone,
}

enum SignInBodyType {
  send_otp,
  verify_otp,
}

enum MethodType {
  add,
  update,
}

enum OrderStatus {
  Accepted,
  Packed,
  ReadyToDispatch,
  OutForDelivery,
}

enum AppDateFormat{
  yyyyMMddTHHmmssSSSZ,
  yyyymmddHHmmss,

}
