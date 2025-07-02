
import CoreData

class ShoppingListSettingsViewModel: ObservableObject {
    
    @Published var shoppingList: ShoppingList
    
    init(shoppingList: ShoppingList) {
        self.shoppingList = shoppingList
    }
    
    var title: Binding<String> {
        Binding<String>(
            get: { self.shoppingList.title ?? "" },
            set: { self.shoppingList.title = $0 }
        )
    }
    
    @MainActor
    func save(title: String, _ context: NSManagedObjectContext) {
        do {
            self.shoppingList.save()
            try context.save()
        } catch {
            print("Error saving:", error.localizedDescription)
        }
    }
    
}