//
//  GitUserDataModel.swift
//  TestForGitFetchAPI
//
//  Created by Rushikesh Nikam on 21/01/19.
//  Copyright © 2019 chandan chavan. All rights reserved.
//

import Foundation
import UIKit

class GitUserDataModel: NSObject {
    var login :String
    var followers_url :String
    var location :String
    var public_repos :String
    var public_gists :String
    var followers :String
    var avatar_url :String
    var image : UIImage?
    var updated_at: String?
    var name: String?
    
    
    override init() {
        self.login = ""
        self.followers_url = ""
        self.location = ""
        self.public_repos = ""
        self.public_gists = ""
        self.followers = ""
        self.avatar_url = ""
        self.name = ""
        self.updated_at = ""
    }
    
    convenience init(jsonObject : Any?) {
        self.init()
        if let data = jsonObject as? [String : Any] {
            self.login = data["login"] as? String ?? ""
            self.followers_url = data["followers_url"] as? String ?? ""
            self.location = data["location"] as? String ?? ""
            self.public_repos = "\(data["public_repos"] ?? "")"
            self.public_gists = "\(data["public_gists"] ?? "")"
            self.followers = "\(data["followers"] ?? "")"
            self.avatar_url = data["avatar_url"] as? String ?? ""
            self.name = data["name"] as? String ?? ""
            self.updated_at = self.convertUpdatedAtToLocal(strDate: data["updated_at"] as? String ?? "")
        }
    }
    
    func convertUpdatedAtToLocal(strDate: String)->String {
        let formatter: DateFormatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = formatter.date(from: strDate)
        formatter.dateFormat = "dd-MM-yyyy"
        var stringDate: String = String()
        if(date != nil) {
            stringDate = formatter.string(from: date!)
        }
        return stringDate
    }
}
