//
//  APIManger.swift
//  RechargePaymentClip
//
//  Created by Mehsam Saeed on 18/04/2023.
//  Copyright © 2023 Etisalat. All rights reserved.
//

import Foundation
import UIKit

class APIManger {
    static let shared = APIManger()
    var client = HTTPClient(config: URLSessionConfiguration.default, baseURL: URL(string: "https://dummyjson.com/")!)

    private var requestModel: RequestModel!

    init() {
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        headers["custom_header"] = "pre_prod"
        headers["Accept"] = "application/json"
        headers["ADRUM"] = "isAjax:true"
        headers["ADRUM_1"] = "isMobile:true"
        client.set(sessionHeaders: headers)
        requestModel = RequestModel(client: client)
    }

    func runGetRequest<T: Decodable>(endPoint: EndPoint, completion: @escaping (Result<T, Error>) -> Void) {
       

        var endPoint_ = endPoint
        endPoint_.method = .get
        requestModel.run(endpoint: endPoint) { [weak self] result in
            completion(result.map { $0 })
        }
    }

    func runPostRequest<T: Decodable>(endPoint: EndPoint, completion: @escaping (Result<T, Error>) -> Void) {
      
        var endPoint_ = endPoint
        endPoint_.method = .post
        requestModel.run(endpoint: endPoint_) { [weak self] result in
            completion(result.map { $0 })
        }
    }

    func runDataTask(endPoint: EndPoint, completion: @escaping (Result<Data, Error>) -> Void) {
       
        requestModel.run(endpoint: endPoint) { [weak self] result in
            completion(result.map { $0 })
        }
    }


}
