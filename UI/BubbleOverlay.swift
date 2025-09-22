import SwiftUI

struct BubbleOverlay: View {
    enum BubbleAction { case add, subtract, start, stop, clear, visibility, save, close }

    var onAction: (BubbleAction) -> Void
    @State private var offset: CGSize = .zero
    @State private var isHidden = false

    var body: some View {
        VStack(spacing: 8) {
            Group {
                button("Add", .add)
                button("Sub", .subtract)
                button("Start", .start)
                button("Stop", .stop)
                button("Clear", .clear)
                button(isHidden ? "Show" : "Hide", .visibility)
                button("Save", .save)
                button("Close", .close)
            }
        }
        .padding(8)
        .background(.thinMaterial)
        .cornerRadius(10)
        .shadow(radius: 6)
        .opacity(isHidden ? 0.35 : 1)
        .offset(offset)
        .gesture(
            DragGesture()
                .onChanged { offset = $0.translation }
        )
        .onChange(of: isHidden) { _ in } // keep for parity with Android button
    }

    private func button(_ title: String, _ action: BubbleAction) -> some View {
        Button(title) { 
            if action == .visibility { isHidden.toggle() }
            onAction(action) 
        }.font(.system(size: 12))
    }
}
