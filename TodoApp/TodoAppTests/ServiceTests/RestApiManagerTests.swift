//
//  RestApiManagerTests.swift
//  TodoAppTests
//
//  Created by Kesh Gurung on 03/11/2023.
//

import XCTest
@testable import TodoApp

final class RestApiManagerTests: XCTestCase {
    var mockRestAPIManager: MockRestApiNetworking!
    var serviceManager: RestApiManager!
    
    @MainActor override func setUp() {
        mockRestAPIManager = MockRestApiNetworking()
        serviceManager = RestApiManager(urlSession: mockRestAPIManager)
    }
    
    override func tearDown() {
        mockRestAPIManager = nil
        serviceManager = nil
    }
    
    //when API is successful, get function will return expected data,
    func testGetTodoListWhenResponseIs_200() async {
        // reading local json file data
        let data = "response".data(using: .utf8)
        mockRestAPIManager.mockData = data
        mockRestAPIManager.mockResponse = HTTPURLResponse(url:URL(string: "test")!, statusCode: 200, httpVersion:nil, headerFields:nil)
        let actualData = try! await serviceManager.execute(request: TodoRequest(path:"test"))
        XCTAssertEqual(actualData, data)
    }
    
    //when API is fails with 404 response code
    func testGetTodoListWhenResponseIs404() async {
        // reading local json file data
        let data = "response".data(using: .utf8)
        mockRestAPIManager.mockData = data
        mockRestAPIManager.mockResponse = HTTPURLResponse(url:URL(string: "test")!, statusCode: 404, httpVersion:nil, headerFields:nil)
        do {
            _ = try await serviceManager.execute(request: TodoRequest(path:"test"))
        } catch {
            XCTAssertEqual(error as! RestApiCallError, RestApiCallError.invalidResponse)
        }
    }
    
    //when API is fails with response code other than 200 to 299
    
    func testGetTodoListWhenResponseIs502() async {
        // reading local json file data
        let data = "response".data(using: .utf8)
        mockRestAPIManager.mockData = data
        mockRestAPIManager.mockResponse = HTTPURLResponse(url:URL(string: "test")!, statusCode: 502, httpVersion:nil, headerFields:nil)
        do {
            _ = try await serviceManager.execute(request: TodoRequest(path:"test"))
        } catch {
            XCTAssertEqual(error as! RestApiCallError, RestApiCallError.invalidResponse)
        }
    }
    
    //when API is fails with request invalid
    
    func testGetTodoListWhenRequestIsNotValid() async {
        do {
            _ = try await serviceManager.execute(request: TodoRequest(path:""))
        } catch {
            XCTAssertEqual(error as! RestApiCallError, RestApiCallError.invalidRequest)
        }
    }
}
