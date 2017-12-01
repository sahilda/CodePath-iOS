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
    var offset: Int = 0
    var filters = [Sections: AnyObject]()
    var isMoreDataLoading = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var leftBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = YelpRedColor.getYelpRedColor()
        
        loadTableView()
        loadSearchBar()
        
        offset = 0
        yelpSearch(term: searchTerm, sort: sort, categories: categories, deals: deals, radius: radius, offset: offset)
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
        navigationItem.titleView?.tintColor = UIColor.white
        searchBar.delegate = self
    }
    
    func yelpSearch(term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, radius: Double?, offset: Int?) {
        print("Searching with terms: \(term), sort: \(sort), categories: \(categories), deals: \(deals), radius: \(radius), and offset: \(offset)")
        
        Business.searchWithTerm(term: term, sort: sort, categories: categories, deals: deals, radius: radius, offset: offset, completion: { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            if let _ = businesses {
                self.tableView.reloadData()
                print("Count: \(businesses!.count)")
            }
        })
    }
    
     // MARK: - Navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        
        if navigationController.restorationIdentifier == "settingsNavigation" {
            let filtersViewController = navigationController.topViewController as! FiltersViewController
            filtersViewController.delegate = self
            
            filtersViewController.filters = filters
        } else if navigationController.restorationIdentifier == "detailsNavigation"  {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let detailsViewController = navigationController.topViewController as! DetailsViewController
            detailsViewController.business = businesses![indexPath!.row]
        } else if navigationController.restorationIdentifier == "mapNavigation" {
            let mapViewController = navigationController.topViewController as! MapViewController
            mapViewController.businesses = businesses
        }
     }
}

// MARK: UISearchBarDelegate

extension BusinessesViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != nil {
            searchTerm = searchBar.text!
            offset = 0
            yelpSearch(term: searchTerm, sort: sort, categories: categories, deals: deals, radius: radius, offset: offset)
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
        offset = 0
        yelpSearch(term: searchTerm, sort: sort, categories: categories, deals: deals, radius: radius, offset: offset)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func loadMoreData() {
        offset = offset + 20
        
        print("Searching with terms: \(searchTerm), sort: \(sort), categories: \(categories), deals: \(deals), radius: \(radius), and offset: \(offset)")
            
        Business.searchWithTerm(term: searchTerm, sort: sort, categories: categories, deals: deals, radius: radius, offset: offset, completion: { (businesses: [Business]?, error: Error?) -> Void in
            if let _ = businesses {
                self.businesses = self.businesses + businesses!
                self.isMoreDataLoading = false
                self.tableView.reloadData()
            }
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                // Code to load more results
                loadMoreData()
            }
        }
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
        
        offset = 0
        yelpSearch(term: searchTerm, sort: sort, categories: categories, deals: deals, radius: radius, offset: offset)
    }
    
}
