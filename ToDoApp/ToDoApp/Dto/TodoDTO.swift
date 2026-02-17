import Foundation

struct TodoResponse: Codable {
    let todos: [TodoDTO]
}

struct TodoDTO: Codable {
    let id: Int
    let todo: String
    let completed: Bool
}
