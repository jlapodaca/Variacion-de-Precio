## Carga librerias que probablemente se usen

library(ggplot2)
library(memisc)
library(reshape2)
library(plyr)
library(data.table)
library(qdap)
library(gridBase) 


## carga datos, asume que archivos estan en "working directory"/Data  y que se ha
## usado Set Working Directory To source file location
path.dir <- 'Data'

## nombres de archivos a pasar al analisis
f.MesActual<-file.path(path.dir,"BO Mayo 14.csv", fsep=.Platform$file.sep)    # MOD
f.MesPrevio<-file.path(path.dir,"BO Abril 14.csv", fsep=.Platform$file.sep)  # MOD

# NOTA: Archivos extraidos del BO por Desarrollo Comercial

## lectura archivos
dfMesActual<-fread(f.MesActual)
dfMesPrevio<-fread(f.MesPrevio)

# se agregó instrucción porque XL trae alunos renglones blancos de mes
dfMesPrevio<-dfMesPrevio[!dfMesPrevio$Mes=="",]
dfMesActual<-dfMesActual[!dfMesActual$Mes=="", ]   ## MOD dependiendo del mes

# droplevels(dfMesActual)
# droplevels(dfMesPrevio)

## funcion para limpiar nombres de columnas, eliminando caracteres extras como "Destin..mcÃ?a..V.Com.."

Limpia.nombres<-function(df){
  
  veccolumnas<-colnames(df)
  
  veccolumnas<-gsub('Destin.mcÃ?a..V.Com..', '', veccolumnas)
  veccolumnas<-gsub('Destin\\. mcía\\.\\(V Com\\) ', '', veccolumnas)
  veccolumnas<-gsub('..DenominaciÃ³n.media.', '', veccolumnas)
  veccolumnas<-gsub(' \\(Denominación media\\)', '', veccolumnas)
  veccolumnas<-gsub('Destin.fac..V..Com..', '', veccolumnas)
  veccolumnas<-gsub('Destin fac \\(V\\. Com\\) ', '', veccolumnas)
  veccolumnas<-gsub("\\.\\.", ".", veccolumnas)
  veccolumnas<-gsub("\\.\\.", ".", veccolumnas)  # para los nombres con tres puntos
  veccolumnas<-gsub("Ã³n", "on", veccolumnas)
  veccolumnas<-gsub("\\.$", "", veccolumnas)
  # Se sustituyen espacios 
  veccolumnas<-gsub(" ","_",veccolumnas)
  
  veccolumnas<-tolower(veccolumnas)   # cambia a minusculas (Google R Style Guide para variables)
  
  colnames(df)<-veccolumnas
  
  return (df)
}

# ejecuta funcion y reasigna para tener dos datos frames con los datos a comparar
# con los nombres de variables identicos y de acuerdo al Google R Style Guide

dfMesActual<-Limpia.nombres(dfMesActual)    

dfMesPrevio<-Limpia.nombres(dfMesPrevio)    


# vectores con nombres de variables de interes

descriptores<-c("region/zona", "gerencia","area.comercial", "mercado.comercial",
                "centro.clave", "centro", "holding", "destinatario.de.merc",  
                "solicitante","frente", "vendedor/admys", "vendedor/promotor",
                "canal","sub.canal", "especialidad", "región (denominación)", 
                "ciudad", "micromercado", "clasificación articu", "producto",
                "gpo de materiales (nav)", "tipo.pe", "grupo", "tipo",
                "material", "identificador.combo","premio.pe",
                "grupo de clientes (denominación)","cliente.inst", "plaza",
                "zona") 

col.numericas<-c("importe.de.venta","volumen.bombeo", "volumen.colocacion",
                 "volumen.concreto", "volumen aditivos, adiciones y fibras",  
                 "volumen.cargos.adicionales", "importe.bombeo",
                 "importe colocación", "importe.concreto",
                 "importe.cargos.adicionales","importe.base", 
                 "descuento automatico ( otros descuentos )")

##Se agrega para sustituir puntos y espacios para manejo en data.table:
descriptores<-gsub("\\.","_",descriptores)
col.numericas<-gsub("\\.","_",col.numericas)
descriptores<-gsub(" ","_",descriptores)
col.numericas<-gsub(" ","_",col.numericas)

#Se cambia a factores las columnas de descriptores, porque data.table las tiene como character

dfMesActual<-dfMesActual[,(descriptores):=lapply(.SD, as.factor),.SDcols=descriptores]
dfMesPrevio<-dfMesPrevio[,(descriptores):=lapply(.SD, as.factor),.SDcols=descriptores]



# Variables interesantes, exploración:
  
# 
# Revisar esta sección porque no funciona con data.table
# explorar.descriptores<-lapply(descriptores, function(column){
#   aux<-NULL
#   aux$variable<-column
#   aux$cant.factores<-nlevels(dfMesActual$column)
#   aux$factores<-levels(dfMesActual$column)[2:6]
#   #aux$tabla<-table(dfMesActual[ , column])     # MOD para agregar tabla de frecuencia
#   return(aux)
# })
# 
# print(explorar.descriptores)


table(dfMesActual$grupo) #Mas aglomerado
table(dfMesActual$tipo) #Aqui viene si es especial sustentable, convencional
table(dfMesActual$"clasificación_articu") # Esta tiene muchos datos sin asignar, mejor Tipo
table(dfMesActual$producto) #Mas detallado el producto menos aglomerado
head(dfMesActual$"volumen_concreto")
head(dfMesActual$"importe_concreto")
head(dfMesActual$"descuento_automatico_(_otros_descuentos_)")   #A todo le hacen descuento
tables()


colnames(dfMesActual)<-gsub(" ","_",colnames(dfMesActual))



##########
#función que calcula el $/m3 según los cortes que se le quiera dar en un vector de columnas
precioporm3<-function (cortes, tabla=dfMesActual)
{
  tabla[,sum(importe_concreto,na.rm=TRUE)/sum(volumen_concreto,na.rm=TRUE), by=cortes]
}





# melt
# dcast.data.table(...)