//
//  MovieFetcher.swift
//  RACSearch
//
//  Created by Raheel Ahmad on 3/27/16.
//  Copyright © 2016 Raheel Ahmad. All rights reserved.
//

import Foundation
import ReactiveCocoa

typealias JSON = [String: AnyObject]

func toMovies(json: JSON) -> [Movie] {
    guard let result = json["results"] as? [JSON] else { return [] }
    return result.flatMap { rawMovie in
        if let name = rawMovie["collectionName"] as? String,
           let imageURLString = rawMovie["artworkUrl100"] as? String,
           let imageURL = NSURL(string: imageURLString)
        {
            return Movie(name: name, imageURL: imageURL)
        } else { return nil }
    }
}

enum FetchError: ErrorType {
    case Networking
}

final class MovieFetcher {
    let urlSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    func fetchForText(term: String) -> SignalProducer<[Movie], FetchError>  {
        let request = NSURLRequest(URL: NSURL(string: "https://itunes.apple.com/search?term=\(term)&media=movie")!)
        return urlSession.rac_dataWithRequest(request)
            .mapError { _ in FetchError.Networking }
            .map { data, response in
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? JSON {
                        return toMovies(json)
                    } else {
                        return []
                    }
                } catch {
                    return []
                }
            }
    }
}
