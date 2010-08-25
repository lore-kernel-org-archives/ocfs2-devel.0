From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Wed, 25 Aug 2010 20:31:26 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: dynamically allocate lvb for
 dlm_lock_resource
In-Reply-To: <4C740ADC.9020506@oracle.com>
References: <201008231056.o7N8ClUi002147@rcsinet13.oracle.com>
	<4C740ADC.9020506@oracle.com>
Message-ID: <20100825123126.GA3134@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10-08-24 11:09, Sunil Mushran wrote:
> On 08/21/2010 04:13 PM, Wengang Wang wrote:
> >Not all dlm_lock_resource use lvb. It's a waste of memory for those
> >dlm_lock_resources since lvb is a "char lvb[64];".
> >
> >This patch allocates lvb for dlm_lock_resources who use lvb.
> >
> >Without the patch applied,
> >[wwg at cool linux-2.6]$ egrep "o2dlm_lockres" /proc/slabinfo
> >o2dlm_lockres         42     42    256   32    2 : tunables    0    0    0 : slabdata      2      2      0
> >
> >After patch applied,
> >[wwg at cool linux-2.6]$ egrep "o2dlm_lockres" /proc/slabinfo
> >o2dlm_lockres         42     42    192   21    1 : tunables    0    0    0 : slabdata      2      2      0
> >
> >#that's on i686.
> 
> nice.
> 
> >Signed-off-by: Wengang Wang<wen.gang.wang@oracle.com>
> >---
> >  fs/ocfs2/dlm/dlmast.c    |    2 ++
> >  fs/ocfs2/dlm/dlmcommon.h |    3 ++-
> >  fs/ocfs2/dlm/dlmlock.c   |    6 ++++++
> >  fs/ocfs2/dlm/dlmmaster.c |   31 ++++++++++++++++++++++++++++---
> >  4 files changed, 38 insertions(+), 4 deletions(-)
> >
> >diff --git a/fs/ocfs2/dlm/dlmast.c b/fs/ocfs2/dlm/dlmast.c
> >index f449991..fe272b1 100644
> >--- a/fs/ocfs2/dlm/dlmast.c
> >+++ b/fs/ocfs2/dlm/dlmast.c
> >@@ -191,6 +191,8 @@ static void dlm_update_lvb(struct dlm_ctxt *dlm, struct dlm_lock_resource *res,
> >  			mlog(0, "getting lvb from lockres for %s node\n",
> >  				  lock->ml.node == dlm->node_num ? "master" :
> >  				  "remote");
> >+			mlog_bug_on_msg(!res->lvb, "lockname : %.*s\n",
> >+					res->lockname.len, res->lockname.name);
> >  			memcpy(lksb->lvb, res->lvb, DLM_LVB_LEN);
> >  		}
> 
> Move this to the top of the function. We want to catch this bug as
> early as possible.

It looks we can't move it to the very top.
The caller doesn't make sure we need to update lvb. In other words, it
treat the lockres' that need lvb and those don't the same. We have to
distinguish them in dlm_update_lvb() its self. And I think checking 
DLM_LKSB_GET_LVB flag is the right place to place the assertion.

Or do you meant we should treat different type (lvb needed or no) of
lockress differently in the callers?(though I don't think you meant this)

> 
> >  		/* Do nothing for lvb put requests - they should be done in
> >diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
> >index 4b6ae2c..49e6492 100644
> >--- a/fs/ocfs2/dlm/dlmcommon.h
> >+++ b/fs/ocfs2/dlm/dlmcommon.h
> >@@ -329,7 +329,7 @@ struct dlm_lock_resource
> >  	wait_queue_head_t wq;
> >  	u8  owner;              //node which owns the lock resource, or unknown
> >  	u16 state;
> >-	char lvb[DLM_LVB_LEN];
> >+	char *lvb;
> >  	unsigned int inflight_locks;
> >  	unsigned long refmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
> >  };
> >@@ -1033,6 +1033,7 @@ void dlm_clean_master_list(struct dlm_ctxt *dlm,
> >  int dlm_lock_basts_flushed(struct dlm_ctxt *dlm, struct dlm_lock *lock);
> >  int __dlm_lockres_has_locks(struct dlm_lock_resource *res);
> >  int __dlm_lockres_unused(struct dlm_lock_resource *res);
> >+char *dlm_alloc_lvb(char **lvb);
> >
> >  static inline const char * dlm_lock_mode_name(int mode)
> >  {
> >diff --git a/fs/ocfs2/dlm/dlmlock.c b/fs/ocfs2/dlm/dlmlock.c
> >index 69cf369..5c7ece7 100644
> >--- a/fs/ocfs2/dlm/dlmlock.c
> >+++ b/fs/ocfs2/dlm/dlmlock.c
> >@@ -425,6 +425,12 @@ static void dlm_init_lock(struct dlm_lock *newlock, int type,
> >  	kref_init(&newlock->lock_refs);
> >  }
> >
> >+char *dlm_alloc_lvb(char **lvb)
> >+{
> >+	*lvb = kzalloc(DLM_LVB_LEN, GFP_NOFS);
> >+	return *lvb;
> >+}
> 
> Scrap this function. Do the kzalloc() in dlm_new_lockres() itself.
> This way we do allocs for a lockres in one location.

Actually I alreay have another similar patch which dynamically allocates
lvb for dlm_lock. dlm_alloc_lvb() is used in that patch. So allocating
lvb is in a separated function.
Since the patch for dlm_lock is much more complex than this one, I
didn't post it out together before this one gets approved.

Anyway if you persist, I can make it as you wanted.

regards,
wengang.
