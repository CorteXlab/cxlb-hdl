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
*  File        : radio420x_settings.h
*  Description : Functions that setup the Radio420 FMC
*
*                Copyrights Nutaq 2012
*
****************************************************************************/
#ifndef __RADIO420X_SETTINGS_DEFINES__
#define __RADIO420X_SETTINGS_DEFINES__

struct tx_conf_struct
{
   float TX_ACQUISITION_FREQUENCY;
   float TX_CARRIER_FREQUENCY;
   float TXFILTER;
   float TXVGA1;
   float TXVGA2;
   float TXVGA_EXT;
} tx_conf_struct;

struct rx_conf_struct
{
   float RX_ACQUISITION_FREQUENCY;
   float RX_CARRIER_FREQUENCY;
   float RXFILTER;
   float RXVGA1;
   float RXVGA2;
   float RXVGA_LNA;
   float RXVGA_EXT;
} rx_conf_struct;

void get_radio420x_params(const char *filename, const char *radio_card_name, const char *txrx_conf);

int InitRadio420x( adp_handle_bus_access hBusAccess , FMCRADIO_REV revision, unsigned int uFMCPos, unsigned int uCarrierFreq, unsigned int uAcqFreq);
int CalibrateRadio420x( adp_handle_bus_access hBusAccess , FMCRADIO_REV revision, unsigned int uFMCPos, unsigned int uCarrierFreq, unsigned int uAcqFreq);
#endif
