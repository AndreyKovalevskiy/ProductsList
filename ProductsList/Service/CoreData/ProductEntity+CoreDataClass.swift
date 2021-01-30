//
//  ProductEntity+CoreDataClass.swift
//  ProductsList
//
//  Created by Andrey Kovalevskiy on 29.01.21.
//
//

import Foundation
import CoreData

@objc(ProductEntity)
public class ProductEntity: NSManagedObject {

    func convertToProduct() -> Product {
        return Product(id: self.id, name: self.name, price: self.price, imageUrl: self.imageUrl)
    }

    func fill(from item: Product) {
        id = item.id
        name = item.name
        imageUrl = item.imageUrl
        price = item.price
    }
}
