//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController {
    
    var businesses: [Business]!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 90
        
        yelpSearch(term: "", sort: nil, categories: nil, deals: nil)
    }
    
    func yelpSearch(term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?) {
        Business.searchWithTerm(term: term, sort: sort, categories: categories, deals: deals, completion: { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            if let _ = businesses {
                self.tableView.reloadData()
            }
        })
    }
    
     // MARK: - Navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        
        let filtersViewController =  navigationController.topViewController as! FiltersViewController
        filtersViewController.delegate = self
     }
    
}

extension BusinessesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        cell.business = businesses![indexPath.row]
        
        return cell
    }
}

extension BusinessesViewController: FiltersViewControllerDelegate {
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        
        let categories = filters["categories"] as! [String]
        yelpSearch(term: "", sort: nil, categories: categories, deals: nil)
    }
    
}
