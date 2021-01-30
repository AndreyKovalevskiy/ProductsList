//
//  StoreManager.swift
//  ProductsList
//
//  Created by Andrey Kovalevskiy on 29.01.21.
//

import Foundation
import CoreData

protocol StoreManagerProtocol {
    func fetchStoredProducts(completion: ([Product]) -> Void)
    func save(products: [Product])
}

class StoreManager: StoreManagerProtocol {

    // MARK: - Properties

    let mainContext = CoreDataManager.shared.persistentContainer.viewContext
    let backGroundContext = CoreDataManager.shared.persistentContainer.newBackgroundContext()

    // MARK: - Methods

    func fetchStoredProducts(completion: ([Product]) -> Void) {

        var products = [Product]()

        let fetchRequest = NSFetchRequest<ProductEntity>(entityName: "ProductEntity")

        do {
            let result = try mainContext.fetch(fetchRequest)
            products = result.map { $0.convertToProduct() }
        } catch {
            print(error)
        }
        completion(products)
    }

    func save(products: [Product]) {

        products.forEach { (item) in
            if let productEntity = newsItemExists(id: item.id) {
                productEntity.fill(from: item)
            } else {
                let newProductEntity = ProductEntity(context: backGroundContext)
                newProductEntity.fill(from: item)
            }
        }

        do {
            if backGroundContext.hasChanges {
                try backGroundContext.save()
            }
        } catch {
            print(error)
        }
    }

    private func newsItemExists(id: String) -> ProductEntity? {

        let request = NSFetchRequest<ProductEntity>(entityName: "ProductEntity")
        request.predicate = NSPredicate(format: "id = %@", id)

        do {
            let entity = try backGroundContext.fetch(request)
            return entity.first
        } catch {
            print(error)
        }
        return nil
    }
}
