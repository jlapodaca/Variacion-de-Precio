#######
#######
### Inicializacion variacion de precios
#######
#######

## Descripcion:

# La inicializacion genera los data tables de interes, con los nombres de variables
# en formato tidy data, con variables limpias, en minusculas, las clases de variables
# correctas
# El output de esta funcion son 3 data tables para trabajar  
# dfMesActual  con los datos completos del mes actual
# dfMesPrevio con los datos completos del mes de comparacion previo
# dfTotal con los datos de ambos meses



## Secuencia para cargar archivos, asume que archivos estan en "working directory"/Data  
## y que se ha usado Set Working Directory To source file location
  
  path.dir <- 'Data'

## nombres de archivos a pasar al analisis
  f.MesActual<-file.path(path.dir,"BO Mayo 14.csv", fsep=.Platform$file.sep)    # MOD 
  f.MesPrevio<-file.path(path.dir,"BO Abril 14.csv", fsep=.Platform$file.sep)   # MOD

# NOTA: Archivos extraidos del BO por Desarrollo Comercial


## lectura archivos
  dfMesActual<-read.csv(f.MesActual)
  dfMesPrevio<-read.csv(f.MesPrevio)

  dfMesActual<-dfMesActual[!dfMesActual$Mes=="", ]   
  dfMesPrevio<-dfMesPrevio[!dfMesPrevio$Mes=="",]
  


## Funcion para limpiar nombres de columnas, 
## eliminando caracteres extras como "Destin..mcía..V.Com.."

Limpia.nombres<-function(df){
  
  veccolumnas<-colnames(df)
  
  veccolumnas<-gsub('Destin..mcía..V.Com..', '', veccolumnas)
  veccolumnas<-gsub('..Denominación.media.', '', veccolumnas)
  veccolumnas<-gsub('Destin.fac..V..Com..', '', veccolumnas)
  veccolumnas<-gsub("\\.\\.", ".", veccolumnas)
  veccolumnas<-gsub("\\.\\.", ".", veccolumnas)  # para los nombres con tres puntos
  veccolumnas<-gsub("ón", "on", veccolumnas)
  veccolumnas<-gsub("\\.$", "", veccolumnas) 
  
  veccolumnas<-tolower(veccolumnas)   # cambia a minusculas (Google R Style Guide para variables)
  
  colnames(df)<-veccolumnas
  
  return (df)
}


# Ejecuta funcion para limpiar nombres de variables para tener dos data frames 
# con los datos a comparar cuyos nombres de variables deben ser identicos y 
# estandarizados de acuerdo al Google R Style Guide

  dfMesActual<-Limpia.nombres(dfMesActual)   
  dfMesPrevio<-Limpia.nombres(dfMesPrevio)

  if (identical(colnames(dfMesActual), colnames(dfMesPrevio))==FALSE){
    stop("Estructura de archivos de entrada no es identica 
         (cantidad o nombre de variables). Revisar archivos BO")
  }   # condicion solo para validar que los nombres esten identicos



# Ejecuta funcion para dejar listas las variables numericas como clase numeric

# primero se declaran en col.numericas las variables que deben ser numericas
# declara otras funciones para asegurar que las variables numericas sean tratadas 
# como clase numeric y no como factores

  col.numericas<-c("importe.de.venta","volumen.bombeo", "volumen.colocacion",
                 "volumen.concreto", "volumen.aditivos.adiciones.y.fibras",  
                 "volumen.cargos.adicionales", "importe.bombeo",
                 "importe.colocacion", "importe.concreto",
                 "importe.cargos.adicionales","importe.base", 
                 "descuento.automatico.otros.descuentos")

  asNumeric <- function(x) {
    as.numeric(as.character(x))
  }

  factorsNumeric <- function(d) {
   modifyList(d, lapply(d[, col.numericas], asNumeric))
  }

# ejecuta funcion para dejar listas  las clases numericas

  dfMesActual<-factorsNumeric(dfMesActual)    
  dfMesPrevio<-factorsNumeric(dfMesPrevio) 


# Fusionar archivos para contar con un solo archivo donde esten todos los datos,
# convierte todos los archivos fuente a data table
  
  dfTotal<-rbind.fill(dfMesActual, dfMesPrevio)
  dfTotal<-data.table(dfTotal)
  dfMesActual<-data.table(dfMesActual)
  dfMesPrevio<-data.table(dfMesPrevio)
  


######
#####
####
##
#   FIN


# Script opcional para recordar la estructura de los archivos

# vector con nombres de variables de interes
  
  descriptores<-c("region.zona", "gerencia","area.comercial", "mercado.comercial",
                  "centro.clave", "centro", "holding", "destinatario.de.merc",  
                  "solicitante","frente", "vendedor.admys", "vendedor.promotor",
                  "canal","sub.canal", "especialidad", "region.denominacion", 
                  "ciudad", "micromercado", "clasificacion.articu", "producto",
                  "gpo.de.materiales.nav", "tipo.pe", "grupo", "tipo",
                  "material", "identificador.combo","premio.pe",
                  "grupo.de.clientes.denominacion","cliente.inst", "plaza",
                  "zona")  
  
  
  ## Lista con descripcion de las variables descriptoras potencialmente
  # a ser usadas para agregar el analisis de precio, se incluyen como ejemplo 
  # 5 factores por variable
  
  explorar.descriptores<-lapply(descriptores, function(column){
    aux<-NULL
    aux$variable<-column
    aux$cant.factores<-nlevels(dfMesActual[ , column])
    aux$factores<-levels(dfMesActual[ , column])[2:6]
    #aux$tabla<-table(dfMesActual[ , column])     # MOD para agregar tabla de frecuencia
    return(aux)
  })
  
  # print(explorar.descriptores)  # MOD opcional para ver la estructura del archivo
  
  # levels(dfMesActual$tipo)       # MOD si se quiere ver los niveles de otras variables
  