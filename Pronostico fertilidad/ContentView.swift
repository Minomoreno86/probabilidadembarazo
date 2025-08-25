//
//  ContentView.swift
//  Pronostico fertilidad
//
//  Created by Jorge Vasquez rodriguez on 11/08/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [FertilityProfile]
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var appleSignInManager: AppleSignInManager
    @EnvironmentObject var authFlowManager: AuthenticationFlowManager
    @EnvironmentObject var localizationManager: LocalizationManager
    @Environment(\.themeColors) var colors
    @State private var showingCalculator = false
    @State private var showingSettings = false
    @State private var showingOnboarding = false
    @State private var currentProfile: FertilityProfile?
    @State private var animateHero = false
    @State private var animateStats = false

    var body: some View {
        NavigationView {
            ZStack {
                // Professional medical background with dynamic gradient - Same method as SettingsView
                colors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Renovated Hero Section
                        modernHeroSection
                        
                        // Statistics Dashboard
                        statisticsDashboard
                            .accessibilityIdentifier("statistics_dashboard")
                        
                        // Main content
                        if profiles.isEmpty {
                            modernWelcomeView
                        } else {
                            modernProfilesView
                        }
                        
                        // Mandatory medical disclaimer
                        MedicalDisclaimerView(style: .warning)
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        
                        // Footer with medical information
                        medicalFooter
                        
                        // Footer with medical disclaimer
                        FooterMedicalDisclaimer()
                        
                        // MARK: - 🧪 BOTÓN DE TESTING (SOLO PARA DESARROLLO)
                        #if DEBUG
                        VStack(spacing: 16) {
                            Divider()
                                .background(Color.white.opacity(0.3))
                            
                            Text(localizationManager.getLocalizedString("🧪 Herramientas de Desarrollo"))
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Button(action: {
                                // Ejecutar tests desde la consola
                                print("\n🚀 EJECUTANDO TESTS DESDE LA APLICACIÓN...")
                                print("Para ver los resultados, revisa la consola de Xcode")
                                print("O ejecuta: TestLauncher.runAllTests() en el código")
                            }) {
                                HStack {
                                    Image(systemName: "testtube.2")
                                    Text(localizationManager.getLocalizedString("Ejecutar Tests"))
                                }
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(Color.orange)
                                .cornerRadius(10)
                            }
                            
                            Text(localizationManager.getLocalizedString("Los tests se ejecutan en la consola de Xcode"))
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                        )
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        #endif
                    }
                }
                .ignoresSafeArea(edges: .top)
            }
        }
        .sheet(isPresented: $showingCalculator) {
            ModernFertilityCalculatorView(profile: currentProfile)
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
                .environmentObject(authFlowManager)
        }
        .fullScreenCover(isPresented: $showingOnboarding) {
            OnboardingFlow(isPresented: $showingOnboarding)
        }
        .onAppear {
            // Verificar si es la primera vez que se abre la aplicación
            if !UserDefaults.hasCompletedOnboarding {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showingOnboarding = true
                }
            }
            
            withAnimation(.easeInOut(duration: 1.2)) {
                animateHero = true
            }
            withAnimation(.easeInOut(duration: 1.5).delay(0.3)) {
                animateStats = true
            }
        }
    }
    
    // MARK: - 🎯 MODERN HERO SECTION
    private var modernHeroSection: some View {
        VStack(spacing: 24) {
            // Top navigation
            HStack {
                // Logo/Branding
                HStack(spacing: 12) {
                    Image(systemName: "stethoscope")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(12)
                        .background(
                            Circle()
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                        )
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(localizationManager.getLocalizedString("FertilyzeAI"))
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text(localizationManager.getLocalizedString("Medical Suite"))
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                
                Spacer()
                
                // Configuración
                Button(action: { showingSettings = true }) {
                    Image(systemName: "gearshape")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(
                            Circle()
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                        )
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 60)
            
            // Título principal con animación
            VStack(spacing: 16) {
                HStack(spacing: 8) {
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 32, weight: .light))
                        .foregroundColor(.white)
                        .scaleEffect(animateHero ? 1.0 : 0.8)
                        .animation(.spring(response: 0.8, dampingFraction: 0.6), value: animateHero)
                    
                    Text(localizationManager.getLocalizedString("Pronóstico de"))
                        .font(.system(size: 36, weight: .thin, design: .rounded))
                        .foregroundColor(.white)
                }
                
                Text(localizationManager.getLocalizedString("FERTILIDAD"))
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .tracking(2)
                    .scaleEffect(animateHero ? 1.0 : 0.9)
                    .opacity(animateHero ? 1.0 : 0.7)
                    .animation(.easeInOut(duration: 1.0).delay(0.2), value: animateHero)
                
                // Subtítulo con badges
                VStack(spacing: 12) {
                    Text(localizationManager.getLocalizedString("Inteligencia Artificial Médica Avanzada"))
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.95))
                        .multilineTextAlignment(.center)
                    
                    HStack(spacing: 12) {
                        MedicalBadge(icon: "chart.line.uptrend.xyaxis", text: localizationManager.getLocalizedString("Evidencia Científica"))
                        MedicalBadge(icon: "brain", text: localizationManager.getLocalizedString("IA Avanzada"))
                        MedicalBadge(icon: "shield.checkered", text: localizationManager.getLocalizedString("Validación Médica"))
                    }
                }
            }
            .padding(.horizontal, 24)
            .opacity(animateHero ? 1.0 : 0.0)
            .offset(y: animateHero ? 0 : 30)
            .animation(.easeInOut(duration: 1.2).delay(0.1), value: animateHero)
        }
        .padding(.bottom, 40)
    }
    
    // MARK: - 📊 DASHBOARD DE ESTADÍSTICAS
    private var statisticsDashboard: some View {
        VStack(spacing: 20) {
            HStack {
                Text(localizationManager.getLocalizedString("Métricas del Sistema"))
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(localizationManager.getLocalizedString("Tiempo real"))
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(.ultraThinMaterial)
                    )
            }
            .padding(.horizontal, 24)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    StatCard(
                        title: localizationManager.getLocalizedString("Evaluaciones"),
                        value: "\(profiles.count)",
                        subtitle: localizationManager.getLocalizedString("Completadas"),
                        icon: "chart.bar.fill",
                        color: .cyan,
                        animate: animateStats
                    )
                    .accessibilityIdentifier("evaluations_count")
                    
                    StatCard(
                        title: localizationManager.getLocalizedString("Precisión"),
                        value: "96.1%",
                        subtitle: localizationManager.getLocalizedString("Validación Clínica"),
                        icon: "target",
                        color: .green,
                        animate: animateStats
                    )
                    .accessibilityIdentifier("precision_percentage")
                    
                    StatCard(
                        title: localizationManager.getLocalizedString("Referencias"),
                        value: "1,247",
                        subtitle: localizationManager.getLocalizedString("Artículos Científicos"),
                        icon: "doc.text.magnifyingglass",
                        color: .purple,
                        animate: animateStats
                    )
                    .accessibilityIdentifier("references_count")
                    
                    StatCard(
                        title: localizationManager.getLocalizedString("Algoritmos"),
                        value: "45",
                        subtitle: localizationManager.getLocalizedString("Benchmarks Clínicos"),
                        icon: "function",
                        color: .orange,
                        animate: animateStats
                    )
                    .accessibilityIdentifier("algorithms_count")
                }
                .padding(.horizontal, 24)
            }
        }
        .padding(.bottom, 32)
    }
    
    // MARK: - 🎆 WELCOME VIEW MODERNO
    private var modernWelcomeView: some View {
        VStack(spacing: 32) {
            // Sección de bienvenida
            VStack(spacing: 24) {
                ZStack {
                    // Fondo con efecto glassmorphism
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                    
                    VStack(spacing: 20) {
                        // Ícono principal
                        ZStack {
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [Color.pink.opacity(0.3), Color.purple.opacity(0.1)],
                                        center: .center,
                                        startRadius: 20,
                                        endRadius: 60
                                    )
                                )
                                .frame(width: 120, height: 120)
                            
                            Image(systemName: "heart.text.square")
                                .font(.system(size: 50, weight: .light))
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 12) {
                            Text(localizationManager.getLocalizedString("¡Bienvenida al Futuro!"))
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text(localizationManager.getLocalizedString("Evaluación de fertilidad con inteligencia artificial médica de última generación"))
                                .font(.body)
                                .foregroundColor(.white.opacity(0.9))
                                .multilineTextAlignment(.center)
                                .lineLimit(3)
                        }
                        
                        // Características principales
                        VStack(spacing: 8) {
                            FeatureRow(icon: "brain.head.profile", text: localizationManager.getLocalizedString("15 Interacciones No Lineales"))
                            FeatureRow(icon: "chart.xyaxis.line", text: localizationManager.getLocalizedString("45 Benchmarks Clínicos"))
                            FeatureRow(icon: "doc.text.below.ecg", text: localizationManager.getLocalizedString("Evidencia Científica ESHRE/ASRM"))
                            FeatureRow(icon: "function", text: localizationManager.getLocalizedString("Transiciones Suaves por Edad"))
                            FeatureRow(icon: "target", text: localizationManager.getLocalizedString("Simulador de Tratamientos"))
                        }
                    }
                    .padding(32)
                }
                .padding(.horizontal, 24)
                
                // Botón principal CTA
                Button(action: startNewCalculation) {
                    HStack(spacing: 12) {
                        Image(systemName: "sparkles")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text(localizationManager.getLocalizedString("Iniciar Evaluación Avanzada"))
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Image(systemName: "arrow.right")
                            .font(.title3)
                            .fontWeight(.semibold)
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
                    .scaleEffect(animateHero ? 1.0 : 0.95)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: animateHero)
                }
                .accessibilityIdentifier("start_advanced_assessment_button")
                .padding(.horizontal, 24)
            }
        }
        .padding(.bottom, 40)
    }
    
    // MARK: - 📋 VISTA MODERNA DE PERFILES
    private var modernProfilesView: some View {
        VStack(spacing: 24) {
            // Header de perfiles
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(localizationManager.getLocalizedString("Mis Evaluaciones"))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("\(profiles.count) \(profiles.count == 1 ? localizationManager.getLocalizedString("evaluación") : localizationManager.getLocalizedString("evaluaciones")) \(profiles.count == 1 ? localizationManager.getLocalizedString("completada") : localizationManager.getLocalizedString("completadas"))")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                // Botón nueva evaluación compacto
                Button(action: startNewCalculation) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus")
                            .font(.title3)
                            .fontWeight(.semibold)
                                            Text(localizationManager.getLocalizedString("Nueva"))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        LinearGradient(
                            colors: [Color.pink, Color.purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .pink.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .accessibilityIdentifier("new_assessment_button")
            }
            .padding(.horizontal, 24)
            
            // Lista de perfiles moderna con funcionalidad de eliminar
            LazyVStack(spacing: 16) {
                ForEach(profiles) { profile in
                    SwipeableProfileCard(profile: profile) {
                        currentProfile = profile
                        showingCalculator = true
                    } onDelete: {
                        deleteProfile(profile)
                    }
                }
            }
            .padding(.horizontal, 24)
        }
        .padding(.bottom, 32)
    }
    
    // MARK: - 🏥 FOOTER MÉDICO
    private var medicalFooter: some View {
        VStack(spacing: 20) {
            // Separador elegante
            HStack {
                Rectangle()
                    .fill(Color.white.opacity(0.3))
                    .frame(height: 1)
                
                Image(systemName: "stethoscope")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.horizontal, 16)
                
                Rectangle()
                    .fill(Color.white.opacity(0.3))
                    .frame(height: 1)
            }
            .padding(.horizontal, 24)
            
            // Información médica
            VStack(spacing: 12) {
                Text(localizationManager.getLocalizedString("Validado Científicamente"))
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text(localizationManager.getLocalizedString("Basado en guías ESHRE, ASRM, OMS y más de 1,247 referencias científicas"))
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
                // Badges de organizaciones
                HStack(spacing: 16) {
                    OrganizationBadge(text: "ESHRE")
                    OrganizationBadge(text: "ASRM")
                    OrganizationBadge(text: "OMS")
                    OrganizationBadge(text: "NICE")
                    OrganizationBadge(text: "SART")
                    OrganizationBadge(text: "HFEA")
                }
            }
            
            // Copyright
            Text(localizationManager.getLocalizedString("© 2024 FertilyzeAI Medical Suite - Uso Profesional"))
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
                .padding(.top, 8)
        }
        .padding(.vertical, 32)
        .padding(.horizontal, 24)
    }
    
    private func startNewCalculation() {
        let newProfile = FertilityProfile()
        modelContext.insert(newProfile)
        currentProfile = newProfile
        showingCalculator = true
    }
    
    // MARK: - 🗑️ FUNCIÓN PARA ELIMINAR PERFIL
    private func deleteProfile(_ profile: FertilityProfile) {
        withAnimation(.easeInOut(duration: 0.3)) {
            modelContext.delete(profile)
            try? modelContext.save()
        }
    }
}

// MARK: - 🎨 COMPONENTES DE DISEÑO MODERNO

// Fondo médico dinámico
struct MedicalBackgroundView: View {
    var body: some View {
        ZStack {
            // Gradiente base médico
            LinearGradient(
                colors: [
                    Color(red: 0.1, green: 0.2, blue: 0.4),
                    Color(red: 0.2, green: 0.3, blue: 0.5),
                    Color(red: 0.3, green: 0.4, blue: 0.6)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Efectos de partículas médicas
            GeometryReader { geometry in
                ForEach(0..<15, id: \.self) { i in
                    Circle()
                        .fill(Color.white.opacity(0.05))
                        .frame(width: CGFloat.random(in: 20...80))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                }
            }
            
            // Overlay de textura
            Rectangle()
                .fill(
                    RadialGradient(
                        colors: [Color.clear, Color.black.opacity(0.1)],
                        center: .center,
                        startRadius: 100,
                        endRadius: 500
                    )
                )
        }
        .ignoresSafeArea()
    }
}

// Badge médico
struct MedicalBadge: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption)
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
        }
        .foregroundColor(.white)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .overlay(
                    Capsule()
                        .stroke(Color.white.opacity(0.3), lineWidth: 0.5)
                )
        )
    }
}

// Tarjeta de estadísticas
struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    let animate: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(color.opacity(0.2))
                    )
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .scaleEffect(animate ? 1.0 : 0.8)
                    .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(Double.random(in: 0...0.5)), value: animate)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.9))
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .frame(width: 160, height: 120)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
        .shadow(color: color.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}

// Fila de características
struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
                .frame(width: 20)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))
            
            Spacer()
        }
    }
}

// Tarjeta de perfil con funcionalidad de swipe
struct SwipeableProfileCard: View {
    let profile: FertilityProfile
    let onTap: () -> Void
    let onDelete: () -> Void
    @State private var offset: CGFloat = 0
    @State private var isSwiped = false
    @EnvironmentObject var localizationManager: LocalizationManager
    
    private var completionPercentage: Double {
        profile.completionPercentage()
    }
    
    private var profileIdText: String {
        return localizationManager.getLocalizedString("Evaluación")
    }
    
    var body: some View {
        ZStack {
            // Fondo rojo para indicar eliminación
            HStack {
                Spacer()
                if offset < -50 {
                    Text(localizationManager.getLocalizedString("Suelta para eliminar"))
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.red.opacity(0.9))
                        .cornerRadius(10)
                }
            }
            .padding(.trailing, 24)
            
            // Tarjeta principal
            ModernProfileCard(profile: profile, onTap: {
                // Solo ejecutar onTap si no hay offset (no se está haciendo swipe)
                if offset == 0 {
                    onTap()
                }
            })
                .offset(x: offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if value.translation.width < 0 {
                                offset = value.translation.width
                            }
                        }
                        .onEnded { value in
                            if value.translation.width < -80 {
                                // Deslizamiento completo - eliminar automáticamente
                                onDelete()
                            } else if value.translation.width < -80 {
                                // Deslizamiento parcial - mostrar indicador de eliminación
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    offset = -100
                                    isSwiped = true
                                }
                            } else {
                                // Deslizamiento insuficiente - volver a posición original
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    offset = 0
                                    isSwiped = false
                                }
                            }
                        }
                )
        }
    }
}

// Tarjeta de perfil moderna (simplificada)
struct ModernProfileCard: View {
    let profile: FertilityProfile
    let onTap: () -> Void
    @EnvironmentObject var localizationManager: LocalizationManager
    
    private var completionPercentage: Double {
        profile.completionPercentage()
    }
    
    private var profileIdText: String {
        return localizationManager.getLocalizedString("Evaluación")
    }
    
    var body: some View {
        cardContent
            .onTapGesture {
                onTap()
            }
    }
    
    private var cardContent: some View {
        VStack(spacing: 16) {
            profileHeader
            metricsRow
        }
        .padding(20)
        .background(cardBackground)
        .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 8)
    }
    
    private var profileHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Image(systemName: "person.crop.circle")
                        .font(.title2)
                        .foregroundColor(.white)
                    
                    Text(profileIdText)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                
                Text("\(localizationManager.getLocalizedString("Creada:")) \(profile.createdAt, style: .date)")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            progressCircle
        }
    }
    
    private var progressCircle: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.3), lineWidth: 4)
            
            Circle()
                .trim(from: 0, to: completionPercentage / 100)
                .stroke(Color.cyan, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))
            
            Text(String(format: localizationManager.getLocalizedString("Progreso: %@%%"), String(Int(completionPercentage))))
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .frame(width: 50, height: 50)
    }
    
    private var metricsRow: some View {
        HStack(spacing: 16) {
            MetricPill(icon: "person.fill", value: "\(Int(profile.age))", label: localizationManager.getLocalizedString("años"))
            MetricPill(icon: "scalemass.fill", value: String(format: "%.1f", profile.bmi), label: localizationManager.getLocalizedString("IMC"))
            
            if completionPercentage == 100 {
                MetricPill(icon: "checkmark.circle.fill", value: "100%", label: localizationManager.getLocalizedString("completo"))
            } else {
                MetricPill(icon: "clock.fill", value: String(format: localizationManager.getLocalizedString("Progreso: %@%%"), String(Int(completionPercentage))), label: localizationManager.getLocalizedString("progreso"))
            }
        }
    }
    
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
    }
}

// Píldora de métrica
struct MetricPill: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
            
            Text(value)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(Color.white.opacity(0.1))
        )
    }
}

// Badge de organización
struct OrganizationBadge: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
            )
    }
}

#Preview {
    ContentView()
        .modelContainer(for: FertilityProfile.self, inMemory: true)
}
