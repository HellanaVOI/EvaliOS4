//
//  DataManager.swift
//  Eval
//
//  Created by Student09 on 14/09/2023.
//

import Foundation
import CoreData

class DataManager{
    
    static let shared = DataManager()
    let context: NSManagedObjectContext
    
    init() {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error loading persistant store:", error)
            }
        }
        context = container.viewContext
        initSection()
    }
    
    // MARK: - Utilitaire
    
    private func saveContext() {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            print("Error saving context", error)
        }
    }
    
    private func initSection(){
        
        if !UserDefaults.standard.bool(forKey: "isFirstLaunch") {
            addTypeOfExpense(name: "Taxe")
            addTypeOfExpense(name: "Restaurant")
            addTypeOfExpense(name: "Voiture")
            addTypeOfExpense(name: "Maison")
            addTypeOfExpense(name: "Facture")
            UserDefaults.standard.setValue(true, forKey: "isFirstLaunch")
        }
    }
    
    // MARK: - Type Of Expense
    
    func addTypeOfExpense(name: String){
        
        let typeOfExpense = ExpenseSection(context: context)
        typeOfExpense.name = name
         
        saveContext()
    }
    
    func delType(_ item: ExpenseSection){
        context.delete(item)
        saveContext()
    }
    
    
    // MARK: - Expense
    func addExpense(name: String, amount: Float, date: Date, type: ExpenseSection){
        
        let expense = Expense(context: context)
        expense.name = name
        expense.value = amount
        expense.date = date
        expense.fkType = type
         
        saveContext()
    }
    
    func delExpense(_ item: Expense){
        context.delete(item)
        saveContext()
    }
    
    
    
}
