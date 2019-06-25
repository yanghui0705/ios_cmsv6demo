#ifndef _TTX_MUTEX_H_
#define _TTX_MUTEX_H_


/******************************************************************************
  File Name     : ttxmutex
  Version       : Initial Draft
  Author        : afu
  Created       : 2011-5
  Last Modified :
  Description   : 实现互斥锁功能
  Function List :
  History       :
  1.Date        : 2011-5
    Author      : afu
    Modification: Created file
    
******************************************************************************/

#include "ttxtypedef.h"
#include "ttxpublic.h"

#ifdef WIN32
#else
#include <pthread.h>
#endif

class CTtxMutex
{
public:
    CTtxMutex();
    virtual ~CTtxMutex();

private:
    CTtxMutex(const CTtxMutex &);
    CTtxMutex &operator = (const CTtxMutex &);

public:
    void Lock();
    void Unlock();
private:
#ifdef WIN32
	CRITICAL_SECTION m_mutex;
#else
    pthread_mutex_t m_mutex;
#endif
};

class CTtxAutoLock
{
public:
    CTtxAutoLock(CTtxMutex& Mutex);
    virtual ~CTtxAutoLock();

public:
    void Release()
    {
        if (m_pMutex != NULL)
        {
            m_pMutex->Unlock();
            m_pMutex = NULL;
        }
    }

private:
    CTtxAutoLock();
    CTtxAutoLock(const CTtxAutoLock &);
    CTtxMutex &operator = (const CTtxAutoLock &);

private:
    CTtxMutex *m_pMutex;
};

#endif
