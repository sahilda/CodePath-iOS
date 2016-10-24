//
//  SortBy.swift
//  Yelp
//
//  Created by Sahil Agarwal on 10/23/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

enum SortBy: String {
    case bestMatch = "Best Match"
    case distance = "Distance"
    case highestRated = "Highest Rated"
    
    static func returnSortByOptions() -> [SortBy] {
        return [SortBy.bestMatch, SortBy.distance, SortBy.highestRated]
    }
    
    static func getYelpSortMode(index: Int) -> YelpSortMode {
        if index == 0 {
            return YelpSortMode.bestMatched
        } else if index == 1 {
            return YelpSortMode.distance
        } else {
            return YelpSortMode.highestRated
        }
    }
}
