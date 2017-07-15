//
//  Todo.swift
//  CM_Networking
//
//  Created by Artem Lyksa on 7/15/17.
//  Copyright © 2017 Artem Lyksa. All rights reserved.
//

import Foundation

class Todo {
    
    var title: String
    var id: Int?
    var userId: Int
    var isCompleted: Bool
    
    
    required init? (title: String, id: Int?, userId: Int, isCompleted: Bool) {
        self.title = title
        self.id = id
        self.userId = userId
        self.isCompleted = isCompleted
    }
    
    func description() -> String {
        return "ID: \(self.id), " +
        "User ID: \(self.userId), " +
        "Title: \(self.title)\n " +
        "IsCompleted: \(self.isCompleted)\n"
        
    }
    
}
