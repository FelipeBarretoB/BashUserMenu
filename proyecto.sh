USERS_DB='db/usuarios.txt'
DEPTO_DB='db/departamentos.txt'
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
				echo "Modificar usuario"
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

function crearUsuario(){
  echo "Creando usuario"
  read -p "Ingrese el nombre del usuario: " nombre
  # Verificar si el usuario ya existe
    if grep -q "^$nombre:" "$USERS_DB"; then
        echo "El usuario ya existe."
    else
        # Crear el usuario y almacenar en el archivo
        useradd "$nombre"
        echo "$nombre:activo" >> "$USERS_DB"
        echo "Usuario creado con éxito."
    fi
}

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
    else
        echo "El usuario no existe."
    fi
}

function listarUsuarios(){
	echo "Listando usuarios"
	awk -F: '{ print $1}' /etc/passwd
	echo
}

function escogerUsuario(){
	echo "escoga un usuario"
	read user
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
				echo "deshabilitar departamento"
				;;
			3)
				echo "modificar departamento"
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
  fi
}

function deshabilitarDepartamento(){
  echo "Deshabilitando departamento"
  read -p "Ingrese el nombre del departamento: " nombre
  # Verificar si el departamento existe
  if grep -q "^$nombre:" "$DEPTO_DB"; then
    # Deshabilitar el departamento y almacenar en el archivo
    groupdel "$nombre"
    # Deshabilitar el departamento cambiando su estado a inactivo"
    awk -v nombre="$nombre" 'BEGIN {FS=OFS=":"} {if ($1 == nombre && $2 == "activo") $2 = "inactivo"} 1' "$DEPTO_DB" > tmpfile && mv tmpfile "$DEPTO_DB"
    echo "Departamento deshabilitado con éxito."
  else
    echo "El departamento no existe."
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
		echo "Escriba atras para volver al menu de departamentos"
		read -p "Seleccione una opcion: " opcionAsig
		case $opcionAsig in
			1)
				echo "asignar usuario a departamento"
				;;
			2)
				echo "deshabilitar usuario a departamento"
				;;
			3)
				listarUsuarios
				echo
				;;
			4)
				echo "listar departamentos"
				groups
				echo
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

#fin de funciones del departamento

#Funciones de log

function menuLog(){
	echo "bienvenido al menu de log"
	opcionLog=""

	while [ "$opcionLog" != "atras" ]; do
		#TODO: agregar opciones de log 
		echo "presione 1 para ver log 2"
		echo "presione 2 para ver log 1"
		echo "Esciba atras para volver al menu principal"
		read -p "Seleccione una opcion: " opcionLog
		case $opcionLog in
			1)
				echo "log 1"
				;;
			2)
				echo "log 2"
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
				;;
			3)
				echo "visualizar archivos del usuario"
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

#fin de funciones de gestion del sistema

function salir(){
	echo "Saliendo"
	exit 0
}

function main (){
	echo "Proyecto por Gabriel Delgado, Juan Manuel Palta, Arturo Diaz y Felipe Barreto"
	echo "Bienvenido al menu"
	opcion=""
	while [ "$opcion" != "exit" ]; do
		menuPrincipal
		echo
	done
}


main
