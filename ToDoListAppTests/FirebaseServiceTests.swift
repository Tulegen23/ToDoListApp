import XCTest
import FirebaseFirestore
@testable import ToDoListApp

class FirebaseServiceTests: XCTestCase {
    var service: FirebaseService!
    
    override func setUp() {
        super.setUp()
        service = FirebaseService()
    }
    
    func testAddAndFetchTask() async throws {
        let task = ToDoTask(title: "Test Task", description: "Test", dueDate: Date(), isCompleted: false)
        try await service.addTask(task)
        
        let tasks = try await service.fetchTasks()
        XCTAssertTrue(tasks.contains { $0.title == "Test Task" })
    }
}
