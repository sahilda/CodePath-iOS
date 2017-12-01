//
//  Sections.swift
//  Yelp
//
//  Created by Sahil Agarwal on 10/23/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

enum Sections: String {
    case deals = "Deals"
    case distance = "Distance"
    case sort = "Sort By"
    case category = "Category"
    
    static func getSections() -> [Sections] {
        return [Sections.deals, Sections.distance, Sections.sort, Sections.category]
    }
    
}
