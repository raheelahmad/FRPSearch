//
//  Movie.swift
//  RACSearch
//
//  Created by Raheel Ahmad on 3/27/16.
//  Copyright © 2016 Raheel Ahmad. All rights reserved.
//

import Foundation

struct Movie: Equatable {
    let name: String
    let imageURL: NSURL?
}

func == (lhs: Movie, rhs: Movie) -> Bool {
    return lhs.name == rhs.name && (lhs.imageURL == rhs.imageURL)
}
