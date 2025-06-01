# Compiladores
CC = gcc
AS = as
LD = ld

# Flags para debug
ASFLAGS = -g          # Símbolos de depuración en el ensamblador
LDFLAGS = -g          # ¡IMPORTANTE! Preserva los símbolos en el linker

# Directorios de salida
BIN_C = bin_c
BIN_AS = bin_as
OBJ_DIR = obj

# Crear directorios si no existen
$(shell mkdir -p $(BIN_C) $(BIN_AS) $(OBJ_DIR))

# Si se especifica un archivo como argumento
ifdef archivo
    ifeq ($(suffix $(archivo)),.c)
        TARGET = $(BIN_C)/$(basename $(archivo))
        SOURCE = $(archivo)
    else ifeq ($(suffix $(archivo)),.s)
        TARGET = $(BIN_AS)/$(basename $(archivo))_asm
        OBJECT = $(OBJ_DIR)/$(basename $(archivo)).o
        SOURCE = $(archivo)
    else
        $(error El archivo debe tener extensión .c o .s)
    endif
endif

# Regla para archivos .s (asegúrate de pasar LDFLAGS al linker)
$(BIN_AS)/%_asm: $(OBJ_DIR)/%.o
	$(LD) $(LDFLAGS) $< -o $@

$(OBJ_DIR)/%.o: %.s
	$(AS) $(ASFLAGS) $< -o $@


# Limpieza
clean:
	rm -rf $(BIN_C) $(BIN_AS) $(OBJ_DIR)

# Nueva regla: debug (compila y ejecuta gdb)
debug: $(TARGET)
	@if [ -f "$(TARGET)" ]; then \
		echo "Ejecutando GDB para depuración..."; \
		gdb -q $(TARGET); \
	else \
		echo "Error: El target no existe. Usa 'make archivo=archivo.s' primero."; \
	fi

.PHONY: all clean debug