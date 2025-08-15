//
//  RootView.swift
//  Pronostico fertilidad
//
//  Vista raíz que maneja el flujo de autenticación
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var authFlowManager: AuthenticationFlowManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var appleSignInManager: AppleSignInManager
    @EnvironmentObject var userFontManager: UserFontManager
    @Environment(\.themeColors) var colors
    
    var body: some View {
        Group {
            switch authFlowManager.authenticationState {
            case .checking:
                // Pantalla de carga mientras verifica autenticación
                loadingView
                
            case .notAuthenticated:
                // Mostrar pantalla de login simplificada
                loginView
                
            case .authenticated:
                // Mostrar contenido principal
                ContentView()
                    .environmentObject(themeManager)
                    .environmentObject(appleSignInManager)
                    .environmentObject(authFlowManager)
                    .environmentObject(userFontManager)
                
            case .error(let message):
                // Mostrar error de autenticación
                errorView(message: message)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: authFlowManager.authenticationState)
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("AppleSignInCompleted"))) { notification in
            if let user = notification.object as? AppleUser {
                // Sincronizar con el AuthenticationFlowManager
                authFlowManager.authenticateUser(
                    userID: user.userID,
                    email: user.email,
                    fullName: user.fullName
                )
            }
        }
    }
    
    // MARK: - 🔐 PANTALLA DE LOGIN
    private var loginView: some View {
        NavigationView {
            ZStack {
                // Fondo con gradiente
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    // Logo
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.cyan, Color.blue]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)
                            
                            Image(systemName: "stethoscope")
                                .font(.system(size: 50, weight: .light))
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 8) {
                            Text("FertilyzeAI")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("Medical Suite")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    
                    // Contenido principal
                    VStack(spacing: 32) {
                        // Welcome
                        VStack(spacing: 16) {
                            Text("Bienvenido")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Inicia sesión para acceder a herramientas médicas profesionales de fertilidad")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white.opacity(0.9))
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                        }
                        
                        // Login buttons
                        VStack(spacing: 24) {
                            // Apple Sign In Button
                            Button(action: handleAppleSignIn) {
                                HStack(spacing: 12) {
                                    Image(systemName: "applelogo")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                    
                                    Text("Continuar con Apple")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 24)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.black)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                        )
                                )
                            }
                            .frame(height: 56)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                            
                            // Continue without login
                            Button(action: continueWithoutLogin) {
                                HStack {
                                    Image(systemName: "arrow.right.circle.fill")
                                        .font(.title2)
                                    Text("Continuar sin cuenta")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                .foregroundColor(.white.opacity(0.8))
                                .padding(.vertical, 16)
                                .padding(.horizontal, 24)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                        )
                                )
                            }
                        }
                        
                        // Disclaimer
                        VStack(spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.orange)
                                Text("Herramienta de apoyo diagnóstico")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.orange.opacity(0.2))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.orange.opacity(0.4), lineWidth: 1)
                                    )
                            )
                            
                            Text("Al continuar, aceptas nuestros términos de servicio y política de privacidad")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)
            }
        }
        .onChange(of: appleSignInManager.isAuthenticated) { _, isAuthenticated in
            if isAuthenticated, let user = appleSignInManager.currentUser {
                // Sincronizar con el AuthenticationFlowManager
                authFlowManager.authenticateUser(
                    userID: user.userID,
                    email: user.email,
                    fullName: user.fullName
                )
            }
        }
    }
    
    // MARK: - 🔄 FUNCIONES DE LOGIN
    private func handleAppleSignIn() {
        appleSignInManager.signInWithApple()
    }
    
    private func continueWithoutLogin() {
        authFlowManager.continueWithoutAccount()
    }
    
    // MARK: - ⏳ PANTALLA DE CARGA
    private var loadingView: some View {
        ZStack {
            colors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Logo animado
                ZStack {
                    Circle()
                        .fill(colors.accentGradient)
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "stethoscope")
                        .font(.system(size: 40, weight: .light))
                        .foregroundColor(.white)
                }
                .scaleEffect(1.0)
                .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: true)
                
                VStack(spacing: 8) {
                    Text("FertilyzeAI")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Verificando autenticación...")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
        }
    }
    
    // MARK: - ❌ PANTALLA DE ERROR
    private func errorView(message: String) -> some View {
        ZStack {
            colors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Icono de error
                ZStack {
                    Circle()
                        .fill(colors.error.opacity(0.2))
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 40, weight: .medium))
                        .foregroundColor(colors.error)
                }
                
                VStack(spacing: 16) {
                    Text("Error de Autenticación")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(message)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                    
                    // Botón para reintentar
                    Button(action: {
                        authFlowManager.authenticationState = .checking
                        // Reintentar verificación
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            authFlowManager.authenticationState = .notAuthenticated
                        }
                    }) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Reintentar")
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(colors.error.opacity(0.3))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(colors.error.opacity(0.5), lineWidth: 1)
                                )
                        )
                    }
                }
            }
            .padding(.horizontal, 32)
        }
    }
}

// MARK: - 📱 PREVIEW
#Preview {
    RootView()
        .environmentObject(ThemeManager())
        .environmentObject(AppleSignInManager())
        .environmentObject(AuthenticationFlowManager())
}
