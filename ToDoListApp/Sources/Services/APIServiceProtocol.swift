import Foundation

protocol APIServiceProtocol {
    func fetchTasks() async throws -> [ToDoTask]
    func addTask(_ task: ToDoTask) async throws
    func updateTask(_ task: ToDoTask) async throws
    func deleteTask(_ taskId: String) async throws
}
