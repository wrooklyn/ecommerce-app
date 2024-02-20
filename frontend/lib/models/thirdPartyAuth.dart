class ThirdPartyAuthBody{
  String email;
  String name; 
  String accessToken;
  String idToken; 

  ThirdPartyAuthBody({
      required this.email,
      required this.name,
      required this.accessToken,
      required this.idToken
  });
  
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["email"]=email;
    data["name"]=name;
    data["accessToken"]=accessToken;
    data["idToken"]=idToken;

    return data; 
  }
}