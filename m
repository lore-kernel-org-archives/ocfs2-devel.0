From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 05 Mar 2009 11:17:14 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: reserve xattr block for new
 directory with inline data
In-Reply-To: <1236222358-10447-1-git-send-email-tiger.yang@oracle.com>
References: <49AF40A9.8050601@oracle.com>
	<1236222358-10447-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <49AF443A.4040305@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi tiger,
	I guess Joel's idea is that you add comment above the code. Not in the 
commit log. ;)

Regards,
Tao

Tiger Yang wrote:
> If this is a new directory with inline data, we choose to reserve
> the entire inline area for directory contents and force an external
> xattr block.
> 
> Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
> ---
>  fs/ocfs2/xattr.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 4ddd788..053ae3d 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -549,6 +549,7 @@ int ocfs2_calc_xattr_init(struct inode *dir,
>  	 * for them is ok.
>  	 */
>  	if (dir->i_sb->s_blocksize == OCFS2_MIN_BLOCKSIZE ||
> +	    (S_ISDIR(mode) && ocfs2_supports_inline_data(osb)) ||
>  	    (s_size + a_size) > OCFS2_XATTR_FREE_IN_IBODY) {
>  		ret = ocfs2_reserve_new_metadata_blocks(osb, 1, xattr_ac);
>  		if (ret) {
