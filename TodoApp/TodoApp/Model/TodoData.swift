//
//  TodoData.swift
//  TodoApp
//
//  Created by Kesh Gurung on 03/11/2023.
//

import Foundation

struct TodoData: Codable {
    let todos: [Todo]
}

struct Todo: Codable, Identifiable {
    var id, userId: Int
    var todo: String
    var completed: Bool
}

typealias TodoDeleted = [String]

extension Todo {
    static func mockTodo() -> Todo {
        return Todo(id: 1, userId: 22, todo: "Play music", completed: false)
    }
}
