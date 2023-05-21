//
//  URLSessionClient.swift
//  RechargePaymentClip
//
//  Created by Mehsam Saeed on 17/04/2023.
//  Copyright © 2023 Etisalat. All rights reserved.
//

import Foundation

public class HTTPClient {
    private var sessionHeaders = [String: String]()
    private var session: URLSession
    public let baseURL: URL

    public init(config: URLSessionConfiguration, baseURL: URL) {
        session = URLSession(configuration: config)
        self.baseURL = baseURL
    }

    /// set sessionHeader which are
    public func set(sessionHeaders: [String: String]) {
        let configuration = session.configuration
        configuration.httpAdditionalHeaders = sessionHeaders
        session = URLSession(configuration: configuration)
    }

    func getRequest(from endpoint: EndPoint, requestEncoder: URLRequestEncoder) throws -> URLRequest {
        try requestEncoder.request(from: endpoint.baseURL ?? baseURL, endPoint: endpoint)
    }
}

// MARK: Callback
public extension HTTPClient {
    /// execute a url request and return result on given queue using combine framework
    func run<T: Decodable>(endpoint: EndPoint, requestEncoder: URLRequestEncoder, decoder: JSONDecoder, completion: @escaping (Result<Response<T>, Error>) -> Void) {
        return runDataTask(endpoint: endpoint, requestEncoder: requestEncoder, responseMap: { data, response in
            try ResponseParser().parse(data: data, response: response, decoder: decoder)
        }, completion: completion)
    }

    /// execute a url request and return raw data  on given queue using combine framework
    func rawData(endpoint: EndPoint, requestEncoder: URLRequestEncoder, completion: @escaping (Result<Response<Data>, Error>) -> Void) {
        return runDataTask(endpoint: endpoint, requestEncoder: requestEncoder, responseMap: { data, response in
            try ResponseParser().wrap(data: data, response: response)
        }, completion: completion)
    }

    private func runDataTask<T>(endpoint: EndPoint, requestEncoder: URLRequestEncoder, responseMap: @escaping (Data, URLResponse) throws -> Response<T>, completion: @escaping (Result<Response<T>, Error>) -> Void) {
        if !Reachability.isConnectedToNetwork() {
            completion(.failure(CustomError.noInternet))
        }

        do {
            let request = try getRequest(from: endpoint, requestEncoder: requestEncoder)
            let task = session.dataTask(with: request) { data, response, error in

                do {
                    if let data = data, let response = response {
                        self.printResponse(request: request, data: data, response: response, error: error)
                        let response = try responseMap(data, response)
                        let decoder = JSONDecoder()
                        completion(.success(response))
                    } else {
                        DispatchQueue.main.async {
                            completion(.failure(error ?? CustomError.unknown))
                        }
                    }

                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
            task.resume()

        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }

    internal func printResponse(request: URLRequest, data: Data, response _: URLResponse, error _: Error?) {
        let dataJSON = data.prettyJSONString() ?? ""

        print("\n✅✅✅✅✅========================== REQUEST START ==========================✅✅✅✅✅\n")

        if let url = request.url?.absoluteString {
            print("URL: \n\(url)\n")
        }

        if let method = request.httpMethod {
            print("METHOD: \n\(method)\n")
        }

        if let headers = request.allHTTPHeaderFields {
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: headers,
                options: []
            ) {
                print("HEADERS: \n\(theJSONData.prettyJSONString()!)")
            }
        }

        if let body = request.httpBody?.prettyJSONString() {
            print("REQUEST: \n\(body)\n")
        }

        print("RESPONSE: \n\(dataJSON)\n")

        print("✅✅✅✅✅========================== REQUEST END ==========================✅✅✅✅✅")
        print("\n")
    }
}

extension Data {
    func prettyJSONString() -> String? {
        if let json = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers) {
            if let prettyPrintedData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                return String(bytes: prettyPrintedData, encoding: String.Encoding.utf8) ?? nil
            }
        }
        return nil
    }
}


