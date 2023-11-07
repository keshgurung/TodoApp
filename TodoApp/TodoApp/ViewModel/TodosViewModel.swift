//
//  TodosViewModel.swift
//  TodoApp
//
//  Created by Kesh Gurung on 03/11/2023.
//

import Foundation
import SwiftUI

protocol TodosViewModelType: ObservableObject {
    func getTodosList(path: String) async
}

@MainActor
final class TodosViewModel {
    
    @Published private(set) var viewState: ViewStates = .loaded
    @Published var todosList: [Todo] = []
    private let repository: TodoDataRepository
    
    init(repository: TodoDataRepository) {
        self.repository = repository
    }
}

extension TodosViewModel: TodosViewModelType {
    func getTodosList(path: String) async {
        viewState = .loading
        do {
            let todosData = try await repository.getTodos(path: path)
            todosList = todosData
            
            if todosList.isEmpty {
                viewState = .emptyView
            } else {
                viewState = .loaded
            }
        } catch {
            self.viewState = .error
        }
    }
    
    func deleteTodoList(index: String) async throws {
        do {
            let _ = try await repository.deleteTodo(index: index)
        } catch {
            throw error
        }
    }
}


