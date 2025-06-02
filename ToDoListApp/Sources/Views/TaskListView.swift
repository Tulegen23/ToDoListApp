import SwiftUI

struct TaskListView: View {
    @StateObject private var viewModel = TaskListViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Градиентный фон
                LinearGradient(
                    gradient: Gradient(colors: [.blue.opacity(0.1), .purple.opacity(0.05)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    if viewModel.isLoading {
                        ProgressView("Загрузка...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            .scaleEffect(1.5)
                    } else if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    } else if viewModel.tasks.isEmpty {
                        VStack(spacing: 10) {
                            Image(systemName: "tray")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                            Text("Нет доступных задач")
                                .foregroundColor(.gray)
                                .font(.headline)
                        }
                        .padding()
                    } else {
                        List {
                            ForEach(viewModel.tasks) { task in
                                NavigationLink(destination: TaskDetailView(task: task)) {
                                    TaskCardView(task: task)
                                }
                                .listRowBackground(Color.clear)
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
                        .listStyle(PlainListStyle())
                    }
                }
                .padding(.top, 8)
                .navigationTitle("📋 To-Do List")
                .toolbar {
                    NavigationLink(destination: TaskFormView()) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
                .task {
                    await viewModel.fetchTasks()
                }
            }
        }
    }
}

struct TaskCardView: View {
    let task: ToDoTask

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(task.title)
                    .font(.headline)
                Spacer()
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "clock.fill")
                    .foregroundColor(task.isCompleted ? .green : .orange)
            }
            Text(task.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("Срок: \(task.dueDate, formatter: dateFormatter)")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
        )
        .padding(.vertical, 4)
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
    }
}
