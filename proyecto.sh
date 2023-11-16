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
			echo "opciones de log"
			;;
		4)
			echo "opciones de actividades"
			;;
		5)
			echo "opciones del sistema"
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
				echo "crear usuario"
				;;
			2)
				echo "deshabilitar usuario"
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
	done
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
		echo "Escriba atras para volver al menu principal"
		read -p "Seleccione una opcion: " opcionDepa
		case $opcionDepa in
			1)
				echo "crear depa"
				;;
			2)
				echo "deshabilitar departamento"
				;;
			3)
				echo "modificar departamento"
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
	done
}


#fin de funciones del departamento


function salir(){
	echo "saliendo"
	exit 0
}

function main (){
	echo "Proyecto por Gabriel Delgado y Felipe Barreto"
	echo "bienvenido al menu"
	opcion=""
	while [ "$opcion" != "exit" ]; do
		menuPrincipal
	done
}


main
