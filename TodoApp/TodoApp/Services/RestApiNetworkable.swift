//
//  RestApiNetworkable.swift
//  TodoApp
//
//  Created by Kesh Gurung on 03/11/2023.
//

import Foundation

protocol RestApiNetworkable {
    func execute(request: Requestable) async throws -> Data
}
