#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>

#ifdef __linux__
#include <Nutaq/memory_map.h>
//#include <Nutaq/address_map.h>
#include <Nutaq/adp_types.h>
#include <Nutaq/adp_media_types.h>
#include <Nutaq/eapi.h>
#include <Nutaq/adp_bus_access_media_types.h>
#include <Nutaq/adp_bus_access_types.h>
#include <Nutaq/adp_bus_access.h>
#include <Nutaq/adp_rtdex_types.h>
#include <Nutaq/adp_rtdex_eth_types.h>
#include <Nutaq/adp_rtdex_media.h>
#include <Nutaq/adp_rtdex_access.h>
#include <Nutaq/adp_rtdex.h>
#include <Nutaq/adp_rtdex_eth.h>
#include <Nutaq/adp_recplay_types.h>
#include <Nutaq/adp_recplay.h>
#include <Nutaq/fmc_radio_defines.h>
#include <Nutaq/mac_utils.h>
#include <Nutaq/adp_buff_fct.h>
#include <radio420x_settings.h>
#include <sys/ioctl.h>
#include <sys/time.h>
#define sscanf_s sscanf
#endif

// WARNING: to run this demo under LINUX, you may need root privilege

#define BOARD_REV FMCRADIOREVSDR_D

// Uncomment following USE_MEMMAP to use an os memory map file for the data buffers, comment it to use a regular allocated
// read/write buffer using normal file io (before/after buffer use).
//#define USE_MEMMAP 1


// Uncomment following #define USE_JUMBO_FRAME to use ehernet jumbo frame which should improve data transfer
// performance. But to use this mode, all ethernet elements between the module and the host must support it
// (not all gigabit ethernet adapters support this). Software drivers configuration could also be needed to
// achieve this mode (see perseus documentation).
//#define USE_JUMBO_FRAME 1


// This sets the ethernet frame inter packets time pause in 125MHz clk counts when the module is sending data packets to the host.
// Could be used if data packets are lost. Hardware "Pause" frame support could also be used for this
// purpose, but all elements including the computer software drivers in the connection between
// the module and the host must support it and be configured for it. Make this number bigger
// to increase inter-packets delay. This number could be made lower if pause frame is supported
// Around 200000 ~ 2 msec inter packet delay
#define FRAME_GAP 20000


// Use for data transfer time estimation to the host (record). Estimation is for gigabit ethernet (see ETH_SPEED)...
#define FRAME_GAP_CLK 100000000
#define ETH_SPEED 1000000000
#define ETH_FRAME_OVERHEAD 38
#define PACKET_OVERHEAD 30


#define TOP_RADIO 2
#define BOTTOM_RADIO 1
#define MIMO '2'
#define SISO '1'


/***************************************************
*  Frequency defines
***************************************************/
//#define CARRIER_FREQ 860000000 //860000000//943000000
//#define ACQUISTION_FREQ 16000000	//(FMCRADIO_DATARATE_REF_30_72MHZ_7DOT68MHZ)
#define BUFFSIZE RTDEX_STREAMING_TEST_SIZE

#define NBR_PACKET atoi(argv[4])//1000000

#define RX_ON 1 
#define TX_ON 1

// Defines for easy command line arguments access
#define IpAddress argv[1]
#define MimoTest *(argv[2])

/***************************************************
*  RTDEx defines
***************************************************/
#define RTDEX_PACKET_SIZE (256) //(8192)	
#define BURST_SIZE (RTDEX_PACKET_SIZE * 1)
#define RECEIVE_BUFFER_SIZE (BURST_SIZE)


//unsigned short pTopBuffer[RECEIVE_BUFFER_SIZE];
//unsigned short pBottomBuffer[RECEIVE_BUFFER_SIZE];

/*unsigned short pTopTxBuffer[RECEIVE_BUFFER_SIZE];
unsigned short pTopRxBuffer[RECEIVE_BUFFER_SIZE];

unsigned short pBottomTxBuffer[RECEIVE_BUFFER_SIZE];
unsigned short pBottomRxBuffer[RECEIVE_BUFFER_SIZE];

unsigned short pMACTxBuffer[RECEIVE_BUFFER_SIZE];
unsigned short pMACRxBuffer[RECEIVE_BUFFER_SIZE];*/

unsigned char pTopTxBuffer[RECEIVE_BUFFER_SIZE];
unsigned char pTopRxBuffer[RECEIVE_BUFFER_SIZE];

unsigned char pBottomTxBuffer[RECEIVE_BUFFER_SIZE];
unsigned char pBottomRxBuffer[RECEIVE_BUFFER_SIZE];

unsigned char pMACTxBuffer[RECEIVE_BUFFER_SIZE];
unsigned char pMACRxBuffer[RECEIVE_BUFFER_SIZE];

adp_handle_rtdex_conn hConnStreamingMACRx			= NULL;
adp_handle_rtdex_conn hConnStreamingMACTx			= NULL;
adp_handle_rtdex_conn hConnStreamingTopRx			= NULL;
adp_handle_rtdex_conn hConnStreamingTopTx			= NULL;
adp_handle_rtdex_conn hConnStreamingBottomRx		= NULL;
adp_handle_rtdex_conn hConnStreamingBottomTx		= NULL;

adp_handle_bus_access hBusAccess    = NULL;

unsigned int temp = 0;

float CARRIER_FREQ;
float ACQUISTION_FREQ;

#ifdef __linux__

#include <termios.h>
#include <unistd.h>
#include <stdlib.h>

static int _getch(void)
{
    struct termios oldt,
    newt;
    int ch;

    tcgetattr( STDIN_FILENO, &oldt );
    newt = oldt;
    newt.c_lflag &= ~( ICANON | ECHO );
    tcsetattr( STDIN_FILENO, TCSANOW, &newt );
    ch = getchar();
    tcsetattr( STDIN_FILENO, TCSANOW, &oldt );

    return ch;
}

/*
 *  kbhit()  --  a keyboard lookahead monitor
 *
 *  returns the number of characters available to read.
 */
static int _kbhit(void) {
  int                   cnt = 0;
  int                   error;
  struct termios Otty, Ntty;

  fflush(stdout);

  tcgetattr(0, &Otty);
  Ntty = Otty;

  Ntty.c_iflag          = 0;       /* input mode                */
//  Ntty.c_oflag          = 0;       /* output mode               */
  Ntty.c_lflag         &= ~ICANON; /* line mode                 */
  Ntty.c_cc[VMIN]       = 0;    /* minimum time to wait      */
  Ntty.c_cc[VTIME]      = 1;   /* minimum characters to wait for */

  if (0 == (error = tcsetattr(0, TCSANOW, &Ntty))) {
    struct timeval      tv;
    error     += ioctl(0, FIONREAD, &cnt);
    error     += tcsetattr(0, TCSANOW, &Otty);
    tv.tv_sec  = 0;
    tv.tv_usec = 100;
    select(1, NULL, NULL, NULL, &tv);  /* a small time delay */
  }

  return (error == 0 ? cnt : -1 );
}

static unsigned GetTickCount()
{
   struct timeval tv;
   unsigned long long val;
   gettimeofday( &tv, NULL);
   val = tv.tv_sec * 1000000 + tv.tv_usec;
   return val/1000;
}

#define Sleep(x) usleep( x*1000 )

#endif 

int Test_Terminate(void)
{
    if(hConnStreamingMACTx != NULL)
	{
		RTDExCloseEth(hConnStreamingMACTx);
	}
    if(hConnStreamingMACRx != NULL)
	{
		RTDExCloseEth(hConnStreamingMACRx);
	}
	if(hConnStreamingTopRx != NULL)
	{	
		RTDExCloseEth(hConnStreamingTopRx);
	}
	if(hConnStreamingBottomRx != NULL)
	{	
		RTDExCloseEth(hConnStreamingBottomRx);
	}
	if(hConnStreamingTopTx != NULL)
	{	
		RTDExCloseEth(hConnStreamingTopTx);
	}
	if(hConnStreamingBottomTx != NULL)
	{	
		RTDExCloseEth(hConnStreamingBottomTx);
	}
	if(hBusAccess != NULL)
	{	
		BusAccess_Ethernet_Close(hBusAccess);
	}
	return 0;
}

//FILE *pfile;
FILE *pIfile;
FILE *pOfileRx0;
FILE *pOfileRx1;
FILE *pOfileRx2;
char *nIfile    = "ifile.txt";
char *nOfileRx0 = "ofileRx0.txt";
char *nOfileRx1 = "ofileRx1.txt";
char *nOfileRx2 = "ofileRx2.txt";

void InputFilesGenerator(int mimo_test)
{
    unsigned int mcnt;
    char *pcbuffer;
	
    char *iStr;	// = " FIT--CorteXlab "

    long result;
    long sizeIfile;
    int indk =0;
    srand(time(NULL));
    
    pIfile = fopen(nIfile,"w+");
    if(pIfile == NULL){
        printf("I couldn't open %s \n",nIfile);
        exit(0);
    }
 
    fclose(pIfile);
}


void OutputFilesSaver(int mimo_test)
{
    unsigned int i = 0;
    int indk = 0;
    long sizeIfile;
    
    pOfileRx0 = fopen(nOfileRx0,"w+");
    if(pOfileRx0 == NULL){
        printf("I couldn't open %s \n",nOfileRx0);
        exit(0);
    }

    pOfileRx1 = fopen(nOfileRx1,"a"); //w+
    if(pOfileRx1 == NULL){
        printf("I couldn't open %s \n",nOfileRx1);
        exit(0);
    }
    
    pOfileRx2 = fopen(nOfileRx2,"w+");
    if(pOfileRx2 == NULL){
        printf("I couldn't open %s \n",nOfileRx2);
        exit(0);
    }
    
    for(i=0; i<RECEIVE_BUFFER_SIZE; i++){	//sizeIfile
        if(indk<15){
            fprintf(pOfileRx0,"%c",(unsigned char)pMACRxBuffer[i]);
            fprintf(pOfileRx1,"%2X",(unsigned char)pBottomRxBuffer[i]);
            //if(mimo_test == MIMO)
            fprintf(pOfileRx2,"%2X",(unsigned char)pTopRxBuffer[i]);
            indk++;
        }
        else {
            indk = 0;
            //if(mimo_test == MIMO)
            fprintf(pOfileRx0,"\n");
            fprintf(pOfileRx1,"\n");
            fprintf(pOfileRx2,"\n");
        }
    }
    fclose(pOfileRx0);
    fclose(pOfileRx1);
    fclose(pOfileRx2);
}

void frame_ieee802_15_4_gen(const char * payload)
{
   unsigned int i = 0;
   size_t len_payload = strlen(payload);
   printf("Length of Payload <%s> is <%ld> bytes\n",payload,len_payload);   

   unsigned int len_tx_buffer = sizeof(pTopTxBuffer);
   printf("Length of pTopTxBuffer is <%d> bytes\n",len_tx_buffer); 

   memset(pTopTxBuffer, 0x00, sizeof(pTopTxBuffer));

   pTopTxBuffer[0] = 0x00;
   pTopTxBuffer[1] = 0x00;
   pTopTxBuffer[2] = 0x00;
   pTopTxBuffer[3] = 0x00;
   pTopTxBuffer[4] = 0xA7;

   pTopTxBuffer[5] = (unsigned char) len_payload;

   memcpy(&pTopTxBuffer[6],payload,len_payload);
   memcpy(&pMACTxBuffer,pTopTxBuffer,RECEIVE_BUFFER_SIZE);
   memcpy(&pBottomTxBuffer,pTopTxBuffer,RECEIVE_BUFFER_SIZE);

   /*i = 6;
   while(i<len_payload+6){
	pTopTxBuffer[i++] = (unsigned char) (*payload++);
   }*/

   i = 0;
   printf("\n=====================================\n");
   while(i<6+len_payload)
	printf("%2X : ",pTopTxBuffer[i++]);
   printf("\n=====================================\n");
   i = 0;
   printf("\n=====================================\n");
   while(i<6+len_payload)
	printf("%c",pTopTxBuffer[i++]);
   printf("\n=====================================\n");

}


unsigned char *generic_frame_ieee802_15_4_gen(const char * payload)
{
   unsigned int i = 0;
   unsigned char *output_buffer;
   size_t len_payload = strlen(payload);
   printf("Length of Payload <%s> is <%ld> bytes\n",payload,len_payload);   

   output_buffer = (unsigned char *) malloc(6+len_payload);

   memset(output_buffer, 0x00, sizeof(output_buffer));

   output_buffer[0] = 0x00;
   output_buffer[1] = 0x00;
   output_buffer[2] = 0x00;
   output_buffer[3] = 0x00;
   output_buffer[4] = 0xA7;

   output_buffer[5] = (unsigned char) len_payload;

   memcpy(&output_buffer[6],payload,len_payload);

   i = 0;
   printf("\n##############################################\n");
   while(i<6+len_payload)
	printf("%2X : ",output_buffer[i++]);
   printf("\n##############################################\n");
   i = 0;
   printf("\n##############################################\n");
   while(i<6+len_payload)
	printf("%c",output_buffer[i++]);
   printf("\n##############################################\n");

   return output_buffer;
}


void print_buff(unsigned char * buffer)
{
   size_t len_buffer = strlen(buffer);
   unsigned int i = 0;
   printf("\n***************************************************\n");
   while(i<len_buffer)
	printf("%2X : ",buffer[i++]);
   printf("\n***************************************************\n");
}
//******************************************************************
//                      M  A  I  N
//******************************************************************

//extern load_radio_params(const char *filename);
extern void get_radio420x_params(const char *filename, const char *radio_card_name, const char *txrx_conf);
//extern tx_conf_struct tx_conf_struct;

int main( int argc, char* argv[] )
{
   adp_result_t res;

   unsigned int NbrTx = 0;

   unsigned int indk = 0;
   unsigned int i;
 
   unsigned long long streamingstart;
   unsigned long long streamingstop;
   unsigned int iterations = 0;

   float transferlenght    = 0;
   float transfersizeRxTop = 0;
   float transfersizeRxBot = 0;
   float transfersizeTxTop = 0;
   float transfersizeTxBot = 0;
    
   unsigned long long bytereceivedRxMAC = 0;
   unsigned long long bytesentMAC       = 0;
   unsigned long long bytereceivedRxBot = 0;
   unsigned long long bytereceivedRxTop = 0;
   unsigned long long bytesentBot       = 0;
   unsigned long long bytesentTop       = 0;

   char pHostMacAddr[6];
   char pDeviceMacAddr[6];
   const char* pMacStr = "%02x:%02x:%02x:%02x:%02x:%02x:%02x";

   FMCRADIO_REV BoardRevision = BOARD_REV;
   int choice;

   char Radio420x_Cfg[20];
   //sprintf(Radio420x_Cfg,"radio420_config/%s",argv[3]);
   //sprintf(Radio420x_Cfg,"radio420_config/radio420x.cfg");
   sprintf(Radio420x_Cfg,"%s",argv[3]);
   printf("PATH of RADIO-A1 Config File : %s\n",Radio420x_Cfg);
   //******************************
    get_radio420x_params(Radio420x_Cfg,"RA1","tx");
     //load_radio_params(RadioA1_Cfg);
   //******************************
   CARRIER_FREQ = tx_conf_struct.TX_ACQUISITION_FREQUENCY;
   ACQUISTION_FREQ = tx_conf_struct.TX_CARRIER_FREQUENCY;
   printf("#======# CARRIER_FREQ : %f\n", CARRIER_FREQ);
   printf("#======# ACQUISTION_FREQ : %f\n", ACQUISTION_FREQ);
   getchar();
   
   //==========================================================================
   //                 IEEE 802.15.4 FRAME GENERATOR 
   //==========================================================================
     const char *msg1 = argv[5];
     const char *msg2 = argv[6];
   //==========================================================================
     unsigned char* ptr_msg1 = generic_frame_ieee802_15_4_gen(msg1);
     memcpy(&pTopTxBuffer[0],ptr_msg1,6+strlen(msg1));
     unsigned char* ptr_msg2 = generic_frame_ieee802_15_4_gen(msg2);
     memcpy(&pBottomTxBuffer[0],ptr_msg2,6+strlen(msg2));
     getchar();
   //==========================================================================

   // Initialize eapi before use 
   res = eapi_init();
   if( res != 0 )
   {
       printf( "Error initializing eapi.\n"
              " The program will terminate. Push any key to continue\n" );
       _getch();
	   Test_Terminate();
       return -1;
   }

   if(MimoTest == MIMO)
   {
		printf( "Radio420 MIMO Streaming demo is started.\n" );
   }
   else
   {
		printf( "Radio420 SISO Streaming demo is started.\n" );
   }

   printf( "Connecting to %s \n",IpAddress );

   // Connect to Perseus
   res  = BusAccess_Ethernet_OpenWithoutConnection(&hBusAccess, IpAddress, 0);
   if( res ) 
   {
       printf( "The Perseus is not responding.\n" );
       printf( "Please ensure the Perseus IP address you specified (%s) is correct.\n\n", IpAddress );
       printf( "The program will terminate. Push any key to continue\n" );
       _getch();
	   Test_Terminate();
       return -1;
   }
   
   printf( "Connected!\n\n" );

  
   // Extract Mac addresses 
   res = iGetConnectionPeerMacAddr( hBusAccess, (unsigned char *)pDeviceMacAddr);
   if( res ) 
   {
       printf( "Problem getting target MAC address.\n" );
       printf( "The program will terminate. Push any key to continue\n" );
       _getch();
       return -1;
   }

   printf( "MAC address of Perseus is: '");
   for( i = 0; i < 5; i++)
   printf( "%02X:", (unsigned char)pDeviceMacAddr[ i ]);
   printf( "%02X'\n", (unsigned char)pDeviceMacAddr[ i ]);

   res = iGetConnectionLocalMacAddr( hBusAccess, (unsigned char *)pHostMacAddr);
   if( res ) 
   {
       printf( "Problem getting host MAC address.\n" );
       printf( "The program will terminate. Push any key to continue\n" );
       _getch();
       return -1;
   }

   printf( "MAC Address of Host is: '");
   for( i = 0; i < 5; i++)
   printf( "%02X:", (unsigned char)pHostMacAddr[ i ]);
   printf( "%02X'\n\n", (unsigned char)pHostMacAddr[ i ]);

   // Initialize FMC Radios
    printf("Initializing bottom FMC...\r\n");
    res = InitRadio420x( hBusAccess , BoardRevision, BOTTOM_RADIO, CARRIER_FREQ, ACQUISTION_FREQ);
	if( res != 0 ) 
	{
	   printf( "Error initializing the Radio420x, code=%x.\n"
			   "The program will terminate. Push any key to continue\n", res );

	   _getch();
	   Test_Terminate();
	   return -1;
	}	
    printf("Done\r\n\n");

    if (MimoTest == MIMO)
	{
	   printf("Initializing top FMC...\r\n");
	   res = InitRadio420x( hBusAccess , BoardRevision, TOP_RADIO, CARRIER_FREQ, ACQUISTION_FREQ);
	   if( res != 0 ) 
	   {
		   printf( "Error initializing the Radio420x, code=%x.\n"
				   "The program will terminate. Push any key to continue\n", res );

		   _getch();
	   Test_Terminate();
		   return -1;
	   }	
		printf("Done\r\n\n");
	}

	printf("Press enter to start streaming\n");
	
	//choice = _getch();
	res = BusAccess_WriteReg( hBusAccess, TARGET_CUSTOMREGS_1, 6);

	//disable FPGA rtdex transmission to host
	res = BusAccess_WriteReg( hBusAccess, TARGET_CUSTOMREGS_3, 0);

	// Set mimo or siso configuration
  	if(MimoTest == MIMO)
	{
		// Radio transmitters are synchronised for mimo
		res = BusAccess_WriteReg( hBusAccess, TARGET_CUSTOMREGS_4, 1);
	}
	else
	{
		// Radio transmitters are not synchronised
		res = BusAccess_WriteReg( hBusAccess, TARGET_CUSTOMREGS_4, 0);
	}

    // Reset RTDEx Core
	res = RTDExResetCoreEth(hBusAccess, module_rtdex_eth_base);
	if( res ) 
	{
	   printf( "Error resetting the RTDEx core.\n"
			   "The program will terminate. Push any key to continue\n"  );
	   _getch();
	   return -1;
	}

    // Reset Open Ethernet Channels 0 & 1 & 2
    if( TX_ON)
	{
      //Ethernet TX Channel 0
		res = RTDExOpenEth( &hConnStreamingMACTx,  pHostMacAddr,
                            eHost,
                            pDeviceMacAddr,
                            hBusAccess,
                            module_rtdex_eth_base,
                            0,
                            eToFpga,
                            eContinuous );
		if( res )
		{
			printf( "Error initializing the Tx Bottom RTDEx connection. %x\n"
				   "The program will terminate. Push any key to continue\n" ,res );
			_getch();
			Test_Terminate();
			return -1;
		}
      //Ethernet TX Channel 1
		res = RTDExOpenEth( &hConnStreamingBottomTx,  pHostMacAddr,
							eHost,
							pDeviceMacAddr, 
							hBusAccess,
							module_rtdex_eth_base, 
							1,
							eToFpga,
							eContinuous );  
		if( res ) 
		{
			printf( "Error initializing the Tx Bottom RTDEx connection. %x\n"
				   "The program will terminate. Push any key to continue\n" ,res );
			_getch();
			Test_Terminate();
			return -1;
		}
      //Ethernet TX Channel 2
		res = RTDExOpenEth( &hConnStreamingTopTx,  pHostMacAddr,
                            eHost,
                            pDeviceMacAddr,
                            hBusAccess,
                            module_rtdex_eth_base,
                            2,
                            eToFpga,
                            eContinuous );
		if( res )
		{
			printf( "Error initializing the Tx Bottom RTDEx connection. %x\n"
				   "The program will terminate. Push any key to continue\n" ,res );
			_getch();
			Test_Terminate();
			return -1;
		}
	}
	if( RX_ON)
	{
      //Ethernet RX Channel 0
		res = RTDExOpenEth( &hConnStreamingMACRx, pHostMacAddr,
                            eHost,
                            pDeviceMacAddr,
                            hBusAccess,
                            module_rtdex_eth_base,
                            0,
                            eFromFpga,
                            eContinuous );
		if( res )
		{
            
            printf( "Error initializing the RTDEx connection.\n"
				   "The program will terminate. Push any key to continue\n"  );
            _getch();
			Test_Terminate();
            return -1;
		}
        //Ethernet RX Channel 1
		res = RTDExOpenEth( &hConnStreamingBottomRx, pHostMacAddr,
										eHost,
										pDeviceMacAddr, 
										hBusAccess,
										module_rtdex_eth_base, 
										1,
										eFromFpga,
										eContinuous );
		if( res ) 
		{
		  
		   printf( "Error initializing the RTDEx connection.\n"
				   "The program will terminate. Push any key to continue\n"  );
		   _getch();
			Test_Terminate();
		   return -1;
		}
        //Ethernet RX Channel 2
		res = RTDExOpenEth( &hConnStreamingTopRx, pHostMacAddr,
                            eHost,
                            pDeviceMacAddr,
                            hBusAccess,
                            module_rtdex_eth_base,
                            2,
                            eFromFpga,
                            eContinuous );
		if( res )
		{
            
            printf( "Error initializing the RTDEx connection.\n"
				   "The program will terminate. Push any key to continue\n"  );
            _getch();
			Test_Terminate();
            return -1;
		}
	}

	// Set frame gap for FPGA transmitter
	res = RTDExSetTxFrameGapValEth( hBusAccess, module_rtdex_eth_base, FRAME_GAP );
	if( res != 0 ) 
	{
	   printf( "Error with SetRTDExEthTxFrameGapVal.\n"
			  " The program will terminate. Push any key to continue\n" );
	   _getch();
		Test_Terminate();
	   return -1;
	}

	// Set flow control setup for FPGA receiver
	// Fifo is 32ksamples
	// Packet size is 2k samples (8k bytes)
	// Fifo is 16 packets deep
	// Minimum threshold (for flow control clear) is 4 packets in fifo
	// Maximum threshold (for flow control pause) is 12 packets in fifo
	res = RTDExEnableFlowControlEth(hBusAccess, module_rtdex_eth_base, 24576, 8192 );
	if( res != 0 ) 
	{
	   printf( "Error with RTDExEnableFlowControlEth.\n"
			  " The program will terminate. Push any key to continue\n" );
	   _getch();
		Test_Terminate();
	   return -1;
	}
    
    if(TX_ON)
    {
        // Start FPGA RTDEx TX FIFO for MAC (Channel 0)
        res = RTDExStart(hConnStreamingMACTx, RTDEX_PACKET_SIZE, 0);
        if( res != 0 )
        {
            printf( "Error starting RTDEx transfer.\n"
                   " The program will terminate. Push any key to continue\n" );
            _getch();
            Test_Terminate();
            return -1;
        }
        // Start FPGA RTDEx TX FIFO for Bottom FMC (Channel 1)
        res = RTDExStart(hConnStreamingBottomTx, RTDEX_PACKET_SIZE, 0);
        if( res != 0 )
        {
            printf( "Error starting RTDEx transfer.\n"
                   " The program will terminate. Push any key to continue\n" );
            _getch();
            Test_Terminate();
            return -1;
        }
        // Start FPGA RTDEx TX FIFO for Top FMC (Channel 2)
        res = RTDExStart(hConnStreamingTopTx, RTDEX_PACKET_SIZE, 0);
        if( res != 0 )
        {
            printf( "Error starting RTDEx transfer.\n"
                   " The program will terminate. Push any key to continue\n" );
            _getch();
            Test_Terminate();
            return -1;
        }
    }
    
    if(RX_ON)
    {
      // Start FPGA RTDEx RX FIFO for MAC (Channel 0)
		res = RTDExStart(hConnStreamingMACRx, RTDEX_PACKET_SIZE, 0);
		if( res != 0 )
		{
			printf( "Error starting RTDEx transfer.\n"
                   " The program will terminate. Push any key to continue\n" );
			_getch();
			Test_Terminate();
			return -1;
		}
        // Start FPGA RTDEx RX FIFO for Buttom FMC (Channel 1)
		res = RTDExStart(hConnStreamingBottomRx, RTDEX_PACKET_SIZE, 0);
		if( res != 0 )
		{
			printf( "Error starting RTDEx transfer.\n"
                   " The program will terminate. Push any key to continue\n" );
			_getch();
			Test_Terminate();
			return -1;
		}
        // Start FPGA RTDEx RX FIFO for Top FMC (Channel 2)
        res = RTDExStart(hConnStreamingTopRx, RTDEX_PACKET_SIZE, 0);
        if( res != 0 )
        {
            printf( "Error starting RTDEx transfer.\n"
                   " The program will terminate. Push any key to continue\n" );
            _getch();
            Test_Terminate();
            return -1;
        }
    }

	// Start FGPA RTDEx Transmitters
	res = BusAccess_WriteReg( hBusAccess, TARGET_CUSTOMREGS_3, 1);
    printf( "Streaming... Press enter to terminate\n");
	streamingstart = GetTickCount();
	{
		//streaming start
		int run = 1;
		unsigned int iterations = 0;
		unsigned int clear;
		printf( "Radio acquisition frequency set to %2.2f Msps\n", ((float)ACQUISTION_FREQ)/1000000);
		//Clear underrun and overrun flags
		BusAccess_ReadReg(hBusAccess, 0x7100009C, &clear);
		BusAccess_ReadReg(hBusAccess, 0x71000094, &clear);

		// streaming loop
		while(NbrTx<NBR_PACKET)	//while(run)
		{ 
		   int FrTx = 0;
		   while(FrTx<5)	//while(run)
		   { 
			switch(FrTx){ 
			  case 0:
				printf("========== 0 // 0 =======\a\n");
				print_buff(pMACTxBuffer);
				memset(pMACTxBuffer, 0x00, sizeof(pMACTxBuffer));
				getchar();
				break;
			  case 1:
				printf("========== 1 // 1 =======\a\n");
				print_buff(pMACTxBuffer);
				memset(pMACTxBuffer, 0x01, sizeof(pMACTxBuffer));
				getchar();
				break;
			  case 2 :
				printf("========== 0 // 3 =======\a\n");
				print_buff(pMACTxBuffer);
				memset(pMACTxBuffer, 0x03, sizeof(pMACTxBuffer));
				getchar();
				break;
			  case 3 :
				printf("========== 0 // 2 =======\a\n");
				print_buff(pMACTxBuffer);
				memset(pMACTxBuffer, 0x02, sizeof(pMACTxBuffer));
				getchar();
				break;
			  case 4 :
				printf("========== 0 // 0 =======\a\n");
				print_buff(pMACTxBuffer);
				memset(pMACTxBuffer, 0x00, sizeof(pMACTxBuffer));
				getchar();
				break;
			}
		    //*****************************
		    FrTx++;
		    //*****************************

			NbrTx++;
			// if key hit, exit loop
			/*if( _kbhit()) 
			{
			   _getch();
			   break;
			}*/
			printf("\nMASSOURI DEBUG BEFORE TX TRANSMIT DATA!!  <%d>\n",NbrTx);
			if(TX_ON)
			{
            // Send Data to MAC (Channel 0)
				res = RTDExSend(hConnStreamingMACTx, (unsigned char*)(pMACTxBuffer), RECEIVE_BUFFER_SIZE);
				if( res != RECEIVE_BUFFER_SIZE )
				{
            	printf( "Error sending RTDEx data on MAC. %x\n"
                       " The program will terminate. Push any key to continue\n",res );
               _getch();
					Test_Terminate();
               return -1;
				}
				bytesentMAC += res;
				printf("\nByte Sent on MAC TX : %llu\n",bytesentMAC);
                
				// Send data to Bottom FMC (Channel 1)
				res = RTDExSend(hConnStreamingBottomTx, (unsigned char*)(pBottomTxBuffer), RECEIVE_BUFFER_SIZE);
				if( res != RECEIVE_BUFFER_SIZE ) 
				{
					printf( "Error sending RTDEx data on Bottom. %x\n"
						  " The program will terminate. Push any key to continue\n",res );
				   _getch();
					Test_Terminate();
				   return -1;
				}
				bytesentBot += res;
				printf("\nByte Sent on Bottom TX : %llu\n",bytesentBot);
                
            // Send data to Top FMC (Channel 2)
				res = RTDExSend(hConnStreamingTopTx, (unsigned char*)(pTopTxBuffer), RECEIVE_BUFFER_SIZE);
				if( res != RECEIVE_BUFFER_SIZE )
				{
               printf( "Error sending RTDEx data on Top. %x\n"
                           " The program will terminate. Push any key to continue\n",res );
               _getch();
					Test_Terminate();
               return -1;
				}
				bytesentTop += res;
				printf("\nByte Sent on Top TX : %llu\n",bytesentTop);
			}
			
			printf("\n========= MASSOURI DEBUG BEFORE RX RECEIVE DATA!! ===========\n");	
			if(RX_ON)
			{
            			// Receive data from MAC 
				res = RTDExReceive(hConnStreamingMACRx, (unsigned char*)(pMACRxBuffer), RECEIVE_BUFFER_SIZE, eRTDExWaitTimeout, 1000);
				
                printf("\n========= CHANNEL < 0 > ===========\n");    
				/*========================================================*/
				printf("\n===== Transmitted Data : =====\n");
				for(i=0; i<RECEIVE_BUFFER_SIZE; i++)
				    printf("%2X",(unsigned char)pMACTxBuffer[i]);
				/*========================================================*/
				printf("\n===== Received Data : =====\n");
                		indk = 0;
				/*========================================================*/
				for(i=0; i<RECEIVE_BUFFER_SIZE; i++)
                    			printf("%2X",(unsigned char)pMACRxBuffer[i]);
				/*========================================================*/
				//*********************************************************
                //OutputFilesSaver(MimoTest);
                //*********************************************************
                printf("\nMAC RX : RTDExReceive -- Byte Recieved on MAC Rx : < %llu > COMPARE TO < %llu> \n",res,RECEIVE_BUFFER_SIZE);
				if( res != RECEIVE_BUFFER_SIZE )
				{
					printf( "\nError RTDEx receiving data.\n"
				           " The program will terminate. Push any key to continue\n" );
				    	_getch();
					Test_Terminate();
				   return -1;
				}
				bytereceivedRxMAC += res;
                
				// Receive data from Bottom FMC
				res = RTDExReceive(hConnStreamingBottomRx, (unsigned char*)(pBottomRxBuffer), RECEIVE_BUFFER_SIZE, eRTDExWaitTimeout, 1000);
				
				printf("\n========= CHANNEL < 1 > ===========\n");
				/*========================================================*/
				printf("\n===== Transmitted Data : =====\n");   
				for(i=0; i<RECEIVE_BUFFER_SIZE; i++)
				    printf("%c",(unsigned char)pBottomTxBuffer[i]);
				/*========================================================*/
				printf("\n===== Received Data : =====\n");
					indk = 0;
				/*========================================================*/ 
				for(i=0; i<RECEIVE_BUFFER_SIZE; i++)
				   printf("%c",(unsigned char)pBottomRxBuffer[i]);
				/*========================================================*/
				//*********************************************************
                //OutputFilesSaver(MimoTest);
                //*********************************************************
				printf("\nBottom RX : RTDExReceive -- Byte Recieved on Bottom Rx : < %llu > COMPARE TO < %llu> \n",res,RECEIVE_BUFFER_SIZE); 
				if( res != RECEIVE_BUFFER_SIZE ) 
				{
					printf( "\nError RTDEx receiving data.\n"
						  " The program will terminate. Push any key to continue\n" );
				   _getch();
					Test_Terminate();
				   return -1;
				}
				bytereceivedRxBot += res;
                
                // Receive data from Top FMC
				res = RTDExReceive(hConnStreamingTopRx, (unsigned char*)(pTopRxBuffer), RECEIVE_BUFFER_SIZE, eRTDExWaitTimeout, 1000);

				printf("\n========= CHANNEL < 2 > ===========\n");                
				/*========================================================*/
				printf("\n===== Transmitted Data : =====\n");
				for(i=0; i<RECEIVE_BUFFER_SIZE; i++)
				    printf("%c",(unsigned char)pTopTxBuffer[i]);
				/*========================================================*/
				printf("\n===== Received Data : =====\n");
                		indk = 0;
				/*========================================================*/
				for(i=0; i<RECEIVE_BUFFER_SIZE; i++)
                    			printf("%c",(unsigned char)pTopRxBuffer[i]);
				/*========================================================*/
				//*********************************************************
                //OutputFilesSaver(MimoTest);
                //*********************************************************

				printf("\nTop RX : RTDExReceive -- Byte Recieved on Top Rx : < %llu > COMPARE TO < %llu> \n",res,RECEIVE_BUFFER_SIZE);                
				if( res != RECEIVE_BUFFER_SIZE )
				{
					printf( "\nError RTDEx receiving data.\n"
                       " The program will terminate. Push any key to continue\n" );
               _getch();
					Test_Terminate();
               return -1;
				}
				bytereceivedRxTop += res;
			}
			//*********************************************************
			//OutputFilesSaver(MimoTest);
			//*********************************************************
			iterations++;
			printf("\n========= ============== ===========\n");
			printf("\nCheck Before Going to the Next Iteration!!\n");
			//_getch();
		   } //End FrTx Loop
		}/* End Loop while(run) */
	}

   //*=============================================================
   //              E N D   O F   S T R E A M I N G    L O O P
   //*=============================================================	
   printf( "\nStreaming complete. \n");
	streamingstop = GetTickCount();
	// disable receiver
	res = BusAccess_WriteReg( hBusAccess, TARGET_CUSTOMREGS_3, 0);

    //*********************************************************
    //OutputFilesSaver(MimoTest);
    //*********************************************************
	
	Test_Terminate();
	//_getch();
	return 0;
}
