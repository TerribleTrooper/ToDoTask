import CoreData

struct PersistenceController {

    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {

        container = NSPersistentContainer(name: "ToDoApp")

        container.loadPersistentStores { _, error in

            if let error = error as NSError? {
                fatalError("CoreData error: \(error)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
