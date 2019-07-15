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
    
    func configure(with icon: Icon) {
        DispatchQueue.main.async { [weak self] in
            do {
                let data = try Data(contentsOf: URL(string: icon.previewUrl)!)
                self?.iconImageView.image = UIImage(data: data)
            } catch {
                print(error)
            }
        }
    }
    
}
