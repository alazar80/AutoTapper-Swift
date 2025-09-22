import SwiftUI

struct SequenceListView: View {
    @EnvironmentObject var store: SequenceStore
    var onRun: (TapSequence) -> Void
    @State private var showingNew = false

    var body: some View {
        VStack {
            if store.sequences.isEmpty {
                Text("No configurations yet").foregroundStyle(.secondary)
            } else {
                List {
                    ForEach(store.sequences) { seq in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(seq.name).fontWeight(.bold)
                            Text(seq.mode.rawValue).font(.caption)
                            if let pkg = seq.boundBundleID {
                                Text(pkg).font(.caption2).foregroundStyle(.secondary)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture { onRun(seq) }
                    }
                    .onDelete { idx in
                        idx.map { store.sequences[$0] }.forEach(store.remove)
                    }
                }
            }

            HStack {
                Button("Create New Config") { showingNew = true }
                Spacer()
                Button("Import") { /* JSON import from file */ }
            }
            .padding(.horizontal)
        }
        .sheet(isPresented: $showingNew) {
            NewConfigSheet { store.add($0) }
        }
    }
}
