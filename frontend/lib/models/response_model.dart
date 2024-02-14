class ResponseModel{
  bool _isSuccess;
  String _message;

  ResponseModel(this._isSuccess, this._message); //note, no curly braces for private variables

  String get message => _message;
  bool get isSuccess => _isSuccess; 

}