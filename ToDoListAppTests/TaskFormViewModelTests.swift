import XCTest
@testable import ToDoListApp
@MainActor
class TaskFormViewModelTests: XCTestCase {
    var viewModel: TaskFormViewModel!
    var service: MockFirebaseService!
    
    override func setUp() {
        super.setUp()
        service = MockFirebaseService()
        viewModel = TaskFormViewModel(service: service)
    }
    
    func testSaveTaskWithEmptyTitle() async {
        viewModel.title = ""
        let result = await viewModel.saveTask()
        XCTAssertFalse(result)
        XCTAssertEqual(viewModel.errorMessage, "Title cannot be empty")
    }
    
    func testSaveTaskSuccessfully() async {
        viewModel.title = "New Task"
        viewModel.description = "Description"
        viewModel.dueDate = Date()
        let result = await viewModel.saveTask()
        XCTAssertTrue(result)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(service.tasks.count, 2)
    }
}
