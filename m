From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 25 Jul 2008 15:52:36 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2-tools: Add extended attribute
 support in fsck.ocfs2
In-Reply-To: <1216969599-9280-2-git-send-email-tiger.yang@oracle.com>
References: <1216969599-9280-1-git-send-email-tiger.yang@oracle.com>
	<1216969599-9280-2-git-send-email-tiger.yang@oracle.com>
Message-ID: <48898644.9090307@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Tiger Yang wrote:

> +#include <string.h>
> +#include <inttypes.h>
> +
> +#include "ocfs2/byteorder.h"
> +#include "ocfs2/ocfs2.h"
> +
> +#include "xattr.h"
> +#include "extent.h"
> +#include "fsck.h"
> +#include "problem.h"
> +#include "util.h"
> +
> +static const char *whoami = "xattr.c";
> +
> +static inline int ocfs2_xattr_extent_recs_per_inode(int blocksize)
> +{
> +	int size;
> +
> +	size = blocksize - offsetof(struct ocfs2_xattr_block,
> +				    xb_attrs.xb_root.xt_list.l_recs);
> +
> +	return (size / sizeof(struct ocfs2_extent_rec));
> +}
I remember with 512, there is no xattr in inode.
> +
> +static inline uint16_t ocfs2_xattr_buckets_per_cluster(ocfs2_filesys *fs)
> +{
> +	return (fs->fs_clustersize / OCFS2_XATTR_BUCKET_SIZE);
> +}
> +
> +static inline uint16_t ocfs2_blocks_per_xattr_bucket(ocfs2_filesys *fs)
> +{
> +	return (OCFS2_XATTR_BUCKET_SIZE / fs->fs_blocksize);
> +}
> +
> +static errcode_t check_xattr(o2fsck_state *ost,
> +			     struct ocfs2_dinode *di,
> +			     struct ocfs2_xattr_header *xh,
> +			     int *changed)
> +{
> +	struct extent_info ei = {0, };
> +	int i;
> +	errcode_t ret = 0;
> +
> +	for (i = 0 ; i < xh->xh_count; i++) {
> +		int change = 0;
> +		struct ocfs2_xattr_entry *xe = &xh->xh_entries[i];
> +
> +		if (!xe->xe_local) {
> +			struct ocfs2_xattr_value_root *xv =
> +				(struct ocfs2_xattr_value_root *)
> +				((void *)xh + xe->xe_name_offset +
> +				OCFS2_XATTR_SIZE(xe->xe_name_len));
> +			struct ocfs2_extent_list *el = &xv->xr_list;
> +			ret = check_el(ost, &ei, di, el, 1, &change);
> +			if (ret)
> +				break;
> +			if (change) {
> +				*changed = 1;
> +				ocfs2_swap_extent_list_from_cpu(el);
> +			}
> +		}
> +	}
> +
> +	return ret;
> +}
> +
> +static errcode_t ocfs2_xattr_get_rec(o2fsck_state *ost,
> +				     struct ocfs2_dinode *di,
> +				     uint32_t name_hash,
> +				     uint64_t *p_blkno,
> +				     uint32_t *e_cpos,
> +				     uint32_t *num_clusters,
> +				     struct ocfs2_extent_list *el)
> +{
> +	int i;
> +	errcode_t ret = 0;
> +	char *eb_buf = NULL;
> +	struct ocfs2_extent_block *eb;
> +	struct ocfs2_extent_rec *rec = NULL;
> +	uint64_t e_blkno = 0;
> +
> +	if (el->l_tree_depth) {
> +		ret = ocfs2_find_leaf(ost->ost_fs, di, el, name_hash, &eb_buf);
> +		if (ret) {
> +			com_err(whoami, ret, "while finding leaf of xattr "
> +				"tree");
> +			goto out;
> +		}
> +
> +		eb = (struct ocfs2_extent_block *) eb_buf;
> +		el = &eb->h_list;
> +
> +		if (el->l_tree_depth) {
> +			ret = -1;
> +			goto out;
> +		}
> +	}
> +
> +	for (i = le16_to_cpu(el->l_next_free_rec) - 1; i >= 0; i--) {
no le16_to_cpu in tools. there are also some below, please remove them.
> +		rec = &el->l_recs[i];
> +
> +		if (le32_to_cpu(rec->e_cpos) <= name_hash) {
> +			e_blkno = le64_to_cpu(rec->e_blkno);
> +			break;
> +		}
> +	}
> +
> +	if (!e_blkno) {
> +		ret = -1;
> +		goto out;
> +	}
> +
> +	*p_blkno = le64_to_cpu(rec->e_blkno);
> +	*num_clusters = le16_to_cpu(rec->e_leaf_clusters);
> +	if (e_cpos)
> +		*e_cpos = le32_to_cpu(rec->e_cpos);
> +out:
> +	if (eb_buf)
> +		ocfs2_free(&eb_buf);
> +	return ret;
> +}
> +
> +static errcode_t ocfs2_iterate_xattr_buckets(o2fsck_state *ost,
> +					     struct ocfs2_dinode *di,
> +					     uint64_t blkno,
> +					     uint32_t clusters)
> +{
> +	int i;
> +	errcode_t ret = 0;
> +	char *bucket = NULL;
> +	struct ocfs2_xattr_header *xh;
> +	int block_num = ocfs2_blocks_per_xattr_bucket(ost->ost_fs);
> +	uint32_t bpc = ocfs2_xattr_buckets_per_cluster(ost->ost_fs);
> +	uint32_t bucket_num = clusters * bpc;
> +	char *bhs = NULL;
> +
> +
> +	ret = ocfs2_malloc_blocks(ost->ost_fs->fs_io, block_num, &bhs);
> +	if (ret) {
> +		com_err(whoami, ret, "while allocating room to read bucket "
> +			"of xattr data");
> +		goto out;
> +	}
> +
> +	for (i = 0; i < bucket_num; i++, blkno += block_num) {
> +		int changed = 0;
> +
> +		ret = io_read_block(ost->ost_fs->fs_io, blkno, block_num, bhs);
bucket size isn't block size. So you can't just read and handle the 
first block for a bucket. the same for the write.

> +		if (ret) {
> +			com_err(whoami, ret, "while reading blocks of xattr "
> +				"bucket");
> +			goto out;
> +		}
> +
> +		bucket = bhs;
> +
> +		xh = (struct ocfs2_xattr_header *)bucket;
> +		ocfs2_swap_xattr_header(xh);
> +		ocfs2_swap_xattr_entries_to_cpu(xh);
> +		/*
> +		 * The real bucket num in this series of blocks is stored
> +		 * in the 1st bucket.
> +		 */
> +		if (i == 0)
> +			bucket_num = le16_to_cpu(xh->xh_reserved1);
> +
> +		ret = check_xattr(ost, di, xh, &changed);
> +		if (ret)
> +			break;
> +		if (changed) {
> +			ocfs2_swap_xattr_entries_from_cpu(xh);
> +			ocfs2_swap_xattr_header(xh);
> +			io_write_block(ost->ost_fs->fs_io, blkno, block_num,
> +				       bhs);
> +		}
> +	}
> +out:
> +	ocfs2_free(&bhs);
> +
> +	return ret;
> +}
> +
> +static errcode_t o2fsck_check_xattr_index_block(
> +					o2fsck_state *ost,
> +					struct ocfs2_dinode *di,
> +					struct ocfs2_xattr_tree_root *xt,
> +					int *changed)
> +{
> +	struct ocfs2_extent_list *el = &xt->xt_list;
> +	errcode_t ret = 0;
> +	uint32_t name_hash = UINT_MAX, e_cpos = 0, num_clusters = 0;
> +	uint64_t p_blkno = 0;
> +	struct extent_info ei = {0, };
> +
> +	if (el->l_next_free_rec == 0)
> +		return 0;
> +
> +	ret = check_el(ost, &ei, di, el,
> +		ocfs2_xattr_extent_recs_per_inode(ost->ost_fs->fs_blocksize),
> +		changed);
> +	if (ret)
> +		return ret;
> +
> +	while (name_hash > 0) {
> +		ret = ocfs2_xattr_get_rec(ost, di, name_hash, &p_blkno,
> +					  &e_cpos, &num_clusters, el);
> +		if (ret) {
> +			com_err(whoami, ret, "while getting bucket record "
> +				"of xattr data.");
> +			goto out;
> +		}
> +
> +		ret = ocfs2_iterate_xattr_buckets(ost, di, p_blkno,
> +						  num_clusters);
> +		if (ret) {
> +			com_err(whoami, ret, "while iterating buckets "
> +				"of xattr data.");
> +			goto out;
> +		}
> +
> +		if (e_cpos == 0)
> +			break;
> +
> +		name_hash = e_cpos - 1;
> +	}
> +	if (*changed)
> +		ocfs2_swap_extent_list_from_cpu(el);
> +
> +out:
> +	return ret;
> +}
> +
> +static errcode_t o2fsck_check_xattr_ibody(o2fsck_state *ost,
> +					  struct ocfs2_dinode *di)
> +{
> +	errcode_t ret;
> +	struct ocfs2_xattr_header *xh = NULL;
> +	int changed = 0;
> +
> +	xh = (struct ocfs2_xattr_header *)
> +		 ((void *)di + ost->ost_fs->fs_blocksize -
> +		  di->i_xattr_inline_size);
> +
> +	ocfs2_swap_xattr_header(xh);
> +	ocfs2_swap_xattr_entries_to_cpu(xh);
> +
> +	ret = check_xattr(ost, di, xh, &changed);
> +
> +	if (changed) {
> +		ocfs2_swap_xattr_entries_from_cpu(xh);
> +		ocfs2_swap_xattr_header(xh);
> +		o2fsck_write_inode(ost, di->i_blkno, di);
> +	}
> +	return ret;
> +}
> +
> +static errcode_t o2fsck_check_xattr_block(o2fsck_state *ost,
> +					  struct ocfs2_dinode *di)
> +{
> +	errcode_t ret;
> +	char *blk = NULL;
> +	struct ocfs2_xattr_block *xb = NULL;
> +	int changed = 0;
> +
> +	o2fsck_mark_cluster_allocated(ost,
> +		ocfs2_blocks_to_clusters(ost->ost_fs, di->i_xattr_loc));
> +
> +	ret = ocfs2_malloc_block(ost->ost_fs->fs_io, &blk);
> +	if (ret) {
> +		com_err(whoami, ret, "while allocating room to read block "
> +			"of xattr.");
> +		return ret;
> +	}
> +
> +	ret = ocfs2_read_xattr_block(ost->ost_fs, di->i_xattr_loc, blk);
> +	if (ret) {
> +		com_err(whoami, ret, "while reading externel block of xattr.");
> +		return ret;
> +	}
> +
> +	xb = (struct ocfs2_xattr_block *)blk;
> +
> +	if (!(xb->xb_flags & OCFS2_XATTR_INDEXED)) {
> +		struct ocfs2_xattr_header *xh = &xb->xb_attrs.xb_header;
> +
> +		ret = check_xattr(ost, di, xh, &changed);
> +	} else {
> +		struct ocfs2_xattr_tree_root *xt = &xb->xb_attrs.xb_root;
> +
> +		ret = o2fsck_check_xattr_index_block(ost, di, xt, &changed);
> +	}
> +
> +	if (changed)
> +		ocfs2_write_xattr_block(ost->ost_fs, di->i_xattr_loc, blk);
> +
> +	if (blk)
> +		ocfs2_free(&blk);
> +
> +	return ret;
> +}
> +
> +/*
> + * o2fsck_check_xattr
> + *
> + * Check extended attribute in inode block or external block.
> + */
> +errcode_t o2fsck_check_xattr(o2fsck_state *ost,
> +			     struct ocfs2_dinode *di)
> +{
> +	errcode_t ret = 0;
> +
> +	if (!(di->i_dyn_features & OCFS2_HAS_XATTR_FL))
> +		return 0;
> +
> +	if (di->i_dyn_features & OCFS2_HAS_XATTR_FL) {
you mean inline_xattr here?
> +		ret = o2fsck_check_xattr_ibody(ost, di);
> +		if (ret)
> +			return ret;
> +	}
> +	if (di->i_xattr_loc)
> +		ret = o2fsck_check_xattr_block(ost, di);
> +
> +	return ret;
> +}
> diff --git a/include/ocfs2-kernel/ocfs2_fs.h b/include/ocfs2-kernel/ocfs2_fs.h
> index ade9ec1..ee44be8 100644
> --- a/include/ocfs2-kernel/ocfs2_fs.h
> +++ b/include/ocfs2-kernel/ocfs2_fs.h
> @@ -728,6 +728,13 @@ struct ocfs2_group_desc
>  /* Inline extended attribute size (in bytes) */
>  #define OCFS2_MIN_XATTR_INLINE_SIZE     256
>  
> +#define OCFS2_XATTR_BUCKET_SIZE		4096
> +
> +#define OCFS2_XATTR_ROUND		3
> +
> +#define OCFS2_XATTR_SIZE(size)  (((size) + OCFS2_XATTR_ROUND) & \
> +				~(OCFS2_XATTR_ROUND))
> +
>  struct ocfs2_xattr_entry {
>  	__le32	xe_name_hash;
>  	__le16	xe_name_offset;
> diff --git a/include/ocfs2/ocfs2.h b/include/ocfs2/ocfs2.h
> index 1f81c47..6aadd46 100644
> --- a/include/ocfs2/ocfs2.h
> +++ b/include/ocfs2/ocfs2.h
> @@ -291,6 +291,7 @@ errcode_t ocfs2_get_clusters(ocfs2_cached_inode *cinode,
>  			     uint32_t *num_clusters,
>  			     uint16_t *extent_flags);
>  int ocfs2_find_leaf(ocfs2_filesys *fs, struct ocfs2_dinode *di,
> +		    struct ocfs2_extent_list *el,
>  		    uint32_t cpos, char **leaf_buf);
>  int ocfs2_search_extent_list(struct ocfs2_extent_list *el, uint32_t v_cluster);
>  void ocfs2_swap_journal_superblock(journal_superblock_t *jsb);
> @@ -942,5 +943,10 @@ errcode_t ocfs2_block_iterate_inode(ocfs2_filesys *fs,
>  				    void *priv_data);
>  
>  uint32_t xattr_uuid_hash(unsigned char *uuid);
> +void ocfs2_swap_xattr_entries_to_cpu(struct ocfs2_xattr_header *xh);
> +void ocfs2_swap_xattr_entries_from_cpu(struct ocfs2_xattr_header *xh);
> +void ocfs2_swap_xattr_header(struct ocfs2_xattr_header *xh);
> +void ocfs2_swap_xattr_block_from_cpu(struct ocfs2_xattr_block *xb);
> +void ocfs2_swap_xattr_block_to_cpu(struct ocfs2_xattr_block *xb);
>  
>  #endif  /* _FILESYS_H */
> diff --git a/libocfs2/extend_file.c b/libocfs2/extend_file.c
> index 1cb4a00..4cc7a94 100644
> --- a/libocfs2/extend_file.c
> +++ b/libocfs2/extend_file.c
> @@ -997,16 +997,16 @@ static int ocfs2_find_path(ocfs2_filesys *fs, struct ocfs2_path *path,
>   * This function doesn't handle non btree extent lists.
>   */
>  int ocfs2_find_leaf(ocfs2_filesys *fs, struct ocfs2_dinode *di,
> +		    struct ocfs2_extent_list *el,
>  		    uint32_t cpos, char **leaf_buf)
>  {
>  	int ret;
>  	char *buf = NULL;
>  	struct ocfs2_path *path = NULL;
> -	struct ocfs2_extent_list *el = &di->id2.i_list;
>  
>  	assert(el->l_tree_depth > 0);
>  
> -	path = ocfs2_new_inode_path(fs, di);
> +	path = ocfs2_new_path(fs, (char *)di, el);
>  	if (!path) {
>  		ret = OCFS2_ET_NO_MEMORY;
>  		goto out;
> diff --git a/libocfs2/extent_map.c b/libocfs2/extent_map.c
> index 7e5f8fe..dd081fc 100644
> --- a/libocfs2/extent_map.c
> +++ b/libocfs2/extent_map.c
> @@ -147,7 +147,7 @@ errcode_t ocfs2_get_clusters(ocfs2_cached_inode *cinode,
>  	el = &di->id2.i_list;
>  
>  	if (el->l_tree_depth) {
> -		ret = ocfs2_find_leaf(fs, di, v_cluster, &eb_buf);
> +		ret = ocfs2_find_leaf(fs, di, el, v_cluster, &eb_buf);
>  		if (ret)
>  			goto out;
>  
> diff --git a/libocfs2/ocfs2_err.et b/libocfs2/ocfs2_err.et
> index 9b33a3b..88b3366 100644
> --- a/libocfs2/ocfs2_err.et
> +++ b/libocfs2/ocfs2_err.et
> @@ -171,4 +171,7 @@ ec	OCFS2_ET_NO_BACKUP_SUPER,
>  ec      OCFS2_ET_TOO_MANY_SLOTS,
>          "Too many slots for slot map"
>  
> +ec	OCFS2_ET_BAD_XATTR_BLOCK_MAGIC,
> +	"Bad magic number in xattr block"
> +
>  	end
> diff --git a/libocfs2/xattr.c b/libocfs2/xattr.c
> index d198743..767b333 100644
> --- a/libocfs2/xattr.c
> +++ b/libocfs2/xattr.c
> @@ -35,3 +35,113 @@ uint32_t xattr_uuid_hash(unsigned char *uuid)
>  	return hash;
>  }
>  
> +static void ocfs2_swap_xattr_tree_root(struct ocfs2_xattr_tree_root *xt)
> +{
> +	xt->xt_clusters		= bswap_16(xt->xt_clusters);
> +	xt->xt_last_eb_blk	= bswap_16(xt->xt_last_eb_blk);
> +}
> +
> +static void ocfs2_swap_xattr_value_root(struct ocfs2_xattr_value_root *xr)
> +{
> +	xr->xr_clusters		= bswap_16(xr->xr_clusters);
> +	xr->xr_last_eb_blk	= bswap_16(xr->xr_last_eb_blk);
> +}
> +
> +static void ocfs2_swap_xattr_block_header(struct ocfs2_xattr_block *xb)
> +{
> +	xb->xb_suballoc_slot	= bswap_16(xb->xb_suballoc_slot);
> +	xb->xb_suballoc_bit	= bswap_16(xb->xb_suballoc_bit);
> +	xb->xb_fs_generation	= bswap_32(xb->xb_fs_generation);
> +	xb->xb_csum 		= bswap_32(xb->xb_csum);
> +	xb->xb_flags		= bswap_16(xb->xb_flags);
> +	xb->xb_blkno		= bswap_64(xb->xb_blkno);
> +}
> +
> +void ocfs2_swap_xattr_entries_to_cpu(struct ocfs2_xattr_header *xh)
> +{
> +	uint16_t i;
> +
> +	if (cpu_is_little_endian)
> +		return;
> +
> +	for (i = 0; i < xh->xh_count; i++) {
> +		struct ocfs2_xattr_entry *xe = &xh->xh_entries[i];
> +
> +		xe->xe_name_offset	= bswap_16(xe->xe_name_offset);
> +		xe->xe_value_size	= bswap_64(xe->xe_value_size);
> +
> +		if (!xe->xe_local) {
> +			struct ocfs2_xattr_value_root *xr =
> +				(struct ocfs2_xattr_value_root *)
> +				((char *)xh + xe->xe_name_offset +
> +				OCFS2_XATTR_SIZE(xe->xe_name_len));
> +
> +			ocfs2_swap_xattr_value_root(xr);
> +			ocfs2_swap_extent_list_to_cpu(&xr->xr_list);
> +		}
> +	}
> +}
> +
> +void ocfs2_swap_xattr_entries_from_cpu(struct ocfs2_xattr_header *xh)
> +{
> +	uint16_t i;
> +
> +	if (cpu_is_little_endian)
> +		return;
> +
> +	for (i = 0; i < xh->xh_count; i++) {
> +		struct ocfs2_xattr_entry *xe = &xh->xh_entries[i];
> +
> +		if (!xe->xe_local) {
> +			struct ocfs2_xattr_value_root *xr =
> +				(struct ocfs2_xattr_value_root *)
> +				((char *)xh + xe->xe_name_offset +
> +				OCFS2_XATTR_SIZE(xe->xe_name_len));
> +
> +			ocfs2_swap_xattr_value_root(xr);
> +		}
> +		xe->xe_name_offset	= bswap_16(xe->xe_name_offset);
> +		xe->xe_value_size	= bswap_64(xe->xe_value_size);
> +	}
> +}
> +
> +void ocfs2_swap_xattr_header(struct ocfs2_xattr_header *xh)
> +{
> +	if (cpu_is_little_endian)
> +		return;
> +
> +	xh->xh_count		= bswap_16(xh->xh_count);
> +	xh->xh_reserved1	= bswap_16(xh->xh_reserved1);
> +	xh->xh_csum		= bswap_32(xh->xh_csum);
> +}
> +
> +void ocfs2_swap_xattr_block_from_cpu(struct ocfs2_xattr_block *xb)
> +{
> +	if (cpu_is_little_endian)
> +		return;
> +
> +	if (!(xb->xb_flags & OCFS2_XATTR_INDEXED)) {
you should handle xb_flags swap first.
> +		ocfs2_swap_xattr_entries_from_cpu(&xb->xb_attrs.xb_header);
> +		ocfs2_swap_xattr_header(&xb->xb_attrs.xb_header);
> +	} else {
> +		ocfs2_swap_xattr_tree_root(&xb->xb_attrs.xb_root);
> +	}
> +
> +	ocfs2_swap_xattr_block_header(xb);
> +}
> +
> +void ocfs2_swap_xattr_block_to_cpu(struct ocfs2_xattr_block *xb)
> +{
> +	if (cpu_is_little_endian)
> +		return;
> +
> +	ocfs2_swap_xattr_block_header(xb);
> +	if (!(xb->xb_flags & OCFS2_XATTR_INDEXED)) {
> +		ocfs2_swap_xattr_header(&xb->xb_attrs.xb_header);
> +		ocfs2_swap_xattr_entries_to_cpu(&xb->xb_attrs.xb_header);
> +	} else {
> +		ocfs2_swap_xattr_tree_root(&xb->xb_attrs.xb_root);
> +		ocfs2_swap_extent_list_to_cpu(&xb->xb_attrs.xb_root.xt_list);
> +	}
> +}
> +
