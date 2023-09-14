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
    
    @IBOutlet var pickerDate: UIDatePicker!
    @IBOutlet var picker: UIPickerView!
    
    private var resultsController: NSFetchedResultsController<ExpenseSection>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerDate.datePickerMode = .date
        picker.delegate = self
        
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
    
    
    @IBAction func addExpense(_ sender: Any) {
        
        guard let name = textFieldName.text, !name.isEmpty else { print("Error: Name"); return }
        guard let amountText = textFieldAmount.text?.replacingOccurrences(of: ",", with: ".") else { print("Error: Amount_text"); return }
        guard let amount = Float(amountText) else { print("Error: Amount"); return }
        guard let type = resultsController.fetchedObjects?[picker.selectedRow(inComponent: 0)] else { print("Error: type"); return }
        
        
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

