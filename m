From: Changwei Ge <gechangwei@live.cn>
Date: Tue, 8 May 2018 14:53:51 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: Correct the offset comments of the
 structure ocfs2_dir_block_trailer.
In-Reply-To: <71604351584F6A4EBAE558C676F37CA401071C2456@H3CMLB12-EX.srv.huawei-3com.com>
References: <71604351584F6A4EBAE558C676F37CA401071C2456@H3CMLB12-EX.srv.huawei-3com.com>
Message-ID: <HK2PR06MB045244DC20EE4546B2031A65D59A0@HK2PR06MB0452.apcprd06.prod.outlook.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

It looks good to me.


On 2018/5/8 5:46 PM, Guozhonghua wrote:
> Correct the offset comments of the structure ocfs2_dir_block_trailer.
Reviewed-by: Changwei Ge <ge.changwei@h3c.com>
>
> Signed-off-by: guozhonghua <guozhonghua@h3c.com>
> ---
>   fs/ocfs2/ocfs2_fs.h |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h index 5bb4a89..14c60b0 100644
> --- a/fs/ocfs2/ocfs2_fs.h
> +++ b/fs/ocfs2/ocfs2_fs.h
> @@ -808,10 +808,10 @@ struct ocfs2_dir_block_trailer {
>   /*10*/	__u8		db_signature[8];	/* Signature for verification */
>   	__le64		db_reserved2;
>   	__le64		db_free_next;		/* Next block in list (unused) */
> -/*20*/	__le64		db_blkno;		/* Offset on disk, in blocks */
> +/*28*/	__le64		db_blkno;		/* Offset on disk, in blocks */
>   	__le64		db_parent_dinode;	/* dinode which owns me, in
>   						   blocks */
> -/*30*/	struct ocfs2_block_check db_check;	/* Error checking */
> +/*38*/	struct ocfs2_block_check db_check;	/* Error checking */
>   /*40*/
>   };
>   
> --
> 1.7.9.5
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
