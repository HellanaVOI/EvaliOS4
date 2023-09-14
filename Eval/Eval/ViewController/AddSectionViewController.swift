//
//  AddSectionViewController.swift
//  Eval
//
//  Created by Student09 on 14/09/2023.
//

import UIKit
import CoreData

class AddSectionViewController: UIViewController {
    
    private var resultsController: NSFetchedResultsController<ExpenseSection>!
    
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        
        let request = ExpenseSection.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        resultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: DataManager.shared.context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        do{
            try resultsController.performFetch()
        }catch{
            print("Error fetching initial data", error)
        }
        
        resultsController.delegate = self
        
    }
    
    @IBAction func addSection(_ sender: Any) {
        let dialog = UIAlertController(title:"Type de Section", message:"Ajout d'une section", preferredStyle: .alert)
        
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            guard let fieldText = dialog.textFields?.first?.text, !fieldText.isEmpty else { return }
            DataManager.shared.addTypeOfExpense(name: fieldText)
        }
        
        dialog.addTextField()
        dialog.addAction(okAction)
        dialog.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(dialog, animated:true, completion:nil)
    }

}

extension AddSectionViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        resultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let type = resultsController.object(at: indexPath)
        
        let cell = UITableViewCell()
        cell.textLabel?.text = type.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let type = resultsController.object(at: indexPath)
            DataManager.shared.delType(type)
        }
    }
}

extension AddSectionViewController: NSFetchedResultsControllerDelegate{
    
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
