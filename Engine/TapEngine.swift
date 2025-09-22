import UIKit

final class TapEngine: ObservableObject {
    @Published private(set) var isRunning = false
    private var workItem: DispatchWorkItem?

    /// Provide a handler to "apply" a step in your UI.
    /// You decide what a (x,y) means: e.g., hit-testing your root view or mapping to specific controls.
    typealias StepHandler = (_ step: Step) -> Void

    func start(sequence: TapSequence, stepHandler: @escaping StepHandler) {
        stop()
        isRunning = true

        let item = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            for step in sequence.steps {
                if item.isCancelled { break }

                // Execute the "tap/press" inside your app.
                DispatchQueue.main.sync {
                    stepHandler(step)
                }

                // Simulate long press dwell if needed
                if step.duration > 0 {
                    Thread.sleep(forTimeInterval: step.duration)
                }

                // Delay after step
                Thread.sleep(forTimeInterval: max(0, step.delayAfter))
            }
            DispatchQueue.main.async { self.isRunning = false }
        }

        workItem = item
        DispatchQueue.global(qos: .userInitiated).async(execute: item)
    }

    func stop() {
        workItem?.cancel()
        workItem = nil
        isRunning = false
    }
}
