//
//  RequestModel.swift
//  RechargePaymentClip
//
//  Created by Mehsam Saeed on 17/04/2023.
//  Copyright © 2023 Etisalat. All rights reserved.
//

import Foundation
public final class RequestModel {
    private let client: HTTPClient
    private let requestEncoder = DefaultURLRequestEncoder(jsonEncoder: JSONEncoder())
    private let decoder = JSONDecoder()
    public init(client: HTTPClient) {
        self.client = client
    }

    public func run<T: Decodable>(endpoint: EndPoint, completion: @escaping (Result<T, Error>) -> Void) {
        return client.run(endpoint: endpoint, requestEncoder: requestEncoder, decoder: decoder) { result in
            completion(result.map { $0.value })
        }
    }

    public func runDataTask(endpoint: EndPoint, requestEncoder: URLRequestEncoder, completion: @escaping (Result<Response<Data>, Error>) -> Void) {
        return client.rawData(endpoint: endpoint, requestEncoder: requestEncoder) { result in
            completion(result)
        }
    }

    public func set(sessionHeaders: [String: String]) {
        client.set(sessionHeaders: sessionHeaders)
    }
}

class MyModel: Encodable{
    
}
