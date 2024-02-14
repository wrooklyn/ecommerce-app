class SignInBody{
  String email;
  String password; 

  SignInBody({
      required this.email,
      required this.password
  });
  
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["email"]=email;
    data["password"]=password;
    return data; 
  }
}