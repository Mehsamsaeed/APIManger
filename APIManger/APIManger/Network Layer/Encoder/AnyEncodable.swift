//
//  AnyEncodable.swift
//  RechargePaymentClip
//
//  Created by Mehsam Saeed on 17/04/2023.
//  Copyright © 2023 Etisalat. All rights reserved.
//

import Foundation
struct AnyEncodable: Encodable {
    private let encodable: Encodable

    init(_ encodable: Encodable) {
        self.encodable = encodable
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try encodable.encode(to: &container)
    }
}

private extension Encodable {
    //	var asAnyEncodable: AnyEncodable {
    //		AnyEncodable(self)
    //	}

    // We need this helper in order to encode AnyEncodable with a singleValueContainer,
    // this is needed for the encoder to apply the encoding strategies of the inner type (encodable).
    // More details about this in the following thread:
    // https://forums.swift.org/t/how-to-encode-objects-of-unknown-type/12253/10
    func encode(to container: inout SingleValueEncodingContainer) throws {
        try container.encode(self)
    }
}
