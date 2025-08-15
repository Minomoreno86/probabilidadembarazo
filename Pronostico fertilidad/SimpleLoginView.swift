//
//  SimpleLoginView.swift
//  Pronostico fertilidad
//
//  Versión simplificada de LoginView para pruebas
//

import SwiftUI

struct SimpleLoginView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authFlowManager: AuthenticationFlowManager
    @State private var animateLogo = false
    @State private var animateContent = false
    
    private var colors: ThemeColors {
        ThemeColors.current(authFlowManager.currentTheme)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Fondo con gradiente adaptativo al tema
                colors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    // Logo y branding
                    logoSection
                    
                    // Contenido principal
                    VStack(spacing: 32) {
                        welcomeSection
                        loginSection
                        disclaimerSection
                    }
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 30)
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2)) {
                animateLogo = true
            }
            withAnimation(.easeInOut(duration: 1.0).delay(0.3)) {
                animateContent = true
            }
        }
    }
    
    // MARK: - 🏥 LOGO SECTION
    private var logoSection: some View {
        VStack(spacing: 16) {
                            // Logo animado
                ZStack {
                    Circle()
                        .fill(colors.accentGradient)
                        .frame(width: 120, height: 120)
                        .scaleEffect(animateLogo ? 1.0 : 0.8)
                        .animation(.spring(response: 0.8, dampingFraction: 0.6), value: animateLogo)
                    
                    Image(systemName: "stethoscope")
                        .font(.system(size: 50, weight: .light))
                        .foregroundColor(.white)
                        .scaleEffect(animateLogo ? 1.0 : 0.9)
                        .animation(.easeInOut(duration: 1.0).delay(0.2), value: animateLogo)
                }
            
            VStack(spacing: 8) {
                Text("FertilyzeAI")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Medical Suite")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            }
            .opacity(animateLogo ? 1.0 : 0.0)
            .animation(.easeInOut(duration: 1.0).delay(0.4), value: animateLogo)
        }
    }
    
    // MARK: - 👋 WELCOME SECTION
    private var welcomeSection: some View {
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
    }
    
    // MARK: - 🔐 LOGIN SECTION
    private var loginSection: some View {
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
            
            // Botón de continuar sin login
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
    }
    
    // MARK: - ⚠️ DISCLAIMER SECTION
    private var disclaimerSection: some View {
        VStack(spacing: 12) {
            // Disclaimer temporal
            HStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.yellow)
                Text("Herramienta de apoyo diagnóstico")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.yellow.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.yellow.opacity(0.4), lineWidth: 1)
                    )
            )
            
            Text("Al continuar, aceptas nuestros términos de servicio y política de privacidad")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - 🔄 FUNCIONES
    private func handleAppleSignIn() {
        print("🍎 Apple Sign In presionado!")
        // Simular autenticación exitosa
        let mockUser = AppleUser(userID: "test123", email: "test@example.com", fullName: "Usuario Test")
        authFlowManager.authenticateUser(mockUser)
        dismiss()
    }
    
    private func continueWithoutLogin() {
        print("➡️ Continuar sin cuenta presionado!")
        authFlowManager.continueWithoutAuthentication()
        dismiss()
    }
}

// MARK: - 📱 PREVIEW
#Preview {
    SimpleLoginView()
}
