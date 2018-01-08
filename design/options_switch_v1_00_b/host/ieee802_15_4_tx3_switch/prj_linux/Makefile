SDKROOT = /opt/Nutaq/ADP6/ADP_MicroTCA/sdk

LIBS = -lrtdex -lbusaccess -leapi -lpthread -lpcap -lrecplay -llyrstd -lm

CFLAGS = -I $(SDKROOT)/include  -I../inc -Werror-implicit-function-declaration

LBITS := $(shell getconf LONG_BIT)
ifeq ($(LBITS),64)
   vpath %.a = $(SDKROOT)/lib64
else
   vpath %.a = $(SDKROOT)/lib
endif

VPATH = ../src $(SDKROOT)/utils 

BIN_DIR := ../bin

SRC1 := adp_buff_fct.c TxRxSW.c radio420x_settings.c mac_utils.c

OUT1 := TxRxSW

all: ${BIN_DIR}/${OUT1}

${BIN_DIR}/${OUT1}: ${SRC1} ${LIBS}
	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $^ -o $@

.PHONY: clean
clean:
	rm -f ${BIN_DIR}/${OUT1}
