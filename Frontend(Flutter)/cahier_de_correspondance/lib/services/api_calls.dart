import 'package:http/http.dart' as http;
import 'dart:convert';





class ApiCalls{
var client=http.Client();
//static const String baseUrl='http://192.168.52.142:8000/api';
static const String baseUrl='http://192.168.100.10:8000/api';
Future<dynamic> get(String api,String token)async{
  var url=Uri.parse(baseUrl+api);
  var _headers={
    'Authorization':'Bearer '+token,
  };
  var response=await client.get(url,headers: _headers);

  if(response.statusCode==200){
   //var json= response.body;
   return response.body;
   
  }else{
   response.statusCode;
  }
}
Future<dynamic> getDevoir(String api,String token)async{
  var url=Uri.parse(baseUrl+api);
  var _headers={
    'Authorization':'Bearer '+token,
  };
  var response=await client.get(url,headers: _headers);

  return response;
}

Future<dynamic> post(String api,String token,dynamic object)async{
  var url=Uri.parse(baseUrl+api);
  var _payload=json.encode(object);
  var _headers={
    'Authorization':'Bearer '+token,
    'Accept':'application/json',
    'Content-type':'application/json',
  };
  var response=await client.post(url,body:object,headers: _headers);

  if(response.statusCode==200){
   
   return response.body;
   
  }else{
    return response.statusCode;
  }
}

Future<dynamic> delete(String api,String token)async{
  var url=Uri.parse(baseUrl+api);
  var _headers={
    'Authorization':'Bearer '+token,
  };
  var response=await client.delete(url,headers: _headers);
   return response.statusCode;
 
}

}