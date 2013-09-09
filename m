From: Mark Fasheh <mfasheh@suse.de>
Date: Mon, 9 Sep 2013 14:54:23 -0700
Subject: [Ocfs2-devel] [PATCH 6/6] Disallow cluster_stack changes if fs
	are mounted
In-Reply-To: <20130906032932.GA4192@shrek.lan>
References: <20130906032932.GA4192@shrek.lan>
Message-ID: <20130909215423.GF31381@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Sep 05, 2013 at 10:29:37PM -0500, Goldwyn Rodrigues wrote:
> diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
> index c953290..9eeeff03 100644
> --- a/fs/ocfs2/stackglue.h
> +++ b/fs/ocfs2/stackglue.h
> @@ -291,6 +291,9 @@ int ocfs2_plock(struct ocfs2_cluster_connection *conn, u64 ino,
>  
>  void ocfs2_stack_glue_set_max_proto_version(struct ocfs2_protocol_version *max_proto);
>  
> +void ocfs2_inc_mount_count(void);
> +void ocfs2_dec_mount_count(void);
> +
>  
>  /* Used by stack plugins */
>  int ocfs2_stack_glue_register(struct ocfs2_stack_plugin *plugin);
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 60f3d8e..c91087c 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1214,6 +1214,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>  
>  	/* Start this when the mount is almost sure of being successful */
>  	ocfs2_orphan_scan_start(osb);
> +	ocfs2_inc_mount_count();
>  
>  	return status;
>  
> @@ -1253,6 +1254,7 @@ static void ocfs2_kill_sb(struct super_block *sb)
>  	spin_unlock(&dentry_list_lock);
>  	/* Wait for work to finish and/or remove it */
>  	cancel_work_sync(&osb->dentry_lock_work);
> +	ocfs2_dec_mount_count();
>  out:
>  	kill_block_super(sb);
>  }

Why not put these calls in ocfs2_dlm_init() and ocfs2_dlm_shutdown() ?
	--Mark

--
Mark Fasheh
