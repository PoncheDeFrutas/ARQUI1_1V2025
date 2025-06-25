import subprocess  # Importa el módulo subprocess para ejecutar procesos externos

arm_file = "./main2"  # Define la ruta del archivo ejecutable ARM

# Ejecuta el archivo especificado y captura la salida estándar y de error como texto
result = subprocess.run([arm_file], capture_output=True, text=True)

# Muestra la salida estándar del proceso
print("Standard Output:", result.stdout)
# Muestra la salida de error estándar del proceso
print("Standard Error:", result.stderr)
# Muestra el código de retorno del proceso
print("Return Code:", result.returncode)