import CoreGraphics

struct Step: Identifiable, Codable, Equatable {
    var id = UUID()
    var x: CGFloat
    var y: CGFloat
    var duration: TimeInterval  // for long press; 0 for tap
    var delayAfter: TimeInterval // wait before next step

    init(x: CGFloat, y: CGFloat, duration: TimeInterval = 0, delayAfter: TimeInterval = 0.15) {
        self.x = x; self.y = y; self.duration = duration; self.delayAfter = delayAfter
    }
}
