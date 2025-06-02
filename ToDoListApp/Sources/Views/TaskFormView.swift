import SwiftUI

struct TaskFormView: View {
    @StateObject private var viewModel = TaskFormViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                // Фон
                LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.1), .purple.opacity(0.05)]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        TextFieldWithLabel(
                            label: "📌 Заголовок задачи",
                            text: $viewModel.title,
                            placeholder: "Введите заголовок..."
                        )

                        TextFieldWithLabel(
                            label: "📝 Описание",
                            text: $viewModel.description,
                            placeholder: "Введите описание..."
                        )
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("🗓️ Срок выполнения")
                                .font(.headline)
                            DatePicker("", selection: $viewModel.dueDate, displayedComponents: .date)
                                .datePickerStyle(.graphical)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                        
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding(.top, 5)
                        }

                        Button(action: {
                            Task {
                                if await viewModel.saveTask() {
                                    dismiss()
                                }
                            }
                        }) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Сохранить задачу")
                            }
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(viewModel.title.isEmpty ? Color.gray : Color.blue)
                            .cornerRadius(12)
                        }
                        .disabled(viewModel.title.isEmpty)
                        .padding(.top, 10)
                    }
                    .padding()
                }
            }
            .navigationTitle("🆕 Новая задача")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }
}

struct TextFieldWithLabel: View {
    let label: String
    @Binding var text: String
    var placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.headline)
            TextField(placeholder, text: $text)
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 4)
        }
    }
}

struct TaskFormView_Previews: PreviewProvider {
    static var previews: some View {
        TaskFormView()
    }
}
