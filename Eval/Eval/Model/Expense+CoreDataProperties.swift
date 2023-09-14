//
//  Expense+CoreDataProperties.swift
//  Eval
//
//  Created by Student09 on 14/09/2023.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var date: Date
    @NSManaged public var name: String
    @NSManaged public var value: Float
    @NSManaged public var fkType: ExpenseSection

}

extension Expense : Identifiable {

}
