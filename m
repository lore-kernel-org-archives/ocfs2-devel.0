From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Feb 23 18:08:13 2004
Subject: [Ocfs2-devel] Re: [PATCH]2.6 fixes in symlink.c
In-Reply-To: <200402200414.i1K4EDIe004275@penguin.co.intel.com>
References: <200402200414.i1K4EDIe004275@penguin.co.intel.com>
Message-ID: <20040224000810.GE1421@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Committed.
	--Mark

On Thu, Feb 19, 2004 at 08:14:13PM -0800, Rusty Lynch wrote:
> The following patch ports symlink.c to 2.6 by converting to the
> newer wait_on_page_locked() and PageUpdate() functions.
> 
>     --rusty
> 
> Index: src/symlink.c
> ===================================================================
> --- src/symlink.c	(revision 32)
> +++ src/symlink.c	(working copy)
> @@ -154,8 +154,15 @@
>  				NULL);
>  	if (IS_ERR(page))
>  		goto sync_fail;
> +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
> +	wait_on_page_locked(page);
> +	if (!PageUptodate(page))
> +
> +#else
>  	wait_on_page(page);
>  	if (!Page_Uptodate(page))
> +
> +#endif
>  		goto async_fail;
>  	*ppage = page;
>  	return kmap(page);
--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
