//
//  IconCollectionViewCell.swift
//  iconic
//
//  Created by James Langdon on 7/14/19.
//  Copyright © 2019 corporatelangdon. All rights reserved.
//

import UIKit

class IconCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    var url: String?
    
    func configure(with icon: Icon, nounApiClient: NounAPIClient) {
        self.iconImageView.image = nil
        iconImageView.alpha = 0
        nounApiClient.getImage(from: icon.previewUrl) { [weak self] data in
            guard let data = data,
                let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.animate()
                self?.iconImageView.image = image
                self?.url = icon.previewUrl
            }
        }
    }
    
    func animate() {
        UIView.animate(withDuration: 1) { [weak self] in
            self?.iconImageView.alpha = 1
        }
    }
    
}
