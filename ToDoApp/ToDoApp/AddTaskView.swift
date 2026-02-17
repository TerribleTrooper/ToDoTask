import SwiftUI
import CoreData

struct AddTaskView: View {

    @Environment(\.managedObjectContext)
    private var viewContext

    @Environment(\.dismiss)
    private var dismiss

    @State private var title = ""
    @State private var details = ""

    var body: some View {

        NavigationStack {

            Form {

                Section("Task") {

                    TextField("Title", text: $title)

                    TextField("Description", text: $details)
                }
            }

            .navigationTitle("New Task")

            .toolbar {

                ToolbarItem(placement: .topBarLeading) {

                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {

                    Button("Save") {
                        save()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
        .onAppear {

            title = ""
            details = ""
        }
    }

    private func save() {

        let task = TaskEntity(context: viewContext)

        task.id = UUID()
        task.title = title
        task.details = details
        task.createdAt = Date()
        task.isDone = false

        do {

            try viewContext.save()
            dismiss()

        } catch {

            print(error)
        }
    }
}
