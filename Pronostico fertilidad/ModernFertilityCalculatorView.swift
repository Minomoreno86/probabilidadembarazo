//
//  ModernFertilityCalculatorView.swift
//  Pronostico fertilidad
//
//  Vista moderna y funcional para la calculadora de fertilidad
//

import SwiftUI
import SwiftData
#if os(iOS)
import UIKit
#endif

struct ModernFertilityCalculatorView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.themeColors) var colors
    
    @State private var profile: FertilityProfile
    @State private var activeSection: MedicalSection = .demographics
    @State private var showingResults = false
    @State private var calculationResult: ImprovedFertilityEngine.ComprehensiveFertilityResult?
    @State private var isCalculating = false
    @State private var animateProgress = false
    @State private var showError = false
    @State private var errorMessage = ""
    @StateObject private var improvedEngine = ImprovedFertilityEngine()
    
    init(profile: FertilityProfile?) {
        _profile = State(initialValue: profile ?? FertilityProfile())
    }
    
    enum MedicalSection: String, CaseIterable {
        case demographics = "Demografía"
        case gynecology = "Ginecología"
        case laboratory = "Laboratorio"
        case maleFactor = "Factor Masculino"
        
        var icon: String {
            switch self {
            case .demographics: return "person.text.rectangle"
            case .gynecology: return "stethoscope"
            case .laboratory: return "testtube.2"
            case .maleFactor: return "figure.stand"
            }
        }
        
        var color: Color {
            switch self {
            case .demographics: return .blue
            case .gynecology: return .pink
            case .laboratory: return .purple
            case .maleFactor: return .cyan
            }
        }
        
        var description: String {
            switch self {
            case .demographics: return "Información básica del paciente"
            case .gynecology: return "Historia clínica ginecológica"
            case .laboratory: return "Resultados de laboratorio"
            case .maleFactor: return "Análisis andrológico"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Fondo médico profesional con temas
                colors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header médico moderno
                    modernMedicalHeader
                    
                    // Navegación por secciones
                    modernSectionTabs
                    
                    // Contenido del formulario
                    ScrollView {
                        VStack(spacing: 12) {
                            sectionHeader
                            
                            // Disclaimer médico obligatorio
                            MedicalDisclaimerView(style: .standard, isCompact: true)
                                .padding(.horizontal, 4)
                            
                            switch activeSection {
                            case .demographics:
                                demographicsForm
                                    .accessibilityIdentifier("demographics_section")
                            case .gynecology:
                                gynecologyForm
                                    .accessibilityIdentifier("gynecology_section")
                            case .laboratory:
                                laboratoryForm
                                    .accessibilityIdentifier("laboratory_section")
                            case .maleFactor:
                                maleFactorForm
                                    .accessibilityIdentifier("male_factor_section")
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 120) // Más espacio para el botón
                    }
                    .scrollDismissesKeyboard(.interactively) // ✅ Cerrar teclado al scroll
                    
                    // Botón de cálculo
                    modernCalculateButton
                }
            }
        }
        .sheet(isPresented: $showingResults) {
            if let result = calculationResult {
                ImprovedFertilityResultsView(result: result, profile: profile)
            }
        }
        .alert("Error en el Cálculo", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage.isEmpty ? "Ocurrió un error durante el cálculo" : errorMessage)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                animateProgress = true
            }
        }
        .accessibilityIdentifier("ModernFertilityCalculatorView")
    }
    
    // MARK: - HEADER MÉDICO
    private var modernMedicalHeader: some View {
        VStack(spacing: 12) {
            HStack {
                // Botón cerrar
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(colors.text)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(colors.surface.opacity(0.8))
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                        )
                }
                
                Spacer()
                
                // Título
                VStack(spacing: 4) {
                    Text("Evaluación Médica")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(colors.text)
                    
                    Text("FertilyzeAI Suite")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                // Ayuda
                Button(action: {}) {
                    Image(systemName: "info.circle")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(colors.text)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(colors.surface.opacity(0.8))
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                        )
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 60)
            
            // Progreso
            VStack(spacing: 8) {
                Text("Completado: \(Int(profile.completionPercentage()))%")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.9))
                
                ProgressView(value: profile.completionPercentage(), total: 100)
                    .progressViewStyle(LinearProgressViewStyle(tint: .white))
                    .background(Color.white.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            }
            .padding(.horizontal, 24)
        }
        .padding(.bottom, 12)
    }
    
    // MARK: - NAVEGACIÓN DE SECCIONES
    private var modernSectionTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(MedicalSection.allCases, id: \.self) { section in
                    sectionTabButton(for: section)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 12)
    }
    
    // MARK: - BOTÓN DE SECCIÓN (SIMPLIFICADO)
    private func sectionTabButton(for section: MedicalSection) -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                activeSection = section
            }
        }) {
            sectionTabContent(for: section)
        }
    }
    
    private func sectionTabContent(for section: MedicalSection) -> some View {
        VStack(spacing: 8) {
            sectionIcon(for: section)
            sectionTitle(for: section)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(sectionBackground(for: section))
        .scaleEffect(activeSection == section ? 1.05 : 1.0)
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: activeSection == section)
    }
    
    private func sectionIcon(for section: MedicalSection) -> some View {
        Image(systemName: section.icon)
            .font(.title3)
            .foregroundColor(activeSection == section ? section.color : .white.opacity(0.7))
    }
    
    private func sectionTitle(for section: MedicalSection) -> some View {
        Text(section.rawValue)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(activeSection == section ? section.color : .white.opacity(0.7))
            .multilineTextAlignment(.center)
    }
    
    private func sectionBackground(for section: MedicalSection) -> some View {
        let isActive = activeSection == section
        let fillColor = isActive ? Color.white.opacity(0.9) : Color.clear
        let strokeColor = isActive ? section.color.opacity(0.5) : Color.white.opacity(0.3)
        
        return RoundedRectangle(cornerRadius: 16)
            .fill(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .fill(fillColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(strokeColor, lineWidth: 1)
            )
    }
    
    // MARK: - 📝 FORMULARIOS MÉDICOS
    
    private var sectionHeader: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: activeSection.icon)
                    .font(.title2)
                    .foregroundColor(activeSection.color)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(activeSection.color.opacity(0.2))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(activeSection.rawValue)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(colors.text)
                    
                    Text(activeSection.description)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(colors.surface.opacity(0.8))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(activeSection.color.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    // MARK: - 👤 FORMULARIO DEMOGRÁFICO
    private var demographicsForm: some View {
        VStack(spacing: 12) {
            // Edad
            FormField(
                title: "Edad",
                subtitle: "Años cumplidos",
                icon: "calendar",
                value: Binding(
                    get: { 
                        profile.age == 0 ? "" : String(Int(profile.age))
                    },
                    set: { 
                        profile.age = Double($0) ?? profile.age 
                    }
                ),
                color: .blue
            )
            .accessibilityIdentifier("age_field")
            
            // Peso
            FormField(
                title: "Peso",
                subtitle: "Kilogramos",
                icon: "scalemass",
                value: Binding(
                    get: { 
                        profile.weight == 0 ? "" : String(format: "%.0f", profile.weight)
                    },
                    set: { 
                        profile.weight = Double($0) ?? profile.weight
                        profile.updateBMI()
                    }
                ),
                color: .blue
            )
            .accessibilityIdentifier("weight_field")
            
            // Estatura
            FormField(
                title: "Estatura",
                subtitle: "Centímetros",
                icon: "ruler",
                value: Binding(
                    get: { 
                        profile.height == 0 ? "" : String(Int(profile.height))
                    },
                    set: { 
                        profile.height = Double($0) ?? profile.height
                        profile.updateBMI()
                    }
                ),
                color: .blue
            )
            .accessibilityIdentifier("height_field")
            
            // IMC calculado automáticamente
            if profile.height > 0 && profile.weight > 0 {
                HStack(spacing: 12) {
                    Image(systemName: "chart.bar.fill")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.blue)
                        .frame(width: 28, height: 28)
                        .background(Circle().fill(.blue.opacity(0.15)))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("IMC Calculado")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(colors.text)
                        Text(imcCategory)
                            .font(.system(size: 11))
                            .foregroundColor(imcColor)
                    }
                    
                    Spacer()
                    
                    Text("\(String(format: "%.1f", profile.bmi))")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.blue)
                        .frame(width: 60)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.blue.opacity(0.15))
                        )
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(colors.surface.opacity(0.8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                )
            }
        }
    }
    
    // MARK: - 🩺 FORMULARIO GINECOLÓGICO COMPLETO
    private var gynecologyForm: some View {
        VStack(spacing: 12) {
            // Duración del ciclo
            FormField(
                title: "Duración del Ciclo Menstrual",
                subtitle: "Días (normal: 21-35)",
                icon: "calendar.circle",
                value: Binding(
                    get: { 
                        if let cycle = profile.cycleLength, cycle > 0 {
                            return String(Int(cycle))
                        }
                        return ""
                    },
                    set: { 
                        profile.cycleLength = Double($0).flatMap { $0 > 0 ? $0 : nil }
                    }
                ),
                color: .pink
            )
            
            // Duración de infertilidad
            FormField(
                title: "Duración de Infertilidad",
                subtitle: "Años",
                icon: "clock",
                value: Binding(
                    get: { 
                        if let duration = profile.infertilityDuration, duration > 0 {
                            // Solo mostrar decimal si es necesario
                            return duration.truncatingRemainder(dividingBy: 1) == 0 ? 
                                String(Int(duration)) : String(format: "%.1f", duration)
                        }
                        return ""
                    },
                    set: { 
                        profile.infertilityDuration = Double($0).flatMap { $0 > 0 ? $0 : nil }
                    }
                ),
                color: .pink
            )
            
            // Embarazos previos (paridad)
            FormField(
                title: "Embarazos Previos",
                subtitle: "Número total de embarazos (incluye abortos)",
                icon: "heart.circle",
                value: Binding(
                    get: { String(profile.previousPregnancies) },
                    set: { profile.previousPregnancies = Int($0) ?? 0 }
                ),
                color: .pink
            )
            
            // SOP
            ToggleField(
                title: "Síndrome de Ovario Poliquístico (SOP)",
                subtitle: "Diagnóstico confirmado por especialista",
                icon: "circle.hexagongrid",
                isOn: $profile.hasPcos,
                color: .pink
            )
            
            // Preguntas condicionales del SOP
            if profile.hasPcos {
                VStack(alignment: .leading, spacing: 16) {
                    // Header de la sección
                    HStack {
                        Image(systemName: "circle.hexagongrid.fill")
                            .foregroundColor(.pink)
                        Text("Evaluación Detallada del SOP")
                            .font(.headline)
                            .foregroundColor(colors.text)
                        Spacer()
                    }
                    
                    // Manifestaciones androgénicas
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Manifestaciones Androgénicas")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white.opacity(0.9))
                        
                        Picker("Hirsutismo", selection: $profile.hirsutismSeverity) {
                            Text("No").tag(HirsutismSeverity.none)
                            Text("Leve (vello en mentón)").tag(HirsutismSeverity.mild)
                            Text("Moderado (vello en mentón + mejillas)").tag(HirsutismSeverity.moderate)
                            Text("Severo (vello facial extenso)").tag(HirsutismSeverity.severe)
                        }
                        .pickerStyle(MenuPickerStyle())
                        .foregroundColor(.white)
                        
                        Picker("Acné", selection: $profile.acneSeverity) {
                            Text("No").tag(AcneSeverity.none)
                            Text("Leve (pocos granos)").tag(AcneSeverity.mild)
                            Text("Moderado (acné persistente)").tag(AcneSeverity.moderate)
                            Text("Severo (acné quístico)").tag(AcneSeverity.severe)
                        }
                        .pickerStyle(MenuPickerStyle())
                        .foregroundColor(.white)
                    }
                    
                    // Evaluación ovárica
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Evaluación Ovárica")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white.opacity(0.9))
                        
                        Picker("Conteo folicular", selection: $profile.ovarianMorphology) {
                            Text("No me la han hecho").tag(OvarianMorphology.notEvaluated)
                            Text("Normal").tag(OvarianMorphology.normal)
                            Text("Ovarios poliquísticos (>12 folículos)").tag(OvarianMorphology.polycystic)
                        }
                        .pickerStyle(MenuPickerStyle())
                        .foregroundColor(.white)
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(colors.surface.opacity(0.6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.pink.opacity(0.3), lineWidth: 1)
                        )
                )
            }
            
            // Endometriosis
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "medical.thermometer")
                        .foregroundColor(.pink)
                    Text("Endometriosis")
                        .font(.headline)
                        .foregroundColor(colors.text)
                    Spacer()
                }
                
                Picker("Grado de Endometriosis", selection: $profile.endometriosisStage) {
                    Text("Sin endometriosis").tag(0)
                    Text("Grado I (mínima)").tag(1)
                    Text("Grado II (leve)").tag(2)
                    Text("Grado III (moderada)").tag(3)
                    Text("Grado IV (severa)").tag(4)
                }
                .pickerStyle(MenuPickerStyle())
                .foregroundColor(.white)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(colors.surface.opacity(0.8))
            )
            
            // Miomatosis Uterina
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "circle.fill")
                        .foregroundColor(.pink)
                    Text("Miomatosis Uterina")
                        .font(.headline)
                        .foregroundColor(colors.text)
                    Spacer()
                }
                
                Picker("Tipo de Mioma", selection: $profile.myomaType) {
                    Text("Sin miomas").tag(MyomaType.none)
                    Text("Submucoso").tag(MyomaType.submucosal)
                    Text("Intramural").tag(MyomaType.intramural)
                    Text("Subseroso").tag(MyomaType.subserosal)
                }
                .pickerStyle(MenuPickerStyle())
                .foregroundColor(.white)
                
                // Tamaño del mioma (solo si hay miomas)
                if profile.myomaType != .none {
                    HStack {
                        Image(systemName: "ruler")
                            .foregroundColor(.pink)
                        Text("Tamaño del mioma más grande")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                        Spacer()
                    }
                    
                    HStack {
                        TextField("cm", text: Binding(
                            get: { 
                                if let size = profile.myomaSize {
                                    return String(format: "%.1f", size)
                                } else {
                                    return ""
                                }
                            },
                            set: { profile.myomaSize = Double($0) }
                        ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Text("cm")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.caption)
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(colors.surface.opacity(0.8))
            )
            
            // Adenomiosis
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "waveform.path.ecg")
                        .foregroundColor(.pink)
                    Text("Adenomiosis")
                        .font(.headline)
                        .foregroundColor(colors.text)
                    Spacer()
                }
                
                Picker("Tipo de Adenomiosis", selection: $profile.adenomyosisType) {
                    Text("Sin adenomiosis").tag(AdenomyosisType.none)
                    Text("Focal").tag(AdenomyosisType.focal)
                    Text("Difusa").tag(AdenomyosisType.diffuse)
                }
                .pickerStyle(MenuPickerStyle())
                .foregroundColor(.white)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(colors.surface.opacity(0.8))
            )
            
            // Pólipos Endometriales
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "drop.triangle")
                        .foregroundColor(.pink)
                    Text("Pólipos Endometriales")
                        .font(.headline)
                        .foregroundColor(colors.text)
                    Spacer()
                }
                
                Picker("Tipo de Pólipo", selection: $profile.polypType) {
                    Text("Sin pólipos").tag(PolypType.none)
                    Text("Único").tag(PolypType.single)
                    Text("Múltiples").tag(PolypType.multiple)
                }
                .pickerStyle(MenuPickerStyle())
                .foregroundColor(.white)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(colors.surface.opacity(0.8))
            )
            
            // Histerosalpingografía (HSG)
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "xmark.circle")
                        .foregroundColor(.pink)
                    Text("Histerosalpingografía (HSG)")
                        .font(.headline)
                        .foregroundColor(colors.text)
                    Spacer()
                }
                
                Picker("Resultado HSG", selection: $profile.hsgResult) {
                    Text("Normal").tag(HsgResult.normal)
                    Text("Obstrucción unilateral").tag(HsgResult.unilateral)
                    Text("Obstrucción bilateral").tag(HsgResult.bilateral)
                }
                .pickerStyle(MenuPickerStyle())
                .foregroundColor(.white)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(colors.surface.opacity(0.8))
            )
            
            // Cirugías Pélvicas Previas
            ToggleField(
                title: "Cirugías Pélvicas Previas",
                subtitle: "Laparoscopía, laparotomía, etc.",
                icon: "scissors",
                isOn: $profile.hasPelvicSurgery,
                color: .pink
            )
            
            // Número de cirugías (si tiene cirugías previas)
            if profile.hasPelvicSurgery {
                FormField(
                    title: "Número de Cirugías Pélvicas",
                    subtitle: "Cantidad total",
                    icon: "number",
                    value: Binding(
                        get: { String(profile.numberOfPelvicSurgeries) },
                        set: { profile.numberOfPelvicSurgeries = Int($0) ?? 0 }
                    ),
                    color: .pink
                )
            }
            
            // Obstrucción Tubárica (OTB)
            ToggleField(
                title: "Obstrucción Tubárica (OTB)",
                subtitle: "Diagnóstico confirmado",
                icon: "xmark.octagon",
                isOn: $profile.hasOtb,
                color: .pink
            )
            
            // Método de diagnóstico OTB (si tiene OTB)
            if profile.hasOtb {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "stethoscope")
                            .foregroundColor(.pink)
                        Text("Método de Diagnóstico OTB")
                            .font(.headline)
                            .foregroundColor(colors.text)
                        Spacer()
                    }
                    
                    Picker("Método OTB", selection: $profile.otbMethod) {
                        Text("No especificado").tag(OtbMethod.none)
                        Text("Clips").tag(OtbMethod.clips)
                        Text("Coagulación").tag(OtbMethod.coagulation)
                        Text("Salpingectomía").tag(OtbMethod.salpingectomy)
                    }
                    .pickerStyle(MenuPickerStyle())
                    .foregroundColor(.white)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(colors.surface.opacity(0.8))
                )
            }
            

        }
    }
    
    // MARK: - 🧪 FORMULARIO DE LABORATORIO
    private var laboratoryForm: some View {
        VStack(spacing: 12) {
            // AMH - Optimizado
            OptimizedNumericField(
                title: "Hormona Antimulleriana (AMH)",
                subtitle: "Reserva ovárica",
                icon: "drop.circle.fill",
                value: Binding(
                    get: { 
                        if let amh = profile.amhValue, amh > 0 {
                            return String(format: "%.2f", amh)
                        }
                        return ""
                    },
                    set: { 
                        profile.amhValue = Double($0).flatMap { $0 > 0 ? $0 : nil }
                    }
                ),
                color: .purple,
                placeholder: "ej: 2.5",
                unit: "ng/mL",
                commonValues: ["0.5", "1.0", "1.5", "2.0", "2.5", "3.0", "4.0", "5.0"],
                validRange: 0.1...15.0
            )
            
            // TSH
            FormField(
                title: "Hormona Estimulante del Tiroides (TSH)",
                subtitle: "mUI/L - Normal: 0.4-4.0",
                icon: "waveform.path.ecg",
                value: Binding(
                    get: { 
                        if let tsh = profile.tshValue, tsh > 0 {
                            return String(format: "%.2f", tsh)
                        }
                        return ""
                    },
                    set: { 
                        profile.tshValue = Double($0).flatMap { $0 > 0 ? $0 : nil }
                    }
                ),
                color: .purple
            )
            
            // TPO Ab
            ToggleField(
                title: "Anticuerpos Anti-TPO",
                subtitle: "Positivos para autoinmunidad tiroidea",
                icon: "shield.lefthalf.filled",
                isOn: $profile.tpoAbPositive,
                color: .purple
            )
            
            // Prolactina
            FormField(
                title: "Prolactina",
                subtitle: "ng/mL - Normal: <25",
                icon: "drop.triangle.fill",
                value: Binding(
                    get: { 
                        if let prolactin = profile.prolactinValue, prolactin > 0 {
                            return String(format: "%.1f", prolactin)
                        }
                        return ""
                    },
                    set: { 
                        profile.prolactinValue = Double($0).flatMap { $0 > 0 ? $0 : nil }
                    }
                ),
                color: .purple
            )
            
            // Insulina (opcional)
            FormField(
                title: "Insulina Basal",
                subtitle: "μU/mL - Opcional para HOMA-IR",
                icon: "drop.circle",
                value: Binding(
                    get: { 
                        if let insulin = profile.insulinValue, insulin > 0 {
                            return String(format: "%.1f", insulin)
                        }
                        return ""
                    },
                    set: { 
                        profile.insulinValue = Double($0).flatMap { $0 > 0 ? $0 : nil }
                        if profile.insulinValue != nil && profile.glucoseValue != nil {
                            profile.updateHomaIR()
                        }
                    }
                ),
                color: .orange
            )
            
            // Glucosa (opcional)
            FormField(
                title: "Glucosa Basal",
                subtitle: "mg/dL - Opcional para HOMA-IR",
                icon: "drop.circle",
                value: Binding(
                    get: { 
                        if let glucose = profile.glucoseValue, glucose > 0 {
                            return String(format: "%.0f", glucose)
                        }
                        return ""
                    },
                    set: { 
                        profile.glucoseValue = Double($0).flatMap { $0 > 0 ? $0 : nil }
                        if profile.insulinValue != nil && profile.glucoseValue != nil {
                            profile.updateHomaIR()
                        }
                    }
                ),
                color: .orange
            )
            
            // HOMA-IR calculado automáticamente
            if let insulin = profile.insulinValue, let glucose = profile.glucoseValue, 
               insulin > 0 && glucose > 0 {
                HStack(spacing: 12) {
                    Image(systemName: "function")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.orange)
                        .frame(width: 28, height: 28)
                        .background(Circle().fill(.orange.opacity(0.15)))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("HOMA-IR Calculado")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(colors.text)
                        Text("Normal: <2.5")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
                    Spacer()
                    
                    Text("\(String(format: "%.2f", profile.homaIr ?? 0.0))")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.orange)
                        .frame(width: 60)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.orange.opacity(0.15))
                        )
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(colors.surface.opacity(0.8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                )
            }
        }
    }
    
    // MARK: - 👨 FORMULARIO FACTOR MASCULINO
    private var maleFactorForm: some View {
        VStack(spacing: 12) {
            Text("Espermatograma (OMS 2021)")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Concentración
            FormField(
                title: "Concentración Espermática",
                subtitle: "millones/mL (normal: ≥16)",
                icon: "drop.circle",
                value: Binding(
                    get: { String(format: "%.1f", profile.spermConcentration ?? 0.0) },
                    set: { profile.spermConcentration = Double($0) }
                ),
                color: .cyan
            )
            
            // Motilidad
            FormField(
                title: "Motilidad Progresiva",
                subtitle: "% (normal: ≥30%)",
                icon: "arrow.forward.circle",
                value: Binding(
                    get: { String(format: "%.1f", profile.spermProgressiveMotility ?? 0.0) },
                    set: { profile.spermProgressiveMotility = Double($0) }
                ),
                color: .cyan
            )
            
            // Morfología
            FormField(
                title: "Morfología Normal",
                subtitle: "% (normal: ≥4%)",
                icon: "circle.grid.3x3",
                value: Binding(
                    get: { String(format: "%.1f", profile.spermNormalMorphology ?? 0.0) },
                    set: { profile.spermNormalMorphology = Double($0) }
                ),
                color: .cyan
            )
            
            // Volumen
            FormField(
                title: "Volumen Seminal",
                subtitle: "mL (normal: ≥1.4)",
                icon: "testtube.2",
                value: Binding(
                    get: { String(format: "%.1f", profile.semenVolume ?? 0.0) },
                    set: { profile.semenVolume = Double($0) }
                ),
                color: .cyan
            )
            
            // Fragmentación DNA (opcional)
            FormField(
                title: "Fragmentación DNA Espermática (Opcional)",
                subtitle: "% (normal: <15%)",
                icon: "dna",
                value: Binding(
                    get: { 
                        if let fragmentation = profile.spermDNAFragmentation {
                            return String(format: "%.1f", fragmentation)
                        } else {
                            return ""
                        }
                    },
                    set: { profile.spermDNAFragmentation = Double($0) }
                ),
                color: .cyan
            )
            
            // Historia de varicocele
            ToggleField(
                title: "Historia de Varicocele",
                subtitle: "Diagnóstico previo de varicocele",
                icon: "heart.text.square",
                isOn: $profile.hasVaricocele,
                color: .cyan
            )
            
            // Cultivo seminal
            ToggleField(
                title: "Cultivo Seminal Positivo (Opcional)",
                subtitle: "Presencia de bacterias en cultivo",
                icon: "bacteria.circle",
                isOn: $profile.seminalCulturePositive,
                color: .cyan
            )
        }
    }
    
    // MARK: - 📊 PROPIEDADES CALCULADAS
    
    private var imcCategory: String {
        let bmi = profile.bmi
        if bmi < 18.5 { return "Bajo peso" }
        else if bmi < 25 { return "Peso normal" }
        else if bmi < 30 { return "Sobrepeso" }
        else { return "Obesidad" }
    }
    
    private var imcColor: Color {
        let bmi = profile.bmi
        if bmi < 18.5 { return .orange }
        else if bmi < 25 { return .green }
        else if bmi < 30 { return .yellow }
        else { return .red }
    }
    
    // MARK: - BOTÓN DE CÁLCULO
    private var modernCalculateButton: some View {
        Button(action: calculateFertility) {
            HStack(spacing: 12) {
                if isCalculating {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "brain.head.profile")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                
                Text(isCalculating ? "Analizando..." : "Generar Pronóstico")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                if !isCalculating {
                    Image(systemName: "arrow.right")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
            }
            .foregroundColor(.white)
            .padding(.horizontal, 32)
            .padding(.vertical, 18)
            .background(
                LinearGradient(
                    colors: [Color.pink, Color.purple],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .overlay(
                    LinearGradient(
                        colors: [Color.white.opacity(0.3), Color.clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .pink.opacity(0.4), radius: 20, x: 0, y: 10)
            .disabled(isCalculating)
            .scaleEffect(isCalculating ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isCalculating)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 40)
    }
    
    // MARK: - FUNCIÓN DE CÁLCULO OPTIMIZADA
    private func calculateFertility() {
        isCalculating = true
        
        // ✅ SOLUCIÓN: Ejecutar en background thread
        Task {
            do {
                // Ejecutar cálculo intensivo en background
                let result = try await improvedEngine.analyzeComprehensiveFertilityAsync(from: profile)
                
                // ✅ Actualizar UI en main thread
                await MainActor.run {
                    calculationResult = result
                    isCalculating = false
                    showingResults = true
                }
                
                // Guardar perfil en background
                try await saveProfileAsync()
                
            } catch {
                // ✅ Manejar errores en main thread
                await MainActor.run {
                    isCalculating = false
                    // Mostrar error al usuario
                    showError = true
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // ✅ FUNCIÓN ASÍNCRONA PARA GUARDAR PERFIL
    private func saveProfileAsync() async throws {
        try await Task.detached(priority: .utility) {
            try self.modelContext.save()
        }.value
    }
}

// MARK: - 📝 COMPONENTES DE FORMULARIO

/// Campo numérico optimizado para entrada médica rápida
struct OptimizedNumericField: View {
    let title: String
    let subtitle: String
    let icon: String
    @Binding var value: String
    let color: Color
    let placeholder: String
    let unit: String
    let commonValues: [String]
    let validRange: ClosedRange<Double>?
    
    @FocusState private var isFieldFocused: Bool
    @State private var showSuggestions: Bool = false
    @Environment(\.themeColors) var colors
    
    init(title: String, subtitle: String, icon: String, value: Binding<String>, color: Color, 
         placeholder: String = "", unit: String = "", commonValues: [String] = [], 
         validRange: ClosedRange<Double>? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self._value = value
        self.color = color
        self.placeholder = placeholder
        self.unit = unit
        self.commonValues = commonValues
        self.validRange = validRange
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                // Icono compacto
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(color)
                    .frame(width: 28, height: 28)
                    .background(Circle().fill(color.opacity(0.15)))
                
                // Información del campo
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(colors.text)
                    
                    Text(subtitle)
                        .font(.system(size: 11))
                        .foregroundColor(colors.textSecondary)
                }
                
                Spacer()
                
                // Campo de entrada optimizado
                HStack(spacing: 8) {
                    TextField(placeholder, text: $value)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(colors.text)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 80)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white.opacity(isFieldFocused ? 0.2 : 0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(validationColor, lineWidth: isFieldFocused ? 2 : 1)
                                )
                        )
                        .focused($isFieldFocused)
                        .onChange(of: isFieldFocused) { _, focused in
                            showSuggestions = focused && !commonValues.isEmpty
                        }
                    
                    // Botón de limpieza rápida
                    if !value.isEmpty {
                        Button(action: {
                            value = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                    
                    // Unidad
                    if !unit.isEmpty {
                        Text(unit)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
            }
            
            // Sugerencias de valores comunes
            if showSuggestions && !commonValues.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(commonValues, id: \.self) { commonValue in
                            Button(action: {
                                value = commonValue
                                showSuggestions = false
                            }) {
                                Text(commonValue)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(color)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        Capsule()
                                            .fill(color.opacity(0.2))
                                            .overlay(
                                                Capsule()
                                                    .stroke(color.opacity(0.5), lineWidth: 1)
                                            )
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 40) // Alinear con el campo de entrada
                }
            }
            
            // Indicador de validación
            if isFieldFocused && validRange != nil {
                Text(validationMessage)
                    .font(.system(size: 10))
                    .foregroundColor(validationColor)
                    .padding(.leading, 40)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.3))
        )
    }
    
    private var validationColor: Color {
        guard let range = validRange, let doubleValue = Double(value), !value.isEmpty else {
            return .white.opacity(0.3)
        }
        return range.contains(doubleValue) ? .green : .red
    }
    
    private var validationMessage: String {
        guard let range = validRange else { return "" }
        guard let doubleValue = Double(value), !value.isEmpty else {
            return "Rango: \(range.lowerBound)-\(range.upperBound)"
        }
        
        if range.contains(doubleValue) {
            return "✓ Valor válido"
        } else {
            return "⚠️ Rango normal: \(range.lowerBound)-\(range.upperBound)"
        }
    }
}

struct FormField: View {
    let title: String
    let subtitle: String
    let icon: String
    @Binding var value: String
    let color: Color
    @Environment(\.themeColors) var colors
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            // Icono compacto
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color)
                .frame(width: 28, height: 28)
                .background(
                    Circle()
                        .fill(color.opacity(0.15))
                )
            
            // Información del campo
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Spacer()
            
            // Campo de entrada optimizado
            HStack(spacing: 8) {
                TextField("", text: $value)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 60)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(colors.surface.opacity(isFocused ? 0.9 : 0.8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(isFocused ? color : color.opacity(0.3), lineWidth: isFocused ? 2 : 1)
                            )
                    )
                    .focused($isFocused)
                    .keyboardType(.decimalPad)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                
                // Botón de limpieza rápida
                if !value.isEmpty {
                    Button(action: {
                        value = ""
                        isFocused = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .transition(.opacity.combined(with: .scale))
                }
            }
            .animation(.easeInOut(duration: 0.2), value: value.isEmpty)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(colors.surface.opacity(0.8))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isFocused ? color.opacity(0.5) : Color.white.opacity(0.1), lineWidth: 1)
                )
        )
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

struct ToggleField: View {
    let title: String
    let subtitle: String
    let icon: String
    @Binding var isOn: Bool
    let color: Color
    @Environment(\.themeColors) var colors
    
    var body: some View {
        HStack(spacing: 12) {
            // Icono compacto
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color)
                .frame(width: 28, height: 28)
                .background(
                    Circle()
                        .fill(color.opacity(0.15))
                )
            
            // Información del campo
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Spacer()
            
            // Toggle compacto
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: color))
                .scaleEffect(0.8)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(colors.surface.opacity(0.8))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

#Preview {
    ModernFertilityCalculatorView(profile: nil)
        .modelContainer(for: FertilityProfile.self, inMemory: true)
}
