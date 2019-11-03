        extraerValores:

                blez $a1, finm1 #Comprobamos que M no sea menor o igual que 0
                blez $a2, finm1 #Comprobamos que N no sea menor o igual que 0
                
                li $t0, 0x80000000 #Mascara signo
                li $t1, 0x7F800000 #Mascara exponente
                li $t2, 0x007FFFFF #Mascara mantisa
                
                #Calculamos el tamaño de la matriz
                #Primero multiplicamos la dimensiones, le restamo uno para que vaya de 0 a n-1
                mul $t3, $a1, $a2
                addi $t3, $t3, -1
                mul $t3, $t3, 4
                add $t3, $t3, $a0
                
                #Mientras que nuestra posicion sea mayor que cero
                while:
                    blt $t3, $a0, fin0
                    l.s $f0, ($t3) #Leemos el valor de esa posicion de la matriz y lo guardamos en $f0
                    mfc1 $t7, $f0 #Guardamos en $t el valor del float en IEEE para poder aplicar la mascara
                    
                    #Aplicamos la mascara de signo y lo rotamos para que se quede el signo a la derecha del todo
                    and $t4, $t7, $t0 #Signo
                    rol $t4, $t4, 1

                    #Aplicamos la mascara del exponente y lo rotamos para que se quede el exponente a la derecha del todo
                    and $t5, $t7, $t1 #Exponente
                    rol $t5, $t5, 9

                    #Aplicamos la mascara de la mantisa y no hace falta rotar porque ya se encuentra a la derecha del todo
                    and $t6, $t7, $t2 #Mantisa

                    #En todos los casos del condicional se carga el valor de la posición pertinente del vector V (dependiendo del tipo de valor que la posición correspondiente de la matriz A almacene)
                    #se le aumenta el valor en 1, y se vuelve a almacenar en la misma posición.

                    beq $t5, 255, exp255 #Si el exponente es 255 saltamos a la etiqueta exp 255

                    beqz $t5, exp0 #Si el exponente es 0 saltamos a la etiqueta exp 0, sino es un numero normalizado
                        lw $t7, 20($a3)
                        addi $t7, $t7, 1
                        sw $t7, 20($a3)
                        b finbucle

                    exp255:
                        beqz $t6, exp255m0 #Si la mantisa es igual a cero salta a la etiqueta exp255m0 sino es NaN
                            lw $t7, 12($a3)
                            addi $t7, $t7, 1
                            sw $t7, 12($a3)
                            b finbucle

                        exp255m0: 
                            beqz $t4, infpos #Si el signo es 1 es -infinito, si es 0 es +infinito
                                lw $t7, 8($a3)
                                addi $t7, $t7, 1
                                sw $t7, 8($a3)
                                b finbucle
                            infpos:
                                lw $t7, 4($a3)
                                addi $t7, $t7, 1
                                sw $t7, 4($a3)
                                b finbucle

                    exp0:
                        beqz $t6, exp0m0 #Si el exponente es cero y la mantisa es 0 salta a exp0m0, sino es un numero no normalizado
                            lw $t7, 16($a3)
                            addi $t7, $t7, 1
                            sw $t7, 16($a3)
                            b finbucle
                        exp0m0:
                            lw $t7, ($a3)
                            addi $t7, $t7, 1
                            sw $t7, ($a3)
                            b finbucle

                finbucle: #declaramos la etiqueta fin de bucle que es común para todos los casos, la cual resta cuatro al contador del bucle y vuelve a la etiqueta de inicio
                    addi $t3, $t3, -4
                    b while

                
                #Declaramos las dos etiquetas de fin las cuales devuelven 0 o -1 dependiendo de si m y n son válidos o no
                fin0:
                    li $v0, 0
                    jr $ra
                finm1:
                    li $v0, -1
                    jr $ra


        sumar:

            #Guardamos los valores de $a en $t para trabajar con ellos
            move $t0, $a0
            move $t1, $a1
            move $t2, $a2
            move $t3, $a3 # t3 = M
            lw $t4, ($sp) # t4 = N

            #Comparamos M y N para ver si son valores válidos, si no lo son llaman a la etiqueta que devuelve -1
            blez $t3, fin1
            blez $t4, fin1

            #Calculamos el tamaño de la matriz de 0 a n-1 siendo n= M*N y lo multiplicamos por 4 que es el numero de direcciones de memoria en un registro
            mul $t3, $t3, $t4 # t3 = M*N
            addi $t3, $t3, -1
            mul $t3, $t3, 4

            
            while:
                bltz $t3, fin0 #Ejecutamos el bucle siempre que nuestra posicion sea mayor que 0

                #Calculamos las posiciones en las que queremos trabajar de cada matriz, la cual es la de inicio de la matriz mas la que estemos del bucle y leemos el valor
                #Matriz B
                add $t4, $t1, $t3
                l.s $f4, ($t4)
                
                #Matriz C
                add $t5, $t2, $t3
                l.s $f5, ($t5)
                
                #Matriz A
                add $t6, $t0, $t3
                
                #Sumamos valores de B y C
                add.s $f4, $f4, $f5
                
                #Guardamos el valor en A
                s.s $f4, ($t6)
                
                #Avanzamos en el bucle
                addi $t3, $t3, -4
                b while


            #Declaramos las dos funciones de fin, las cuales devuelven 0 o -1
            fin0:
                li $v0, 0
                jr $ra
            fin1:
                li $v0, -1
                jr $ra
