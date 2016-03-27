//
//  MovieCell.swift
//  RACSearch
//
//  Created by Raheel Ahmad on 3/27/16.
//  Copyright © 2016 Raheel Ahmad. All rights reserved.
//

import UIKit

final class MovieCell: UICollectionViewCell {
    static var identifier: String { return "movie" }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
}
