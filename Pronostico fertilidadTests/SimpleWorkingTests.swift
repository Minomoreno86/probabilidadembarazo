//
//  SimpleWorkingTests.swift
//  Pronostico fertilidadTests
//
//  Tests simples que funcionan con el código actual
//

import XCTest
@testable import Pronostico_fertilidad

class SimpleWorkingTests: XCTestCase {
    
    // MARK: - 🧬 TESTS PARA ENUMS BÁSICOS
    
    func testMyomaTypeDisplayNames() {
        // Test que los nombres de display funcionen
        XCTAssertEqual(MyomaType.none.displayName, "Ninguno")
        XCTAssertEqual(MyomaType.submucosal.displayName, "Submucoso")
        XCTAssertEqual(MyomaType.intramural.displayName, "Intramural")
        XCTAssertEqual(MyomaType.subserosal.displayName, "Subseroso")
    }
    
    func testAdenomyosisTypeDisplayNames() {
        // Test que los nombres de display funcionen
        XCTAssertEqual(AdenomyosisType.none.displayName, "Ninguna")
        XCTAssertEqual(AdenomyosisType.focal.displayName, "Focal")
        XCTAssertEqual(AdenomyosisType.diffuse.displayName, "Difusa")
    }
    
    func testPolypTypeDisplayNames() {
        // Test que los nombres de display funcionen
        XCTAssertEqual(PolypType.none.displayName, "Ninguno")
        XCTAssertEqual(PolypType.single.displayName, "Único")
        XCTAssertEqual(PolypType.multiple.displayName, "Múltiples")
    }
    
    func testHsgResultDisplayNames() {
        // Test que los nombres de display funcionen
        XCTAssertEqual(HsgResult.normal.displayName, "Normal")
        XCTAssertEqual(HsgResult.unilateral.displayName, "Obstrucción Unilateral")
        XCTAssertEqual(HsgResult.bilateral.displayName, "Obstrucción Bilateral")
    }
    
    func testOtbMethodDisplayNames() {
        // Test que los nombres de display funcionen
        XCTAssertEqual(OtbMethod.none.displayName, "Ninguno")
        XCTAssertEqual(OtbMethod.clips.displayName, "Clips")
        XCTAssertEqual(OtbMethod.coagulation.displayName, "Coagulación")
        XCTAssertEqual(OtbMethod.salpingectomy.displayName, "Salpingectomía")
    }
    
    func testHirsutismSeverityDisplayNames() {
        // Test que los nombres de display funcionen
        XCTAssertEqual(HirsutismSeverity.none.displayName, "No")
        XCTAssertEqual(HirsutismSeverity.mild.displayName, "Leve (vello en mentón)")
        XCTAssertEqual(HirsutismSeverity.moderate.displayName, "Moderado (vello en mentón + mejillas)")
        XCTAssertEqual(HirsutismSeverity.severe.displayName, "Severo (vello facial extenso)")
    }
    
    // MARK: - 🧬 TESTS PARA ENUMS DE SOP
    
    func testHirsutismSeverityCases() {
        // Test que todos los casos estén disponibles
        let allCases = HirsutismSeverity.allCases
        XCTAssertEqual(allCases.count, 4)
        XCTAssertTrue(allCases.contains(.none))
        XCTAssertTrue(allCases.contains(.mild))
        XCTAssertTrue(allCases.contains(.moderate))
        XCTAssertTrue(allCases.contains(.severe))
    }
    
    func testMyomaTypeCases() {
        // Test que todos los casos estén disponibles
        let allCases = MyomaType.allCases
        XCTAssertEqual(allCases.count, 4)
        XCTAssertTrue(allCases.contains(.none))
        XCTAssertTrue(allCases.contains(.submucosal))
        XCTAssertTrue(allCases.contains(.intramural))
        XCTAssertTrue(allCases.contains(.subserosal))
    }
    
    func testAdenomyosisTypeCases() {
        // Test que todos los casos estén disponibles
        let allCases = AdenomyosisType.allCases
        XCTAssertEqual(allCases.count, 3)
        XCTAssertTrue(allCases.contains(.none))
        XCTAssertTrue(allCases.contains(.focal))
        XCTAssertTrue(allCases.contains(.diffuse))
    }
    
    func testPolypTypeCases() {
        // Test que todos los casos estén disponibles
        let allCases = PolypType.allCases
        XCTAssertEqual(allCases.count, 3)
        XCTAssertTrue(allCases.contains(.none))
        XCTAssertTrue(allCases.contains(.single))
        XCTAssertTrue(allCases.contains(.multiple))
    }
    
    func testHsgResultCases() {
        // Test que todos los casos estén disponibles
        let allCases = HsgResult.allCases
        XCTAssertEqual(allCases.count, 3)
        XCTAssertTrue(allCases.contains(.normal))
        XCTAssertTrue(allCases.contains(.unilateral))
        XCTAssertTrue(allCases.contains(.bilateral))
    }
    
    func testOtbMethodCases() {
        // Test que todos los casos estén disponibles
        let allCases = OtbMethod.allCases
        XCTAssertEqual(allCases.count, 4)
        XCTAssertTrue(allCases.contains(.none))
        XCTAssertTrue(allCases.contains(.clips))
        XCTAssertTrue(allCases.contains(.coagulation))
        XCTAssertTrue(allCases.contains(.salpingectomy))
    }
    
    // MARK: - 🧬 TESTS PARA CODIFICACIÓN
    
    func testEnumCodability() {
        // Test que los enums se puedan codificar/decodificar
        let myoma = MyomaType.submucosal
        let data = try? JSONEncoder().encode(myoma)
        XCTAssertNotNil(data, "MyomaType debe ser codificable")
        
        let decoded = try? JSONDecoder().decode(MyomaType.self, from: data!)
        XCTAssertEqual(decoded, myoma, "MyomaType debe ser decodificable correctamente")
    }
    
    func testMultipleEnumCodability() {
        // Test múltiples enums
        let adenomyosis = AdenomyosisType.focal
        let polyp = PolypType.single
        let hsg = HsgResult.unilateral
        
        let data1 = try? JSONEncoder().encode(adenomyosis)
        let data2 = try? JSONEncoder().encode(polyp)
        let data3 = try? JSONEncoder().encode(hsg)
        
        XCTAssertNotNil(data1, "AdenomyosisType debe ser codificable")
        XCTAssertNotNil(data2, "PolypType debe ser codificable")
        XCTAssertNotNil(data3, "HsgResult debe ser codificable")
    }
    
    // MARK: - 🧬 TESTS PARA VALIDACIÓN DE STRINGS
    
    func testEnumStringValues() {
        // Test que los valores raw string sean correctos
        XCTAssertEqual(MyomaType.submucosal.rawValue, "submucosal")
        XCTAssertEqual(AdenomyosisType.focal.rawValue, "focal")
        XCTAssertEqual(PolypType.multiple.rawValue, "multiple")
        XCTAssertEqual(HsgResult.bilateral.rawValue, "bilateral")
        XCTAssertEqual(OtbMethod.coagulation.rawValue, "coagulation")
        XCTAssertEqual(HirsutismSeverity.severe.rawValue, "severe")
    }
    
    func testEnumFromString() {
        // Test que se puedan crear desde strings
        let myoma = MyomaType(rawValue: "intramural")
        let adenomyosis = AdenomyosisType(rawValue: "diffuse")
        let polyp = PolypType(rawValue: "single")
        
        XCTAssertEqual(myoma, .intramural)
        XCTAssertEqual(adenomyosis, .diffuse)
        XCTAssertEqual(polyp, .single)
    }
    
    func testInvalidEnumStrings() {
        // Test que strings inválidos retornen nil
        let invalidMyoma = MyomaType(rawValue: "invalid")
        let invalidAdenomyosis = AdenomyosisType(rawValue: "invalid")
        let invalidPolyp = PolypType(rawValue: "invalid")
        
        XCTAssertNil(invalidMyoma)
        XCTAssertNil(invalidAdenomyosis)
        XCTAssertNil(invalidPolyp)
    }
}
