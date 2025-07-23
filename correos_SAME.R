#-------------------------------------------------------------
#          Código para envío de minutas
#               por correo a SAMES
#-------------------------------------------------------------

#Aquí va la ruta de tu carpeta donde tienes todo lo necesario para correr el código
setwd("~/Correo de minutas")
#cargar las librerías necesarias
library(gmailr)
library(here)
library(tidyverse)
library(foreach)

#debes guardar en un data tu archivo donde vienen los datos de tus destinatarios
SAME_minutas <- openxlsx::read.xlsx("SAME_minutas.xlsx")

## CONFIGURACIÓN DE INICIO
gm_auth_configure(path="client_secret_507127937106-8mljmm2ui6cdkto1nontl6vfnljq9v07.apps.googleusercontent.com.json") #aquí va tu API que descargas de google
gm_auth()
gm_threads()

#https://drive.google.com/file/d/1o_mZ5YykMBYa_u0_76BMYsnG2s_bB-ix/view?usp=drive_link
image_url <- "https://drive.google.com/uc?export=view&id=1o_mZ5YykMBYa_u0_76BMYsnG2s_bB-ix"
foreach (i=1:nrow(SAME_minutas)) %do% {
  gm_mime()|>
    gm_to(sprintf("%s", SAME_minutas[i,6]))|>
    gm_from("krystal.ocampo@prepaenlinea.sep.gob.mx") |>
    gm_subject("Entrega de archivos modulares y apoyo focalizado") |>
    #gm_cc(c("jimena.delacruzg@prepaenlinea.sep.gob.mx", "miriam.mayoral@prepaenlinea.sep.gob.mx")) |>  # Agregar el destinatario en copia (CC)
    gm_cc(c("jimena.delacruzg@prepaenlinea.sep.gob.mx")) |>  # Agregar el destinatario en copia (CC)
    gm_html_body(sprintf(
      
      "<p>Estimado(a) Supervisor(a) %s,</p>

<p>Es un gusto saludarlo(a), el motivo del presente correo es para notificarle que ya se encuentran disponibles en el sitio de la DASI los archivos <b>“Apoyo a mi seguimiento modular”</b> y <b>“Apoyo focalizado”</b>.</p>

<p>Comparto el enlace para que pueda proceder a la firma de su minuta con folio %s:<p>
      <table border='1' style='border-collapse: collapse'>
        <thead>
          <tr>
            <th style='padding: 8px; text-align: left;'>Generación</th>
            <th style='padding: 8px; text-align: left;'>Nombre del SAME</th>
            <th style='padding: 8px; text-align: left;'>Enlace de minuta</th>
            <th style='padding: 8px; text-align: left;'>Responsable</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td style='padding: 8px;'>%s</td>
            <td style='padding: 8px;'>%s</td>
            <td style='padding: 8px;'>%s</td>
            <td style='padding: 8px;'>%s</td>
          </tr>
        </tbody>
      </table>
<p>    
<p>Le agradeceremos la firma de su minuta lo más pronto posible, como se indica en la sección “Orden del día” y los “Acuerdos” de la misma, como parte del proceso de recepción de los reportes. <b>También le adjuntamos material adicional para la revisión de su minuta y una guía rápida de cómo funciona el llenado de las intervenciones para facilitar su registro</b>.</p>
<p>Así mismo, le comentamos que la fecha límite para el registro de sus intervenciones es el viernes de la semana de cierre de su asignación correspondiente.</p>
<p>Siéntase libre de consultar en el transcurso del módulo los registros de su minuta, ya sea para la elaboración de sus retroalimentaciones u otras actividades que desee.</p>
      
      <br><br>Cualquier situación quedamos pendientes para poder apoyarle.<br>Saludos cordiales.<p><b>Equipo de reportes modulares de la DASI<p></b>
      <p><img src='%s' alt='Imagen PNG' style='width: 50%%;'></p>", 
      #SAME_minutas[i,3], SAME_minutas[i,1]))|> 
      SAME_minutas[i,3], SAME_minutas[i,1], SAME_minutas[i,2], SAME_minutas[i,3], SAME_minutas[i,4], SAME_minutas[i,5],image_url))|>        
    gm_attach_file(SAME_minutas[i,7])|>
    gm_attach_file(SAME_minutas[i,8])|>
    #gm_create_draft()|>
    gm_send_message()
}
