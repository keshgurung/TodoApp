//
//  AddTodoViewModel.swift
//  TodoApp
//
//  Created by Kesh Gurung on 06/11/2023.
//

import Foundation
import SwiftUI

protocol AddTodoViewModelType {
    func addTodo(todo: String, completed: Bool, userId: String) async throws -> Todo
}

class AddTodoViewModel: AddTodoViewModelType, JsonDecoder {
    
    private let serviceManager: RestApiNetworkable
    
    init(serviceManager: RestApiNetworkable = RestApiManager()) {
        self.serviceManager = serviceManager
    }
    
    func addTodo(todo: String, completed: Bool, userId: String) async throws -> Todo {
        do {
            let request = TodoPostRequest(path: Path.addTodo.stringValue(), todo: todo, completed: completed, userId: userId)
            let data = try await serviceManager.execute(request: request)
            let todo = try decode(data:data, to: Todo.self)
            return todo
        } catch {
            throw error
        }
    }
}
