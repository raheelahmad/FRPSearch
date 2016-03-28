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
    
    private var movies: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        SignalProducer(signal: searchBar.rac_searchBarTextDidChange).map { $0.1! }
            .mapError { _ in FetchError.Networking }
            .flatMap(FlattenStrategy.Latest) { fetchForText($0) }
            .observeOn(UIScheduler())
            .startWithNext { [weak self] movies in
                self?.movies = movies
                self?.collectionView.reloadData()
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
        movieCell.setup(movie)
        
        return movieCell
    }
    
}

extension ViewController: UICollectionViewDelegate {
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        self.collectionView?.performBatchUpdates(nil, completion: nil)
    }
}
