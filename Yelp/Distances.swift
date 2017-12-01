//
//  Distances.swift
//  Yelp
//
//  Created by Sahil Agarwal on 10/23/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

enum Distances: Double {
    case auto = 0.0
    case oneThird = 0.3
    case one = 1.0
    case five = 5.0
    case twenty = 20.0
    
    static func returnDistances() -> [Distances] {
        return [Distances.auto, Distances.oneThird, Distances.one, Distances.five, Distances.twenty]
    }
    
    static func getLabel(distance: Distances) -> String {
        if distance == Distances.auto {
            return "None"
        } else if distance == Distances.oneThird {
            return "0.3 miles"
        } else if distance == Distances.one {
            return "1 mile"
        } else if distance == Distances.five {
            return "5 miles"
        } else if distance == Distances.twenty {
            return "20 miles"
        } else {
            return ""
        }
    }
    
}
