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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
    }
    
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 80.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as? DetailCell else {
            return UITableViewCell()
        }
        
        return cell
    }
}
