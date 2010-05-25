From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Tue, 25 May 2010 10:50:04 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2/dlm: resend deref to new master
 if recovery occures
In-Reply-To: <20100525020114.GA9173@laptop.us.oracle.com>
References: <4BFAD7F4.3000705@oracle.com>
	<20100525020114.GA9173@laptop.us.oracle.com>
Message-ID: <20100525025004.GB9173@laptop.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

> > delay deref message if DLM_LOCK_RES_RECOVERING is set (which means
> > recovery got to the lockres before dlm_thread could), move the
> > lockres to the end of the purgelist and retry later.

If you meant checking before sending DEREF, it could cause a high cpu
useage when there are only the ones in recovery left in the purge list
until they are recovered. --Is that acceptable?

regards,
wengang.
