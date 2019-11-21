//
//  RestApiManager.swift
//  CotizadorCafam
//
//  Created by Fabian Humberto Castillo Pineda on 20/11/19.
//  Copyright © 2019 Fabian Humberto Castillo Pineda. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

typealias ServiceResponse = (JSON,Error?)-> Void

class RestApiManager: NSObject {
    static let sharedInstance = RestApiManager()
    let baseUrl = "http://3.133.205.205/cafam/webservices/ws.php?request=action"
    
    func getProgramas(onCompletion:@escaping(JSON) -> Void){
        let route = baseUrl
        let params:[String: String] = [
               "apiKey" : "58587775f2f54284a4e8b5e92e0b611f",
               "JSON":"1",
               "method":"getInfraestructuras"
           ]
       
        /*makeHTTPGetRequest(path: route) {(json: JSON , error: Error?)
            in onCompletion(json as JSON)
            
        }*/
        makeHTTPPostRequest(path: route, body: params) { (json: JSON, error: Error?) in
                   onCompletion(json as JSON)
               }
       //makeHTTPPostRequest1()
            
            
        }
        
    }
    
    private func makeHTTPPostRequest(path: String, body:[String:String], onCompletion: @escaping ServiceResponse) {
      var request = URLRequest(url: NSURL(string: path)! as URL)
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            do { // it's similiar GET but add body data.
                let jsonBody = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
                request.httpBody = jsonBody
                URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
                    if let jsonData = data {
                        do{
                            let json:JSON = try JSON(data:jsonData)
                            print(json)
                            onCompletion(json,nil)
                        }catch{
                            onCompletion(JSON(),error)
                        }
                    }else {
                        onCompletion(JSON(),error)
                    }
                }.resume()
            }catch {
                onCompletion(JSON(),nil)
            }
    }
    
    private func makeHTTPPostRequest1()
    {
    let json: [String: Any] = ["apiKey" : "58587775f2f54284a4e8b5e92e0b611f",
    "JSON":"1",
    "method":"getInfraestructuras"]

    let jsonData = try? JSONSerialization.data(withJSONObject: json)

    // create post request
    let url = URL(string: "http://3.133.205.205/cafam/webservices/ws.php?request=action")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    // insert json data to the request
    request.httpBody = jsonData

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            print(error?.localizedDescription ?? "No data")
            return
        }
        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
        if let responseJSON = responseJSON as? [String: Any] {
            print(responseJSON)
        }
    }

    task.resume()
    }
    
