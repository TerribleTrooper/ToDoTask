import Foundation

final class TodoAPIService {

    func fetchTodos() async throws -> [TodoDTO] {

        guard let url = URL(string: "https://dummyjson.com/todos") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        let decoded = try JSONDecoder().decode(TodoResponse.self, from: data)

        return decoded.todos
    }
}
