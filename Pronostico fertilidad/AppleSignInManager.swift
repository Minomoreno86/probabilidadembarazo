//
//  AppleSignInManager.swift
//  Pronostico fertilidad
//
//  Gestor de autenticación con Apple Sign In
//

import SwiftUI
import AuthenticationServices
import CryptoKit
#if os(iOS)
import UIKit
#endif

// MARK: - 🍎 APPLE SIGN IN MANAGER
class AppleSignInManager: NSObject, ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: AppleUser?
    @Published var isLoading = false
    
    // Estado para el challenge de seguridad
    private var currentNonce: String?
    
    override init() {
        super.init()
        // Verificar si hay una sesión activa al inicializar
        checkExistingCredentialState()
    }
    
    // MARK: - 🔐 AUTENTICACIÓN
    func signInWithApple() {
        print("🍎 Iniciando Apple Sign In...")
        isLoading = true
        
        // Verificar configuración
        checkAppleSignInConfiguration()
        
        #if targetEnvironment(simulator)
        // En el simulador, simular autenticación exitosa
        print("🍎 Simulador detectado - simulando autenticación...")
        simulateAppleSignIn()
        return
        #endif
        
        let nonce = randomNonceString()
        currentNonce = nonce
        print("🍎 Nonce generado: \(nonce)")
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        print("🍎 Creando controlador de autorización...")
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        
        print("🍎 Ejecutando solicitud de autorización...")
        authorizationController.performRequests()
    }
    
    func signOut() {
        // Revocar credenciales
        if let userID = currentUser?.userID {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: userID) { [weak self] state, error in
                DispatchQueue.main.async {
                    if state == .authorized {
                        // El usuario aún está autorizado, pero podemos limpiar localmente
                        self?.clearLocalUserData()
                    }
                }
            }
        }
        
        clearLocalUserData()
    }
    
    // MARK: - 🔍 VERIFICACIÓN DE CREDENCIALES
    private func checkExistingCredentialState() {
        guard let userID = UserDefaults.standard.string(forKey: "appleUserID") else {
            return
        }
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: userID) { [weak self] state, error in
            DispatchQueue.main.async {
                switch state {
                case .authorized:
                    // Usuario autorizado, cargar datos locales
                    self?.loadLocalUserData()
                case .revoked, .notFound:
                    // Usuario no autorizado, limpiar datos
                    self?.clearLocalUserData()
                default:
                    break
                }
            }
        }
    }
    
    // MARK: - 💾 GESTIÓN DE DATOS LOCALES
    private func saveUserData(_ user: AppleUser) {
        print("💾 Guardando datos del usuario en UserDefaults:")
        print("   - User ID: \(user.userID)")
        print("   - Email: \(user.email)")
        print("   - Full Name: \(user.fullName)")
        
        UserDefaults.standard.set(user.userID, forKey: "appleUserID")
        UserDefaults.standard.set(user.email, forKey: "userEmail")
        UserDefaults.standard.set(user.fullName, forKey: "userFullName")
        
        // Forzar sincronización
        UserDefaults.standard.synchronize()
        
        print("💾 Datos guardados exitosamente")
    }
    
    private func loadLocalUserData() {
        guard let userID = UserDefaults.standard.string(forKey: "appleUserID"),
              let email = UserDefaults.standard.string(forKey: "userEmail"),
              let fullName = UserDefaults.standard.string(forKey: "userFullName") else {
            return
        }
        
        currentUser = AppleUser(userID: userID, email: email, fullName: fullName)
        isAuthenticated = true
    }
    
    private func clearLocalUserData() {
        UserDefaults.standard.removeObject(forKey: "appleUserID")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "userFullName")
        
        currentUser = nil
        isAuthenticated = false
    }
    
    // MARK: - 🔒 UTILIDADES DE SEGURIDAD
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

// MARK: - 🍎 DELEGADOS DE AUTORIZACIÓN
extension AppleSignInManager: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        print("🍎 Autorización completada exitosamente")
        
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let nonce = currentNonce else {
            print("❌ Error: No se pudo obtener credencial o nonce")
            isLoading = false
            return
        }
        
        print("🍎 Credencial obtenida - User ID: \(appleIDCredential.user)")
        print("🍎 Email: \(appleIDCredential.email ?? "No disponible")")
        print("🍎 Nombre: \(appleIDCredential.fullName?.formatted() ?? "No disponible")")
        
        // Verificar el nonce
        guard let appleIDToken = appleIDCredential.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("❌ Error: No se pudo obtener token de identidad")
            isLoading = false
            return
        }
        
        print("🍎 Token de identidad obtenido correctamente")
        
        // Crear usuario con mejor manejo de datos faltantes
        let userEmail = appleIDCredential.email ?? ""
        let userFullName = appleIDCredential.fullName?.formatted() ?? ""
        
        print("🍎 Datos recibidos de Apple:")
        print("   - User ID: \(appleIDCredential.user)")
        print("   - Email: \(userEmail)")
        print("   - Full Name: \(userFullName)")
        
        // Si no tenemos nombre, intentar obtenerlo de UserDefaults (para usuarios que ya se autenticaron antes)
        let finalName: String
        if userFullName.isEmpty {
            let storedName = UserDefaults.standard.string(forKey: "userFullName") ?? ""
            finalName = storedName.isEmpty ? "Usuario" : storedName
            print("🍎 Usando nombre guardado: \(finalName)")
        } else {
            finalName = userFullName
        }
        
        // Si no tenemos email, intentar obtenerlo de UserDefaults
        let finalEmail: String
        if userEmail.isEmpty {
            let storedEmail = UserDefaults.standard.string(forKey: "userEmail") ?? ""
            finalEmail = storedEmail.isEmpty ? "" : storedEmail
            print("🍎 Usando email guardado: \(finalEmail)")
        } else {
            finalEmail = userEmail
        }
        
        let user = AppleUser(
            userID: appleIDCredential.user,
            email: finalEmail,
            fullName: finalName
        )
        
        print("🍎 Usuario final creado: \(user.displayName) - \(user.email)")
        
        // Guardar datos del usuario
        saveUserData(user)
        
        // Actualizar estado
        DispatchQueue.main.async {
            self.currentUser = user
            self.isAuthenticated = true
            self.isLoading = false
            print("🍎 Estado actualizado - Usuario autenticado: \(self.isAuthenticated)")
            
            // Notificar que la autenticación se completó exitosamente
            NotificationCenter.default.post(
                name: NSNotification.Name("AppleSignInCompleted"),
                object: user
            )
        }
    }
    
    // MARK: - 🔍 VERIFICACIÓN DE CONFIGURACIÓN
    private func checkAppleSignInConfiguration() {
        print("🔍 Verificando configuración de Apple Sign In...")
        
        // Verificar si Apple Sign In está disponible
        if ASAuthorizationAppleIDProvider.self != nil {
            print("✅ Apple Sign In está disponible")
        } else {
            print("❌ Apple Sign In no está disponible")
        }
        
        // Verificar Bundle ID
        if let bundleID = Bundle.main.bundleIdentifier {
            print("📦 Bundle ID: \(bundleID)")
        } else {
            print("❌ No se pudo obtener Bundle ID")
        }
        
        // Verificar entitlements
        if let entitlements = Bundle.main.infoDictionary?["com.apple.developer.applesignin"] as? [String] {
            print("✅ Apple Sign In entitlements encontrados: \(entitlements)")
        } else {
            print("⚠️ Apple Sign In entitlements no encontrados en Info.plist")
        }
    }
    
    // MARK: - 🎭 SIMULACIÓN PARA DESARROLLO
    private func simulateAppleSignIn() {
        print("🎭 Simulando autenticación de Apple Sign In...")
        
        // Simular delay para que parezca real
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Crear usuario simulado
            let simulatedUser = AppleUser(
                userID: "simulator_user_\(UUID().uuidString)",
                email: "",
                fullName: "Usuario"
            )
            
            print("🎭 Usuario simulado creado: \(simulatedUser.displayName)")
            
            // Guardar datos del usuario
            self.saveUserData(simulatedUser)
            
            // Actualizar estado
            DispatchQueue.main.async {
                self.currentUser = simulatedUser
                self.isAuthenticated = true
                self.isLoading = false
                print("🎭 Simulación completada - Usuario autenticado: \(self.isAuthenticated)")
                
                // Notificar que la autenticación se completó exitosamente
                NotificationCenter.default.post(
                    name: NSNotification.Name("AppleSignInCompleted"),
                    object: simulatedUser
                )
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("❌ Apple Sign In error: \(error.localizedDescription)")
        print("❌ Error details: \(error)")
        
        // Logging detallado para debugging
        if let authError = error as? ASAuthorizationError {
            print("🔍 ASAuthorizationError code: \(authError.code.rawValue)")
            switch authError.code {
            case .canceled:
                print("🔍 Usuario canceló la autenticación")
            case .failed:
                print("🔍 Autenticación falló")
            case .invalidResponse:
                print("🔍 Respuesta inválida")
            case .notHandled:
                print("🔍 Error no manejado")
            case .unknown:
                print("🔍 Error desconocido")
            @unknown default:
                print("🔍 Error no reconocido")
            }
        }
        
        // Verificar si es un error de configuración
        if let nsError = error as NSError? {
            print("🔍 NSError domain: \(nsError.domain)")
            print("🔍 NSError code: \(nsError.code)")
            print("🔍 NSError userInfo: \(nsError.userInfo)")
            
            // Si es un error de configuración, mostrar sugerencias
            if nsError.domain == "com.apple.AuthenticationServices.AuthorizationError" && nsError.code == 1001 {
                print("⚠️ Posible problema de configuración de Apple Sign In")
                print("💡 Verifica que:")
                print("   1. El proyecto tenga Apple Sign In habilitado en Capabilities")
                print("   2. El Bundle ID esté registrado en Apple Developer")
                print("   3. Los entitlements estén configurados correctamente")
            }
        }
        
        isLoading = false
    }
}

extension AppleSignInManager: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        #if os(iOS)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            fatalError("No window found")
        }
        return window
        #else
        fatalError("Apple Sign In not supported on macOS")
        #endif
    }
}

// MARK: - 👤 MODELO DE USUARIO
struct AppleUser {
    let userID: String
    let email: String
    let fullName: String
    
    var displayName: String {
        return fullName.isEmpty ? "Usuario Apple" : fullName
    }
    
    var initials: String {
        let components = fullName.components(separatedBy: " ")
        if components.count >= 2 {
            return "\(components[0].prefix(1))\(components[1].prefix(1))".uppercased()
        } else if !fullName.isEmpty {
            return String(fullName.prefix(2)).uppercased()
        } else {
            return "U"
        }
    }
}
