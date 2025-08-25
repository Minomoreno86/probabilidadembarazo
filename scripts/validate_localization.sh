#!/bin/bash

# Script de validación de localización para Pronóstico Fertilidad
# Verifica la cobertura entre archivos de localización en español e inglés

echo "🔍 VALIDANDO SISTEMA DE LOCALIZACIÓN"
echo "====================================="

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Rutas de archivos
ES_FILE="Pronostico fertilidad/Localization/es.lproj/Localizable.strings"
EN_FILE="Pronostico fertilidad/Localization/en.lproj/Localizable.strings"

# Verificar que los archivos existan
if [ ! -f "$ES_FILE" ]; then
    echo -e "${RED}❌ Error: Archivo español no encontrado: $ES_FILE${NC}"
    exit 1
fi

if [ ! -f "$EN_FILE" ]; then
    echo -e "${RED}❌ Error: Archivo inglés no encontrado: $EN_FILE${NC}"
    exit 1
fi

echo -e "${BLUE}📁 Archivos encontrados:${NC}"
echo "   Español: $ES_FILE"
echo "   Inglés:  $EN_FILE"
echo ""

# Función para extraer claves de un archivo
extract_keys() {
    local file="$1"
    grep '^"[^"]*" = ' "$file" | sed 's/^"\([^"]*\)" = .*/\1/' | sort
}

# Función para contar líneas de contenido (excluyendo comentarios y líneas vacías)
count_content_lines() {
    local file="$1"
    grep -v '^//' "$file" | grep -v '^$' | grep -v '^/\*' | grep -v '^\*/' | wc -l
}

# Extraer claves
echo -e "${BLUE}🔑 Extrayendo claves de localización...${NC}"
ES_KEYS=$(extract_keys "$ES_FILE")
EN_KEYS=$(extract_keys "$EN_FILE")

# Contar claves
ES_COUNT=$(echo "$ES_KEYS" | wc -l)
EN_COUNT=$(echo "$EN_KEYS" | wc -l)

echo -e "${GREEN}✅ Conteo de claves:${NC}"
echo "   Español: $ES_COUNT claves"
echo "   Inglés:  $EN_COUNT claves"
echo ""

# Encontrar claves faltantes en inglés
echo -e "${BLUE}🔍 Buscando claves faltantes en inglés...${NC}"
MISSING_IN_EN=$(comm -23 <(echo "$ES_KEYS") <(echo "$EN_KEYS"))

if [ -z "$MISSING_IN_EN" ]; then
    echo -e "${GREEN}✅ Todas las claves del español están presentes en inglés${NC}"
else
    echo -e "${RED}❌ Claves faltantes en inglés:${NC}"
    echo "$MISSING_IN_EN" | while read -r key; do
        echo -e "   ${RED}• $key${NC}"
    done
    echo ""
fi

# Encontrar claves faltantes en español
echo -e "${BLUE}🔍 Buscando claves faltantes en español...${NC}"
MISSING_IN_ES=$(comm -13 <(echo "$ES_KEYS") <(echo "$EN_KEYS"))

if [ -z "$MISSING_IN_ES" ]; then
    echo -e "${GREEN}✅ Todas las claves del inglés están presentes en español${NC}"
else
    echo -e "${YELLOW}⚠️  Claves faltantes en español:${NC}"
    echo "$MISSING_IN_ES" | while read -r key; do
        echo -e "   ${YELLOW}• $key${NC}"
    done
    echo ""
fi

# Calcular cobertura
if [ $ES_COUNT -gt 0 ]; then
    COVERAGE_EN=$(echo "scale=1; ($EN_COUNT * 100) / $ES_COUNT" | bc -l 2>/dev/null || echo "0")
    echo -e "${BLUE}📊 Cobertura de localización:${NC}"
    echo "   Cobertura inglés: ${COVERAGE_EN}%"
    
    if (( $(echo "$COVERAGE_EN >= 95" | bc -l) )); then
        echo -e "   ${GREEN}✅ Excelente cobertura${NC}"
    elif (( $(echo "$COVERAGE_EN >= 90" | bc -l) )); then
        echo -e "   ${YELLOW}⚠️  Buena cobertura${NC}"
    elif (( $(echo "$COVERAGE_EN >= 80" | bc -l) )); then
        echo -e "   ${YELLOW}⚠️  Cobertura aceptable${NC}"
    else
        echo -e "   ${RED}❌ Cobertura insuficiente${NC}"
    fi
fi

# Buscar strings hardcodeados en código Swift
echo ""
echo -e "${BLUE}🔍 Buscando strings hardcodeados en código Swift...${NC}"
HARDCODED_STRINGS=$(grep -r '"[^"]*"' "Pronostico fertilidad" --include="*.swift" | grep -v "NSLocalizedString\|localizationManager" | grep -v "//" | grep -v "import" | grep -v "struct\|class\|enum\|func" | head -20)

if [ -z "$HARDCODED_STRINGS" ]; then
    echo -e "${GREEN}✅ No se encontraron strings hardcodeados evidentes${NC}"
else
    echo -e "${YELLOW}⚠️  Posibles strings hardcodeados encontrados:${NC}"
    echo "$HARDCODED_STRINGS" | while read -r line; do
        echo -e "   ${YELLOW}• $line${NC}"
    done
    echo -e "${BLUE}💡 Sugerencia: Revisar estos strings para localización${NC}"
fi

# Resumen final
echo ""
echo -e "${BLUE}📋 RESUMEN DE VALIDACIÓN${NC}"
echo "====================================="

if [ -z "$MISSING_IN_EN" ] && [ -z "$MISSING_IN_ES" ]; then
    echo -e "${GREEN}🎉 ¡Sistema de localización completamente sincronizado!${NC}"
    EXIT_CODE=0
else
    echo -e "${RED}⚠️  Se encontraron inconsistencias en la localización${NC}"
    EXIT_CODE=1
fi

echo ""
echo -e "${BLUE}💡 Recomendaciones:${NC}"
echo "   1. Agregar claves faltantes en ambos idiomas"
echo "   2. Verificar que las traducciones sean apropiadas"
echo "   3. Ejecutar este script antes de cada release"
echo "   4. Considerar usar herramientas automatizadas de localización"

exit $EXIT_CODE
