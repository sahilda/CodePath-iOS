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
    var searchBar = UISearchBar()
    var searchTerm: String = ""
    var radius: Double?
    var sort: YelpSortMode?
    var categories: [String]?
    var deals: Bool?
    var filters = [Sections: AnyObject]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var leftBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = YelpRedColor.getYelpRedColor()
        
        loadTableView()
        loadSearchBar()
        
        yelpSearch(term: searchTerm, sort: sort, categories: categories, deals: deals, radius: radius)
    }
    
    func loadTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 90
    }
    
    func loadSearchBar() {
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.placeholder = "Search..."
        navigationItem.titleView = searchBar
        searchBar.delegate = self
    }
    
    func yelpSearch(term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, radius: Double?) {
        print("Searching with terms: \(term), sort: \(sort), categories: \(categories), deals: \(deals), and radius: \(radius)")
        
        Business.searchWithTerm(term: term, sort: sort, categories: categories, deals: deals, radius: radius, completion: { (businesses: [Business]?, error: Error?) -> Void in
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
        
        filtersViewController.filters = filters
     }
}

// MARK: UISearchBarDelegate

extension BusinessesViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != nil {
            searchTerm = searchBar.text!
            yelpSearch(term: searchTerm, sort: sort, categories: categories, deals: deals, radius: radius)
        }
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        searchTerm = ""
        yelpSearch(term: searchTerm, sort: sort, categories: categories, deals: deals, radius: radius)
    }
}

// MARK: UITableView Delegate and DataSource

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

// MARK: FiltersViewControllerDelegate

extension BusinessesViewController: FiltersViewControllerDelegate {
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [Sections : AnyObject]) {
        
        self.filters = filters
        
        if filters[Sections.deals] != nil {
            deals = filters[Sections.deals] as! Bool ? true : false
        } else {
            deals = nil
        }
        
        if filters[Sections.distance] != nil {
            let distances = Distances.returnDistances()
            radius = distances[filters[Sections.distance] as! Int].rawValue
            radius = radius == 0.0 ? nil : radius
        } else {
            radius = nil
        }
        
        if filters[Sections.sort] != nil {
            let index = filters[Sections.sort] as! Int
            sort = SortBy.getYelpSortMode(index: index)
        } else {
            sort = nil
        }
        
        if filters[Sections.category] != nil {
            categories = filters[Sections.category] as? [String]
        } else {
            categories = nil
        }
        
        yelpSearch(term: searchTerm, sort: sort, categories: categories, deals: deals, radius: radius)
    }
    
}
