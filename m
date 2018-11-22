From: Jan Kara <jack@suse.cz>
Date: Thu, 22 Nov 2018 12:43:48 +0100
Subject: [Ocfs2-devel] [RFC][PATCH v4 06/09] ocfs2: use common file type
	conversion
In-Reply-To: <20181121190656.GA7724@pathfinder>
References: <20181121190656.GA7724@pathfinder>
Message-ID: <20181122114348.GI9840@quack2.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Phillip Potter <phil@philpotter.co.uk>
Cc: mark@fasheh.com, amir73il@gmail.com, viro@zeniv.linux.org.uk, jlbec@evilplan.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Wed 21-11-18 19:06:56, Phillip Potter wrote:
> Deduplicate the ocfs2 file type conversion implementation - file systems
> that use the same file types as defined by POSIX do not need to define
> their own versions and can use the common helper functions decared in
> fs_types.h and implemented in fs_types.c
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Phillip Potter <phil@philpotter.co.uk>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ocfs2/dir.c      | 18 +++---------------
>  fs/ocfs2/ocfs2_fs.h | 27 +++++++++++++++------------
>  2 files changed, 18 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index c121abbdfc7d..9e6dea014ab9 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -69,10 +69,6 @@
>  #define NAMEI_RA_BLOCKS  4
>  #define NAMEI_RA_SIZE        (NAMEI_RA_CHUNKS * NAMEI_RA_BLOCKS)
>  
> -static unsigned char ocfs2_filetype_table[] = {
> -	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK
> -};
> -
>  static int ocfs2_do_extend_dir(struct super_block *sb,
>  			       handle_t *handle,
>  			       struct inode *dir,
> @@ -1803,13 +1799,9 @@ static int ocfs2_dir_foreach_blk_id(struct inode *inode,
>  		}
>  		offset += le16_to_cpu(de->rec_len);
>  		if (le64_to_cpu(de->inode)) {
> -			unsigned char d_type = DT_UNKNOWN;
> -
> -			if (de->file_type < OCFS2_FT_MAX)
> -				d_type = ocfs2_filetype_table[de->file_type];
> -
>  			if (!dir_emit(ctx, de->name, de->name_len,
> -				      le64_to_cpu(de->inode), d_type))
> +				      le64_to_cpu(de->inode),
> +				      fs_ftype_to_dtype(de->file_type)))
>  				goto out;
>  		}
>  		ctx->pos += le16_to_cpu(de->rec_len);
> @@ -1900,14 +1892,10 @@ static int ocfs2_dir_foreach_blk_el(struct inode *inode,
>  				break;
>  			}
>  			if (le64_to_cpu(de->inode)) {
> -				unsigned char d_type = DT_UNKNOWN;
> -
> -				if (de->file_type < OCFS2_FT_MAX)
> -					d_type = ocfs2_filetype_table[de->file_type];
>  				if (!dir_emit(ctx, de->name,
>  						de->name_len,
>  						le64_to_cpu(de->inode),
> -						d_type)) {
> +					fs_ftype_to_dtype(de->file_type))) {
>  					brelse(bh);
>  					return 0;
>  				}
> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
> index 7071ad0dec90..daf836e5df43 100644
> --- a/fs/ocfs2/ocfs2_fs.h
> +++ b/fs/ocfs2/ocfs2_fs.h
> @@ -424,17 +424,6 @@ static struct ocfs2_system_inode_info ocfs2_system_inodes[NUM_SYSTEM_INODES] = {
>  #define	OCFS2_LINKS_HI_SHIFT	16
>  #define	OCFS2_DX_ENTRIES_MAX	(0xffffffffU)
>  
> -#define S_SHIFT			12
> -static unsigned char ocfs2_type_by_mode[S_IFMT >> S_SHIFT] = {
> -	[S_IFREG >> S_SHIFT]  = OCFS2_FT_REG_FILE,
> -	[S_IFDIR >> S_SHIFT]  = OCFS2_FT_DIR,
> -	[S_IFCHR >> S_SHIFT]  = OCFS2_FT_CHRDEV,
> -	[S_IFBLK >> S_SHIFT]  = OCFS2_FT_BLKDEV,
> -	[S_IFIFO >> S_SHIFT]  = OCFS2_FT_FIFO,
> -	[S_IFSOCK >> S_SHIFT] = OCFS2_FT_SOCK,
> -	[S_IFLNK >> S_SHIFT]  = OCFS2_FT_SYMLINK,
> -};
> -
>  
>  /*
>   * Convenience casts
> @@ -1629,7 +1618,21 @@ static inline int ocfs2_sprintf_system_inode_name(char *buf, int len,
>  static inline void ocfs2_set_de_type(struct ocfs2_dir_entry *de,
>  				    umode_t mode)
>  {
> -	de->file_type = ocfs2_type_by_mode[(mode & S_IFMT)>>S_SHIFT];
> +	/*
> +	 * compile-time asserts that generic FT_x types still match
> +	 * OCFS2_FT_x types
> +	 */
> +	BUILD_BUG_ON(OCFS2_FT_UNKNOWN != FT_UNKNOWN);
> +	BUILD_BUG_ON(OCFS2_FT_REG_FILE != FT_REG_FILE);
> +	BUILD_BUG_ON(OCFS2_FT_DIR != FT_DIR);
> +	BUILD_BUG_ON(OCFS2_FT_CHRDEV != FT_CHRDEV);
> +	BUILD_BUG_ON(OCFS2_FT_BLKDEV != FT_BLKDEV);
> +	BUILD_BUG_ON(OCFS2_FT_FIFO != FT_FIFO);
> +	BUILD_BUG_ON(OCFS2_FT_SOCK != FT_SOCK);
> +	BUILD_BUG_ON(OCFS2_FT_SYMLINK != FT_SYMLINK);
> +	BUILD_BUG_ON(OCFS2_FT_MAX != FT_MAX);
> +
> +	de->file_type = fs_umode_to_ftype(mode);
>  }
>  
>  static inline int ocfs2_gd_is_discontig(struct ocfs2_group_desc *gd)
> -- 
> 2.19.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
