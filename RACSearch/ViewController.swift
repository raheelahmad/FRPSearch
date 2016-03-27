//
//  ViewController.swift
//  RACSearch
//
//  Created by Raheel Ahmad on 3/26/16.
//  Copyright © 2016 Raheel Ahmad. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result

class ViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var signal: SignalProducer<String, NoError>?
    
    var movies: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.rac_searchBarTextDidChange.observeNext {
            print($0.1)
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MovieCell.identifier, forIndexPath: indexPath)
        let index = indexPath.item
        guard let movieCell = cell as? MovieCell where index < movies.count else { return cell }
        
        let movie = movies[index]
        movieCell.imageView.image = nil
        movieCell.nameLabel.text = movie.name
        
        return movieCell
    }
}
