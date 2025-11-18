import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        EmptyView()
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
