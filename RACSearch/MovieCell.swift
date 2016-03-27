//
//  MovieCell.swift
//  RACSearch
//
//  Created by Raheel Ahmad on 3/27/16.
//  Copyright © 2016 Raheel Ahmad. All rights reserved.
//

import UIKit
import Kingfisher

final class MovieCell: UICollectionViewCell {
    static var identifier: String { return "movie" }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
}

extension MovieCell {
    func setup(movie: Movie) {
        imageView.kf_setImageWithURL(movie.imageURL)
        nameLabel.text = movie.name
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf_cancelDownloadTask()
    }
}
