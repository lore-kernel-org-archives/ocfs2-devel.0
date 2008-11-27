From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 27 Nov 2008 10:16:05 +0800
Subject: [Ocfs2-devel] [PATCH 09/13] ocfs2: Start using buckets in
	ocfs2_adjust_xattr_cross_cluster().
In-Reply-To: <1227744386-10502-10-git-send-email-joel.becker@oracle.com>
References: <1227744386-10502-1-git-send-email-joel.becker@oracle.com>
	<1227744386-10502-10-git-send-email-joel.becker@oracle.com>
Message-ID: <492E02E5.9080102@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Joel Becker wrote:
> We want to be passing around buckets instead of buffer_heads.  Let's get
> them into ocfs2_adjust_xattr_cross_cluster.
> 
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
> ---
>  fs/ocfs2/xattr.c |   46 ++++++++++++++++++++++++++++++++++++++--------
>  1 files changed, 38 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 2c9b673..4dcbc21 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -3613,7 +3613,7 @@ static int ocfs2_mv_xattr_bucket_cross_cluster(struct inode *inode,
>  		 * These shouldn't fail - the buffers are in the
>  		 * journal from ocfs2_cp_xattr_bucket().
>  		 */
> -		ret = ocfs2_read_xattr_bucket(new_first, src_blkno);
> +		ret = ocfs2_read_xattr_bucket(new_first, new_blkno);
>  		if (ret) {
>  			mlog_errno(ret);
>  			goto out;
sorry, I didn't see you change it here, but it may be merged with the 
previous patch.

Regards,
Tao
