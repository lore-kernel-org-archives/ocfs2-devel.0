From: Wengang Wang <wen.gang.wang@ORACLE.COM>
Date: Tue, 8 Jun 2010 20:49:21 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: cancel the migration or redo
 deref to recovery master
In-Reply-To: <4C0851AF.1030803@oracle.com>
References: <4C0851AF.1030803@oracle.com>
Message-ID: <20100608124921.GA3964@laptop.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10-06-03 18:06, Srinivas Eeda wrote:
> Comments inline
> 
> On 6/3/2010 9:37 AM, Wengang Wang wrote:
> >Changes to V1:
> >1 move the msleep to the second runs when the lockres is in recovery so the
> >  purging work on other lockres' can go.
> >2 do not inform recovery master if DLM_LOCK_RES_DROPPING_REF is set and don't
> >  resend deref in this case.
> >
> >Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> >---
> > fs/ocfs2/dlm/dlmcommon.h   |    1 +
> > fs/ocfs2/dlm/dlmrecovery.c |   25 +++++++++++++++
> > fs/ocfs2/dlm/dlmthread.c   |   73 ++++++++++++++++++++++++++++++++++++++-----
> > 3 files changed, 90 insertions(+), 9 deletions(-)
> >
> >diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
> >index 4b6ae2c..4194087 100644
> >--- a/fs/ocfs2/dlm/dlmcommon.h
> >+++ b/fs/ocfs2/dlm/dlmcommon.h
> >@@ -280,6 +280,7 @@ static inline void __dlm_set_joining_node(struct dlm_ctxt *dlm,
> > #define DLM_LOCK_RES_IN_PROGRESS          0x00000010
> > #define DLM_LOCK_RES_MIGRATING            0x00000020
> > #define DLM_LOCK_RES_DROPPING_REF         0x00000040
> >+#define DLM_LOCK_RES_DE_DROP_REF          0x00000080
> Can you please explain the idea of the new flag DLM_LOCK_RES_DE_DROP_REF :)
> 

Discussed with Srini privately, both agreed we don't purge a lockres
when it's in recovery state avoiding adding the new flag.

I will send the revised patch later.

regards,
wengang.
