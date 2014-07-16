
##########
#función que calcula el ingreso, volumen y $/m3 según los cortes que se le quiera dar en un vector de columnas
#Pendiente poner columna de importe, la de volumen, y la división por separado
precioporm3<-function (sbst= 'CONCRETOS', 
                       reg= unique(dfMesActual$"region/zona"),
                       can=unique(dfMesActual$"canal"),
                       pla=unique(dfMesActual$"plaza"),
                       cortes = c('mercado_comercial','sub_canal','especialidad','grupo_de_clientes_(denominación)','producto','material'), 
                       tabla=dfMesActual)
{
  tabla<-tabla[which((tabla$"grupo"==sbst)&(tabla$"region/zona"%in% reg)&(tabla$"canal"%in% can)
                     &(tabla$"plaza"%in% pla)),]
  tabla1<-tabla[,sum(importe_concreto,na.rm=TRUE), by=cortes]
  tabla2<-tabla[,sum(volumen_concreto,na.rm=TRUE), by=cortes]
  tabla3<-tabla[,sum(importe_concreto,na.rm=TRUE)/sum(volumen_concreto,na.rm=TRUE), by=cortes]
  tabla1$volumen<-tabla2[,'V1',with=FALSE]
  tabla1$unitario<-tabla3[,'V1',with=FALSE]
  setnames(tabla1,'V1','ingreso')
  return(tabla1)
}
