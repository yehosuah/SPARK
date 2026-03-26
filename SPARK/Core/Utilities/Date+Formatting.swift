import Foundation

extension Date {
    var timeGreeting: String {
        let hour = Calendar.current.component(.hour, from: self)
        switch hour {
        case 5..<12:
            return "Good morning"
        case 12..<17:
            return "Good afternoon"
        default:
            return "Good evening"
        }
    }

    func relativeDayDescription(reference: Date = .now) -> String {
        let days = Calendar.current.dateComponents([.day], from: self, to: reference).day ?? 0
        if days <= 0 {
            return "Today"
        }
        if days == 1 {
            return "Yesterday"
        }
        return "\(days) days ago"
    }
}
