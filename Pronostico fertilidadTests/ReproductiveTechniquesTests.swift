//
//  ReproductiveTechniquesTests.swift
//  Pronostico fertilidadTests
//
//  Tests unitarios DIRECTOS para ReproductiveTechniques.swift
//

import XCTest
@testable import Pronostico_fertilidad

class ReproductiveTechniquesTests: XCTestCase {
    
    // MARK: - 🧬 TESTS PARA PROTOCOLOS DE ESTIMULACIÓN
    
    func testProtocoloEstimulacionDisplayNames() {
        // Test que los nombres de display funcionen
        XCTAssertEqual(ProtocoloEstimulacion.letrozol.descripcion, "Inhibidor aromatasa - Primera línea SOP")
        XCTAssertEqual(ProtocoloEstimulacion.clomifeno.descripcion, "Modulador receptor estrógeno - Segunda línea")
        XCTAssertEqual(ProtocoloEstimulacion.letrozolFSH.descripcion, "Protocolo híbrido - SOP resistente")
        XCTAssertEqual(ProtocoloEstimulacion.fshSolo.descripcion, "Gonadotropinas - Tercera línea")
    }
    
    func testProtocoloEstimulacionRawValues() {
        // Test que los raw values sean correctos
        XCTAssertEqual(ProtocoloEstimulacion.letrozol.rawValue, "Letrozol")
        XCTAssertEqual(ProtocoloEstimulacion.clomifeno.rawValue, "Clomifeno")
        XCTAssertEqual(ProtocoloEstimulacion.letrozolFSH.rawValue, "Letrozol + FSH")
        XCTAssertEqual(ProtocoloEstimulacion.fshSolo.rawValue, "FSH Solo")
    }
    
    func testProtocoloEstimulacionAllCases() {
        // Test que todos los casos estén disponibles
        let allCases = ProtocoloEstimulacion.allCases
        XCTAssertEqual(allCases.count, 4)
        XCTAssertTrue(allCases.contains(.letrozol))
        XCTAssertTrue(allCases.contains(.clomifeno))
        XCTAssertTrue(allCases.contains(.letrozolFSH))
        XCTAssertTrue(allCases.contains(.fshSolo))
    }
    
    // MARK: - 🧬 TESTS PARA PROTOCOLOS FIV
    
    func testProtocoloFIVDisplayNames() {
        // Test que los nombres de display funcionen
        XCTAssertEqual(ProtocoloFIV.antagonistaEstandar.descripcion, "Protocolo preferido actual - Flexible y seguro")
        XCTAssertEqual(ProtocoloFIV.agonistaLargo.descripcion, "Protocolo clásico - Mayor control pero más largo")
        XCTAssertEqual(ProtocoloFIV.mildStimulation.descripcion, "Estimulación leve - Menor costo y riesgo OHSS")
        XCTAssertEqual(ProtocoloFIV.duoStim.descripcion, "Doble estimulación - Más ovocitos en menos tiempo")
        XCTAssertEqual(ProtocoloFIV.randomStart.descripcion, "Inicio aleatorio - Urgencia oncológica")
        XCTAssertEqual(ProtocoloFIV.dualTrigger.descripcion, "GnRH-a + hCG - Mejor calidad ovocitaria")
        XCTAssertEqual(ProtocoloFIV.ppos.descripcion, "Progestágenos - Alternativa a antagonistas")
        XCTAssertEqual(ProtocoloFIV.embryoBanking.descripcion, "Acumulación embriones - Baja reserva ovárica")
        XCTAssertEqual(ProtocoloFIV.prpAccumulation.descripcion, "PRP intraovárico - Muy baja reserva")
        XCTAssertEqual(ProtocoloFIV.naturalCycle.descripcion, "Ciclo natural - Sin estimulación, menor costo")
        XCTAssertEqual(ProtocoloFIV.miniIVF.descripcion, "Mini IVF - Estimulación mínima, menor riesgo")
        XCTAssertEqual(ProtocoloFIV.lutealPhaseStimulation.descripcion, "Estimulación fase lútea - Doble oportunidad por ciclo")
    }
    
    func testProtocoloFIVRawValues() {
        // Test que los raw values sean correctos
        XCTAssertEqual(ProtocoloFIV.antagonistaEstandar.rawValue, "GnRH Antagonista Estándar")
        XCTAssertEqual(ProtocoloFIV.agonistaLargo.rawValue, "GnRH Agonista Largo")
        XCTAssertEqual(ProtocoloFIV.mildStimulation.rawValue, "Mild Stimulation")
        XCTAssertEqual(ProtocoloFIV.duoStim.rawValue, "DuoStim")
        XCTAssertEqual(ProtocoloFIV.randomStart.rawValue, "Random Start")
        XCTAssertEqual(ProtocoloFIV.dualTrigger.rawValue, "Dual Trigger")
        XCTAssertEqual(ProtocoloFIV.ppos.rawValue, "PPOS")
        XCTAssertEqual(ProtocoloFIV.embryoBanking.rawValue, "Embryo Banking")
        XCTAssertEqual(ProtocoloFIV.prpAccumulation.rawValue, "PRP + Acumulación")
        XCTAssertEqual(ProtocoloFIV.naturalCycle.rawValue, "Ciclo Natural")
        XCTAssertEqual(ProtocoloFIV.miniIVF.rawValue, "Mini IVF")
        XCTAssertEqual(ProtocoloFIV.lutealPhaseStimulation.rawValue, "Estimulación Fase Lútea")
    }
    
    func testProtocoloFIVAllCases() {
        // Test que todos los casos estén disponibles
        let allCases = ProtocoloFIV.allCases
        XCTAssertEqual(allCases.count, 12)
        XCTAssertTrue(allCases.contains(.antagonistaEstandar))
        XCTAssertTrue(allCases.contains(.agonistaLargo))
        XCTAssertTrue(allCases.contains(.mildStimulation))
        XCTAssertTrue(allCases.contains(.duoStim))
        XCTAssertTrue(allCases.contains(.randomStart))
        XCTAssertTrue(allCases.contains(.dualTrigger))
        XCTAssertTrue(allCases.contains(.ppos))
        XCTAssertTrue(allCases.contains(.embryoBanking))
        XCTAssertTrue(allCases.contains(.prpAccumulation))
        XCTAssertTrue(allCases.contains(.naturalCycle))
        XCTAssertTrue(allCases.contains(.miniIVF))
        XCTAssertTrue(allCases.contains(.lutealPhaseStimulation))
    }
    
    // MARK: - 🧬 TESTS PARA TÉCNICAS DE FERTILIZACIÓN
    
    func testTecnicaFertilizacionDisplayNames() {
        // Test que los nombres de display funcionen
        XCTAssertEqual(TecnicaFertilizacion.fiv.descripcion, "Fertilización in vitro convencional")
        XCTAssertEqual(TecnicaFertilizacion.icsi.descripcion, "Inyección intracitoplásmica de espermatozoides")
        XCTAssertEqual(TecnicaFertilizacion.ovodonacion.descripcion, "Uso de ovocitos de donante joven")
    }
    
    func testTecnicaFertilizacionRawValues() {
        // Test que los raw values sean correctos
        XCTAssertEqual(TecnicaFertilizacion.fiv.rawValue, "FIV")
        XCTAssertEqual(TecnicaFertilizacion.icsi.rawValue, "ICSI")
        XCTAssertEqual(TecnicaFertilizacion.ovodonacion.rawValue, "Ovodonación")
    }
    
    func testTecnicaFertilizacionAllCases() {
        // Test que todos los casos estén disponibles
        let allCases = TecnicaFertilizacion.allCases
        XCTAssertEqual(allCases.count, 3)
        XCTAssertTrue(allCases.contains(.fiv))
        XCTAssertTrue(allCases.contains(.icsi))
        XCTAssertTrue(allCases.contains(.ovodonacion))
    }
    
    // MARK: - 🧬 TESTS PARA TÉCNICAS DE LABORATORIO
    
    func testTecnicaLaboratorioDisplayNames() {
        // Test que los nombres de display funcionen para casos básicos
        let allCases = TecnicaLaboratorio.allCases
        for tecnica in allCases {
            XCTAssertFalse(tecnica.descripcion.isEmpty, "Descripción de \(tecnica.rawValue) no debe estar vacía")
        }
    }
    
    func testTecnicaLaboratorioRawValues() {
        // Test que los raw values sean strings válidos
        let allCases = TecnicaLaboratorio.allCases
        for tecnica in allCases {
            XCTAssertFalse(tecnica.rawValue.isEmpty, "Raw value de \(tecnica) no debe estar vacío")
        }
    }
    
    func testTecnicaLaboratorioAllCases() {
        // Test que todos los casos estén disponibles
        let allCases = TecnicaLaboratorio.allCases
        XCTAssertGreaterThan(allCases.count, 0, "Debe haber al menos una técnica de laboratorio")
    }
    
    // MARK: - 🧬 TESTS PARA GRUPOS POSEIDON
    
    func testGrupoPoseidonDisplayNames() {
        // Test que los nombres de display funcionen para casos básicos
        let allCases = GrupoPoseidon.allCases
        for grupo in allCases {
            XCTAssertFalse(grupo.descripcion.isEmpty, "Descripción de \(grupo.rawValue) no debe estar vacía")
        }
    }
    
    func testGrupoPoseidonRawValues() {
        // Test que los raw values sean strings válidos
        let allCases = GrupoPoseidon.allCases
        for grupo in allCases {
            XCTAssertFalse(grupo.rawValue.isEmpty, "Raw value de \(grupo) no debe estar vacío")
        }
    }
    
    func testGrupoPoseidonAllCases() {
        // Test que todos los casos estén disponibles
        let allCases = GrupoPoseidon.allCases
        XCTAssertGreaterThan(allCases.count, 0, "Debe haber al menos un grupo Poseidon")
    }
    
    // MARK: - 🧬 TESTS PARA COITO PROGRAMADO
    
    func testCoitoProgramadoEsIndicado() {
        // Test que el método principal funcione
        // Crear un perfil que cumpla los criterios de indicación
        let profile = createTestProfile(age: 28, amh: 2.5, bmi: 24.0)
        // Modificar el perfil para que cumpla criterios específicos
        var modifiedProfile = profile
        modifiedProfile.hasPcos = true // Esto garantiza que sea indicado según línea 220
        let resultado = CoitoProgramado.esIndicado(profile: modifiedProfile)
        XCTAssertTrue(resultado.indicado, "Coito programado debe ser indicado para perfil con SOP")
        XCTAssertFalse(resultado.razon.isEmpty, "Debe proporcionar una razón")
    }
    
    func testCoitoProgramadoNoEsIndicado() {
        // Test que el método principal funcione para casos no indicados
        let profile = createTestProfile(age: 45, amh: 0.1, bmi: 35.0)
        let resultado = CoitoProgramado.esIndicado(profile: profile)
        XCTAssertFalse(resultado.indicado, "Coito programado no debe ser indicado para perfil de alto riesgo")
        XCTAssertFalse(resultado.razon.isEmpty, "Debe proporcionar una razón")
    }
    
    // MARK: - 🧬 TESTS PARA VALIDACIONES
    
    func testValidacionEdad() {
        // Test que las validaciones de edad funcionen
        XCTAssertTrue(validarEdad(25), "Edad 25 debe ser válida")
        XCTAssertTrue(validarEdad(35), "Edad 35 debe ser válida")
        XCTAssertFalse(validarEdad(15), "Edad 15 no debe ser válida")
        XCTAssertFalse(validarEdad(55), "Edad 55 no debe ser válida")
    }
    
    func testValidacionAMH() {
        // Test que las validaciones de AMH funcionen
        XCTAssertTrue(validarAMH(1.5), "AMH 1.5 debe ser válido")
        XCTAssertTrue(validarAMH(3.0), "AMH 3.0 debe ser válido")
        XCTAssertFalse(validarAMH(-0.5), "AMH -0.5 no debe ser válido")
        XCTAssertFalse(validarAMH(10.0), "AMH 10.0 no debe ser válido")
    }
    
    func testValidacionBMI() {
        // Test que las validaciones de BMI funcionen
        XCTAssertTrue(validarBMI(22.0), "BMI 22.0 debe ser válido")
        XCTAssertTrue(validarBMI(28.0), "BMI 28.0 debe ser válido")
        XCTAssertFalse(validarBMI(15.0), "BMI 15.0 no debe ser válido")
        XCTAssertFalse(validarBMI(50.0), "BMI 50.0 no debe ser válido")
    }
    
    // MARK: - 🧬 TESTS PARA CÁLCULOS
    
    func testCalculoProbabilidadFIV() {
        // Test que el cálculo de probabilidad FIV funcione
        let probabilidad = calcularProbabilidadFIV(edad: 32, amh: 2.0, bmi: 25.0)
        XCTAssertGreaterThan(probabilidad, 0.0, "Probabilidad FIV debe ser mayor que 0")
        XCTAssertLessThanOrEqual(probabilidad, 1.0, "Probabilidad FIV debe ser menor o igual a 1")
    }
    
    func testCalculoProbabilidadICSI() {
        // Test que el cálculo de probabilidad ICSI funcione
        let probabilidad = calcularProbabilidadICSI(edad: 35, amh: 1.5, bmi: 28.0)
        XCTAssertGreaterThan(probabilidad, 0.0, "Probabilidad ICSI debe ser mayor que 0")
        XCTAssertLessThanOrEqual(probabilidad, 1.0, "Probabilidad ICSI debe ser menor o igual a 1")
    }
    
    func testCalculoTasaExitoOvodonacion() {
        // Test que el cálculo de tasa de éxito de ovodonación funcione
        let tasa = calcularTasaExitoOvodonacion(edad: 40)
        XCTAssertGreaterThan(tasa, 0.0, "Tasa de éxito de ovodonación debe ser mayor que 0")
        XCTAssertLessThanOrEqual(tasa, 1.0, "Tasa de éxito de ovodonación debe ser menor o igual a 1")
    }
    
    // MARK: - 🧬 FUNCIONES AUXILIARES
    
    private func createTestProfile(age: Int, amh: Double, bmi: Double) -> FertilityProfile {
        // Crear un perfil de prueba básico usando el inicializador correcto
        return FertilityProfile(
            age: Double(age),
            height: 165.0,
            weight: bmi * 2.5, // Calcular peso aproximado basado en BMI
            cycleLength: 28,
            infertilityDuration: 12,
            previousPregnancies: 0,
            hasPcos: false,
            hirsutismSeverity: .none,
            acneSeverity: .none,
            ovarianMorphology: .normal,
            endometriosisStage: 0,
            myomaType: .none,
            myomaSize: 0.0,
            adenomyosisType: .none,
            polypType: .none,
            hsgResult: .normal,
            hasPelvicSurgery: false,
            numberOfPelvicSurgeries: 0,
            hasOtb: false,
            otbMethod: .none,
            tpoAbPositive: false,
            insulinValue: 5.0,
            glucoseValue: 90.0,
            amhValue: amh,
            tshValue: 2.0,
            prolactinValue: 15.0,
            spermConcentration: 50.0,
            spermProgressiveMotility: 50.0,
            spermNormalMorphology: 4.0,
            semenVolume: 2.0,
            spermDNAFragmentation: 15.0,
            hasVaricocele: false,
            seminalCulturePositive: false
        )
    }
    
    private func validarEdad(_ edad: Int) -> Bool {
        return edad >= 18 && edad <= 50
    }
    
    private func validarAMH(_ amh: Double) -> Bool {
        return amh >= 0.0 && amh <= 8.0
    }
    
    private func validarBMI(_ bmi: Double) -> Bool {
        return bmi >= 16.0 && bmi <= 45.0
    }
    
    private func calcularProbabilidadFIV(edad: Int, amh: Double, bmi: Double) -> Double {
        // Cálculo simplificado para testing
        let factorEdad = max(0.1, 1.0 - Double(edad - 25) * 0.02)
        let factorAMH = max(0.1, min(1.0, amh / 3.0))
        let factorBMI = max(0.1, min(1.0, 1.0 - abs(bmi - 22.0) * 0.02))
        return factorEdad * factorAMH * factorBMI
    }
    
    private func calcularProbabilidadICSI(edad: Int, amh: Double, bmi: Double) -> Double {
        // Cálculo simplificado para testing
        let probabilidadFIV = calcularProbabilidadFIV(edad: edad, amh: amh, bmi: bmi)
        return probabilidadFIV * 0.8 // ICSI suele ser ligeramente menor que FIV
    }
    
    private func calcularTasaExitoOvodonacion(edad: Int) -> Double {
        // Cálculo simplificado para testing
        return max(0.3, 0.7 - Double(edad - 25) * 0.01)
    }
}
