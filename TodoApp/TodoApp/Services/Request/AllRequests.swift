//
//  AllRequests.swift
//  TodoApp
//
//  Created by Kesh Gurung on 03/11/2023.
//

import Foundation

struct TodoRequest: Requestable {
    var path: String
    var type: String = "GET"
}

struct TodoPostRequest: Requestable {
    var path: String
    var params: [String: Any]
    var type: String = "POST"
    
    init(path: String, todo: String, completed: Bool, userId: String) {
        self.path = path
        self.params = [
            "todo": todo,
            "completed": completed,
            "userId": Int(userId) ?? 0
        ]
    }
}

struct TodoDeleteRequest: Requestable {
    var path: String
    var type: String = "DELETE"
}

struct TodoUpdateRequest: Requestable {
    var path: String
    var params: [String: Any]
    var type: String = "PUT"
    
    init(path: String, todo: String, completed: Bool, userId: String) {
        self.path = path
        self.params = [
            "todo": todo,
            "completed": completed,
            "userId": Int(userId) ?? 0
        ]
    }
}
