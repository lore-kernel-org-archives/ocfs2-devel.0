From: Eric Ren <zren@suse.com>
Date: Fri, 29 Jan 2016 16:25:11 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: move lock to the tail of grant
 queue while doing in-place convert
In-Reply-To: <56A89345.5040903@huawei.com>
References: <56A89345.5040903@huawei.com>
Message-ID: <20160129082511.GB14315@desktop.lab.bej.apac.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello jiufei,

On Wed, Jan 27, 2016 at 05:52:05PM +0800, xuejiufei wrote: 
> We have found a bug when two nodes doing umount one after another.
> 1) Node 1 migrate a lockres that has 3 locks in grant queue such as
> N2(PR)<->N3(NL)<->N4(PR) to N2. After migration, lvb of the lock N3(NL)
> and N4(PR) are empty on node 2 because migration target do not copy lvb
> to these two lock.
> 2) Node 3 want to convert to PR, it can be granted in
> __dlmconvert_master(), and the order of these locks is unchanged. The
> lvb of the lock N3(PR) on node 2 is copyed from lockres in function
> dlm_update_lvb() while the lvb of lock N4(PR) is still empty.
> 3) Node 2 want to leave domain, it will migrate this lockres to node 3.
> Then node 2 will trigger the BUG in dlm_prepare_lvb_for_migration()
> when adding the lock N4(PR) to mres with the following message because
> the lvb of mres is already copied from lock N3(PR), but the lvb of lock
> N4(PR) is empty.
> 
> "Mismatched lvb in lock cookie=%u:%llu, name=%.*s, node=%u"
> 
> Signed-off-by: xuejiufei <xuejiufei@huawei.com>
> ---
>  fs/ocfs2/dlm/dlmconvert.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/ocfs2/dlm/dlmconvert.c b/fs/ocfs2/dlm/dlmconvert.c
> index e36d63f..ae0c9d1 100644
> --- a/fs/ocfs2/dlm/dlmconvert.c
> +++ b/fs/ocfs2/dlm/dlmconvert.c
> @@ -212,6 +212,12 @@ grant:
>  	if (lock->lksb->flags & DLM_LKSB_PUT_LVB)
>  		memcpy(res->lvb, lock->lksb->lvb, DLM_LVB_LEN);
> 
> +	/*
> +	 * move the lock to tail because it may be the only lock who has
> +	 * a invalid lvb.
> +	 */

I'm not fimiliar with ocfs2/dlm yet, just out of curious, by "invalid lvb"
here it means when a lock has been upconvert in place, its lvb is invalid?
If so, why not reset it than move?

Thanks,
Eric
> +	list_move_tail(&lock->list, &res->granted);
> +
>  	status = DLM_NORMAL;
>  	*call_ast = 1;
>  	goto unlock_exit;
> -- 
> 1.8.4.3
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
