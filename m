From: Jan Kara <jack@suse.cz>
Date: Fri, 29 Mar 2019 15:28:46 +0100
Subject: [Ocfs2-devel] [PATCH v6 03/07] ocfs2: use common file type
	conversion
In-Reply-To: <20190326213919.GA20878@pathfinder>
References: <20190326213919.GA20878@pathfinder>
Message-ID: <20190329142846.GA16759@quack2.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mark@fasheh.com, amir73il@gmail.com, viro@zeniv.linux.org.uk, jlbec@evilplan.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Phillip Potter <phil@philpotter.co.uk>

Andrew is merging ocfs2 patches. Andrew, can you please pick up this
cleanup? Thanks!

								Honza

On Tue 26-03-19 21:39:19, Phillip Potter wrote:
> Deduplicate the ocfs2 file type conversion implementation and remove
> OCFS2_FT_* definitions - file systems that use the same file types
> as defined by POSIX do not need to define their own versions and can
> use the common helper functions decared in fs_types.h and implemented
> in fs_types.c
> 
> Common implementation can be found via commit:
> bbe7449e2599 "fs: common implementation of file type"
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
> Reviewed-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ocfs2/dir.c      | 20 ++++----------------
>  fs/ocfs2/ocfs2_fs.h | 28 +---------------------------
>  2 files changed, 5 insertions(+), 43 deletions(-)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index c121abbdfc7d..85f21caaa6ec 100644
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
> @@ -1718,7 +1714,7 @@ int __ocfs2_add_entry(handle_t *handle,
>  				de->rec_len = cpu_to_le16(OCFS2_DIR_REC_LEN(de->name_len));
>  				de = de1;
>  			}
> -			de->file_type = OCFS2_FT_UNKNOWN;
> +			de->file_type = FT_UNKNOWN;
>  			if (blkno) {
>  				de->inode = cpu_to_le64(blkno);
>  				ocfs2_set_de_type(de, inode->i_mode);
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
> index 7071ad0dec90..b86bf5e74348 100644
> --- a/fs/ocfs2/ocfs2_fs.h
> +++ b/fs/ocfs2/ocfs2_fs.h
> @@ -391,21 +391,6 @@ static struct ocfs2_system_inode_info ocfs2_system_inodes[NUM_SYSTEM_INODES] = {
>  #define OCFS2_HB_LOCAL			"heartbeat=local"
>  #define OCFS2_HB_GLOBAL			"heartbeat=global"
>  
> -/*
> - * OCFS2 directory file types.  Only the low 3 bits are used.  The
> - * other bits are reserved for now.
> - */
> -#define OCFS2_FT_UNKNOWN	0
> -#define OCFS2_FT_REG_FILE	1
> -#define OCFS2_FT_DIR		2
> -#define OCFS2_FT_CHRDEV		3
> -#define OCFS2_FT_BLKDEV		4
> -#define OCFS2_FT_FIFO		5
> -#define OCFS2_FT_SOCK		6
> -#define OCFS2_FT_SYMLINK	7
> -
> -#define OCFS2_FT_MAX		8
> -
>  /*
>   * OCFS2_DIR_PAD defines the directory entries boundaries
>   *
> @@ -424,17 +409,6 @@ static struct ocfs2_system_inode_info ocfs2_system_inodes[NUM_SYSTEM_INODES] = {
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
> @@ -1629,7 +1603,7 @@ static inline int ocfs2_sprintf_system_inode_name(char *buf, int len,
>  static inline void ocfs2_set_de_type(struct ocfs2_dir_entry *de,
>  				    umode_t mode)
>  {
> -	de->file_type = ocfs2_type_by_mode[(mode & S_IFMT)>>S_SHIFT];
> +	de->file_type = fs_umode_to_ftype(mode);
>  }
>  
>  static inline int ocfs2_gd_is_discontig(struct ocfs2_group_desc *gd)
> -- 
> 2.20.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
