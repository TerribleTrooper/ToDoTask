import SwiftUI
import CoreData

struct ContentView: View {

    // MARK: - CoreData

    @Environment(\.managedObjectContext)
    private var viewContext

    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(
                keyPath: \TaskEntity.createdAt,
                ascending: false
            )
        ],
        animation: .default
    )
    private var tasks: FetchedResults<TaskEntity>

    // MARK: - State

    @State private var showAdd = false
    @State private var searchText = ""

    // MARK: - Interactor

    private let interactor = TodoInteractor()

    // MARK: - View

    var body: some View {

        NavigationStack {

            List {

                ForEach(filteredTasks) { task in
                    row(task)
                }
                .onDelete(perform: deleteTask)
            }

            .listStyle(.plain)

            .navigationTitle("Tasks")

            .searchable(text: $searchText)

            .toolbar {

                ToolbarItem(placement: .topBarTrailing) {

                    Button {
                        showAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }

        .sheet(isPresented: $showAdd) {

            AddTaskView()
                .environment(
                    \.managedObjectContext,
                    viewContext
                )
        }

        .task {
            await loadFromAPI()
        }
    }

    // MARK: - Row

    @ViewBuilder
    private func row(_ task: TaskEntity) -> some View {

        NavigationLink {

            EditTaskView(task: task)
                .environment(
                    \.managedObjectContext,
                    viewContext
                )

        } label: {

            HStack(spacing: 12) {

                Button {

                    toggleDone(task)

                } label: {

                    Image(systemName:
                        task.isDone
                        ? "checkmark.circle.fill"
                        : "circle"
                    )
                    .foregroundColor(.blue)
                }
                .buttonStyle(.plain)

                VStack(alignment: .leading, spacing: 4) {

                    Text(task.title ?? "")
                        .font(.headline)

                    if let details = task.details,
                       !details.isEmpty {

                        Text(details)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }

    // MARK: - Helpers

    private var filteredTasks: [TaskEntity] {

        if searchText.isEmpty {
            return Array(tasks)
        }

        return tasks.filter {

            $0.title?
                .localizedCaseInsensitiveContains(
                    searchText
                ) ?? false
        }
    }

    private func deleteTask(at offsets: IndexSet) {

        for index in offsets {
            viewContext.delete(tasks[index])
        }

        saveContext()
    }

    private func toggleDone(_ task: TaskEntity) {

        task.isDone.toggle()

        saveContext()
    }

    private func saveContext() {

        do {
            try viewContext.save()
        } catch {
            print("Save error:", error)
        }
    }

    // MARK: - API

    @MainActor
    private func loadFromAPI() async {

        if !tasks.isEmpty {
            print("Already have data, skip API")
            return
        }

        do {

            print("Loading from API...")

            try await interactor.loadTodos(
                context: viewContext
            )

            print("API loaded")

        } catch {

            print("API error:", error)
        }
    }
}
