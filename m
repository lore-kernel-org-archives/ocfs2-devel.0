From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Aug  2 12:56:44 2004
Subject: [Ocfs2-devel] [Patch] Fix bug 109, delete subdir does not
	decrease the link on parent.
In-Reply-To: <3ACA40606221794F80A5670F0AF15F840504359B@pdsmsx403>
References: <3ACA40606221794F80A5670F0AF15F840504359B@pdsmsx403>
Message-ID: <20040802175638.GF8008@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Good catch, committed.
	--Mark

On Fri, Jul 30, 2004 at 05:57:19AM +0800, Ling, Xiaofeng wrote:
> Index: namei.c
> ===================================================================
> --- namei.c     (revision 1312)
> +++ namei.c     (working copy)
> @@ -813,7 +813,7 @@
>                 }
>                 dirfe = (ocfs2_dinode *) parent_node_bh->b_data;
>                 dirfe->i_links_count--;
> -               status = ocfs_journal_dirty(handle, fe_bh);
> +               status = ocfs_journal_dirty(handle, parent_node_bh);
>                 if (status < 0) {
>                         LOG_ERROR_STATUS(status);
>                         goto leave;
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
