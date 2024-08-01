//
//  Expenses+CoreDataProperties.swift
//  CryptoC
//
//  Created by Daniil Kim on 30.07.2024.
//
//

import Foundation
import CoreData

extension Expenses {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expenses> {
        return NSFetchRequest<Expenses>(entityName: "Expenses")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var money: Double

}

extension Expenses: Identifiable {
    
    func updateNote(newTitle: String, newMoney: Double) {
        self.title = newTitle
        self.money = newMoney
        self.date = Date()
        
        do {
            try managedObjectContext?.save()
        } catch {
            print("Failed to save the updated note: \(error)")
        }
    }

    func deleteNote() {
        managedObjectContext?.delete(self)
        try? managedObjectContext?.save()
    }
}
