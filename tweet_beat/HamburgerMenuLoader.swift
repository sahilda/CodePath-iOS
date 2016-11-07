//
//  HamburgerMenuLoader.swift
//  tweet_beat
//
//  Created by Sahil Agarwal on 11/6/16.
//  Copyright © 2016 Sahil Agarwal. All rights reserved.
//

import UIKit

class HamburgerMenuLoader: NSObject {
    
    class func loadHamburgetMenu() -> HamburgerViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let hamburgerViewController = storyBoard.instantiateViewController(withIdentifier: "HamburgerViewController") as! HamburgerViewController
        let menuNavigationController = storyBoard.instantiateViewController(withIdentifier: "MenuNavigationController") as! UINavigationController
        let menuViewController = menuNavigationController.topViewController as! MenuViewController
        menuViewController.hamburgerViewController = hamburgerViewController
        hamburgerViewController.menuViewController = menuNavigationController
        return hamburgerViewController
    }

}
