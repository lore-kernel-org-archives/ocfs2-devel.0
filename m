From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 19 Aug 2010 10:40:31 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Correctly treat O_DIRECT write
 in holes or outside 'i_size'.
In-Reply-To: <1282180498-6690-1-git-send-email-tristan.ye@oracle.com>
References: <1282180498-6690-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <4C6C999F.3040603@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 08/19/2010 09:14 AM, Tristan Ye wrote:
> Currently, O_DIRECT writes in a hole or outside the 'i_size' was not
> actually honored, while using a buffered io instead.
>
> It hurts/cheats the 'O_DIRECT' semantics somehow, users may be confusing
> about the data lost after a crash when performing the odirect append writes.
>
> A straightforward way is to flush the pagecache like O_SYNC did to guarantee
> the real touch to disk before writes get returned.
well, actually it is a regression bug.
So tristan, could you please describe the commit that trigger it and the 
real problem that I describe in the bugzilla. Also please mention the 
bug no.
 From this commit log, it seems that we are bad from the very beginning 
which isn't true. ;)

Regards,
Tao
>
> Signed-off-by: Tristan Ye<tristan.ye@oracle.com>
> ---
>   fs/ocfs2/file.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 2b10b36..97b41f8 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -2321,7 +2321,7 @@ out_dio:
>   	BUG_ON(ret == -EIOCBQUEUED&&  !(file->f_flags&  O_DIRECT));
>
>   	if (((file->f_flags&  O_DSYNC)&&  !direct_io) || IS_SYNC(inode) ||
> -	    ((file->f_flags&  O_DIRECT)&&  has_refcount)) {
> +	    ((file->f_flags&  O_DIRECT)&&  !direct_io)) {
>   		ret = filemap_fdatawrite_range(file->f_mapping, pos,
>   					       pos + count - 1);
>   		if (ret<  0)
