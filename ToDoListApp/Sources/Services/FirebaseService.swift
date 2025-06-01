import FirebaseFirestore
import FirebaseFirestoreCombineSwift

class FirebaseService: APIServiceProtocol {
    private let db = Firestore.firestore()
    private let collection = "tasks"

    func fetchTasks() async throws -> [ToDoTask] {
        let snapshot = try await db.collection(collection).getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: ToDoTask.self) }
    }

    func addTask(_ task: ToDoTask) async throws {
        _ = try db.collection(collection).addDocument(from: task)
    }

    func updateTask(_ task: ToDoTask) async throws {
        guard let taskId = task.id else { throw NSError(domain: "App", code: -1, userInfo: [NSLocalizedDescriptionKey: "Task ID is missing"]) }
        try await db.collection(collection).document(taskId).setData(from: task)
    }

    func deleteTask(_ taskId: String) async throws {
        try await db.collection(collection).document(taskId).delete()
    }
}
