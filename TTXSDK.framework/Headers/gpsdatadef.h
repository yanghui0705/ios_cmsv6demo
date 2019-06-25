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
	char szDeviceIP1[32];		//afu  2013-06-16	���Ӷ����ַ����
	char szDeviceIP2[32];
	char szClientIP1[32];
	char szClientIP2[32];
	unsigned short usDevicePort;
	unsigned short usClientPort;
	unsigned short usReserve[2];
}GPSAddrInfo_S;

typedef struct _tagGPSMEDIAFile
{
	char	szFile[228]; 	/*��·�����ļ���*/  // 2015-03-14  256��Ϊ252������uiAlarmType;1���ļ������ж�����͵ı���
							// 2015-04-08  252��Ϊ244������nChnMaskͨ������
							// 2015-4-30	244��Ϊ240�� �����ļ�ƫ����
							// 2015-8-17	240��Ϊ239�� ����¼���ʶ
							// 2016-3-16	239��Ϊ238�� ��������ʶ
							// 2017-3-06	238��Ϊ232�� ����1078Э�����������Դ����,��������,�洢����,������־
							// 2017-4-25	232��Ϊ228�� ���ӱ�����־2,��ǰ������Ϣ����
	int nAlarmFlag1;
	int nAlarmFlag2;		
	char cResourceType;		//0������Ƶ�� 1����Ƶ�� 2����Ƶ
	char cStreamType;		//0���������� 1��������
	char	bStream;		//�Ƿ�Ϊ��ʽ�ļ�����Ϊ��ʽ�ļ�ʱ���ͻ��˻�ʹ�ûطŵķ�ʽ�����ļ�����
	char	bRecording;		//�Ƿ�����¼����ļ���0��ʾû�У�1��ʾ����¼��
	unsigned int nFileOffset;	//�ļ�ƫ����
	unsigned char ucYear;	// 14��ʾ  14��
	unsigned char ucMonth;
	unsigned char ucDay;	
	unsigned char cStoreType;
	int nChnMask;			//ͨ������
	int nAlarmInfo;			//���ļ�Ϊ����ʱ��Ч
	unsigned int uiBegintime;
	unsigned int uiEndtime;
	char	szDevID[GPS_DEV_ID_LEN];			//�豸ID
	int		nChn;
	unsigned int nFileLen;
	int		nFileType;
	int		nLocation;		//λ�ã��豸�ϵ�¼���ļ������Ǵ洢�����ϵ�¼���ļ�
	int		nSvrID;			//�洢������ID����Ϊ�洢�������ϵ��ļ�ʱ��Ч
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
	char	szFile[230]; 	/*��·�����ļ���*/	
	// 2017-3-6 	242��Ϊ234��  ����1078Э�����������Դ����,��������,�洢����,������־
	// 2017-4-25 	234��Ϊ230�� ����1078������־ ��ǰ��nAlarmInfo������
	char cStoreType;			//1�����洢���� 2���ֱ��洢��
	char cReserve;		
	int nAlarmFlag1;
	int nAlarmFlag2;
	char cResourceType;			//0������Ƶ�� 1����Ƶ�� 2����Ƶ
	char cStreamType;			//0���������� 1��������
	// 2016-3-16	243��Ϊ242�� ��������ʶ
	char	bStream;		//�Ƿ�Ϊ��ʽ�ļ�����Ϊ��ʽ�ļ�ʱ���ͻ��˻�ʹ�ûطŵķ�ʽ�����ļ�����
	// 2015-8-17	244��Ϊ243�� ����¼���ʶ
	char	bRecording;		//�Ƿ�����¼����ļ���0��ʾû�У�1��ʾ����¼��
	// 2015-4-30	248��Ϊ244�� �����ļ�ƫ����
	unsigned int nFileOffset;	//�ļ�ƫ����
	//2015-04-08 ԭ����252����Ϊ248������ nChnMask
	int		nChnMask;		//ͨ�����룬ÿ���ļ����ڶ��ͨ��
	//2015-03-14 ԭ����256����Ϊ252������ nAlarmInfo
	int		nAlarmInfo;		//������Ϣ��ÿ���ļ����ܻ��ж������
	//char	szFile[256]; 	/*��·�����ļ���*/
	int		nYear;			
	int		nMonth;
	int		nDay;
	unsigned int uiBegintime;
	unsigned int uiEndtime;
	char	szDevIDNO[32];			//�豸ID
	int		nChn;
	unsigned int nFileLen;
	int		nFileType;
	int		nLocation;		//λ�ã��豸�ϵ�¼���ļ������Ǵ洢�����ϵ�¼���ļ�
	int		nSvrID;			//�洢������ID����Ϊ�洢�������ϵ��ļ�ʱ��Ч
}GPSFile_S, *LPGPSFile_S;

//�ļ���Ϣ
typedef struct _tagGPSRecHead_S
{
	int	nYear;			//��	2013
	int	nMonth;			//��	5
	int nDay;			//��	29
	int nBegHour;		//��ʼʱ��
	int nBegMinute;		
	int nBegSecond;
	unsigned long long u64BegPts;	//�ļ���ʼ��ʱ���
	unsigned int uiTotalMinSecond;	//�ļ���ʱ��������
	unsigned int uiAudioCodec;		//��Ƶ����������	TTX_AUDIO_CODEC_G726_40KBPS
	unsigned int uiAudioChannel;		//��Ƶͨ��
	unsigned int uiAudioSamplesPerSec;	//��Ƶ������
	unsigned int uiAudioBitPerSamples;	//��Ƶÿ��ȡ�������λԪ��
	unsigned int uiInfoCodec;		//��Ϣ֡������	TTX_INFO_CODEC_WKP
	unsigned int uiVideoCodec;		//��Ƶ֡������	TTX_VIDEO_CODEC_H264
	unsigned char ucResolution;		//�ֱ���		TTX_RESOLUTION_720P
	char szReserve[59];		//�����ֶ�
} GPSRecHead_S, *LPGPSRecHead_S;

//¼����Ҳ���
typedef struct _tagGPSRecFileSearchParam
{
	int nChannel;				//ͨ��
	int nYearS;					//��
	int nMonthS;				//��
	int nDayS;					//��
	int nBegTime;				//��ʼʱ��
	int nYearE;					//��
	int nMonthE;				//��
	int nDayE;					//��	
	int nEndTime;				//����ʱ��
	short nRecType;				//¼������
	short nFileAttr;			//�ļ����ԣ�ͼƬ�ļ�����Ϊ¼���ļ�	GPS_FILE_ATTRIBUTE_RECORD(WKPЭ��)
	int nLoc;					//�ļ�λ��
	int nAlarmType;				//��������(WKPЭ��, ���������洢��)
	int nAlarmFlag1;			//������־1		//1078
	int nAlarmFlag2;			//������־2		//1078
	char cResourceType;			//0������Ƶ�� 1����Ƶ�� 2����Ƶ 3;��Ƶ��������Ƶ
	char cStreamType;			//-1:����������������,0��������,1��������
	char cStoreType;			//0:���洢�������ֱ��洢��, 1�����洢���� 2���ֱ��洢��
	char cReserve1;
	char cReserve[32];
}GPSRecFileSearchParam_S, *LPGPSRecFileSearchParam_S;

#pragma pack()

#endif
