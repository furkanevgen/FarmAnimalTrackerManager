import SwiftUI
import CoreData

struct AddAnimalView: View {
    @ObservedObject var viewModel: AnimalViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var selectedType: AnimalType = .cow
    @State private var breed = ""
    @State private var birthDate = Date()
    @State private var hasBirthDate = false
    @State private var weight = ""
    @State private var selectedHealthStatus: HealthStatus = .excellent
    @State private var notes = ""
    @State private var showSuccessAlert = false
    
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
            }
            .navigationTitle("add_animal_title")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("add_animal_cancel") {
                        hideKeyboard()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("add_animal_save") {
                        saveAnimal()
                    }
                    .disabled(name.isEmpty)
                }
            }
            .alert("add_animal_success", isPresented: $showSuccessAlert) {
                Button("common_ok") {
                    dismiss()
                }
            }
        }
        .onAppear {
            AppDelegate.setOrientation(.portrait)
        }
    }
    
    private func saveAnimal() {
        let weightValue = Double(weight) ?? 0.0
        let birthDateValue = hasBirthDate ? birthDate : nil
        
        viewModel.addAnimal(
            name: name,
            type: selectedType.rawValue,
            breed: breed.isEmpty ? nil : breed,
            birthDate: birthDateValue,
            weight: weightValue > 0 ? weightValue : nil,
            healthStatus: selectedHealthStatus.rawValue,
            notes: notes.isEmpty ? nil : notes
        )
        
        clearFields()
        hideKeyboard()
        showSuccessAlert = true
    }
    
    private func clearFields() {
        name = ""
        selectedType = .cow
        breed = ""
        birthDate = Date()
        hasBirthDate = false
        weight = ""
        selectedHealthStatus = .excellent
        notes = ""
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    AddAnimalView(viewModel: AnimalViewModel(viewContext: PersistenceController.preview.container.viewContext))
}

