
function menuPrincipal(){
	echo "presiona 1 para opciones de usuario"
	echo "presiona 2 para opciones de departamento"
	echo "presiona 3 para opciones de gestion de log"
	echo "persiona 4 para opciones de gestion de actividades"
	echo "presiona 5 para opciones de gestion del sistema"
	echo "escriba exit para salir"

	read -p "Seleccione una opcion: " opcion

	case $opcion in
		1)
			clear
			menuUsuario
			;;
		2)
			clear
			menuDepartamento
			;;
		3)
			clear
			menuLog
			;;
		4)
			clear
			menuActividades
			;;
		5)
			clear 
			menuSistema
			;;
		exit)
		  detenerMonitoreoMemoria
			salir
			;;
		*)
			echo "opcion no valida"
			;;
	esac
}

#Funciones de las opciones de usuario
function menuUsuario(){
	echo "Bienvenido al menu del usuario"
	opcionUser=""
	while [ "$opcionUser" != "atras" ]; do
		echo "Presione 1 para crear usuario"
		echo "presione 2 para deshabilitar un usuario"
		echo "Presione 3 para modificar un usuario"
		echo "Presione 4 para listar usuarios"
		echo "escriba atras para volver al menu principal"
		read -p "Seleccione una opcion: " opcionUser
		case $opcionUser in
			1)
				crearUsuario
				;;
			2)
				deshabilitarUsuario
				;;
			3)
        clear
				menuModificarUsuario
				;;
			4)
				listarUsuarios
				;;
			exit)
				salir
				;;
			atras)
				clear
				echo "Saliendo del menu de usuario"
				;;
			*)
				echo "opcion no valida"
				;;
		esac
		echo
	done
}

function menuModificarUsuario(){
  echo "Bienvenido al menu de modificar usuario"
	opcionUser=""
	while [ "$opcionUser" != "atras" ]; do
		echo "presione 1 para cambiar el nombre de usuario"
		echo "escriba atras para volver al menu principal"
		read -p "Seleccione una opcion: " opcionUser
		case $opcionUser in
			1)
				cambiarNombreUsuario
				;;
			exit)
				salir
				;;
			atras)
				clear
				echo "Saliendo del menu de modificar usuario"
				;;
			*)
				echo "opcion no valida"
				;;
		esac
		echo
	done
}

#funciona
function crearUsuario(){
  echo "Creando usuario"
  read -p "Ingrese el nombre del usuario: " nombre
  # Verificar si el usuario ya existe
    if grep -q "^$nombre:" "$USERS_DB"; then
        echo "El usuario ya existe."
    else
        # Crear el usuario y almacenar en el archivo
        useradd "$nombre"
        echo "$nombre:activo:" >> "$USERS_DB"
        echo "Usuario creado con éxito."
		logCreacionModificacion "Creacion" "usuario" "Se creo el usuario $nombre"
		echo "$nombre:activo:" >> "$USERS_DB"
    fi
}
#funciona
function deshabilitarUsuario(){
  echo "Deshabilitando usuario"
  read -p "Ingrese el nombre del usuario: " nombre
  # Verificar si el usuario existe
    if grep -q "^$nombre:" "$USERS_DB"; then
        # Deshabilitar el usuario y almacenar en el archivo
        deluser --remove-home "$nombre"
        # Deshabilitar el usuario cambiando su estado a inactivo"
        awk -v nombre="$nombre" 'BEGIN {FS=OFS=":"} {if ($1 == nombre && $2 == "activo") $2 = "inactivo"} 1' "$USERS_DB" > tmpfile && mv tmpfile "$USERS_DB"
        echo "Usuario deshabilitado con éxito."
	logCreacionModificacion "Modificacion" "usuario" "Se deshabilito el usuario $nombre"
    else
        echo "El usuario no existe."
    fi
}

#funciona
function listarUsuarios(){
	echo
	echo "Listando usuarios"
	#imprimir si el usuario esta activo 
	awk -F: '$2 == "activo" {print $1}' ./db/usuarios.txt
	
}
#funciona
function escogerUsuario(){
	echo "escoga un usuario"
	listarUsuarios
	read user
	#verificar si el usuario existe
	if grep -q "^$user:" "$USERS_DB"; then
		echo "Se escogio el usuario: $user"
	else
		echo "El usuario $user no existe"
		echo "Escoga otro usuario"
		escogerUsuario
	fi
}

function cambiarNombreUsuario(){
  escogerUsuario
  read -p "Ingrese el nuevo nombre del usuario: " nombre
  # Verificar si el usuario ya existe
    if grep -q "^$nombre:" "$USERS_DB"; then
        echo "El usuario ya existe."
	logCreacionModificacon "Modificacion" "usuario" "hubo un error al intentar modificar el nombre de $user"
    else
        # Cambiar el nombre del usuario y almacenar en el archivo
        usermod -l "$nombre" "$user"
        # Cambiar el nombre del usuario en el archivo
        awk -v nombre="$nombre" 'BEGIN {FS=OFS=":"} {if ($1 == "'$user'") $1 = nombre} 1' "$USERS_DB" > tmpfile && mv tmpfile "$USERS_DB"
        echo "Usuario modificado con éxito."
	logCreacionModificacion "Modificacion" "usuario" "Se cambio el nombre de $user a $nombre"
    fi
}

#metodo que retorna true si un usuario ya esta en un departamento
function usuarioEnDepartamento(){
	logAccionesSeguridad "Verificacion de usuario en departamento" "Usuario: $user"
	awk -F: '$1 == "'$user'" && $3 != "" {print "true"; exit}' "$USERS_DB"
}

#Fin de funciones del usuario

#Funciones de departamento
function menuDepartamento(){
	echo "Bienvenido al menu de departamentos"
	#opcion de departamentos
	opcionDepa=""
	while [ "$opcionDepa" != "atras" ]; do
		echo "Presione 1 para crear departamento"
		echo "Presione 2 para deshabilitar un departamento"
		echo "Presione 3 para modificar un departamento"
		echo "Presione 4 para Menu de asignacion de usuarios"
		echo "Escriba atras para volver al menu principal"
		read -p "Seleccione una opcion: " opcionDepa
		case $opcionDepa in
			1)
				crearDepartamento
				;;
			2)
				deshabilitarDepartamento
				;;
			3)
        clear
				menuModificarDepartamento
				;;
			4)
				#TODO: menu de asignacion de usuarios
				echo "Menu de asignacion de usuarios"
				menuAsignacion
				;;
			exit)
				salir
				;;
			atras)
				clear
				echo "saliendo del menu de departamentos"
				;;
			*)
				echo "opcion no valida"
				;;
		esac
		echo
	done
}

function menuModificarDepartamento(){
  echo "Bienvenido al menu de modificar departamento"
	opcionDepto=""
	while [ "$opcionDepto" != "atras" ]; do
		echo "presione 1 para cambiar el nombre del departamento"
		echo "escriba atras para volver al menu principal"
		read -p "Seleccione una opcion: " opcionDepto
		case $opcionDepto in
			1)
				cambiarNombreDepartamento
				;;
			exit)
				salir
				;;
			atras)
				clear
				echo "Saliendo del menu de modificar departamento"
				;;
			*)
				echo "opcion no valida"
				;;
		esac
		echo
	done
}

#funciona
function crearDepartamento(){
  echo "Creando departamento"
  read -p "Ingrese el nombre del departamento: " nombre
  # Verificar si el departamento ya existe
  if grep -q "^$nombre:" "$DEPTO_DB"; then
    echo "El departamento ya existe."
  else
    # Crear el departamento y almacenar en el archivo
    groupadd "$nombre"
    echo "$nombre:activo" >> "$DEPTO_DB"
    echo "Departamento creado con éxito."
    logCreacionModificacion "Creacion" "departamento" "Se creo el departamento $nombre"
  fi
}
#funciona
function deshabilitarDepartamento(){
  echo "Deshabilitando departamento"
  read -p "Ingrese el nombre del departamento: " nombre
  # Verificar si el departamento existe
  if grep -q "^$nombre:" "$DEPTO_DB"; then
    # Deshabilitar el departamento y almacenar en el archivo
    groupdel "$nombre"
    # Deshabilitar el departamento cambiando su estado a inactivo"
    awk -v nombre="$nombre" 'BEGIN {FS=OFS=":"} {if ($1 == nombre && $2 == "activo") $2 = "inactivo"} 1' "$DEPTO_DB" > tmpfile && mv tmpfile "$DEPTO_DB"
	# Deshabilitar el departamento de los usuarios
	awk -v nombre="$nombre" 'BEGIN {FS=OFS=":"} {if ($3 == nombre) $3 = ""} 1' "$USERS_DB" > tmpfile && mv tmpfile "$USERS_DB"
    echo "Departamento deshabilitado con éxito."
    logCreacionModificacion "Modificacion" "departamento" "Se deshabilito el departamento $nombre"
  else
    echo "El departamento no existe."
  fi
}

function cambiarNombreDepartamento(){
  elegirDepartamento
  read -p "Ingrese el nuevo nombre del departamento: " nombre
  # Verificar si el departamento ya existe
  if grep -q "^$nombre:" "$DEPTO_DB"; then
    echo "El departamento ya existe elija otro nombre."
    logCreacionModificacion "Modificacion" "departamento" "Se intento cambiar el nombre del departamento $depa"
  else
    # Cambiar el nombre del departamento y almacenar en el archivo
    groupmod -n "$nombre" "$depa"
    # Cambiar el nombre del departamento en el archivo
    awk -v nombre="$nombre" 'BEGIN {FS=OFS=":"} {if ($1 == "'$depa'") $1 = nombre} 1' "$DEPTO_DB" > tmpfile && mv tmpfile "$DEPTO_DB"
    # Cambiar el nombre del departamento de los usuarios
    awk -v nombre="$nombre" 'BEGIN {FS=OFS=":"} {if ($3 == "'$depa'") $3 = nombre} 1' "$USERS_DB" > tmpfile && mv tmpfile "$USERS_DB"
    
    echo "Departamento modificado con éxito."
    logCreacionModificacion "Modificacion" "departamento" "Se cambio el nombre del departamento de $depa a $nombre"
  fi
}

function menuAsignacion(){
	echo "Bienvenido al menu de asignacion de usuarios"
	opcionAsig=""
	while [ "$opcionAsig" != "atras" ]; do
		echo "Presione 1 para asignar usuario a departamento"
		echo "Presione 2 para desasignar usuario a departamento"
		echo "Presione 3 para listar usuarios"
		echo "Presione 4 para listar departamentos"
		echo "Presione 5 para listar usuarios de un departamento"
		echo "Escriba atras para volver al menu de departamentos"
		read -p "Seleccione una opcion: " opcionAsig
		case $opcionAsig in
			1)
				AsignarUsuario
				;;
			2)
				desasignarUsuarioDeDepartamento
				echo
				;;
			3)
				listarUsuarios
				echo
				;;
			4)
				listarDepartamentos
				echo
				;;
			5)
				listarUsuarioDelDepartamento
				;;
			exit)
				salir
				;;
			atras)
				clear
				echo "saliendo del menu de asignacion de usuarios"
				;;
			*)
				echo "opcion no valida"
				;;
		esac
		echo
	done
}
#funciona
function listarDepartamentos(){
	echo
	echo "Listando departamentos"
	#imprimir si el usuario esta activo 
	awk -F: '$2 == "activo" {print $1}' ./db/departamentos.txt
	
}
#funciona
function elegirDepartamento(){
	#TODO mirar caso donde no existen departamentos
	echo "escoga un departamento"
	listarDepartamentos
	read depa
	#verificar si el usuario existe
	if grep -q "^$depa:" "$DEPTO_DB"; then
		echo "Se escogio el departamento: $depa"
	else
		echo "El departamento $depa no existe"
		echo "Escoga otro departamento"
		elegirDepartamento
	fi
}
#funciona
function AsignarUsuario(){
	echo "asignar usuario a departamento"
	escogerUsuario
	#verificar si el usuario ya esta en un departamento
	if [ "$(usuarioEnDepartamento)" == "true" ]; then
		echo "El usuario $user ya esta en un departamento"
		echo "Escoga otro usuario"
		AsignarUsuario
	else
		elegirDepartamento
		usermod -a -G $depa $user
		echo "usuario $user asignado al departamento $depa"
		#añadir :depatamento al archivo de usuarios
		awk -v nombre="$user" -v departamento="$depa" 'BEGIN {FS=OFS=":"} {if ($1 == nombre) $3 = departamento} 1' "$USERS_DB" > tmpfile && mv tmpfile "$USERS_DB"
		logCreacionModificacion "Modificacion" "usuario" "Se añade usuario $user a departamento $depa"
	fi
	
}
#funciona
function listarUsuarioDelDepartamentoParaEscogerUsuario(){
	echo "listando usuarios del departamento $depa"
	usuariosEnDepo=$(awk -F: '$3 == "'$depa'" {print $1}' ./db/usuarios.txt)
	echo "$usuariosEnDepo"
	#verificar si hay usuarios en el departamento
	if [ -z "$usuariosEnDepo" ]; then
		echo "no hay usuarios en el departamento $depa"
	else
		escogerUsuarioDelDepartamento
	fi
	
}

function listarUsuarioDelDepartamento(){
	elegirDepartamento
	echo "listando usuarios del departamento $depa"
	usuariosEnDepo=$(awk -F: '$3 == "'$depa'" {print $1}' ./db/usuarios.txt)
	#verificar si hay usuarios en el departamento
	if [ -z "$usuariosEnDepo" ]; then
		echo "no hay usuarios en el departamento $depa"
	else
		echo "$usuariosEnDepo"
	fi
	
}

function escogerUsuarioDelDepartamento(){
	echo "escoja un usuario del departamento $depa"
	read user
	#verificar si el usuario existe
	if echo "$usuariosEnDepo" | grep -q "^$user"; then
		echo "Se escogio el usuario: $user"
		#desasignar usuario del departamento
		gpasswd -d $user $depa
		awk -v nombre="$user" -v departamento="$depa" 'BEGIN {FS=OFS=":"} {if ($1 == nombre) $3 = ""} 1' "$USERS_DB" > tmpfile && mv tmpfile "$USERS_DB"
	else
		echo "El usuario $user no existe en este departamento"
		echo "Escoga otro usuario"
		escogerUsuarioDelDepartamento
	fi
}

function desasignarUsuarioDeDepartamento(){
	echo "desasignar usuario de departamento"
	#elegir un departamento
	elegirDepartamento
	#listar usuarios del departamento
	listarUsuarioDelDepartamentoParaEscogerUsuario
	#escoger un usuario del departamento
	
}


#fin de funciones del departamento

#Funciones de log
function logInicioSesion(){
        
        echo "$(date): Inicio de sesion - Usuario: $1 - Estado: $2 - Detalle: $3" >> inicio_sesion.log
}
 
function logCreacionModificacion(){
        echo "$(date): $1 de $2 - Detalles: $3" >> creacion_modificacion.log
}
 
function logAccionesSeguridad(){
        echo "$(date): Accion de seguridad - Evento: $1 - Detalles: $2" >> acciones_seguridad.log
}

function menuInfoLogs() {
	opcionInfoLog=""
	while [ "$opcionInfoLog" != "atras" ]; do
		echo "Presiona 1 para ver todos los logs de Inicio de sesion"
       	 	echo "Presiona 2 para ver todos los logs de creacion/modificacion"
        	echo "Presiona 3 para ver todos los logs de seguridad"
	        echo "Escriba atras para volver al menu anterior"
		read -p "Elige tu opcion " opcionInfoLog
		case $opcionInfoLog in
			1)
				clear
				echo "------ LOGS DE INICIO DE SESION ------"	
				cat inicio_sesion.log
				echo "------ FIN LOGS DE INICIO DE SESION ------"
				;;
			2)
				clear
				echo "------ LOGS DE CREACION/MODIFICACION ------"	
				cat creacion_modificacion.log
				echo "------ FIN LOGS DE CREACION/MODIFICACION ------"
				;;
			3)
				clear
				echo "------ LOGS DE SEGURIDAD ------"	
				cat acciones_seguridad.log
				echo "------ FIN LOGS SEGURIDAD ------"
				;;

			exit)
				clear
				echo "Saliendo del programa"
				salir
				;;
			atras)
				clear
				echo "Regresando a menu anterior"
				;;
			*)
				clear
				echo "Esta opcion no esta disponible"
				;;
		esac
		echo
	done 
}

function estadisticasLogs() {
	echo "--- ESTADISTICAS LOGS INICIO SESION ---"
	echo "Numero de inicios de sesion: $(wc -l inicio_sesion.log)"
	echo "--- FIN ESTADISTICAS LOGS INICIO SESION ---"

	echo "--- ESTADISTICAS LOGS DE CREACION/MODIFICACION ---"
	echo "Numero total de eventos: $(wc -l creacion_modificacion.log)"
	echo "Numero de eventos de creacion: $(grep -c "Creacion" creacion_modificacion.log)"
	echo "Numero de eventos de modificacion: $(grep -c "Modificacion" creacion_modificacion.log)"
	echo "--- FIN ESTADISTICAS LOGS DE CREACION/MODIFICACION ---"

	echo "--- ESTADISTICAS LOGS DE SEGURIDAD ---"
	echo "Numero de logs de seguridad $(wc -l acciones_seguridad.log)"
	echo "--- FIN ESTADISTICAS LOGS DE SEGURIDAD ---"
}


function menuLog(){
	echo "bienvenido al menu de log"
	opcionLog=""

	while [ "$opcionLog" != "atras" ]; do
		#TODO: agregar opciones de log 
		echo "presione 1 para ver logs de inicio de sesion por usuario"
		echo "presione 2 para ver log de actividad de usuario"
		echo "presione 3 para ver logs de seguridad por actividad"
		echo "presione 4 para ver un log por completo"
		echo "presione 5 para ver estadisticas de logs"
		echo "Esciba atras para volver al menu principal"
		read -p "Seleccione una opcion: " opcionLog
		case $opcionLog in
			1)
				echo "--- LOG DE INICIO DE SESION ---"
				escogerUsuario
				grep "$user" inicio_sesion.log
				;;
			2)
				echo "--- LOG DE ACTIVIDAD DE USUARIO ---"
				escogerUsuario
				grep "$user" creacion_modificacion.log
				;;
			3)
				echo "--- LOG DE ACCIONES DE SEGURIDAD ---"
				accion=""
				read -p "Seleccione una opcion a filtrar" accion
				grep "$accion" acciones_seguridad.log
				;;
			4)
				echo "--- MENU DE INFORMACION DE LOGS ---"
				menuInfoLogs
				;;
			5)
				echo "--- ESTADISTICAS DE LOGS ---"
				estadisticasLogs
				;;
			exit)
				salir
				;;
			atras)
				clear
				echo "saliendo del menu de log"
				;;
			*)
				echo "opcion no valida"
				;;
		esac
		echo
	done

}




#fin de funciones de log

#funcion gestion de actividades

function menuActividades(){
	echo "bienvenido al menu de actividades"
	opcionActi=""
	#TODO seleccion de usuario 
	while [ "$opcionActi" != "atras" ]; do
		echo "Presione 1 para visualizar uso de memoria del usuario"
		echo "Presione 2 para visualizar procesos del usuario"
		echo "presione 3 para visualizar archivos del usuario"
		echo "Escriba atras para volver al menu principal"
		read -p "Seleccione una opcion: " opcionActi

		case $opcionActi in
			1)
				echo "visualizar uso de memoria del usuario"
				escogerUsuario
				top -b -n 1 -u $user
				echo
				;;
			2)
				echo "visualizar procesos del usuario"
				escogerUsuario
				ps -u $user
				echo
				;;
			3)
				echo "visualizar archivos del usuario"
				escogerUsuario
				find /home -user $user -ls
				;;
			exit)
				salir
				;;
			atras)
				clear
				echo "saliendo del menu de actividades"
				;;
			*)
				echo "opcion no valida"
				;;
		esac
	done 

}
#fin de funciones de actividades

#funciones de gestion del sistema

function menuSistema(){
	echo "bienvenido al menu de gestion del sistema"
	opcionSis=""
	while [ "$opcionSis" != "atras" ]; do
		echo "Presione 1 para visualizar uso de memoria del sistema"
		echo "Presione 2 para visualizar procesos del sistema"
		echo "presione 3 para visualizar archivos del sistema"
		echo "Escriba atras para volver al menu principal"
		read -p "Seleccione una opcion: " opcionSis

		case $opcionSis in
			1)
				echo "visualizar uso de memoria del sistema"
				free
				echo
				;;
			2)
				echo "visualizar procesos del sistema"
				top
				;;
			3)
				echo "visualizar archivos del sistema"
				ls -a
				echo
				;;
			exit)
				salir
				;;
			atras)
				clear
				echo "saliendo del menu de gestion del sistema"
				;;
			*)
				echo "opcion no valida"
				;;
		esac
	done 
}

function iniciarMonitoreoMemoria(){
    # Esta función crea una tarea de cron que ejecuta la verificación de memoria cada 1 minuto
    (crontab -l 2>/dev/null; echo "* * * * * $PWD/$0 verificarMemoria >> $PWD/verificacion_memoria.log 2>&1") | crontab -
    echo "Tarea de cron para verificar memoria cada 1 minuto creada."
}

function detenerMonitoreoMemoria(){
    # Esta función elimina la tarea de cron asociada al script
    crontab -r
    echo "Tarea de cron para verificar memoria eliminada."
}

function verificarMemoria(){
    echo "Verificando memoria"
    uso_memoria=$(free | awk 'FNR == 2 {print $3/$2 * 100}')

    if (( $(echo "$uso_memoria > 20" | bc -l) )); then
        echo "¡Alerta! El uso de memoria ha superado el 20%."
        # Aquí puedes agregar código adicional para enviar notificaciones.
    fi
}

#fin de funciones de gestion del sistema

function onStartUp(){
	echo "Iniciando el programa"
	if [ ! -d db ]; then
		echo "Creando carpeta db"
		mkdir db
		cd db
		touch usuarios.txt
		touch departamentos.txt
	else
		echo "La carpeta db ya existe"
		#verificar si los archivos existen
		if [ ! -f db/usuarios.txt ]; then
			echo "Creando archivo usuarios.txt"
			touch db/usuarios.txt
		else
			echo "El archivo usuarios.txt ya existe"
		fi

		if [ ! -f db/departamentos.txt ]; then
			echo "Creando archivo departamentos.txt"
			touch db/departamentos.txt
		else
			echo "El archivo departamentos.txt ya existe"
		fi

		#verificar si los grupos existen del archivo departamentos.txt
		while IFS=: read -r nombre estado; do
			if [ "$estado" == "activo" ] && grep -q "^$nombre:" /etc/group; then
				echo "El grupo $nombre ya existe"

			elif [ "$estado" == "inactivo" ]; then
				echo "El grupo $nombre esta deshabilitando"
			else
				echo "Creando grupo $nombre"
				groupadd "$nombre"
			fi
			echo
		done < db/departamentos.txt

		#verificar si los usuarios existen del archivo usuarios.txt
		while IFS=: read -r nombre estado departamento; do
			if [ "$estado" == "activo" ] && getent passwd "$nombre" &>/dev/null; then
				echo "El usuario $nombre ya existe"
			elif [ "$estado" == "inactivo" ]; then
				echo "El usuario $nombre esta deshabilitando"
			else
				echo "Creando usuario $nombre"
				useradd "$nombre"
				#agregar usuario a su departamento
			fi
				if [ ! -z "$departamento" ] && [ "$estado" == "activo" ]; then
					usermod -a -G $departamento $nombre
				fi
			echo
		done < db/usuarios.txt
	fi

	USERS_DB='db/usuarios.txt'
	DEPTO_DB='db/departamentos.txt'
}

function salir(){
	echo "Saliendo"
	exit 0
}

function main (){
  iniciarMonitoreoMemoria
	echo "Proyecto por Gabriel Delgado, Juan Manuel Palta, Arturo Diaz y Felipe Barreto"
	echo 
	onStartUp
	logInicioSesion "$(whoami)" "Exito" "Inicio de sesion exitoso"
	echo
	echo "Bienvenido al menu"
	opcion=""
	while [ "$opcion" != "exit" ]; do
		menuPrincipal
		echo
	done
}


main
