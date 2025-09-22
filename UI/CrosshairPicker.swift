import SwiftUI

struct CrosshairPicker: View {
    @Binding var capturedPoint: CGPoint?
    @GestureState private var current: CGPoint? = nil

    var body: some View {
        GeometryReader { geo in
            Color.clear
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                    .updating($current) { val, state, _ in
                        state = val.location
                    }
                    .onEnded { val in
                        capturedPoint = val.location
                    }
                )
                .overlay(
                    Group {
                        if let p = current ?? capturedPoint {
                            Image(systemName: "scope")
                                .font(.system(size: 28))
                                .opacity(0.9)
                                .position(p)
                        }
                    }
                )
        }
    }
}
