From: Christoph Hellwig <hch@infradead.org>
Date: Mon, 19 Jan 2015 01:07:20 -0800
Subject: [Ocfs2-devel] [PATCH 07/17] quota: Switch ->get_dqblk() and
 ->set_dqblk() to use bytes as space units
In-Reply-To: <1421412471-4747-8-git-send-email-jack@suse.cz>
References: <1421412471-4747-1-git-send-email-jack@suse.cz>
	<1421412471-4747-8-git-send-email-jack@suse.cz>
Message-ID: <20150119090720.GG27474@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com

> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 18dc721ca19f..f718ba1f2ccb 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -559,18 +559,4 @@ typedef struct xfs_swapext
>  /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
>  
>  
> -#ifndef HAVE_BBMACROS
> -/*
> - * Block I/O parameterization.	A basic block (BB) is the lowest size of
> - * filesystem allocation, and must equal 512.  Length units given to bio
> - * routines are in BB's.
> - */
> -#define BBSHIFT		9
> -#define BBSIZE		(1<<BBSHIFT)
> -#define BBMASK		(BBSIZE-1)
> -#define BTOBB(bytes)	(((__u64)(bytes) + BBSIZE - 1) >> BBSHIFT)
> -#define BTOBBT(bytes)	((__u64)(bytes) >> BBSHIFT)
> -#define BBTOB(bbs)	((bbs) << BBSHIFT)
> -#endif

Please don't move these defintions around and just opencode them in
the quota code.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
