//
//  ListViewController.swift
//  test2
//
//  Created by amirhosseinpy on 6/23/1397 AP.
//  Copyright © 1397 amirhosseinpy. All rights reserved.
//

import UIKit
import DeckTransition

protocol ListViewContrllerDelegate: class {
    func itemDidChose()
}

class ListViewContrller: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: ListViewContrllerDelegate?
    var onItemSelected:(() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCollectionView()
    }
    
    func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
//        self.collectionView.transform = CGAffineTransform(scaleX: -1, y: 1)
//        self.collectionView.semanticContentAttribute = .forceRightToLeft
    }
    
    func setupCell(cell: CarpetListCell, index: Int) {
        cell.cardView.addCardShadow()
        cell.carpetImageView.image = Helper.images[index]
        cell.detailButton.layer.cornerRadius = 5.0
//        cell.priceLabel.layer.cornerRadius = 5.0
//        cell.priceLabel.text = "5000000".setTomanFormatWithToman()
        
        let detailGesture = UITapGestureRecognizer(target: self, action: #selector(self.onDetailTapped(_:)))
        cell.detailButton.tag = index
        cell.detailButton.addGestureRecognizer(detailGesture)
        cell.detailButton.isUserInteractionEnabled = true
    }
    
    func present(to viewController: UIViewController) {
        let transitionDelegate = DeckTransitioningDelegate(isSwipeToDismissEnabled: false)
        self.transitioningDelegate = transitionDelegate
        self.modalPresentationStyle = .custom
        viewController.present(self, animated: true, completion: nil)
    }
    
    @objc func onDetailTapped(_ gesture: UITapGestureRecognizer) {
        let story = UIStoryboard(name: "Main", bundle: self.nibBundle)
        
        if let view = gesture.view, let viewController = story.instantiateViewController(withIdentifier: "detailViewController") as? DetailViewController {
            viewController.index = view.tag
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func dismissTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ListViewContrller: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "carpetListCell", for: indexPath) as? CarpetListCell else {
            return UICollectionViewCell()
        }
        self.setupCell(cell: cell, index: indexPath.row)
//        cell.transform = CGAffineTransform(scaleX: -1, y: 1)
        return cell
    }
}

extension ListViewContrller: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Helper.selectedIndex = indexPath.row
        self.onItemSelected?()
        self.dismiss(animated: true, completion: nil)
//        if let delegate = self.delegate {
//            delegate.itemDidChose()
//        }
    }
}

extension ListViewContrller: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        return CGSize(width: width - 20, height: height - 64)
    }
}
