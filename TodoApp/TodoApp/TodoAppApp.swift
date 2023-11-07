//
//  TodoAppApp.swift
//  TodoApp
//
//  Created by Kesh Gurung on 03/11/2023.
//

import SwiftUI

@main
struct TodoAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TodosListView()
                .environmentObject(TodosViewModel(repository: TodoRepository(serviceManager: RestApiManager())))
        }
    }
}
