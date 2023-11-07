//
//  AddTodoView.swift
//  TodoApp
//
//  Created by Kesh Gurung on 03/11/2023.
//

import SwiftUI

struct AddTodoView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State private var isAlertShown: Bool = false
    @EnvironmentObject var viewModel: TodosViewModel
    @State private var todo = ""
    @State private var completed = false
    @State private var userId = ""
    private var addTodoViewModel = AddTodoViewModel()
    
    var body: some View {
        VStack {
            TextField("Enter Todo item", text: $todo)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Enter user ID", text: $userId)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Toggle("Is Completed", isOn: $completed)
            
            Button(action:  {
                Task {
                    do {
                        let todo = try await addTodoViewModel.addTodo(todo: todo, completed: completed, userId: userId)
                        viewModel.todosList.insert(contentsOf: [todo], at: 0)
                        isAlertShown = true // Show the success alert
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }) {
                Text("Submit")
            }
            Spacer()
        }
        .padding()
        .alert("Successfully added the item", isPresented: $isAlertShown, actions: {
            Button("Okay") {
                self.presentationMode.wrappedValue.dismiss() // Dismiss the view
            }
        })
    }
}

struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        AddTodoView()
            .environmentObject(TodosViewModel(repository: TodoRepository(serviceManager: RestApiManager())))
    }
}
