import SwiftUI

struct NewConfigSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var mode: ActionType = .multiPoint
    @State private var boundBundleID: String? = nil
    @State private var steps: [Step] = []
    @State private var pickPoint: CGPoint?
    let onSave: (TapSequence) -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    TextField("Configuration name", text: $name)

                    Text("Bind to app").fontWeight(.bold)
                    HStack {
                        Text(boundBundleID ?? "*")
                        Spacer()
                        Button("Choose App") { /* present your own list of internal targets if needed */ }
                    }

                    Text("Mode").fontWeight(.bold)
                    Picker("", selection: $mode) {
                        ForEach(ActionType.allCases) { Text($0.rawValue).tag($0) }
                    }.pickerStyle(.inline)

                    Divider()
                    Text("Tap points").fontWeight(.bold)

                    ZStack {
                        RoundedRectangle(cornerRadius: 8).stroke(.gray.opacity(0.4))
                            .frame(height: 220)
                        CrosshairPicker(capturedPoint: $pickPoint)
                    }
                    .onChange(of: pickPoint) { p in
                        guard let p else { return }
                        steps.append(Step(x: p.x, y: p.y, duration: mode == .longPress ? 0.6 : 0))
                    }

                    if steps.isEmpty {
                        Text("Tap inside the box to add points.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(steps) { s in
                            Text("• (\(Int(s.x)), \(Int(s.y)))  dur: \(String(format: "%.2f", s.duration))s  delay: \(String(format: "%.2f", s.delayAfter))s")
                                .font(.caption)
                        }
                    }
                }
                .padding(20)
            }
            .navigationTitle("New Configuration")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(TapSequence(name: name.isEmpty ? "Untitled" : name,
                                           boundBundleID: boundBundleID,
                                           mode: mode,
                                           steps: steps))
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
            }
        }
    }
}
