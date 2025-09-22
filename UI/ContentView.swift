import SwiftUI

struct ContentView: View {
    @StateObject private var store = SequenceStore()
    @StateObject private var engine = TapEngine()
    @State private var activeSequence: TapSequence?

    var body: some View {
        ZStack(alignment: .topLeading) {
            SequenceListView(onRun: { seq in
                activeSequence = seq
                start(seq)
            })
            .environmentObject(store)
            .padding(.top, 60)

            BubbleOverlay { action in
                switch action {
                case .add: /* add a point via Crosshair or current touch */ break
                case .subtract: /* remove last point */ break
                case .start: if let s = activeSequence { start(s) }
                case .stop: engine.stop()
                case .clear: activeSequence = nil
                case .visibility: break
                case .save: /* save current edits */ break
                case .close: /* dismiss overlay in this screen context */ break
                }
            }
            .padding()
        }
    }

    private func start(_ seq: TapSequence) {
        engine.start(sequence: seq) { step in
            // Map (x,y) to your view hierarchy. Example: broadcast a Notification or call a controller:
            // 1) Show a visual indicator:
            UIImpactFeedbackGenerator(style: .light).impactOccurred()

            // 2) If you have a registry of tappable targets, resolve and fire:
            // AppTargetRegistry.shared.fire(at: CGPoint(x: step.x, y: step.y))

            // 3) Or hit-test the key window and call UIControl actions if found:
            if let window = UIApplication.shared.connectedScenes
                .compactMap({ ($0 as? UIWindowScene)?.keyWindow }).first {
                let point = CGPoint(x: step.x, y: step.y)
                if let view = window.hitTest(point, with: nil) as? UIControl {
                    view.sendActions(for: .touchUpInside)
                }
            }
        }
    }
}
