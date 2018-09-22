//
//  ListViewController.swift
//  test2
//
//  Created by amirhosseinpy on 6/23/1397 AP.
//  Copyright © 1397 amirhosseinpy. All rights reserved.
//

import UIKit

protocol ListViewContrllerDelegate: class {
    func itemDidChose()
}

class ListViewContrller: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: ListViewContrllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCollectionView()
    }
    
    func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    func setupCell(cell: CarpetListCell, index: Int) {
        cell.cardView.addCardShadow()
        cell.carpetImageView.image = Helper.images[index]
        cell.detailButton.layer.cornerRadius = 5.0
        cell.priceButton.layer.cornerRadius = 5.0
    }
}

extension ListViewContrller: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "carpetListCell", for: indexPath) as? CarpetListCell else {
            return UICollectionViewCell()
        }
        
        self.setupCell(cell: cell, index: indexPath.row)
        return cell
    }
}

extension ListViewContrller: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Helper.selectedIndex = indexPath.row
        if let delegate = self.delegate {
            delegate.itemDidChose()
        }
    }
}
