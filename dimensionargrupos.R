

###Función para calcular # de articulos, proporción y monto de ventas de articulos
##que se encuentran en los diferentes grupos (1 a 4).
##  El tema es por producto en el contexto que se defina originalmente (si es por regi?n o por plaza)
## 1. Mismos productos en misma configuración
## 2. Mismo producto en una configuración distinta sin efecto
## 3. Mismo producto en configuración distinta con efecto
## 4. Producto en previo no encontrado en actual (en ninguna configuración) y 
## Producto en actual no encontrado en previo (en ninguna configuraci?n)

## Por lo pronto se considerará grupos 2 y 3 como misma situación.
source('InitVarPrecios.R')


dimgrupos<-function()
{

  source('subsetycortes.R')

actual<-precioporm3()
previo<-precioporm3(tabla = dfMesPrevio)

#################################################
#para el grupo 1

indice<-grep('ingreso',names(actual))-1
nombres<-names(actual)[1:indice]

setkeyv(actual,nombres)
setkeyv(previo,nombres)

prueba<-merge(actual,previo,all.x=TRUE)
setnames(prueba,names(prueba),gsub('.x','.actual',names(prueba)))
setnames(prueba,names(prueba),gsub('.y','.previo',names(prueba)))

lana10<-prueba[!is.na(prueba$ingreso.actual) & !is.na(prueba$ingreso.previo),sum(ingreso.actual,na.rm=TRUE)]
ratiolana10a<-lana10/prueba[,sum(ingreso.actual)]
cuantos10<-prueba[!is.na(prueba$ingreso.actual) & !is.na(prueba$ingreso.previo),length(unique(material))]
ratiocuantos10<-cuantos10/prueba[,length(unique(material))]
##############################
# para el grupo #4
## Articulos que están en previo pero no están en actual
materialesmes<-as.vector(unname(unlist(actual[,'material',with=FALSE])))
norep<-previo[!(previo$material %in% materialesmes),]
cuantos41<-length(unique(norep$material))
ratiocuantos41<-cuantos41/length(unique(previo$material))
lana41<-sum(norep$ingreso)
ratiolana41<-sum(norep$ingreso)/sum(previo$ingreso)

## Articulos que están en actual pero no están en previo
materialesprev<-as.vector(unname(unlist(previo[,'material',with=FALSE])))
nuevos<-actual[!(actual$material %in% materialesprev),]
cuantos40<-length(unique(nuevos$material))
ratiocuantos40<-cuantos40/length(unique(actual$material)) ##en numero de articulos unique
lana40<-sum(nuevos$ingreso)
ratiolana40<-sum(nuevos$ingreso)/sum(actual$ingreso)


################################################
##Para grupos 2 y 3
prueba$matl.en.previo<-prueba$material %in% materialesprev


lana23<-prueba[prueba$matl.en.previo & is.na(prueba$ingreso.previo),sum(ingreso.actual,na.rm=TRUE)]
ratiolana23<-lana23/prueba[,sum(ingreso.actual)]
cuantos23<-prueba[!is.na(prueba$ingreso.actual) & !is.na(prueba$ingreso.previo),length(unique(material))]
ratiocuantos10<-cuantos10/prueba[,length(unique(material))]

paragraf<-c(MismaConfig=lana10/1000000,DistintaConfig=lana23/1000000,NuevoMaterial=lana40/1000000)
print(paragraf)
print('En Millones de Pesos')

}
