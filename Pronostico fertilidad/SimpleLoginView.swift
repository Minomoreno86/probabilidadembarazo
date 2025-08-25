//
//  SimpleLoginView.swift
//  Pronostico fertilidad
//
//  Simplified version of LoginView for testing
//

import SwiftUI

struct SimpleLoginView: View {
    @EnvironmentObject var appleSignInManager: AppleSignInManager
    @EnvironmentObject var authFlowManager: AuthenticationFlowManager
    @EnvironmentObject var localizationManager: LocalizationManager
    @State private var animateLogo = false
    @State private var animateContent = false
    
    var body: some View {
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
        .autoRefreshOnLanguageChange()
    }
    
    // MARK: - 🏥 LOGO SECTION
    private var logoSection: some View {
        VStack(spacing: 16) {
            // Logo animado
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
                    .scaleEffect(animateLogo ? 1.0 : 0.8)
                    .animation(.spring(response: 0.8, dampingFraction: 0.6), value: animateLogo)
                
                Image(systemName: "stethoscope")
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(.white)
                    .scaleEffect(animateLogo ? 1.0 : 0.9)
                    .animation(.easeInOut(duration: 1.0).delay(0.2), value: animateLogo)
            }
            
            VStack(spacing: 8) {
                Text(localizationManager.getLocalizedString("FertilyzeAI"))
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text(localizationManager.getLocalizedString("Medical Suite"))
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
            Text(localizationManager.getLocalizedString("Bienvenido"))
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            
            Text(localizationManager.getLocalizedString("Inicia sesión para acceder a herramientas médicas profesionales de fertilidad"))
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
                    
                    Text(localizationManager.getLocalizedString("Continuar con Apple"))
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
            
            // Continue without login button
            Button(action: continueWithoutLogin) {
                HStack {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.title2)
                    Text(localizationManager.getLocalizedString("Continuar sin cuenta"))
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
            // Disclaimer
            HStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
                Text(localizationManager.getLocalizedString("Herramienta de apoyo diagnóstico"))
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
            
            Text(localizationManager.getLocalizedString("Al continuar, aceptas nuestros términos de servicio y política de privacidad"))
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - 🔄 FUNCIONES
    private func handleAppleSignIn() {
        // Usar el AppleSignInManager real
        appleSignInManager.signInWithApple()
    }
    
    private func continueWithoutLogin() {
        // Verificar si ya hay un usuario autenticado con Apple
        if let existingUserID = UserDefaults.standard.string(forKey: "appleUserID"),
           existingUserID != "anonymous" {
            // Simplemente marcar como autenticado sin cambiar los datos
            DispatchQueue.main.async {
                self.authFlowManager.isAuthenticated = true
                self.authFlowManager.authenticationState = .authenticated
            }
        } else {
            // Continue without authentication
            authFlowManager.continueWithoutAccount()
        }
    }
}

// MARK: - 📱 PREVIEW
#Preview {
    SimpleLoginView()
}
