import SwiftUI

struct TreatmentSimulatorView: View {
	let profile: FertilityProfile
	private let simulator = TreatmentSimulator()
	@State private var recommendation: TreatmentRecommendation?
	@State private var simulations: [ModifiableFactorSimulation] = []
	@State private var nonModifiableFactors: [NonModifiableFactor] = []
	@State private var completeAnalysis: CompleteFactorAnalysis?
	@Environment(\.themeColors) var colors
	
	var body: some View {
		ScrollView {
			VStack(spacing: 16) {
				header
				summarySection
				recommendationSection
				modifiableFactorsSection
				nonModifiableFactorsSection
				Spacer(minLength: 20)
			}
			.padding()
		}
		.background(colors.backgroundGradient)
		.onAppear(perform: compute)
	}
	
	private var header: some View {
		HStack(spacing: 12) {
			Image(systemName: "cross.case.fill")
				.font(.title2)
				.foregroundColor(.purple)
			
			VStack(alignment: .leading, spacing: 2) {
				Text("Simulador de Tratamientos")
					.font(.title2)
					.fontWeight(.bold)
				Text("Recomendación personalizada + mejoras alcanzables")
					.font(.caption)
					.foregroundColor(.secondary)
			}
			Spacer()
		}
	}
	
	private var summarySection: some View {
		VStack(alignment: .leading, spacing: 12) {
			Text("Resumen del Análisis")
				.font(.headline)
				.fontWeight(.semibold)
			
			if let analysis = completeAnalysis {
				Text(analysis.summary)
					.font(.subheadline)
					.foregroundColor(.primary)
					.padding(12)
					.background(colors.surface)
					.cornerRadius(10)
					.shadow(color: colors.border.opacity(0.2), radius: 2, x: 0, y: 1)
			}
		}
	}
	
	private var recommendationSection: some View {
		VStack(alignment: .leading, spacing: 12) {
			Text("Recomendación Principal")
				.font(.headline)
				.fontWeight(.semibold)
			
			if let rec = recommendation {
				VStack(alignment: .leading, spacing: 12) {
					HStack {
						Image(systemName: "stethoscope")
							.foregroundColor(.blue)
						Text(rec.plan.rawValue)
							.font(.title3)
							.fontWeight(.bold)
						Spacer()
					}
					
					Text(rec.plan.description)
						.font(.subheadline)
						.foregroundColor(.secondary)
					
					HStack(spacing: 16) {
						Label("Tasa estimada: \(Int(rec.successRate * 100))%", systemImage: "percent")
							.font(.caption)
							.foregroundColor(.primary)
						Label("Tiempo estimado: \(rec.timeToPregnancy)", systemImage: "clock")
							.font(.caption)
							.foregroundColor(.primary)
					}
					
					if !rec.rationale.isEmpty {
						VStack(alignment: .leading, spacing: 6) {
							Text("Motivos clínicos")
								.font(.subheadline)
								.fontWeight(.semibold)
							ForEach(rec.rationale, id: \.self) { reason in
								HStack(alignment: .top, spacing: 8) {
									Image(systemName: "chevron.right.circle.fill").foregroundColor(.blue)
									Text(reason).font(.caption)
								}
							}
						}
					}
					
					Divider().padding(.vertical, 4)
					
					if !rec.references.isEmpty {
						VStack(alignment: .leading, spacing: 6) {
							Text("Bibliografía")
								.font(.subheadline)
								.fontWeight(.semibold)
							ForEach(0..<rec.references.count, id: \.self) { idx in
								let r = rec.references[idx]
								Text("• \(r.citation)")
									.font(.caption)
									.foregroundColor(.secondary)
							}
						}
					}
				}
				.padding(16)
				.background(colors.surface)
				.cornerRadius(12)
				.shadow(color: colors.border.opacity(0.3), radius: 4, x: 0, y: 2)
			} else {
				ProgressView("Calculando recomendación...")
			}
		}
	}
	
	private var modifiableFactorsSection: some View {
		VStack(alignment: .leading, spacing: 12) {
			Text("Factores Modificables (Simulación)")
				.font(.headline)
				.fontWeight(.semibold)
			
			if simulations.isEmpty {
				Text("No se identificaron factores modificables relevantes.")
					.font(.caption)
					.foregroundColor(.secondary)
			} else {
				VStack(spacing: 10) {
					ForEach(0..<simulations.count, id: \.self) { idx in
						let s = simulations[idx]
						HStack(alignment: .top, spacing: 12) {
							VStack(alignment: .leading, spacing: 4) {
								Text(s.factor)
									.font(.subheadline)
									.fontWeight(.semibold)
								Text("Actual: \(s.currentValue) → Objetivo: \(s.recommendedValue)")
									.font(.caption)
									.foregroundColor(.secondary)
								Text("Mejora estimada: \(String(format: "%.0f", s.improvement))% • Tiempo: \(s.timeToAchieve)")
									.font(.caption)
								Text("Recomendación: \(s.recommendation)")
									.font(.caption)
							}
							Spacer()
						}
						.padding(12)
						.background(colors.surface)
						.cornerRadius(10)
						.shadow(color: colors.border.opacity(0.2), radius: 2, x: 0, y: 1)
					}
				}
			}
		}
	}
	
	private var nonModifiableFactorsSection: some View {
		VStack(alignment: .leading, spacing: 12) {
			Text("⚠️ Factores No Modificables")
				.font(.headline)
				.fontWeight(.semibold)
			
			if nonModifiableFactors.isEmpty {
				Text("No se identificaron factores no modificables relevantes.")
					.font(.caption)
					.foregroundColor(.secondary)
			} else {
				VStack(spacing: 10) {
					ForEach(0..<nonModifiableFactors.count, id: \.self) { idx in
						let factor = nonModifiableFactors[idx]
						VStack(alignment: .leading, spacing: 8) {
							HStack {
								Image(systemName: "exclamationmark.triangle.fill")
									.foregroundColor(.orange)
								Text(factor.factor)
									.font(.subheadline)
									.fontWeight(.semibold)
								Spacer()
								Text(factor.severity)
									.font(.caption)
									.padding(.horizontal, 8)
									.padding(.vertical, 2)
									.background(Color.orange.opacity(0.2))
									.cornerRadius(4)
							}
							
							Text("Valor actual: \(factor.currentValue)")
								.font(.caption)
								.foregroundColor(.secondary)
							
							Text("Impacto: \(factor.impact)")
								.font(.caption)
								.foregroundColor(.primary)
							
							Text(factor.explanation)
								.font(.caption)
								.foregroundColor(.secondary)
							
							Text("Implicación clínica: \(factor.clinicalImplication)")
								.font(.caption)
								.fontWeight(.medium)
								.foregroundColor(.blue)
						}
						.padding(12)
						.background(colors.surface)
						.cornerRadius(10)
						.shadow(color: colors.border.opacity(0.2), radius: 2, x: 0, y: 1)
					}
				}
			}
		}
	}
	
	private func compute() {
		recommendation = simulator.determineOptimalTreatment(profile: profile)
		simulations = simulator.simulateModifiableFactors(profile: profile)
		nonModifiableFactors = simulator.identifyNonModifiableFactors(profile: profile)
		completeAnalysis = simulator.generateCompleteFactorAnalysis(profile: profile)
	}
}
