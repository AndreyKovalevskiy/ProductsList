//
//  Product.swift
//  ProductsList
//
//  Created by Andrey Kovalevskiy on 29.01.21.
//

import Foundation

struct Product: Decodable {

    // MARK: - Properties

    let id: String
    let name: String
    let price: Double
    let imageUrl: String

    enum CodingKeys: String, CodingKey {
        case id = "product_id"
        case name
        case price
        case imageUrl = "image"
    }
}
