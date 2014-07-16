## 
### Inicializacion variacion de precios
##


## Carga librerias que probablemente se usen

library(ggplot2)
library(memisc)
library(reshape2)
library(plyr)
library(data.table)
library(qdap)
library(gridBase) 

#source()


## carga datos, asume que archivos estan en "working directory"/Data  y que se ha
## usado Set Working Directory To source file location
  path.dir <- 'Data'

## nombres de archivos a pasar al analisis
  f.MesActual<-file.path(path.dir,"BO Mayo 14.csv", fsep=.Platform$file.sep)    # MOD
  f.MesPrevio<-file.path(path.dir,"BO Abril 14.csv", fsep=.Platform$file.sep)  # MOD

# NOTA: Archivos extraidos del BO por Desarrollo Comercial


## lectura archivos
  dfMesActual<-read.csv(f.MesActual)
  dfMesPrevio<-read.csv(f.MesPrevio)

  dfMesActual<-dfMesActual[!dfMesActual$Mes=="", ]   ## MOD dependiendo del mes
# se agregó la instrucción porque el Excel trae renglones blancos de más
  dfMesPrevio<-dfMesPrevio[!dfMesPrevio$Mes=="",]
  
  droplevels(dfMesActual)
  droplevels(dfMesPrevio)


## funcion para limpiar nombres de columnas, 
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


# ejecuta funcion y reasigna para tener dos datos frames con los datos a comparar
# con los nombres de variables identicos y de acuerdo al Google R Style Guide

  dfMesActual<-Limpia.nombres(dfMesActual)    

  dfMesPrevio<-Limpia.nombres(dfMesPrevio)    


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


# explorando estructura de archivo
  str(dfMesActual)
  colnames(dfMesActual)


# vectores con nombres de variables de interes

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

  print(explorar.descriptores)

  #levels(dfMesActual$tipo)      # MOD si se quiere ver los niveles de otras variables



#  Fusionar archivos para contar con un solo archivo donde esten todos los datos,
# convierte todos los archivos fuente a data table

  dfTotal<-rbind.fill(dfMesActual, dfMesPrevio)
  dfTotal<-data.table(dfTotal)
  dfMesActual<-data.table(dfMesActual)
  dfMesPrevio<-data.table(dfMesPrevio)



#####
#####
####

