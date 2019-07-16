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
            updateCollectionView()
        }
    }
    var nounApiClient = NounAPIClient<OAuth1Client>()
    var page = 1
    var limit = 50
    var iconIndexRangeToLoad: CountableClosedRange<Int> {
        return (icons.count - limit)...(icons.count - 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchRecentUpdates(for: page)
    }
    
    func fetchRecentUpdates(for page: Int? = nil) {
        nounApiClient.recentUploads(limit: limit, page: page) { result in
            switch result {
            case .success(let recent): self.icons.append(contentsOf: recent.recentUploads)
            case .failure(let error): print(error)
            }
        }
    }
    
    func updateCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.performBatchUpdates({
                let indexRange = self.iconIndexRangeToLoad.map { IndexPath(item: $0, section: 0) }
                self.collectionView.insertItems(at: indexRange)
            }, completion: nil)
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
        cell?.configure(with: icon, nounApiClient: nounApiClient)
        return cell ?? UICollectionViewCell()
    }
    
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == icons.endIndex - 20) {
            page += 1
            fetchRecentUpdates(for: page)
        }
    }
}
