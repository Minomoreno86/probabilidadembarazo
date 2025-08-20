#!/bin/bash

# 🧪 SCRIPT DE CODE COVERAGE - PRONÓSTICO FERTILIDAD
# Este script ejecuta tests y genera reportes de cobertura

set -e

echo "🧪 INICIANDO ANÁLISIS DE CODE COVERAGE..."
echo "=========================================="

# Configuración
PROJECT_NAME="Pronostico fertilidad"
SCHEME_NAME="Pronostico fertilidad"
DESTINATION="platform=iOS Simulator,name=iPhone 16,OS=18.5"
COVERAGE_DIR="CoverageResults"
REPORT_DIR="CoverageReports"

# Limpiar directorios anteriores
echo "🧹 Limpiando directorios anteriores..."
rm -rf "$COVERAGE_DIR"
rm -rf "$REPORT_DIR"
mkdir -p "$REPORT_DIR"

# Ejecutar tests con cobertura
echo "🚀 Ejecutando tests con cobertura habilitada..."
xcodebuild test \
    -project "$PROJECT_NAME.xcodeproj" \
    -scheme "$SCHEME_NAME" \
    -destination "$DESTINATION" \
    -enableCodeCoverage YES \
    -resultBundlePath "$COVERAGE_DIR" \
    -derivedDataPath "DerivedData" \
    | xcpretty --color --simple

# Verificar que los tests pasaron
if [ $? -eq 0 ]; then
    echo "✅ Tests ejecutados exitosamente"
else
    echo "❌ Los tests fallaron. Revisa los errores antes de continuar."
    exit 1
fi

# Generar reporte de cobertura
echo "📊 Generando reporte de cobertura..."
xcrun xccov view --report --json "$COVERAGE_DIR" > "$REPORT_DIR/coverage.json"

# Generar reporte HTML (si está disponible)
if command -v xcrun &> /dev/null; then
    echo "🌐 Generando reporte HTML..."
    xcrun xccov view --report --html "$COVERAGE_DIR" > "$REPORT_DIR/coverage.html" 2>/dev/null || echo "⚠️  Reporte HTML no disponible"
fi

# Generar reporte detallado
echo "📋 Generando reporte detallado..."
xcrun xccov view --report "$COVERAGE_DIR" > "$REPORT_DIR/coverage.txt"

# Analizar cobertura por archivo
echo "🔍 Analizando cobertura por archivo..."
xcrun xccov view --report --files "$COVERAGE_DIR" > "$REPORT_DIR/coverage-by-file.txt"

# Generar reporte resumido
echo "📊 Generando reporte resumido..."
{
    echo "# 📊 REPORTE DE CODE COVERAGE"
    echo ""
    echo "**Fecha:** $(date)"
    echo "**Proyecto:** $PROJECT_NAME"
    echo "**Scheme:** $SCHEME_NAME"
    echo ""
    echo "## 📈 RESUMEN GENERAL"
    echo ""
    echo "### Cobertura Total:"
    echo "- **Archivos analizados:** $(grep -c '^.*\.swift' "$REPORT_DIR/coverage-by-file.txt" 2>/dev/null || echo "N/A")"
    echo "- **Líneas cubiertas:** $(grep -o '[0-9]\+/[0-9]\+' "$REPORT_DIR/coverage.txt" | head -1 | sed 's/\// de /' || echo "N/A")"
    echo ""
    echo "## 📁 ARCHIVOS CON MAYOR COBERTURA"
    echo ""
    if [ -f "$REPORT_DIR/coverage-by-file.txt" ]; then
        grep -E '^.*\.swift.*[0-9]+/[0-9]+' "$REPORT_DIR/coverage-by-file.txt" | head -10 | while read line; do
            echo "- $line"
        done
    else
        echo "⚠️  Información de archivos no disponible"
    fi
    echo ""
    echo "## 📊 ARCHIVOS CON MENOR COBERTURA"
    echo ""
    if [ -f "$REPORT_DIR/coverage-by-file.txt" ]; then
        grep -E '^.*\.swift.*[0-9]+/[0-9]+' "$REPORT_DIR/coverage-by-file.txt" | tail -10 | while read line; do
            echo "- $line"
        done
    else
        echo "⚠️  Información de archivos no disponible"
    fi
    echo ""
    echo "## 🎯 RECOMENDACIONES"
    echo ""
    echo "### Para alcanzar 90%+ de cobertura:"
    echo "1. **Agregar tests** para archivos con baja cobertura"
    echo "2. **Refactorizar código** no cubierto"
    echo "3. **Implementar mocks** para dependencias externas"
    echo "4. **Agregar tests de edge cases**"
    echo ""
    echo "## 📱 ARCHIVOS DE REPORTE"
    echo ""
    echo "- **JSON:** $REPORT_DIR/coverage.json"
    echo "- **HTML:** $REPORT_DIR/coverage.html"
    echo "- **Texto:** $REPORT_DIR/coverage.txt"
    echo "- **Por archivo:** $REPORT_DIR/coverage-by-file.txt"
    echo ""
    echo "## 🚀 PRÓXIMOS PASOS"
    echo ""
    echo "1. **Revisar reportes** generados"
    echo "2. **Identificar archivos** con baja cobertura"
    echo "3. **Agregar tests** faltantes"
    echo "4. **Ejecutar script** nuevamente para verificar mejora"
    
} > "$REPORT_DIR/coverage-summary.md"

# Mostrar resumen
echo ""
echo "🎉 ANÁLISIS DE COBERTURA COMPLETADO"
echo "===================================="
echo "📁 Directorio de reportes: $REPORT_DIR"
echo "📊 Reporte resumido: $REPORT_DIR/coverage-summary.md"
echo "📋 Reporte detallado: $REPORT_DIR/coverage.txt"
echo "🌐 Reporte HTML: $REPORT_DIR/coverage.html"
echo ""

# Mostrar cobertura total si está disponible
if [ -f "$REPORT_DIR/coverage.txt" ]; then
    echo "📈 COBERTURA TOTAL:"
    grep -E '[0-9]+/[0-9]+' "$REPORT_DIR/coverage.txt" | head -1
    echo ""
fi

echo "✅ Script completado exitosamente!"
