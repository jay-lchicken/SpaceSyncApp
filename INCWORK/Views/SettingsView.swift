//
//  SettingsView.swift
//  HELIPOP
//
//  Created by Lai Hong Yu on 9/10/24.
//

import SwiftUI
import UniformTypeIdentifiers
struct SettingsView: View {
    @ObservedObject var viewModel: LogManagementViewModel
    @State private var selectedFileURL: URL? = nil
    @AppStorage("darkMode") var darkMode: Bool = false
    @State private var isImporting = false
    @State private var isExporting = false
    @State private var exportUrl: URL?
    @State var showSecondAlert: Bool = false
    @State var showSuccess = false
    @AppStorage("isINC") var isINC: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Toggle(isOn: $darkMode) {
                        Text("Dark Mode: \(darkMode ? "On" : "Off")")
                    }
                    
                    Picker("Font Size: \(viewModel.fontSize.hashValue)", selection: $viewModel.fontSize) {
                        Text("Extra Small").tag(ContentSizeCategory.extraSmall)
                        Text("Small").tag(ContentSizeCategory.small)
                        Text("Medium").tag(ContentSizeCategory.medium)
                        Text("Large").tag(ContentSizeCategory.large)
                        Text("Extra Large").tag(ContentSizeCategory.extraLarge)
                        Text("Extra Extra Large").tag(ContentSizeCategory.extraExtraLarge)
                        Text("Extra Extra Extra Large").tag(ContentSizeCategory.extraExtraExtraLarge)
                        Text("Accessibility Medium").tag(ContentSizeCategory.accessibilityMedium)
                        Text("Accessibility Large").tag(ContentSizeCategory.accessibilityLarge)
                        Text("Accessibility Extra Large").tag(ContentSizeCategory.accessibilityExtraLarge)
                        Text("Accessibility XX Large").tag(ContentSizeCategory.accessibilityExtraExtraLarge)
                        Text("Accessibility XXX Large").tag(ContentSizeCategory.accessibilityExtraExtraExtraLarge)
                    }
                    .pickerStyle(WheelPickerStyle())
                    .padding()
                    .frame(width: 350)
                    
                    Button(action: {
                        isExporting = true
                    }) {
                        HStack{
                            Label("Export Logs", systemImage: "square.and.arrow.up")
                            Spacer()
                        }
                    }
                    .padding()
                    .frame(width: 350)
                    .fileExporter(
                        isPresented: $isExporting,
                        document: ExportDocument(data: exportData()),
                        contentType: .json,
                        defaultFilename: "logs"
                    ) { result in
                        switch result {
                        case .success(let url):
                            showSuccess = true
                            print("Exported to: \(url)")
                        case .failure(let error):
                            print("Failed to export: \(error.localizedDescription)")
                        }
                    }
                    
                    Button(action: {
                        viewModel.showAlert = true
                    }) {
                        HStack{
                            Label("Import Logs", systemImage: "square.and.arrow.down")
                            Spacer()
                        }
                        
                    }
                    .fileImporter(
                        isPresented: $isImporting,
                        allowedContentTypes: [.json],
                        allowsMultipleSelection: false
                    ) { result in
                        do {
                            guard let selectedFile: URL = try result.get().first else { return }
                            if selectedFile.startAccessingSecurityScopedResource(){
                                importLogs(from: selectedFile)
                            }
                            selectedFile.stopAccessingSecurityScopedResource()
                            showSuccess = true
                        } catch {
                            print("Failed to import: \(error.localizedDescription)")
                        }
                    }
                    Button{
                        isINC = false
                    }label: {
                        Label("Go Back To SpaceSync", systemImage: "arrow.2.circlepath.circlepath.circle")
                    }
                }
                .navigationTitle("Settings")
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
                    Alert(
                        title: Text("Confirm Importation"),
                        message: Text("Importing the new data will delete all existing data. Are you sure you want to continue? You may want to export your current data first."),
                        primaryButton: .destructive(Text("Delete and Import")) {
                            isImporting = true
                        },
                        secondaryButton: .cancel()
                    )
                }

        .sheet(isPresented: $showSuccess){
            SuccessView()
        }
    }
    
    func exportData() -> Data {
        let encoder = JSONEncoder()
        do {
            return try encoder.encode(viewModel.logs)
        } catch {
            print("Error encoding logs: \(error)")
            return Data()
        }
    }
    
    func importLogs(from url: URL) {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let importedLogs = try decoder.decode([log].self, from: data)
            viewModel.logs = importedLogs
            viewModel.sync()

        } catch {
            print("Error decoding logs: \(error)")
        }
    }
}
struct ExportDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.json] }
    var data: Data

    init(data: Data) {
        self.data = data
    }

    init(configuration: ReadConfiguration) throws {
        self.data = Data()
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: data)
    }
}
