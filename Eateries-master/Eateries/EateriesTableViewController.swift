//
//  EateriesTableViewController.swift
//  Eateries
//
//  Created by Aleksey Kabishau on 1019..17.
//  Copyright © 2017 Aleksey Kabishau. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class EateriesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var restaurants: [Restaurant] = []
    
    var fetchResultsController: NSFetchedResultsController<Restaurant>!
    // for search
    var searchController: UISearchController!
    var filteredResultArray: [Restaurant] = []

    // unwindSegue from cancel button on new restaurant screen
    @IBAction func close(segue: UIStoryboardSegue) {        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = true
    }
    
    
    ///МАССИВ ДАННЫХ ПРИХОДЯЩИЙ С САЙТА
    var info: [[String: Any]] = [[String: Any]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        /////////ALAMOFIRE DATA
//        let url = "http://arteri.pro:1337/get_all"
//        Alamofire.request(url).responseJSON { (response) in
//            if let responseValue = response.result.value as! [String: Any]? {
//                if let responseInfo = responseValue["data"] as! [[String:Any]]? {
//                    self.info = responseInfo
//                    self.tableView?.reloadData()
//                }
//            }
//
//        }
        
        
        
        // MARK: Search
        // nil - results will be shown on the same screen; can be custom searchResultController
        searchController = UISearchController(searchResultsController: nil)
        //
        searchController.searchResultsUpdater = self
        // if true - screen becomes dimmed; false - no such representation
        searchController.dimsBackgroundDuringPresentation = false
        // showing search bar
        tableView.tableHeaderView = searchController.searchBar
        // locking search bar on the main screen (it doesn't appear on detailed screen)
        definesPresentationContext = true
        // for implementing UISearchBarDelegate Protocol
        searchController.searchBar.delegate = self
        // changing bar color and font color
        searchController.searchBar.barTintColor = #colorLiteral(red: 0.4901960784, green: 0.7647058824, blue: 0.9882352941, alpha: 1)
        searchController.searchBar.tintColor = .white

        
        // self-sizing cell establishing
        tableView.estimatedRowHeight = 85
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // removing name from back button in navigation bar for detail view controller
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
        // fetching data from Core Data
        let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        // gives the data that is sorted by field name
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        // applying created sortDescriptor to fetchRequest
        fetchRequest.sortDescriptors = [sortDescriptor]
        // creating the context
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultsController.delegate = self
            
            do {
                try fetchResultsController.performFetch()
                // saving retrieved data into restaurants array
                restaurants = fetchResultsController.fetchedObjects!
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    // it will upload Page View Controller at the top of main screen
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // checking did user see the Intro pages, if not - displaying  first page
        let userDefaults = UserDefaults.standard
        let wasIntroWatched = userDefaults.bool(forKey: "wasIntroWatched")
        guard !wasIntroWatched else { return }
        
        // calling Page View Controller from storyboard without any segues
        // casting to PageViewController to have access to all properties
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "pageViewController") as? PageViewController {
            present(pageViewController, animated: true, completion: nil)
        }
        
    }
    
    // MARK: - Fetch results controller delegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert: guard let indexPath = newIndexPath else { break }
        tableView.insertRows(at: [indexPath], with: .fade)
        case .delete: guard let indexPath = indexPath else { break }
        tableView.deleteRows(at: [indexPath], with: .fade)
        case .update: guard let indexPath = indexPath else { break }
        tableView.reloadRows(at: [indexPath], with: .fade)
        default:
            tableView.reloadData()
        }
        
        restaurants = controller.fetchedObjects as! [Restaurant]
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredResultArray.count
        }
        return restaurants.count
        ///////return info.count
    }
    
    // method for displaying different array of restaurants depending on usage of search bar
    func restaurantToDisplay(indexPath: IndexPath) -> Restaurant {
        let restaurant: Restaurant
        if searchController.isActive && searchController.searchBar.text != "" {
            restaurant = filteredResultArray[indexPath.row]
        } else {
            restaurant = restaurants[indexPath.row]
        }
        return restaurant
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EateriesTableViewCell
        
        let restaurant = restaurantToDisplay(indexPath: indexPath)
        
        cell.nameLabel.text = restaurant.name
        cell.typeLabel.text = restaurant.type
        cell.locationLabel.text = restaurant.location
        cell.thumbnailImageView.image = UIImage(data: restaurant.image! as Data)
        cell.accessoryType = restaurant.isVisited ? .checkmark : .none
        
        // making images round
        cell.thumbnailImageView.layer.cornerRadius = 32.5
        cell.thumbnailImageView.clipsToBounds = true
        
        
        
        
        
        
        
        /////ПОДСТАВЛЕНИЕ ТЕКСТА С СЕРВЕРА!!!!!!!!!!!!
//        if self.info.count > 0 {
//            let eachInfo = self.info[indexPath.row]
//            cell.nameLabel?.text = (eachInfo["name"] as? String) ?? ""
//            cell.locationLabel?.text = (eachInfo["geo_location"] as? String) ?? ""
//            cell.typeLabel?.text = (eachInfo["type"] as? String) ?? ""
//
//        }
        

        return cell
    }

/*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alertController = UIAlertController(title: nil, message: "Choose action", preferredStyle: .actionSheet)
        
        // cancel action
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        
        // call action
        let call = UIAlertAction(title: "Call 215-966-956\(indexPath.row)", style: .default) {
            (action: UIAlertAction) -> Void in
            let alertController = UIAlertController(title: nil, message: "Call can not be done", preferredStyle: .alert)
            let okay = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okay)
            self.present(alertController, animated: true, completion: nil)
        }
        alertController.addAction(call)
        
        // check-in/check-out action
        let visitedTitle = self.restaurants[indexPath.row].isVisited ? "Check out" : "Check In"
        let isVisited = UIAlertAction(title: visitedTitle, style: .default) { (action) in

            let cell = tableView.cellForRow(at: indexPath)
            self.restaurants[indexPath.row].isVisited = !self.restaurants[indexPath.row].isVisited
            cell?.accessoryType = self.restaurants[indexPath.row].isVisited ? .checkmark : .none
        }
        alertController.addAction(isVisited)
        
        
        present(alertController, animated: true, completion: nil)
        
        // deselecting standart highlighting
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
*/
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            restaurants.remove(at: indexPath.row)
//        }
//        tableView.deleteRows(at: [indexPath], with: .fade)
//    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            self.restaurants.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // deleting item from Core Data
            let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext
            // getting object and deleting it from context
            let objectToDelete = self.fetchResultsController.object(at: indexPath)
            context?.delete(objectToDelete)
            
            do {
                try context?.save()
            } catch {
                print(error.localizedDescription) 
            }
            
            
        }
        let share = UITableViewRowAction(style: .default, title: "Share") { (action, indexPath) in
            
            let defaulText = "I'm in " + self.restaurants[indexPath.row].name!
            if let image = UIImage(data: self.restaurants[indexPath.row].image! as Data) {
                let activityController = UIActivityViewController(activityItems: [defaulText, image], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }
        }
        
        delete.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        share.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        
        return [delete, share]
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationViewController = segue.destination as! DetailEateryViewController
                destinationViewController.restaurant = restaurantToDisplay(indexPath: indexPath)
            }
        }
    }
    
    // method for updateSearchResults
    func filterContentFor(searchText text: String) {
        // new array from restaurants array depending on filter
        filteredResultArray = restaurants.filter({ (restaurant) -> Bool in
            return (restaurant.name?.lowercased().contains(text.lowercased()))!
        })
    }

}

extension EateriesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentFor(searchText: searchController.searchBar.text!)
        tableView.reloadData()
    }
}

extension EateriesTableViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            navigationController?.hidesBarsOnSwipe = false
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        navigationController?.hidesBarsOnSwipe = true
    }
}




