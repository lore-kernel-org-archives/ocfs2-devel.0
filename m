From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri Sep  3 18:01:37 2004
Subject: [Ocfs2-devel] [PATCH] remove pre-2.4.21 compat code
In-Reply-To: <20040903091228.GC32029@lst.de>
References: <20040903091228.GC32029@lst.de>
Message-ID: <20040903230130.GA5532@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello,

On Fri, Sep 03, 2004 at 11:12:29AM +0200, Christoph Hellwig wrote:
<snip> 
> Index: src/aops.c
> ===================================================================
> --- src/aops.c	(revision 1418)
> +++ src/aops.c	(working copy)
> @@ -609,8 +609,8 @@
>  	LOG_CLEAR_CONTEXT();
>  	return ret;
>  }				/* ocfs_direct_IO */
> +#else
>  
> -#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,10)
>  /*
>   * ocfs_direct_IO()
>   *
> @@ -618,7 +618,7 @@
>   * we should never get here any more
>   * so let's just BUG(), hint from sct@redhat.com
>   */
> -#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,20) || defined(SUSE)
> +#ifdef SUSE
>  static int ocfs_direct_IO (int rw, struct file *filp, struct kiobuf *iobuf, unsigned long blocknr, int blocksize)
>  {
>  	BUG();
> @@ -631,7 +631,7 @@
>  	return 0;
>  }				/* ocfs_direct_IO */
>  #endif
> -#endif  /* version >= 2.4.10 */
> +#endif
I think over here you really mean this:

  * we should never get here any more
  * so let's just BUG(), hint from sct@redhat.com
  */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,20) || defined(SUSE)
 static int ocfs_direct_IO (int rw, struct file *filp, struct kiobuf *iobuf,
unsigned long blocknr, int blocksize)
 {
        BUG();
        return 0;
 }                              /* ocfs_direct_IO */
-#else
-static int ocfs_direct_IO (int rw, struct inode *inode, struct kiobuf
*iobuf, unsigned long blocknr, int blocksize)
-{
-       BUG();
-       return 0;
-}                              /* ocfs_direct_IO */
 #endif
-#endif  /* version >= 2.4.10 */

Otherwise, it looks good, thanks!
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
