From: Manish Singh <manish.singh@oracle.com>
Date: Mon Jun 21 16:52:11 2004
Subject: [Ocfs2-devel] [PATCH] fixup journal-related ifdef mess
In-Reply-To: <20040620144000.GB16073@lst.de>
References: <20040620144000.GB16073@lst.de>
Message-ID: <20040621215142.GA31932@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sun, Jun 20, 2004 at 04:40:00PM +0200, Christoph Hellwig wrote:
> always use the 2.6 variants and fix up for 2.4 under the hood
> 
> 
> Index: src/journal.c
> ===================================================================
> --- src/journal.c	(revision 1156)
> +++ src/journal.c	(working copy)
> @@ -105,9 +105,17 @@
>  
>  	return status;
>  }
> -#else
> -#define ocfs_journal_start	journal_start
> -#define ocfs_journal_stop	journal_stop
> +
> +#define journal_start(journal, nblocks)	\
> +	ocfs_journal_start(journal, nblocks)
> +#define journal_stop(handle) \
> +	ocfs_journal_stop(handle)
> +
> +/* these two gained another argument during 2.6 */
> +#define journal_get_write_access(handle, bh, credits) \
> +	journal_get_write_access(handle, bh)
> +#define journal_get_undo_access(handle, bh, credits) \
> +	journal_get_undo_access(handle, bh)
>  #endif

This breaks with the modversion #define magic. I committed a version
with wrapper inlines, like with journal_start/stop.. if you have a
better idea, let me know.

-Manish
