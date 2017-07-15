//
//  Todo+Networking.swift
//  CM_Networking
//
//  Created by Artem Lyksa on 7/15/17.
//  Copyright © 2017 Artem Lyksa. All rights reserved.
//

import Foundation
import Alamofire

extension Todo {
    enum BackendError: Error {
        case objectSerialization(reason: String)
    }
    
    
    convenience init? (json: [String: Any]) {
        guard
            let title = json["title"] as? String,
            let userId = json["userId"] as? Int,
            let isCompleted = json["completed"] as? Bool
            else {
                return nil
        }
        let idValue = json["id"] as? Int
        self.init(title: title, id: idValue, userId: userId, isCompleted: isCompleted)
        
    }
    
    class func todoByID(id: Int, completionHandler: @escaping (Result<Todo>) -> Void) {        
        Alamofire.request(TodoRouter.get(id))
            .responseJSON { response in
                let result = Todo.todoFromResponse(response: response)
                completionHandler(result)
        }
    }
    
    func save(completionHandler: @escaping (Result<Todo>) -> Void) {
        let json = self.toJSON()
        Alamofire.request(TodoRouter.create(json))
            .responseJSON { response in
                let result = Todo.todoFromResponse(response: response)
                completionHandler(result)
        }
    }
    
    func toJSON() -> [String: Any] {
        var json = [String: Any]()
        json["title"] = title
        
        if let id = id {
            json["id"] = id
        }
        json["userId"] = userId
        json["completed"] = isCompleted
        
        return json
    }
    
    private class func todoFromResponse(response: DataResponse<Any>) -> Result<Todo> {
        guard response.result.error == nil else {
            print(response.result.error!)
            let failure = Result<Todo>.failure(response.result.error!)
            return failure
        }
        
        //make sure we got a JSON dictionary
        guard let json = response.result.value as? [String: Any] else {
            print("didn;t get todo object as JSON from API")
            return .failure(BackendError.objectSerialization(reason: "Did not get JSON dictionary in response"))
            
        }
        
        guard let todo = Todo(json: json) else {
            return .failure(BackendError.objectSerialization(reason: "Could no create Todo object from JSON"))
        }
        let success = Result<Todo>.success(todo)
        return success
    }
}






