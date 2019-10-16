        inicializar:
            move $t0, $a0 #Guardamos la dirección de la matriz en un registro temporal para poder trabajar con ello
            move $t1, $a1 #Guardamos el número de filas en un registro temporal para poder trabajar con ello (M)
            move $t2, $a2 #Guardamos el número de columnas en un registro temporal para poder trabajar con ello (N)
        
            blez $t1, fin1 #Comprobamos que M no sea menor o igual que 0
            blez $t2, fin1 #Comprobamos que N no sea menor o igual que 0
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
            fin1:
                li $v0, -1
                jr $ra
