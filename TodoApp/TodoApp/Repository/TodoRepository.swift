//
//  TodoRepository.swift
//  TodoApp
//
//  Created by Kesh Gurung on 03/11/2023.
//

import Foundation

protocol TodoDataRepository {
    func getTodos(path: String) async throws -> [Todo]
    func deleteTodo(index: String) async throws
}

struct TodoRepository: JsonDecoder {
    private let serviceManager: RestApiNetworkable
    
    init(serviceManager: RestApiNetworkable = RestApiManager()) {
        self.serviceManager = serviceManager
    }
}

extension TodoRepository: TodoDataRepository {
    func getTodos(path: String) async throws -> [Todo] {
        do {
            let request = TodoRequest(path: path)
            let data = try await serviceManager.execute(request: request)
            let todos = try decode(data:data, to: TodoData.self)
            return todos.todos
        } catch {
            throw error
        }
    }
    
    func deleteTodo(index: String) async throws  {
        do {
            let request = TodoDeleteRequest(path: Path.deleteTodo(id: index).stringValue())
            let data = try await serviceManager.execute(request: request)
            var _ = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            throw error
        }
    }
}

