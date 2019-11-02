        inicializar:
        
                  move $t0, $a0 #Guardamos la dirección de la matriz en un registro temporal para poder trabajar con ello
                  move $t1, $a1 #Guardamos el número de filas en un registro temporal para poder trabajar con ello (M)
                  move $t2, $a2 #Guardamos el número de columnas en un registro temporal para poder trabajar con ello (N)

                  blez $t1, finm1 #Comprobamos que M no sea menor o igual que 0
                  blez $t2, finm1 #Comprobamos que N no sea menor o igual que 0
                  mul $t3, $t1, $t2 #Calculamos MxN para saber el número de celdas
                  addi $t3, $t3, -1 #Restamos 1 al número de celdas para poder ir del 0 al 8
                  mul $t3, $t3, 4 #Multiplicamos por 4 (Número de bytes en un registro) para ir avanzando de registro en registro
                  add $t3, $t3, $t0 #Añadimos a nuestra de fin calculada la direccion de inicio de la matriz, para asi calcular la direccion de fin real
        
                  #En el siguente bucle while recorremos la matriz desde su ultima posicion a la primera
                  while:
                        blt $t3, $t0, fin0 #Bucle while, mientras que $t3 sea mayor que la direccion de inicio de la matriz se ejecuta el while
                        sw $zero, ($t3) #Carga 0 en esa posicion
                        addi $t3, $t3, -4 #Retrocede una poscion (4bytes) en memoria 
                        b while #Vuelve al inicio del bucle

                  #Lo siguiente cambia el valor de v0 a 0 o 1 dependiendo de la funcion y finaliza la funcion con jr $ra
                  fin0:
                        li $v0, 0
                        jr $ra
                  finm1:
                        li $v0, -1
                        jr $ra
                
                
        sumar:
        
      	        move $t0, $a0 #Almacena la direccion de la matriz destino (A) en un registro temporal para poder trabajar con ella
                move $t1, $a1 #Almacena la direccion de la matriz B en un registro temporal para poder trabajar con ella
                move $t2, $a2 #Almacena la dreccion de la matriz C en un registro temporal para poder trabajar con ella
                move $t3, $a3 #Mueve el valor de M a un registro temporal para poder trabajar con el
                lw $t4, ($sp) #Mueve el valor de N a un registro temporal para poder trabajar con el, cargandolo de pila, puesto que todos los $a están ocupados
                blez $t3, finm1 #Comprueba que M no sea menor o igual a 0
                blez $t4, finm1 #Comprueba que N no sea menor o igual a 0
                mul $t3, $t3, $t4 #Calcula M*N
                addi $t3, $t3, -1 #Le resta 1 al resultado de la multiplicacion anterior para poder recorrer la matriz en vez de 1 a M*N, de 0 a (M*N)-1
                mul $t3, $t3, 4 #Multiplicamos el numero de registros a recorrer calculado en las lineas anteriores por el número de direcciones de memoria que ocupa cada uno (4)
        
                while: #Creamos la estructura de un bucle while para poder recorrer cada registro de la matriz
        	        bltz $t3, fin0 #Mientras que $t3 sea mayor o igual a 0, continua en el bucle, y si no salta a la etiqueta fin0. $t3 lo usamos como contador al que le vamos restando de 4 en 4 (numero de posiciones de memoria en un registro) para ir recorriendo la matriz de atras hacia delante
                        #Matriz B
                        add $t4, $t1, $t3 #Le añadimos el contador a la direccion inicial de la matriz B para ir a esa posicion en la matriz
                        lw $t4, ($t4) #Cargamos el valor de esa direccion de memoria en un registro temporal para luego operar con el
                        #Matriz C
                        add $t5, $t2, $t3 #Le añadimos el contador a la direccion inicial de la matriz C para ir a esa posicion en la matriz
                        lw $t5, ($t5) #Cargamos el valor de esa direccion de memoria en un registro temporal para luego operar con el
                        #Matriz A
                        add $t6, $t0, $t3  #Le añadimos el contador a la direccion inicial de la matriz C para ir a esa posicion en la matriz
                        add $t4, $t4, $t5 #Sumamos los valores almacenados anteriormente de las matrices B y C
                        #Guardamos el valor en A
                        sw $t4, ($t6) #El valor que calculamos en la linea anterior lo almacenamos en la posicion de memoria correspondiente de la matriz de resultados A
                        addi $t3, $t3, -4 #Una vez hecho lo anterior avanzamos un registro en el contador y por lo tanto una celda en cada una de las matrices
                        b while #salta al principio del bucle
                fin0: #Si se llama a la etiqueta fin0, “devuelve” el valor 0 por $v0, y restaura la ejecución de la funcion que le ha llamado
        	        li $v0, 0
                        jr $ra
                finm1: #Si se llama a la etiqueta fin0, “devuelve” el valor -1 por $v0, y restaura la ejecución de la funcion que le ha llamado
        	        li $v0, -1
                        jr $ra
                        
                        
        extraerfila:
        
    	        move $t0, $a0 #Copiamos la direccion del vector A en un registro temporal para poder trabajar con él
                move $t1, $a1 #Copiamos la direccion de la matriz B en un registro temporal para poder trabajar con él
                move $t2, $a2 #Copiamos el valor de M en un registro temporal para poder trabajar con él
                move $t3, $a3 #Copiamos el valor de N en un registro temporal para poder trabajar con él
                lw $t4, ($sp) #Cargamos de pila el valor de j, a un registro temporal, para poder trabajar con él, puesto que todos los registros $a están ocupados, y por convenio se nos pasan el resto de parámetros por pila
                blez $t2, finm1 #Comprobamos que M no sea menor o igual a 0
                blez $t3, finm1 #Comprobamos que N no sea menor o igual a 0
                bltz $t4, finm1 #Comprobamos que j no sea menor que 0
                bge $t4, $t2, finm1 #Comprobamos que j no sea mayor o igual a M
                mul $t5, $t4, $t3 #Multiplicamos N*j
                mul $t5, $t5, 4 #Multiplicamos el resultado anterior por el número de direcciones de memoria por registro, con esto calculamos el desplazo desde la direción inicial de la matriz B que necesitamos para llegar a la fila que se quiere copiar
                add $t5, $t5, $t1 #Sumamos a la direccion inicial de la matriz B el desplazo necesario para llegar a la fila que se quiere copiar
                addi $t3, $t3, -1 #Preparamos el registro contador para el bucle, en este caso, va a ser el que almacena el valor de N. Lo que hacemos es restarle 1 para poder ir de 0 a N-1 en vez de tener que recorrer de 1 a N
                mul $t3, $t3, 4 #Multiplicamos lo anterior por 4, siento esto el numero de direcciones de memoria por registro
        
                while: #Creamos una estructura de bucle while
        	        bltz $t3, fin0 #Si el contador es mayor o igual a 0, el bucle continua, si no, salta a la etiqueta fin0
                        add $t6, $t5, $t3 #Le sumamos el contador a la direccion de memoria inicial de la fila de la matriz, calculada anteriormente
                        add $t7, $t0, $t3 #Le sumamos el contador a la direccion inicial del vector
                        lw $t8, ($t6) #Cargamos el valor de la posicion de la matriz en la que estamos, en un registro temporal
                        sw $t8, ($t7) #Almacenamos el valor del registro temporal que contiene el valor de la posicion de la matriz correspondiente, en la posicion del vector correspondiente
                        addi $t3, $t3, -4 #Avanzamos en contador, restandole 4 (n° de direcciones de memoria por registro)
                        b while #Volvemos al principio del bucle
                finm1: #Cuando llamamos a esta etiqueta, “devolvemos” el valor -1 a través de $v0 y restauramos la ejecución de la función que llamó a esta
        	        li $v0, -1
                        jr $ra
                fin0: #Cuando llamamos a esta etiqueta, “devolvemos” el valor 0 a través de $v0 y restauramos la ejecución de la función que llamó a esta
        	        li $v0, 0
                        jr $ra   
                
                
        masceros:
        
    	        #Reservamos espacio en pila y guardamos los valores de $s para despues restaurarlos
    	        addi $sp , $sp , -24
                sw $s0, ($sp)
                sw $s1, 4($sp)
                sw $s2, 8($sp)
                sw $s3, 12($sp)
                sw $s4, 16($sp)
                sw $s5, 20($sp)
        
   	        #Guardamos todos los valores de $a en $s para usarlos durante la funcion y que se gruarden a la hora de llamar a la funcion calcular	
    	        move $s0, $a0#MA 
                move $s1, $a1#MB
                move $s2, $a2#M
                move $s3, $a3#N
                move $s4, $ra

                #Comprobamos que M y N sean validos 
                blez $s2, finm1 #M
                blez $s3, finm1 #N

                #Guardamos los argumentos que necesita la funcion calcular y la llamamos
                move $a1, $s2
                move $a2, $s3
                li $a3, 0
                jal calcular
                #Guardamos el resultado de calcular el numero de ceros de la matriz a  
                move $s5, $v0

                #Guardamos los nuevos argumentos de la funcion y la llamamos
                move $a0, $s1
                jal calcular
                #Guardamos el resultado de calcular el numero de ceros de la matriz b
                move $t1, $v0

                #Movemos el valor de $s5 a $t0 para poder restaurar $s5
                move $t0, $s5
                #Restauramos $a $ra
                move $a0, $s0
                move $a1, $s1
                move $a2, $s2
                move $a3, $s3
                move $ra, $s4

                #Restauramos $s
                lw $s0, ($sp)
                lw $s1, 4($sp)
                lw $s2, 8($sp)
                lw $s3, 12($sp)
                lw $s4, 16($sp)
                lw $s5, 20($sp)
                addi $sp , $sp , 24
        
                #Realizamos las comparaciones $t0 = A $t1= B y dependiendo del resultado va a fin0 (devuelve 0)
                #O a fin1 (devuleve uno) o pasa automaticamente a 2 que es empate
                bgt $t0, $t1, fin0
                blt $t0, $t1, fin1
                        li $v0, 2
                        jr $ra
                finm1:
                        li $v0, -1
                        jr $ra
                fin0:
                        li $v0, 0
                        jr $ra
                fin1:
                        li $v0, 1
                        jr $ra
