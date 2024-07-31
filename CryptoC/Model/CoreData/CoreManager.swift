import Foundation
import CoreData

// Singleton
class CoreManager {
    
    static let shared = CoreManager()
    var expenses = [Expenses]()
    
    private init() {
        fetchAllExpenses()
    }
    
    // MARK: - Core Data Stack
    var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "CryptoC")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print(error.localizedDescription)
//                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // Fetch func
    func fetchAllExpenses(){
           let request = Expenses.fetchRequest()
           if let expenses = try? persistentContainer.viewContext.fetch(request) {
               self.expenses = expenses
           }
       }
    
    // Add func
    func addNewNote(title: String, money: Double) {
        let expense = Expenses(context: persistentContainer.viewContext)
        expense.id = UUID().uuidString
        expense.title = title
        expense.money = money
        expense.date = Date()
        
        saveContext()
        fetchAllExpenses()
    }
}
