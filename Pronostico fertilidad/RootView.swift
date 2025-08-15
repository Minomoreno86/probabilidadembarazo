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
    @Environment(\.themeColors) var colors
    
    var body: some View {
        Group {
            switch authFlowManager.authenticationState {
            case .checking:
                // Pantalla de carga mientras verifica autenticación
                loadingView
                
            case .notAuthenticated:
                // Mostrar pantalla de login
                SimpleLoginView()
                    .environmentObject(themeManager)
                    .environmentObject(authFlowManager)
                
            case .authenticated:
                // Mostrar contenido principal
                ContentView()
                    .environmentObject(themeManager)
                    .environmentObject(appleSignInManager)
                    .environmentObject(authFlowManager)
                
            case .error(let message):
                // Mostrar error de autenticación
                errorView(message: message)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: authFlowManager.authenticationState)
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
