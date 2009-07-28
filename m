From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 28 Jul 2009 14:45:07 -0700
Subject: [Ocfs2-devel] [PATCH 1/8] Update ocfs2_fs.h to contain all
 necessary quota structures and constants
In-Reply-To: <1248717216-26617-2-git-send-email-jack@suse.cz>
References: <1248717216-26617-1-git-send-email-jack@suse.cz>
	<1248717216-26617-2-git-send-email-jack@suse.cz>
Message-ID: <20090728214507.GD8420@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jul 27, 2009 at 07:53:29PM +0200, Jan Kara wrote:
> diff --git a/include/ocfs2-kernel/ocfs2_fs.h b/include/ocfs2-kernel/ocfs2_fs.h
> index 2140bb3..ad655dc 100644
> --- a/include/ocfs2-kernel/ocfs2_fs.h
> +++ b/include/ocfs2-kernel/ocfs2_fs.h
> @@ -344,6 +344,8 @@ enum {
>  #define OCFS2_FIRST_ONLINE_SYSTEM_INODE SLOT_MAP_SYSTEM_INODE
>  	HEARTBEAT_SYSTEM_INODE,
>  	GLOBAL_BITMAP_SYSTEM_INODE,
> +	USER_QUOTA_SYSTEM_INODE,
> +	GROUP_QUOTA_SYSTEM_INODE,
>  #define OCFS2_LAST_GLOBAL_SYSTEM_INODE GLOBAL_BITMAP_SYSTEM_INODE

	You need to redefine OCFS2_LAST_GLOBAL_SYSTEM_INODE like it is
in the kernel.

>  #define OCFS2_GLOBAL_INFO_OFF (sizeof(struct ocfs2_disk_dqheader))
> +#define OCFS2_GLOBAL_TREE_BLK 1

	I don't see GLOBAL_TREE_BLK in the kernel.

>  /* Information header of global quota file (immediately follows the generic
>   * header) */
> @@ -977,6 +986,16 @@ struct ocfs2_global_disk_dqinfo {
>  				 * file */
>  };
>  
> +/* Header of leaf tree block */
> +struct ocfs2_global_disk_dqdbheader {
> +	__le32 dqdh_next_free;	/* Number of next block with free entry */
> +	__le32 dqdh_prev_free;	/* Number of previous block with free entry */
> +	__le16 dqdh_entries;	/* Number of valid entries in block */
> +	__le16 dqdh_pad1;
> +	__le32 dqdh_pad2;
> +};

	Nor do I see ocfs2_global_disk_dqdbheader.

> +static inline int ocfs2_global_dqstr_in_blk(int blocksize)
> +{
> +	return (blocksize - OCFS2_QBLK_RESERVED_SPACE -
> +		sizeof(struct ocfs2_global_disk_dqdbheader)) /
> +		sizeof(struct ocfs2_global_disk_dqblk);
> +}
> +

	Nor ocfs2_global_dqstr_in_blk.

Joel

-- 

"Not being known doesn't stop the truth from being true."
        - Richard Bach

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
