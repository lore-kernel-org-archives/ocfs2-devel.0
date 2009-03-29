From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Sat, 28 Mar 2009 22:54:39 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: 64-bit inode number for
	getattr() instead of 32-bit value
In-Reply-To: <200903270708.n2R78IMi021731@acsinet13.oracle.com>
References: <200903270708.n2R78IMi021731@acsinet13.oracle.com>
Message-ID: <44766EC3-898E-4EAE-970D-41B17CF06437@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Last I checked one could not have 64 bit inode numbers on 32 bit  
systems. Meaning this patch is not required.

On Mar 27, 2009, at 12:06 AM, wengang wang <wen.gang.wang@oracle.com>  
wrote:

> ocfs2_getattr() uses generic_fillattr() to set inode number(and other
> attributes). generic_fillattr() inturn fills inode number with inode- 
> >i_ino
> which is a 32-bit(unsigned long) value.
>
> if the ocfs2 partition is huge enough, that may become an incorrect
> value.
> the fix is filling it again after generic_fillattr() with  
> ip_blkno(u64).
>
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> --
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index a5887df..ffe7d34 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1076,6 +1076,8 @@ int ocfs2_getattr(struct vfsmount *mnt,
>    /* We set the blksize from the cluster size for performance */
>    stat->blksize = osb->s_clustersize;
>
> +    stat->ino = OCFS2_I(inode)->ip_blkno;
> +
> bail:
>    mlog_exit(err);
>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
