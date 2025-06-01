import Foundation

@MainActor
class ARTaskViewModel: ObservableObject {
    let task: ToDoTask
    
    init(task: ToDoTask) {
        self.task = task
    }
    
    var displayText: String {
        task.title
    }
}
