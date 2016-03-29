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
        
        // To see the effect of "Latest", remove throttle, so multiple requests are in flight.
        
        SignalProducer(signal: searchBar.rac_searchBarTextDidChange) // https://github.com/ReactiveCocoa/ReactiveCocoa/issues/2150#issuecomment-158778866
            .map { $0.1! }
            .throttle(0.5, onScheduler: QueueScheduler.init(qos: QOS_CLASS_USER_INITIATED, name: "com.example.SearchBarTextThrottle"))
            .mapError { _ in FetchError.Networking }
            .flatMap(FlattenStrategy.Latest) { self.fetchForText($0) }
            .observeOn(UIScheduler())
            .on(failed: { error in
                print("in ViewController: \(error)")
            })
            .on(next: { [weak self] movies in
                self?.movies = movies
                self?.collectionView.reloadData()
            })
            .start()
    }
}

extension ViewController { // MARK: Signals
    func fetchForText(text: String) -> SignalProducer<[Movie], FetchError> {
        return MovieFetcher.fetchForText(text)
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
