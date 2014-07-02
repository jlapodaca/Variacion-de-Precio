library(data.table)
mayo14<-fread("mayo2014.csv")

# Variables interesantes:
  
table(mayo14$Grupo) #Mas aglomerado
table(mayo14$Tipo) #Aqui viene si es especial sustentable, convencional
table(mayo14$"Clasificación Articu") # Esta tiene muchos datos sin asignar, mejor Tipo
table(mayo14$Producto) #Mas detallado el producto menos aglomerado
head(mayo14$"Volumen Concreto")
head(mayo14$"Importe Concreto")
head(mayo14$"Descuento Automatico ( Otros Descuentos )")   #A todo le hacen descuento
tables()

melt
dcast.data.table(...)