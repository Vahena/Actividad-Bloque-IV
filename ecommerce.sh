ventas_csv='/workspaces/Actividad-Bloque-IV/ventas.csv'

#Función top 10 productos más vendidos
top_10() {
    local ventas_csv=$1
    awk -F',' '{productos[$2]+=$3} END {for (producto in productos) print productos[producto], producto}' "$ventas_csv" \
    | sort -rn | head -n 10 | nl
}

#Función ingresos por categoría
ingresos_categoria() {
    local ventas_csv=$1
    awk -F',' '{ingresos[$5]+=7} END {for (categoria in ingresos) if (ingresos[categoria] > 10) print categoria, ingresos[categoria]}' "$ventas_csv"
}

#Funcion ingresos por mes
ingresos_mes() {
    local ventas_csv=$1
    awk -F',' 'BEGIN {
        meses["01"]="Enero"
        meses["02"]="Febrero"
        meses["03"]="Marzo"
        meses["04"]="Abril"
        meses["05"]="Mayo"
        meses["06"]="Junio"
        meses["07"]="Julio"
        meses["08"]="Agosto"
        meses["09"]="Septiembre"
        meses["10"]="Octubre"
        meses["11"]="Noviembre"
        meses["12"]="Diciembre"
    }
    {
        mes=substr($1, 6, 2)
        ingresos[mes]+=$7
    }
    END {
        for (i=1; i<=12; i++) {
            mes=sprintf("%02d", i)
            mes_nombre=meses[mes]
            print mes_nombre, ingresos[mes]+0
        }
    }' "$ventas_csv"
}

#Función ingresos por cliente
ingresos_cliente() {
    local ventas_csv=$1
    awk -F',' '{ingresos[$4]+=$7} END {for (cliente in ingresos) print cliente, ingresos[cliente]}' "$ventas_csv"
}

#Función ingresos por departamento
ingresos_departamento() {
    local ventas_csv=$1
    awk -F',' '{ingresos[$6]+=$7} END {for (departamento in ingresos) print departamento, ingresos[departamento]}' "$ventas_csv"
}

{
    echo " .:.REPORTE DE VENTAS.:." 
    echo "TOP 10 productos más vendidos: " 
    top_10 "$ventas_csv"
    echo "" 
    echo "Total de ingresos por categoría: " 
    ingresos_categoria "$ventas_csv"
    echo "" 
    echo "Total ingresos por mes: " 
    ingresos_mes "$ventas_csv"
    echo "" 
    echo "Total de ingresos por clientes: " 
    ingresos_cliente "$ventas_csv"
    echo "" 
    echo "Total de ingresos por departamentos: " 
    ingresos_departamento "$ventas_csv"
    echo "" 
    echo "Informe generado el $(date)" "$ventas_csv"

} >> /workspaces/Actividad-Bloque-IV/reporte.txt