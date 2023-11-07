//
//  TodosListView.swift
//  TodoApp
//
//  Created by Kesh Gurung on 03/11/2023.
//

import SwiftUI

struct TodosListView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State private var isAlertShown: Bool = false
    @EnvironmentObject var viewModel: TodosViewModel
    @State private var swipedItemIndex: Int?
    
    var body: some View {
        NavigationView {
            VStack {
                switch viewModel.viewState {
                case .loading:
                    ProgressView()
                case .loaded:
                    showTodosListView()
                case .error:
                    showErrorView()
                case .emptyView:
                    EmptyView()
                }
            }
            .navigationTitle(Text(LocalizedStringKey("TodosList")))
            .navigationBarItems(
                trailing:
                    NavigationLink(destination: AddTodoView()) {
                        Image(systemName: "plus")
                    }
            )
        }
        .task {
            if viewModel.todosList.isEmpty {
                await viewModel.getTodosList(path: Path.todosPath.stringValue())
            }
        }
    }
    
    @ViewBuilder
    func showTodosListView() -> some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(Array(viewModel.todosList.enumerated()), id: \.element.id) { index, list in
                    NavigationLink(destination: UpdateTodoView(index: index, updateTodo: list)) {
                        HStack {
                            Text("\(index + 1).")
                            Text(list.todo)
                                .bold()
                                .foregroundColor(.black)
                                .frame(height: 60)
                            
                            Spacer()
                            
                            if swipedItemIndex == index {
                                Button(action: {
                                    Task {
                                        do {
                                            try await viewModel.deleteTodoList(index: String(swipedItemIndex ?? 0))
                                            isAlertShown = true
                                        } catch {
                                            print("An error occurred: \(error)")
                                        }
                                    }
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                                .padding(.trailing, 0)
                                .transition(.move(edge: .trailing))
                                .alert("Successfully deleted the item", isPresented: $isAlertShown, actions: {
                                    Button("Okay") {
                                        viewModel.todosList.remove(at: swipedItemIndex ?? 0)
                                        swipedItemIndex = nil
                                    }
                                })
                            }
                        }
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    if value.translation.width < -50 {
                                        withAnimation {
                                            swipedItemIndex = index
                                        }
                                    } else if value.translation.width > 50 {
                                        withAnimation {
                                            swipedItemIndex = nil
                                        }
                                    }
                                }
                        )
                    }
                    
                    Rectangle()
                        .frame(height: 0.5)
                        .foregroundColor(.gray)
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                }
            }
            .padding()
        }
    }
    
    
    @ViewBuilder
    func showErrorView() -> some View {
        Text("Sorry, Error Occurred")
            .bold()
            .frame(height: 100)
    }
}

struct TodosListView_Previews: PreviewProvider {
    static var previews: some View {
        TodosListView()
            .environmentObject(TodosViewModel(repository: TodoRepository(serviceManager: RestApiManager())))
    }
}
