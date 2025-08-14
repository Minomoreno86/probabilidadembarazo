# Pronóstico de Fertilidad - iOS/macOS App

Una aplicación nativa de iOS/macOS desarrollada en SwiftUI para el cálculo y análisis de probabilidades de fertilidad, basada en la aplicación React Native existente.

## 🚀 Características

### 📊 Calculadora Médica Completa
- **Información Demográfica**: Edad, altura, peso con cálculo automático de BMI
- **Historia Ginecológica**: Endometriosis, miomas, adenomiosis, HSG, OTB
- **Pruebas de Laboratorio**: AMH, TSH, prolactina, insulina, glucosa con cálculo automático de HOMA-IR
- **Factor Masculino**: Espermatograma completo (concentración, motilidad, morfología, volumen)

### 🧮 Motor de Cálculo Avanzado
- Algoritmo basado en evidencia médica
- Evaluación de múltiples factores de fertilidad
- Probabilidades anuales y mensuales
- Categorización de resultados (BUENO, MODERADO, BAJO)

### 📱 Interfaz de Usuario Moderna
- Diseño nativo SwiftUI
- Navegación intuitiva por pestañas
- Formularios con validación en tiempo real
- Gradientes y animaciones fluidas
- Barra de progreso de completitud
- Modo claro/oscuro automático

### 💾 Persistencia de Datos
- SwiftData para almacenamiento local
- Historial de evaluaciones
- Resultados de cálculos guardados
- Sincronización automática

## 🏗️ Arquitectura

### Modelos de Datos
- `FertilityProfile`: Modelo principal con toda la información médica
- `FertilityCalculationResult`: Resultados de cálculos
- Enums tipados para datos médicos (MyomaType, AdenomyosisType, etc.)

### Motor de Cálculo
- `FertilityCalculationEngine`: Lógica de cálculo principal
- Factores de modificación basados en literatura médica
- Probabilidades base por edad
- Evaluación integral de factores de riesgo

### Vistas Principales
- `ContentView`: Pantalla principal con lista de perfiles
- `FertilityCalculatorView`: Formulario de evaluación
- `FertilityResultsView`: Presentación de resultados
- Componentes reutilizables para formularios

## 🔧 Requisitos Técnicos

- **iOS**: 17.0+
- **macOS**: 14.0+
- **Xcode**: 15.0+
- **Swift**: 5.9+
- **SwiftUI**: Framework principal
- **SwiftData**: Persistencia de datos

## 📋 Instalación

1. Clona el repositorio
2. Abre `Pronostico fertilidad.xcodeproj` en Xcode
3. Selecciona tu dispositivo/simulador
4. Ejecuta el proyecto (⌘+R)

## 🏥 Funcionalidades Médicas

### Cálculo de BMI
- Automático basado en altura y peso
- Categorización clínica
- Interpretación del impacto en fertilidad

### Cálculo de HOMA-IR
- Índice de resistencia a la insulina
- Basado en glucosa e insulina en ayunas
- Evaluación de riesgo metabólico

### Evaluación de Factores
- **Edad**: Probabilidad base según rango etario
- **BMI**: Impacto de bajo peso, sobrepeso y obesidad
- **PCOS**: Síndrome de ovario poliquístico
- **Endometriosis**: Grados 1-4 con diferentes impactos
- **Miomas**: Submucosos, intramurales, subserosos
- **Factor Masculino**: Análisis completo de espermatograma
- **Factores Tubáricos**: HSG y obstrucciones
- **Factores Hormonales**: TSH, prolactina, AMH

### Recomendaciones Personalizadas
- Basadas en los factores de riesgo identificados
- Sugerencias de estilo de vida
- Recomendaciones de seguimiento médico
- Indicaciones para especialistas

## 📊 Algoritmo de Cálculo

### Probabilidad Base por Edad
- ≤24 años: 25% (fertilidad máxima)
- 25-29 años: 22.5% (fertilidad excelente)
- 30-34 años: 17.5% (buena fertilidad)
- 35-39 años: 10% (fecundidad en descenso)
- 40-44 años: 5% (baja tasa de embarazo)
- 45-49 años: 1.5% (probabilidad muy baja)
- ≥50 años: 0.5% (edad extrema)

### Factores de Modificación
Cada factor aplica un multiplicador a la probabilidad base:
- **BMI bajo peso**: x0.9
- **BMI sobrepeso**: x0.9
- **BMI obesidad**: x0.8
- **PCOS no tratado**: x0.7
- **Endometriosis grado 1-2**: x0.9
- **Endometriosis grado 3-4**: x0.7
- **Mioma submucoso**: x0.6
- **Factor masculino severo**: x0.4
- **Obstrucción tubárica bilateral**: x0.3

## 🔄 Migración desde React Native

Esta aplicación está basada en la aplicación React Native existente del usuario, manteniendo:
- ✅ Misma lógica de cálculo médico
- ✅ Estructura de datos compatible
- ✅ Flujo de usuario similar
- ✅ Funcionalidades completas
- ✅ Interfaz mejorada para plataformas nativas

### Ventajas de la Versión Nativa
- 🚀 Rendimiento superior
- 📱 Integración nativa con iOS/macOS
- 💾 SwiftData para mejor persistencia
- 🎨 Animaciones fluidas nativas
- 🔒 Mejor seguridad y privacidad
- 📦 Menor tamaño de aplicación
- ⚡ Arranque más rápido

## 🧪 Testing

El proyecto incluye:
- Tests unitarios para el motor de cálculo
- Tests de integración para SwiftData
- Tests de UI para flujos principales
- Validación de algoritmos médicos

## 📈 Roadmap

### Próximas Funcionalidades
- [ ] Gráficos de tendencias
- [ ] Exportación de reportes PDF
- [ ] Recordatorios de seguimiento
- [ ] Integración con HealthKit
- [ ] Modo offline completo
- [ ] Sincronización en la nube
- [ ] Múltiples idiomas
- [ ] Apple Watch companion

## 👨‍⚕️ Disclaimer Médico

Esta aplicación es una herramienta de apoyo educativo y no debe reemplazar el consejo médico profesional. Siempre consulte con un especialista en reproducción asistida para evaluación y tratamiento personalizados.

## 📄 Licencia

Proyecto privado - Todos los derechos reservados

---

**Desarrollado con ❤️ usando SwiftUI y SwiftData**
