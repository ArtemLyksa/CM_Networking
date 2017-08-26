//
//  Gist.swift
//  CM_Networking
//
//  Created by Artem Lyksa on 8/26/17.
//  Copyright © 2017 Artem Lyksa. All rights reserved.
//

import Foundation
import Alamofire

class Gist {
    
    var id: String?
    var description: String?
    var ownerLogin: String?
    var ownerAvatarURL: String?
    var url: String?
    
    required init() {
        
    }
    
    required init?(json: [String: Any]) {
        guard
            let idValue = json["id"] as? String,
            let description = json["description"]as? String,
            let url = json["url"] as? String
            else {
                return nil
        }
        self.id = idValue
        self.description = description
        self.url = url
        
        if let ownerJson = json["owner"] as? [String: Any] {
            self.ownerLogin = ownerJson["login"] as? String
            self.ownerAvatarURL = json["avatar_url"] as? String
        }
    }
}
