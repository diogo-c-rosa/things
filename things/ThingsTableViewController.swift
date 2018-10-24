//
//  ThingsTableViewController.swift
//  things
//
//  Created by Diogo Rosa on 15/10/18.
//  Copyright © 2018 Diogo. All rights reserved.
//

import UIKit

class ThingsTableViewController: UITableViewController, UISearchBarDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var searchBar: UISearchBar!
    var things: [Thing] = []
    var filteredThings: [Thing] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        getData()
        filteredThings = things
        tableView.reloadData()
    }
    
    func getData() {
        do {
            things = try context.fetch(Thing.fetchRequest())
        } catch {
            print("Fetching Failed")
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredThings.count
    }

    func age(_ startDate: Date?, _ endDate: Date?) -> String? {
        guard let startDate = startDate else {
            return ""
        }
        
        let form = DateComponentsFormatter()
        form.maximumUnitCount = 2
        form.unitsStyle = .full
        form.allowedUnits = [.year, .month, .day]
        
        guard let endDate = endDate else {
            return form.string(from: startDate, to: Date())
        }
        return form.string(from: startDate, to: endDate)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "prototypeCell", for: indexPath)

        let thing = filteredThings[indexPath.row]
        
        if let name = thing.name {
            cell.textLabel?.text = name
            cell.detailTextLabel?.text = age(thing.start, thing.end)
            if thing.end != nil {
                cell.detailTextLabel?.textColor = UIColor.red
            }
        }

        return cell
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredThings = searchText.isEmpty ? things : things.filter {
            (item: Thing) -> Bool in
            return item.name!.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}
