
##################################
###Conceptualizaci�n de la pregunta y el problema
## Estas comparando dos n�meros, con bases diferentes. lana/m3 vendido en el previo, vs lana/m3 vendido en actual
## El tema es explicar porque vario de un n�mero a otro.
## El tema es por producto en el contexto que se defina originalmente (si es por regi�n o por plaza)
## 1. Mismos productos en misma configuraci�n
## 2. Mismo producto en una configuraci�n distinta sin efecto
## 3. Mismo producto en configuraci�n distinta con efecto
## 4. Producto en previo no encontrado en actual (en ninguna configuraci�n)
## 5. Producto en actual no encontrado en previo (en ninguna configuraci�n)
## Cada n�mero es un grupo de productos
## 
## para el 1., hay un efecto del volumen aunque sean los mismos productos y configuraciones, los volumenes
## de cada producto fueron distintos. Suponiendo el escenario siguiente y que no se vendi� nada mas:
## Producto A 10m3 a 100 pesos/m3 (1000 pesos de ingreso); 100m3 a 120 pesos/m3 (12,000 pesos de ingreso)
## Producto B 100m3 a 200 pesos (20,000 pesos de ingreso); 10m3 a 180 pesos (1800 pesos de ingreso)
## Previo de 190/m3 vs actual de 125/m3
## Cu�nto de la baja de 190 a 125 es por precio y cuanto es por mezcla?
## Si volumen hubieran sido constantes, el efecto por precio seria: 10m3 a $120/m3 (1,200 pesos ingreso)
##                                                                  100m3 a $180/m3 (18,000 pesos ingreso) 
## Por precio, hubiera bajado solo de 190/m3 a 174/m3, el resto de la baja (de 174 a 125 es mezcla)
## Por lo tanto el volumen, los productos, y las configuraciones son la mezcla.
## Si el precio hubiera sido constante, el efecto por volumen ser�a: 100m3 a $100/m3 (10,000 pesos ingreso)
#                                                                      10m3 a $200/m3 (2000 pesos ingreso)
## por volumen hubiera bajado a de 190/m3 a 109/m3, y el precio hubiera tenido un efecto positivo 
## para llevarlo a 125/m3
## Producto A +200 por precio, +10800 por mezcla (se fija volumen se multiplican ingresos y se restan para delta)
## Producto B -2000 por precio, -16200 por mezcla
## Si solo hubiera variado el precio hubiera bajado de 190 a 174, si solo hubiera variado el volumen
## hubiera bajado de 190 a 109. Variaron los dos, y qued� en 125
## No es lineal el tema, por eso no se puede descomponer en sumas?
## Creo que la mejor opci�n es no fijar el volumen porque no es controlable por el comercial (en todo caso
## no es gesti�n de precio o productividad de precio sino de volumen, en mezcla va demanda m�s productividad
## de volumen, no de precio)
## Entonces ser�a
## Producto A +2000 por precio, +9000 por mezcla (se fija precio se multiplican ingresos y se restan para delta)
## Producto B -200 por precio, -18000 por mezcla
## Luego ya se suman los efectos de precio, y se dividen por m3 actuales, y luego se suman los efectos
## De mezcla, y se dividen por m3 actuales, y ya la suma de los dos te da el delta, es decir
## tienes un delta descompuesto.


## Carga librerias que probablemente se usen

library(ggplot2)
library(memisc)
library(reshape2)
library(plyr)
library(data.table)
library(qdap)
library(gridBase) 


source("subsetycortes.R")



