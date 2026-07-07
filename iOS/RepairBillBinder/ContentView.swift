import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showingAdd = false
    @State private var showingPaywall = false
    @State private var showingSettings = false
    @State private var editingEntry: ReceiptEntry?

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                List {
                    if store.entries.isEmpty {
                        Text("No receipt entries yet. Tap + to add your first one.")
                            .font(Theme.bodyFont)
                            .foregroundStyle(Theme.textSecondary)
                            .listRowBackground(Color.clear)
                    }
                    ForEach(store.entries) { entry in
                        Button {
                            editingEntry = entry
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("entry.shop".isEmpty ? "Receipt" : "entry.shop")
                                    .font(Theme.bodyFont).bold()
                                Text(entry.date, style: .date)
                                    .font(Theme.captionFont)
                                    .foregroundStyle(Theme.textSecondary)
                            }
                        }
                        .accessibilityIdentifier("entryRow_\(entry.id.uuidString)")
                    }
                    .onDelete(perform: store.delete)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Repair Bill Binder")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.canAddMore {
                            showingAdd = true
                        } else {
                            showingPaywall = true
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityIdentifier("addButton")
                }
            }
            .sheet(isPresented: $showingAdd) {
                EntryEditorView(entry: nil) { newEntry in
                    store.add(newEntry)
                }
            }
            .sheet(item: $editingEntry) { entry in
                EntryEditorView(entry: entry) { updated in
                    store.update(updated)
                }
            }
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
        .tint(Theme.accent)
    }
}

struct EntryEditorView: View {
    @Environment(\.dismiss) var dismiss
    @State private var draft: ReceiptEntry
    var onSave: (ReceiptEntry) -> Void

    init(entry: ReceiptEntry?, onSave: @escaping (ReceiptEntry) -> Void) {
        _draft = State(initialValue: entry ?? ReceiptEntry())
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            Form {
                DatePicker("Date", selection: $draft.date, displayedComponents: .date)
                    .accessibilityIdentifier("field_date")
                TextField("Shop / vendor", text: $draft.shop)
                    .accessibilityIdentifier("field_shop")
                TextField("Cost", value: $draft.cost, format: .number)
                    .keyboardType(.decimalPad)
                    .accessibilityIdentifier("field_cost")
                TextField("Notes", text: $draft.notes, axis: .vertical)
                    .accessibilityIdentifier("field_notes")
            }
            .onTapGesture {
                hideKeyboard()
            }
            .navigationTitle("Receipt Entry")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .accessibilityIdentifier("cancelButton")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(draft)
                        dismiss()
                    }
                    .accessibilityIdentifier("saveButton")
                }
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    ContentView()
        .environmentObject(Store())
        .environmentObject(PurchaseManager())
}
