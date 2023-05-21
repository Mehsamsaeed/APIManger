//
//  Response.swift
//  RechargePaymentClip
//
//  Created by Mehsam Saeed on 17/04/2023.
//  Copyright © 2023 Etisalat. All rights reserved.
//

import Foundation
public struct Response<T> {
    public let value: T
    public let response: URLResponse
}
