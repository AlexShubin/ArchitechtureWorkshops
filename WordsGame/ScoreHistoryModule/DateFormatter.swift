import Foundation

struct ModuleDateFormatter {
    var format: (Date) -> String

    private static func makeFormatter(dateStyle: DateFormatter.Style,
                                      timeStyle: DateFormatter.Style) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter
    }

    static func make(dateFormatter: DateFormatter) -> ModuleDateFormatter {
        ModuleDateFormatter { dateFormatter.string(from: $0) }
    }

    static let medium = make(dateFormatter: makeFormatter(dateStyle: .medium,
                                                          timeStyle: .medium))
}
