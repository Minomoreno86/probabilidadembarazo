# 🌍 Guía de Localización - Pronostico Fertilidad

## 📋 Descripción General

Esta aplicación ahora soporta **localización completa** en español e inglés, permitiendo a los usuarios cambiar el idioma de la interfaz según sus preferencias.

## 🏗️ Estructura de Localización

### Archivos de Localización
```
Pronostico fertilidad/
├── Localization/
│   ├── es.lproj/
│   │   └── Localizable.strings    # Textos en español
│   └── en.lproj/
│       └── Localizable.strings    # Textos en inglés
├── String+Localization.swift      # Extensión para facilitar localización
├── LocalizationManager.swift      # Gestor de localización
└── LanguageSelectionView.swift    # Vista de selección de idioma
```

### Configuración del Proyecto
- **Info.plist**: Configurado con `CFBundleLocalizations` para español (es) e inglés (en)
- **CFBundleDevelopmentRegion**: Español como idioma por defecto

## 🚀 Cómo Usar la Localización

### 1. Texto Simple
```swift
// Antes (hardcodeado)
Text("Bienvenido")

// Ahora (localizado)
Text("Bienvenido".localized)
// o
Text(LocalizationKeys.welcome.localized)
```

### 2. Texto con Argumentos
```swift
// Antes
Text("\(profiles.count) evaluación completada")

// Ahora
Text(LocalizationKeys.singleAssessment.localized(with: profiles.count))
```

### 3. Usando la Extensión de View
```swift
// Con la extensión personalizada
Text("Bienvenido").localizedText("Bienvenido")

// Con argumentos
Text("... y %d más").localizedText("... y %d más", with: count)
```

## 🔧 Gestión de Idiomas

### LocalizationManager
```swift
// Obtener instancia
let manager = LocalizationManager.shared

// Cambiar idioma
manager.setLanguage(.english)

// Obtener texto localizado
let text = manager.getLocalizedString("Bienvenido")
```

### Cambio de Idioma en la UI
1. Ir a **Configuración** → **Idioma**
2. Seleccionar el idioma deseado
3. La aplicación se reiniciará automáticamente

## 📝 Agregar Nuevos Textos

### 1. Agregar al archivo de localización
```strings
// En es.lproj/Localizable.strings
"Nuevo Texto" = "Nuevo Texto";

// En en.lproj/Localizable.strings  
"Nuevo Texto" = "New Text";
```

### 2. Agregar a LocalizationKeys
```swift
// En String+Localization.swift
struct LocalizationKeys {
    static let newText = "Nuevo Texto"
}
```

### 3. Usar en el código
```swift
Text(LocalizationKeys.newText.localized)
```

## 🎯 Mejores Prácticas

### ✅ Hacer
- Usar siempre claves descriptivas
- Mantener consistencia en el formato
- Usar argumentos para texto dinámico
- Agrupar textos relacionados en secciones

### ❌ Evitar
- Texto hardcodeado en el código
- Claves genéricas como "text1", "text2"
- Mezclar idiomas en la misma vista
- Olvidar agregar traducciones en ambos idiomas

## 🔍 Verificación de Localización

### 1. Cambiar idioma en la app
- Ir a Configuración → Idioma
- Verificar que todos los textos cambien

### 2. Verificar en Xcode
- Cambiar el idioma del simulador
- Ejecutar la app
- Verificar que los textos se muestren correctamente

### 3. Verificar archivos .strings
- Asegurar que todas las claves estén en ambos archivos
- Verificar que no haya claves duplicadas
- Comprobar que los argumentos (%d, %@) coincidan

## 🐛 Solución de Problemas

### Texto no se localiza
1. Verificar que la clave existe en ambos archivos .strings
2. Verificar que se esté usando `.localized`
3. Limpiar y reconstruir el proyecto

### Error de formato
1. Verificar que los argumentos coincidan entre idiomas
2. Verificar que no haya caracteres especiales mal escapados
3. Verificar la sintaxis de los archivos .strings

### Cambio de idioma no funciona
1. Verificar que LocalizationManager esté configurado correctamente
2. Verificar que se esté llamando a `setLanguage`
3. Verificar que la app se reinicie después del cambio

## 📚 Recursos Adicionales

- [Apple Localization Guide](https://developer.apple.com/documentation/xcode/localization)
- [NSLocalizedString Documentation](https://developer.apple.com/documentation/foundation/nslocalizedstring)
- [SwiftUI Localization](https://developer.apple.com/documentation/swiftui/text/localized)

## 🤝 Contribución

Para agregar soporte para un nuevo idioma:

1. Crear carpeta `[código_idioma].lproj/`
2. Crear archivo `Localizable.strings` con traducciones
3. Agregar código del idioma a `Info.plist`
4. Agregar caso al enum `Language` en `LocalizationManager`
5. Actualizar `LanguageSelectionView`

---

**Nota**: Esta guía se actualiza regularmente. Para preguntas o problemas, consultar la documentación oficial de Apple o contactar al equipo de desarrollo.
