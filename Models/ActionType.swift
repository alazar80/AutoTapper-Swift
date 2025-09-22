import Foundation

enum ActionType: String, Codable, CaseIterable, Identifiable {
    case singleTap = "SINGLE_TAP"
    case longPress = "LONG_PRESS"
    case multiPoint = "MULTI_POINT"

    var id: String { rawValue }
}
