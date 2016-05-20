From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Fri, 20 May 2016 06:06:40 -0500
Subject: [Ocfs2-devel] [PATCH] ocfs2: insure dlm lockspace is created by
	kernel module
In-Reply-To: <1463731940-13044-2-git-send-email-ghe@suse.com>
References: <1463731940-13044-1-git-send-email-ghe@suse.com>
	<1463731940-13044-2-git-send-email-ghe@suse.com>
Message-ID: <573EEFC0.4090901@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gang He <ghe@suse.com>, mfasheh@suse.com
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org

Looks good.

Reviewed-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

On 05/20/2016 03:12 AM, Gang He wrote:
> This patch will be used to insure the dlm lockspace is created by kernel
> module when mounting a ocfs2 file system. There are two ways to create a
> lockspace, from user space and kernel space, but the same name lockspaces
> probably have different lvblen lengths/flags.
> To avoid this mix using, we add one more flag DLM_LSFL_NEWEXCL, it will make
> sure the dlm lockspace is created by kernel module when mounting.
> Secondly, if a user space program (ocfs2-tools) is running on a file system,
> the user tries to mount this file system in the cluster, DLM module will return
> a -EEXIST or -EPROTO errno, we should give the user a obvious error message,
> then, the user can let that user space tool exit before mounting the file
> system again.
>
> Signed-off-by: Gang He <ghe@suse.com>
> ---
>   fs/ocfs2/stack_user.c | 11 +++++++++--
>   1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
> index ced70c8..c9e828e 100644
> --- a/fs/ocfs2/stack_user.c
> +++ b/fs/ocfs2/stack_user.c
> @@ -1007,10 +1007,17 @@ static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
>   	lc->oc_type = NO_CONTROLD;
>
>   	rc = dlm_new_lockspace(conn->cc_name, conn->cc_cluster_name,
> -			       DLM_LSFL_FS, DLM_LVB_LEN,
> +			       DLM_LSFL_FS | DLM_LSFL_NEWEXCL, DLM_LVB_LEN,
>   			       &ocfs2_ls_ops, conn, &ops_rv, &fsdlm);
> -	if (rc)
> +	if (rc) {
> +		if (rc == -EEXIST || rc == -EPROTO)
> +			printk(KERN_ERR "ocfs2: Unable to create the "
> +				"lockspace %s (%d), because a ocfs2-tools "
> +				"program is running on this file system "
> +				"with the same name lockspace\n",
> +				conn->cc_name, rc);
>   		goto out;
> +	}
>
>   	if (ops_rv == -EOPNOTSUPP) {
>   		lc->oc_type = WITH_CONTROLD;
>

-- 
Goldwyn
