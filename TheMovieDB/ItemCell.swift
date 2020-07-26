//
//  ItemCell.swift
//  TheMovieDB
//
//  Created by Nguyen, Long on 7/26/20.
//  Copyright © 2020 Nguyen, Long. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class ItemCell: UICollectionViewCell {
    var imageUrl: String? {
        didSet {
            guard let url = URL(string: imageUrl!) else { return }
            
            self.imageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        self.addSubview(imageView)
        
        imageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
}
