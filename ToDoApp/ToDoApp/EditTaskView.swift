import SwiftUI
import CoreData

struct EditTaskView: View {

    @ObservedObject var task: TaskEntity

    @Environment(\.managedObjectContext)
    private var viewContext

    @Environment(\.dismiss)
    private var dismiss

    @State private var title = ""
    @State private var details = ""

    var body: some View {

        Form {

            Section("Task") {

                TextField("Title", text: $title)

                TextField("De scription", text: $details)

                Toggle("Completed", isOn: $task.isDone)
            }
        }

        .navigationTitle("Edit Task")

        .toolbar {

            ToolbarItem(placement: .topBarTrailing) {

                Button("Save") {
                    save()
                }
            }
        }

        .onAppear {

            title = task.title ?? ""
            details = task.details ?? ""
        }
    }

    private func save() {

        task.title = title
        task.details = details

        do {

            try viewContext.save()
            dismiss()

        } catch {

            print(error)
        }
    }
}
