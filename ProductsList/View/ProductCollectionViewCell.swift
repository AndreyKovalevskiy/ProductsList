//
//  CollectionViewCell.swift
//  ProductsList
//
//  Created by Andrey Kovalevskiy on 29.01.21.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    // MARK: - Properties

    private(set) var imageUrl: String?

    // MARK: - Constants

    private enum CollectionViewCellConstants {
        static var borderColor = UIColor.gray.cgColor
        static var borderWidth: CGFloat = 0.5
    }

    // MARK: - Methods

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = CollectionViewCellConstants.borderColor
        layer.borderWidth = CollectionViewCellConstants.borderWidth
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
        priceLabel.text = nil
    }

    func fill(with viewModel: ProductCellViewModel) {
        nameLabel.text = viewModel.name
        priceLabel.text = viewModel.price
        imageUrl = viewModel.imageUrl
    }
}
