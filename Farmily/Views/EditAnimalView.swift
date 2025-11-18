import SwiftUI
import CoreData

struct EditAnimalView: View {
    let animal: Animal
    @ObservedObject var viewModel: AnimalViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String
    @State private var selectedType: AnimalType
    @State private var breed: String
    @State private var birthDate: Date
    @State private var hasBirthDate: Bool
    @State private var weight: String
    @State private var selectedHealthStatus: HealthStatus
    @State private var notes: String
    @State private var showSuccessAlert = false
    @State private var showDeleteAlert = false
    
    init(animal: Animal, viewModel: AnimalViewModel) {
        self.animal = animal
        self.viewModel = viewModel
        
        _name = State(initialValue: animal.name ?? "")
        _selectedType = State(initialValue: AnimalType.fromString(animal.type ?? "cow"))
        _breed = State(initialValue: animal.breed ?? "")
        _birthDate = State(initialValue: animal.birthDate ?? Date())
        _hasBirthDate = State(initialValue: animal.birthDate != nil)
        _weight = State(initialValue: animal.weight > 0 ? String(Int(animal.weight)) : "")
        _selectedHealthStatus = State(initialValue: HealthStatus.fromString(animal.healthStatus ?? "good"))
        _notes = State(initialValue: animal.notes ?? "")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("add_animal_name")) {
                    TextField("add_animal_name", text: $name)
                }
                
                Section(header: Text("add_animal_type")) {
                    Picker("add_animal_type", selection: $selectedType) {
                        ForEach(AnimalType.allCases, id: \.self) { type in
                            Text(type.localizedName).tag(type)
                        }
                    }
                }
                
                Section(header: Text("add_animal_breed")) {
                    TextField("add_animal_breed", text: $breed)
                }
                
                Section(header: Text("add_animal_birth_date")) {
                    Toggle("add_animal_birth_date", isOn: $hasBirthDate)
                    if hasBirthDate {
                        DatePicker("", selection: $birthDate, displayedComponents: .date)
                    }
                }
                
                Section(header: Text("add_animal_weight")) {
                    TextField("add_animal_weight", text: $weight)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("add_animal_health_status")) {
                    Picker("add_animal_health_status", selection: $selectedHealthStatus) {
                        ForEach(HealthStatus.allCases, id: \.self) { status in
                            Text(status.localizedName).tag(status)
                        }
                    }
                }
                
                Section(header: Text("add_animal_notes")) {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                }
                
                Section {
                    Button(role: .destructive, action: {
                        showDeleteAlert = true
                    }) {
                        HStack {
                            Spacer()
                            Text("edit_animal_delete")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("edit_animal_title")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("common_cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("edit_animal_save") {
                        saveAnimal()
                    }
                    .disabled(name.isEmpty)
                }
            }
            .alert("add_animal_success", isPresented: $showSuccessAlert) {
                Button("common_ok") {
                    viewModel.fetchAnimals()
                    dismiss()
                }
            }
            .alert("edit_animal_delete_confirm_title", isPresented: $showDeleteAlert) {
                Button("common_cancel", role: .cancel) {}
                Button("common_delete", role: .destructive) {
                    deleteAnimal()
                }
            } message: {
                Text("edit_animal_delete_confirm")
            }
        }
        .onAppear {
            AppDelegate.setOrientation(.portrait)
        }
    }
    
    private func saveAnimal() {
        let weightValue = Double(weight) ?? 0.0
        let birthDateValue = hasBirthDate ? birthDate : nil
        
        viewModel.updateAnimal(
            animal,
            name: name,
            type: selectedType.rawValue,
            breed: breed.isEmpty ? nil : breed,
            birthDate: birthDateValue,
            weight: weightValue > 0 ? weightValue : nil,
            healthStatus: selectedHealthStatus.rawValue,
            notes: notes.isEmpty ? nil : notes
        )
        
        showSuccessAlert = true
    }
    
    private func deleteAnimal() {
        viewModel.deleteAnimal(animal)
        dismiss()
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let animal = Animal(context: context)
    animal.id = UUID()
    animal.name = "Test Animal"
    animal.type = "Cow"
    return EditAnimalView(animal: animal, viewModel: AnimalViewModel(viewContext: context))
}

