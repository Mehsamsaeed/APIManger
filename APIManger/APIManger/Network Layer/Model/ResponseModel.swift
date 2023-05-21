//
//  ResponseModel.swift
//  APIManger
//
//  Created by Mehsam Saeed on 12/05/2023.
//

import Foundation


class ResponseModel: Codable {
    var id: Int
    var title, description: String
    var price: Int
    var discountPercentage, rating: Double
    var stock: Int
    var brand, category: String
    var thumbnail: String
    var images: [String]

    init(id: Int, title: String, description: String, price: Int, discountPercentage: Double, rating: Double, stock: Int, brand: String, category: String, thumbnail: String, images: [String]) {
        self.id = id
        self.title = title
        self.description = description
        self.price = price
        self.discountPercentage = discountPercentage
        self.rating = rating
        self.stock = stock
        self.brand = brand
        self.category = category
        self.thumbnail = thumbnail
        self.images = images
    }
}
