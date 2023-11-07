//
//  UpdateTodoViewModel.swift
//  TodoApp
//
//  Created by Kesh Gurung on 03/11/2023.
//

import Foundation
import SwiftUI

protocol UpdateTodoViewModelType {
    func updateTodo(index: String, todo: String, completed: Bool, userId: String) async throws -> Todo
}

class UpdateTodoViewModel: UpdateTodoViewModelType, JsonDecoder {
    
    private let serviceManager: RestApiNetworkable
    
    init(serviceManager: RestApiNetworkable = RestApiManager()) {
        self.serviceManager = serviceManager
    }
    
    func updateTodo(index: String,todo: String, completed: Bool, userId: String) async throws -> Todo {
        do {
            let request = TodoUpdateRequest(path: Path.updateTodo(id:index).stringValue(), todo: todo, completed: completed, userId: userId)
            let data = try await serviceManager.execute(request: request)
            let todo = try decode(data:data, to: Todo.self)
            return todo
        } catch {
            throw error
        }
    }
}
