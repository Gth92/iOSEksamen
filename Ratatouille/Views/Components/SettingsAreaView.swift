
import SwiftUI
import CoreData

struct SettingsAreaView: View {
    @Environment(\.managedObjectContext) private var viewContext
    private var apiClient = MealDBApiClient()
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Area.areaName, ascending: true)],
        animation: .default)
    private var areas: FetchedResults<Area>
    
    var body: some View {
        List {
            ForEach(areas, id: \.self) { area in
                Text(area.areaName ?? "Unknown Area")
            }
            .onDelete(perform: deleteArea)
        }
        .onAppear(perform: fetchAndSaveAreas)
        .navigationTitle("Areas")
    }
    
    private func fetchAndSaveAreas() {
        apiClient.fetchAreas { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let areaResponse):
                    self.saveAreas(areaResponse.meals)
                    print("Successfully fetched and saved areas")
                case .failure(let error):
                    print("Error fetching areas: \(error)")
                }
            }
        }
    }
    
    private func saveAreas(_ apiAreas: [APIArea]) {
        apiAreas.forEach { apiArea in
            let fetchRequest: NSFetchRequest<Area> = Area.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "areaName == %@", apiArea.strArea)
            
            do {
                let results = try viewContext.fetch(fetchRequest)
                if results.isEmpty {
                    
                    let area = Area(context: viewContext)
                    area.areaName = apiArea.strArea
                    
                }
            } catch {
                print("Error fetching area: \(error)")
            }
        }
        
        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    private func deleteArea(at offsets: IndexSet) {
        for index in offsets {
            let area = areas[index]
            viewContext.delete(area)
        }
        
        do {
            try viewContext.save()
        } catch {
            print("Error deleting area: \(error)")
        }
    }
}

#Preview {
    SettingsAreaView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

