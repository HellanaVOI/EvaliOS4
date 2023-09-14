//
//  AddExpenseViewController.swift
//  Eval
//
//  Created by Student09 on 14/09/2023.
//

import UIKit
import CoreData

class AddExpenseViewController: UIViewController {
    
    @IBOutlet var textFieldName: UITextField!
    @IBOutlet var textFieldAmount: UITextField!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var pickerDate: UIDatePicker!
    
    private var resultsController: NSFetchedResultsController<ExpenseSection>!
    private var typeSelected: ExpenseSection? = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerDate.datePickerMode = .date
        
        //Config TableView
        tableView.dataSource = self
        tableView.delegate = self
        
        
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

    }
    
    func addAlert(message: String){
        let dialog = UIAlertController(title:"Error", message:message, preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(dialog, animated:true, completion:nil)
    }
    
    
    @IBAction func addExpense(_ sender: Any) {
        
        guard let name = textFieldName.text, !name.isEmpty else { addAlert(message: "Champ Nom vide"); return }
        guard let amountText = textFieldAmount.text?.replacingOccurrences(of: ",", with: "."), let amount = Float(amountText)
            else { addAlert(message: "Champ Montant vide"); return }
        guard typeSelected != nil, let type = typeSelected else { addAlert(message: "Pas de type selectionné"); return }
        
        
        dismiss(animated: true){
            DataManager.shared.addExpense(name: name, amount: amount, date: self.pickerDate.date, type: type)
        }
        
    }
    
    @IBAction func cancel() {
        dismiss(animated: true)
    }

}


extension AddExpenseViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        resultsController.fetchedObjects?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        resultsController.fetchedObjects?[row].name
    }
}

extension AddExpenseViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        resultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let type = resultsController.object(at: indexPath)
        
        let cell = UITableViewCell()
        cell.textLabel?.text = type.name
        return cell
    }
}

extension AddExpenseViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath) {
        typeSelected = resultsController.fetchedObjects?[indexPath.row]
    }
    
}

