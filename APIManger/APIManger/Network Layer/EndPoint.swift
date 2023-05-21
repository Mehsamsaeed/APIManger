//
//  EndPoint.swift
//  RechargePaymentClip
//
//  Created by Mehsam Saeed on 17/04/2023.
//  Copyright © 2023 Etisalat. All rights reserved.
//

import Foundation
public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public protocol HTTPEncoding {
    var headers: [String: String] { get }
}

public enum ContentType: String {
    case json = "application/json"
    case form = "application/x-www-form-urlencoded"
}

public struct EncodingType: HTTPEncoding {
    public let headers: [String: String]

    public init(headers: [String: String]) {
        self.headers = headers
    }

    public static var json: HTTPEncoding { EncodingType(headers: ["Content-Type": "application/json"]) }
    public static var multipart: HTTPEncoding { EncodingType(headers: ["Content-Type": "multipart/form-data"]) }
    public static var form: HTTPEncoding { EncodingType(headers: ["Content-Type": "application/x-www-form-urlencoded"]) }
}

public struct EndPoint {
    var method: HTTPMethod
    /// this baseURL overrides baseURL  of Client
    let baseURL: URL?
    let path: String
    let queryItems: Encodable
    let body: Encodable?
    let headers: [String: String]

    private init(method: HTTPMethod, baseURL: URL?, path: String, queryItems: Encodable, body: Encodable?, headers: [String: String]) {
        self.method = method
        self.baseURL = baseURL
        self.path = path
        self.queryItems = queryItems
        self.body = body
        self.headers = headers
    }

    public init(method: HTTPMethod = .get, baseURL: URL? = nil, path: String, contentType: ContentType = .json, queryItems: Encodable = [String: String](), body: Encodable? = nil, headers: [String: String] = [:]) {
        var endPointHeaders = headers
        endPointHeaders["Content-Type"] = contentType.rawValue

        self.init(method: method, baseURL: baseURL, path: path, queryItems: queryItems, body: body, headers: endPointHeaders)
    }

    public init(method: HTTPMethod, baseURL: URL? = nil, path: String, queryItems: Encodable = [String: String](), multipartForm: MultipartForm?, headers: [String: String] = [:]) {
        var endPointHeaders = headers
        endPointHeaders["Content-Type"] = multipartForm?.contentType

        self.init(method: method, baseURL: baseURL, path: path, queryItems: queryItems, body: multipartForm?.bodyData, headers: endPointHeaders)
    }
}
