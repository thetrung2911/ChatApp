//
//  DataService.swift
//  RimochaApp
//
//  Created by iMac dev4 on 8/28/20.
//  Copyright © 2020 vnc. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class DataService {

    class var sharedInstance: DataService {
        struct Singleton{
            static let instance = DataService()
        }
        return Singleton.instance
    }
    
    //Set request timeout
    let manager : Session = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10
        config.timeoutIntervalForResource = 10
        let mrg =  Alamofire.Session(configuration: config)
        return mrg
    }()
    /*
     Encoding Object
     Input: Any Object
     Output: Json Object
     */
    func encodingParamToDict<T:Codable>(object : T) -> [String: Any]
    {
        let jsonEncode = JSONEncoder()
        var jsonDict = [String: Any]()
        let jsonData = try? jsonEncode.encode(object)
        if let data = jsonData
        {
            jsonDict = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any]
        }
        return jsonDict
    }
    
     //MARK:--- Get request
     /*
      Get request using Alamofire
      Input: Host url, parameter, header
      Output: completion block, failure block
      */
    func requestGetData<T:Codable>(urlInput: String, parameter: [String:Any]?, header: HTTPHeaders?,success: @escaping (T) -> Void, fail: @escaping (String) -> (Void)){
        // create url with parameter
        var url = String()
        if let param = parameter {
            url = urlInput + "?" + param.stringFromHttpParameters()
        }else {
            url = urlInput
        }
        
        DispatchQueue.global(qos: .background).async {
            self.manager.request(url, method: .get, headers: header).responseJSON(completionHandler: {
                (response) in
                if response.error == nil {
                    print("***DATA RESPONSE: %@", String(describing: response.value))
                    if let data = response.data
                    {
                        let decoder = JSONDecoder()
                        let apiResponse = try! decoder.decode(T.self, from: data)
                        success(apiResponse)
                    }
                } else
                {
                    if let error = response.error?.localizedDescription
                    {
                        fail(error)
                    }
                }
            })
        }
    }
    
    //MARK:--- Post request
          /*
           Post request using Alamofire
           Input: Host url, parameter, header
           Output: completion block, failure block
           */
    func requestPostData<T:Codable>(urlInput: String, parameter: [String:Any]?, header: HTTPHeaders?,isRequestBody: Bool? ,success: @escaping (T) -> Void, fail: @escaping (String) -> (Void)){
        
        
        //Check type of parameters request - json object or formdata
        var request: DataRequest!
        
        if (isRequestBody ?? false) {
            request = self.manager.request(urlInput, method: .post, parameters: parameter,encoding: JSONEncoding.default,  headers:header)
        }else{
            request = self.manager.request(urlInput, method: .post, parameters: parameter, headers:header)
        }
        
        //Request to system
        request.responseJSON(completionHandler: { (response) in
            if response.error == nil
            {
                print("***DATA RESPONSE: %@", String(describing: response.value))
                if let data = response.data
                {
                    let decoder = JSONDecoder()
                    let apiResponse = try! decoder.decode(T.self, from: data)
                    success(apiResponse)
                }
            }
            else
            {
                if let error = response.error?.localizedDescription
                {
                    fail(error)
                }
            }
        })
    }
    
}
