//
//  RestApiEndPoints.swift
//  TodoApp
//
//  Created by Kesh Gurung on 03/11/2023.
//

import Foundation

enum EndPoint: String {
    case baseUrl = "https://dummyjson.com/"
}

enum Path {
    case todosPath
    case addTodo
    case deleteTodo(id: String)
    case updateTodo(id: String)
    
    func stringValue() -> String {
        switch self {
        case .todosPath:
            return "todos"
        case .addTodo:
            return "todos/add"
        case .deleteTodo(let id):
            return "todos/\(id)"
        case .updateTodo(let id):
            return "todos/\(id)"
        }
    }
}
