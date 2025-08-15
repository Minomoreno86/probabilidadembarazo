import SwiftUI

struct FontSelectionView: View {
    @EnvironmentObject var userFontManager: UserFontManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(UserFontManager.FontFamily.allCases, id: \.self) { fontFamily in
                        FontOptionRow(
                            fontFamily: fontFamily,
                            isSelected: userFontManager.selectedFontFamily == fontFamily
                        ) {
                            userFontManager.setFontFamily(fontFamily)
                        }
                    }
                } header: {
                    Text("Selecciona una fuente")
                        .font(.headline)
                } footer: {
                    Text("La fuente seleccionada se aplicará a toda la aplicación. Los cambios se guardan automáticamente.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Vista previa")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Título Principal")
                                .font(userFontManager.title)
                                .foregroundColor(.primary)
                            
                            Text("Resultado del pronóstico: 85%")
                                .font(userFontManager.data)
                                .foregroundColor(.blue)
                            
                            Text("Información médica importante que debe ser legible para todos los usuarios.")
                                .font(userFontManager.info)
                                .foregroundColor(.secondary)
                            
                            HStack {
                                Text("Texto Normal")
                                    .font(userFontManager.body)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Text("Texto Bold")
                                    .font(userFontManager.customBoldFont(size: 16))
                                    .foregroundColor(.primary)
                            }
                            
                            Button("Botón de ejemplo") {
                                // Acción de ejemplo
                            }
                            .font(userFontManager.button)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                    .padding(.vertical, 8)
                } header: {
                    Text("Vista previa")
                        .font(.headline)
                }
            }
            .navigationTitle("Tipografía")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Listo") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct FontOptionRow: View {
    let fontFamily: UserFontManager.FontFamily
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(fontFamily.displayName)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(fontFamily.previewText)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title2)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    FontSelectionView()
        .environmentObject(UserFontManager())
}
