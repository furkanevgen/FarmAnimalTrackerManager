import SwiftUI
import CoreData

struct StatisticsView: View {
    @ObservedObject var viewModel: AnimalViewModel
    
    var statistics: AnimalStatistics {
        viewModel.getStatistics()
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    StatCard(
                        title: "statistics_total",
                        value: "\(statistics.total)",
                        icon: "pawprint.fill",
                        color: .blue
                    )
                    
                    StatCard(
                        title: "statistics_average_weight",
                        value: String(format: "%.1f kg", statistics.averageWeight),
                        icon: "scalemass.fill",
                        color: .green
                    )
                    
                    if !statistics.byType.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("statistics_by_type")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ForEach(Array(statistics.byType.keys.sorted()), id: \.self) { type in
                                StatRow(
                                    label: AnimalType.fromString(type).localizedName,
                                    value: "\(statistics.byType[type] ?? 0)",
                                    color: .orange
                                )
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    
                    if !statistics.healthStatus.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("statistics_health")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ForEach(Array(statistics.healthStatus.keys.sorted()), id: \.self) { status in
                                StatRow(
                                    label: HealthStatus.fromString(status).localizedName,
                                    value: "\(statistics.healthStatus[status] ?? 0)",
                                    color: .purple
                                )
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("statistics_title")
        }
        .onAppear {
            AppDelegate.setOrientation(.portrait)
        }
    }
}

struct StatCard: View {
    let title: LocalizedStringKey
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(color)
                .frame(width: 50)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct StatRow: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            
            Text(label)
                .font(.body)
            
            Spacer()
            
            Text(value)
                .font(.headline)
                .foregroundColor(color)
        }
        .padding(.horizontal)
    }
}

#Preview {
    StatisticsView(viewModel: AnimalViewModel(viewContext: PersistenceController.preview.container.viewContext))
}

