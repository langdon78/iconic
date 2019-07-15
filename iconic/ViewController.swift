//
//  ViewController.swift
//  iconic
//
//  Created by James Langdon on 7/13/19.
//  Copyright © 2019 corporatelangdon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var icons: [Icon] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    var nounApiClient = NounAPIClient()
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchRecentUpdates(for: page)
    }
    
    func fetchRecentUpdates(for page: Int? = nil) {
        nounApiClient.recentUploads(limit: 20, page: page) { result in
            switch result {
            case .success(let recent): self.icons.append(contentsOf: recent.recentUploads)
            case .failure(let error): print(error)
            }
        }
    }
}

// MARK: UICollectionView Data Source
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath) as? IconCollectionViewCell
        let icon = icons[indexPath.row]
        cell?.configure(with: icon)
        return cell ?? UICollectionViewCell()
    }
    
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == icons.endIndex - 1) {
            page += 1
            fetchRecentUpdates(for: page)
        }
    }
}
