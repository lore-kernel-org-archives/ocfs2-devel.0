From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Feb 23 17:53:28 2004
Subject: [Ocfs2-devel] Re: [PATCH]2.6 fixes in dcache.c
In-Reply-To: <200402200413.i1K4D0D5004243@penguin.co.intel.com>
References: <200402200413.i1K4D0D5004243@penguin.co.intel.com>
Message-ID: <20040223235323.GD1421@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Committed.
	--Mark

On Thu, Feb 19, 2004 at 08:13:00PM -0800, Rusty Lynch wrote:
> This is a minimal patch that fixes a compile warning when building
> with a 2.6 kernel, and also switches over another #if LINUX_2_5 to
> the normal #if LINUX_VERSION_CODE ...
> 
>     --rusty
> 
> Index: src/dcache.c
> ===================================================================
> --- src/dcache.c	(revision 32)
> +++ src/dcache.c	(working copy)
> @@ -43,10 +43,12 @@
>  	ocfs_inode *oin;
>  	ocfs_super *osb;
>  	__u64 off;
> -	ocfs_find_inode_args args;
>          struct qstr q;
>  	struct buffer_head *fe_bh = NULL;
>  	int needs_trunc;
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
> +	ocfs_find_inode_args args;
> +#endif
>  
>          LOG_ENTRY_ARGS ("(0x%08x, %d, '%*s')\n", dentry, flags,
>                          dentry->d_name.len, dentry->d_name.name);
> @@ -127,7 +129,7 @@
>                  LOG_TRACE_STR("found the file entry, but it has been deleted or renamed!");
>                  ret = 0;  /* it is now officially stale :) */
>          } else {
> -#ifdef LINUX_2_5
> +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
>  		ocfs_read_locked_inode (inode, fe);
>  #else
>  		args.offset = fe->this_sector;
--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
