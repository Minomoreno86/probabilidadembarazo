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
        isLoading = true
        
        let nonce = randomNonceString()
        currentNonce = nonce
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
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
        UserDefaults.standard.set(user.userID, forKey: "appleUserID")
        UserDefaults.standard.set(user.email, forKey: "userEmail")
        UserDefaults.standard.set(user.fullName, forKey: "userFullName")
        
        // Actualizar también los datos del perfil
        UserDefaults.standard.set(user.fullName, forKey: "userFullName")
        UserDefaults.standard.set(user.email, forKey: "userEmail")
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
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let nonce = currentNonce else {
            isLoading = false
            return
        }
        
        // Verificar el nonce
        guard let appleIDToken = appleIDCredential.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            isLoading = false
            return
        }
        
        // Crear usuario
        let user = AppleUser(
            userID: appleIDCredential.user,
            email: appleIDCredential.email ?? "",
            fullName: appleIDCredential.fullName?.formatted() ?? ""
        )
        
        // Guardar datos del usuario
        saveUserData(user)
        
        // Actualizar estado
        DispatchQueue.main.async {
            self.currentUser = user
            self.isAuthenticated = true
            self.isLoading = false
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple Sign In error: \(error.localizedDescription)")
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
