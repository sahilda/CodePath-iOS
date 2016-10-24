//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Sahil Agarwal on 10/23/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var sections = Sections.getSections()
    
    var distances: [Distances] = Distances.returnDistances()
    var distanceCollapsed = true
    
    var sortByOptions: [SortBy] = SortBy.returnSortByOptions()
    var sortByCollapsed = true
    
    var categories: [[String: String]]! = Categories.yelpCategories()
    var categoriesCollapsed = true
    var categoriesCollapsedRows = 4
    var categoriesSwitchStates = [Int: Bool]()
    
    var filters = [Sections: AnyObject]()
    var newFilters = [Sections: AnyObject]()

    var delegate: FiltersViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = YelpRedColor.getYelpRedColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        newFilters = filters
    }
    
    @IBAction func onCancelButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onSearchButton(_ sender: AnyObject) {
        getCategoriesFilterStateOnSearch()
        delegate?.filtersViewController(filtersViewController: self, didUpdateFilters: newFilters)
        dismiss(animated: true, completion: nil)
    }
    
    func getCategoriesFilterStateOnSearch() {
        var selectedCategories = [String]()
        for (row, isSelected) in categoriesSwitchStates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        
        if selectedCategories.count > 0 {
            newFilters[Sections.category] = selectedCategories as AnyObject?
        }
    }
    
}

// MARK: TableView functions

extension FiltersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func getHeaderHeight() -> Int {
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: Int(tableView.frame.width), height: getHeaderHeight()))
        headerLabel.backgroundColor = UIColor.white
        headerLabel.text = sections[section].rawValue
        headerView.addSubview(headerLabel)
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // No header for the first section
        if sections[section] == Sections.deals {
            return 0
        }
        return CGFloat(getHeaderHeight())
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sections[section] == Sections.deals {
            return 1
        } else if sections[section] == Sections.distance {
            return distanceCollapsed ? 1 : distances.count
        } else if sections[section] == Sections.sort {
            return sortByCollapsed ? 1 : sortByOptions.count
        } else if sections[section] == Sections.category {
            return categoriesCollapsed ? (categoriesCollapsedRows + 1) : categories.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
        cell.delegate = self
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 3
        cell.layer.borderColor = UIColor.darkGray.cgColor
        
        if sections[indexPath.section] == Sections.deals {
            dealCell(cell: cell)
        } else if sections[indexPath.section] == Sections.distance {
            distanceCellsCollapsed(cell: cell, index: indexPath.row)
        } else if sections[indexPath.section] == Sections.sort {
            sortByCellsCollapsed(cell: cell, index: indexPath.row)
        } else if sections[indexPath.section] == Sections.category {
            categoriesCellsCollapsed(cell: cell, index: indexPath.row)
        } else {
            cell.switchLabel.text = ""
            cell.onSwitch.isOn = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if sections[indexPath.section] == Sections.distance && distanceCollapsed {
            distanceCollapsed = false
            tableView.reloadData()
        } else if sections[indexPath.section] == Sections.sort && sortByCollapsed {
            sortByCollapsed = false
            tableView.reloadData()
        } else if sections[indexPath.section] == Sections.category && categoriesCollapsed && indexPath.row == categoriesCollapsedRows {
                categoriesCollapsed = false
                tableView.reloadData()
            }
    }
    
}

// MARK: specific cell view implementations

extension FiltersViewController {
    
    func dealCell(cell: SwitchCell) {
        cell.switchLabel.text = "Offering a Deal"
        if newFilters[Sections.deals] != nil {
            cell.onSwitch.isOn = newFilters[Sections.deals] as! Bool
        } else {
            cell.onSwitch.isOn = false
        }
    }
    
    func distanceCellsCollapsed(cell: SwitchCell, index: Int) {
        cell.switchLabel.text = Distances.getLabel(distance: distances[index])
        cell.onSwitch.isHidden = false
        cell.onSwitch.isOn = false
        
        if distanceCollapsed {
            cell.switchLabel.text = "See All"
            cell.onSwitch.isHidden = true
        }
    }
    
    func sortByCellsCollapsed(cell: SwitchCell, index: Int) {
        cell.switchLabel.text = sortByOptions[index].rawValue
        cell.onSwitch.isHidden = false
        cell.onSwitch.isOn = false
        
        if sortByCollapsed {
            if newFilters[Sections.sort] != nil {
                cell.switchLabel.text = sortByOptions[newFilters[Sections.sort] as! Int].rawValue
            } else {
                cell.switchLabel.text = "See All"
            }
            cell.onSwitch.isHidden = true
        }
        
        if newFilters[Sections.sort] != nil && newFilters[Sections.sort] as! Int == index {
            cell.switchLabel.text = sortByOptions[newFilters[Sections.sort] as! Int].rawValue
            cell.onSwitch.isOn = true
        }
    
    }
    
    func categoriesCellsCollapsed(cell: SwitchCell, index: Int) {
        cell.switchLabel.text = categories[index]["name"]
        cell.onSwitch.isHidden = false
        cell.onSwitch.isOn = categoriesSwitchStates[index] ?? false
        
        if categoriesCollapsed {
            if index >= categoriesCollapsedRows {
                cell.switchLabel.text = "See All"
                cell.onSwitch.isHidden = true
                cell.onSwitch.isOn = false
            }
        }
    }
    
}

extension FiltersViewController: SwitchCellDelegate {
    func switchCell(switchcell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: switchcell)!
        if sections[indexPath.section] == Sections.deals {
            newFilters[sections[indexPath.section]] = value as AnyObject?
        } else if sections[indexPath.section] == Sections.distance {
            newFilters[sections[indexPath.section]] = indexPath.row as AnyObject?
        } else if sections[indexPath.section] == Sections.sort {
            handleSortBySelection(switchcell: switchcell, indexPath: indexPath, value: value)
        } else {
            categoriesSwitchStates[indexPath.row] = value
        }
    }
    
    func handleSortBySelection(switchcell: SwitchCell, indexPath: IndexPath, value: Bool) {
        if value == false {
            newFilters[sections[indexPath.section]] = nil
        } else {
            newFilters[sections[indexPath.section]] = indexPath.row as AnyObject?
        }
        
        sortByCollapsed = true
        tableView.reloadData()
    }
    
}

extension FiltersViewController: FiltersViewControllerDelegate{
    internal func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [Sections : AnyObject]) {
        // do nothing
    }
}

protocol FiltersViewControllerDelegate {
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [Sections: AnyObject])
}
