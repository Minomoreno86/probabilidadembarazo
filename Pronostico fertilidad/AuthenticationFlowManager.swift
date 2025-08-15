//
//  AuthenticationFlowManager.swift
//  Pronostico fertilidad
//
//  Gestor del flujo de autenticación de la aplicación
//

import SwiftUI

// MARK: - 🔐 GESTOR DE FLUJO DE AUTENTICACIÓN
class AuthenticationFlowManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var hasCompletedOnboarding = false
    
    // Estados de autenticación
    @Published var authenticationState: AuthenticationState = .checking
    
    init() {
        // Verificar estado de autenticación al inicializar
        checkAuthenticationState()
    }
    
    // MARK: - 🔍 VERIFICACIÓN DE ESTADO
    private func checkAuthenticationState() {
        // Verificar si hay datos de usuario guardados
        if let userID = UserDefaults.standard.string(forKey: "appleUserID"),
           let email = UserDefaults.standard.string(forKey: "userEmail"),
           let fullName = UserDefaults.standard.string(forKey: "userFullName") {
            
            // Usuario ya autenticado
            self.isAuthenticated = true
            self.authenticationState = .authenticated
            print("🔐 Usuario autenticado encontrado: \(fullName)")
        } else {
            // Usuario no autenticado
            self.isAuthenticated = false
            self.authenticationState = .notAuthenticated
            print("🔐 Usuario no autenticado")
        }
    }
    
    // MARK: - 🔐 AUTENTICACIÓN
    func authenticateUser(userID: String, email: String, fullName: String) {
        print("🔐 Iniciando autenticación para: \(fullName) - \(email)")
        
        // Guardar datos del usuario
        UserDefaults.standard.set(userID, forKey: "appleUserID")
        UserDefaults.standard.set(email, forKey: "userEmail")
        UserDefaults.standard.set(fullName, forKey: "userFullName")
        
        // Forzar sincronización
        UserDefaults.standard.synchronize()
        
        // Actualizar estado
        DispatchQueue.main.async {
            self.isAuthenticated = true
            self.authenticationState = .authenticated
        }
        
        print("🔐 Usuario autenticado exitosamente: \(fullName)")
        print("🔐 UserDefaults guardados - userID: \(userID), email: \(email), fullName: \(fullName)")
    }
    
    // MARK: - 🚪 LOGOUT
    func logout() {
        // Limpiar datos del usuario
        UserDefaults.standard.removeObject(forKey: "appleUserID")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "userFullName")
        
        // Actualizar estado
        DispatchQueue.main.async {
            self.isAuthenticated = false
            self.authenticationState = .notAuthenticated
        }
        
        print("🚪 Usuario desautenticado")
    }
    
    // MARK: - 👤 ACCESO SIN CUENTA
    func continueWithoutAccount() {
        print("👤 Iniciando acceso sin cuenta...")
        
        // Verificar si ya hay un usuario autenticado con Apple
        if let existingUserID = UserDefaults.standard.string(forKey: "appleUserID"),
           existingUserID != "anonymous" {
            print("👤 Usuario ya autenticado con Apple, manteniendo datos existentes")
            // No sobrescribir los datos del usuario autenticado
            DispatchQueue.main.async {
                self.isAuthenticated = true
                self.authenticationState = .authenticated
            }
        } else {
            print("👤 Configurando acceso anónimo")
            // Marcar como autenticado sin datos específicos
            UserDefaults.standard.set("anonymous", forKey: "appleUserID")
            UserDefaults.standard.set("", forKey: "userEmail")
            UserDefaults.standard.set("Usuario", forKey: "userFullName")
            
            // Actualizar estado
            DispatchQueue.main.async {
                self.isAuthenticated = true
                self.authenticationState = .authenticated
            }
        }
        
        print("👤 Usuario continúa sin cuenta")
    }
    
    // MARK: - 📊 DATOS DEL USUARIO
    var currentUser: UserData? {
        guard let userID = UserDefaults.standard.string(forKey: "appleUserID"),
              let email = UserDefaults.standard.string(forKey: "userEmail"),
              let fullName = UserDefaults.standard.string(forKey: "userFullName") else {
            print("🔍 Debug - No se encontraron datos de usuario en UserDefaults")
            return nil
        }
        
        print("🔍 Debug - Datos encontrados: \(fullName) - \(email)")
        return UserData(userID: userID, email: email, fullName: fullName)
    }
    
    var isAnonymousUser: Bool {
        return currentUser?.userID == "anonymous"
    }
}

// MARK: - 🔄 ESTADOS DE AUTENTICACIÓN
enum AuthenticationState: Equatable {
    case checking
    case notAuthenticated
    case authenticated
    case error(String)
    
    static func == (lhs: AuthenticationState, rhs: AuthenticationState) -> Bool {
        switch (lhs, rhs) {
        case (.checking, .checking),
             (.notAuthenticated, .notAuthenticated),
             (.authenticated, .authenticated):
            return true
        case (.error(let lhsMessage), .error(let rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}

// MARK: - 👤 DATOS DEL USUARIO
struct UserData: Equatable {
    let userID: String
    let email: String
    let fullName: String
    
    var displayName: String {
        return fullName.isEmpty ? "Usuario" : fullName
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
