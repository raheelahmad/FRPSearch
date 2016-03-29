//
//  MovieFetcher.swift
//  RACSearch
//
//  Created by Raheel Ahmad on 3/27/16.
//  Copyright © 2016 Raheel Ahmad. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Result

typealias JSON = [String: AnyObject]

func toMovies(json: JSON) -> [Movie] {
    guard let result = json["results"] as? [JSON] else { return [] }
    return result.flatMap { rawMovie in
        if let name = rawMovie["trackName"] as? String,
            let imageURLString = rawMovie["artworkUrl100"] as? String,
            let imageURL = NSURL(string: imageURLString)
        {
            return Movie(name: name, imageURL: imageURL)
        } else { return nil }
    }
}

enum FetchError: ErrorType {
    case Networking
    case Parsing
    case General
}

struct MovieFetcher {
    static func fetchForText(term: String) -> SignalProducer<[Movie], FetchError>  {
        let term = term.stringByReplacingOccurrencesOfString(" ", withString: "+")
        let request = NSURLRequest(URL: NSURL(string: "https://itunes.apple.com/search?term=\(term)&media=movie")!)
        
        return NSURLSession.sharedSession().rac_dataWithRequest(request)
            .mapError { _ in FetchError.Networking }
            .attemptMap { data, response in
                guard let httpResponse = response as? NSHTTPURLResponse where httpResponse.isLegit else {
                    return Result<[Movie], FetchError>.Failure(FetchError.Networking)
                }
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? JSON {
                        return .Success(toMovies(json))
                    }
                } catch { }
                return .Failure(FetchError.Parsing)
            }
            .on(started: {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            })
            .on(completed: {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            })
            .on(failed: { error in
                print("Error: \(error)")
            })
            .on(interrupted: {
                print("Fetch request interrupted. Probably because of FlattenStrategy.Latest")
            })
    }
}

extension NSHTTPURLResponse {
    var isLegit: Bool {
        return statusCode >= 200 && statusCode < 400
    }
}
