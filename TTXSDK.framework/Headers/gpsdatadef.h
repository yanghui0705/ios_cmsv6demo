#ifndef _GPS_DATA_DEF_H_
#define _GPS_DATA_DEF_H_

#define GPS_DEV_ID_LEN						32


#define GPS_FRM_TYPE_HEAD						1
#define GPS_FRM_TYPE_I							0x63643000
#define GPS_FRM_TYPE_P							0x63643100
#define GPS_FRM_TYPE_A							0x63643200
#define GPS_FRM_TYPE_INFO						0x63643900
#define GPS_FRM_TYPE_REC_HDR					2


#pragma pack(4)

typedef struct _tagGPSAddrInfo
{
	char szLanIP[64];
	char szDeviceIP1[32];		//afu  2013-06-16	增加多个地址配置
	char szDeviceIP2[32];
	char szClientIP1[32];
	char szClientIP2[32];
	unsigned short usDevicePort;
	unsigned short usClientPort;
	unsigned short usReserve[2];
}GPSAddrInfo_S;

typedef struct _tagGPSMEDIAFile
{
	char	szFile[228]; 	/*带路径的文件名*/  // 2015-03-14  256变为252，增加uiAlarmType;1个文件可能有多个类型的报警
							// 2015-04-08  252变为244，增加nChnMask通道掩码
							// 2015-4-30	244变为240， 增加文件偏移量
							// 2015-8-17	240变为239， 增加录像标识
							// 2016-3-16	239变为238， 增加流标识
							// 2017-3-06	238变为232， 增加1078协议上需求的资源类型,码流类型,存储类型,报警标志
							// 2017-4-25	232变为228， 增加报警标志2,以前报警信息不动
	int nAlarmFlag1;
	int nAlarmFlag2;		
	char cResourceType;		//0：音视频， 1：音频， 2：视频
	char cStreamType;		//0：主码流， 1：子码流
	char	bStream;		//是否为流式文件，当为流式文件时，客户端会使用回放的方式进行文件下载
	char	bRecording;		//是否正在录像的文件，0表示没有，1表示正在录像
	unsigned int nFileOffset;	//文件偏移量
	unsigned char ucYear;	// 14表示  14年
	unsigned char ucMonth;
	unsigned char ucDay;	
	unsigned char cStoreType;
	int nChnMask;			//通道掩码
	int nAlarmInfo;			//当文件为报警时有效
	unsigned int uiBegintime;
	unsigned int uiEndtime;
	char	szDevID[GPS_DEV_ID_LEN];			//设备ID
	int		nChn;
	unsigned int nFileLen;
	int		nFileType;
	int		nLocation;		//位置，设备上的录像文件，还是存储服务上的录像文件
	int		nSvrID;			//存储服务器ID，在为存储服务器上的文件时有效
}GPSMEDIAFile_S, *LPGPSMEDIAFile_S;

typedef struct _tagGPSDEVUpgradeFile
{
	char szVersion[32];
	int	nDevType;
	int nFileLength;
}GPSDEVUpgradeFile_S, *LPGPSDEVUpgradeFile_S;

typedef struct _tagGPSServerInfo
{
	int nID;
	char szIDNO[32];
	char szName[32];
	int nGroup;
	GPSAddrInfo_S	Addr;
}GPSServerInfo_S, *LPGPSServerInfo_S;

typedef struct _tagGPSServerAddr
{
	int nSvrID;
	GPSAddrInfo_S Addr;
}GPSServerAddr_S, *LPGPSServerAddr_S;

typedef struct _tagGPSFile
{
	char	szFile[230]; 	/*带路径的文件名*/	
	// 2017-3-6 	242变为234，  增加1078协议上需求的资源类型,码流类型,存储类型,报警标志
	// 2017-4-25 	234变为230， 增加1078报警标志 以前的nAlarmInfo不共用
	char cStoreType;			//1：主存储器， 2：灾备存储器
	char cReserve;		
	int nAlarmFlag1;
	int nAlarmFlag2;
	char cResourceType;			//0：音视频， 1：音频， 2：视频
	char cStreamType;			//0：主码流， 1：子码流
	// 2016-3-16	243变为242， 增加流标识
	char	bStream;		//是否为流式文件，当为流式文件时，客户端会使用回放的方式进行文件下载
	// 2015-8-17	244变为243， 增加录像标识
	char	bRecording;		//是否正在录像的文件，0表示没有，1表示正在录像
	// 2015-4-30	248变为244， 增加文件偏移量
	unsigned int nFileOffset;	//文件偏移量
	//2015-04-08 原来是252，变为248，增加 nChnMask
	int		nChnMask;		//通道掩码，每个文件存在多个通道
	//2015-03-14 原来是256，变为252，增加 nAlarmInfo
	int		nAlarmInfo;		//报警信息，每个文件可能会有多个报警
	//char	szFile[256]; 	/*带路径的文件名*/
	int		nYear;			
	int		nMonth;
	int		nDay;
	unsigned int uiBegintime;
	unsigned int uiEndtime;
	char	szDevIDNO[32];			//设备ID
	int		nChn;
	unsigned int nFileLen;
	int		nFileType;
	int		nLocation;		//位置，设备上的录像文件，还是存储服务上的录像文件
	int		nSvrID;			//存储服务器ID，在为存储服务器上的文件时有效
}GPSFile_S, *LPGPSFile_S;

//文件信息
typedef struct _tagGPSRecHead_S
{
	int	nYear;			//年	2013
	int	nMonth;			//月	5
	int nDay;			//日	29
	int nBegHour;		//开始时间
	int nBegMinute;		
	int nBegSecond;
	unsigned long long u64BegPts;	//文件起始的时间戳
	unsigned int uiTotalMinSecond;	//文件总时长，毫秒
	unsigned int uiAudioCodec;		//音频解码器类型	TTX_AUDIO_CODEC_G726_40KBPS
	unsigned int uiAudioChannel;		//音频通道
	unsigned int uiAudioSamplesPerSec;	//音频采样率
	unsigned int uiAudioBitPerSamples;	//音频每个取样所需的位元数
	unsigned int uiInfoCodec;		//信息帧解码器	TTX_INFO_CODEC_WKP
	unsigned int uiVideoCodec;		//视频帧解码器	TTX_VIDEO_CODEC_H264
	unsigned char ucResolution;		//分辨率		TTX_RESOLUTION_720P
	char szReserve[59];		//保留字段
} GPSRecHead_S, *LPGPSRecHead_S;

//录像查找参数
typedef struct _tagGPSRecFileSearchParam
{
	int nChannel;				//通道
	int nYearS;					//年
	int nMonthS;				//月
	int nDayS;					//日
	int nBegTime;				//开始时间
	int nYearE;					//年
	int nMonthE;				//月
	int nDayE;					//日	
	int nEndTime;				//结束时间
	short nRecType;				//录像类型
	short nFileAttr;			//文件属性，图片文件或者为录像文件	GPS_FILE_ATTRIBUTE_RECORD(WKP协议)
	int nLoc;					//文件位置
	int nAlarmType;				//报警类型(WKP协议, 报警联动存储的)
	int nAlarmFlag1;			//报警标志1		//1078
	int nAlarmFlag2;			//报警标志2		//1078
	char cResourceType;			//0：音视频， 1：音频， 2：视频 3;视频或者音视频
	char cStreamType;			//-1:主码流或者子码流,0：主码流,1：子码流
	char cStoreType;			//0:主存储器或者灾备存储器, 1：主存储器， 2：灾备存储器
	char cReserve1;
	char cReserve[32];
}GPSRecFileSearchParam_S, *LPGPSRecFileSearchParam_S;

#pragma pack()

#endif
