From: Eric Ren <zren@suse.com>
Date: Mon, 4 Jul 2016 11:36:09 +0800
Subject: [Ocfs2-devel] ocfs2: cleanup implemented prototypes
In-Reply-To: <57763787.4020706@huawei.com>
References: <57763787.4020706@huawei.com>
Message-ID: <5779D9A9.4030605@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joseph,

Please see comments inline;-)

On 07/01/2016 05:27 PM, Joseph Qi wrote:
> Several prototypes in inode.h are just defined but not actually
> implemented and used, so remove them.
>
> Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
> ---
>   fs/ocfs2/inode.h | 7 -------
>   fs/ocfs2/super.c | 1 -
>   2 files changed, 8 deletions(-)
>
> diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
> index d8f3fc8..50cc550 100644
> --- a/fs/ocfs2/inode.h
> +++ b/fs/ocfs2/inode.h
> @@ -145,22 +145,15 @@ int ocfs2_drop_inode(struct inode *inode);
>   struct inode *ocfs2_ilookup(struct super_block *sb, u64 feoff);
>   struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 feoff, unsigned flags,
>   			 int sysfile_type);
> -int ocfs2_inode_init_private(struct inode *inode);
>   int ocfs2_inode_revalidate(struct dentry *dentry);
>   void ocfs2_populate_inode(struct inode *inode, struct ocfs2_dinode *fe,
>   			  int create_ino);
> -void ocfs2_read_inode(struct inode *inode);
> -void ocfs2_read_inode2(struct inode *inode, void *opaque);
> -ssize_t ocfs2_rw_direct(int rw, struct file *filp, char *buf,
> -			size_t size, loff_t *offp);
>   void ocfs2_sync_blockdev(struct super_block *sb);
>   void ocfs2_refresh_inode(struct inode *inode,
>   			 struct ocfs2_dinode *fe);
>   int ocfs2_mark_inode_dirty(handle_t *handle,
>   			   struct inode *inode,
>   			   struct buffer_head *bh);
> -struct buffer_head *ocfs2_bread(struct inode *inode,
> -				int block, int *err, int reada);

grep shows "ocfs2_bread" also appears in dir.c:511, could you take a
look at?

Eric

>
>   void ocfs2_set_inode_flags(struct inode *inode);
>   void ocfs2_get_inode_flags(struct ocfs2_inode_info *oi);
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index d7cae33..d97de21 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -2072,7 +2072,6 @@ static int ocfs2_initialize_super(struct super_block *sb,
>   	osb->osb_dx_seed[3] = le32_to_cpu(di->id2.i_super.s_uuid_hash);
>
>   	osb->sb = sb;
> -	/* Save off for ocfs2_rw_direct */
>   	osb->s_sectsize_bits = blksize_bits(sector_size);
>   	BUG_ON(!osb->s_sectsize_bits);
>
