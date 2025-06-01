import SwiftUI

struct TaskFormView: View {
    @StateObject private var viewModel = TaskFormViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $viewModel.title)
                TextField("Description", text: $viewModel.description)
                DatePicker("Due Date", selection: $viewModel.dueDate, displayedComponents: .date)
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Add Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {
                            if await viewModel.saveTask() {
                                dismiss()
                            }
                        }
                    }
                    .disabled(viewModel.title.isEmpty)
                }
            }
        }
    }
}

struct TaskFormView_Previews: PreviewProvider {
    static var previews: some View {
        TaskFormView()
    }
}
