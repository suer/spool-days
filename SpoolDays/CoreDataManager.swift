import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data error: \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func save() {
        let context = persistentContainer.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Save error: \(error)")
            }
        }
    }

    func saveAndWait() {
        let context = persistentContainer.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Save error: \(error)")
            }
        }
    }

    func delete(_ object: NSManagedObject) {
        context.delete(object)
    }

    func rollback() {
        context.rollback()
    }

    func fetchBaseDates() -> [BaseDate] {
        let fetchRequest: NSFetchRequest<BaseDate> = NSFetchRequest<BaseDate>(entityName: "BaseDate")
        let sortDescriptor = NSSortDescriptor(key: "sort", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch dates: \(error)")
            return []
        }
    }
}
