#ifndef _TTX_AUDIO_API_H_
#define _TTX_AUDIO_API_H_

/******************************************************************************
  Author        : afu
  Created       : 2012/12/25
  Last Modified :
  Description   : 解码库接口定义
  History       :
	  1.	Date        : 2012/12/25
		Author      : afu
		Modification: Created file

******************************************************************************/

#include "ttxtype.h"

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

	
int TTXAUDIO_Initialize();
int TTXAUDIO_UnInitialize(void);

//=============================音频编码====================================//
int TTXAUDIO_OpenAudioEncoder(long* lpAudioEncoder, int nEncType);
int TTXAUDIO_AudioEncoderHead(long lAudioEncoder, char *pOutBuffer, int* lpOutLen);
int TTXAUDIO_AudioEncoderFrame(long lAudioEncoder, char *pInBuffer, int nInLen, char *pOutBuffer, int* lpOutLen);
int TTXAUDIO_CloseAudioEncoder(long lAudioEncoder);

//=============================音频解码====================================//
int TTXAUDIO_OpenAudioDecoder(long* lpAudioDecoder);
int TTXAUDIO_InputVideoHead(long lAudioDecoder, const char* pAudioData, int nDataLen);
int TTXAUDIO_InputAudioHead(long lAudioDecoder, const char* pAudioData, int nDataLen);
int TTXAUDIO_InputAudioData(long lAudioDecoder, const char* pAudioData, int nDataLen, unsigned long long u64Stamp);
int TTXAUDIO_InputAudioFrame(long lAudioDecoder, const char* pAudioData, int nDataLen, unsigned long long u64Stamp);
int TTXAUDIO_ClearAudioData(long lAudioDecoder);
int TTXAUDIO_ClearAudioFrame(long lAudioDecoder, unsigned long long u64Stamp);
int TTXAUDIO_GetAudioWavFormat(long lAudioDecoder, int* lpChannels, int* lpSamplePerSec, int* lpBitPerSample, int* lpWavBufLen);
int TTXAUDIO_GetAudioWavData(long lAudioDecoder, char* pWavBuf, int* pWavLen);
int TTXAUDIO_CloseAudioDecoder(long lAudioDecoder);

#ifdef __cplusplus
};
#endif /* __cplusplus */


#endif

