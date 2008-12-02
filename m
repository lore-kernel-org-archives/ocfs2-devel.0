From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 02 Dec 2008 14:09:15 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix DLM_BADARGS error in
 concurrent file locking
In-Reply-To: <493524C0.4090506@suse.de>
References: <493524C0.4090506@suse.de>
Message-ID: <4935B20B.9040309@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Coly Li wrote:
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index 44f87ca..c777844 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -742,6 +742,19 @@ lookup:
>  			goto lookup;
>  		}
>
> +		/* tmpres might be initiating by another process, in this case
> +		 * we should wait until the initiation done  */
> +		spin_lock(&tmpres->spinlock);
> +		if (tmpres->owner == DLM_LOCK_RES_OWNER_UNKNOWN ||
> +		    (tmpres->state & DLM_LOCK_RES_IN_PROGRESS)) {
> +			__dlm_wait_on_lockres_flags(tmpres, DLM_LOCK_RES_IN_PROGRESS);
> +			spin_unlock(&tmpres->spinlock);
> +			dlm_lockres_put(tmpres);
> +			tmpres = NULL;
> +			goto lookup;
> +		}
> +		spin_unlock(&tmpres->spinlock);
> +
>  		mlog(0, "found in hash!\n");
>  		if (res)
>  			dlm_lockres_put(res);

This will work but we are wasting cycles as we are looking up the same
lockres again. How about the following? The mlog is for testing.

--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -742,6 +742,17 @@ lookup:
                        goto lookup;
                }
 
+               /* wait if lock resource is being mastered by another 
thread */
+               spin_lock(&tmpres->spinlock);
+               if (tmpres->owner == DLM_LOCK_RES_OWNER_UNKNOWN) {
+                       mlog(ML_NOTICE, "%s:%.*s Another thread is 
mastering "
+                            "this resource\n", dlm->name, namelen, lockid);
+                       __dlm_wait_on_lockres_flags(tmpres,
+                                                   
DLM_LOCK_RES_IN_PROGRESS);
+                       BUG_ON(tmpres->owner == DLM_LOCK_RES_OWNER_UNKNOWN);
+               }
+               spin_unlock(&tmpres->spinlock);
+
                mlog(0, "found in hash!\n");
                if (res)
                        dlm_lockres_put(res);

Secondly, the patch comments are more than required. We should prune it
down a bit. Like:

=========================================================================
ocfs2/dlm: Fix lockres mastery race

dlm_get_lock_resource() is supposed to return a lock resource with a proper
master. If multiple concurrent threads attempt to lookup the lockres for the
same lockid, one or more threads are likely to return a lockres without a
proper master, if the lock mastery is underway.

This patch makes the threads wait in dlm_get_lock_resource() while the 
mastery
is underway, ensuring all threads return the lockres with a proper master.

This issue is limited to users using the flock() syscall. For all other fs
operations, dlmglue ensures that only one thread is performing dlm 
operations
for a given lockid at any one time.

Signed-off-by: Coly Li <...>
=========================================================================

Corrections welcome.

Lastly, test the patch not only with the flock() test but also otherwise.
Say, with recovery. Part of fixing bugs is ensuring the fix does not break
existing functionality. Run all multinode tests in ocfs2-test.

Thanks
Sunil
