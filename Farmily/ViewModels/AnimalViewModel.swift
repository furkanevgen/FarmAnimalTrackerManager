import Foundation
import CoreData
import SwiftUI
import Combine

class AnimalViewModel: ObservableObject {
    @Published var animals: [Animal] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        DispatchQueue.main.async {
            self.fetchAnimals()
        }
    }
    
    func fetchAnimals() {
        isLoading = true
        let request: NSFetchRequest<Animal> = Animal.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Animal.createdAt, ascending: false)]
        
        do {
            let fetchedAnimals = try viewContext.fetch(request)
            for animal in fetchedAnimals {
                viewContext.refresh(animal, mergeChanges: true)
            }
            animals = fetchedAnimals
            isLoading = false
            objectWillChange.send()
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    func addAnimal(
        name: String,
        type: String,
        breed: String?,
        birthDate: Date?,
        weight: Double?,
        healthStatus: String?,
        notes: String?
    ) {
        let newAnimal = Animal(context: viewContext)
        newAnimal.id = UUID()
        newAnimal.name = name
        newAnimal.type = type
        newAnimal.breed = breed
        newAnimal.birthDate = birthDate
        newAnimal.weight = weight ?? 0.0
        newAnimal.healthStatus = healthStatus
        newAnimal.notes = notes
        newAnimal.createdAt = Date()
        newAnimal.updatedAt = Date()
        
        saveContext()
    }
    
    func updateAnimal(
        _ animal: Animal,
        name: String,
        type: String,
        breed: String?,
        birthDate: Date?,
        weight: Double?,
        healthStatus: String?,
        notes: String?
    ) {
        animal.name = name
        animal.type = type
        animal.breed = breed
        animal.birthDate = birthDate
        animal.weight = weight ?? 0.0
        animal.healthStatus = healthStatus
        animal.notes = notes
        animal.updatedAt = Date()
        
        do {
            try viewContext.save()
            viewContext.refresh(animal, mergeChanges: true)
            fetchAnimals()
            objectWillChange.send()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteAnimal(_ animal: Animal) {
        viewContext.delete(animal)
        saveContext()
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
            fetchAnimals()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func getStatistics() -> AnimalStatistics {
        let total = animals.count
        var byType: [String: Int] = [:]
        var healthStatus: [String: Int] = [:]
        var totalWeight: Double = 0
        var weightCount = 0
        
        for animal in animals {
            byType[animal.type ?? "Unknown", default: 0] += 1
            if let status = animal.healthStatus {
                healthStatus[status, default: 0] += 1
            }
            if animal.weight > 0 {
                totalWeight += animal.weight
                weightCount += 1
            }
        }
        
        let averageWeight = weightCount > 0 ? totalWeight / Double(weightCount) : 0
        
        return AnimalStatistics(
            total: total,
            byType: byType,
            healthStatus: healthStatus,
            averageWeight: averageWeight
        )
    }
}

struct AnimalStatistics {
    let total: Int
    let byType: [String: Int]
    let healthStatus: [String: Int]
    let averageWeight: Double
}

