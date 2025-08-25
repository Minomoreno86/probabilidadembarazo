#!/usr/bin/env swift

// Script de prueba para verificar el cambio de idioma
import Foundation

// Simular el LocalizationManager
class TestLocalizationManager {
    enum Language: String {
        case spanish = "es"
        case english = "en"
    }
    
    var currentLanguage: Language = .spanish
    
    func setLanguage(_ language: Language) {
        currentLanguage = language
        print("🌍 Idioma cambiado a: \(language.rawValue)")
    }
    
    func getLocalizedString(_ key: String) -> String {
        // Simular las traducciones
        let translations: [String: [String: String]] = [
            "es": [
                "Evaluación Médica": "Evaluación Médica",
                "Completado:": "Completado:",
                "IMC Calculado": "IMC Calculado",
                "Evaluación Detallada del SOP": "Evaluación Detallada del SOP",
                "Manifestaciones Androgénicas": "Manifestaciones Androgénicas",
                "No": "No",
                "Leve (vello en mentón)": "Leve (vello en mentón)",
                "Moderado (vello en mentón + mejillas)": "Moderado (vello en mentón + mejillas)",
                "Severo (vello facial extenso)": "Severo (vello facial extenso)",
                "Leve (pocos granos)": "Leve (pocos granos)",
                "Moderado (acné persistente)": "Moderado (acné persistente)",
                "Severo (acné quístico)": "Severo (acné quístico)",
                "Evaluación Ovárica": "Evaluación Ovárica",
                "No me la han hecho": "No me la han hecho",
                "Normal": "Normal",
                "Ovarios poliquísticos (>12 folículos)": "Ovarios poliquísticos (>12 folículos)",
                "Endometriosis": "Endometriosis",
                "Sin endometriosis": "Sin endometriosis",
                "Grado I (mínima)": "Grado I (mínima)",
                "Grado II (leve)": "Grado II (leve)",
                "Grado III (moderada)": "Grado III (moderada)",
                "Grado IV (severa)": "Grado IV (severa)",
                "Miomatosis Uterina": "Miomatosis Uterina",
                "Sin miomas": "Sin miomas",
                "Submucoso": "Submucoso",
                "Intramural": "Intramural",
                "Subseroso": "Subseroso",
                "Tamaño del mioma más grande": "Tamaño del mioma más grande",
                "cm": "cm",
                "Adenomiosis": "Adenomiosis",
                "Sin adenomiosis": "Sin adenomiosis",
                "Focal": "Focal",
                "Difusa": "Difusa",
                "Pólipos Endometriales": "Pólipos Endometriales",
                "Sin pólipos": "Sin pólipos",
                "Único": "Único",
                "Múltiples": "Múltiples",
                "Histerosalpingografía (HSG)": "Histerosalpingografía (HSG)",
                "Obstrucción unilateral": "Obstrucción unilateral",
                "Obstrucción bilateral": "Obstrucción bilateral",
                "Método de Diagnóstico OTB": "Método de Diagnóstico OTB",
                "No especificado": "No especificado",
                "Clips": "Clips",
                "Coagulación": "Coagulación",
                "Salpingectomía": "Salpingectomía",
                "Hormona Antimulleriana (AMH)": "Hormona Antimulleriana (AMH)",
                "Reserva ovárica": "Reserva ovárica",
                "Hormona Estimulante del Tiroides (TSH)": "Hormona Estimulante del Tiroides (TSH)",
                "mUI/L - Normal: 0.4-4.0": "mUI/L - Normal: 0.4-4.0",
                "Anticuerpos Anti-TPO": "Anticuerpos Anti-TPO",
                "Positivos para autoinmunidad tiroidea": "Positivos para autoinmunidad tiroidea",
                "Prolactina": "Prolactina",
                "ng/mL - Normal: <25": "ng/mL - Normal: <25",
                "Insulina Basal": "Insulina Basal",
                "μU/mL - Opcional para HOMA-IR": "μU/mL - Opcional para HOMA-IR",
                "Glucosa Basal": "Glucosa Basal",
                "mg/dL - Opcional para HOMA-IR": "mg/dL - Opcional para HOMA-IR",
                "HOMA-IR Calculado": "HOMA-IR Calculado",
                "Normal: <2.5": "Normal: <2.5",
                "Espermatograma (OMS 2021)": "Espermatograma (OMS 2021)"
            ],
            "en": [
                "Evaluación Médica": "Medical Assessment",
                "Completado:": "Completed:",
                "IMC Calculado": "BMI Calculated",
                "Evaluación Detallada del SOP": "Detailed PCOS Assessment",
                "Manifestaciones Androgénicas": "Androgenic Manifestations",
                "No": "No",
                "Leve (vello en mentón)": "Mild (chin hair)",
                "Moderado (vello en mentón + mejillas)": "Moderate (chin + cheek hair)",
                "Severo (vello facial extenso)": "Severe (extensive facial hair)",
                "Leve (pocos granos)": "Mild (few pimples)",
                "Moderado (acné persistente)": "Moderate (persistent acne)",
                "Severo (acné quístico)": "Severe (cystic acne)",
                "Evaluación Ovárica": "Ovarian Assessment",
                "No me la han hecho": "Not done",
                "Normal": "Normal",
                "Ovarios poliquísticos (>12 folículos)": "Polycystic ovaries (>12 follicles)",
                "Endometriosis": "Endometriosis",
                "Sin endometriosis": "No endometriosis",
                "Grado I (mínima)": "Grade I (minimal)",
                "Grado II (leve)": "Grade II (mild)",
                "Grado III (moderada)": "Grade III (moderate)",
                "Grado IV (severa)": "Grade IV (severe)",
                "Miomatosis Uterina": "Uterine Fibroids",
                "Sin miomas": "No fibroids",
                "Submucoso": "Submucosal",
                "Intramural": "Intramural",
                "Subseroso": "Subserosal",
                "Tamaño del mioma más grande": "Size of largest fibroid",
                "cm": "cm",
                "Adenomiosis": "Adenomyosis",
                "Sin adenomiosis": "No adenomyosis",
                "Focal": "Focal",
                "Difusa": "Diffuse",
                "Pólipos Endometriales": "Endometrial Polyps",
                "Sin pólipos": "No polyps",
                "Único": "Single",
                "Múltiples": "Multiple",
                "Histerosalpingografía (HSG)": "Hysterosalpingography (HSG)",
                "Obstrucción unilateral": "Unilateral obstruction",
                "Obstrucción bilateral": "Bilateral obstruction",
                "Método de Diagnóstico OTB": "OTB Diagnostic Method",
                "No especificado": "Not specified",
                "Clips": "Clips",
                "Coagulación": "Coagulation",
                "Salpingectomía": "Salpingectomy",
                "Hormona Antimulleriana (AMH)": "Anti-Müllerian Hormone (AMH)",
                "Reserva ovárica": "Ovarian reserve",
                "Hormona Estimulante del Tiroides (TSH)": "Thyroid Stimulating Hormone (TSH)",
                "mUI/L - Normal: 0.4-4.0": "mUI/L - Normal: 0.4-4.0",
                "Anticuerpos Anti-TPO": "Anti-TPO Antibodies",
                "Positivos para autoinmunidad tiroidea": "Positive for thyroid autoimmunity",
                "Prolactina": "Prolactin",
                "ng/mL - Normal: <25": "ng/mL - Normal: <25",
                "Insulina Basal": "Basal Insulin",
                "μU/mL - Opcional para HOMA-IR": "μU/mL - Optional for HOMA-IR",
                "Glucosa Basal": "Basal Glucose",
                "mg/dL - Opcional para HOMA-IR": "mg/dL - Optional for HOMA-IR",
                "HOMA-IR Calculado": "HOMA-IR Calculated",
                "Normal: <2.5": "Normal: <2.5",
                "Espermatograma (OMS 2021)": "Semen Analysis (WHO 2021)"
            ]
        ]
        
        let currentTranslations = translations[currentLanguage.rawValue] ?? [:]
        return currentTranslations[key] ?? key
    }
}

// Función de prueba
func testLanguageChange() {
    print("🧪 PROBANDO CAMBIO DE IDIOMA")
    print("=============================")
    
    let manager = TestLocalizationManager()
    
    // Test en español
    print("\n🇪🇸 Probando en ESPAÑOL:")
    print("  Evaluación Médica: \(manager.getLocalizedString("Evaluación Médica"))")
    print("  Completado: \(manager.getLocalizedString("Completado:"))")
    print("  IMC Calculado: \(manager.getLocalizedString("IMC Calculado"))")
    print("  Evaluación Detallada del SOP: \(manager.getLocalizedString("Evaluación Detallada del SOP"))")
    print("  Manifestaciones Androgénicas: \(manager.getLocalizedString("Manifestaciones Androgénicas"))")
    print("  No: \(manager.getLocalizedString("No"))")
    print("  Leve (vello en mentón): \(manager.getLocalizedString("Leve (vello en mentón)"))")
    print("  Leve (pocos granos): \(manager.getLocalizedString("Leve (pocos granos)"))")
    print("  Evaluación Ovárica: \(manager.getLocalizedString("Evaluación Ovárica"))")
    print("  No me la han hecho: \(manager.getLocalizedString("No me la han hecho"))")
    print("  Normal: \(manager.getLocalizedString("Normal"))")
    print("  Ovarios poliquísticos (>12 folículos): \(manager.getLocalizedString("Ovarios poliquísticos (>12 folículos)"))")
    print("  Endometriosis: \(manager.getLocalizedString("Endometriosis"))")
    print("  Sin endometriosis: \(manager.getLocalizedString("Sin endometriosis"))")
    print("  Grado I (mínima): \(manager.getLocalizedString("Grado I (mínima)"))")
    print("  Grado II (leve): \(manager.getLocalizedString("Grado II (leve)"))")
    print("  Grado III (moderada): \(manager.getLocalizedString("Grado III (moderada)"))")
    print("  Grado IV (severa): \(manager.getLocalizedString("Grado IV (severa)"))")
    print("  Miomatosis Uterina: \(manager.getLocalizedString("Miomatosis Uterina"))")
    print("  Sin miomas: \(manager.getLocalizedString("Sin miomas"))")
    print("  Submucoso: \(manager.getLocalizedString("Submucoso"))")
    print("  Intramural: \(manager.getLocalizedString("Intramural"))")
    print("  Subseroso: \(manager.getLocalizedString("Subseroso"))")
    print("  Tamaño del mioma más grande: \(manager.getLocalizedString("Tamaño del mioma más grande"))")
    print("  cm: \(manager.getLocalizedString("cm"))")
    print("  Adenomiosis: \(manager.getLocalizedString("Adenomiosis"))")
    print("  Sin adenomiosis: \(manager.getLocalizedString("Sin adenomiosis"))")
    print("  Focal: \(manager.getLocalizedString("Focal"))")
    print("  Difusa: \(manager.getLocalizedString("Difusa"))")
    print("  Pólipos Endometriales: \(manager.getLocalizedString("Pólipos Endometriales"))")
    print("  Sin pólipos: \(manager.getLocalizedString("Sin pólipos"))")
    print("  Único: \(manager.getLocalizedString("Único"))")
    print("  Múltiples: \(manager.getLocalizedString("Múltiples"))")
    print("  Histerosalpingografía (HSG): \(manager.getLocalizedString("Histerosalpingografía (HSG)"))")
    print("  Obstrucción unilateral: \(manager.getLocalizedString("Obstrucción unilateral"))")
    print("  Obstrucción bilateral: \(manager.getLocalizedString("Obstrucción bilateral"))")
    print("  Método de Diagnóstico OTB: \(manager.getLocalizedString("Método de Diagnóstico OTB"))")
    print("  No especificado: \(manager.getLocalizedString("No especificado"))")
    print("  Clips: \(manager.getLocalizedString("Clips"))")
    print("  Coagulación: \(manager.getLocalizedString("Coagulación"))")
    print("  Salpingectomía: \(manager.getLocalizedString("Salpingectomía"))")
    print("  Hormona Antimulleriana (AMH): \(manager.getLocalizedString("Hormona Antimulleriana (AMH)"))")
    print("  Reserva ovárica: \(manager.getLocalizedString("Reserva ovárica"))")
    print("  Hormona Estimulante del Tiroides (TSH): \(manager.getLocalizedString("Hormona Estimulante del Tiroides (TSH)"))")
    print("  mUI/L - Normal: 0.4-4.0: \(manager.getLocalizedString("mUI/L - Normal: 0.4-4.0"))")
    print("  Anticuerpos Anti-TPO: \(manager.getLocalizedString("Anticuerpos Anti-TPO"))")
    print("  Positivos para autoinmunidad tiroidea: \(manager.getLocalizedString("Positivos para autoinmunidad tiroidea"))")
    print("  Prolactina: \(manager.getLocalizedString("Prolactina"))")
    print("  ng/mL - Normal: <25: \(manager.getLocalizedString("ng/mL - Normal: <25"))")
    print("  Insulina Basal: \(manager.getLocalizedString("Insulina Basal"))")
    print("  μU/mL - Opcional para HOMA-IR: \(manager.getLocalizedString("μU/mL - Opcional para HOMA-IR"))")
    print("  Glucosa Basal: \(manager.getLocalizedString("Glucosa Basal"))")
    print("  mg/dL - Opcional para HOMA-IR: \(manager.getLocalizedString("mg/dL - Opcional para HOMA-IR"))")
    print("  HOMA-IR Calculado: \(manager.getLocalizedString("HOMA-IR Calculado"))")
    print("  Normal: <2.5: \(manager.getLocalizedString("Normal: <2.5"))")
    print("  Espermatograma (OMS 2021): \(manager.getLocalizedString("Espermatograma (OMS 2021)"))")
    
    // Cambiar a inglés
    print("\n🔄 Cambiando a inglés...")
    manager.setLanguage(.english)
    
    // Test en inglés
    print("\n🇺🇸 Probando en INGLÉS:")
    print("  Evaluación Médica: \(manager.getLocalizedString("Evaluación Médica"))")
    print("  Completado: \(manager.getLocalizedString("Completado:"))")
    print("  IMC Calculado: \(manager.getLocalizedString("IMC Calculado"))")
    print("  Evaluación Detallada del SOP: \(manager.getLocalizedString("Evaluación Detallada del SOP"))")
    print("  Manifestaciones Androgénicas: \(manager.getLocalizedString("Manifestaciones Androgénicas"))")
    print("  No: \(manager.getLocalizedString("No"))")
    print("  Leve (vello en mentón): \(manager.getLocalizedString("Leve (vello en mentón)"))")
    print("  Leve (pocos granos): \(manager.getLocalizedString("Leve (pocos granos)"))")
    print("  Evaluación Ovárica: \(manager.getLocalizedString("Evaluación Ovárica"))")
    print("  No me la han hecho: \(manager.getLocalizedString("No me la han hecho"))")
    print("  Normal: \(manager.getLocalizedString("Normal"))")
    print("  Ovarios poliquísticos (>12 folículos): \(manager.getLocalizedString("Ovarios poliquísticos (>12 folículos)"))")
    print("  Endometriosis: \(manager.getLocalizedString("Endometriosis"))")
    print("  Sin endometriosis: \(manager.getLocalizedString("Sin endometriosis"))")
    print("  Grado I (mínima): \(manager.getLocalizedString("Grado I (mínima)"))")
    print("  Grado II (leve): \(manager.getLocalizedString("Grado II (leve)"))")
    print("  Grado III (moderada): \(manager.getLocalizedString("Grado III (moderada)"))")
    print("  Grado IV (severa): \(manager.getLocalizedString("Grado IV (severa)"))")
    print("  Miomatosis Uterina: \(manager.getLocalizedString("Miomatosis Uterina"))")
    print("  Sin miomas: \(manager.getLocalizedString("Sin miomas"))")
    print("  Submucoso: \(manager.getLocalizedString("Submucoso"))")
    print("  Intramural: \(manager.getLocalizedString("Intramural"))")
    print("  Subseroso: \(manager.getLocalizedString("Subseroso"))")
    print("  Tamaño del mioma más grande: \(manager.getLocalizedString("Tamaño del mioma más grande"))")
    print("  cm: \(manager.getLocalizedString("cm"))")
    print("  Adenomiosis: \(manager.getLocalizedString("Adenomiosis"))")
    print("  Sin adenomiosis: \(manager.getLocalizedString("Sin adenomiosis"))")
    print("  Focal: \(manager.getLocalizedString("Focal"))")
    print("  Difusa: \(manager.getLocalizedString("Difusa"))")
    print("  Pólipos Endometriales: \(manager.getLocalizedString("Pólipos Endometriales"))")
    print("  Sin pólipos: \(manager.getLocalizedString("Sin pólipos"))")
    print("  Único: \(manager.getLocalizedString("Único"))")
    print("  Múltiples: \(manager.getLocalizedString("Múltiples"))")
    print("  Histerosalpingografía (HSG): \(manager.getLocalizedString("Histerosalpingografía (HSG)"))")
    print("  Obstrucción unilateral: \(manager.getLocalizedString("Obstrucción unilateral"))")
    print("  Obstrucción bilateral: \(manager.getLocalizedString("Obstrucción bilateral"))")
    print("  Método de Diagnóstico OTB: \(manager.getLocalizedString("Método de Diagnóstico OTB"))")
    print("  No especificado: \(manager.getLocalizedString("No especificado"))")
    print("  Clips: \(manager.getLocalizedString("Clips"))")
    print("  Coagulación: \(manager.getLocalizedString("Coagulación"))")
    print("  Salpingectomía: \(manager.getLocalizedString("Salpingectomía"))")
    print("  Hormona Antimulleriana (AMH): \(manager.getLocalizedString("Hormona Antimulleriana (AMH)"))")
    print("  Reserva ovárica: \(manager.getLocalizedString("Reserva ovárica"))")
    print("  Hormona Estimulante del Tiroides (TSH): \(manager.getLocalizedString("Hormona Estimulante del Tiroides (TSH)"))")
    print("  mUI/L - Normal: 0.4-4.0: \(manager.getLocalizedString("mUI/L - Normal: 0.4-4.0"))")
    print("  Anticuerpos Anti-TPO: \(manager.getLocalizedString("Anticuerpos Anti-TPO"))")
    print("  Positivos para autoinmunidad tiroidea: \(manager.getLocalizedString("Positivos para autoinmunidad tiroidea"))")
    print("  Prolactina: \(manager.getLocalizedString("Prolactina"))")
    print("  ng/mL - Normal: <25: \(manager.getLocalizedString("ng/mL - Normal: <25"))")
    print("  Insulina Basal: \(manager.getLocalizedString("Insulina Basal"))")
    print("  μU/mL - Opcional para HOMA-IR: \(manager.getLocalizedString("μU/mL - Opcional para HOMA-IR"))")
    print("  Glucosa Basal: \(manager.getLocalizedString("Glucosa Basal"))")
    print("  mg/dL - Opcional para HOMA-IR: \(manager.getLocalizedString("mg/dL - Opcional para HOMA-IR"))")
    print("  HOMA-IR Calculado: \(manager.getLocalizedString("HOMA-IR Calculado"))")
    print("  Normal: <2.5: \(manager.getLocalizedString("Normal: <2.5"))")
    print("  Espermatograma (OMS 2021): \(manager.getLocalizedString("Espermatograma (OMS 2021)"))")
    
    print("\n✅ Prueba completada!")
}

// Ejecutar la prueba
testLanguageChange()
