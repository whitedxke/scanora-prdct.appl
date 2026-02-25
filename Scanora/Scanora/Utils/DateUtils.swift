import Foundation

extension Date {
    private static let eventDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.locale = Locale(
            identifier: "ru_RU",
        )
        formatter.dateFormat = "d MMMM yyyy HH:mm"
        
        return formatter
    }()

    var eventDisplayText: String {
        let rawText = Self.eventDateFormatter.string(
            from: self,
        )
        
        guard let first = rawText.first else {
            return rawText
        }
        
        return String(first).uppercased() + rawText.dropFirst()
    }
}
