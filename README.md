# Network_Cacao
Force - Directed placement, datos de importaciones de Cacao en Colombia. Realizada con la librería networkD3 de R. 

https://merarifonseca.shinyapps.io/NetworkD3-Importacion-Cacao/

<img src="https://raw.githubusercontent.com/MerariFonseca/Network_Cacao/master/Red.png" alt="simple-network-example"/></a>

# Objetivo:
Presentar los principales países que exportan cacao a Colombia y sus departamentos de destino. Esto permite hacer seguimiento a los procesos y políticas de importación de estos países en los departamentos identificados.


# Tecnologías:
* R V 3.51
* RStudio V 1.1.456
* shinyapp.io
* Libreriías de R: RCurl, networkD3, sqldf, shiny, rsconnect.

El código se ejecuta desde la consola de RStudio, una vez instaladas las librerías requeridas.

 
# Fuente
Los datos utilizados en esta visualización fueron obtenidos a través del portal Datos Abiertos de Colombia atos Abiertos, Ministerio de Agricultura y Desarrollo Rural. Cadena Productiva Cacao - Importaciones https://www.datos.gov.co/Agricultura-y-Desarrollo-Rural/Cadena-Productiva-Cacao-Importaciones/ad53-mnet  . Esta información es recolectada por el Ministerio de Agricultura y Desarrollo Rural de Colombia.

# Autores
Areli Merari Moreno Fonseca https://plus.google.com/u/0/+AreliMoreno

# Bibliografía:
* Datos Abiertos Colombia: https://www.datos.gov.co/Agricultura-y-Desarrollo-Rural/Cadena-Productiva-Cacao-Importaciones/ad53-mnet 
* D3Network : https://github.com/christophergandrud/d3Network
* https://shiny.rstudio.com/tutorial/written-tutorial/lesson2/ 
* Package networkd3: https://cran.r-project.org/web/packages/networkD3/networkD3.pdf 

# Abstracción Tamara Munzner
#  What

* Fuente: Datos Abiertos, Ministerio de Agricultura y Desarrollo Rural. Cadena Productiva Cacao - Importaciones https://www.datos.gov.co/Agricultura-y-Desarrollo-Rural/Cadena-Productiva-Cacao-Importaciones/ad53-mnet 
* Dataset: Tabla Temporal, Estática, Periodicidad mensual 2006 abril de 2018.
* Atributos:
* * Año: Atributo temporal
* * Mes: Atributo temporal cíclico
* * País de Origen: Atributo categórico,  indica el nombre del país de donde proviene el Cacao importado
* * Departamento de destino: Atributo Categpórico, departamento al que ingresa el producto
* *Cantidad en kilos: Atributo ordenado cuantitativo, secuencial, indica la cantidad de cacao importado en kilos

* Atributos derivados para construir base de datos tipo Red (network database):
* * Cantidad de cacao importado por país y departamento de origen en unidades de 100 toneladas, para cada año 2015, 2016 y 2017: Atributo ordenado cuantitativo secuencial.
* * Id para nodos(países y departamentos): Atributo ordenado, secuencial que numera los países y departamentos de 0 al número de nodos. (para uso en R).
* * Pais: Id del país de origen
* * Departamento: Id del departamento de origen

#  Why 
* Tareas Principales:
Identificar los países origen de la importación de mayores cantidades de cacao en colombia y cuáles son sus departamentos de destino para el año 2017. [Analize-present-explore- features and paths]

Identificar el departamento a donde se encuentra centralizada la importación de cacao de diferentes países, para el año 2017.
[Analize -present-explore-cluster]


* Tareas secundarias:
Comparar el comportamiento, en los años 2015 a 2017,  los principales países exportadores identificados. 
[Analize-present-compare-features and pahs]

Comparar el comportamiento en los años 2015 a 2017 de los países que importan la menor cantidad de cacao a los departamentos de colombia. [Analize-present-compare-features and pahs]

Identificar grupos de países que exportan cacao a un mismo departamento.[Analize-present-explore-clusters].

* Tareas de derivación:
Calcular el atributo derivado:  cantidad de cacao importado por país y departamento de origen en unidades de 100 toneladas, para cada año 2015, 2016 y 2017. 

Construir Id para nodos(países y departamentos), para uso de la librería networkd3 de R. 

Construir variables País y Departamento a partir del Id para nodos, con el objetivo de construir tablas de nodos y links para cada año.
[Derive - Features]


#  How

Visualización Force directed Placement:
Marcas de puntos para representar los nodos, con en canal de saturación del color para separar los grupos de nodos entre Departamento y País de Origen [Encode-Separate]. Marcas de conexión de enlaces (links) para indicar la relación entre país y departamento, con el canal de tamaño de área del enlace para expresar la magnitud en relación a la cantidad de kilogramos de cacao exportados. [Encode-Express-Value].

Interacciones:  Se grafica la red para cada año 2015 a 2017 con opción de selección de cada año. Se adicionan las etiquetas con los nombres de los nodos, con opción de opacarlas, y la opción de presentar la dirección del enlace con flechas. 
Adicionalmente si se selecciona un punto los demás se opacan, par mostrar el de interés. [Manipulate-Select and Reduce-Filter] y realizando doble click sobre la imagen se realiza un zoom.

