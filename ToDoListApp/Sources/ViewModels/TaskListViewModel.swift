import Foundation
import Combine

@MainActor
class TaskListViewModel: ObservableObject {
    @Published var tasks: [ToDoTask] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service: APIServiceProtocol
    
    init(service: APIServiceProtocol = FirebaseService()) {
        self.service = service
    }
    
    func fetchTasks() async {
        isLoading = true
        errorMessage = nil
        do {
            tasks = try await service.fetchTasks()
        } catch {
            errorMessage = "Failed to load tasks: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    func addTask(_ task: ToDoTask) async {
        do {
            try await service.addTask(task)
            await fetchTasks()
        } catch {
            errorMessage = "Failed to add task: \(error.localizedDescription)"
        }
    }
    
    func updateTask(_ task: ToDoTask) async {
        do {
            try await service.updateTask(task)
            await fetchTasks()
        } catch {
            errorMessage = "Failed to update task: \(error.localizedDescription)"
        }
    }
    
    func deleteTask(_ taskId: String) async {
        do {
            try await service.deleteTask(taskId)
            await fetchTasks()
        } catch {
            errorMessage = "Failed to delete task: \(error.localizedDescription)"
        }
    }
}
