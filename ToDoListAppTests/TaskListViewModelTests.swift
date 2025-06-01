import XCTest
@testable import ToDoListApp

class MockFirebaseService: APIServiceProtocol {
    var tasks: [ToDoTask] = [
        ToDoTask(id: "1", title: "Test Task", description: "Description", dueDate: Date(), isCompleted: false)
    ]
    
    func fetchTasks() async throws -> [ToDoTask] { tasks }
    func addTask(_ task: ToDoTask) async throws { tasks.append(task) }
    func updateTask(_ task: ToDoTask) async throws {}
    func deleteTask(_ taskId: String) async throws { tasks.removeAll { $0.id == taskId } }
}
@MainActor
class TaskListViewModelTests: XCTestCase {
    var viewModel: TaskListViewModel!
    var service: MockFirebaseService!
    
    override func setUp() {
        super.setUp()
        service = MockFirebaseService()
        viewModel = TaskListViewModel(service: service)
    }
    
    func testFetchTasks() async {
        await viewModel.fetchTasks()
        XCTAssertEqual(viewModel.tasks.count, 1)
        XCTAssertEqual(viewModel.tasks.first?.title, "Test Task")
    }
    
    func testAddTask() async {
        let newTask = ToDoTask(title: "New Task", description: "New", dueDate: Date(), isCompleted: false)
        await viewModel.addTask(newTask)
        XCTAssertEqual(viewModel.tasks.count, 2)
    }
    
    func testDeleteTask() async {
        await viewModel.deleteTask("1")
        XCTAssertEqual(viewModel.tasks.count, 0)
    }
}
