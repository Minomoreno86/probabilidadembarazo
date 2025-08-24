import SwiftUI

// MARK: - Flujo de Onboarding Informativo
// Explica qué datos se introducirán, cómo se calcula la probabilidad y qué significan los resultados

struct OnboardingFlow: View {
    @Binding var isPresented: Bool
    @State private var currentPage = 0
    @State private var showingSkipAlert = false
    @EnvironmentObject var localizationManager: LocalizationManager
    
    private var pages: [OnboardingPage] {
        [
            // Página 1: Bienvenida
            OnboardingPage(
                title: localizationManager.getLocalizedString("Bienvenido a Pronóstico Fertilidad"),
                description: localizationManager.getLocalizedString("Una herramienta científica basada en guías ESHRE/ASRM para evaluar probabilidades de embarazo"),
                icon: "heart.fill",
                iconColor: .pink,
                bulletPoints: [
                    localizationManager.getLocalizedString("Cálculos basados en evidencia científica internacional"),
                    localizationManager.getLocalizedString("Algoritmos validados por especialistas en medicina reproductiva"),
                    localizationManager.getLocalizedString("Procesamiento 100% local de tus datos médicos"),
                    localizationManager.getLocalizedString("Sin conexión a internet requerida para los cálculos")
                ],
                showMedicalDisclaimer: true
            ),
            
            // Página 2: Qué datos necesitamos
            OnboardingPage(
                title: localizationManager.getLocalizedString("¿Qué Datos Necesitamos?"),
                description: localizationManager.getLocalizedString("Para calcular tu pronóstico, necesitamos información médica específica"),
                icon: "doc.text.fill",
                iconColor: .blue,
                bulletPoints: [
                    localizationManager.getLocalizedString("Datos demográficos: edad, peso, altura"),
                    localizationManager.getLocalizedString("Análisis hormonales: AMH, TSH, prolactina"),
                    localizationManager.getLocalizedString("Historia ginecológica: ciclos, patologías, cirugías"),
                    localizationManager.getLocalizedString("Factor masculino: espermatograma (si aplica)"),
                    localizationManager.getLocalizedString("Duración de la búsqueda de embarazo")
                ],
                showMedicalDisclaimer: false
            ),
            
            // Página 3: Cómo calculamos
            OnboardingPage(
                title: localizationManager.getLocalizedString("¿Cómo Calculamos la Probabilidad?"),
                description: localizationManager.getLocalizedString("Nuestro algoritmo utiliza modelos matemáticos avanzados"),
                icon: "function",
                iconColor: .purple,
                bulletPoints: [
                    localizationManager.getLocalizedString("Análisis de interacciones no lineales entre factores"),
                    localizationManager.getLocalizedString("Ponderación basada en evidencia científica (ESHRE 2023, ASRM 2024)"),
                    localizationManager.getLocalizedString("Calibración con cohortes de pacientes reales"),
                    localizationManager.getLocalizedString("Validación cruzada con resultados clínicos"),
                    localizationManager.getLocalizedString("Actualización continua con nueva evidencia")
                ],
                showMedicalDisclaimer: false
            ),
            
            // Página 4: Qué significan los resultados
            OnboardingPage(
                title: localizationManager.getLocalizedString("¿Qué Significan los Resultados?"),
                description: localizationManager.getLocalizedString("Los resultados son probabilidades estadísticas, no predicciones exactas"),
                icon: "chart.bar.fill",
                iconColor: .green,
                bulletPoints: [
                    localizationManager.getLocalizedString("Probabilidad de embarazo espontáneo en 12 meses"),
                    localizationManager.getLocalizedString("Factores críticos identificados automáticamente"),
                    localizationManager.getLocalizedString("Recomendaciones personalizadas basadas en tu perfil"),
                    localizationManager.getLocalizedString("Nivel de confianza del análisis (transparencia científica)"),
                    localizationManager.getLocalizedString("Sugerencias de seguimiento médico específico")
                ],
                showMedicalDisclaimer: false
            ),
            
            // Página 5: Limitaciones importantes
            OnboardingPage(
                title: "Limitaciones Importantes",
                description: "Es fundamental entender qué puede y qué NO puede hacer esta herramienta",
                icon: "exclamationmark.triangle.fill",
                iconColor: .orange,
                bulletPoints: [
                    "NO reemplaza la consulta médica profesional",
                    "NO diagnostica enfermedades ni condiciones médicas",
                    "Los resultados son orientativos, no definitivos",
                    "Cada caso es único y requiere evaluación individualizada",
                    "Siempre consulta con un especialista en medicina reproductiva"
                ],
                showMedicalDisclaimer: true
            ),
            
            // Página 6: Privacidad y seguridad
            OnboardingPage(
                title: localizationManager.getLocalizedString("Tu Privacidad es Nuestra Prioridad"),
                description: localizationManager.getLocalizedString("Todos tus datos se procesan de forma completamente local y segura"),
                icon: "lock.shield.fill",
                iconColor: .indigo,
                bulletPoints: [
                    localizationManager.getLocalizedString("Procesamiento 100% local en tu dispositivo"),
                    localizationManager.getLocalizedString("Sin transmisión de datos a servidores externos"),
                    localizationManager.getLocalizedString("Cifrado avanzado para almacenamiento local"),
                    localizationManager.getLocalizedString("Sin recopilación de datos personales identificables"),
                    localizationManager.getLocalizedString("Cumplimiento total con GDPR y regulaciones de privacidad")
                ],
                showMedicalDisclaimer: false
            )
        ]
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Fondo gradiente
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Barra de progreso
                    ProgressBar(currentPage: currentPage, totalPages: pages.count)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    
                    // Contenido de la página actual
                    TabView(selection: $currentPage) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            OnboardingPageView(page: pages[index])
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .animation(.easeInOut(duration: 0.3), value: currentPage)
                    
                    // Controles de navegación
                    NavigationControls(
                        currentPage: $currentPage,
                        totalPages: pages.count,
                        onComplete: {
                            completeOnboarding()
                        },
                        onSkip: {
                            showingSkipAlert = true
                        }
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .navigationBarHidden(true)
        }
        .alert(localizationManager.getLocalizedString("¿Omitir Introducción?"), isPresented: $showingSkipAlert) {
            Button(localizationManager.getLocalizedString("Cancelar"), role: .cancel) { }
            Button(localizationManager.getLocalizedString("Omitir")) {
                completeOnboarding()
            }
        } message: {
            Text(localizationManager.getLocalizedString("La introducción explica cómo funciona la aplicación y qué significan los resultados. ¿Estás seguro de que quieres omitirla?"))
        }
    }
    
    private func completeOnboarding() {
        // Marcar onboarding como completado
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        
        // Cerrar el onboarding
        withAnimation(.easeInOut(duration: 0.5)) {
            isPresented = false
        }
    }
}

// MARK: - Página de Onboarding

struct OnboardingPageView: View {
    let page: OnboardingPage
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Spacer(minLength: 20)
                
                // Icono principal
                ZStack {
                    Circle()
                        .fill(page.iconColor.opacity(0.2))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: page.icon)
                        .font(.system(size: 50, weight: .light))
                        .foregroundColor(page.iconColor)
                }
                .padding(.bottom, 10)
                
                // Título
                Text(page.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                // Descripción principal
                Text(page.description)
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                // Contenido específico
                VStack(spacing: 16) {
                    ForEach(page.bulletPoints, id: \.self) { point in
                        BulletPointView(text: point, color: page.iconColor)
                    }
                }
                .padding(.horizontal, 20)
                
                // Disclaimer médico (si aplica)
                if page.showMedicalDisclaimer {
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.orange)
                                                    Text(localizationManager.getLocalizedString("Importante"))
                            .font(.headline)
                            .foregroundColor(.orange)
                    }
                    
                    Text(localizationManager.getLocalizedString("Esta herramienta es de apoyo diagnóstico, siempre consulte a un médico profesional"))
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(8)
                    }
                    .padding(.horizontal, 20)
                }
                
                Spacer(minLength: 40)
            }
        }
    }
}

// MARK: - Componentes del Onboarding

struct BulletPointView: View {
    let text: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
                .padding(.top, 8)
            
            Text(text)
                .font(.body)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
    }
}

struct ProgressBar: View {
    let currentPage: Int
    let totalPages: Int
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(String(format: localizationManager.getLocalizedString("Paso %@ de %@"), "\(currentPage + 1)", "\(totalPages)"))
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 4)
                        .cornerRadius(2)
                    
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: geometry.size.width * CGFloat(currentPage + 1) / CGFloat(totalPages), height: 4)
                        .cornerRadius(2)
                        .animation(.easeInOut(duration: 0.3), value: currentPage)
                }
            }
            .frame(height: 4)
        }
    }
}

struct NavigationControls: View {
    @Binding var currentPage: Int
    let totalPages: Int
    let onComplete: () -> Void
    let onSkip: () -> Void
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        VStack(spacing: 16) {
            // Botones principales
            HStack(spacing: 16) {
                // Botón Anterior
                Button(action: {
                    if currentPage > 0 {
                        currentPage -= 1
                    }
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text(localizationManager.getLocalizedString("Anterior"))
                    }
                    .font(.headline)
                    .foregroundColor(currentPage > 0 ? .blue : .gray)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                    .background(Color(uiColor: .systemBackground))
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(currentPage > 0 ? Color.blue : Color.gray, lineWidth: 1)
                    )
                }
                .disabled(currentPage == 0)
                
                Spacer()
                
                // Botón Siguiente/Comenzar
                Button(action: {
                    if currentPage < totalPages - 1 {
                        currentPage += 1
                    } else {
                        onComplete()
                    }
                }) {
                    HStack {
                        Text(currentPage < totalPages - 1 ? localizationManager.getLocalizedString("Siguiente") : localizationManager.getLocalizedString("¡Comenzar!"))
                        if currentPage < totalPages - 1 {
                            Image(systemName: "chevron.right")
                        } else {
                            Image(systemName: "checkmark")
                        }
                    }
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: currentPage < totalPages - 1 ? [.blue, .blue.opacity(0.8)] : [.green, .green.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(25)
                    .shadow(color: .blue.opacity(0.3), radius: 4, x: 0, y: 2)
                }
            }
            
            // Botón Omitir
            Button(localizationManager.getLocalizedString("Omitir introducción")) {
                onSkip()
            }
            .font(.callout)
            .foregroundColor(.secondary)
        }
    }
}

// MARK: - Modelo de Datos del Onboarding

struct OnboardingPage {
    let title: String
    let description: String
    let icon: String
    let iconColor: Color
    let bulletPoints: [String]
    let showMedicalDisclaimer: Bool
}

// MARK: - Extensión para verificar si se completó el onboarding

extension UserDefaults {
    static var hasCompletedOnboarding: Bool {
        get {
            UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "hasCompletedOnboarding")
        }
    }
}

#Preview {
    OnboardingFlow(isPresented: .constant(true))
}
