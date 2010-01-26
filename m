From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 25 Jan 2010 19:52:17 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix a misleading variable name
In-Reply-To: <201001221359.o0MDwHkW015414@acsinet15.oracle.com>
References: <201001221359.o0MDwHkW015414@acsinet15.oracle.com>
Message-ID: <20100126035217.GE15982@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jan 22, 2010 at 09:58:04PM +0800, Wengang Wang wrote:
> a local variable "dlm_version" is used as a fs locking version.
> rename it fs_version.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>

This patch is now part of the 'fixes' branch of ocfs2.git.

Joel

> ---
>  fs/ocfs2/stack_o2cb.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ocfs2/stack_o2cb.c b/fs/ocfs2/stack_o2cb.c
> index e49c410..3038c92 100644
> --- a/fs/ocfs2/stack_o2cb.c
> +++ b/fs/ocfs2/stack_o2cb.c
> @@ -277,7 +277,7 @@ static int o2cb_cluster_connect(struct ocfs2_cluster_connection *conn)
>  	u32 dlm_key;
>  	struct dlm_ctxt *dlm;
>  	struct o2dlm_private *priv;
> -	struct dlm_protocol_version dlm_version;
> +	struct dlm_protocol_version fs_version;
>  
>  	BUG_ON(conn == NULL);
>  	BUG_ON(o2cb_stack.sp_proto == NULL);
> @@ -304,18 +304,18 @@ static int o2cb_cluster_connect(struct ocfs2_cluster_connection *conn)
>  	/* used by the dlm code to make message headers unique, each
>  	 * node in this domain must agree on this. */
>  	dlm_key = crc32_le(0, conn->cc_name, conn->cc_namelen);
> -	dlm_version.pv_major = conn->cc_version.pv_major;
> -	dlm_version.pv_minor = conn->cc_version.pv_minor;
> +	fs_version.pv_major = conn->cc_version.pv_major;
> +	fs_version.pv_minor = conn->cc_version.pv_minor;
>  
> -	dlm = dlm_register_domain(conn->cc_name, dlm_key, &dlm_version);
> +	dlm = dlm_register_domain(conn->cc_name, dlm_key, &fs_version);
>  	if (IS_ERR(dlm)) {
>  		rc = PTR_ERR(dlm);
>  		mlog_errno(rc);
>  		goto out_free;
>  	}
>  
> -	conn->cc_version.pv_major = dlm_version.pv_major;
> -	conn->cc_version.pv_minor = dlm_version.pv_minor;
> +	conn->cc_version.pv_major = fs_version.pv_major;
> +	conn->cc_version.pv_minor = fs_version.pv_minor;
>  	conn->cc_lockspace = dlm;
>  
>  	dlm_register_eviction_cb(dlm, &priv->op_eviction_cb);
> -- 
> 1.6.6
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

Life's Little Instruction Book #337

	"Reread your favorite book."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
