From: Joel Becker <jlbec@evilplan.org>
Date: Tue, 14 Aug 2012 23:41:10 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: skip locks in the blocked list
In-Reply-To: <5029B1E5.4030509@huawei.com>
References: <5029B1E5.4030509@huawei.com>
Message-ID: <20120815064109.GG31083@dhcp-172-17-9-228.mtv.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Aug 14, 2012 at 10:03:17AM +0800, Xue jiufei wrote:
>   A parallel umount on 4 nodes triggered a bug in dlm_process_recovery_date(). Here?s the situation:
>   Receiving MIG_LOCKRES message, A node processes the locks in migratable lockres. It copys lvb from migratable lockres when processing the first valid lock. 
> If there is a lock in the blocked list with the EX level, it triggers the BUG. Since valid lvbs are set when locks are granted with EX or PR levels, locks in 
> the blocked list cannot have valid lvbs. Therefore I think we should skip the locks in the blocked list.
> 
> Signed-off-by: Xuejiufei <xuejiufei@huawei.com>

This patch is now part of the fixes branch of ocfs2.git.

Joel

> ---
>  fs/ocfs2/dlm/dlmrecovery.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
> index 01ebfd0..15d81ad 100644
> --- a/fs/ocfs2/dlm/dlmrecovery.c
> +++ b/fs/ocfs2/dlm/dlmrecovery.c
> @@ -1887,6 +1887,13 @@ static int dlm_process_recovery_data(struct dlm_ctxt *dlm,
>  
>  		if (ml->type == LKM_NLMODE)
>  			goto skip_lvb;
> +		
> +		/*
> +		 * If the lock is in the blocked list it can't have a valid lvb,
> +		 * so skip it
> +		 */
> +		if (ml->list == DLM_BLOCKED_LIST)
> +			goto skip_lvb;
>  
>  		if (!dlm_lvb_is_empty(mres->lvb)) {
>  			if (lksb->flags & DLM_LKSB_PUT_LVB) {
> -- 
> 1.7.9.7

-- 

"There is shadow under this red rock.
 (Come in under the shadow of this red rock)
 And I will show you something different from either
 Your shadow at morning striding behind you
 Or your shadow at evening rising to meet you.
 I will show you fear in a handful of dust."

			http://www.jlbec.org/
			jlbec at evilplan.org
