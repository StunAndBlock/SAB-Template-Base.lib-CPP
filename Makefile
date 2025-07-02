
## <os agnostic>
ifeq ($(OS),Windows_NT)
	BINARY_DINAMIC_SUFFIX = dll
	BINARY_STATIC_SUFFIX = a
else
	UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S),Linux)
        BINARY_DINAMIC_SUFFIX = so
		BINARY_STATIC_SUFFIX = a
    endif
endif

BINARY_IMPORT_TARGER_SUFFIX = $(BINARY_DINAMIC_SUFFIX).$(BINARY_STATIC_SUFFIX)
BITS = $(BINARY_IMPORT_TARGER_SUFFIX)
BDS = $(BINARY_DINAMIC_SUFFIX)
BSS = $(BINARY_STATIC_SUFFIX)
## !<>


## <compiller>
CC_DYNAMIC = x86_64-w64-mingw32-g++
CC_STATIC = ar rcs
## !<>

## <name of binary>
NAME_DYNAMIC = 
NAME_STATIC = 
NAME_IMPORT =  
DYNAMICTARGET = $(NAME_DYNAMIC).$(BDS)
STATICTARGET = $(NAME_STATIC).$(BSS)
IMPORTTARGET = $(NAME_IMPORT).$(BITS)
## !<>


## <dir-realted variables>
BUILD_DIR = build
BUILD_DYNAMIC_DIR = $(BUILD_DIR)/dynamic
BUILD_STATIC_DIR = $(BUILD_DIR)/static


INCLUDE_DIR = include
INCLUDE_PATH = $(INCLUDE_DIR)/
SRC_DIR = src
SRC_PATH = $(SRC_DIR)/
## !<>

## <flag-related>
LIBEXPORT = -D
CINCLUDE = -I$(INCLUDE_DIR)
AVOIDMINGWDYNAMIC = -static
CFLAGS = -std=c++17 \
         -O0 -D_FORTIFY_SOURCE=2 -fstack-protector \
		 -Wall -Wextra -Werror -Wshadow \
		 $(LIBEXPORT) \
		 $(CINCLUDE)
		
LDFLAGS = -shared $(AVOIDMINGWDYNAMIC) -Wl,--out-implib,$(BUILD_DYNAMIC_DIR)/$(IMPORTTARGET)
#LDFLAGS_STATIC = -Wl,--out-implib,$(STATICTARGET)
# $(AVOIDMINGWDYNAMIC) $(WINAPILIBS) $(WINAPIRELATED)
## !<>

## <modular system>
MMAIN = 
 
MODULES = $(MMAIN)
#### DO NOT TOUCH
CPP = $(addprefix $(SRC_PATH),$(filter %.cpp,$(MODULES)))
HEADERS = $(addprefix $(INCLUDE_PATH),$(filter %.hpp %.h,$(MODULES)))
OBJECTS = $(patsubst %.cpp,%.o,$(CPP))
## !<>

## <Make main system>
.PHONY: all clean static dynamic

all: dynamic static

dynamic: $(OBJECTS) | $(BUILD_DYNAMIC_DIR)
	$(CC_DYNAMIC) $(OBJECTS) $(LDFLAGS) -o $(BUILD_DYNAMIC_DIR)/$(DYNAMICTARGET)  

static: $(OBJECTS) | $(BUILD_STATIC_DIR)
	$(CC_STATIC) $(BUILD_STATIC_DIR)/$(STATICTARGET) $(OBJECTS) 


### do not touch dynamic object compilation
$(OBJECTS): %.o: %.cpp $(HEADERS)
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJECTS)
	rm -rf $(BUILD_DIR)


### build dir ensurance
$(BUILD_DIR):
	mkdir -p  $(BUILD_DIR)

$(BUILD_DYNAMIC_DIR): $(BUILD_DIR)
	mkdir -p $(BUILD_DYNAMIC_DIR)

$(BUILD_STATIC_DIR): $(BUILD_DIR)
	mkdir -p  $(BUILD_STATIC_DIR)

# !<>