From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed Mar  5 11:05:49 2008
Subject: [Ocfs2-devel] [PATCH 05/12] ocfs2/dlm: Dump the dlm state in a
	debugfs file
In-Reply-To: <1204678200-26237-6-git-send-email-sunil.mushran@oracle.com>
References: <1204678200-26237-1-git-send-email-sunil.mushran@oracle.com>
	<1204678200-26237-6-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080305190545.GD799@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Mar 04, 2008 at 04:49:53PM -0800, Sunil Mushran wrote:
> This patch dumps the dlm state (dlm_ctxt) into a debugfs file.

> Useful for debugging.
> +/* files in subroot */
> +int dlm_debug_init(struct dlm_ctxt *dlm)
> +{
> +#ifdef CONFIG_DEBUG_FS
> +	struct dlm_debug_ctxt *dc = dlm->dlm_debug_ctxt;
> +
> +	/* for dumping dlm_ctxt */
> +	dc->debug_state_dentry = debugfs_create_file(DLM_DEBUGFS_DLM_STATE,
> +						     S_IFREG|S_IRUSR,
> +						     dlm->dlm_debugfs_subroot,
> +						     dlm, &debug_state_fops);
> +	if (!dc->debug_state_dentry) {
> +		mlog_errno(-ENOMEM);
> +		goto bail;
> +	}
> +
> +	dlm_debug_get(dc);
> +	return 0;
> +
> +bail:
> +	dlm_debug_shutdown(dlm);
> +	return -ENOMEM;
> +#endif
> +	return 0;
> +}

	Here again you could move the no-debugfs case to an inline in
dlmdebug.h.

Joel

-- 

"Time is an illusion, lunchtime doubly so."
        -Douglas Adams

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
