import XCTest
@testable import ToDoApp

@MainActor
final class TodoAPITests: XCTestCase {

    func testFetchTodos() async throws {

        let api = TodoAPIService()

        let todos = try await api.fetchTodos()

        XCTAssertFalse(todos.isEmpty)
    }
}
