## TRABAJO FINAL DIGITAL I
BYRON ADOLFO ERAZO CHALUPUD

JHON EDISON BOHORQUEZ MARTINEZ

## INTRODUCCIÓN
En esta entrega se recoge todo el proceso seguido en el diseño e implementación de una cámara digital el cual se inicia con entrega 1 uno llamado work01 en donde se dio respuesta a interrogantes para la implementación la memoria RAM que utilizara la camara para el procesamiento de la imagen. En la segunda entrega work realizó el diseño e implementación de la captura de datos de la cámara "captura_datos_downsampler" según la configuración 320x240 16b pixel. Además de esto se realiza la adaptación del bloque PLL según la tarjeta de desarrollo Nexys 4 la cual cuenta con un dispositivo FPGA de la nueva familia de XILINX ARTIX  XC7A100T-1CSG324C. Para la tercera entrega work03 se realiza el diseño del cam_reed.v que permite la captura de datos por medio del uso de un botón externo.
## DESARROLLO DE MODULOS DE LA CAMARA

**1.	Contador de Pixel y Href WP02**

En este trabajo se realiza el diseño e implementación de la captura de datos de la cámara "captura_datos_downsampler" según la configuración 320x240 16b pixel. Además de esto se realiza la adaptación del bloque PLL, teniendo en cuenta que la señal de reloj viene de la FPGA Spartan 6 y la seleccionada por el grupo para la implementación del proyecto corresponde a la Artix 7, así como la adaptación de los datos para que se almacenen en la memoria, teniendo en cuenta que el formato debe ser RGB332. Una vez diseñado e implementado el bloque "captura_datos_dawnsampler", se procede a instanciarlo en el test_cam.v para probar la funcionalidad del diseño.

**Instanciación de modulos.** Lo primero que se realiza es la instanciación de los nuevos módulos que componen el proyecto, entre estos se encuentra el modulo **clk_25_nexys4.v** 
![DIAGRAMA](./figs/INSRELOJ.png)

Se instanciaron los módulos de entrada y salidas del cam_read.v, partiendo del paquete del repositorio.
![DIAGRAMA](./figs/INSCAM.png)

en donde se tiene como entradas de la camara (.pclk,rst, vsync, href, px_data, b_captura) y como salidas del modulo **tes_cam.v**  (mem_px_addr, mem_px_data, px_wr).

Instanciación salida VGA.
![DIAGRAMA](./figs/INSVGA.png)

Mediante la siguiente lógica se obtuvo DP_RAM_addr_out, teniendo en cuenta la posición del pixel en pantalla, en el primer condicional se calcula la última posición y en el segundo se da la posición de la dirección de salida.

![DIAGRAMA](./figs/LOGPIXPAN.png)

Para pasar de formato RGB332 a RGB 444 para ser usado por la pantalla VGA. Para hacer dicha conversión se añadieron ceros en las cifras menos significativas faltantes, es decir, para el rojo y el verde sólo se agregó un cero para completar los 4 y en el azul dos ceros.
![DIAGRAMA](./figs/convRGB332A444.png)


**Dimensionamiento de espacio de memoria.**
Se determinar el tamaño máximo del buffer de memoria RAM que se puede crear con la FPGA, en este caso la Artix-7  de la tarjeta Nexys 4, para ello se revisó el datasheet.
Para una imagen de 320 x 240 píxeles. Se decide recortar el tamaño de la imagen para que no exceda la capacidad de la FPGA, se escala por un factor de 2, por lo que la nueva imagen es ahora 1/4 del tamaño con respecto al tamaño anterior. Por lo que el número de posiciones o píxeles totales es de 320 x 240 = 76.800. 



