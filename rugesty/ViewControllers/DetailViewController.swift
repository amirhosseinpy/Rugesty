//
//  DetailViewController.swift
//  test2
//
//  Created by amirhosseinpy on 6/30/1397 AP.
//  Copyright © 1397 amirhosseinpy. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var index: Int = 0
    var carpets: [Carpet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.setupTableView()
    }
    
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 80.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func setupView() {
        self.carpets = Carpet.setupCarpets()
        
        let backGesture = UITapGestureRecognizer(target: self, action: #selector(self.onBackTapped))
        self.backImageView.addGestureRecognizer(backGesture)
        self.backImageView.isUserInteractionEnabled = true
    }
    
    @objc func onBackTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupCell(cell: DetailCell, index: Int) {
        switch index {
        case 0:
            cell.keyLabel.text = "design.number.colon".localized
            cell.valueLabel.text = carpets[self.index].designNo
        case 1:
            cell.keyLabel.text = "background.color.colon".localized
            cell.valueLabel.text = carpets[self.index].backgroundColor
        case 2:
            cell.keyLabel.text = "number.of.color.colon".localized
            cell.valueLabel.text = "colors".localizedWithArgs(["\(carpets[self.index].numberOfColors ?? 0)"])
        case 3:
            cell.keyLabel.text = "density.colon".localized
            cell.valueLabel.text = carpets[self.index].density
        case 4:
            cell.keyLabel.text = "pile.yarn.colon".localized
            cell.valueLabel.text = carpets[self.index].pileYarn
        case 5:
            cell.keyLabel.text = "warp.weft.yarn.colon".localized
            cell.valueLabel.text = carpets[self.index].wrapWeftYarn
        default:
            return
        }
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as? DetailCell else {
            return UITableViewCell()
        }
        
        self.setupCell(cell: cell, index: indexPath.row)
        return cell
    }
}
