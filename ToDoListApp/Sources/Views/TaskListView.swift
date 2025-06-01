import SwiftUI

struct TaskListView: View {
    @StateObject private var viewModel = TaskListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else if viewModel.tasks.isEmpty {
                    Text("No tasks available")
                        .foregroundColor(.gray)
                } else {
                    List {
                        ForEach(viewModel.tasks) { task in
                            NavigationLink(destination: TaskDetailView(task: task)) {
                                VStack(alignment: .leading) {
                                    Text(task.title)
                                        .font(.headline)
                                    Text(task.description)
                                        .font(.subheadline)
                                    Text(task.dueDate, style: .date)
                                        .font(.caption)
                                    Text(task.isCompleted ? "Completed" : "Pending")
                                        .font(.caption)
                                        .foregroundColor(task.isCompleted ? .green : .orange)
                                }
                            }
                        }
                        .onDelete { indexSet in
                            Task {
                                for index in indexSet {
                                    if let taskId = viewModel.tasks[index].id {
                                        await viewModel.deleteTask(taskId)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("To-Do List")
            .toolbar {
                NavigationLink(destination: TaskFormView()) {
                    Image(systemName: "plus")
                }
            }
            .task {
                await viewModel.fetchTasks()
            }
        }
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
    }
}
