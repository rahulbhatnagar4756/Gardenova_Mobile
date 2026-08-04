class VerifiedEmailLocalParsingModel {
  String email;
  String userType;
  bool fromLoginFlow;
  bool requestSussessFull;

  VerifiedEmailLocalParsingModel({
    required this.email,
    required this.userType,
    required this.fromLoginFlow,
    this.requestSussessFull = false,
  });
}
