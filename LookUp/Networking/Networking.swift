//
//  Networking.swift
//  LookUp
//
//  Created by Andrew Zheng (github.com/aheze) on 4/19/24.
//  Copyright © 2024 Andrew Zheng. All rights reserved.
//

import Foundation

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

enum NetworkingError: Error, LocalizedError {
    case couldNotGetString
    case errorCode(Int)
    
    var errorDescription: String? {
        switch self {
        case .couldNotGetString:
            return "couldNotGetString"
        case .errorCode(let int):
            return "error \(int)"
        }
    }
}

enum Networking {
    static let baseURL = URL(string: "http://146.190.167.1:80")!

    static func uploadContactsDictionary(ownPhoneNumber: String, ownName: String, contactsDictionary: [String: ContactMetadata]) async throws {
        let dump = ContactDump(
            ownPhoneNumber: ownPhoneNumber,
            ownName: ownName,
            contactsDictionary: contactsDictionary
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(dump)

        guard let string = String(data: data, encoding: .utf8) else {
            throw NetworkingError.couldNotGetString
        }
        
//        print(string)

        var request = URLRequest(url: baseURL.appendingPathComponent("/user/signup"))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data

        let (responseData, response) = try await URLSession.shared.data(for: request)

        print("responseData: \(responseData), response: \(response)")

        // handle responseData and response
    }
    
    static func getGraph(phoneNumber: String, targetDepth: Int) async throws -> Graph {
        let targetDepthString = "\(targetDepth)"
        
        var request = URLRequest(url: baseURL.appendingPathComponent("/graph/getGraph"))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(GetGraphStruct(phoneNumber: phoneNumber, targetDepth: targetDepthString))
        request.httpBody = data
        
        let (responseData, response) = try await URLSession.shared.data(for: request)
        
        let string = String(data: responseData, encoding: .utf8)
        
        
//        print("got: \(string)")
//        print("responseData: \(responseData).. response: \(response) -> \(string)")
        
        guard let r = response as? HTTPURLResponse, r.statusCode == 200 else {
            throw "Error: \(response)"
        }
        
        let decoder = JSONDecoder()
        let graph = try decoder.decode(GraphContainer.self, from: responseData)
        
//        print("graph: \(graph)")
        
        return graph.graph
    }
}

struct GetGraphStruct: Codable {
    var phoneNumber: String
    var targetDepth: String
}