//
//  ImageManager.swift
//  ProductsList
//
//  Created by Andrey Kovalevskiy on 29.01.21.
//

import Foundation
import UIKit

struct ImageManager {

    // MARK: - Methods

    func saveImages(from productList: [Product]) {

        for product in productList {
            saveImage(fileName: product.id, imageUrl: product.imageUrl)
        }
    }

    private func saveImage(fileName: String, imageUrl: String) {

        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
                                        else { return }
        let fileURL = cachesDirectory.appendingPathComponent(fileName)

        guard let url = URL(string: imageUrl),
              let data = try? Data(contentsOf: url) else { return }
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch let removeError {
                print("File not removed with error", removeError.localizedDescription)
            }
        }

        do {
            try data.write(to: fileURL)
        } catch let error {
            print("File not saved with error", error.localizedDescription)
        }
    }

    func loadImageDataFromDiskWith(fileName: String) -> Data? {

        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)

        if let directoryPath = paths.first {
            let imageUrl = URL(fileURLWithPath: directoryPath).appendingPathComponent(fileName)
            let data = try? Data(contentsOf: imageUrl)
            return data
        }
        return nil
    }
}
