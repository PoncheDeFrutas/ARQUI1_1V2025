import random

def generar_numeros_aleatorios():
    try:
        # Solicitar la cantidad de datos a generar
        cantidad = int(input("Ingrese la cantidad de números a generar: "))
        if cantidad <= 0:
            print("La cantidad debe ser un número positivo.")
            return

        # Solicitar el rango mínimo y máximo
        minimo = int(input("Ingrese el valor mínimo del rango: "))
        maximo = int(input("Ingrese el valor máximo del rango: "))
        if minimo > maximo:
            print("El valor mínimo no puede ser mayor que el máximo.")
            return

        # Generar los números aleatorios
        numeros = [random.randint(minimo, maximo) for _ in range(cantidad)]

        # Solicitar el nombre del archivo de salida
        nombre_archivo = input("Ingrese el nombre del archivo para guardar los números (ej. numeros.txt): ")

        # Escribir los números en el archivo con el formato solicitado
        with open(nombre_archivo, 'w') as archivo:
            for i, numero in enumerate(numeros):
                archivo.write(f"{i}\n{numero}\n")
            archivo.write("$")  # Agregar el símbolo $ al final

        print(f"Se han generado {cantidad} números aleatorios entre {minimo} y {maximo} en el archivo '{nombre_archivo}'.")
        print("Se ha agregado el símbolo '$' al final del archivo.")

    except ValueError:
        print("Por favor, ingrese valores numéricos válidos.")

if __name__ == "__main__":
    generar_numeros_aleatorios()