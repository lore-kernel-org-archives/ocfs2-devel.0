From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri Aug 13 16:35:14 2004
Subject: [Ocfs2-devel] [PATCH] remove dead code and add missing statics
In-Reply-To: <20040813103221.GA5176@lst.de>
References: <20040813103221.GA5176@lst.de>
Message-ID: <20040813213506.GB1035@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Aug 13, 2004 at 12:32:21PM +0200, Christoph Hellwig wrote:
<snip>

> Index: src/dlm.c
> ===================================================================
> --- src/dlm.c	(revision 1352)
> +++ src/dlm.c	(working copy)
> @@ -389,7 +389,9 @@
>   * ocfs_update_disk_lock()
>   * inode is definitely non NULL
>   */
> -int ocfs_update_disk_lock (ocfs_super * osb, __u32 flags, struct buffer_head **bh, struct inode *inode, ocfs_journal_handle *handle)
> +static int ocfs_update_disk_lock (ocfs_super * osb, __u32 flags,
> +		struct buffer_head **bh, struct inode *inode,
> +		ocfs_journal_handle *handle)
>  {
>  	int status = 0;
>  	ocfs2_dinode *fe = NULL;
I already beat you to that stuff as of this morning :)


> Index: src/util.c
> ===================================================================
> --- src/util.c	(revision 1352)
> +++ src/util.c	(working copy)
> @@ -183,43 +183,6 @@
>  }				/* ocfs_truncate_inode_pages */
>  
>  
> -/*
> -To print the ocfs call stack use: ocfs_show_stack( NULL);
> -
> -ocfs_show_trace prints alot of garbage because nothing usefull is exported
> -by the kernel to determine which addresses are from the kernel/modules
> -
> -However the following greps will help you filter out most of the garbage
> -from the syslog :
> -
> -alias ocfstrace='tail -200 /var/log/messages | grep -v modules | grep -v \\\[\<'
> -*/
> -
> -
> -
> -void ocfs_show_stack(unsigned long * esp)
> -{
<snip>
I'm going to leave this in because we use it for debugging...

> -
>  static int ocfs_kernel_text_address(unsigned long addr)
>  {
>    return  (addr >= 0xc0000000 ) ; 
> @@ -246,47 +209,3 @@
>  
>  
>  }
> -
> -int __ocfs_wait_atomic_eq(wait_queue_head_t *wq, atomic_t *var, int val, int ms)
> -{
<snip>
I'm also going to defer this one to Kurt as I think it was supposed to
replace some uses of the horrible ocfs_wait macro...

<snip>
> Index: src/vote.h
> ===================================================================
> --- src/vote.h	(revision 1352)
> +++ src/vote.h	(working copy)
> @@ -58,10 +58,8 @@
>  // clear all the bits in "target" which are set in "mask"
>  void ocfs_node_map_clear_bits(ocfs_node_map *target, ocfs_node_map *mask);
>  // set all the bits in "target" which are set in "mask"
> -void ocfs_node_map_set_bits(ocfs_node_map *target, ocfs_node_map *mask);
>  int ocfs_node_map_test_bit(ocfs_node_map *map, int bit);
>  int ocfs_node_map_is_empty(ocfs_node_map *map);
> -int ocfs_node_map_is_equal(ocfs_node_map *map1, ocfs_node_map *map2);
>  void ocfs_node_map_and(ocfs_node_map *target, ocfs_node_map *mask);
>  void ocfs_node_map_set(ocfs_node_map *target, ocfs_node_map *from);
>  void ocfs_node_map_dup(ocfs_super *osb, ocfs_node_map *target, ocfs_node_map *from);
I'm told we may use these soon :)

Otherwise, everything else has been committed, thanks!
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
