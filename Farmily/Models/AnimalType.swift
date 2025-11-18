import Foundation

enum AnimalType: String, CaseIterable {
    case cow = "cow"
    case pig = "pig"
    case chicken = "chicken"
    case sheep = "sheep"
    case goat = "goat"
    case horse = "horse"
    case other = "other"
    
    var localizedName: String {
        switch self {
        case .cow:
            return "animal_type_cow".localized
        case .pig:
            return "animal_type_pig".localized
        case .chicken:
            return "animal_type_chicken".localized
        case .sheep:
            return "animal_type_sheep".localized
        case .goat:
            return "animal_type_goat".localized
        case .horse:
            return "animal_type_horse".localized
        case .other:
            return "animal_type_other".localized
        }
    }
    
    static func fromString(_ string: String) -> AnimalType {
        let lowercased = string.lowercased()
        switch lowercased {
        case "cow", "корова":
            return .cow
        case "pig", "свинья":
            return .pig
        case "chicken", "курица":
            return .chicken
        case "sheep", "овца":
            return .sheep
        case "goat", "коза":
            return .goat
        case "horse", "лошадь":
            return .horse
        default:
            return .other
        }
    }
}

enum HealthStatus: String, CaseIterable, Hashable {
    case excellent = "excellent"
    case good = "good"
    case fair = "fair"
    case poor = "poor"
    
    var localizedName: String {
        switch self {
        case .excellent:
            return "health_excellent".localized
        case .good:
            return "health_good".localized
        case .fair:
            return "health_fair".localized
        case .poor:
            return "health_poor".localized
        }
    }
    
    static func fromString(_ string: String) -> HealthStatus {
        let lowercased = string.lowercased()
        switch lowercased {
        case "excellent", "отличное":
            return .excellent
        case "good", "хорошее":
            return .good
        case "fair", "удовлетворительное":
            return .fair
        case "poor", "плохое":
            return .poor
        case "under treatment", "на лечении", "treatment":
            return .good
        default:
            return .good
        }
    }
}

