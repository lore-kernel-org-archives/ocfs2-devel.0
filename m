From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri Nov 30 11:42:36 2007
Subject: [Ocfs2-devel] [PATCH 2/3] Add group extend for online resize,
	take 2
In-Reply-To: <20071127082135.GA4480@tma-pc1.cn.oracle.com>
References: <20071127081123.GA4345@tma-pc1.cn.oracle.com>
	<20071127082135.GA4480@tma-pc1.cn.oracle.com>
Message-ID: <20071130194130.GD28607@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Nov 27, 2007 at 04:21:35PM +0800, tao.ma wrote:
> User can do offline resize using tunefs.ocfs2 when a volume isn't
> mounted. Now the support for online resize is added into ocfs2.
> 
> Please note that the node where online resize goes must already
> has the volume mounted. We don't mount it behind the user and the
> operation would fail if we find it isn't mounted. As for other
> nodes, we don't care whether the volume is mounted or not.
> 
> global_bitmap, super block and all the backups will be updated
> in the kernel. And if super block or backup's update fails, we
> just output some error message in dmesg and continue the work.
> 
> The whole process is derived from ext3 and divided into 2 steps:
> 1. If the last group isn't full, tunefs.ocfs2 will call
>    OCFS2_IOC_GROUP_EXTEND first to extend it. All the main work is
>    done in kernel.
> 2. For every new groups, tunefs.ocfs2 will call OCFS2_IOC_GROUP_ADD
>    to add them one by one. The new group descriptor is initialized
>    in userspace, we only check it in the kernel and update the
>    global_bitap, super blocks etc.
> 
> This patch includes the implementation for the 1st step.

Ok, this looks pretty good. Some comments below - the new method of doing
this is much simpler to understand.


> diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
> index 9fb8132..ecc58b8 100644
> --- a/fs/ocfs2/Makefile
> +++ b/fs/ocfs2/Makefile
> @@ -28,7 +28,8 @@ ocfs2-objs := \
>  	sysfile.o 		\
>  	uptodate.o		\
>  	ver.o 			\
> -	vote.o
> +	vote.o			\
> +	resize.o

Should stay consitent with the makefile and add this in alphabetical
order...


> diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
> index 87dcece..60698de 100644
> --- a/fs/ocfs2/ioctl.c
> +++ b/fs/ocfs2/ioctl.c
> @@ -115,6 +115,7 @@ int ocfs2_ioctl(struct inode * inode, struct file * filp,
>  	unsigned int cmd, unsigned long arg)
>  {
>  	unsigned int flags;
> +	u32 new_clusters;
>  	int status;
>  	struct ocfs2_space_resv sr;
>  
> @@ -140,6 +141,11 @@ int ocfs2_ioctl(struct inode * inode, struct file * filp,
>  			return -EFAULT;
>  
>  		return ocfs2_change_file_space(filp, cmd, &sr);
> +	case OCFS2_IOC_GROUP_EXTEND:
> +		if (get_user(new_clusters, (__u32 __user *)arg))
> +			return -EFAULT;
> +
> +		return ocfs2_group_extend(inode, new_clusters);
>  	default:
>  		return -ENOTTY;
>  	}
> @@ -162,6 +168,7 @@ long ocfs2_compat_ioctl(struct file *file, unsigned cmd, unsigned long arg)
>  	case OCFS2_IOC_RESVSP64:
>  	case OCFS2_IOC_UNRESVSP:
>  	case OCFS2_IOC_UNRESVSP64:
> +	case OCFS2_IOC_GROUP_EXTEND:
>  		break;
>  	default:
>  		return -ENOIOCTLCMD;
> diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
> index 4b32e09..0ba3a42 100644
> --- a/fs/ocfs2/journal.h
> +++ b/fs/ocfs2/journal.h
> @@ -278,6 +278,9 @@ int                  ocfs2_journal_dirty_data(handle_t *handle,
>  /* simple file updates like chmod, etc. */
>  #define OCFS2_INODE_UPDATE_CREDITS 1
>  
> +/* group extend. inode update and last group update. */
> +#define OCFS2_GROUP_EXTEND_CREDITS	(OCFS2_INODE_UPDATE_CREDITS + 1)
> +
>  /* get one bit out of a suballocator: dinode + group descriptor +
>   * prev. group desc. if we relink. */
>  #define OCFS2_SUBALLOC_ALLOC (3)
> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index 60a23e1..8a6925b 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -527,6 +527,11 @@ static inline unsigned int ocfs2_pages_per_cluster(struct super_block *sb)
>  	return pages_per_cluster;
>  }
>  
> +/* given a cluster offset, calculate which block group it belongs to
> + * and return that block offset. */
> +u64 ocfs2_which_cluster_group(struct inode *inode, u32 cluster);
> +int ocfs2_group_extend(struct inode * inode, u32 new_clusters);
> +

You should stick ocfs2_which_cluster_group() in suballoc.c and
ocfs2_group_extend() in resize.h. We've been trying to chip away at ocfs2.h
for years now ;)


>  #define ocfs2_set_bit ext2_set_bit
>  #define ocfs2_clear_bit ext2_clear_bit
>  #define ocfs2_test_bit ext2_test_bit
> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
> index 6ef8767..4b5813d 100644
> --- a/fs/ocfs2/ocfs2_fs.h
> +++ b/fs/ocfs2/ocfs2_fs.h
> @@ -231,6 +231,8 @@ struct ocfs2_space_resv {
>  #define OCFS2_IOC_RESVSP64	_IOW ('X', 42, struct ocfs2_space_resv)
>  #define OCFS2_IOC_UNRESVSP64	_IOW ('X', 43, struct ocfs2_space_resv)
>  
> +#define OCFS2_IOC_GROUP_EXTEND	_IOW('f', 7, unsigned long)
> +

You also need to add:

#define OCFS2_IOC_GROUP_EXTEND32		_IOW('f', 7, int)

and check for that in ocfs2_compat_ioctl(). Look at how
OCFS2_IOC32_GETFLAGS/OCFS2_IOC_SETFLAGS is handled.

This is all for compatibility with 32 bit system calls on 64 bit kernels by
the way which would be passing the argument as a 32 bit value.


Actually, thinking about this a bit more - why not just make the argument
always an 'int'? That should be 32 bits pretty much everywhere and we
wouldn't need the compat handling for it.


> +static void ocfs2_update_super_and_backups(struct inode *inode,
> +					   u32 new_clusters)
> +{
> +	int ret;
> +	u32 clusters = 0;
> +	struct buffer_head *super_bh = NULL;
> +	struct ocfs2_dinode *super_di = NULL;
> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +
> +	/*
> +	 * update the superblock last.
> +	 * It doesn't matter if the write failed.
> +	 */
> +	ret = ocfs2_read_block(osb, OCFS2_SUPER_BLOCK_BLKNO,
> +			       &super_bh, 0, NULL);
> +	if (ret < 0) {
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +
> +	super_di = (struct ocfs2_dinode *)super_bh->b_data;
> +	le32_add_cpu(&super_di->i_clusters, new_clusters);
> +	clusters = le32_to_cpu(super_di->i_clusters);
> +
> +	ret = ocfs2_write_super_or_backup(osb, super_bh);
> +	if (ret < 0) {
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +
> +	if (OCFS2_HAS_COMPAT_FEATURE(osb->sb, OCFS2_FEATURE_COMPAT_BACKUP_SB))
> +		update_backups(inode, clusters, super_bh->b_data);
> +
> +out:
> +	if (super_bh)
> +		brelse(super_bh);

If we exit with error here, we should probably print to log so that the user
knows to run fsck.ocfs2. Maybe:

printk(KERN_WARN "ocfs2: Failed to update super blocks on %s during fs "
"resize. This condition is not fatal, but fsck.ocfs2 should be run to fix "
"it\n", osb->dev_str);


> +int ocfs2_group_extend(struct inode * inode, u32 new_clusters)
> +{
> +	int ret;
> +	handle_t *handle;
> +	struct buffer_head *main_bm_bh = NULL;
> +	struct buffer_head *group_bh = NULL;
> +	struct inode *main_bm_inode = NULL;
> +	struct ocfs2_dinode *fe = NULL;
> +	struct ocfs2_group_desc *group = NULL;
> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +	u16 cl_bpc;
> +	u32 first_new_cluster;
> +	u64 lgd_blkno;
> +
> +	mlog_entry_void();
> +
> +	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> +		return -EROFS;
> +
> +	if (new_clusters == 0)
> +		return 0;
> +
> +	main_bm_inode = ocfs2_get_system_file_inode(osb,
> +						    GLOBAL_BITMAP_SYSTEM_INODE,
> +						    OCFS2_INVALID_SLOT);
> +	if (!main_bm_inode) {
> +		ret = -EINVAL;
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +
> +	mutex_lock(&main_bm_inode->i_mutex);
> +
> +	ret = ocfs2_meta_lock(main_bm_inode, &main_bm_bh, 1);
> +	if (ret < 0) {
> +		mlog_errno(ret);
> +		goto out_mutex;
> +	}
> +
> +	fe = (struct ocfs2_dinode *)main_bm_bh->b_data;
> +
> +	if (le16_to_cpu(fe->id2.i_chain.cl_cpg) !=
> +				 ocfs2_group_bitmap_size(osb->sb) * 8) {
> +		mlog(0, "The disk is too old. Force to do offline resize.");
> +		ret = -EINVAL;
> +		goto out_mutex;
> +	}
> +
> +	if (!OCFS2_IS_VALID_DINODE(fe)) {
> +		OCFS2_RO_ON_INVALID_DINODE(main_bm_inode->i_sb, fe);
> +		ret = -EIO;
> +		goto out_unlock;
> +	}
> +
> +	first_new_cluster = le32_to_cpu(fe->i_clusters);
> +	lgd_blkno = ocfs2_which_cluster_group(main_bm_inode,
> +					      first_new_cluster - 1);
> +
> +	ret = ocfs2_read_block(osb, lgd_blkno, &group_bh, OCFS2_BH_CACHED,
> +			       main_bm_inode);
> +	if (ret < 0) {
> +		mlog_errno(ret);
> +		goto out_unlock;
> +	}
> +
> +	group = (struct ocfs2_group_desc *) group_bh->b_data;

Right here is probably a good place to call ocfs2_check_group_descriptor().
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
