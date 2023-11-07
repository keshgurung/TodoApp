//
//  MockRestAPIManager.swift
//  TodoAppTests
//
//  Created by Kesh Gurung on 03/11/2023.
//

import Foundation
@testable import TodoApp

class MockRestAPIManager: RestApiNetworkable {
    
    var path: String = ""
    func execute(request: TodoApp.Requestable) async throws -> Data {
        do {
            let bundle = Bundle(for: MockRestAPIManager.self)
            guard !path.isEmpty, let resourcePath = bundle.url(forResource: path, withExtension: "json") else
            {
                throw RestApiCallError.apiError
            }
            let data = try Data(contentsOf: resourcePath)
            return data
        } catch {
            throw RestApiCallError.dataNotFound
        }
    }
}
