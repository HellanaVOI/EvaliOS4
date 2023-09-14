//
//  HomeViewController.swift
//  Eval
//
//  Created by Student09 on 14/09/2023.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    private var resultsController: NSFetchedResultsController<Expense>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Gérer vos dépenses"
        
        let request = Expense.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "fkType.name", ascending: true),
            NSSortDescriptor(key: "date", ascending: false),
            NSSortDescriptor(key: "name", ascending: true)
        ]


        resultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: DataManager.shared.context,
            sectionNameKeyPath: "fkType.name",
            cacheName: nil)
        
        resultsController.delegate = self
        do{
            try resultsController.performFetch()
        }catch{
            print("Error fetching initial data", error)
        }
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")
    }
    
    
    @IBAction func addExpense(_ sender: Any) {
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: "addExpense")
        else {
            fatalError("Unable to instantiate NewEmployeeViewController")
        }

        present(viewController, animated: true)
    }
}

extension HomeViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        resultsController.sections?[section].numberOfObjects ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier:"CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        
        customCell.setup(item: resultsController.object(at: indexPath))
        return customCell
    }
    
    
    // Partie pour faire plusieur section
    func numberOfSections(in tableView: UITableView) -> Int {
        resultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        resultsController.sections?[section].name
    }
}

extension HomeViewController: NSFetchedResultsControllerDelegate{
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections([sectionIndex], with: .automatic)
        case .delete:
            tableView.deleteSections([sectionIndex], with: .automatic)
        default:
            break
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
}
