From: Guozhonghua <guozhonghua@h3c.com>
Date: Wed, 9 May 2018 02:50:17 +0000
Subject: [Ocfs2-devel] =?utf-8?b?562U5aSNOiAgW1BBVENIXSBvY2ZzMjogQ29ycmVj?=
 =?utf-8?q?t_the_offset_comments_of_the_structure_ocfs2=5Fdir=5Fblock=5Ftr?=
 =?utf-8?q?ailer=2E?=
In-Reply-To: <3992b678-170b-353c-85f7-117299d1c527@gmail.com>
References: <71604351584F6A4EBAE558C676F37CA401071C2456@H3CMLB12-EX.srv.huawei-3com.com>
	<3992b678-170b-353c-85f7-117299d1c527@gmail.com>
Message-ID: <71604351584F6A4EBAE558C676F37CA401071C2CC6@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Good Idea, I will send patch v2 for review. 

Thanks.

Guozhonghua. 

-----????-----
???: Joseph Qi [mailto:jiangqi903 at gmail.com] 
????: 2018?5?9? 9:01
???: guozhonghua (Cloud); Andrew Morton (akpm at linux-foundation.org)
??: 'ocfs2-devel at oss.oracle.com' (ocfs2-devel at oss.oracle.com)
??: Re: [Ocfs2-devel] [PATCH] ocfs2: Correct the offset comments of the structure ocfs2_dir_block_trailer.

Umm... We always explicitly comment out the shift of 0x10, 0x20, ..., IMO, we'd better move the comments to the correct place instead of change it to something like 0x28.

Thanks,
Joseph

On 18/5/8 17:46, Guozhonghua wrote:
> Correct the offset comments of the structure ocfs2_dir_block_trailer.
> 
> Signed-off-by: guozhonghua <guozhonghua@h3c.com>
> ---
>  fs/ocfs2/ocfs2_fs.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h index 
> 5bb4a89..14c60b0 100644
> --- a/fs/ocfs2/ocfs2_fs.h
> +++ b/fs/ocfs2/ocfs2_fs.h
> @@ -808,10 +808,10 @@ struct ocfs2_dir_block_trailer {
>  /*10*/	__u8		db_signature[8];	/* Signature for verification */
>  	__le64		db_reserved2;
>  	__le64		db_free_next;		/* Next block in list (unused) */
> -/*20*/	__le64		db_blkno;		/* Offset on disk, in blocks */
> +/*28*/	__le64		db_blkno;		/* Offset on disk, in blocks */
>  	__le64		db_parent_dinode;	/* dinode which owns me, in
>  						   blocks */
> -/*30*/	struct ocfs2_block_check db_check;	/* Error checking */
> +/*38*/	struct ocfs2_block_check db_check;	/* Error checking */
>  /*40*/
>  };
>  
> --
> 1.7.9.5
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
