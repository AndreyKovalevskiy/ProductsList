//
//  DataManager.swift
//  ProductsList
//
//  Created by Andrey Kovalevskiy on 29.01.21.
//

import Foundation

protocol DataManagerProtocol {
    func fetchProducts(completion: @escaping ([Product]) -> Void)
    func loadProducts(completion: @escaping ([Product]) -> Void)
    func getImageData(fileName: String, imageUrl: String, completion: @escaping (Data?) -> Void)
}

class DataManager: DataManagerProtocol {

    // MARK: - Properties

    private let storeManager: StoreManagerProtocol
    private let networkManager: NetworkManagerProtocol
    private let imageManager: ImageManager

    // MARK: - Initializers

    init(storeManager: StoreManagerProtocol = StoreManager(),
         networkManager: NetworkManagerProtocol = NetworkManager(),
         imageManager: ImageManager = ImageManager()) {
        self.storeManager = storeManager
        self.networkManager = networkManager
        self.imageManager = imageManager
    }

    // MARK: - Methods

    func fetchProducts(completion: @escaping ([Product]) -> Void) {
        storeManager.fetchStoredProducts { [weak self] (items) in
            guard let self = self else { return }
            if items.isEmpty {
                self.loadProducts(completion: completion)
            } else {
                completion(items)
            }
        }
    }

    func loadProducts(completion: @escaping ([Product]) -> Void) {

        self.networkManager.loadProducts { (items) in
            self.storeManager.save(products: items)
            DispatchQueue.global().async {
                self.imageManager.saveImages(from: items)
            }
            self.fetchProducts(completion: completion)
        }
    }

    func getImageData(fileName: String, imageUrl: String, completion: @escaping (Data?) -> Void) {
        DispatchQueue.global().async {
            if let data = self.imageManager.loadImageDataFromDiskWith(fileName: fileName) {
                completion(data)
            } else {
                if let url = URL(string: imageUrl),
                   let data = try? Data(contentsOf: url) {
                    completion(data)
                }
            }
            completion(nil)
        }
    }
}
