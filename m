From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 31 Jul 2008 14:16:23 -0700
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2: track local alloc state
	via	debugfs
In-Reply-To: <1217536922-28328-4-git-send-email-mfasheh@suse.com>
References: <1217536922-28328-1-git-send-email-mfasheh@suse.com>
	<1217536922-28328-4-git-send-email-mfasheh@suse.com>
Message-ID: <20080731211623.GE14766@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jul 31, 2008 at 01:42:02PM -0700, Mark Fasheh wrote:
> +static void ocfs2_init_la_debug(struct ocfs2_super *osb)
> +{
> +	osb->local_alloc_debug_buf = kmalloc(LA_DEBUG_BUF_SZ, GFP_NOFS);
> +	if (!osb->local_alloc_debug_buf)
> +		return;
> +
> +	osb->local_alloc_debug = debugfs_create_file("local_alloc_stats",
> +						     S_IFREG|S_IRUSR,
> +						     osb->osb_debug_root,
> +						     osb,
> +						     &ocfs2_la_debug_fops);
> +	if (!osb->local_alloc_debug) {
> +		kfree(osb->local_alloc_debug_buf);
> +		osb->local_alloc_debug_buf = NULL;
> +	}
> +}

	I like the way you safely ignore failures here - problems
creating a debug file probably shouldn't fail a mount.  However, I'd say
it warrants an informative printk(), so that someone looking for the
file knows why it is missing.
	Btw, I think we should emulate this approach in the rest of our
debugfs code.  Instead of aborting mounts, we should make it cleanly
fail.  Simplifies the callers too, as they don't have to check errors.

Joel

-- 

"For every complex problem there exists a solution that is brief,
     concise, and totally wrong."
                                        -Unknown

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
