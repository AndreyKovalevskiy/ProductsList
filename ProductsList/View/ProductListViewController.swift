//
//  ViewController.swift
//  ProductsList
//
//  Created by Andrey Kovalevskiy on 29.01.21.
//

import UIKit

class ProductListViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Properties

    private var productListViewModel = ProductListViewModel()

    // MARK: - Constants

    private enum CollectionViewConstants {
        static var padding: CGFloat = 15
        static var alphaOnLoadingData: CGFloat = 0.0
        static var alphaAfterLoadingData: CGFloat = 1.0
    }

    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureRefreshControl()
        configureBindings()
        productListViewModel.fetchProducts()
    }

    override func willTransition(to newCollection: UITraitCollection,
                                 with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }

    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func configureRefreshControl () {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(handleRefreshControl),
                                 for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }

     @objc private func handleRefreshControl() {
        productListViewModel.loadProducts()
        collectionView.refreshControl?.endRefreshing()
    }

    private func configureBindings() {
        productListViewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        productListViewModel.updateLoadingStatusClosure = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.productListViewModel.isLoading ?? false
                if isLoading {
                    self?.activityIndicator.startAnimating()
                    self?.collectionView.alpha = CollectionViewConstants.alphaOnLoadingData
                } else {
                    self?.activityIndicator.stopAnimating()
                    self?.collectionView.alpha = CollectionViewConstants.alphaAfterLoadingData
                }
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ProductListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productListViewModel.numberOfCells
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductListCellID", for: indexPath)
                as? ProductCollectionViewCell else { return UICollectionViewCell()}

        let productCellViewModel = productListViewModel.getProductCellViewModel(index: indexPath.row)
        cell.fill(with: productCellViewModel)

        productListViewModel.imageDataForCell(index: indexPath.row) { (data) in
            if let data = data,
               cell.imageUrl == productCellViewModel.imageUrl {
                DispatchQueue.main.async {
                    cell.imageView.image = UIImage(data: data)
                }
            }
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProductListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = CollectionViewConstants.padding
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
    }
}

// MARK: - UICollectionViewDelegate

extension ProductListViewController: UICollectionViewDelegate {
}
