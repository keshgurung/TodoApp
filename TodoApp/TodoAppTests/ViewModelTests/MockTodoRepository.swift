//
//  MockTodoRepository.swift
//  TodoAppTests
//
//  Created by Kesh Gurung on 03/11/2023.
//

import Foundation
@testable import TodoApp

class MockTodoRepository: TodoDataRepository {
    
    private var todos: [Todo] = []
    private var error: RestApiCallError?
    
    func enqueuResponse(todos: [Todo]) {
        self.todos = todos
    }
    func enqueuError(error: RestApiCallError) {
        self.error = error
    }
    
    func getTodos(path: String) async throws -> [TodoApp.Todo] {
        if error != nil {
            throw error!
        }
        return todos
    }
    
    func deleteTodo(index: String) async throws {
        if error != nil {
            throw error!
        }
    }
    
}
