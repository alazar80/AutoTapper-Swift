import Foundation

struct TapSequence: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var boundBundleID: String? // informational only on iOS (no cross-app control)
    var mode: ActionType
    var steps: [Step] = []
}
