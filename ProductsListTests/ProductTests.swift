//
//  ProductsListTests.swift
//  ProductsListTests
//
//  Created by Andrey Kovalevskiy on 30.01.21.
//

import XCTest
@testable import ProductsList

class ProductTests: XCTestCase {

    func testPublicPropertiesContainExpectedValuesWhenProductIsInitializedWithGivenParameters() throws {

        // Given
        let expectedID = "345"
        let expectedName = "fish"
        let expectedPrice = 105.25
        let expectedImageUrl = "https://grandkulinar.ru/uploads/posts/2014-08/1408885717_morozhenaya-ryba.jpg"

        // When
        let product = Product(id: expectedID,
                              name: expectedName,
                              price: expectedPrice,
                              imageUrl: expectedImageUrl)

        // Then
        XCTAssertEqual(product.id, expectedID)
        XCTAssertEqual(product.name, expectedName)
        XCTAssertEqual(product.price, expectedPrice)
        XCTAssertEqual(product.imageUrl, expectedImageUrl)
    }
}
