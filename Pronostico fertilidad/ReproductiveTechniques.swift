//
//  ReproductiveTechniques.swift
//  Pronostico fertilidad
//
//  Módulo de Técnicas de Reproducción Asistida
//  Basado en ESHRE 2023, ASRM 2024, evidencia 2025
//

import Foundation

// MARK: - 🎯 ESTRUCTURAS DE DATOS

enum ProtocoloEstimulacion: String, CaseIterable {
    case letrozol = "Letrozol"
    case clomifeno = "Clomifeno"
    case letrozolFSH = "Letrozol + FSH"
    case fshSolo = "FSH Solo"
    
    var descripcion: String {
        switch self {
        case .letrozol:
            return "Inhibidor aromatasa - Primera línea SOP"
        case .clomifeno:
            return "Modulador receptor estrógeno - Segunda línea"
        case .letrozolFSH:
            return "Protocolo híbrido - SOP resistente"
        case .fshSolo:
            return "Gonadotropinas - Tercera línea"
        }
    }
}

// MARK: - 🧬 PROTOCOLOS AVANZADOS FIV/ICSI

enum ProtocoloFIV: String, CaseIterable {
    case antagonistaEstandar = "GnRH Antagonista Estándar"
    case agonistaLargo = "GnRH Agonista Largo"
    case mildStimulation = "Mild Stimulation"
    case duoStim = "DuoStim"
    case randomStart = "Random Start"
    case dualTrigger = "Dual Trigger"
    case ppos = "PPOS"
    case embryoBanking = "Embryo Banking"
    case prpAccumulation = "PRP + Acumulación"
    
    var descripcion: String {
        switch self {
        case .antagonistaEstandar:
            return "Protocolo preferido actual - Flexible y seguro"
        case .agonistaLargo:
            return "Protocolo clásico - Mayor control pero más largo"
        case .mildStimulation:
            return "Estimulación leve - Menor costo y riesgo OHSS"
        case .duoStim:
            return "Doble estimulación - Más ovocitos en menos tiempo"
        case .randomStart:
            return "Inicio aleatorio - Urgencia oncológica"
        case .dualTrigger:
            return "GnRH-a + hCG - Mejor calidad ovocitaria"
        case .ppos:
            return "Progestágenos - Alternativa a antagonistas"
        case .embryoBanking:
            return "Acumulación embriones - Baja reserva ovárica"
        case .prpAccumulation:
            return "PRP intraovárico - Muy baja reserva"
        }
    }
}

enum TecnicaFertilizacion: String, CaseIterable {
    case fiv = "FIV"
    case icsi = "ICSI"
    case ovodonacion = "Ovodonación"
    
    var descripcion: String {
        switch self {
        case .fiv:
            return "Fertilización in vitro convencional"
        case .icsi:
            return "Inyección intracitoplásmica de espermatozoides"
        case .ovodonacion:
            return "Uso de ovocitos de donante joven"
        }
    }
}

struct TasasExitoFIV {
    let tasaImplantacion: Double     // %
    let embarazoClinico: Double      // %
    let nacidoVivo: Double          // %
    let cancelacion: Double         // %
    let ovocitosPromedio: Int       // número
    let blastocistosPromedio: Int   // número
}

struct TasasExito {
    let ovulacion: Double        // % de ovulación
    let embarazoMensual: Double  // % embarazo por mes
    let embarazoMultiple: Double // % embarazo múltiple
    let embarazoAcumulado3Meses: Double // % embarazo acumulado 3 meses
    let embarazoAcumulado6Meses: Double // % embarazo acumulado 6 meses
}

struct RespuestaOvarica {
    let foliculosDesarrollados: Int
    let foliculosDominantes: Int  // ≥18mm
    let grosorEndometrial: Double // mm
}

// MARK: - 🧬 COITO PROGRAMADO CON ESTIMULACIÓN OVÁRICA

class CoitoProgramado {
    
    // MARK: - ✅ INDICACIONES CLARAS
    
    static func esIndicado(profile: FertilityProfile) -> (indicado: Bool, razon: String) {
        // Referencias: ESHRE 2023 DOI: 10.1093/hropen/hoad023
        //             ASRM 2024 DOI: 10.1016/j.fertnstert.2023.04.003
        
        // 1. SOP leve/moderado
        if profile.hasPcos {
            return (true, "SOP leve/moderado - Letrozol primera línea")
        }
        
        // 2. Infertilidad anovulatoria leve
        if let cycleLength = profile.cycleLength, cycleLength > 35 {
            return (true, "Anovulación leve - Estimulación ovárica indicada")
        }
        
        // 3. Infertilidad inexplicada (<35 años, <3 años)
        if profile.age < 35, let duration = profile.infertilityDuration, duration < 3 {
            return (true, "Infertilidad inexplicada - Mujer joven")
        }
        
        // 4. Endometriosis mínima (I-II)
        if profile.endometriosisStage >= 1 && profile.endometriosisStage <= 2 {
            return (true, "Endometriosis mínima (I-II) - Coito programado viable")
        }
        
        // 5. Mujer joven con ovulación irregular
        if profile.age < 32, let cycleLength = profile.cycleLength, 
           cycleLength < 21 || cycleLength > 35 {
            return (true, "Mujer joven con ciclos irregulares")
        }
        
        // 6. Factor masculino normal
        if let concentration = profile.spermConcentration,
           let motility = profile.spermProgressiveMotility,
           let morphology = profile.spermNormalMorphology,
           concentration >= 15, motility >= 32, morphology >= 4 {
            
            if profile.age < 37, let duration = profile.infertilityDuration, duration < 2 {
                return (true, "Factor masculino normal - Preferible vs IIU como primera opción")
            }
        }
        
        // Contraindicaciones
        if profile.age > 40 {
            return (false, "Edad >40 años - Considerar técnicas de alta complejidad")
        }
        
        if profile.hsgResult == .bilateral {
            return (false, "Obstrucción tubárica bilateral - Requiere FIV")
        }
        
        if let duration = profile.infertilityDuration, duration > 3 {
            return (false, "Duración infertilidad >3 años - Considerar técnicas de mayor complejidad")
        }
        
        return (false, "No cumple criterios de indicación para coito programado")
    }
    
    // MARK: - 💊 SELECCIÓN DE PROTOCOLO
    
    static func seleccionarProtocolo(profile: FertilityProfile) -> ProtocoloEstimulacion {
        // Referencias: Legro RS et al., NEJM 2014 PMID: 24785206
        
        // 1. Letrozol → Primera línea en SOP y ovulación irregular
        if profile.hasPcos || (profile.cycleLength ?? 28) > 35 {
            return .letrozol
        }
        
        // 2. Letrozol + FSH → SOP resistente o edad >37
        if profile.hasPcos && profile.age > 37 {
            return .letrozolFSH
        }
        
        if let homaIr = profile.homaIr, homaIr > 3.5, profile.hasPcos {
            return .letrozolFSH // SOP resistente con alta RI
        }
        
        // 3. FSH solo → Tercera línea, casos específicos
        if let amh = profile.amhValue, amh < 1.0, profile.age > 35 {
            return .fshSolo // Baja reserva ovárica
        }
        
        // 4. Clomifeno → Alternativa si falla letrozol
        return .clomifeno
    }
    
    // MARK: - 📈 CÁLCULO DE TASAS DE ÉXITO
    
    static func calcularTasasExito(profile: FertilityProfile, protocolo: ProtocoloEstimulacion) -> TasasExito {
        // Referencias: ESHRE 2023, ASRM 2024
        
        var tasasBase: TasasExito
        
        switch protocolo {
        case .letrozol:
            tasasBase = TasasExito(
                ovulacion: 80.0,
                embarazoMensual: 17.5,
                embarazoMultiple: 3.0,
                embarazoAcumulado3Meses: 45.0,
                embarazoAcumulado6Meses: 65.0
            )
        case .clomifeno:
            tasasBase = TasasExito(
                ovulacion: 77.5,
                embarazoMensual: 12.5,
                embarazoMultiple: 9.0,
                embarazoAcumulado3Meses: 32.0,
                embarazoAcumulado6Meses: 50.0
            )
        case .letrozolFSH:
            tasasBase = TasasExito(
                ovulacion: 87.5,
                embarazoMensual: 21.5,
                embarazoMultiple: 12.0,
                embarazoAcumulado3Meses: 55.0,
                embarazoAcumulado6Meses: 75.0
            )
        case .fshSolo:
            tasasBase = TasasExito(
                ovulacion: 87.5,
                embarazoMensual: 21.5,
                embarazoMultiple: 20.0,
                embarazoAcumulado3Meses: 55.0,
                embarazoAcumulado6Meses: 75.0
            )
        }
        
        // Ajustes por factores del perfil
        var factorAjuste = 1.0
        
        // Edad (factor crítico)
        if profile.age < 30 {
            factorAjuste *= 1.15 // +15% si <30 años
        } else if profile.age < 35 {
            factorAjuste *= 1.05 // +5% si 30-34 años
        } else if profile.age > 37 {
            factorAjuste *= 0.75 // -25% si >37 años
        } else if profile.age > 40 {
            factorAjuste *= 0.50 // -50% si >40 años
        }
        
        // AMH (reserva ovárica)
        if let amh = profile.amhValue {
            if amh > 3.0 {
                factorAjuste *= 1.10 // Buena reserva
            } else if amh < 1.0 {
                factorAjuste *= 0.80 // Baja reserva
            }
        }
        
        // SOP (puede mejorar con letrozol)
        if profile.hasPcos && protocolo == .letrozol {
            factorAjuste *= 1.05 // Letrozol es ideal para SOP
        }
        
        // Factor masculino
        if let concentration = profile.spermConcentration,
           let motility = profile.spermProgressiveMotility,
           concentration < 15 || motility < 32 {
            factorAjuste *= 0.85 // Factor masculino subóptimo
        }
        
        // Aplicar ajustes
        return TasasExito(
            ovulacion: min(95.0, tasasBase.ovulacion * factorAjuste),
            embarazoMensual: min(30.0, tasasBase.embarazoMensual * factorAjuste),
            embarazoMultiple: tasasBase.embarazoMultiple, // No se ajusta
            embarazoAcumulado3Meses: min(70.0, tasasBase.embarazoAcumulado3Meses * factorAjuste),
            embarazoAcumulado6Meses: min(85.0, tasasBase.embarazoAcumulado6Meses * factorAjuste)
        )
    }
    
    // MARK: - 🔄 CRITERIOS DE CANCELACIÓN
    
    static func evaluarCancelacion(respuesta: RespuestaOvarica) -> (cancelar: Bool, razon: String) {
        // ≥3 folículos ≥14 mm
        if respuesta.foliculosDesarrollados >= 3 {
            return (true, "≥3 folículos desarrollados - Riesgo embarazo múltiple")
        }
        
        // Endometrio persistente <6 mm
        if respuesta.grosorEndometrial < 6.0 {
            return (true, "Endometrio <6 mm - Considerar vitrificación")
        }
        
        // No desarrollo folicular
        if respuesta.foliculosDominantes == 0 {
            return (true, "Sin folículos dominantes - Aumentar dosis próximo ciclo")
        }
        
        return (false, "Respuesta adecuada - Continuar ciclo")
    }
    
    // MARK: - 🧠 ALGORITMO MÉDICO IA
    
    static func recomendacionIA(profile: FertilityProfile) -> (recomendacion: String, protocolo: ProtocoloEstimulacion?, confianza: Double) {
        let (indicado, razon) = esIndicado(profile: profile)
        
        if !indicado {
            return ("No indicado: \(razon)", nil, 0.95)
        }
        
        let protocolo = seleccionarProtocolo(profile: profile)
        let tasas = calcularTasasExito(profile: profile, protocolo: protocolo)
        
        var confianza = 0.85
        
        // Ajustar confianza según factores
        if profile.age < 35 { confianza += 0.10 }
        if profile.hasPcos && protocolo == .letrozol { confianza += 0.05 }
        if let amh = profile.amhValue, amh > 2.0 { confianza += 0.05 }
        
        let recomendacion = """
        COITO PROGRAMADO RECOMENDADO
        
        Protocolo: \(protocolo.rawValue)
        - \(protocolo.descripcion)
        
        Tasas esperadas:
        - Ovulación: \(String(format: "%.1f", tasas.ovulacion))%
        - Embarazo mensual: \(String(format: "%.1f", tasas.embarazoMensual))%
        - Embarazo 6 meses: \(String(format: "%.1f", tasas.embarazoAcumulado6Meses))%
        - Riesgo múltiple: \(String(format: "%.1f", tasas.embarazoMultiple))%
        
        Fundamento: \(razon)
        """
        
        return (recomendacion, protocolo, min(0.99, confianza))
    }
}

// MARK: - 📚 REFERENCIAS CIENTÍFICAS

// MARK: - 🎆 INSEMINACIÓN INTRAUTERINA (IIU)

class InseminacionIntrauterina {
    
    static func esIndicada(profile: FertilityProfile) -> (indicada: Bool, razon: String) {
        // Referencias: ESHRE 2023 DOI: 10.1093/hropen/hoad023, ASRM 2024 DOI: 10.1016/j.fertnstert.2024.01.009
        
        // ❌ CONTRAINDICACIONES ABSOLUTAS
        if profile.age > 42, let amh = profile.amhValue, amh < 0.7 {
            return (false, "Edad >42 años + baja reserva ovárica (AMH <0.7) - Considerar FIV")
        }
        
        if profile.hsgResult == .bilateral {
            return (false, "Obstrucción tubárica bilateral - Requiere FIV")
        }
        
        if profile.endometriosisStage >= 3 {
            return (false, "Endometriosis moderada-severa (estadio ≥III) - Considerar FIV")
        }
        
        // Factor masculino severo (TMSC <5M)
        if let concentration = profile.spermConcentration,
           let motility = profile.spermProgressiveMotility,
           let morphology = profile.spermNormalMorphology {
            
            let estimatedTMSC = concentration * 3.0 * (motility/100.0) * 0.5
            if estimatedTMSC < 5.0 || morphology < 1.0 {
                return (false, "Factor masculino severo (TMSC <5M o morfología <1%) - Requiere ICSI")
            }
        }
        
        // ✅ CRITERIOS DE INCLUSIÓN
        if profile.hasPcos {
            return (true, "SOP - IIU con letrozol primera línea")
        }
        
        if profile.endometriosisStage >= 1 && profile.endometriosisStage <= 2 {
            return (true, "Endometriosis leve (I-II) - IIU apropiada")
        }
        
        if let duration = profile.infertilityDuration, duration < 3, profile.age < 38 {
            return (true, "Infertilidad inexplicada - Mujer joven, duración <3 años")
        }
        
        return (false, "No cumple criterios óptimos para IIU")
    }
    
    static func recomendacionIIU(profile: FertilityProfile) -> (recomendacion: String, protocolo: ProtocoloEstimulacion?, confianza: Double) {
        
        let (indicada, razon) = esIndicada(profile: profile)
        
        if !indicada {
            return ("IIU no indicada: \(razon)", nil, 0.95)
        }
        
        let protocolo = CoitoProgramado.seleccionarProtocolo(profile: profile)
        let tasas = CoitoProgramado.calcularTasasExito(profile: profile, protocolo: protocolo)
        
        var confianza = 0.85
        if profile.age < 35 { confianza += 0.08 }
        if profile.hasPcos && protocolo == .letrozol { confianza += 0.05 }
        
        let ciclosRecomendados = profile.age > 38 ? 2 : (profile.age > 35 ? 2 : 3)
        
        // IIU: +15% tasa embarazo vs coito programado
        let tasasIIU = TasasExito(
            ovulacion: tasas.ovulacion,
            embarazoMensual: min(25.0, tasas.embarazoMensual * 1.15),
            embarazoMultiple: tasas.embarazoMultiple,
            embarazoAcumulado3Meses: min(70.0, tasas.embarazoAcumulado3Meses * 1.15),
            embarazoAcumulado6Meses: min(85.0, tasas.embarazoAcumulado6Meses * 1.15)
        )
        
        let recomendacion = """
        INSEMINACIÓN INTRAUTERINA RECOMENDADA
        
        Protocolo: \(protocolo.rawValue)
        - \(protocolo.descripcion)
        
        Tasas esperadas por ciclo:
        - Ovulación: \(String(format: "%.1f", tasasIIU.ovulacion))%
        - Embarazo: \(String(format: "%.1f", tasasIIU.embarazoMensual))%
        - Riesgo múltiple: \(String(format: "%.1f", tasasIIU.embarazoMultiple))%
        
        Probabilidad acumulada \(ciclosRecomendados) ciclos: \(String(format: "%.1f", tasasIIU.embarazoAcumulado3Meses))%
        
        Requisito: TMSC postlavado ≥5 millones
        
        Fundamento: \(razon)
        """
        
        return (recomendacion, protocolo, min(0.95, confianza))
    }
}

// MARK: - 🧬 FIV / ICSI / OVODONACIÓN (ALTA COMPLEJIDAD)

class FertilizacionInVitro {
    
    // MARK: - ✅ INDICACIONES MÉDICAS FIV/ICSI
    
    static func evaluarIndicacion(profile: FertilityProfile) -> (tecnica: TecnicaFertilizacion, razon: String, urgencia: String) {
        // Referencias: ESHRE 2023 DOI: 10.1093/hropen/hoad030
        //             ASRM 2024 DOI: 10.1016/j.fertnstert.2024.04.008
        
        // 🥚 OVODONACIÓN (primera evaluación)
        
        // 1. Edad >43-44 años con ovocitos propios
        if profile.age > 43 {
            return (.ovodonacion, "Edad >43 años - Baja tasa éxito ovocitos propios (<5%)", "Alta")
        }
        
        // 2. Insuficiencia ovárica (AMH muy baja)
        if let amh = profile.amhValue, amh < 0.3 {
            return (.ovodonacion, "Insuficiencia ovárica (AMH <0.3) - Considerar ovodonación", "Moderada")
        }
        
        // 3. Menopausia precoz
        if profile.age < 40, let amh = profile.amhValue, amh < 0.1 {
            return (.ovodonacion, "Menopausia precoz - Falla ovárica prematura", "Alta")
        }
        
        // 🧬 ICSI (indicaciones específicas)
        
        // 1. Factor masculino severo
        if let concentration = profile.spermConcentration,
           let motility = profile.spermProgressiveMotility,
           let morphology = profile.spermNormalMorphology {
            
            let estimatedTMSC = concentration * 3.0 * (motility/100.0) * 0.5
            
            if estimatedTMSC < 2.0 || morphology < 1.0 {
                return (.icsi, "Factor masculino severo (TMSC <2M o morfología <1%)", "Moderada")
            }
            
            if concentration < 5.0 || motility < 20.0 || morphology < 2.0 {
                return (.icsi, "Oligoastenoteratozoospermia severa", "Moderada")
            }
        }
        
        // 2. Fallo FIV convencional previo (simulado)
        // En implementación real se evaluaría historia previa
        
        // 🧬 FIV CONVENCIONAL
        
        // 1. Obstrucción tubárica bilateral
        if profile.hsgResult == .bilateral {
            return (.fiv, "Obstrucción tubárica bilateral - FIV indicación absoluta", "Alta")
        }
        
        // 2. Endometriosis moderada-severa
        if profile.endometriosisStage >= 3 {
            return (.fiv, "Endometriosis moderada-severa (III-IV) - FIV preferible", "Moderada")
        }
        
        // 3. Fallo a IIU o coito programado (simulado por duración)
        if let duration = profile.infertilityDuration, duration > 2, profile.age > 35 {
            return (.fiv, "Fallo tratamientos baja complejidad + edad >35 años", "Moderada")
        }
        
        // 4. Baja reserva ovárica pero viable
        if let amh = profile.amhValue, amh < 1.0, amh > 0.3 {
            return (.fiv, "Baja reserva ovárica - FIV con protocolo ajustado", "Moderada")
        }
        
        // 5. Edad >38 años con infertilidad >1 año
        if profile.age > 38, let duration = profile.infertilityDuration, duration > 1 {
            return (.fiv, "Edad >38 años + infertilidad >1 año - Ventana reproductiva limitada", "Alta")
        }
        
        return (.fiv, "FIV como opción de tratamiento", "Baja")
    }
    
    // MARK: - 📈 SELECCIÓN DE PROTOCOLO AVANZADO
    
    static func seleccionarProtocoloFIV(profile: FertilityProfile) -> ProtocoloFIV {
        
        // 1. Protocolo para alta reserva / riesgo OHSS
        if let amh = profile.amhValue, amh > 3.5 || profile.hasPcos {
            return .mildStimulation // Evitar OHSS
        }
        
        // 2. Baja reserva ovárica (POSEIDON 3-4)
        if let amh = profile.amhValue {
            if amh < 0.5 {
                return .prpAccumulation // Muy baja reserva
            } else if amh < 1.0 {
                if profile.age < 35 {
                    return .duoStim // Joven con baja reserva
                } else {
                    return .embryoBanking // Edad + baja reserva
                }
            }
        }
        
        // 3. Urgencia oncológica o preservación
        // (En implementación real se evaluaría indicación médica)
        
        // 4. Fallos previos de implantación
        // (Simulado por endometriosis o adenomiosis)
        if profile.endometriosisStage > 0 || profile.adenomyosisType != .none {
            return .dualTrigger // Mejor calidad ovocitaria
        }
        
        // 5. Protocolo estándar (más común)
        if profile.age < 38 {
            return .antagonistaEstandar
        } else {
            return .dualTrigger // Edad avanzada
        }
    }
    
    // MARK: - 📈 TASAS DE ÉXITO POR EDAD
    
    static func calcularTasasExitoFIV(profile: FertilityProfile, tecnica: TecnicaFertilizacion) -> TasasExitoFIV {
        
        var tasasBase: TasasExitoFIV
        
        // OVODONACIÓN (tasas constantes - depende edad donante)
        if tecnica == .ovodonacion {
            return TasasExitoFIV(
                tasaImplantacion: 60.0,
                embarazoClinico: 60.0,
                nacidoVivo: 50.0,
                cancelacion: 5.0,
                ovocitosPromedio: 15,
                blastocistosPromedio: 8
            )
        }
        
        // FIV/ICSI según edad (ovocitos propios)
        if profile.age < 35 {
            tasasBase = TasasExitoFIV(
                tasaImplantacion: 45.0,
                embarazoClinico: 50.0,
                nacidoVivo: 40.0,
                cancelacion: 5.0,
                ovocitosPromedio: 12,
                blastocistosPromedio: 6
            )
        } else if profile.age < 38 {
            tasasBase = TasasExitoFIV(
                tasaImplantacion: 35.0,
                embarazoClinico: 40.0,
                nacidoVivo: 35.0,
                cancelacion: 12.0,
                ovocitosPromedio: 10,
                blastocistosPromedio: 4
            )
        } else if profile.age < 41 {
            tasasBase = TasasExitoFIV(
                tasaImplantacion: 25.0,
                embarazoClinico: 30.0,
                nacidoVivo: 25.0,
                cancelacion: 25.0,
                ovocitosPromedio: 8,
                blastocistosPromedio: 3
            )
        } else if profile.age < 43 {
            tasasBase = TasasExitoFIV(
                tasaImplantacion: 12.0,
                embarazoClinico: 15.0,
                nacidoVivo: 12.0,
                cancelacion: 35.0,
                ovocitosPromedio: 5,
                blastocistosPromedio: 1
            )
        } else {
            tasasBase = TasasExitoFIV(
                tasaImplantacion: 3.0,
                embarazoClinico: 5.0,
                nacidoVivo: 3.0,
                cancelacion: 50.0,
                ovocitosPromedio: 3,
                blastocistosPromedio: 0
            )
        }
        
        // Ajustes por factores del perfil
        var factorAjuste = 1.0
        
        // AMH (reserva ovárica)
        if let amh = profile.amhValue {
            if amh > 3.0 {
                factorAjuste *= 1.15 // Excelente reserva
            } else if amh < 1.0 {
                factorAjuste *= 0.75 // Baja reserva
            } else if amh < 0.5 {
                factorAjuste *= 0.50 // Muy baja reserva
            }
        }
        
        // Endometriosis (reduce implantación)
        if profile.endometriosisStage >= 3 {
            factorAjuste *= 0.80
        } else if profile.endometriosisStage > 0 {
            factorAjuste *= 0.90
        }
        
        // Factor masculino (si ICSI)
        if tecnica == .icsi {
            factorAjuste *= 0.95 // Leve reducción por manipulación
        }
        
        return TasasExitoFIV(
            tasaImplantacion: min(70.0, tasasBase.tasaImplantacion * factorAjuste),
            embarazoClinico: min(70.0, tasasBase.embarazoClinico * factorAjuste),
            nacidoVivo: min(60.0, tasasBase.nacidoVivo * factorAjuste),
            cancelacion: max(5.0, tasasBase.cancelacion / factorAjuste),
            ovocitosPromedio: max(1, Int(Double(tasasBase.ovocitosPromedio) * factorAjuste)),
            blastocistosPromedio: max(0, Int(Double(tasasBase.blastocistosPromedio) * factorAjuste))
        )
    }
    
    // MARK: - 🤖 ALGORITMO MÉDICO IA PARA FIV/ICSI
    
    static func recomendacionFIV(profile: FertilityProfile) -> (recomendacion: String, tecnica: TecnicaFertilizacion, protocolo: ProtocoloFIV, confianza: Double) {
        
        let (tecnica, razon, urgencia) = evaluarIndicacion(profile: profile)
        let protocolo = seleccionarProtocoloFIV(profile: profile)
        let tasas = calcularTasasExitoFIV(profile: profile, tecnica: tecnica)
        
        var confianza = 0.90
        
        // Ajustar confianza según factores
        if urgencia == "Alta" { confianza += 0.05 }
        if let amh = profile.amhValue, amh > 2.0 { confianza += 0.03 }
        if profile.age < 35 { confianza += 0.02 }
        
        let ciclosEstimados = tecnica == .ovodonacion ? 1 : (profile.age > 40 ? 3 : 2)
        
        let recomendacion = """
        \(tecnica.descripcion.uppercased()) RECOMENDADA
        
        Técnica: \(tecnica.rawValue)
        Protocolo: \(protocolo.rawValue)
        - \(protocolo.descripcion)
        
        Tasas esperadas por ciclo:
        - Implantación: \(String(format: "%.1f", tasas.tasaImplantacion))%
        - Embarazo clínico: \(String(format: "%.1f", tasas.embarazoClinico))%
        - Nacido vivo: \(String(format: "%.1f", tasas.nacidoVivo))%
        - Cancelación: \(String(format: "%.1f", tasas.cancelacion))%
        
        Ovocitos esperados: \(tasas.ovocitosPromedio)
        Blastocistos esperados: \(tasas.blastocistosPromedio)
        
        Ciclos estimados: \(ciclosEstimados)
        Urgencia: \(urgencia)
        
        Fundamento: \(razon)
        """
        
        return (recomendacion, tecnica, protocolo, min(0.98, confianza))
    }
}

/*
 REFERENCIAS BIBLIOGRÁFICAS:
 
 === COITO PROGRAMADO ===
 1. ESHRE 2023 Ovulation Induction Guideline - DOI: 10.1093/hropen/hoad023
 2. ASRM 2024 Committee Opinion on Ovulation Induction - DOI: 10.1016/j.fertnstert.2023.04.003
 3. Legro RS et al., Letrozole vs Clomifene for Infertility in PCOS - NEJM 2014, PMID: 24785206
 
 === INSEMINACIÓN INTRAUTERINA ===
 4. ESHRE Guideline: Ovarian Stimulation for IUI (2023) - DOI: 10.1093/hropen/hoad023
 5. ASRM Committee Opinion: IUI Protocols (2024) - DOI: 10.1016/j.fertnstert.2024.01.009
 6. NICE Fertility Recommendations (2024) - Updated guidelines for IUI protocols
 
 === GENERALES ===
 7. WHO Laboratory Manual for the Examination of Human Semen, 6th Edition (2021) - ISBN: 9789240030787
 8. ESHRE PCOS Guideline 2023 - DOI: 10.1093/hropen/hoad019
 */
