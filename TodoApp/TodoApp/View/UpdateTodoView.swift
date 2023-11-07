//
//  UpdateTodoView.swift
//  TodoApp
//
//  Created by Kesh Gurung on 03/11/2023.
//

import SwiftUI

struct UpdateTodoView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State private var isAlertShown: Bool = false
    @EnvironmentObject var viewModel: TodosViewModel
    var updateTodoViewModel = UpdateTodoViewModel()
    var index: Int
    @State var updateTodo: Todo
    @State private var userId = ""
    
    var body: some View {
        
        VStack {
            TextField(updateTodo.todo, text: $updateTodo.todo)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField(String(updateTodo.userId), text: $userId)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Toggle("Is Completed", isOn: $updateTodo.completed)
            
            Button(action:  {
                Task {
                    do {
                        let updatedTodo = try await updateTodoViewModel.updateTodo(index: String(updateTodo.userId), todo: updateTodo.todo, completed: updateTodo.completed, userId: String(updateTodo.userId))
                        viewModel.todosList[index] = updatedTodo
                        isAlertShown = true // Show the success alert
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }) {
                Text("Update")
            }
            Spacer()
        }
        .onAppear {
            userId = String(updateTodo.userId)
        }
        .padding()
        .alert("Successfully updated the item", isPresented: $isAlertShown, actions: {
            Button("Okay") {
                self.presentationMode.wrappedValue.dismiss() // Dismiss the view
            }
        })
    }
}
