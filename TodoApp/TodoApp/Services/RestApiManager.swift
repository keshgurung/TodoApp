//
//  RestApiManager.swift
//  TodoApp
//
//  Created by Kesh Gurung on 03/11/2023.
//

import Foundation

struct RestApiManager {
    private let urlSession: RestApiNetworking
    init(urlSession: RestApiNetworking = URLSession.shared) {
        self.urlSession = urlSession
    }
}

extension RestApiManager: RestApiNetworkable {
    func execute(request: Requestable) async throws -> Data {
        guard let urlRequest = request.createUrlRequest() else {
            throw RestApiCallError.invalidRequest
        }
        do {
            let (data, response) = try await urlSession.data(for: urlRequest, delegate: nil)
            if  response.isValidResponse() {
                return data
            } else {
                throw RestApiCallError.invalidResponse
            }
        } catch {
            throw error
        }
    }
}

extension URLResponse {
    func isValidResponse()-> Bool {
        guard let response = self as? HTTPURLResponse else {
            return false
        }
        switch response.statusCode {
        case 200...299:
            return true
        default:
            return false
        }
    }
}
