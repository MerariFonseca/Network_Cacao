#require(devtools)
#library(RJSONIO)
library(RCurl)#leer datos con  RCurl
require(networkD3) # Crear D3 network graphs 
#library(httr)
library(sqldf)
#library(magrittr)
#library(readr)


######## Cargar datos, con getURL desde repositorio de GitHUb

colclase <- c(rep("character",10), rep("numeric",5))
data <- read.table(text=getURL("https://raw.githubusercontent.com/MerariFonseca/Network_Cacao/master/Datos_Cacao.txt",ssl.verifypeer = FALSE), sep= "\t", header=TRUE, colClasses = colclase)
#######


########Procesamiento de datos
#agregacion por año, pais departamento de origen

Agreg_cacao <-  sqldf("SELECT Anio,PaisOrigen,DepartamentoDestino, sum(CantidadUnidades) as Cantidad FROM data GROUP BY Anio,PaisOrigen,DepartamentoDestino")
Agreg_cacao["Cantidad_T"]<-Agreg_cacao["Cantidad"]/100000 # cantidad en 100 miles de kilos de kilogramos

#seleccionando solo años de interes
Agreg_cacao_2015 <- sqldf("SELECT PaisOrigen,DepartamentoDestino,Cantidad_T  FROM Agreg_cacao WHERE Anio = 2015 AND Cantidad_T !=0")
Agreg_cacao_2016 <- sqldf("SELECT PaisOrigen,DepartamentoDestino,Cantidad_T FROM Agreg_cacao WHERE Anio = 2016 AND Cantidad_T !=0")
Agreg_cacao_2017 <- sqldf("SELECT PaisOrigen,DepartamentoDestino,Cantidad_T FROM Agreg_cacao WHERE Anio = 2017 AND Cantidad_T !=0")


# # Creando bases de nodos para cada base
node_cacao_2015p <- sqldf("SELECT DISTINCT PaisOrigen as name, 'Pais' as group1 FROM Agreg_cacao_2015 WHERE Cantidad_T !=0")
node_cacao_2015d <- sqldf("SELECT DISTINCT DepartamentoDestino as name, 'Departamento' as group1 FROM Agreg_cacao_2015 WHERE Cantidad_T !=0")
node_cacao_2015 <- rbind(node_cacao_2015p,node_cacao_2015d)
node_cacao_2015['num']<- 1:nrow(node_cacao_2015)-1#codigo numerico para nodos

node_cacao_2016p <- sqldf("SELECT DISTINCT PaisOrigen as name, 'Pais' as group1 FROM Agreg_cacao_2016 WHERE Cantidad_T !=0")
node_cacao_2016d <- sqldf("SELECT DISTINCT DepartamentoDestino as name, 'Departamento' as group1 FROM Agreg_cacao_2016 WHERE Cantidad_T !=0")
node_cacao_2016 <- rbind(node_cacao_2016p,node_cacao_2016d)
node_cacao_2016['num']<- 1:nrow(node_cacao_2016)-1#codigo numerico para nodos


node_cacao_2017p <- sqldf("SELECT DISTINCT PaisOrigen as name, 'Pais' as group1 FROM Agreg_cacao_2017 WHERE Cantidad_T !=0")
node_cacao_2017d <- sqldf("SELECT DISTINCT DepartamentoDestino as name, 'Departamento' as group1 FROM Agreg_cacao_2017 WHERE Cantidad_T !=0")
node_cacao_2017 <- rbind(node_cacao_2017p,node_cacao_2017d)
node_cacao_2017['num']<- 1:nrow(node_cacao_2017)-1 #codigo numerico para nodos, resta 1 para que comience en cero

# # Creando links

Link_cacao_2015p <- sqldf('select Agreg_cacao_2015.*, node_cacao_2015.num as Pais from Agreg_cacao_2015 left outer join node_cacao_2015 on Agreg_cacao_2015.PaisOrigen = node_cacao_2015.name')
Link_cacao_2015<- sqldf('select Link_cacao_2015p.*, node_cacao_2015.num as Departamento from Link_cacao_2015p left outer join node_cacao_2015 on Link_cacao_2015p.DepartamentoDestino = node_cacao_2015.name')

Link_cacao_2016p <- sqldf('select Agreg_cacao_2016.*, node_cacao_2016.num as Pais from Agreg_cacao_2016 left outer join node_cacao_2016 on Agreg_cacao_2016.PaisOrigen = node_cacao_2016.name')
Link_cacao_2016<- sqldf('select Link_cacao_2016p.*, node_cacao_2016.num as Departamento from Link_cacao_2016p left outer join node_cacao_2016 on Link_cacao_2016p.DepartamentoDestino = node_cacao_2016.name')

Link_cacao_2017p <- sqldf('select Agreg_cacao_2017.*, node_cacao_2017.num as Pais from Agreg_cacao_2017 left outer join node_cacao_2017 on Agreg_cacao_2017.PaisOrigen = node_cacao_2017.name')
Link_cacao_2017<- sqldf('select Link_cacao_2017p.*, node_cacao_2017.num as Departamento from Link_cacao_2017p left outer join node_cacao_2017 on Link_cacao_2017p.DepartamentoDestino = node_cacao_2017.name')

########


#########

####Crea networks y muestra en servidor####
library(shiny) # Para crear página web 


###Esquema de color

ColourScale <- 'd3.scaleOrdinal()
            .domain(["Pais", "Departamento"])
           .range(["#456aa1", "#66CC00"]);'



#### Server ####
server <- function(input, output) {
  

  output$force_15 <- renderForceNetwork({
    forceNetwork(Links = Link_cacao_2015, Nodes = node_cacao_2015,
                 Source = "Pais", Target = "Departamento",
                 Value = "Cantidad_T", NodeID = "name",
                 Group = "group1",opacity=1, height=1120,width=700,
                 arrows=input$arrow,
                 bounded=TRUE,
                 charge =-150,
                 opacityNoHover=input$opacity,
                 colourScale = JS(ColourScale),
                 fontSize = 13,zoom =TRUE)
    
  })
  
  
  
  output$force_16 <- renderForceNetwork({
    forceNetwork(Links = Link_cacao_2016, Nodes = node_cacao_2016,
                 Source = "Pais", Target = "Departamento",
                 Value = "Cantidad_T", NodeID = "name",
                 Group = "group1",opacity=1,fontSize = 13,
                 bounded=TRUE,
                 charge =-150,
                 opacityNoHover=input$opacity,
                 arrows=input$arrow,
                 colourScale = JS(ColourScale),
                 zoom =TRUE)
    
  })
  
  
  output$force_17 <- renderForceNetwork({
    forceNetwork(Links = Link_cacao_2017, Nodes = node_cacao_2017,
                 Source = "Pais", Target = "Departamento",
                 Value = "Cantidad_T", NodeID = "name",
                 Group = "group1",opacity=1,
                 opacityNoHover=input$opacity,
                 colourScale = JS(ColourScale),
                 arrows=input$arrow,
                 bounded=TRUE,
                 charge =-150,
                 fontSize = 13,zoom =TRUE)
    
  })
  
}

#### UI ####

ui <- shinyUI(fluidPage(
  
  titlePanel("Importaciones de Cacao en Departamentos de Colombia"),

  tags$div(class="header", checked=NA,
           tags$p("El Ministerio de Agricultura y Desarrollo Rural es la entidad encargada de consolidar información sobre importaciones de los
                  productos agrícolas en Colombia. La siguiente visualización presenta los países que exportaron Cacao al país, para cada año 2015 a 2017 y los departamentos de destino."),
           tags$p("Un país con un ancho de enlace delgado hacia un departamento, exporta importa menos toneladas de cacao que un país con un enlace más ancho hacia el mismo departamento."),
           tags$p("Puede seleccionar la intensidad de las etiquetas de los nodos, deslizando la barra. Adicionalmente puede mostrar la dirección de los enlaces haciendo Click en Mostrar Flechas.")
  ),
  

  tags$div(
    tags$ul(
      tags$li("Paises", style = "color:darkblue"),
      tags$li("Departamentos", style = "color:green")
    )
  ),
  
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("opacity", "Mostrar Etiquetas", 0.6, min = 0.1,
                  max = 1, step = .1, value=0.1),
      
      checkboxInput("arrow", "Mostrar Flechas", value = FALSE, width = NULL)
      
    ),
    
  
    
    mainPanel(
      tabsetPanel(
        tabPanel("2015", forceNetworkOutput("force_15")),
        tabPanel("2016", forceNetworkOutput("force_16")),
        tabPanel("2017", forceNetworkOutput("force_17"))
      )
    )
  ),

  tags$div(class="h2", checked=NA,
           tags$p("Abstración Tamara Munzner")
  ),
  
  tags$div(class="h3", checked=NA,
           tags$p("What")
  ),
  
tags$div(
    tags$ul(
      tags$li("Fuente: Datos Abiertos, Ministerio de Agricultura y Desarrollo Rural. Cadena Productiva Cacao - Importaciones https://www.datos.gov.co/Agricultura-y-Desarrollo-Rural/Cadena-Productiva-Cacao-Importaciones/ad53-mnet "),
      tags$li("Dataset: Tabla Temporal, Estática, Periodicidad mensual 2006 abril de 2018"),
      tags$li("Atrubutos:"),
      tags$p("Año: Atributo temporal"),
      tags$p("Mes: Atributo temporal cíclico"),
      tags$p("País de Origen: Atributo categórico,  indica el nombre del país de donde proviene el Cacao importado"),
      tags$p("Departamento de destino: Atributo categórico Departamento al que ingresa el cacao"),
      tags$p("Cantidad en kilos: Atributo ordenado cuantitativo, secuencial, indica la cantidad de cacao importado en kilos"),
      tags$li("Atributos derivados para construir base de datos tipo Red (network database):"),
      tags$p("Cantidad de cacao importado por país y departamento de origen en unidades de 100 toneladas, para cada año 2015, 2016 y 2017: Atributo ordenado cuantitativo secuencial."),
      tags$p("Id para nodos(países y departamentos): Atributo ordenado, secuencial que numera los países y departamentos de 0 al número de nodos. (para uso en R)"),
      tags$p("Pais: Id del país de origen"),
      tags$p("Departamento: Id del departamento de origen")
      )
    
    ),
  
  
  tags$div(class="h3", checked=NA,
           tags$p("Why")
           
  ),


tags$div(
  tags$ul(
    tags$li("Tareas Principales:"),
    tags$p("Identificar los países origen de la importación de mayores cantidades de cacao en colombia y cuáles son sus departamentos de destino para el año 2017.[Analize-present-explore- features and paths]"),
    tags$p("Identificar el departamento a donde se encuentra centralizada la importación de cacao de diferentes países, para el año 2017.
[Analize -present-explore-cluster]"),
    tags$li("Tareas secundarias:"),
    tags$p("Comparar el comportamiento, en los años 2015 a 2017,  los principales países exportadores identificados. 
    [Analize-present-compare-features and pahs]"),
    tags$p("Comparar el comportamiento en los años 2015 a 2017 de los países que importan la menor cantidad de cacao a los departamentos de colombia.
    Analize-present-compare-features and pahs"),
    tags$p("Identificar grupos de países que exportan cacao a un mismo departamento.Analize-present-explore-clusters"),
    tags$li("Tareas de derivación:"),
    tags$p("Calcular el atributo derivado:  cantidad de cacao importado por país y departamento de origen en unidades de 100 toneladas, para cada año 2015, 2016 y 2017."),
    tags$p("Construir Id para nodos(países y departamentos), para uso de la librería networkd3 de R"),
    tags$p("Construir variables País y Departamento a partir del Id para nodos, con el objetivo de construir tablas de nodos y links para cada año"),
    tags$p("[Derive - Features]")
  )
  
  
  ),
  
  
  tags$div(class="h3", checked=NA,
           tags$p("How")
           ),



  tags$div(class="header", checked=NA,
         tags$p("Visualización Force directed Placement:
          Marcas de puntos para representar los nodos, con en canal de saturación del color para separar los grupos de nodos entre Departamento y País de Origen [Encode-Separate]. Marcas de conexión de enlaces (links) para indicar la relación entre país y departamento, con el canal de tamaño de área del enlace para expresar la magnitud en relación a la cantidad de kilogramos de cacao exportados. [Encode-Express-Value]")
   ),
   tags$div(class="h3", checked=NA,
         tags$p("Detalles")
   ),

  tags$div(class="header", checked=NA,
         tags$p("Puede consultar detalles en el repositorio de Github https://github.com/MerariFonseca/Network_Cacao")
         
         )

  
  ))

#### Run ####



shinyApp(ui = ui, server = server)
