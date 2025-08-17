//
//  PasskeysManager.swift
//  Pronostico fertilidad
//
//  Gestor de autenticación con Passkeys para máxima seguridad HIPAA
//

import SwiftUI
import AuthenticationServices
import CryptoKit
import Security
import LocalAuthentication
#if os(iOS)
import UIKit
#endif

// MARK: - 🔐 PASSKEYS MANAGER
class PasskeysManager: NSObject, ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: PasskeyUser?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Estado para el challenge de seguridad
    private var currentChallenge: Data?
    private var currentRelyingPartyIdentifier: String = "pronostico-fertilidad.com"
    
    override init() {
        super.init()
        checkExistingPasskeyCredentials()
    }
    
    // MARK: - 🔐 REGISTRO DE PASSKEY
    func registerPasskey(userID: String, displayName: String) {
        isLoading = true
        errorMessage = nil
        
        let challenge = Data((0..<32).map { _ in UInt8.random(in: 0...255) })
        currentChallenge = challenge
        
        let publicKeyCredentialProvider = ASAuthorizationPlatformPublicKeyCredentialProvider(
            relyingPartyIdentifier: currentRelyingPartyIdentifier
        )
        
        let registrationRequest = publicKeyCredentialProvider.createCredentialRegistrationRequest(
            challenge: challenge,
            name: displayName,
            userID: userID.data(using: .utf8)!
        )
        
        let authorizationController = ASAuthorizationController(
            authorizationRequests: [registrationRequest]
        )
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        
        authorizationController.performRequests()
    }
    
    // MARK: - 🔑 AUTENTICACIÓN CON PASSKEY
    func authenticateWithPasskey() {
        isLoading = true
        errorMessage = nil
        
        let challenge = Data((0..<32).map { _ in UInt8.random(in: 0...255) })
        currentChallenge = challenge
        
        let publicKeyCredentialProvider = ASAuthorizationPlatformPublicKeyCredentialProvider(
            relyingPartyIdentifier: currentRelyingPartyIdentifier
        )
        
        let assertionRequest = publicKeyCredentialProvider.createCredentialAssertionRequest(
            challenge: challenge
        )
        
        let authorizationController = ASAuthorizationController(
            authorizationRequests: [assertionRequest]
        )
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        
        authorizationController.performRequests()
    }
    
    // MARK: - 🔍 VERIFICACIÓN DE CREDENCIALES
    private func checkExistingPasskeyCredentials() {
        // Verificar si hay datos de usuario guardados
        if let userData = loadUserDataSecurely() {
            currentUser = userData
            isAuthenticated = true
        } else {
            isAuthenticated = false
        }
    }
    
    // MARK: - 🗑️ ELIMINACIÓN DE PASSKEY
    func deletePasskey() {
        isAuthenticated = false
        currentUser = nil
        clearUserDataSecurely()
    }
    
    // MARK: - 🔄 CERRAR SESIÓN
    func signOut() {
        isAuthenticated = false
        currentUser = nil
        clearUserDataSecurely()
    }
}

// MARK: - 🎯 DELEGADOS DE AUTORIZACIÓN
extension PasskeysManager: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        isLoading = false
        
        switch authorization.credential {
        case let credentialRegistration as ASAuthorizationPlatformPublicKeyCredentialRegistration:
            // Registro exitoso
            handleSuccessfulRegistration(credentialRegistration)
            
        case let credentialAssertion as ASAuthorizationPlatformPublicKeyCredentialAssertion:
            // Autenticación exitosa
            handleSuccessfulAssertion(credentialAssertion)
            
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        isLoading = false
        
        let authError = error as? ASAuthorizationError
        switch authError?.code {
        case .canceled:
            errorMessage = "Autenticación cancelada"
        case .failed:
            errorMessage = "Error de autenticación"
        case .invalidResponse:
            errorMessage = "Respuesta inválida"
        case .notHandled:
            errorMessage = "No se pudo procesar la autenticación"
        case .unknown:
            errorMessage = "Error desconocido"
        default:
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - ✅ MANEJO DE REGISTRO
    private func handleSuccessfulRegistration(_ registration: ASAuthorizationPlatformPublicKeyCredentialRegistration) {
        let user = PasskeyUser(
            userID: UUID().uuidString,
            displayName: "Usuario Passkey",
            credentialID: registration.credentialID,
            createdAt: Date()
        )
        
        currentUser = user
        isAuthenticated = true
        
        // Guardar datos localmente de forma segura
        saveUserDataSecurely(user)
    }
    
    // MARK: - ✅ MANEJO DE AUTENTICACIÓN
    private func handleSuccessfulAssertion(_ assertion: ASAuthorizationPlatformPublicKeyCredentialAssertion) {
        // Cargar datos del usuario
        if let userData = loadUserDataSecurely() {
            currentUser = userData
        } else {
            // Crear usuario temporal si no existe
            let user = PasskeyUser(
                userID: UUID().uuidString,
                displayName: "Usuario Passkey",
                credentialID: assertion.credentialID,
                createdAt: Date()
            )
            currentUser = user
            saveUserDataSecurely(user)
        }
        
        isAuthenticated = true
    }
}

// MARK: - 📱 CONTEXTO DE PRESENTACIÓN
extension PasskeysManager: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        #if os(iOS)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            fatalError("No window available")
        }
        return window
        #else
        fatalError("Passkeys only supported on iOS")
        #endif
    }
}

// MARK: - 👤 MODELO DE USUARIO
struct PasskeyUser: Codable {
    let userID: String
    let displayName: String
    let credentialID: Data
    let createdAt: Date
    
    init(userID: String, displayName: String, credentialID: Data, createdAt: Date = Date()) {
        self.userID = userID
        self.displayName = displayName
        self.credentialID = credentialID
        self.createdAt = createdAt
    }
}

// MARK: - 🔒 ALMACENAMIENTO SEGURO
extension PasskeysManager {
    private func saveUserDataSecurely(_ user: PasskeyUser) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "passkey_user_\(user.userID)",
            kSecValueData as String: try? JSONEncoder().encode(user),
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
            kSecAttrSynchronizable as String: false
        ]
        
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status != errSecSuccess {
            print("Error saving user data: \(status)")
        }
    }
    
    private func loadUserDataSecurely() -> PasskeyUser? {
        // Buscar cualquier usuario guardado
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "passkey_user_*",
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess,
           let data = result as? Data,
           let user = try? JSONDecoder().decode(PasskeyUser.self, from: data) {
            return user
        }
        return nil
    }
    
    private func clearUserDataSecurely() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "passkey_user_*"
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}

// MARK: - 🎨 EXTENSIONES DE UI
extension PasskeysManager {
    var biometricType: String {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            switch context.biometryType {
            case .faceID:
                return "Face ID"
            case .touchID:
                return "Touch ID"
            default:
                return "Biometría"
            }
        }
        return "Autenticación"
    }
    
    var biometricIcon: String {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            switch context.biometryType {
            case .faceID:
                return "faceid"
            case .touchID:
                return "touchid"
            default:
                return "lock.shield"
            }
        }
        return "lock.shield"
    }
}
