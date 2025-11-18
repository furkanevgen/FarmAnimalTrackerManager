import SwiftUI
import CoreData

struct TrackerView: View {
    @ObservedObject var viewModel: AnimalViewModel
    
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
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        viewModel.deleteAnimal(animal)
                                    } label: {
                                        Label("common_delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("tracker_title")
        }
        .onAppear {
            AppDelegate.setOrientation(.portrait)
        }
    }
}

struct AnimalRowView: View {
    @ObservedObject var animal: Animal
    
    var body: some View {
        HStack(spacing: 16) {
            Text(iconForType(animal.type ?? ""))
                .font(.system(size: 30))
                .frame(width: 50, height: 50)
                .background(Color.accentColor.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(animal.name ?? "Unknown")
                    .font(.headline)
                
                Text(AnimalType.fromString(animal.type ?? "other").localizedName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if let healthStatus = animal.healthStatus {
                    HStack {
                        Circle()
                            .fill(colorForHealthStatus(healthStatus))
                            .frame(width: 8, height: 8)
                        Text(HealthStatus.fromString(healthStatus).localizedName)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
            
            if animal.weight > 0 {
                VStack(alignment: .trailing) {
                    Text("\(Int(animal.weight))")
                        .font(.headline)
                    Text("kg")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
    
    private func iconForType(_ type: String) -> String {
        let animalType = AnimalType.fromString(type)
        switch animalType {
        case .cow: return "🐄"
        case .pig: return "🐷"
        case .chicken: return "🐔"
        case .sheep: return "🐑"
        case .goat: return "🐐"
        case .horse: return "🐴"
        case .other: return "🐾"
        }
    }
    
    private func colorForHealthStatus(_ status: String) -> Color {
        let healthStatus = HealthStatus.fromString(status)
        switch healthStatus {
        case .excellent: return .green
        case .good: return .blue
        case .fair: return .orange
        case .poor: return .red
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "pawprint.fill")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("tracker_empty")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("tracker_empty_description")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#Preview {
    TrackerView(viewModel: AnimalViewModel(viewContext: PersistenceController.preview.container.viewContext))
}

