import SwiftUI

struct TaskDetailView: View {
    let task: ToDoTask
    @StateObject private var viewModel = TaskListViewModel()
    @State private var isCompleted: Bool

    init(task: ToDoTask) {
        self.task = task
        _isCompleted = State(initialValue: task.isCompleted)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Заголовок
                Text(task.title)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.primary)
                    .padding(.bottom, 10)

                // Описание
                VStack(alignment: .leading, spacing: 10) {
                    Label("Описание", systemImage: "doc.text")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text(task.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                }

                // Срок выполнения
                VStack(alignment: .leading, spacing: 10) {
                    Label("Срок", systemImage: "calendar")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text("\(task.dueDate, formatter: dateFormatter)")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }

                // Переключатель выполнения
                Toggle(isOn: $isCompleted) {
                    Label("Статус задачи", systemImage: isCompleted ? "checkmark.circle.fill" : "clock.fill")
                        .foregroundColor(isCompleted ? .green : .orange)
                }
                .onChange(of: isCompleted) { newValue in
                    Task {
                        let updatedTask = ToDoTask(
                            id: task.id,
                            title: task.title,
                            description: task.description,
                            dueDate: task.dueDate,
                            isCompleted: newValue
                        )
                        await viewModel.updateTask(updatedTask)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 2)

                // AR кнопка
                NavigationLink(destination: ARTaskView(task: task)) {
                    HStack {
                        Image(systemName: "arkit")
                        Text("Посмотреть в AR")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("📝 Детали задачи")
        .navigationBarTitleDisplayMode(.inline)
        .background(
            LinearGradient(gradient: Gradient(colors: [.white, .blue.opacity(0.05)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView(
            task: ToDoTask(
                id: "1",
                title: "Проверить интерфейс",
                description: "Сделать UI детального просмотра крутым.",
                dueDate: Date(),
                isCompleted: false
            )
        )
    }
}
