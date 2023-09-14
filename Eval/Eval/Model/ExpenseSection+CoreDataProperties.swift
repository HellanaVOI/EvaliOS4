//
//  ExpenseSection+CoreDataProperties.swift
//  Eval
//
//  Created by Student09 on 14/09/2023.
//
//

import Foundation
import CoreData


extension ExpenseSection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExpenseSection> {
        return NSFetchRequest<ExpenseSection>(entityName: "ExpenseSection")
    }

    @NSManaged public var name: String?
    @NSManaged public var fkExpense: Expense?

}

extension ExpenseSection : Identifiable {

}
