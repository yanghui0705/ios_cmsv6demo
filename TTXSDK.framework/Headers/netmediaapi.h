#ifndef _NET_MEDIA_API_H_
#define _NET_MEDIA_API_H_

#define NETMEDIA_API

#ifndef API_CALL
#define  API_CALL	
#endif

#ifndef CALLBACK
#define CALLBACK
#endif

#include "gpsdatadef.h"

#define NETMEDIA_OK			0
#define NETMEDIA_FALSE		1

#define NETMEDIA_TYPE_VIEWER			0
#define NETMEDIA_TYPE_REC_SVR		1

#define NETMEDIA_REAL_MSG_SUCCESS			0
#define NETMEDIA_REAL_MSG_CNT_DS_FD			-1
#define NETMEDIA_REAL_MSG_USR_NORIGHT		-2
#define NETMEDIA_REAL_MSG_MS_EMPTY			-3
#define NETMEDIA_REAL_MSG_CNT_MS_FD			-4
#define NETMEDIA_REAL_MSG_CNT_MS_SUC			-5
#define NETMEDIA_REAL_MSG_CNT_DEV_FD			-6
#define NETMEDIA_REAL_MSG_CNT_DEV_SUC		-7
#define NETMEDIA_REAL_MSG_MS_DISCONNECT		-8
#define NETMEDIA_REAL_MSG_USR_FULL_ERROR		-9
#define NETMEDIA_REAL_MSG_USR_ERROR			-10
#define NETMEDIA_REAL_MSG_UNKNOW				-11
#define NETMEDIA_REAL_MSG_FINISHED			-12
#define NETMEDIA_REAL_MSG_SESSION_END		-13
#define NETMEDIA_REAL_MSG_DEV_USED			-14
#define NETMEDIA_REAL_MSG_DEV_OFFLINE		-15	
#define NETMEDIA_REAL_MSG_PLAY_FINISHED		-16

#define NETMEDIA_REAL_TYPE_MAIN				0
#define NETMEDIA_REAL_TYPE_SUB				1

#define NETMEDIA_CNT_TYPE_TCP				0
#define NETMEDIA_CNT_TYPE_UDP				1

#define NETMEDIA_REAL_DATA_TYPE_HEAD		1
#define NETMEDIA_REAL_DATA_TYPE_I_FRAME		0x63643030
#define NETMEDIA_REAL_DATA_TYPE_P_FRAME		0x63643130
#define NETMEDIA_REAL_DATA_TYPE_A_FRAME		0x63643230

#define NETMEDIA_AUDIO_MIC_CHANNEL			98

#define NETMEDIA_SEARCH_FINISHED 			99
#define NETMEDIA_SEARCH_FAILED 				100

#define GPS_PTZ_MOVE_LEFT	0
#define GPS_PTZ_MOVE_RIGHT	1
#define GPS_PTZ_MOVE_TOP	2
#define GPS_PTZ_MOVE_BOTTOM	3
#define GPS_PTZ_MOVE_LEFT_TOP       4
#define GPS_PTZ_MOVE_RIGHT_TOP      5
#define GPS_PTZ_MOVE_LEFT_BOTTOM	6
#define GPS_PTZ_MOVE_RIGHT_BOTTOM	7

#define GPS_PTZ_FOCUS_DEL   8
#define GPS_PTZ_FOCUS_ADD 	9
#define GPS_PTZ_LIGHT_DEL   10
#define GPS_PTZ_LIGHT_ADD   11
#define GPS_PTZ_ZOOM_DEL    12
#define GPS_PTZ_ZOOM_ADD    13
#define GPS_PTZ_LIGHT_OPEN	14
#define GPS_PTZ_LIGHT_CLOSE	15
#define GPS_PTZ_WIPER_OPEN	16
#define GPS_PTZ_WIPER_CLOSE	17
#define GPS_PTZ_CRUISE      18
#define GPS_PTZ_MOVE_STOP   19

#define GPS_PTZ_PRESET_MOVE				21
#define GPS_PTZ_PRESET_SET				22
#define GPS_PTZ_PRESET_DEL				23

#define GPS_PTZ_SPEED_MIN				0
#define GPS_PTZ_SPEED_MAX				255

#define GPS_PTZ_SPEED_DEFAULT  128

//�������ͣ�0��ʾ3G��1��ʾWIFI
#define GPS_NET_TYPE_3G		0
#define GPS_NET_TYPE_WIFI	1
#define GPS_NET_TYPE_NET	2

#define GPS_FILE_TYPE_NORMAL					0
#define GPS_FILE_TYPE_ALARM						1
#define GPS_FILE_TYPE_ALL						-1

#define GPS_FILE_LOCATION_DEVICE			1		//�豸
#define GPS_FILE_LOCATION_STOSVR			2		//�洢������
#define GPS_FILE_LOCATION_LOCAL				3		//�ͻ��˱���
#define GPS_FILE_LOCATION_DOWNSVR			4		//���ط�����

#define GPS_FILE_ATTRIBUTE_JPEG				1
#define GPS_FILE_ATTRIBUTE_RECORD			2
///#define GPS_FILE_ATTRIBUTE_ALL				3		//����ʱʹ�ñ�ʾ��������¼���ļ�
#define GPS_FILE_ATTRIBUTE_LOG				4			

#define GPS_DOWNLOAD_MSG_FAILED				1
#define GPS_DOWNLOAD_MSG_BEGIN				2
#define GPS_DOWNLOAD_MSG_FINISHED			3
#define GPS_DOWNLOAD_MSG_PROCESS			4

#pragma pack(4)

#pragma pack(0)

#ifdef __cplusplus
extern "C" {
#endif


NETMEDIA_API int	API_CALL	NETMEDIA_Initialize(const char* szLogPath);
NETMEDIA_API int	API_CALL	NETMEDIA_UnInitialize();

NETMEDIA_API int	API_CALL	NETMEDIA_SetSession(const char* szGUID);
NETMEDIA_API int	API_CALL	NETMEDIA_SetDirSvr(const char* szIP, const char* szLanIP, unsigned short usPort, bool bLanFirst);

//ʵʱԤ��
NETMEDIA_API int	API_CALL	NETMEDIA_OpenRealPlay(const char* szDevIDNO, int nChn, int nMode, int nCntMode, bool bTransmit, long* lpRealHandle);	
NETMEDIA_API int	API_CALL	NETMEDIA_SetRealMsgCallBack(long lRealHandle, void* pUsr, void (CALLBACK *FUNRealMsgCB)(int nMsg, void* pUsr));
NETMEDIA_API int	API_CALL	NETMEDIA_SetUserInfo(long lRealHandle, const char* szUser, const char* szPwd);
NETMEDIA_API int	API_CALL	NETMEDIA_SetRealAddress(long lRealHandle, const char* szIP, unsigned short usPort);
NETMEDIA_API int	API_CALL	NETMEDIA_SetAutoSelect(long lRealHandle, bool bAutoSelect);
NETMEDIA_API int	API_CALL	NETMEDIA_SetRealSession(long lRealHandle, const char* szSession);
NETMEDIA_API int	API_CALL	NETMEDIA_StartRealPlay(long lRealHandle, bool bDec);
NETMEDIA_API int	API_CALL	NETMEDIA_StopRealPlay(long lRealHandle);
NETMEDIA_API int	API_CALL	NETMEDIA_GetRPlayStatus(long lRealHandle);
NETMEDIA_API int	API_CALL	NETMEDIA_GetRPlayHandle(long lRealHandle, long *lpPlayHandle);
NETMEDIA_API int	API_CALL	NETMEDIA_GetRPlayImage(long lRealHandle, int nRgbLen, char* pRgbBuf, int* pSize, int nRgbFormat);
NETMEDIA_API int	API_CALL	NETMEDIA_GetWavFormat(long lRealHandle, int* lpChannels, int* lpSamplePerSec, int* lpBitPerSample, int* lpWavBufLen);
NETMEDIA_API int	API_CALL	NETMEDIA_GetWavData(long lRealHandle, char* pWavBuf, int* pWavLen);
NETMEDIA_API int	API_CALL	NETMEDIA_SetStreamMode(long lRealHandle, int nMode);
NETMEDIA_API int	API_CALL	NETMEDIA_SetDelayTime(long lRealHandle, unsigned long ulMinMinsecond, unsigned long ulMaxMinsecond);
//szRecPath = "/mnt/xxx"
NETMEDIA_API int	API_CALL	NETMEDIA_StartRecord(long lRealHandle, const char* szRecPath, const char* szDevName);
NETMEDIA_API int    API_CALL    NETMEDIA_GetFileFullPath(long lRealHandle, char*szfullPath);
NETMEDIA_API int	API_CALL	NETMEDIA_StopRecord(long lRealHandle);
NETMEDIA_API int	API_CALL	NETMEDIA_PlaySound(long lRealHandle, bool bPlay);
NETMEDIA_API int	API_CALL	NETMEDIA_SetVolume(long lRealHandle, unsigned short usVolume);
NETMEDIA_API int	API_CALL	NETMEDIA_CaptureBMP(long lRealHandle, const char* szBmpFile);
NETMEDIA_API int	API_CALL	NETMEDIA_GetFlowRate(long lRealHandle, int* lpFlowRate);
NETMEDIA_API int	API_CALL	NETMEDIA_RPlayPtzCtrl(long lRealHandle, int nCommand, int nSpeed, int nParam);
NETMEDIA_API int	API_CALL	NETMEDIA_CloseRealPlay(long lRealHandle);

//˫��Խ�
NETMEDIA_API int	API_CALL	NETMEDIA_TBOpenTalkback(const char* szDevIDNO, int nChn, int nCntMode, long* lpTalkbackHandle);	
NETMEDIA_API int	API_CALL	NETMEDIA_TBSetRealServer(long lTalkbackHandle, const char* szIP, unsigned short usPort, const char* szSession);	
NETMEDIA_API int	API_CALL	NETMEDIA_TBSetSession(long lTalkbackHandle, const char* szSession);
NETMEDIA_API int	API_CALL	NETMEDIA_TBSetTalkbackMsgCallBack(long lTalkbackHandle, void* pUsr, void (CALLBACK *FUNRealMsgCB)(int nMsg, void* pUsr));
NETMEDIA_API int	API_CALL	NETMEDIA_TBStartTalkback(long lTalkbackHandle);
NETMEDIA_API int	API_CALL	NETMEDIA_TBStopTalkback(long lTalkbackHandle);
NETMEDIA_API int	API_CALL	NETMEDIA_TBGetStatus(long lTalkbackHandle);
NETMEDIA_API int	API_CALL	NETMEDIA_TBGetStop(long lTalkbackHandle);
NETMEDIA_API int    API_CALL    NETMEDIA_TBSetAudioEncodeAAC(long lTalkbackHandle, int forceType);
NETMEDIA_API int	API_CALL	NETMEDIA_TBSendWavData(long lTalkbackHandle, char* pWavBuf, int nWavLen);
NETMEDIA_API int	API_CALL	NETMEDIA_TBGetWavFormat(long lTalkbackHandle, int* lpChannels, int* lpSamplePerSec, int* lpBitPerSample, int* lpWavBufLen);
NETMEDIA_API int	API_CALL	NETMEDIA_TBGetWavData(long lTalkbackHandle, char* pWavBuf, int* pWavLen);
NETMEDIA_API int	API_CALL	NETMEDIA_TBCloseTalkback(long lTalkbackHandle);
// ����
NETMEDIA_API int	API_CALL	NETMEDIA_MTOpenMonitor(const char* szDevIDNO, int nChn, int nCntMode, long* lpMonitorHandle);
NETMEDIA_API int	API_CALL	NETMEDIA_MTSetRealServer(long lMonitorHandle, const char* szIP, unsigned short usPort, const char* szSession);
NETMEDIA_API int	API_CALL	NETMEDIA_MTSetSession(long lMonitorHandle, const char* szSession);
NETMEDIA_API int	API_CALL	NETMEDIA_MTSetMonitorMsgCallBack(long lMonitorHandle, void* pUsr, void (CALLBACK *FUNRealMsgCB)(int nMsg, void* pUsr));
NETMEDIA_API int	API_CALL	NETMEDIA_MTStartMonitor(long lMonitorHandle);
NETMEDIA_API int	API_CALL	NETMEDIA_MTStopMonitor(long lMonitorHandle);
NETMEDIA_API int	API_CALL	NETMEDIA_MTGetStatus(long lMonitorHandle);
NETMEDIA_API int	API_CALL	NETMEDIA_MTGetWavFormat(long lMonitorHandle, int* lpChannels, int* lpSamplePerSec, int* lpBitPerSample, int* lpWavBufLen);
NETMEDIA_API int	API_CALL	NETMEDIA_MTGetWavData(long lMonitorHandle, char* pWavBuf, int* pWavLen);
NETMEDIA_API int	API_CALL	NETMEDIA_MTCloseMonitor(long lMonitorHandle);


//ǰ��ץ��
NETMEDIA_API int	API_CALL	NETMEDIA_SNOpenSnapshot(long* lpSnapshot, const char* szDevIDNO, int nChn);
NETMEDIA_API int	API_CALL	NETMEDIA_SNSetRealServer(long lSnapshotHandle, const char* szIP, unsigned short usPort, const char* szSession);	
NETMEDIA_API int	API_CALL	NETMEDIA_SNSetSnapMsgCB(long lSnapshotHandle, void* pUsr
													   , void (CALLBACK *FUNMsgCB)(int nMsg, void* pUsr));
NETMEDIA_API int	API_CALL	NETMEDIA_SNSetSnapDataCB(long lSnapshotHandle, void* pUsr
														, void (CALLBACK *FUNDataCB)(const char* pBuf, int nLen, long nPos, void* pUsr));
NETMEDIA_API int	API_CALL	NETMEDIA_SNStartSnapshot(long lSnapshotHandle);
NETMEDIA_API int	API_CALL	NETMEDIA_SNStopSnapshot(long lSnapshotHandle);
NETMEDIA_API int	API_CALL	NETMEDIA_SNCloseSnapshot(long lSnapshotHandle);	

//�ļ�������ͼƬ����¼���ļ���
NETMEDIA_API int	API_CALL	NETMEDIA_SFOpenSrchFile(long* lpSearchHandle, const char* szDevIDNO, int nLocation, int nAttributenFile);
NETMEDIA_API int	API_CALL	NETMEDIA_SFSetRealServer(long lSearchHandle, const char* szIP, unsigned short usPort, const char* szSession);	
NETMEDIA_API int	API_CALL	NETMEDIA_SFSetSession(long lSearchHandle, const char* szSession);
//NETMEDIA_API int	API_CALL	NETMEDIA_SFSetSearchMsgCB(long lSearchHandle, void* pUsr
//														   , void (CALLBACK *FUNMsgCB)(int nMsg, int nParam, void* pUsr));
//NETMEDIA_API int	API_CALL	NETMEDIA_SFGetSearchMsg(long lSearchHandle, int* lpMsg, int* lpParam);
//NETMEDIA_API int	API_CALL	NETMEDIA_SFSetSearchFileCB(long lSearchHandle, void* pUsr
//															, void (CALLBACK *FUNFileCB)(GPSFile_S* pFile, void* pUsr));
//szFileInfo: 	szFile[256]:nYear:nMonth:nDay:uiBegintime:uiEndtime:szDevIDNO:nChn:nFileLen:nFileType:nLocation:nSvrID
NETMEDIA_API int	API_CALL	NETMEDIA_SFGetSearchFile(long lSearchHandle, char* szFileInfo, int nLength);
NETMEDIA_API int	API_CALL	NETMEDIA_SFStartSearchFile(long lSearchHandle, int nYear, int nMonth, int nDay
															, int nRecType, int nChn, int nBegTime, int nEndTime);
NETMEDIA_API int	API_CALL	NETMEDIA_SFStartSearchFileMoreEx(long lSearchHandle, GPSRecFileSearchParam_S* pParam);
NETMEDIA_API int	API_CALL	NETMEDIA_SFStopSearchFile(long lSearchHandle);
NETMEDIA_API int	API_CALL	NETMEDIA_SFCloseSearchFile(long lSearchHandle);	

//=============================�ļ�������ͼƬ����¼���ļ���====================================//
NETMEDIA_API int	API_CALL	NETMEDIA_DFOpenDownFile(long* lpDownHandle, int nAttribute);
NETMEDIA_API int	API_CALL	NETMEDIA_DFSetRealServer(long lDownHandle, const char* szIP, unsigned short usPort, const char* szSession);	
NETMEDIA_API int	API_CALL	NETMEDIA_DFSetDFileMsgCB(long lDownHandle, void* pUsr
														  , void (CALLBACK *FUNMsgCB)(int nMsg, int nParam, void* pUsr));
NETMEDIA_API int	API_CALL	NETMEDIA_DFGetDFileMsg(long lDownHandle, int* lpMsg, int* lpParam);
//ȡ�ļ��������ݣ���λKByte
NETMEDIA_API int	API_CALL	NETMEDIA_DFGetFlowRate(long lDownHandle, int* lpFlowRate);
//�����ط�ʽ����׷�����أ��߱��ϵ�̴�����
//szFileInfo: 	szFile[256]:nYear:nMonth:nDay:uiBegintime:uiEndtime:szDevIDNO:nChn:nFileLen:nFileType:nLocation:nSvrID
NETMEDIA_API int	API_CALL	NETMEDIA_DFStartDownFile(long lDownHandle, const char* szFileInfo, char* szDownFile);
NETMEDIA_API int	API_CALL	NETMEDIA_DFStopDownFile(long lDownHandle);
NETMEDIA_API int	API_CALL	NETMEDIA_DFCloseDownFile(long lDownHandle);

//Զ�̻طŽӿ� PB = PlayBack
NETMEDIA_API int	API_CALL	NETMEDIA_PBOpenPlayBack(long* lpPlaybackHandle, const char* szTempPath);	
NETMEDIA_API int	API_CALL	NETMEDIA_PBSetRealServer(long lPlaybackHandle, const char* szIP, unsigned short usPort, const char* szSession);	
NETMEDIA_API int	API_CALL	NETMEDIA_PBSetSession(long lPlaybackHandle, const char* szSession);
NETMEDIA_API int	API_CALL	NETMEDIA_PBSetPlayMsgCallBack(long lPlaybackHandle, void* pUsr, void (CALLBACK *FUNRealMsgCB)(int nMsg, void* pUsr));
NETMEDIA_API int	API_CALL	NETMEDIA_PBGetPlayMsg(long lPlaybackHandle, int* lpMsg);
NETMEDIA_API int	API_CALL	NETMEDIA_PBStartPlayback(long lPlaybackHandle, const char* szFileInfo, int nPlayChannel, int nBegMinSecond, int nEndMinSecond
														 , bool bPlayOnlyIFrame);
//NETMEDIA_API int	API_CALL	NETMEDIA_PBAdjustedWndRect(long lPlaybackHandle);
NETMEDIA_API int	API_CALL	NETMEDIA_PBStopPlayback(long lPlaybackHandle);
NETMEDIA_API int	API_CALL	NETMEDIA_PBGetRPlayStatus(long lPlaybackHandle);
NETMEDIA_API int	API_CALL	NETMEDIA_PBGetRPlayImage(long lPlaybackHandle, int nRgbLen, char* pRgbBuf, int* pSize, int nRgbFormat);
NETMEDIA_API int	API_CALL	NETMEDIA_PBGetWavData(long lPlaybackHandle, char* pWavBuf, int* pWavLen);
//ȡ�ļ��������ݣ���λKByte
NETMEDIA_API int	API_CALL	NETMEDIA_PBGetFlowRate(long lPlaybackHandle, int* lpFlowRate);
//��������
NETMEDIA_API int	API_CALL	NETMEDIA_PBPlaySound(long lPlaybackHandle, long lPlay);
NETMEDIA_API int	API_CALL	NETMEDIA_PBSetVolume(long lPlaybackHandle, unsigned short wVolume);
//��ͣ
NETMEDIA_API int	API_CALL	NETMEDIA_PBPause(long lPlaybackHandle, bool bPause);
//�϶�
NETMEDIA_API int	API_CALL	NETMEDIA_PBSetPlayTime(long lPlaybackHandle, int nMinSecond);
//����ֻ��I֡
NETMEDIA_API int	API_CALL	NETMEDIA_PBSetPlayIFrame(long lPlaybackHandle, bool bIFrame);
//ȡ�ò��ŵ�����
NETMEDIA_API int	API_CALL	NETMEDIA_PBGetPlayTime(long lPlaybackHandle, int* lpMinSecond);
//ȡ����������
NETMEDIA_API int	API_CALL	NETMEDIA_PBGetDownTime(long lPlaybackHandle, int* lpMinSecond);
//ץ��ͼƬ
NETMEDIA_API int	API_CALL	NETMEDIA_PBCaptureBMP(long lPlaybackHandle, const char* szBmpFile);
//�Ƿ񲥷Ž���
NETMEDIA_API int	API_CALL	NETMEDIA_PBIsPlayFinished(long lPlaybackHandle);
//�Ƿ��������
NETMEDIA_API int	API_CALL	NETMEDIA_PBIsDownFinished(long lPlaybackHandle);
//�ر�Զ�̻ط�
NETMEDIA_API int	API_CALL	NETMEDIA_PBClosePlayback(long lPlaybackHandle);


//�ж����豸�Ƿ���ͬһ�����ϣ��˽ӿڻ���1����ʱ
//@szDevIPΪ�����豸��ַ
NETMEDIA_API int	API_CALL	NETMEDIA_IsSameNetwork(const char* szDevIDNO, char* szDevIP, int* port);

//�豸����
NETMEDIA_API int	API_CALL	NETMEDIA_SDOpenSearch(long* lpSearchHandle);
//szDevInfoΪDevIDNO:NetType(0=Wifi, 1=Net):IP:DevType:chn
NETMEDIA_API int	API_CALL	NETMEDIA_SDGetSearchResult(long lSearchHandle, char* szDevInfo, int nLength);
NETMEDIA_API int	API_CALL	NETMEDIA_SDStartSearch(long lSearchHandle, const char* szIp, unsigned short usPort);
NETMEDIA_API int	API_CALL	NETMEDIA_SDStopSearch(long lSearchHandle);
NETMEDIA_API int	API_CALL	NETMEDIA_SDCloseSearch(long lSearchHandle);
NETMEDIA_API int	API_CALL	NETMEDIA_SDConfigWifi(const char* szIp, unsigned short usPort, const char* szUsr, const char* szPwd, const char* szDevIDNO, const char* szWifiSsid, const char* szWifiPwd);

//���豸���Ϳ���ָ��
NETMEDIA_API int	API_CALL	NETMEDIA_MCOpenControl(long* lpControl, const char* szSession, bool bAutoSelect, unsigned int uiTimeoutMinSecond);	
//��ת�ͷ�ת�ӿ�
NETMEDIA_API int	API_CALL	NETMEDIA_MCSendCtrl(long lControl, const char* szDevIDNO, int nCtrlType);
NETMEDIA_API int	API_CALL	NETMEDIA_MCGetResult(long lControl, char* szResult, int nLength);
NETMEDIA_API int	API_CALL	NETMEDIA_MCCloseControl(long lControl);	

#ifdef __cplusplus
}
#endif

#endif

