//
//  NetworkManager.swift
//  TestForGitFetchAPI
//
//  Created by Rushikesh Nikam on 21/01/19.
//  Copyright © 2019 chandan chavan. All rights reserved.
//

import Foundation
enum Result<String>{
    case success
    case failure(String)
}
class NetworkManager : NSObject {
    static let sharedInstance = NetworkManager()
    override init() {}
    func getGitUserDataFromServer(userName:String, completion:@escaping (_ response :NSDictionary?, _ error: Error?)->Void) -> Void {
        let config = URLSessionConfiguration.default
        var url = URL(string: "http://api.github.com/users/\(userName)")
        let session = URLSession(configuration: config)
        let request = URLRequest(url: url!)
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                
                completion(nil, error)
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, error)
                        return
                    }
                    do {
                        print(responseData)
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        print(jsonData)
                        if let data = jsonData as? NSDictionary {
                            completion(data,nil)
                        }
                    }catch {
                        print(error)
                        completion(nil, error)
                    }
                case .failure(_):
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        print("Respose code \(response.statusCode)")
        switch response.statusCode {
        case 200...299: return .success
        case 401...600: return .failure("Please check your network")
        default: return .failure("Please check your network")
        }
    }
}
extension URLRequest {
    
     func percentEscapeString(_ string: String) -> String {
        var characterSet = CharacterSet.alphanumerics
        characterSet.insert(charactersIn: "-._* ")
        
        return string
            .addingPercentEncoding(withAllowedCharacters: characterSet)!
            .replacingOccurrences(of: " ", with: "+")
            .replacingOccurrences(of: " ", with: "+", options: [], range: nil)
    }
    
    mutating func encodeParameters(parameters: [String : String]) {
        httpMethod = "GET"
        
        let parameterArray = parameters.map { (arg) -> String in
            let (key, value) = arg
            return "\(key)=\(self.percentEscapeString(value))"
        }
        
        httpBody = parameterArray.joined(separator: "&").data(using: String.Encoding.utf8)
    }
}
