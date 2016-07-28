From: Mark Fasheh <mfasheh@suse.de>
Date: Thu, 28 Jul 2016 15:12:04 -0700
Subject: [Ocfs2-devel] [patch 4/5] ocfs2/dlm: solve a BUG when deref
 failed in dlm_drop_lockres_ref
In-Reply-To: <579a73bd.aWzQ0Rkjfu9OwqME%akpm@linux-foundation.org>
References: <579a73bd.aWzQ0Rkjfu9OwqME%akpm@linux-foundation.org>
Message-ID: <20160728221204.GD5316@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jul 28, 2016 at 02:06:05PM -0700, Andrew Morton wrote:
> From: piaojun <piaojun@huawei.com>
> Subject: ocfs2/dlm: solve a BUG when deref failed in dlm_drop_lockres_ref
> 
> We found a BUG situation that lockres is migrated during deref described
> below.  To solve the BUG, we could purge lockres directly when other node
> says I did not have a ref.  Additionally, we'd better purge lockres if
> master goes down, as no one will response deref done.
> 
> Node 1                  Node 2(old master)             Node3(new master)
> dlm_purge_lockres
> send deref to N2
> 
>                         leave domain
>                         migrate lockres to N3
>                                                        finish migration
>                                                        send do assert
>                                                        master to N1
> 
> receive do assert msg
> form N3, but can not
> find lockres because
> DROPPING_REF is set,
> so the owner is still
> N2.
> 
>                         receive deref from N1
>                         and response -EINVAL
>                         because lockres is migrated
> 
> BUG when receive -EINVAL
> in dlm_drop_lockres_ref
> 
> Fixes: 842b90b62461d ("ocfs2/dlm: return in progress if master can not clear the refmap bit right now")
> 
> Link: http://lkml.kernel.org/r/57845103.3070406 at huawei.com
> Signed-off-by: Jun Piao <piaojun@huawei.com>
> Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
> Reviewed-by: Jiufei Xue <xuejiufei@huawei.com>

Reviewed-by: Mark Fasheh <mfasheh@suse.de>

The only thing is I wonder if those ML_NOTICE messages in this patch and
the previous one will cause unnecessary end-user concern.

The fixes though look good, thanks for those.
	--Mark


> Cc: Mark Fasheh <mfasheh@suse.de>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Junxiao Bi <junxiao.bi@oracle.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/ocfs2/dlm/dlmmaster.c |    9 ++++++---
>  fs/ocfs2/dlm/dlmthread.c |   13 +++++++++++--
>  2 files changed, 17 insertions(+), 5 deletions(-)
> 
> diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-solve-a-bug-when-deref-failed-in-dlm_drop_lockres_ref fs/ocfs2/dlm/dlmmaster.c
> --- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-solve-a-bug-when-deref-failed-in-dlm_drop_lockres_ref
> +++ a/fs/ocfs2/dlm/dlmmaster.c
> @@ -2276,9 +2276,12 @@ int dlm_drop_lockres_ref(struct dlm_ctxt
>  		mlog(ML_ERROR, "%s: res %.*s, DEREF to node %u got %d\n",
>  		     dlm->name, namelen, lockname, res->owner, r);
>  		dlm_print_one_lock_resource(res);
> -		BUG();
> -	}
> -	return ret ? ret : r;
> +		if (r == -ENOMEM)
> +			BUG();
> +	} else
> +		ret = r;
> +
> +	return ret;
>  }
>  
>  int dlm_deref_lockres_handler(struct o2net_msg *msg, u32 len, void *data,
> diff -puN fs/ocfs2/dlm/dlmthread.c~ocfs2-dlm-solve-a-bug-when-deref-failed-in-dlm_drop_lockres_ref fs/ocfs2/dlm/dlmthread.c
> --- a/fs/ocfs2/dlm/dlmthread.c~ocfs2-dlm-solve-a-bug-when-deref-failed-in-dlm_drop_lockres_ref
> +++ a/fs/ocfs2/dlm/dlmthread.c
> @@ -175,6 +175,15 @@ static void dlm_purge_lockres(struct dlm
>  	     res->lockname.len, res->lockname.name, master);
>  
>  	if (!master) {
> +		if (res->state & DLM_LOCK_RES_DROPPING_REF) {
> +			mlog(ML_NOTICE, "%s: res %.*s already in "
> +				"DLM_LOCK_RES_DROPPING_REF state\n",
> +				dlm->name, res->lockname.len,
> +				res->lockname.name);
> +			spin_unlock(&res->spinlock);
> +			return;
> +		}
> +
>  		res->state |= DLM_LOCK_RES_DROPPING_REF;
>  		/* drop spinlock...  retake below */
>  		spin_unlock(&res->spinlock);
> @@ -203,8 +212,8 @@ static void dlm_purge_lockres(struct dlm
>  		dlm->purge_count--;
>  	}
>  
> -	if (!master && ret != 0) {
> -		mlog(0, "%s: deref %.*s in progress or master goes down\n",
> +	if (!master && ret == DLM_DEREF_RESPONSE_INPROG) {
> +		mlog(0, "%s: deref %.*s in progress\n",
>  			dlm->name, res->lockname.len, res->lockname.name);
>  		spin_unlock(&res->spinlock);
>  		return;
> _
--
Mark Fasheh
