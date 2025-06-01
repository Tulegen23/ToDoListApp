import Foundation
import FirebaseFirestore
import FirebaseFirestoreCombineSwift

struct ToDoTask: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var description: String
    var dueDate: Date
    var isCompleted: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case dueDate = "due_date"
        case isCompleted = "is_completed"
    }
}
