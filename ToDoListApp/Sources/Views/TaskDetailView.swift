import SwiftUI

struct TaskDetailView: View {
    let task: ToDoTask
    @StateObject private var viewModel = TaskListViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(task.title)
                .font(.largeTitle)
            Text(task.description)
                .font(.body)
            Text("Due: \(task.dueDate, style: .date)")
                .font(.subheadline)
            Toggle("Completed", isOn: Binding(
                get: { task.isCompleted },
                set: { newValue in
                    Task {
                        let updatedTask = ToDoTask(id: task.id, title: task.title, description: task.description, dueDate: task.dueDate, isCompleted: newValue)
                        await viewModel.updateTask(updatedTask)
                    }
                }
            ))
            NavigationLink(destination: ARTaskView(task: task)) {
                Text("View in AR")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Task Details")
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView(task: ToDoTask(title: "Sample Task", description: "Description", dueDate: Date(), isCompleted: false))
    }
}
