import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    private init() {}
    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        let applicationSupportURL = urls[urls.count-1]
        let applicationName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "SpoolDays"
        let appDirectoryURL = applicationSupportURL.appendingPathComponent(applicationName)
        if !FileManager.default.fileExists(atPath: appDirectoryURL.path) {
            try? FileManager.default.createDirectory(at: appDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        }
        return appDirectoryURL
    }()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        let storeURL = self.applicationDocumentsDirectory.appendingPathComponent("spooldays.sqlite3")
        let description = NSPersistentStoreDescription(url: storeURL)
        description.type = NSSQLiteStoreType
        container.persistentStoreDescriptions = [description]
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
