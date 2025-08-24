//
//  InteractionsVisualizationView.swift
//  Pronostico fertilidad
//
//  Vista de Visualización de Interacciones No Lineales
//  Diagramas interactivos y gráficos para mostrar interacciones complejas
//

import SwiftUI
import Charts

// MARK: - 📊 VISTA PRINCIPAL DE VISUALIZACIONES

struct InteractionsVisualizationView: View {
    let interactionsReport: NonLinearInteractionsReport
    @State private var selectedInteraction: NonLinearInteractionsEngine.ClinicalInteraction?
    @State private var showingDetails = false
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var localizationManager: LocalizationManager
    @Environment(\.themeColors) var colors
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // HEADER
                headerSection
                
                if interactionsReport.hasInteractions {
                    // RESUMEN VISUAL
                    summaryCardsSection
                    
                    // DIAGRAMA DE RED
                    networkDiagramSection
                    
                    // GRÁFICO DE MULTIPLICADORES
                    multipliersChartSection
                    
                    // LISTA DETALLADA
                    detailedListSection
                    
                } else {
                    noInteractionsSection
                }
            }
            .padding()
        }
        .navigationTitle("🔄 Interacciones No Lineales")
        .sheet(isPresented: $showingDetails) {
            if let interaction = selectedInteraction {
                InteractionDetailView(interaction: interaction)
            }
        }
    }
    
    // MARK: - 📋 HEADER SECTION
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "network")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading) {
                    Text(localizationManager.getLocalizedString("Interacciones Detectadas"))
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(localizationManager.getLocalizedString("Factores que se potencian entre sí"))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            if interactionsReport.hasInteractions {
                HStack {
                    VStack {
                        Text("\(interactionsReport.detectedInteractions.count)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        Text(localizationManager.getLocalizedString("Total"))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("\(String(format: "%.0f", interactionsReport.finalMultiplier * 100))%")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(multiplierColor(interactionsReport.finalMultiplier))
                        Text(localizationManager.getLocalizedString("Probabilidad Final"))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("\(interactionsReport.criticalInteractionsCount)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                        Text(localizationManager.getLocalizedString("Críticas"))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }
        }
    }
    
    // MARK: - 📊 SUMMARY CARDS
    
    private var summaryCardsSection: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 12) {
            
            SummaryCard(
                title: "🚨 Críticas",
                value: "\(interactionsReport.criticalInteractionsCount)",
                color: .red,
                description: "Cambio obligatorio"
            )
            
            SummaryCard(
                title: "⚡ Altas",
                value: "\(interactionsReport.highPriorityInteractionsCount)",
                color: .orange,
                description: "Modifican tratamiento"
            )
            
            SummaryCard(
                title: "💊 Moderadas",
                value: "\(interactionsReport.detectedInteractions.count - interactionsReport.criticalInteractionsCount - interactionsReport.highPriorityInteractionsCount)",
                color: .blue,
                description: "Ajustes menores"
            )
        }
    }
    
    // MARK: - 🕸️ NETWORK DIAGRAM
    
    private var networkDiagramSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(localizationManager.getLocalizedString("🕸️ Diagrama de Red"))
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(localizationManager.getLocalizedString("Visualización de cómo interactúan los factores"))
                .font(.caption)
                .foregroundColor(.secondary)
            
            InteractionsNetworkView(interactions: interactionsReport.detectedInteractions) { interaction in
                selectedInteraction = interaction
                showingDetails = true
            }
            .frame(height: 300)
            .background(Color.gray.opacity(0.05))
            .cornerRadius(12)
        }
    }
    
    // MARK: - 📈 MULTIPLIERS CHART
    
    private var multipliersChartSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(localizationManager.getLocalizedString("📈 Impacto de Multiplicadores"))
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(localizationManager.getLocalizedString("Efecto acumulativo sobre la probabilidad base"))
                .font(.caption)
                .foregroundColor(.secondary)
            
            if #available(iOS 16.0, macOS 13.0, *) {
                Chart {
                    ForEach(Array(interactionsReport.detectedInteractions.enumerated()), id: \.offset) { index, interaction in
                        BarMark(
                            x: .value("Interacción", interaction.name.prefix(20) + "..."),
                            y: .value("Multiplicador", interaction.multiplier)
                        )
                        .foregroundStyle(priorityColor(interaction.priority))
                        .opacity(0.8)
                    }
                }
                .frame(height: 200)
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisGridLine()
                        AxisValueLabel {
                            if let doubleValue = value.as(Double.self) {
                                Text("\(Int(doubleValue * 100))%")
                                    .font(.caption)
                            }
                        }
                    }
                }
                .chartXAxis {
                    AxisMarks { _ in
                        AxisValueLabel()
                            .font(.caption2)
                    }
                }
            } else {
                // Fallback para versiones anteriores
                VStack {
                    ForEach(interactionsReport.detectedInteractions, id: \.name) { interaction in
                        HStack {
                            Text(interaction.name.prefix(25) + "...")
                                .font(.caption)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            Rectangle()
                                .fill(priorityColor(interaction.priority))
                                .frame(width: CGFloat(interaction.multiplier * 200), height: 20)
                                .cornerRadius(4)
                            
                            Text("\(String(format: "%.0f", interaction.multiplier * 100))%")
                                .font(.caption)
                                .fontWeight(.medium)
                                .frame(width: 40, alignment: .trailing)
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(12)
            }
        }
    }
    
    // MARK: - 📋 DETAILED LIST
    
    private var detailedListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(localizationManager.getLocalizedString("📋 Detalles de Interacciones"))
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVStack(spacing: 8) {
                ForEach(interactionsReport.detectedInteractions, id: \.name) { interaction in
                    InteractionRowView(interaction: interaction) {
                        selectedInteraction = interaction
                        showingDetails = true
                    }
                }
            }
        }
    }
    
    // MARK: - ❌ NO INTERACTIONS
    
    private var noInteractionsSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
            
            Text(localizationManager.getLocalizedString("✅ Sin Interacciones Detectadas"))
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(localizationManager.getLocalizedString("No se encontraron interacciones no lineales significativas en este perfil."))
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Text(localizationManager.getLocalizedString("Esto significa que los factores actúan de forma independiente y las probabilidades calculadas no requieren ajustes adicionales."))
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
        }
        .padding(40)
        .background(Color.green.opacity(0.1))
        .cornerRadius(16)
    }
    
    // MARK: - 🎨 HELPER FUNCTIONS
    
    private func multiplierColor(_ multiplier: Double) -> Color {
        switch multiplier {
        case 0.0..<0.2: return .red
        case 0.2..<0.5: return .orange
        case 0.5..<0.8: return .yellow
        default: return .green
        }
    }
    
    private func priorityColor(_ priority: NonLinearInteractionsEngine.InteractionPriority) -> Color {
        switch priority {
        case .critical: return .red
        case .high: return .orange
        case .moderate: return .blue
        case .low: return .gray
        }
    }
}

// MARK: - 📊 SUMMARY CARD

struct SummaryCard: View {
    let title: String
    let value: String
    let color: Color
    let description: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(description)
                .font(.caption2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - 🕸️ NETWORK VIEW

struct InteractionsNetworkView: View {
    let interactions: [NonLinearInteractionsEngine.ClinicalInteraction]
    let onInteractionTapped: (NonLinearInteractionsEngine.ClinicalInteraction) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Color.clear
                
                // Connections (lines between nodes)
                ForEach(Array(interactions.enumerated()), id: \.offset) { index, interaction in
                    let position = nodePosition(for: index, in: geometry.size, total: interactions.count)
                    let centerPosition = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    
                    Path { path in
                        path.move(to: centerPosition)
                        path.addLine(to: position)
                    }
                    .stroke(priorityColor(interaction.priority).opacity(0.3), lineWidth: 2)
                }
                
                // Center node (Patient)
                Circle()
                    .fill(Color.blue)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text("👤")
                            .font(.title2)
                    )
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                
                // Interaction nodes
                ForEach(Array(interactions.enumerated()), id: \.offset) { index, interaction in
                    let position = nodePosition(for: index, in: geometry.size, total: interactions.count)
                    
                    Button(action: {
                        onInteractionTapped(interaction)
                    }) {
                        VStack(spacing: 4) {
                            Circle()
                                .fill(priorityColor(interaction.priority))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Text(priorityEmoji(interaction.priority))
                                        .font(.title3)
                                )
                            
                            Text("\(String(format: "%.0f", interaction.multiplier * 100))%")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(priorityColor(interaction.priority))
                        }
                    }
                    .position(position)
                }
            }
        }
    }
    
    private func nodePosition(for index: Int, in size: CGSize, total: Int) -> CGPoint {
        let angle = (2 * .pi * Double(index)) / Double(total) - .pi / 2
        let radius = min(size.width, size.height) / 3
        let centerX = size.width / 2
        let centerY = size.height / 2
        
        return CGPoint(
            x: centerX + CoreGraphics.cos(angle) * radius,
            y: centerY + CoreGraphics.sin(angle) * radius
        )
    }
    
    private func priorityColor(_ priority: NonLinearInteractionsEngine.InteractionPriority) -> Color {
        switch priority {
        case .critical: return .red
        case .high: return .orange
        case .moderate: return .blue
        case .low: return .gray
        }
    }
    
    private func priorityEmoji(_ priority: NonLinearInteractionsEngine.InteractionPriority) -> String {
        switch priority {
        case .critical: return "🚨"
        case .high: return "⚡"
        case .moderate: return "💊"
        case .low: return "🌱"
        }
    }
}

// MARK: - 📋 INTERACTION ROW

struct InteractionRowView: View {
    let interaction: NonLinearInteractionsEngine.ClinicalInteraction
    let onTap: () -> Void
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Priority indicator
                Circle()
                    .fill(priorityColor(interaction.priority))
                    .frame(width: 12, height: 12)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(interaction.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
                    Text(interaction.conditions)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(String(format: "%.0f", interaction.multiplier * 100))%")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(multiplierColor(interaction.multiplier))
                    
                    if interaction.forcesTreatmentChange {
                        Text(localizationManager.getLocalizedString("Cambio obligatorio"))
                            .font(.caption2)
                            .foregroundColor(.red)
                    }
                }
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.gray.opacity(0.05))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func priorityColor(_ priority: NonLinearInteractionsEngine.InteractionPriority) -> Color {
        switch priority {
        case .critical: return .red
        case .high: return .orange
        case .moderate: return .blue
        case .low: return .gray
        }
    }
    
    private func multiplierColor(_ multiplier: Double) -> Color {
        switch multiplier {
        case 0.0..<0.2: return .red
        case 0.2..<0.5: return .orange
        case 0.5..<0.8: return .yellow
        default: return .green
        }
    }
}

// MARK: - 🔍 INTERACTION DETAIL VIEW

struct InteractionDetailView: View {
    let interaction: NonLinearInteractionsEngine.ClinicalInteraction
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Disclaimer médico
                    MedicalDisclaimerView(style: .standard, isCompact: true)
                    
                    // Header
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Circle()
                                .fill(priorityColor(interaction.priority))
                                .frame(width: 20, height: 20)
                            
                            Text(interaction.name)
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        
                        HStack {
                            Text(localizationManager.getLocalizedString("Multiplicador:"))
                                .fontWeight(.medium)
                            Text("\(String(format: "%.2f", interaction.multiplier)) (\(String(format: "%.0f", interaction.multiplier * 100))%)")
                                .fontWeight(.bold)
                                .foregroundColor(multiplierColor(interaction.multiplier))
                        }
                    }
                    
                    Divider()
                    
                    // Conditions
                    DetailSection(
                        title: "🎯 Condiciones",
                        content: interaction.conditions
                    )
                    
                    // Algorithm Effect
                    DetailSection(
                        title: "⚙️ Efecto en el Algoritmo",
                        content: interaction.algorithmEffect
                    )
                    
                    // Clinical Explanation
                    DetailSection(
                        title: "🧬 Explicación Clínica",
                        content: interaction.clinicalExplanation
                    )
                    
                    // Recommendations
                    DetailSection(
                        title: "💡 Recomendaciones",
                        content: interaction.recommendations
                    )
                    
                    // References
                    VStack(alignment: .leading, spacing: 8) {
                        Text(localizationManager.getLocalizedString("📚 Referencias"))
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        ForEach(interaction.references, id: \.self) { reference in
                            Text(String(format: localizationManager.getLocalizedString("• %@"), reference))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Priority and Treatment Change
                    HStack {
                        VStack(alignment: .leading) {
                            Text(localizationManager.getLocalizedString("Prioridad"))
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(priorityText(interaction.priority))
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(priorityColor(interaction.priority))
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text(localizationManager.getLocalizedString("Cambio de Tratamiento"))
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(interaction.forcesTreatmentChange ? "Obligatorio" : "Opcional")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(interaction.forcesTreatmentChange ? .red : .green)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }
                .padding()
            }
            .navigationTitle(localizationManager.getLocalizedString("Detalle de Interacción"))
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(localizationManager.getLocalizedString("Cerrar")) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func priorityColor(_ priority: NonLinearInteractionsEngine.InteractionPriority) -> Color {
        switch priority {
        case .critical: return .red
        case .high: return .orange
        case .moderate: return .blue
        case .low: return .gray
        }
    }
    
    private func priorityText(_ priority: NonLinearInteractionsEngine.InteractionPriority) -> String {
        switch priority {
        case .critical: return "🚨 Crítica"
        case .high: return "⚡ Alta"
        case .moderate: return "💊 Moderada"
        case .low: return "🌱 Baja"
        }
    }
    
    private func multiplierColor(_ multiplier: Double) -> Color {
        switch multiplier {
        case 0.0..<0.2: return .red
        case 0.2..<0.5: return .orange
        case 0.5..<0.8: return .yellow
        default: return .green
        }
    }
}

// MARK: - 📋 DETAIL SECTION

struct DetailSection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - 🔍 PREVIEW

struct InteractionsVisualizationView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleInteractions = [
            NonLinearInteractionsEngine.ClinicalInteraction(
                name: "🧓 Edad ≥38 + AMH <1.0",
                conditions: "Edad ≥38 años AND AMH <1.0 ng/mL",
                algorithmEffect: "Multiplicador adicional de -0.7",
                clinicalExplanation: "Reduce drásticamente tasa de blastocistos viables",
                recommendations: "→ FIV + acumulación embrionaria",
                references: ["ESHRE 2023"],
                multiplier: 0.30,
                forcesTreatmentChange: true,
                priority: .critical
            ),
            NonLinearInteractionsEngine.ClinicalInteraction(
                name: "⚙️ SOP + HOMA >3.5",
                conditions: "SOP confirmado AND HOMA-IR >3.5",
                algorithmEffect: "Penalización del 20%",
                clinicalExplanation: "Insulina alta inhibe FSH",
                recommendations: "→ Letrozol + metformina",
                references: ["NEJM 2023"],
                multiplier: 0.80,
                forcesTreatmentChange: false,
                priority: .high
            )
        ]
        
        let sampleReport = NonLinearInteractionsReport(
            detectedInteractions: sampleInteractions,
            finalMultiplier: 0.24,
            forcesTreatmentChange: true,
            treatmentChangeReason: "Interacciones críticas detectadas",
            clinicalRecommendations: ["FIV + acumulación", "Metformina"]
        )
        
        InteractionsVisualizationView(interactionsReport: sampleReport)
    }
}
