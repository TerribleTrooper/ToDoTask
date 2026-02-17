import Foundation
import CoreData

@MainActor
final class TodoInteractor {

    private let api = TodoAPIService()

    func loadTodos(
        context: NSManagedObjectContext
    ) async throws {

        let todos = try await api.fetchTodos()

        for todo in todos {

            let task = TaskEntity(context: context)

            task.id = UUID()
            task.title = todo.todo
            task.details = ""
            task.createdAt = Date()
            task.isDone = todo.completed
        }

        try context.save()
    }
}
