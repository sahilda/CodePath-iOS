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
    var sort: YelpSortMode?
    var categories: [String]?
    var deals: Bool?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = getYelpRedColor()
        
        loadTableView()
        loadSearchBar()
        
        yelpSearch(term: searchTerm, sort: sort, categories: categories, deals: deals)
    }
    
    func getYelpRedColor() -> UIColor {
        return UIColor(red: 196/255, green: 18/255, blue: 0/255, alpha: 1)
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
    
    func yelpSearch(term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?) {
        print("Searching with terms: \(term), sort: \(sort), categories: \(categories), and deals: \(deals)")
        
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

// MARK: UISearchBarDelegate

extension BusinessesViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != nil {
            searchTerm = searchBar.text!
            yelpSearch(term: searchTerm, sort: sort, categories: categories, deals: deals)
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
        yelpSearch(term: searchTerm, sort: sort, categories: categories, deals: deals)
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
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        if filters["categories"] != nil {
            categories = filters["categories"] as? [String]
        }
        
        yelpSearch(term: searchTerm, sort: sort, categories: categories, deals: deals)
    }
    
}
