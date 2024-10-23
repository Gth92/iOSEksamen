
import SwiftUI
import CoreData

struct SettingsArchiveView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Meal.mealName, ascending: true)],
        predicate: NSPredicate(format: "isArchived == %@", NSNumber(value: true)),
        animation: .default)
    private var archivedMeals: FetchedResults<Meal>
    
    var body: some View {
        List {
            ForEach(archivedMeals) { meal in
                Text(meal.mealName ?? "Unknown Meal")
                    .swipeActions {
                        Button(role: .destructive) {
                            deleteMeal(meal)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        
                        Button {
                            unarchiveMeal(meal)
                        } label: {
                            Label("Unarchive", systemImage: "archivebox")
                        }
                        .tint(.gray)
                    }
            }
        }
        .navigationBarTitle("Arkiverte måltider")
        .navigationBarItems(trailing: EditButton())
    }
    
    private func deleteMeal(_ meal: Meal) {
        viewContext.delete(meal)
        saveContext()
    }
    
    private func unarchiveMeal(_ meal: Meal) {
        meal.isArchived = false
        saveContext()
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

#Preview {
    SettingsArchiveView()
}
