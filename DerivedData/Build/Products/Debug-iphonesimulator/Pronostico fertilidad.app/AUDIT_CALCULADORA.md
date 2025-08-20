# 🔍 AUDITORÍA SISTEMÁTICA - CALCULADORA DE FERTILIDAD

## 🚨 PROBLEMAS IDENTIFICADOS
El usuario reporta que **múltiples variables no están funcionando correctamente** en la calculadora de fertilidad. Los síntomas indican un problema **SISTÉMICO**.

### Casos de Prueba Problemáticos:
1. **Mujer 22 años, IMC normal** → Solo 1 recomendación (debería ser correcto)
2. **Mujer 22 años, IMC normal, AMH 0.9** → AMH no aparecía (parcialmente corregido)
3. **Patrón menstrual** → Detectaba "irregular grave" sin datos (corregido)
4. **Paridad** → Penalizaba nulíparas incorrectamente (corregido)

## 🎯 REVISIÓN SISTEMÁTICA REQUERIDA

### 1. VERIFICAR CÁLCULO DE FACTORES INDIVIDUALES
```swift
// Verificar cada función calculate*Factor:
- calculateAgeFactor(22) → debería ser ~0.25
- calculateBMIFactor(23) → debería ser 1.0  
- calculateAMHFactor(0.9) → debería ser 0.68
- calculateTSHFactor(2.5) → debería ser 0.85
- calculateProlactinFactor(25) → debería ser 0.80
- calculateHOMAIRFactor(3.0) → debería ser 0.75
- calculateMaleFactor(normal) → debería ser 1.0
- calculatePCOSFactor(false) → debería ser 1.0
- calculateEndometriosisFactor(none) → debería ser 1.0
- calculateMyomaFactor(none) → debería ser 1.0
- calculatePolypFactor(none) → debería ser 1.0
- calculateAdenomyosisFactor(none) → debería ser 1.0
- calculateHSGFactor(normal) → debería ser 1.0
- calculateOTBFactor(none) → debería ser 1.0
- calculatePelvicSurgeryFactor(0) → debería ser 1.0
- calculateInfertilityDurationFactor(1.0) → debería ser 1.0
- calculateCycleFactor(28) → debería ser 1.0
- calculateParityFactor(0) → debería ser 1.0
```

### 2. VERIFICAR APLICACIÓN EN CÁLCULO FINAL
```swift
// En calculateFinalProbability:
adjustedFertility *= factors.age        // ✓
adjustedFertility *= factors.bmi        // ✓
adjustedFertility *= factors.cycle      // ¿?
adjustedFertility *= factors.infertilityDuration // ¿?
adjustedFertility *= factors.amh        // ¿?
adjustedFertility *= factors.tsh        // ¿?
adjustedFertility *= factors.prolactin  // ¿?
adjustedFertility *= factors.homaIR     // ¿?
adjustedFertility *= factors.parity     // ¿?
adjustedFertility *= factors.pcos       // ¿?
adjustedFertility *= factors.endometriosis // ¿?
adjustedFertility *= factors.myoma      // ¿?
adjustedFertility *= factors.polyp      // ¿?
adjustedFertility *= factors.adenomyosis // ¿?
adjustedFertility *= factors.hsg        // ¿?
adjustedFertility *= factors.otb        // ¿?
adjustedFertility *= factors.pelvicSurgery // ¿?
adjustedFertility *= factors.male       // ¿?
```

### 3. VERIFICAR CONVERSIÓN PROFILE → FACTORS
```swift
// En convertProfileToMedicalFactors:
- ¿Se asignan TODOS los valores del profile?
- ¿Se manejan correctamente los valores nil?
- ¿Se calculan correctamente los valores derivados (BMI, HOMA-IR)?
```

### 4. VERIFICAR ANÁLISIS MÉDICO
```swift
// En generateDetailedAnalysis:
- ¿Se muestran TODOS los factores alterados?
- ¿Se calculan correctamente los porcentajes de impacto?
- ¿Se incluyen recomendaciones específicas?
```

### 5. VERIFICAR FACTORES ANALIZADOS
```swift
// En generateKeyFactors:
- ¿Se incluyen TODOS los factores < 1.0?
- ¿Se muestran con nombres descriptivos?
- ¿Se filtran correctamente?
```

### 6. VERIFICAR RECOMENDACIONES
```swift
// En generateEvidenceBasedRecommendations:
- ¿Se generan recomendaciones para TODOS los factores alterados?
- ¿El filtrado hasAdverseFactors incluye TODOS los factores?
- ¿Las prioridades son correctas?
```

## 🧪 CASOS DE PRUEBA ESPECÍFICOS

### CASO 1: Mujer Joven Normal
- Edad: 22, IMC: 23, AMH: 2.0, TSH: 2.0, Prolactina: 15
- **Esperado:** Probabilidad ~25% mensual, 1 recomendación
- **Verificar:** Todos los factores = 1.0 excepto edad

### CASO 2: Mujer Joven con AMH Baja
- Edad: 22, IMC: 23, AMH: 0.9, TSH: 2.0, Prolactina: 15
- **Esperado:** Probabilidad ~17% mensual, 2+ recomendaciones
- **Verificar:** factors.amh = 0.68, aparece en análisis

### CASO 3: Mujer Joven con Múltiples Factores
- Edad: 22, IMC: 30, AMH: 0.9, TSH: 5.0, Prolactina: 30
- **Esperado:** Probabilidad ~10% mensual, múltiples recomendaciones
- **Verificar:** Todos los factores alterados aparecen

### CASO 4: Mujer Mayor
- Edad: 38, IMC: 23, AMH: 0.7, TSH: 2.0, Prolactina: 15
- **Esperado:** Probabilidad ~8% mensual, recomendaciones urgentes
- **Verificar:** Interacciones no lineales activas

## 🔧 ACCIONES REQUERIDAS

1. **CREAR SCRIPT DE PRUEBAS** que verifique cada caso
2. **IDENTIFICAR DISCREPANCIAS** entre esperado vs actual
3. **CORREGIR BUGS SISTEMÁTICOS** encontrados
4. **VALIDAR CORRECCIONES** con casos de prueba
5. **DOCUMENTAR CAMBIOS** realizados

## 📊 MÉTRICAS DE ÉXITO

- ✅ Todos los factores alterados aparecen en análisis
- ✅ Todos los factores alterados aparecen en factores analizados  
- ✅ Probabilidad cambia apropiadamente con cada factor
- ✅ Recomendaciones son específicas y relevantes
- ✅ No hay recomendaciones innecesarias para casos normales

---

**COLABORACIÓN CON QWEN:**
Este documento debe ser revisado sistemáticamente con Qwen para identificar y corregir todos los problemas de la calculadora de fertilidad.
