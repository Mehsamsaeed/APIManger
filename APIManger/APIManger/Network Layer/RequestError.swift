//
//  RequestError.swift
//  RechargePaymentClip
//
//  Created by Mehsam Saeed on 17/04/2023.
//  Copyright © 2023 Etisalat. All rights reserved.
//

import Foundation

public enum CustomError: Error {
    case unknown
    case badResponse(Int, Data, HTTPURLResponse)
    case invalidBody(String)
    case invalideQueryParam(String)
    case errorMessage(String)
    case noInternet
}

