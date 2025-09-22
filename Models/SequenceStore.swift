import Foundation

final class SequenceStore: ObservableObject {
    @Published private(set) var sequences: [TapSequence] = []
    private let key = "tap_sequences_v1"

    init() { load() }

    func add(_ seq: TapSequence) {
        sequences.append(seq); save()
    }

    func update(_ seq: TapSequence) {
        guard let idx = sequences.firstIndex(where: { $0.id == seq.id }) else { return }
        sequences[idx] = seq; save()
    }

    func remove(_ seq: TapSequence) {
        sequences.removeAll { $0.id == seq.id }; save()
    }

    private func save() {
        if let data = try? JSONEncoder().encode(sequences) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let list = try? JSONDecoder().decode([TapSequence].self, from: data) else { return }
        sequences = list
    }
}
