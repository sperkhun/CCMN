//
//  CiscoRequests.swift
//  CCMN
//
//  Created by Serhii PERKHUN on 11/5/18.
//  Copyright © 2018 Serhii PERKHUN. All rights reserved.
//

import UIKit
import Alamofire

class CiscoRequests {
    let parser = Parser()
    
    private var Manager : Alamofire.SessionManager = {
        // Create the server trust policies
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "cisco-cmx.unit.ua": .disableEvaluation, "cisco-presence.unit.ua": .disableEvaluation
        ]
        // Create custom manager
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let man = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        return man
    }()
    
    func dataRequest(name: String, floor: String, completion: @escaping (Bool) -> Void) {
        let data = requests[name]!
        let auth = "Basic " + String("RO:" + data.password).toBase64()
        let url = data.url + floor
        Manager.request(url.replacingOccurrences(of: " ", with: "%20"), headers: ["Authorization": auth]).validate().responseData { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    self.parser.mapImg(imageData: value)
                    completion(true)
                    print(name + " OK")
                }
            case .failure(let error):
                print(name + "!!!!!!!!!!!!!!!!")
                print(error)
                completion(false)
            }
        }
    }
    
    func paramJsonRequest(name: String, dopUrl: String, param: [String:Any], completion: @escaping (Bool) -> Void) {
        let data = requests[name]!
        let auth = "Basic " + String("RO:" + data.password).toBase64()
        Manager.request(data.url + dopUrl, method: .get, parameters: param, headers: ["Authorization": auth]).validate().responseJSON { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    self.parser.paramParseAll(name: name, timeStamp: MainData.timeStamp, data: value)
                    completion(true)
                    print(name + " OK")
                }
            case .failure(let error):
                print(name + "!!!!!!!!!!!!!!!!!!!!!")
                print(error)
                completion(false)
            }
        }
    }
    
    func jsonRequest(name: String, completion: @escaping (Bool) -> Void) {
        let data = requests[name]!
        let auth = "Basic " + String("RO:" + data.password).toBase64()
        Manager.request(data.url, headers: ["Authorization": auth]).validate().responseJSON { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    self.parser.parseAll(name: name, data: value)
                    completion(true)
                    print(name + " OK")
                }
            case .failure(let error):
                print(name + "!!!!!!!!!!!!!!!!!!!!!")
                print(error)
                completion(false)
                }
            }
        }
    }
