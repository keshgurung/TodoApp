//
//  TodosViewModelTest.swift
//  TodoAppTests
//
//  Created by Kesh Gurung on 03/11/2023.
//

import XCTest
@testable import TodoApp

final class TodosViewModelTest: XCTestCase {
    
    var mockTodoRepository: MockTodoRepository!
    var todosViewModel: TodosViewModel!
    
    @MainActor override func setUp() {
        mockTodoRepository = MockTodoRepository()
        todosViewModel = TodosViewModel(repository: mockTodoRepository)
    }
    
    override func tearDown() {
        mockTodoRepository = nil
        todosViewModel = nil
    }
    
    //when user list is not empty
    func testGetTodoWhenListIsNotEmpty() async {
        
        // Given
        mockTodoRepository.enqueuResponse(todos: [Todo.mockTodo()])
        
        // When
        await todosViewModel.getTodosList(path: "TodoAPIResponseData")
        
        // Then
        let empList = await todosViewModel.todosList
        XCTAssertEqual(empList.count, 1)
        XCTAssertEqual(empList.first?.userId, 22)
        
        let viewState = await todosViewModel.viewState
        XCTAssertEqual(viewState, .loaded)
    }
    
    
    //when user list is empty
    func testGetTodoWhenListIsEmpty() async {
        
        // Given
        mockTodoRepository.enqueuResponse(todos: [])
        
        // When
        await todosViewModel.getTodosList(path: "TodoAPIResponseData")
        
        // Then
        
        let empList = await todosViewModel.todosList
        XCTAssertEqual(empList.count, 0)
        let viewState = await todosViewModel.viewState
        XCTAssertEqual(viewState, .emptyView)
    }
    
    
    //when repository throws error for getUsers
    func testGetTodoWhenRepositoryThrowsError() async {
        
        // Given
        mockTodoRepository.enqueuError(error: RestApiCallError.apiError)
        
        // When
        await todosViewModel.getTodosList(path: "TodoAPIResponseData")
        
        // Then
        let empList = await todosViewModel.todosList
        XCTAssertEqual(empList.count, 0)
        let viewState = await todosViewModel.viewState
        XCTAssertEqual(viewState, .error)
    }
}



