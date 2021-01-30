//
//  ProductsViewModel.swift
//  ProductsList
//
//  Created by Andrey Kovalevskiy on 29.01.21.
//

import Foundation

class ProductListViewModel {

    // MARK: - Properties

    private var productCellViewModels = [ProductCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    private(set) var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatusClosure?()
        }
    }
    private let dataManager: DataManagerProtocol
    var reloadTableViewClosure: (() -> Void)?
    var updateLoadingStatusClosure: (() -> Void)?
    var numberOfCells: Int {
        return productCellViewModels.count
    }

    // MARK: - Initializers

    init(dataManager: DataManagerProtocol = DataManager()) {
        self.dataManager = dataManager
    }

    // MARK: - Methods

    func fetchProducts() {
        isLoading = true
        dataManager.fetchProducts { (products) in
            let productCellViewModels = products.map { self.createProductCellViewModel(with: $0) }
            self.productCellViewModels = productCellViewModels
            self.isLoading = false
        }
    }

    func loadProducts() {
        dataManager.loadProducts { (products) in
            let productCellViewModels = products.map { self.createProductCellViewModel(with: $0) }
            self.productCellViewModels = productCellViewModels
        }
    }

    private func createProductCellViewModel(with product: Product) -> ProductCellViewModel {
        return ProductCellViewModel(id: product.id,
                                    name: product.name,
                                    price: String(product.price),
                                    imageUrl: product.imageUrl)
    }

    func getProductCellViewModel(index: Int) -> ProductCellViewModel {
        return productCellViewModels[index]
    }

    func imageDataForCell(index: Int, completion: @escaping (Data?) -> Void) {
        let cellViewModel = productCellViewModels[index]
        dataManager.getImageData(fileName: cellViewModel.id, imageUrl: cellViewModel.imageUrl, completion: completion)
    }
}
