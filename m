From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 12 Jun 2008 20:22:30 -0700
Subject: [Ocfs2-devel] [PATCH 7/8] ocfs2: Add extended attributes
	support. v1
In-Reply-To: <1212650694-9603-1-git-send-email-tiger.yang@oracle.com>
References: <484792D1.3080802@oracle.com>
	<1212650694-9603-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <20080613032230.GW28100@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Ok, so I only got halfway through this one today - I'll have to pick it up
tommorrow. In the meantime, here are the comments I have so far. My hope is
that you can at least start from what I've gathered here.
	--Mark


On Thu, Jun 05, 2008 at 03:24:54PM +0800, Tiger Yang wrote:
> This patch implement storing extended attributes both in inode or metadata block.
> For EAs in inode, we reserve the last 256 bytes in inode block(blocksize >= 1024).

Ok, so this comes out to the space occupied by 16 extent records. Imho, for
block sizes 1k and over, this is a perfectly reasonable amount of space to
devote to ea storage.


> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
> index 52c4266..d0fbf38 100644
> --- a/fs/ocfs2/ocfs2_fs.h
> +++ b/fs/ocfs2/ocfs2_fs.h
> @@ -291,6 +291,9 @@ struct ocfs2_new_group_input {
>  /* Journal limits (in bytes) */
>  #define OCFS2_MIN_JOURNAL_SIZE		(4 * 1024 * 1024)
>
> +/* Inline extended attribute size (in bytes) */
> +#define OCFS2_MAX_XATTR_INLINE_SIZE	256
> +
>  /*
>   * Default local alloc size (in megabytes)
>   *
> @@ -640,11 +643,12 @@ struct ocfs2_dinode {
>  	__le32 i_atime_nsec;
>  	__le32 i_ctime_nsec;
>  	__le32 i_mtime_nsec;
> -	__le32 i_attr;
> +/*70*/	__le32 i_attr;
>  	__le16 i_orphaned_slot;		/* Only valid when OCFS2_ORPHANED_FL
>  					   was set in i_flags */
>  	__le16 i_dyn_features;
> -/*70*/	__le64 i_reserved2[8];
> +	__le64 i_xattr_loc;
> +/*80*/	__le64 i_reserved2[7];
>  /*B8*/	union {
>  		__le64 i_pad1;		/* Generic way to refer to this
>  					   64bit union */
> @@ -721,16 +725,26 @@ static inline int ocfs2_fast_symlink_chars(struct super_block *sb)
>  
>  static inline int ocfs2_max_inline_data(struct super_block *sb)
>  {
> -	return sb->s_blocksize -
> -		offsetof(struct ocfs2_dinode, id2.i_data.id_data);
> +	if (sb->s_blocksize != OCFS2_MIN_BLOCKSIZE)
> +		return sb->s_blocksize -
> +			offsetof(struct ocfs2_dinode, id2.i_data.id_data) -
> +			OCFS2_MAX_XATTR_INLINE_SIZE;
> +	else
> +		return sb->s_blocksize -
> +			offsetof(struct ocfs2_dinode, id2.i_data.id_data);
>  }
>  
>  static inline int ocfs2_extent_recs_per_inode(struct super_block *sb)
>  {
>  	int size;
>  
> -	size = sb->s_blocksize -
> -		offsetof(struct ocfs2_dinode, id2.i_list.l_recs);
> +	if (sb->s_blocksize != OCFS2_MIN_BLOCKSIZE)
> +		size = sb->s_blocksize -
> +			offsetof(struct ocfs2_dinode, id2.i_list.l_recs) -
> +			OCFS2_MAX_XATTR_INLINE_SIZE;
> +	else
> +		size = sb->s_blocksize -
> +			offsetof(struct ocfs2_dinode, id2.i_list.l_recs);
>  
>  	return size / sizeof(struct ocfs2_extent_rec);
>  }
> @@ -806,15 +820,26 @@ static inline int ocfs2_fast_symlink_chars(int blocksize)
>  
>  static inline int ocfs2_max_inline_data(int blocksize)
>  {
> -	return blocksize - offsetof(struct ocfs2_dinode, id2.i_data.id_data);
> +	if (blocksize != OCFS2_MIN_BLOCKSIZE)
> +		return blocksize -
> +			offsetof(struct ocfs2_dinode, id2.i_data.id_data) -
> +			OCFS2_MAX_XATTR_INLINE_SIZE;
> +	else
> +		return blocksize -
> +			offsetof(struct ocfs2_dinode, id2.i_data.id_data);
>  }
>  
>  static inline int ocfs2_extent_recs_per_inode(int blocksize)
>  {
>  	int size;
>  
> -	size = blocksize -
> -		offsetof(struct ocfs2_dinode, id2.i_list.l_recs);
> +	if (blocksize != OCFS2_MIN_BLOCKSIZE)
> +		size = blocksize -
> +			offsetof(struct ocfs2_dinode, id2.i_list.l_recs) -
> +			OCFS2_MAX_XATTR_INLINE_SIZE;
> +	else
> +		size = blocksize -
> +			offsetof(struct ocfs2_dinode, id2.i_list.l_recs);
>  
>  	return size / sizeof(struct ocfs2_extent_rec);
>  }

You can't just change these functions like that - by doing so, you are
effectively changing the disk format. Say I have an existing file system and
I run your code. Now the module is going to think some of my inline-data files
are too large, and that some of my extent lists have overflowed. New inodes
will have different values for no good reason (pretend that I don't have EA
support turned on yet).


I think what we need to do is replace some occurences of these calls with an
inode-block specific version of the function in question. The new functions
will take things like whether an inode has inline EA's into account. For
example:

static inline int ocfs2_max_inline_data(struct super_block *sb,
					struct ocfs2_dinode *di)
{
	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_XATTR_FL)
		return le64_to_cpu(di->i_xattr_loc) - 
			offsetof(struct ocfs2_dinode, id2.i_data.id_data);
	else
		return sb->s_blocksize -
			offsetof(struct ocfs2_dinode, id2.i_data.id_data);
}

You'll have to go through the code and determine where we need to use the
new functions. Please do this as a seperate patch by the way - it's a tricky
enough operation that I will refuse to read the change if it's intermingled
with other stuff.


> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index c223ab0..ed07448 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -21,6 +21,19 @@
>   * Boston, MA 021110-1307, USA.
>   */
>  
> +#include <linux/capability.h>
> +#include <linux/fs.h>
> +#include <linux/types.h>
> +#include <linux/slab.h>
> +#include <linux/highmem.h>
> +#include <linux/pagemap.h>
> +#include <linux/uio.h>
> +#include <linux/sched.h>
> +#include <linux/splice.h>
> +#include <linux/mount.h>
> +#include <linux/writeback.h>
> +#include <linux/falloc.h>
> +
>  #define MLOG_MASK_PREFIX ML_INODE
>  #include <cluster/masklog.h>
>  
> @@ -28,6 +41,7 @@
>  #include "alloc.h"
>  #include "dlmglue.h"
>  #include "file.h"
> +#include "sysfile.h"
>  #include "inode.h"
>  #include "journal.h"
>  #include "ocfs2_fs.h"
> @@ -36,6 +50,129 @@
>  #include "buffer_head_io.h"
>  #include "xattr.h"
>  
> +
> +#define OCFS2_XATTR_PAD_BITS	2
> +#define OCFS2_XATTR_PAD		4
> +#define OCFS2_XATTR_ROUND	(OCFS2_XATTR_PAD-1)
> +#define OCFS2_XATTR_SIZE(size)	(((size) + OCFS2_XATTR_ROUND) & \
> +				~OCFS2_XATTR_ROUND)
> +#define OCFS2_XATTR_ROOT_SIZE	(sizeof(struct ocfs2_xattr_def_value_root))
> +#define OCFS2_XATTR_INLINE_SIZE	80
> +#define OCFS2_NAME_HASH_SHIFT	5
> +#define OCFS2_VALUE_HASH_SHIFT	16

Some of these should be defined in the patch where they're actually used.


> +static struct ocfs2_xattr_def_value_root def_xv = {
> +	.xv.xr_list.l_count = cpu_to_le16(1),
> +};
> +
> +struct xattr_handler *ocfs2_xattr_handlers[] = {
> +	&ocfs2_xattr_user_handler,
> +#ifdef CONFIG_OCFS2_FS_POSIX_ACL
> +	&ocfs2_xattr_acl_access_handler,
> +	&ocfs2_xattr_acl_default_handler,
> +#endif
> +	&ocfs2_xattr_trusted_handler,
> +#ifdef CONFIG_OCFS2_FS_LUSTRE
> +	&ocfs2_xattr_lustre_handler,
> +#endif
> +#ifdef CONFIG_OCFS2_FS_SECURITY
> +	&ocfs2_xattr_security_handler,
> +#endif
> +	NULL
> +};
> +
> +static struct xattr_handler *ocfs2_xattr_handler_map[] = {
> +	[OCFS2_XATTR_INDEX_USER]	= &ocfs2_xattr_user_handler,
> +#ifdef CONFIG_OCFS2_FS_POSIX_ACL
> +	[OCFS2_XATTR_INDEX_POSIX_ACL_ACCESS]
> +					= &ocfs2_xattr_acl_access_handler,
> +	[OCFS2_XATTR_INDEX_POSIX_ACL_DEFAULT]
> +					= &ocfs2_xattr_acl_default_handler,
> +#endif
> +	[OCFS2_XATTR_INDEX_TRUSTED]	= &ocfs2_xattr_trusted_handler,
> +#ifdef CONFIG_OCFS2_FS_LUSTRE
> +	[OCFS2_XATTR_INDEX_LUSTRE]	= &ocfs2_xattr_lustre_handler,
> +#endif
> +#ifdef CONFIG_OCFS2_FS_SECURITY
> +	[OCFS2_XATTR_INDEX_SECURITY]	= &ocfs2_xattr_security_handler,
> +#endif
> +};
> +
> +struct ocfs2_xattr_info {
> +	int name_index;
> +	const char *name;
> +	const void *value;
> +	size_t value_len;
> +};
> +
> +struct ocfs2_xattr_search {
> +	struct buffer_head *inode_bh;
> +	struct buffer_head *xattr_bh;
> +	struct ocfs2_xattr_header *header;
> +	void *base;
> +	void *end;
> +	struct ocfs2_xattr_entry *here;
> +	int not_found;
> +};
> +
> +static inline u32 ocfs2_blocks_per_cluster(struct super_block *sb)
> +{
> +	return 1 << (OCFS2_SB(sb)->s_clustersize_bits - sb->s_blocksize_bits);
> +}

You could just:

#define ocfs2_blocks_per_cluster(_sb)	ocfs2_blocks_to_clusters((_sb), 1)


At any rate, this belongs in ocfs2.h.


> +static inline struct xattr_handler *ocfs2_xattr_handler(int name_index)
> +{
> +	struct xattr_handler *handler = NULL;
> +
> +	if (name_index > 0 && name_index < OCFS2_XATTR_MAX)
> +		handler = ocfs2_xattr_handler_map[name_index];
> +
> +	return handler;
> +}
> +
> +static inline __u32 ocfs2_xattr_name_hash(char *prefix,
> +					  int prefix_len,
> +					  char *name,
> +					  int name_len)
> +{
> +	__u32 hash = 0;
> +	int i;
> +
> +	for (i = 0; i < prefix_len; i++) {
> +		hash = (hash << OCFS2_NAME_HASH_SHIFT) ^
> +		       (hash >> (8*sizeof(hash) - OCFS2_NAME_HASH_SHIFT)) ^
> +		       *prefix++;
> +	}
> +
> +	for (i = 0; i < name_len; i++) {
> +		hash = (hash << OCFS2_NAME_HASH_SHIFT) ^
> +		       (hash >> (8*sizeof(hash) - OCFS2_NAME_HASH_SHIFT)) ^
> +		       *name++;
> +	}
> +	return hash;
> +}

What hash function is this? Where did you get it from? How good is it for
use with EA names? How good is it for other uses? Answers to all those
questions belong here in e-mail, as well as a nice big comment at the top of
this function.


Also, there's this item in the design doc:
 * need a random seed in super block which is never printed on console

We want to combine the random seed with the hashing process somehow so that
the results for a given name are not globally predictable for all Ocfs2 file
systems.


> +/*
> + * ocfs2_xattr_hash_entry()
> + *
> + * Compute the hash of an extended attribute.
> + */
> +static void ocfs2_xattr_hash_entry(struct ocfs2_xattr_header *header,
> +				   struct ocfs2_xattr_entry *entry)
> +{
> +	__u32 hash = 0;
> +	struct xattr_handler *handler = ocfs2_xattr_handler(entry->xe_type);
> +	char *prefix = handler->prefix;
> +	char *name = (char *)header + le16_to_cpu(entry->xe_name_offset);
> +	int prefix_len = strlen(handler->prefix);
> +
> +	hash = ocfs2_xattr_name_hash(prefix, prefix_len, name,
> +				     entry->xe_name_len);
> +	entry->xe_name_hash = cpu_to_le32(hash);
> +
> +	return;
> +}
> +
>  static int ocfs2_xattr_extend_allocation(struct inode *inode,
>  					 u32 clusters_to_add,
>  					 struct buffer_head *xattr_bh,
> @@ -50,7 +187,7 @@ static int ocfs2_xattr_extend_allocation(struct inode *inode,
>  	enum ocfs2_alloc_restarted why;
>  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>  	struct ocfs2_extent_list *root_el = &xv->xr_list;
> -	u32 logical_start = le16_to_cpu(xv->xr_clusters);
> +	u32 logical_start = le32_to_cpu(xv->xr_clusters);

Is this a bug fix? Next round, please just merge that into the patch which
introduces the code.


> +int ocfs2_xattr_get(struct inode *inode,
> +		    int name_index,
> +		    const char *name,
> +		    void *buffer,
> +		    size_t buffer_size)
> +{
> +	int ret;
> +	struct ocfs2_dinode *di = NULL;
> +	struct buffer_head *di_bh = NULL;
> +	struct ocfs2_xattr_search xis = {
> +		.not_found = -ENODATA,
> +	};
> +	struct ocfs2_xattr_search xbs = {
> +		.not_found = -ENODATA,
> +	};
> +
> +	ret = ocfs2_inode_lock(inode, &di_bh, 0);
> +	if (ret < 0) {
> +		mlog_errno(ret);
> +		return ret;
> +	}
> +	xis.inode_bh = xbs.inode_bh = di_bh;
> +	di = (struct ocfs2_dinode *)di_bh->b_data;
> +	if (!(le16_to_cpu(di->i_dyn_features) & OCFS2_HAS_XATTR_FL)) {

A lot of these checks are using the disk field, when it's faster and more
readable to look at the ocfs2_inode_info->ip_dyn_features.


> +		ret = -ENODATA;
> +		goto cleanup;
> +	}
> +
> +	ret = ocfs2_xattr_ibody_get(inode, name_index, name, buffer,
> +				    buffer_size, &xis);
> +	if (ret == -ENODATA)
> +		ret = ocfs2_xattr_block_get(inode, name_index, name, buffer,
> +					    buffer_size, &xbs);
> +cleanup:
> +	ocfs2_inode_unlock(inode, 0);
> +
> +	if (di_bh)
> +		brelse(di_bh);
> +	return ret;
> +}
> +

> +/*
> + * ocfs2_xattr_remove()
> + *
> + * Free extended attribute resources associated with this inode.
> + */
> +int ocfs2_xattr_remove(struct inode *inode, struct buffer_head *di_bh)
> +{
> +	struct ocfs2_xattr_block *xb;
> +	struct buffer_head *blk_bh = NULL;
> +	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +	handle_t *handle;
> +	int ret;
> +
> +	if (!(le16_to_cpu(di->i_dyn_features) & OCFS2_HAS_XATTR_FL))
> +		return 0;
> +
> +	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_XATTR_FL) {
> +		ret = ocfs2_xattr_ibody_remove(inode, di_bh);
> +		if (ret < 0)
> +			mlog_errno(ret);
> +	}
> +	if (di->i_xattr_loc) {
> +		ret = ocfs2_read_block(OCFS2_SB(inode->i_sb),
> +				       le64_to_cpu(di->i_xattr_loc),
> +				       &blk_bh, OCFS2_BH_CACHED, inode);
> +		if (ret)
> +			return ret;
> +		ret = ocfs2_xattr_block_remove(inode, blk_bh);
> +		if (ret < 0)
> +			mlog_errno(ret);
> +	}
> +
> +	handle = ocfs2_start_trans((OCFS2_SB(inode->i_sb)),
> +				   OCFS2_INODE_UPDATE_CREDITS);
> +	if (IS_ERR(handle)) {
> +		ret = PTR_ERR(handle);
> +		goto out;
> +	}
> +	ret = ocfs2_journal_access(handle, inode, di_bh,
> +				   OCFS2_JOURNAL_ACCESS_WRITE);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out_commit;
> +	}
> +
> +	if (di->i_xattr_loc) {
> +		xb = (struct ocfs2_xattr_block *)blk_bh->b_data;
> +		ocfs2_xattr_free_block(handle, osb, xb);
> +		di->i_xattr_loc = cpu_to_le64(0);
> +	}
> +
> +	di->i_dyn_features = cpu_to_le16(le16_to_cpu(di->i_dyn_features) &
> +					 !OCFS2_INLINE_XATTR_FL &
> +					 !OCFS2_HAS_XATTR_FL);

You aren't updating OCFS2_I(inode)->ip_dyn_features, and boy is this code
confusing to read. Also, I'm not sure '!' is the operator you want to use.
This is so much better:

struct ocfs2_inode_info *oi = OCFS2_I(inode);

...

oi->ip_dyn_features &= ~(OCFS2_INLINE_XATTR_FL|OCFS2_HAS_XATTR_FL);
di->i_dyn_features = cpu_to_le16(oi->ip_dyn_features);


> +	ret = ocfs2_journal_dirty(handle, di_bh);
> +	if (ret < 0)
> +		mlog_errno(ret);
> +out_commit:
> +	ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
> +out:
> +	if (blk_bh)
> +		brelse(blk_bh);
> +	return ret;
> +}
> +
> +static int ocfs2_xattr_update_flag(struct inode *inode,
> +				   struct buffer_head *di_bh,
> +				   int flag)
> +{
> +	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
> +	handle_t *handle = NULL;
> +	int ret = 0;
> +
> +	handle = ocfs2_start_trans((OCFS2_SB(inode->i_sb)),
> +				   OCFS2_INODE_UPDATE_CREDITS);
> +	if (IS_ERR(handle)) {
> +		ret = PTR_ERR(handle);
> +		goto out;
> +	}
> +	ret = ocfs2_journal_access(handle, inode, di_bh,
> +				   OCFS2_JOURNAL_ACCESS_WRITE);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out_commit;
> +	}
> +

Again, you aren't updating OCFS2_I(inode)->ip_dyn_features.


> +	di->i_dyn_features = cpu_to_le16(le16_to_cpu(di->i_dyn_features) |
> +					 flag);
> +	ret = ocfs2_journal_dirty(handle, di_bh);
> +	if (ret < 0)
> +		mlog_errno(ret);
> +out_commit:
> +	ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
> +out:
> +	return ret;
> +}
> +
--
Mark Fasheh
