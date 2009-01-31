From: Andrew Morton <akpm@linux-foundation.org>
Date: Sat, 31 Jan 2009 00:23:47 -0000
Subject: [Ocfs2-devel] [PATCH] fs: Add new pre-allocation ioctls to vfs
 for compatibility with legacy xfs ioctls
In-Reply-To: <4980C71F.1010804@ankitjain.org>
References: <4980C71F.1010804@ankitjain.org>
Message-ID: <20090130162252.7bf9c1f4.akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ankit Jain <me@ankitjain.org>
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, linux-fsdevel@vger.kernel.org, mfasheh@suse.com, joel.becker@oracle.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, xfs-masters@oss.sgi.com, xfs@oss.sgi.com

On Thu, 29 Jan 2009 02:29:11 +0530
Ankit Jain <me@ankitjain.org> wrote:

> --- xfs.orig/include/linux/falloc.h	2009-01-21 21:03:28.076324621 +0100
> +++ xfs/include/linux/falloc.h	2009-01-27 20:36:59.190423995 +0100
> @@ -3,4 +3,48 @@
>  
>  #define FALLOC_FL_KEEP_SIZE	0x01 /* default is extend size */
>  
> +#ifdef __KERNEL__
> +
> +/*
> + * Space reservation ioctls and argument structure
> + * are designed to be compatible with the legacy XFS ioctls.
> + */
> +struct space_resv {
> +	__s16		l_type;
> +	__s16		l_whence;
> +	__s64		l_start;
> +	__s64		l_len;		/* len == 0 means until end of file */
> +	__s32		l_sysid;
> +	__u32		l_pid;
> +	__s32		l_pad[4];	/* reserve area			    */
> +};
> +
> +#define F_IOC_RESVSP		_IOW('X', 40, struct space_resv)
> +#define F_IOC_RESVSP64		_IOW('X', 42, struct space_resv)

Should this stuff be inside #ifdef __KERNEL__?  It is shared with userspace.

Are we sure that the aligment of l_start will be reliably the same
across all compilers and versions thereof for all time?
