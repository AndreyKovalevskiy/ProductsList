//
//  ProductEntity+CoreDataProperties.swift
//  ProductsList
//
//  Created by Andrey Kovalevskiy on 29.01.21.
//
//

import Foundation
import CoreData

extension ProductEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductEntity> {
        return NSFetchRequest<ProductEntity>(entityName: "ProductEntity")
    }

    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var price: Double
    @NSManaged public var imageUrl: String

}

extension ProductEntity: Identifiable {
}
