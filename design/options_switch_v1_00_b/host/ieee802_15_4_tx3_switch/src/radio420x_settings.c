/****************************************************************************   
 * 
 *    ****                              I                                     
 *   ******                            ***                                    
 *   *******                           ****                                   
 *   ********    ****  ****     **** *********    ******* ****    *********** 
 *   *********   ****  ****     **** *********  **************  ************* 
 *   **** *****  ****  ****     ****   ****    *****    ****** *****     **** 
 *   ****  ***** ****  ****     ****   ****   *****      ****  ****      **** 
 *  ****    *********  ****     ****   ****   ****       ****  ****      **** 
 *  ****     ********  ****    ****I  ****    *****     *****  ****      **** 
 *  ****      ******   ***** ******   *****    ****** *******  ****** ******* 
 *  ****        ****   ************    ******   *************   ************* 
 *  ****         ***     ****  ****     ****      *****  ****     *****  **** 
 *                                                                       **** 
 *          I N N O V A T I O N  T O D A Y  F O R  T O M M O R O W       **** 
 *                                                                        ***       
 * 
 ************************************************************************//** 
*
*  Project     : Radio420 example
*  File        : radio420x_settings.c
*  Description : Functions that setup the Radio420 FMC
*
*                Copyrights Nutaq 2012
*
****************************************************************************/

#ifdef __linux__
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <strings.h>
#include <Nutaq/adp_types.h>
#include <Nutaq/adp_media_types.h>
#include <Nutaq/eapi_fmcradio.h>
#include <Nutaq/fmc_radio.h>
#include <Nutaq/fmc_radio_defines.h>
#include <Nutaq/eapi.h>
#include <Nutaq/memory_map.h>
//#include <Nutaq/address_map.h>
#include <Nutaq/adp_bus_access_media_types.h>
#include <Nutaq/adp_bus_access_types.h>
#include <Nutaq/adp_bus_access.h>
#include <radio420x_settings.h>
#include <Nutaq/lms6002_defines.h>
#endif

#define TX_NUM_PARAM 6
#define RX_NUM_PARAM 7
#define PARAM_LENGTH 64

const char TX_PARMAS_DICT[TX_NUM_PARAM][PARAM_LENGTH] = {"TX_CARRIER_FREQUENCY","TX_ACQUISITION_FREQUENCY","TXFILTER","TXVGA1","TXVGA2","TXVGA_EXT"};

const char RX_PARMAS_DICT[RX_NUM_PARAM][PARAM_LENGTH] = {"RX_CARRIER_FREQUENCY","RX_ACQUISITION_FREQUENCY","RXFILTER","RXVGA1","RXVGA2","RXVGA_LNA","RXVGA_EXT"};


float get_param_val(const char *filename,const char *paramname)
{
     FILE *pFile;
     char buffer[PARAM_LENGTH];
     float Val;

     pFile = fopen(filename,"r");
     if(pFile==0)
       fprintf(stderr,"Error Opening File : %s\n",strerror(errno));
     while(!feof(pFile))
     {
       fscanf(pFile,"%s %f",buffer,&Val);
       if(!strcasecmp(buffer,paramname))
         break;
     }
     fclose(pFile);
     return(Val);
}


/*TX_PARAMS tx_conf_struct_Radio2x2[2];*/

void get_radio420x_params(const char *filename, const char *radio_card_name, const char *txrx_conf) /*int id_radio_card)*/
{
     char param_name[PARAM_LENGTH];
     float param_val[PARAM_LENGTH];
     int cnt = 0;
     printf("#####- %s::%s -#####\n",radio_card_name,txrx_conf);
     if(!strcasecmp(txrx_conf,"tx"))
     {
       for(cnt=0;cnt<TX_NUM_PARAM;cnt++){
         sprintf(param_name,"%s_%s",radio_card_name,TX_PARMAS_DICT[cnt]);
         printf("#0%d : %s = %f\n", cnt,param_name,get_param_val(filename,param_name)); 
	 param_val[cnt] = get_param_val(filename,param_name);    
       } 
	tx_conf_struct.TX_ACQUISITION_FREQUENCY = param_val[0];
	tx_conf_struct.TX_CARRIER_FREQUENCY = param_val[1];
	tx_conf_struct.TXFILTER = param_val[2];
	tx_conf_struct.TXVGA1 = param_val[3];
	tx_conf_struct.TXVGA2 = param_val[4];
	tx_conf_struct.TXVGA_EXT = param_val[5];
     }     
     else if(!strcasecmp(txrx_conf,"rx"))
     {
       for(cnt=0;cnt<RX_NUM_PARAM;cnt++){
         sprintf(param_name,"%s_%s",radio_card_name,RX_PARMAS_DICT[cnt]);
         printf("#0%d : %s = %f\n", cnt,param_name,get_param_val(filename,param_name));  
	 param_val[cnt] = get_param_val(filename,param_name);    
       }
	rx_conf_struct.RX_ACQUISITION_FREQUENCY = param_val[0];
	rx_conf_struct.RX_CARRIER_FREQUENCY = param_val[1];
	rx_conf_struct.RXFILTER = param_val[2];
	rx_conf_struct.RXVGA1 = param_val[3];
	rx_conf_struct.RXVGA2 = param_val[4];
	rx_conf_struct.RXVGA_LNA = param_val[5];
	rx_conf_struct.RXVGA_EXT = param_val[6];
     }
     else if(!strcasecmp(txrx_conf,"txrx"))
     {
       for(cnt=0;cnt<TX_NUM_PARAM;cnt++){
         sprintf(param_name,"%s_%s",radio_card_name,TX_PARMAS_DICT[cnt]);
         printf("#0%d : %s = %f\n", cnt,param_name,get_param_val(filename,param_name));  
	 param_val[cnt] = get_param_val(filename,param_name);    
       }
	tx_conf_struct.TX_ACQUISITION_FREQUENCY = param_val[0];
	tx_conf_struct.TX_CARRIER_FREQUENCY = param_val[1];
	tx_conf_struct.TXFILTER = param_val[2];
	tx_conf_struct.TXVGA1 = param_val[3];
	tx_conf_struct.TXVGA2 = param_val[4];
	tx_conf_struct.TXVGA_EXT = param_val[5];

       for(cnt=0;cnt<RX_NUM_PARAM;cnt++){
         sprintf(param_name,"%s_%s",radio_card_name,RX_PARMAS_DICT[cnt]);
         printf("#0%d : %s = %f\n", cnt,param_name,get_param_val(filename,param_name)); 
	 param_val[cnt] = get_param_val(filename,param_name);     
       }
	rx_conf_struct.RX_ACQUISITION_FREQUENCY = param_val[0];
	rx_conf_struct.RX_CARRIER_FREQUENCY = param_val[1];
	rx_conf_struct.RXFILTER = param_val[2];
	rx_conf_struct.RXVGA1 = param_val[3];
	rx_conf_struct.RXVGA2 = param_val[4];
	rx_conf_struct.RXVGA_LNA = param_val[5];
	rx_conf_struct.RXVGA_EXT = param_val[6];
     }
     else
       fprintf(stderr,"Unsuported Option (must be <tx> or <rx>) : %s\n",strerror(errno));
}

unsigned int uPoweredUp = 0;

// This function initializes the fmc radio module for 943MHz external source
int InitRadio420x( adp_handle_bus_access hBusAccess , FMCRADIO_REV revision, unsigned int uFMCPos, unsigned int uCarrierFreq, unsigned int uAcqFreq)
{
    adp_result_t res;
    connection_state state;
	cdce62005_param param;
	int pllstatus = 0;
	FMCRADIOSDR_FILTER_BANK filter;
	lms6002_pll_param param1;
	unsigned int uRefFreq = 0;
	unsigned int uLimeFreq = 0;
	unsigned int uTxFreq = uCarrierFreq;
	unsigned int uRxFreq = uCarrierFreq + 1000000;

    if (revision == FMCRADIOREVSDR_B || revision == FMCRADIOREVSDR_A)
	{
		uRefFreq = FMC_RADIO_SDR_REVB_REFERENCE_CLOCK;
		uLimeFreq = FMC_RADIO_SDR_REVB_LIME_CLOCK;
	}
    else if (revision == FMCRADIOREVSDR_C || revision == FMCRADIOREVSDR_D)
	{
		uRefFreq = FMC_RADIO_SDR_REVC_REFERENCE_CLOCK;
		uLimeFreq = FMC_RADIO_SDR_REVC_LIME_CLOCK;
	}
    else
	{
		printf("Error: Erroneous board revision\r\n");
		return -1;
	}

    res = BusAccess_GetConnectionState( hBusAccess, &state);    
    if(res != 0)
    {
		printf("Error: Could not retrieve connection state\r\n");
		return res;
    }

	res = fmc_radio_select_send(&state, uFMCPos);
    if( res != 0 )
    {
		printf("Error: Could not select fmc card\r\n");
		return res;
    }

	res = fmc_radio_setrevision_send(&state, revision);
    if( res != 0 )
    {
		printf("Error: Could not set revision\r\n");
		return res;
    }

    res = fmc_radio_presence(&state);
    if( res != 0 )
    {
		printf("Error: Could detect Radi420 presence\r\n");
		return res;
    }
	printf("    Radio420 core detected\r\n");

    // fmcradio_powerup
	if (uPoweredUp == 0)
	{
		printf("    Powering up hardware\r\n");
		res = fmc_radio_powerup_send(&state);
		if( res != 0 )
		{
			printf("Error: Could not power up radio\r\n");
			return res;
		}
		uPoweredUp = 1;
	}

	printf("    Resetting hardware\r\n");
    // fmcradio_reset
	res = fmc_radio_sdr_reset_send(&state);
    if( res != 0 )
    {
		printf("Error: Could not reset radio\r\n");
		return res;
    }


	printf("    Configuring PLL\r\n");
	res = fmc_radio_pll_calculate(&param, uRefFreq, uAcqFreq, uLimeFreq);
    if( res != 0 )
    {
		printf("Error: Could not calculate pll parameters\r\n");
        return res;
    }
    
	if(uFMCPos == 2)
	{
		param.secondary_clock = 1;
		printf("      - Reference frequency %d Hz from external connector\r\n", uRefFreq);
	}
	else
	{
		printf("      - Reference frequency %d Hz from internal reference\r\n", uRefFreq);
	}
	
	printf("      - Acquisition frequency %d Hz\r\n", uAcqFreq);
	printf("      - Lime frequency %d Hz \r\n", uLimeFreq);

	res = fmc_radio_pll_setparam_send(&state, &param);
    if( res != 0 )
    {
		printf("Error: Could not write pll parameters\r\n");
        return res;
    }
	if(param.vco_bypass_all == 1)
	{
		printf("    PLL is set in bypass\r\n");
	}
	else
	{
    //  fmcradio_pll_lock
		res = fmc_radio_pll_lockstatus_send(&state, &pllstatus);
		if( res != 0 )
		{
			printf("Error: Could not read pll status\r\n");
			return res;
		}
		 // Check if the pll is locked
		if( pllstatus != CDCE62005_PLL_LOCKED )
		{
			printf("Error: PLL is not locked\r\n");
			//return res;
		}
		else
		{
			printf("    PLL is locked\r\n");
		}
	}


    // fmcradio_filter 943MHZ
    if (revision == FMCRADIOREVSDR_B || revision == FMCRADIOREVSDR_A)
	{
		filter = FMCRADIOSDR_REVB_FILTER_NONE;
	}
    else if (revision == FMCRADIOREVSDR_C || revision == FMCRADIOREVSDR_D)
	{
        filter = FMCRADIOSDR_REVC_FILTER_BYPASS;
	}
    else
	{
		printf("Error: Erroneous board revision\r\n");
		return res;
	}

	res = fmc_radio_sdr_setrxfilter_send(&state, filter);
    if( res != 0 )
    {
		printf("Error: Could not set rx filter\r\n");
		//return res;
    }

	printf("    Configuring Gains\r\n");
	   // fmcradio_tx -15 5 0
	//res = fmc_radio_tx_gain_send(&state,-17,5,-4);
	//res = fmc_radio_tx_gain_send(&state,-15,6,-3);
	printf("#    TXVGA1 = %f\n",tx_conf_struct.TXVGA1);
	printf("#    TXVGA2 = %f\n",tx_conf_struct.TXVGA2);
	printf("# TXVGA_EXT = %f\n",tx_conf_struct.TXVGA_EXT);
	res = fmc_radio_tx_gain_send(&state,tx_conf_struct.TXVGA1,tx_conf_struct.TXVGA2,tx_conf_struct.TXVGA_EXT);
    if( res != 0 )
    {
		printf("Error: Could not set tx gain\r\n");
		//return res;
    }

    // fmcradio_rx 0 -5
    // fmcradio_rx_gain(LMS6002_LNA_MIDGAIN, LMS_VGA1_GAIN19DB, 0, -5)
    //res = fmc_radio_sdr_rx_gain_send(&state,LMS6002_LNA_MIDGAIN, LMS_VGA1_GAIN5DB, 0, -8);
    res = fmc_radio_sdr_rx_gain_send(&state,rx_conf_struct.RXVGA_LNA, rx_conf_struct.RXVGA1, rx_conf_struct.RXVGA2, rx_conf_struct.RXVGA_EXT);
    if( res != 0 )
    {
		printf("Error: Could not set rx gain\r\n");
		//return res;
    }


	printf("    Configuring Lime PLL\r\n");
	if(uTxFreq > 1500000000)
	{
		// fmcradio_band high
		printf("      - Using high band\r\n");
		res = fmc_radio_sdr_band_send(&state, FMC_RADIO_SDR_HIGH_BAND);
		if( res != 0 )
		{
			printf("Error: Could not set SDR band\r\n");
			//return res;
		}
	}
	else
	{
		// fmcradio_band lowu
		printf("      - Using low band\r\n");
		res = fmc_radio_sdr_band_send(&state, FMC_RADIO_SDR_LOW_BAND);
		if( res != 0 )
		{
			printf("Error: Could not set SDR band\r\n");
			//return res;
		}
	}

	// fmcradio_lpf rx 2.5MHZ
	res = fmc_radio_lpf_set_send(&state, LMS6002_TX, LMS6002_LPF_2DOT5MHZ);
    if( res != 0 )
    {
		printf("Error: Could not set RX low-pass filter\r\n");
		//return res;
    }

	res = fmc_radio_lpf_set_send(&state, LMS6002_RX, LMS6002_LPF_2DOT5MHZ);
    if( res != 0 )
    {
		printf("Error: Could not set RX low-pass filter\r\n");
		//return res;
    }
	printf("      - RX carrier frequency %u Hz\r\n", uRxFreq);
	printf("      - TX carrier frequency %u Hz \r\n", uTxFreq);

    // fmcradio_lime_pll rx 30000000 944000000
	res = fmc_radio_lime_calculate(&param1, uLimeFreq, uRxFreq);
    if( res != 0 )
    {
		printf("Error: Could not calculate rx lime pll parameters. Invalid configuration\r\n");
		//return res;
    }

	res = fmc_radio_lime_setpllparam_send(&state, LMS6002_RX, &param1);
    if( res != 0 )
    {
		printf("Error: Could not set lime rx pll param\r\n");
		//return res;
    }

    res = fmc_radio_lime_calibratePLL_send(&state, LMS6002_RX);
    if( res != 0 )
    {
		printf("Error: Could not calibrate lime rx pll\r\n");
		//return res;
    }
	
	  // fmcradio_lime_pll rx 30000000 944000000
	res = fmc_radio_lime_calculate(&param1, uLimeFreq, uTxFreq);
    if( res != 0 )
    {
		printf("Error: Could not calculate rx lime pll parameters. Invalid configuration\r\n");
		//return res;
    }

	res = fmc_radio_lime_setpllparam_send(&state, LMS6002_TX, &param1);
    if( res != 0 )
    {
		printf("Error: Could not set lime rx pll param\r\n");
		//return res;
    }

    res = fmc_radio_lime_calibratePLL_send(&state, LMS6002_TX);
    if( res != 0 )
    {
		printf("Error: Could not calibrate lime rx pll\r\n");
		//return res;
    }
	
	res = fmc_radio_lpf_calibrate_send(&state, LMS6002_TXRX, uRefFreq);
    if( res != 0 )
    {
		printf("Error: Could not calibrate low pass filter\r\n");
		//return res;
    }

	res = fmc_radio_rxvga_calibrate_send(&state);
    if( res != 0 )
    {
		printf("Error: Could not calibrate RXVGA\r\n");
		//return res;
    }

    return 0;
}

int CalibrateRadio420x( adp_handle_bus_access hBusAccess , FMCRADIO_REV revision, unsigned int uFMCPos, unsigned int uCarrierFreq, unsigned int uAcqFreq)
{
    adp_result_t res;
    connection_state state;
	cdce62005_param param;
	int pllstatus = 0;
	lms6002_ssb_calib ssb_calib;		
	lms6002_lo_leakage_calib lo_calib;	
	lms6002_rx_dc_calib rxdc_calib;
	lms6002_pll_param param1;
	unsigned int uTxFreq = uCarrierFreq;
	unsigned int uRxFreq = uCarrierFreq + 1000000;
	unsigned int uRefFreq = 0;
	unsigned int uLimeFreq = 0;

    if (revision == FMCRADIOREVSDR_B || revision == FMCRADIOREVSDR_A)
	{
		uRefFreq = FMC_RADIO_SDR_REVB_REFERENCE_CLOCK;
		uLimeFreq = FMC_RADIO_SDR_REVB_LIME_CLOCK;
	}
    else if (revision == FMCRADIOREVSDR_C || revision == FMCRADIOREVSDR_D)
	{
		uRefFreq = FMC_RADIO_SDR_REVC_REFERENCE_CLOCK;
		uLimeFreq = FMC_RADIO_SDR_REVC_LIME_CLOCK;
	}
    else
	{
		printf("Error: Erroneous board revision\r\n");
		return -1;
	}

    res = BusAccess_GetConnectionState( hBusAccess, &state);    
    if(res != 0)
    {
		printf("Error: Could not retrieve connection state\r\n");
		return res;
    }
	
	printf("Executing RF Calibration\r\n");
	printf("  - LO leakage calibration\r\n");

	res = fmc_radio_select_send(&state, uFMCPos);
	res = fmc_radio_lo_leakage_calibration_send(&state, uCarrierFreq, uAcqFreq, &lo_calib);
	if( res != 0 )
	{
		printf("Error: Could not calibrate lo leakage %x\r\n",res) ;
		//return res;
	}

	printf("  - SSB calibration\r\n");
	res = fmc_radio_ssb_calibration_send(&state, uCarrierFreq, uAcqFreq, &ssb_calib);
	if( res != 0 )
	{
		printf("Error: Could not calibrate ssb %x\r\n",res) ;
		//return res;
	}

	
	 // fmcradio_pll for REV C
	res = fmc_radio_pll_calculate(&param, uRefFreq, uAcqFreq, uLimeFreq);
    if( res != 0 )
    {
		printf("Error: Could not calculate pll parameters\r\n");
        return res;
    }

	if(uFMCPos == 2)
	{
		param.secondary_clock = 1;
	}
	res = fmc_radio_pll_setparam_send(&state, &param);
	if( res != 0 )
	{
		printf("Error: Could not write pll parameters %x\r\n",res) ;
		return res;
	}

	if(param.vco_bypass_all == 1)
	{
		printf("PLL is set in bypass\r\n");
	}
	else
	{
	//  fmcradio_pll_lock
		res = fmc_radio_pll_lockstatus_send(&state, &pllstatus);
		if( res != 0 )
		{
			printf("Error: Could not read pll status %x\r\n",res) ;
			return res;
		}
		 // Check if the pll is locked
		if( pllstatus != CDCE62005_PLL_LOCKED )
		{
			printf("Error: PLL is not locked\r\n");
			//return res;
		}
		else
		{
			printf("PLL is locked\r\n");
		}
	}

	//res = fmc_radio_sdr_rx_gain_send(&state,LMS6002_LNA_MIDGAIN, LMS_VGA1_GAIN19DB, 0, -5);
        res = fmc_radio_sdr_rx_gain_send(&state,rx_conf_struct.RXVGA_LNA, rx_conf_struct.RXVGA1, rx_conf_struct.RXVGA2, rx_conf_struct.RXVGA_EXT);
	if( res != 0 )
	{
		printf("Error: Could not set rx gain %x\r\n",res) ;
		//return res;
	}

	// fmcradio_tx -15 5 0
	//res = fmc_radio_tx_gain_send(&state,-17,5,-4);
	//res = fmc_radio_tx_gain_send(&state,-15,6,-3);
	printf("#    TXVGA1 = %f\n",tx_conf_struct.TXVGA1);
	printf("#    TXVGA2 = %f\n",tx_conf_struct.TXVGA2);
	printf("# TXVGA_EXT = %f\n",tx_conf_struct.TXVGA_EXT);
	res = fmc_radio_tx_gain_send(&state,tx_conf_struct.TXVGA1,tx_conf_struct.TXVGA2,tx_conf_struct.TXVGA_EXT);
	//res = fmc_radio_tx_gain_send(&state,-17,5,-4);
	if( res != 0 )
	{
		printf("Error: Could not set tx gain %x\r\n",res) ;
		//return res;
	}

	  // fmcradio_lime_pll rx 30000000 943000000
	res = fmc_radio_lime_calculate(&param1, uLimeFreq, uRxFreq);
    if( res != 0 )
    {
		printf("Error: Could not calculate rx lime pll parameters. Invalid configuration\r\n");
		//return res;
    }

	res = fmc_radio_lime_setpllparam_send(&state, LMS6002_RX, &param1);
    if( res != 0 )
    {
		printf("Error: Could not set lime rx pll param\r\n");
		//return res;
    }

    res = fmc_radio_lime_calibratePLL_send(&state, LMS6002_RX);
    if( res != 0 )
    {
		printf("Error: Could not calibrate lime rx pll\r\n");
		//return res;
    }


	// fmcradio_rxvga_calibrate
	res = fmc_radio_rxvga_calibrate_send(&state);
	if( res != 0)
	{
		printf("Error: Could not set calibrate rxvga %x\r\n",res) ;
		//return res;
	}
	res = fmc_radio_lpf_calibrate_send(&state, LMS6002_TXRX, uRefFreq);
    if( res != 0 )
    {
		printf("Error: Could not set RX low-pass filter\r\n");
		//return res;
    }
	res = fmc_radio_rx_dc_offset_calibration_send(&state,  &rxdc_calib);
	if( res != 0 )
	{
		printf("Error: Could not calibrate rx dc offset %x\r\n",res) ;
		//return res;
	}

	
    return 0;
}
