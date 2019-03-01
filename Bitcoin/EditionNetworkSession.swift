//
//  EditionNetworkSession.swift
//  Edition
//


//

import Foundation
class EditionNetworkSession:NSObject,URLSessionDelegate {
    let url:URL
    var urlSession:Foundation.URLSession?
    var successBlock:(Data)->Void
    
    var failureBlock:(NSError? )->Void
    var dataTask:URLSessionDataTask?
    var authString:String?
    var mutableData:NSMutableData?
    init(url:URL, withSuccessBlock success:@escaping (Data)->Void , andFailure failure:@escaping (NSError? )->Void ){
        self.url=url
        successBlock=success
        failureBlock=failure
      
    }
  



    /// This function uses NSURLSession to send post request

    func setUpPostRequest ( parametersDictionary:[String:String]){

        let config = URLSessionConfiguration.ephemeral

//        print(url)

    //    config.HTTPAdditionalHeaders = ["Authorization" : authString]
        // Create session
        let session = Foundation.URLSession(configuration: config,delegate: self, delegateQueue: Foundation.OperationQueue.main)

       var request = URLRequest(url: url)
        let parameters = parametersDictionary.dictionaryToString()
       // print(parameters)

        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = parameters.data(using: String.Encoding.utf8)

        dataTask = session.dataTask(with: request, completionHandler:{[unowned self] (data,response,error) in
       //    print(response)
//            print(String(data: request.httpBody!, encoding: .utf8))
            if let nserror = error as NSError?
            {
                self.failureBlock(nserror)
            }
            else {
              //  print("\(error) \(NSString(data: data, encoding: NSUTF8StringEncoding)))")
//                do{
//                   
//                }
//                catch{
//                    let nserror = error as NSError
//                    self.failureBlock(nserror)
//                    print(String(data: data!, encoding: String.Encoding.utf8))
//
//                }
                if data != nil {
                    
                    print(data!.count)

                self.successBlock(data!)
                }

            }
            })
        dataTask?.resume()
    }
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?){
        print(error as Any)
    }
    /// This function uses NSURLSession to send get request
    func setUpGetRequest(_ url:String){

        let config = URLSessionConfiguration.default

        urlSession = Foundation.URLSession(configuration: config, delegate: self, delegateQueue: nil)
        guard let nsurl = URL(string: url) else {
            self.failureBlock(nil)
            return
        }
        
            var request = URLRequest(url: nsurl)
            request.httpMethod="GET"
          
            dataTask =     urlSession!.dataTask(with: request, completionHandler: {[unowned self] (data,response,error) in
                if let nserror = error as NSError? {

                self.failureBlock(nserror)
            }else {
              //  print("\(error) \(NSString(data: data, encoding: NSUTF8StringEncoding)))")
            
                    DispatchQueue.main.async{

                            if data != nil {
                            self.successBlock(data!)
                            }
                            else{
                                self.failureBlock(nil)
                            }
                        
            
                        self.failureBlock(error as NSError?)
                        
                    }

            
                
            }
        
        })
        
        dataTask?.resume()

        
    }
    func cancelRequest(){
        dataTask?.cancel()
    }
}
extension Dictionary{
    /// This function converts dictionary to String.
    func dictionaryToString()->String{
        var string:String = String()
        for (key,value) in self{
            if string.count == 0 {
                string = string + "\(key)="+"\(value)"
  
            }else{
            string = string + "&\(key)="+"\(value)"
            }
        }
        return string
    }
}
