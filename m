From: Mark Fasheh <mfasheh@suse.de>
Date: Thu, 28 Jul 2016 14:57:21 -0700
Subject: [Ocfs2-devel] [patch 1/5] ocfs2: ensure that dlm lockspace is
 created by kernel module
In-Reply-To: <579a73b4.UvdhRu1jgG1MmrgX%akpm@linux-foundation.org>
References: <579a73b4.UvdhRu1jgG1MmrgX%akpm@linux-foundation.org>
Message-ID: <20160728215721.GB5316@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jul 28, 2016 at 02:05:56PM -0700, Andrew Morton wrote:
> From: Gang He <ghe@suse.com>
> Subject: ocfs2: ensure that dlm lockspace is created by kernel module
> 
> We encountered a bug from the customer, the user did a fsck.ocfs2 on the
> file system and exited unusually, the lockspace (with LVB size = 32) was
> left in the kernel space, next, the user mounted this file system, the
> kernel module did not create a new lockspace (LVB size = 64) via calling
> dlm_new_lockspace() function in mounting stage, just used the existing
> lockspace, created by the user space tool, this would lead the user was
> not able to mount this file system from the other nodes, with the error
> message like:
> 
> dlm: 032F5......: config mismatch: 64,0 nodeid 177127961: 32,0
> (mount.ocfs2,26981,46):ocfs2_dlm_init:2995 ERROR: status = -71
> ocfs2_mount_volume:1881 ERROR: status = -71
> ocfs2_fill_super:1236 ERROR: status = -71
> 
> The user found it very difficult to find the root cause, then, we brought
> out this patch to relieve such problem.  
> 
> First, we add one more flag in calling dlm_new_lockspace() function, to
> make sure the lockspace is created by kernel module itself, and this
> change will not affect the backward compatibility.
> 
> Second, the obvious error message is reported in the kernel log, let the
> user be more easy to find the root cause.
> 
> 
> 
> This patch will be used to insure the dlm lockspace is created by kernel
> module when mounting a ocfs2 file system.  There are two ways to create a
> lockspace, from user space and kernel space, but the same name lockspaces
> probably have different lvblen lengths/flags.
> 
> To avoid this mix using, we add one more flag DLM_LSFL_NEWEXCL, it will
> make sure the dlm lockspace is created by kernel module when mounting. 
> Secondly, if a user space program (ocfs2-tools) is running on a file
> system, the user tries to mount this file system in the cluster, DLM
> module will return a -EEXIST or -EPROTO errno, we should give the user a
> obvious error message, then, the user can let that user space tool exit
> before mounting the file system again.

I really like that we're printing a clear message for the user. I'm
concerned about a couple things though:

Gang - did you check that *online* userspace tools can still work on a
mounted cluster with this change? I ask because this isn't the first time
this issue has come up and if my memory hasn't faded too much we had
problems with userspace/kernel interactions when we tried to fix it. In
particular if the kernel says the lockspace is now exclusive, does that mean
userspace will not be allowed to join, even if it doesn't use the lvb?

Actually, how does this interact with dlmfs? We won't be allowed to join
domains from dlmfs effectively gutting the ocfs2-tools ability to query the
cluster. In particualr see this blurb in libocfs2/dlm.c:

        /*
         * We want to use dlmfs if we can, as it provides the full feature
         * set of libo2dlm.  Any dlmfs with the 'stackglue' capability will
         * support all cluster stacks.  An empty cluster.c_stack means
         * o2cb, which always supports dlmfs.
         *
         * If we're unlucky enough to have older userspace stack code,
         * we pass NULL to avoid dlmfs.
         */

Thanks,
	--Mark


> 
> Link: http://lkml.kernel.org/r/1463731940-13044-2-git-send-email-ghe at suse.com
> Signed-off-by: Gang He <ghe@suse.com>
> Reviewed-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> Cc: Mark Fasheh <mfasheh@suse.de>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Junxiao Bi <junxiao.bi@oracle.com>
> Cc: Joseph Qi <joseph.qi@huawei.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/ocfs2/stack_user.c |   11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff -puN fs/ocfs2/stack_user.c~ocfs2-insure-dlm-lockspace-is-created-by-kernel-module fs/ocfs2/stack_user.c
> --- a/fs/ocfs2/stack_user.c~ocfs2-insure-dlm-lockspace-is-created-by-kernel-module
> +++ a/fs/ocfs2/stack_user.c
> @@ -1007,10 +1007,17 @@ static int user_cluster_connect(struct o
>  	lc->oc_type = NO_CONTROLD;
>  
>  	rc = dlm_new_lockspace(conn->cc_name, conn->cc_cluster_name,
> -			       DLM_LSFL_FS, DLM_LVB_LEN,
> +			       DLM_LSFL_FS | DLM_LSFL_NEWEXCL, DLM_LVB_LEN,
>  			       &ocfs2_ls_ops, conn, &ops_rv, &fsdlm);
> -	if (rc)
> +	if (rc) {
> +		if (rc == -EEXIST || rc == -EPROTO)
> +			printk(KERN_ERR "ocfs2: Unable to create the "
> +				"lockspace %s (%d), because a ocfs2-tools "
> +				"program is running on this file system "
> +				"with the same name lockspace\n",
> +				conn->cc_name, rc);
>  		goto out;
> +	}
>  
>  	if (ops_rv == -EOPNOTSUPP) {
>  		lc->oc_type = WITH_CONTROLD;
> _
--
Mark Fasheh
