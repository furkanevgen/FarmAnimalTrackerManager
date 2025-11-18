import SwiftUI
import CoreData

struct MainTabView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var languageManager: LanguageManager
    @StateObject private var animalViewModel: AnimalViewModel
    
    init(viewContext: NSManagedObjectContext) {
        _animalViewModel = StateObject(wrappedValue: AnimalViewModel(viewContext: viewContext))
    }
    
    var body: some View {
        TabView {
            TrackerView(viewModel: animalViewModel)
                .tabItem {
                    Label("tab_tracker", systemImage: "pawprint.fill")
                }
            
            AddAnimalView(viewModel: animalViewModel)
                .tabItem {
                    Label("tab_add", systemImage: "plus.circle.fill")
                }
            
            EditAnimalListView(viewModel: animalViewModel)
                .tabItem {
                    Label("tab_edit", systemImage: "pencil.circle.fill")
                }
            
            StatisticsView(viewModel: animalViewModel)
                .tabItem {
                    Label("tab_statistics", systemImage: "chart.bar.fill")
                }
            
            SettingsView(
                themeManager: themeManager,
                languageManager: languageManager
            )
            .tabItem {
                Label("tab_settings", systemImage: "gearshape.fill")
            }
        }
        .onAppear {
            AppDelegate.setOrientation(.portrait)
        }
    }
}

struct EditAnimalListView: View {
    @ObservedObject var viewModel: AnimalViewModel
    @State private var selectedAnimal: Animal?
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.animals.isEmpty {
                    EmptyStateView()
                } else {
                    List {
                        ForEach(viewModel.animals, id: \.id) { animal in
                            AnimalRowView(animal: animal)
                                .onTapGesture {
                                    selectedAnimal = animal
                                }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("tab_edit")
            .sheet(item: $selectedAnimal) { animal in
                EditAnimalView(animal: animal, viewModel: viewModel)
            }
        }
        .onAppear {
            AppDelegate.setOrientation(.portrait)
            viewModel.fetchAnimals()
        }
        .onChange(of: selectedAnimal) { newValue in
            if newValue == nil {
                viewModel.fetchAnimals()
            }
        }
    }
}

#Preview {
    MainTabView(viewContext: PersistenceController.preview.container.viewContext)
        .environmentObject(ThemeManager())
        .environmentObject(LanguageManager())
}

