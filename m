From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri Mar  5 18:44:34 2004
Subject: [Ocfs2-devel] Re: [PATCH]inode binding on 2.6
In-Reply-To: <200403042219.i24MJetf006769@penguin.co.intel.com>
References: <200403042219.i24MJetf006769@penguin.co.intel.com>
Message-ID: <20040306004430.GB31692@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Mar 04, 2004 at 02:19:40PM -0800, Rusty Lynch wrote:
<snip>
Looks good so far...

> None of these changes should effect the 2.4 build, and this patch does
> make it possible to mount ocfs2 on a 2.6 box, walk a directory of file
> put on the file system from a 2.4 build, and cat the files.
> 
> There is still a fatal bug that will hang the system just about anytime
> any kind of clean up happens, which makes the 2.6 build still unusable 
> (but closer to usable.)
Can you give me an explanation of the bug?


> Index: src/inode.c
> ===================================================================
> --- src/inode.c	(revision 754)
> +++ src/inode.c	(working copy)
<snip>
> @@ -391,9 +393,15 @@
>  		    mode |= S_IFREG;
>  		    break;
>  	}
> -	ocfs_populate_inode (inode, entry, mode, newoin, false);
> +	ocfs_populate_inode (inode, fe, mode, newoin, false);
> +	voteoff = S_ISDIR (mode) ? fe->extents[0].disk_off : fe->this_sector;
> +	if (!args->skip_bind)
> +		ocfs_inode_hash_bind(osb, voteoff, inode);
Good so far, but aren't you missing the ocfs_inode_hash_bind() call for the
root inode case in this function? Check out ocfs_read_inode2 to see what I'm
talking about. You can safely ignore the skip_bind argument for the root
inode.

<snip>
> Index: src/inc/ocfs.h
> ===================================================================
> --- src/inc/ocfs.h	(revision 754)
> +++ src/inc/ocfs.h	(working copy)
> @@ -27,10 +27,6 @@
>  #ifndef OCFS_H
>  #define OCFS_H
>  
> -/* XXX Hack to avoid warning */
> -struct mem_dqinfo;
> -extern inline void mark_info_dirty(struct mem_dqinfo *info);
> -
Are you trying to slip an unrelated patch by me?  ;)
Not that it's not correct (and I'll gladly commit it after you regenerate
this patch)

Could I get you to regenerate this against current svn? Also, please add
that call to ocfs_inode_hash_bind.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
