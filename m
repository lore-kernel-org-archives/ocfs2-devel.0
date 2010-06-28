From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Mon, 28 Jun 2010 09:46:45 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2 fix o2dlm dlm run purgelist(bug
 9094491) -backport to 1.2
In-Reply-To: <3F85066B-F53C-4F1F-8E44-0AD4EEA9DD5C@oracle.com>
References: <201006261134.o5QBKSM7015886@acsinet15.oracle.com>
	<4C279C5F.2080103@oracle.com>
	<20100628011610.GA2331@laptop.us.oracle.com>
	<3F85066B-F53C-4F1F-8E44-0AD4EEA9DD5C@oracle.com>
Message-ID: <20100628014645.GA2364@laptop.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10-06-27 18:31, Sunil Mushran wrote:
> So when backporting, try to keep the patch as is. The aim is to
> ensure the code across trees is as similar as possible. That is not
> to suggest that that function should not be static. But the correct
> procedure is to change mainline. There is a reason for this madness.
> We do this because we want to be able to apply patches easily.
> 
In mainline it's already a static.
I should make it in a seprate patch.

regards,
wengang.
> On Jun 27, 2010, at 6:16 PM, Wengang Wang <wen.gang.wang@oracle.com>
> wrote:
> 
> >On 10-06-27 11:45, Sunil Mushran wrote:
> >>Is it the same patch as targeted for mainline? If so, go ahead.
> >>If not, then please highlight the differences.
> >
> >almost same as the one for mainline. just
> >1) make dlm_purge_lockres() static
> >2) removed the useless declaration of dlm_purge_lockres() from
> >dlmcommon.h
> >
> >regards,
> >wengang.
> >>
> >>On 06/26/2010 04:32 AM, Wengang Wang wrote:
> >>>There are two problems in dlm_run_purgelist
> >>>
> >>>1. If a lockres is found to be in use, dlm_run_purgelist keeps
> >>>trying to purge
> >>>the same lockres instead of trying the next lockres.
> >>>
> >>>2. When a lockres is found unused, dlm_run_purgelist releases
> >>>lockres spinlock
> >>>before setting DLM_LOCK_RES_DROPPING_REF and calls
> >>>dlm_purge_lockres.
> >>>spinlock is reacquired but in this window lockres can get
> >>>reused. This leads
> >>>to BUG.
> >>>
> >>>This patch modifies dlm_run_purgelist to skip lockres if it's
> >>>in use and purge
> >>>next lockres. It also sets DLM_LOCK_RES_DROPPING_REF before
> >>>releasing the
> >>>lockres spinlock protecting it from getting reused.
> >>>
> >>>Signed-off-by: Srinivas Eeda<srinivas.eeda@oracle.com>
> >>>Signed-off-by: Sunil Mushran<sunil.mushran@oracle.com>
> >>>---
> >>>dlmcommon.h |    2 -
> >>>dlmthread.c |   72 +++++++++++++++++++++++++++++-------------------------------
> >>>2 files changed, 35 insertions(+), 39 deletions(-)
> >>>
> >>>diff -upr ocfs2-1.2.9-7/fs/ocfs2/dlm/dlmthread.c
> >>>ocfs2-1.2.9-8/fs/ocfs2/dlm/dlmthread.c
> >>>--- ocfs2-1.2.9-7/fs/ocfs2/dlm/dlmthread.c    2010-06-26
> >>>14:40:32.000000000 +0800
> >>>+++ ocfs2-1.2.9-8/fs/ocfs2/dlm/dlmthread.c    2010-06-26
> >>>18:44:14.000000000 +0800
> >>>@@ -156,29 +156,23 @@ void dlm_lockres_calc_usage(struct dlm_c
> >>>   spin_unlock(&dlm->spinlock);
> >>>}
> >>>
> >>>-int dlm_purge_lockres(struct dlm_ctxt *dlm, struct
> >>>dlm_lock_resource *res)
> >>>+static void dlm_purge_lockres(struct dlm_ctxt *dlm, struct
> >>>dlm_lock_resource *res)
> >>>{
> >>>   int master;
> >>>   int ret = 0;
> >>>
> >>>-    spin_lock(&res->spinlock);
> >>>-    if (!__dlm_lockres_unused(res)) {
> >>>-        __dlm_print_one_lock_resource(res);
> >>>-        spin_unlock(&res->spinlock);
> >>>-        mlog(0, "%s:%.*s: tried to purge but not unused\n",
> >>>-             dlm->name, res->lockname.len, res->lockname.name);
> >>>-        return -ENOTEMPTY;
> >>>-    }
> >>>+    assert_spin_locked(&dlm->spinlock);
> >>>+    assert_spin_locked(&res->spinlock);
> >>>+
> >>>   master = (res->owner == dlm->node_num);
> >>>-    if (!master)
> >>>-        res->state |= DLM_LOCK_RES_DROPPING_REF;
> >>>-    spin_unlock(&res->spinlock);
> >>>
> >>>   mlog(0, "purging lockres %.*s, master = %d\n", res->lockname.len,
> >>>        res->lockname.name, master);
> >>>
> >>>   if (!master) {
> >>>+        res->state |= DLM_LOCK_RES_DROPPING_REF;
> >>>       /* drop spinlock...  retake below */
> >>>+        spin_unlock(&res->spinlock);
> >>>       spin_unlock(&dlm->spinlock);
> >>>
> >>>       spin_lock(&res->spinlock);
> >>>@@ -196,31 +190,35 @@ int dlm_purge_lockres(struct dlm_ctxt *d
> >>>       mlog(0, "%s:%.*s: dlm_deref_lockres returned %d\n",
> >>>            dlm->name, res->lockname.len, res->lockname.name, ret);
> >>>       spin_lock(&dlm->spinlock);
> >>>+        spin_lock(&res->spinlock);
> >>>   }
> >>>
> >>>-    spin_lock(&res->spinlock);
> >>>   if (!list_empty(&res->purge)) {
> >>>       mlog(0, "removing lockres %.*s:%p from purgelist, "
> >>>            "master = %d\n", res->lockname.len, res->lockname.name,
> >>>            res, master);
> >>>       list_del_init(&res->purge);
> >>>-        spin_unlock(&res->spinlock);
> >>>       dlm_lockres_put(res);
> >>>       dlm->purge_count--;
> >>>-    } else {
> >>>-        spin_unlock(&res->spinlock);
> >>>+    }
> >>>+
> >>>+    if (!__dlm_lockres_unused(res)) {
> >>>+        mlog(ML_ERROR, "found lockres %s:%.*s: in use after
> >>>deref\n",
> >>>+             dlm->name, res->lockname.len, res->lockname.name);
> >>>+        __dlm_print_one_lock_resource(res);
> >>>+        BUG();
> >>>   }
> >>>+
> >>>   __dlm_unhash_lockres(res);
> >>>
> >>>   /* lockres is not in the hash now.  drop the flag and wake up
> >>>    * any processes waiting in dlm_get_lock_resource. */
> >>>   if (!master) {
> >>>-        spin_lock(&res->spinlock);
> >>>       res->state&= ~DLM_LOCK_RES_DROPPING_REF;
> >>>       spin_unlock(&res->spinlock);
> >>>       wake_up(&res->wq);
> >>>-    }
> >>>-    return 0;
> >>>+    } else
> >>>+        spin_unlock(&res->spinlock);
> >>>}
> >>>
> >>>static void dlm_run_purge_list(struct dlm_ctxt *dlm,
> >>>@@ -239,18 +237,6 @@ static void dlm_run_purge_list(struct dl
> >>>       lockres = list_entry(dlm->purge_list.next,
> >>>                    struct dlm_lock_resource, purge);
> >>>
> >>>-        /* Status of the lockres *might* change so double
> >>>-         * check. If the lockres is unused, holding the dlm
> >>>-         * spinlock will prevent people from getting and more
> >>>-         * refs on it -- there's no need to keep the lockres
> >>>-         * spinlock. */
> >>>-        spin_lock(&lockres->spinlock);
> >>>-        unused = __dlm_lockres_unused(lockres);
> >>>-        spin_unlock(&lockres->spinlock);
> >>>-
> >>>-        if (!unused)
> >>>-            continue;
> >>>-
> >>>       purge_jiffies = lockres->last_used +
> >>>           msecs_to_jiffies(DLM_PURGE_INTERVAL_MS);
> >>>
> >>>@@ -261,16 +247,28 @@ static void dlm_run_purge_list(struct dl
> >>>            * in tail order, we can stop at the first
> >>>            * unpurgable resource -- anyone added after
> >>>            * him will have a greater last_used value */
> >>>+            spin_unlock(&lockres->spinlock);
> >>>           break;
> >>>       }
> >>>
> >>>-        dlm_lockres_get(lockres);
> >>>-
> >>>-        /* This may drop and reacquire the dlm spinlock if it
> >>>-         * has to do migration. */
> >>>-        if (dlm_purge_lockres(dlm, lockres))
> >>>-            BUG();
> >>>+        /* Status of the lockres *might* change so double
> >>>+         * check. If the lockres is unused, holding the dlm
> >>>+         * spinlock will prevent people from getting and more
> >>>+         * refs on it.
> >>>+         */
> >>>+        unused = __dlm_lockres_unused(lockres);
> >>>+        if (!unused ||
> >>>+            (lockres->state&  DLM_LOCK_RES_MIGRATING)) {
> >>>+            mlog(0, "lockres %s:%.*s: is in use or "
> >>>+                 "being remastered\n", dlm->name,
> >>>+                 lockres->lockname.len, lockres->lockname.name);
> >>>+            list_move_tail(&dlm->purge_list,&lockres->purge);
> >>>+            spin_unlock(&lockres->spinlock);
> >>>+            continue;
> >>>+        }
> >>>
> >>>+        dlm_lockres_get(lockres);
> >>>+        dlm_purge_lockres(dlm, lockres);
> >>>       dlm_lockres_put(lockres);
> >>>
> >>>       /* Avoid adding any scheduling latencies */
> >>>diff -urp ocfs2-1.2.9-7/fs/ocfs2/dlm/dlmcommon.h
> >>>ocfs2-1.2.9-8/fs/ocfs2/dlm/dlmcommon.h
> >>>--- ocfs2-1.2.9-7/fs/ocfs2/dlm/dlmcommon.h    2010-06-26
> >>>14:40:32.000000000 +0800
> >>>+++ ocfs2-1.2.9-8/fs/ocfs2/dlm/dlmcommon.h    2010-06-26
> >>>18:57:19.000000000 +0800
> >>>@@ -753,8 +753,6 @@ void __dlm_lockres_calc_usage(struct dlm
> >>>                 struct dlm_lock_resource *res);
> >>>void dlm_lockres_calc_usage(struct dlm_ctxt *dlm,
> >>>               struct dlm_lock_resource *res);
> >>>-int dlm_purge_lockres(struct dlm_ctxt *dlm,
> >>>-              struct dlm_lock_resource *lockres);
> >>>void dlm_lockres_get(struct dlm_lock_resource *res);
> >>>void dlm_lockres_put(struct dlm_lock_resource *res);
> >>>void __dlm_unhash_lockres(struct dlm_lock_resource *res);
> >>>
> >>>_______________________________________________
> >>>Ocfs2-devel mailing list
> >>>Ocfs2-devel at oss.oracle.com
> >>>http://oss.oracle.com/mailman/listinfo/ocfs2-devel
> >>
