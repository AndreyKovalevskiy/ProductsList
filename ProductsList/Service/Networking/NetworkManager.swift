//
//  NetworkManager.swift
//  ProductsList
//
//  Created by Andrey Kovalevskiy on 29.01.21.
//

import Foundation

protocol NetworkManagerProtocol {
    func loadProducts(completion: @escaping ([Product]) -> Void)
}

struct NetworkManager: NetworkManagerProtocol {

    // MARK: - Properties

    private let basicURL = "https://s3-eu-west-1.amazonaws.com/developer-application-test/cart/list"

    // MARK: - Methods

    func loadProducts(completion: @escaping ([Product]) -> Void) {
        performRequest(url: basicURL, completion: completion)
    }

    // here can do it more universally: for example, using
    // the following completion: @escaping (Result <Data, NetworkError>),
    // thus getting and returning not only data but also various errors
    private func performRequest(url: String, completion: @escaping ([Product]) -> Void) {
        if let url = URL(string: url) {
            let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                if let data = data,
                   let products = parseJSON(data: data) {
                    completion(products)
                } else {
                    print( "invalid data")
                }
            }
            task.resume()
        }
    }

    private func parseJSON(data: Data) -> [Product]? {
        let decoder = JSONDecoder()
        do {
            let productList = try decoder.decode(ProductList.self, from: data)
            return productList.products
        } catch {
            return nil
        }
    }
}
