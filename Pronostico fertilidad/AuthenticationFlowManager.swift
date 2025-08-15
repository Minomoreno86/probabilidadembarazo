//
//  AuthenticationFlowManager.swift
//  Pronostico fertilidad
//
//  Gestor del flujo de autenticación
//

import SwiftUI
import Combine

// MARK: - 🔐 AUTHENTICATION FLOW MANAGER
class AuthenticationFlowManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var hasCompletedOnboarding = false
    @Published var currentUser: AppleUser?
    
    // Estado de carga inicial
    @Published var isLoading = true
    
    // Integración con el sistema de temas
    @Published var currentTheme: AppTheme = .light
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Cargar tema guardado
        loadSavedTheme()
        
        // Verificar estado de autenticación al inicializar
        checkAuthenticationState()
    }
    
    // MARK: - 🎨 GESTIÓN DE TEMAS
    private func loadSavedTheme() {
        if let savedTheme = UserDefaults.standard.string(forKey: "selectedTheme") {
            switch savedTheme {
            case "light":
                currentTheme = .light
            case "dark":
                currentTheme = .dark
            case "pink":
                currentTheme = .pink
            default:
                currentTheme = .light
            }
        } else {
            currentTheme = .light
        }
    }
    
    func setTheme(_ theme: AppTheme) {
        currentTheme = theme
        UserDefaults.standard.set(theme.rawValue, forKey: "selectedTheme")
    }
    
    // MARK: - 🔍 VERIFICACIÓN DE ESTADO
    private func checkAuthenticationState() {
        // Simular verificación (en producción esto verificaría credenciales reales)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoading = false
            
            // Verificar si hay datos de usuario guardados
            if let userID = UserDefaults.standard.string(forKey: "appleUserID"),
               let email = UserDefaults.standard.string(forKey: "userEmail"),
               let fullName = UserDefaults.standard.string(forKey: "userFullName") {
                
                self.currentUser = AppleUser(userID: userID, email: email, fullName: fullName)
                self.isAuthenticated = true
                self.hasCompletedOnboarding = true
            } else {
                // No hay usuario autenticado
                self.isAuthenticated = false
                self.hasCompletedOnboarding = false
            }
        }
    }
    
    // MARK: - 🔐 AUTENTICACIÓN
    func authenticateUser(_ user: AppleUser) {
        self.currentUser = user
        self.isAuthenticated = true
        self.hasCompletedOnboarding = true
        
        // Guardar datos del usuario
        UserDefaults.standard.set(user.userID, forKey: "appleUserID")
        UserDefaults.standard.set(user.email, forKey: "userEmail")
        UserDefaults.standard.set(user.fullName, forKey: "userFullName")
    }
    
    func signOut() {
        // Limpiar datos del usuario
        UserDefaults.standard.removeObject(forKey: "appleUserID")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "userFullName")
        
        self.currentUser = nil
        self.isAuthenticated = false
        self.hasCompletedOnboarding = false
    }
    
    // MARK: - 🚀 CONTINUAR SIN AUTENTICACIÓN
    func continueWithoutAuthentication() {
        self.isAuthenticated = false
        self.hasCompletedOnboarding = true
    }
    
    // MARK: - 📱 DETERMINAR PANTALLA INICIAL
    var initialView: some View {
        Group {
            if isLoading {
                LoadingView()
            } else if !hasCompletedOnboarding {
                LoginView()
            } else {
                MainContentView()
            }
        }
    }
}

// MARK: - ⏳ PANTALLA DE CARGA
struct LoadingView: View {
    @EnvironmentObject var authManager: AuthenticationFlowManager
    @State private var animateLogo = false
    @State private var animateText = false
    
    private var colors: ThemeColors {
        ThemeColors.current(authManager.currentTheme)
    }
    
    var body: some View {
        ZStack {
            // Fondo con gradiente adaptativo al tema
            colors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Logo animado
                ZStack {
                    Circle()
                        .fill(colors.accentGradient)
                        .frame(width: 120, height: 120)
                        .scaleEffect(animateLogo ? 1.0 : 0.8)
                        .animation(.spring(response: 0.8, dampingFraction: 0.6).repeatForever(autoreverses: true), value: animateLogo)
                    
                    Image(systemName: "stethoscope")
                        .font(.system(size: 50, weight: .light))
                        .foregroundColor(.white)
                        .scaleEffect(animateLogo ? 1.1 : 0.9)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animateLogo)
                }
                
                VStack(spacing: 8) {
                    Text("FertilyzeAI")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .opacity(animateText ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 1.0).delay(0.3), value: animateText)
                    
                    Text("Medical Suite")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .opacity(animateText ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 1.0).delay(0.5), value: animateText)
                }
                
                // Indicador de carga
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.2)
                    .opacity(animateText ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 1.0).delay(0.7), value: animateText)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                animateLogo = true
            }
            withAnimation(.easeInOut(duration: 1.0).delay(0.2)) {
                animateText = true
            }
        }
    }
}

// MARK: - 🏠 CONTENIDO PRINCIPAL
struct MainContentView: View {
    @EnvironmentObject var authManager: AuthenticationFlowManager
    @EnvironmentObject var appleSignInManager: AppleSignInManager
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                // Usuario autenticado - mostrar ContentView normal
                ContentView()
            } else {
                // Usuario no autenticado - mostrar versión limitada
                LimitedContentView()
            }
        }
    }
}

// MARK: - 🔒 CONTENIDO LIMITADO
struct LimitedContentView: View {
    @EnvironmentObject var authManager: AuthenticationFlowManager
    @State private var showingLogin = false
    
    private var colors: ThemeColors {
        ThemeColors.current(authManager.currentTheme)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                colors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    // Header con botón de login
                    HStack {
                        Spacer()
                        Button(action: { showingLogin = true }) {
                            HStack(spacing: 8) {
                                Image(systemName: "person.circle.fill")
                                    .font(.title2)
                                Text("Iniciar Sesión")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    )
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 60)
                    
                    // Contenido principal
                    VStack(spacing: 30) {
                        // Logo
                        VStack(spacing: 16) {
                            Image(systemName: "stethoscope")
                                .font(.system(size: 60, weight: .light))
                                .foregroundColor(.white)
                                .padding(20)
                                .background(
                                    Circle()
                                        .fill(.ultraThinMaterial)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                        )
                                )
                            
                            VStack(spacing: 8) {
                                Text("FertilyzeAI")
                                    .font(.system(size: 36, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                Text("Medical Suite")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                        
                        // Mensaje de bienvenida
                        VStack(spacing: 16) {
                            Text("Bienvenido a FertilyzeAI")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            Text("Herramientas médicas profesionales para el análisis de fertilidad")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white.opacity(0.9))
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                        }
                        
                        // Botón de acceso
                        Button(action: { showingLogin = true }) {
                            HStack(spacing: 12) {
                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.title2)
                                Text("Acceder a Herramientas")
                                    .font(.system(size: 18, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(colors.accentGradient)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    )
                            )
                            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showingLogin) {
            LoginView()
        }
    }
}
