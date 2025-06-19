# Compiladores
CC = gcc
AS = as
LD = ld

# Flags para debug
ASFLAGS = -g
LDFLAGS = -g

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
        COMPILE_CMD = $(CC) -g $(SOURCE) -o $(TARGET)
    else ifeq ($(suffix $(archivo)),.s)
        TARGET = $(BIN_AS)/$(basename $(archivo))_asm
        OBJECT = $(OBJ_DIR)/$(basename $(archivo)).o
        SOURCE = $(archivo)
        COMPILE_CMD = $(AS) $(ASFLAGS) $(SOURCE) -o $(OBJECT) && $(LD) $(LDFLAGS) $(OBJECT) -o $(TARGET)
    else
        $(error El archivo debe tener extensión .c o .s)
    endif
endif

# Regla por defecto que compila, pero no ejecuta gdb
all:
ifndef archivo
	@echo "Error: Debes especificar un archivo con 'make archivo=archivo.c|.s'"
else
	@echo "Compilando $(SOURCE)..."
	@$(COMPILE_CMD)
	@echo "Compilación completa. Binario: $(TARGET)"
endif

# Limpieza
clean:
	rm -rf $(BIN_C) $(BIN_AS) $(OBJ_DIR)

# Debug
debug: all
	@if [ -f "$(TARGET)" ]; then \
		echo "Ejecutando GDB para depuración..."; \
		gdb -q $(TARGET); \
	else \
		echo "Error: El target no existe. Usa 'make archivo=archivo.s' primero."; \
	fi

.PHONY: all clean debug