import Foundation

@MainActor
class TaskFormViewModel: ObservableObject {
    @Published var title = ""
    @Published var description = ""
    @Published var dueDate = Date()
    @Published var errorMessage: String?
    
    private let service: APIServiceProtocol
    
    init(service: APIServiceProtocol = FirebaseService()) {
        self.service = service
    }
    
    func saveTask() async -> Bool {
        guard !title.isEmpty else {
            errorMessage = "Title cannot be empty"
            return false
        }
        let task = ToDoTask(title: title, description: description, dueDate: dueDate, isCompleted: false)
        do {
            try await service.addTask(task)
            return true
        } catch {
            errorMessage = "Failed to save task: \(error.localizedDescription)"
            return false
        }
    }
}
