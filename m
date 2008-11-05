From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 5 Nov 2008 14:49:20 -0800
Subject: [Ocfs2-devel] [PATCH 25/29] ocfs2: Implementation of local and
	global quota file handling
In-Reply-To: <12248861041077-git-send-email-jack@suse.cz>
References: <122488610212-git-send-email-jack@suse.cz>
	<12248861041077-git-send-email-jack@suse.cz>
Message-ID: <20081105224920.GW15154@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Oct 25, 2008 at 12:08:18AM +0200, Jan Kara wrote:
> @@ -3450,6 +3485,108 @@ static int ocfs2_dentry_convert_worker(struct ocfs2_lock_res *lockres,
>  	return UNBLOCK_CONTINUE_POST;
>  }
>  
> +static void ocfs2_set_qinfo_lvb(struct ocfs2_lock_res *lockres)
> +{
> +	struct ocfs2_qinfo_lvb *lvb;
> +	struct ocfs2_mem_dqinfo *oinfo = ocfs2_lock_res_qinfo(lockres);
> +	struct mem_dqinfo *info = sb_dqinfo(oinfo->dqi_gi.dqi_sb,
> +					    oinfo->dqi_gi.dqi_type);
> +
> +	mlog_entry_void();
> +
> +	lvb = (struct ocfs2_qinfo_lvb *)ocfs2_dlm_lvb(&lockres->l_lksb);
> +	lvb->lvb_version   = OCFS2_LVB_VERSION;

You might want your own 'OCFS2_QINFO_LVB_VERSION' value. That one is
misnamed in that it actually only governs meta data lvbs. If we changed the
meta data lvb format, we'd want to bump it seperately from the quote lvb
format version and vice-versa. We should probably rename OCFS2_LVB_VERSION
to OCFS2_INODE_LVB_VERSION at some point too, but don't feel like you have
to do that in this series.


> +	lvb->lvb_bgrace = cpu_to_be32(info->dqi_bgrace);
> +	lvb->lvb_igrace = cpu_to_be32(info->dqi_igrace);
> +	lvb->lvb_syncms = cpu_to_be32(oinfo->dqi_syncms);
> +	lvb->lvb_blocks = cpu_to_be32(oinfo->dqi_gi.dqi_blocks);
> +	lvb->lvb_free_blk = cpu_to_be32(oinfo->dqi_gi.dqi_free_blk);
> +	lvb->lvb_free_entry = cpu_to_be32(oinfo->dqi_gi.dqi_free_entry);
> +
> +	mlog_exit_void();
> +}
> +
> +void ocfs2_qinfo_unlock(struct ocfs2_mem_dqinfo *oinfo, int ex)
> +{
> +	struct ocfs2_lock_res *lockres = &oinfo->dqi_gqlock;
> +	struct ocfs2_super *osb = OCFS2_SB(oinfo->dqi_gi.dqi_sb);
> +	int level = ex ? DLM_LOCK_EX : DLM_LOCK_PR;
> +
> +	mlog_entry_void();
> +	if (!ocfs2_is_hard_readonly(osb) && !ocfs2_mount_local(osb))
> +		ocfs2_cluster_unlock(osb, lockres, level);
> +	mlog_exit_void();
> +}
> +
> +/* Lock quota info, this function expects at least shared lock on the quota file
> + * so that we can safely refresh quota info from disk. */
> +int ocfs2_qinfo_lock(struct ocfs2_mem_dqinfo *oinfo, int ex)
> +{
> +	struct mem_dqinfo *info = sb_dqinfo(oinfo->dqi_gi.dqi_sb,
> +					    oinfo->dqi_gi.dqi_type);
> +	struct ocfs2_lock_res *lockres = &oinfo->dqi_gqlock;
> +	struct ocfs2_super *osb = OCFS2_SB(oinfo->dqi_gi.dqi_sb);
> +	struct ocfs2_qinfo_lvb *lvb;
> +	int level = ex ? DLM_LOCK_EX : DLM_LOCK_PR;
> +	int status = 0;
> +	struct buffer_head *bh;
> +	struct ocfs2_global_disk_dqinfo *gdinfo;
> +
> +	mlog_entry_void();
> +
> +	/* We'll allow faking a readonly metadata lock for
> +	 * rodevices. */

You might want to update this comment   ;)


> +	if (ocfs2_is_hard_readonly(osb)) {
> +		if (ex)
> +			status = -EROFS;
> +		goto bail;
> +	}
> +	if (ocfs2_mount_local(osb))
> +		goto bail;
> +
> +	status = ocfs2_cluster_lock(osb, lockres, level, 0, 0);
> +	if (status < 0) {
> +		mlog_errno(status);
> +		goto bail;
> +	}
> +	if (!ocfs2_should_refresh_lock_res(lockres))
> +		goto bail;
> +	/* OK, we have the lock but we need to refresh the quota info */
> +	lvb = ocfs2_dlm_lvb(&lockres->l_lksb);
> +	if (lvb->lvb_version == OCFS2_LVB_VERSION) {
> +		info->dqi_bgrace = be32_to_cpu(lvb->lvb_bgrace);
> +		info->dqi_igrace = be32_to_cpu(lvb->lvb_igrace);
> +		oinfo->dqi_syncms = be32_to_cpu(lvb->lvb_syncms);
> +		oinfo->dqi_gi.dqi_blocks = be32_to_cpu(lvb->lvb_blocks);
> +		oinfo->dqi_gi.dqi_free_blk = be32_to_cpu(lvb->lvb_free_blk);
> +		oinfo->dqi_gi.dqi_free_entry =
> +					be32_to_cpu(lvb->lvb_free_entry);
> +	} else {
> +		bh = ocfs2_read_quota_block(oinfo->dqi_gqinode, 0, &status);
> +		if (!bh) {
> +			ocfs2_qinfo_unlock(oinfo, ex);
> +			mlog_errno(status);
> +			goto bail_refresh;
> +		}
> +		gdinfo = (struct ocfs2_global_disk_dqinfo *)
> +					(bh->b_data + OCFS2_GLOBAL_INFO_OFF);
> +		info->dqi_bgrace = le32_to_cpu(gdinfo->dqi_bgrace);
> +		info->dqi_igrace = le32_to_cpu(gdinfo->dqi_igrace);
> +		oinfo->dqi_syncms = le32_to_cpu(gdinfo->dqi_syncms);
> +		oinfo->dqi_gi.dqi_blocks = le32_to_cpu(gdinfo->dqi_blocks);
> +		oinfo->dqi_gi.dqi_free_blk = le32_to_cpu(gdinfo->dqi_free_blk);
> +		oinfo->dqi_gi.dqi_free_entry =
> +					le32_to_cpu(gdinfo->dqi_free_entry);
> +		brelse(bh);
> +		ocfs2_track_lock_refresh(lockres);
> +	}
> +bail_refresh:
> +	ocfs2_complete_lock_res_refresh(lockres, status);

Can we put the refresh logic in another function, please?


> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
> index dd17137..04bebd2 100644
> --- a/fs/ocfs2/ocfs2_fs.h
> +++ b/fs/ocfs2/ocfs2_fs.h
> @@ -878,6 +878,101 @@ static inline int ocfs2_xattr_get_type(struct ocfs2_xattr_entry *xe)
>  	return xe->xe_type & OCFS2_XATTR_TYPE_MASK;
>  }
>  
> +/*
> + *  On disk structures for global quota file
> + */
> +
> +/* Magic numbers and known versions for global quota files */
> +#define OCFS2_GLOBAL_QMAGICS {\
> +	0x0cf52470, /* USRQUOTA */ \
> +	0x0cf52471  /* GRPQUOTA */ \
> +}
> +
> +#define OCFS2_GLOBAL_QVERSIONS {\
> +	0, \
> +	0, \
> +}
> +
> +/* Generic header of all quota files */
> +struct ocfs2_disk_dqheader {
> +	__le32 dqh_magic;	/* Magic number identifying file */
> +	__le32 dqh_version;	/* Quota format version */
> +};
> +
> +#define OCFS2_GLOBAL_INFO_OFF (sizeof(struct ocfs2_disk_dqheader))
> +
> +/* Information header of global quota file (immediately follows the generic
> + * header) */
> +struct ocfs2_global_disk_dqinfo {
> +/*00*/	__le32 dqi_bgrace;
> +	__le32 dqi_igrace;
> +	__le32 dqi_syncms;
> +	__le32 dqi_blocks;
> +/*10*/	__le32 dqi_free_blk;
> +	__le32 dqi_free_entry;
> +};

Can we get some comments explaining the fields in this structure? I had to
search around to get the idea behind some of them...


> +/* Structure with global user / group information. We reserve some space
> + * for future use. */
> +struct ocfs2_global_disk_dqblk {
> +/*00*/	__le32 dqb_id;          /* ID the structure belongs to */
> +	__le32 dqb_use_count;   /* Number of nodes having reference to this structure */
> +	__le64 dqb_ihardlimit;  /* absolute limit on allocated inodes */
> +/*10*/	__le64 dqb_isoftlimit;  /* preferred inode limit */
> +	__le64 dqb_curinodes;   /* current # allocated inodes */
> +/*20*/	__le64 dqb_bhardlimit;  /* absolute limit on disk space */
> +	__le64 dqb_bsoftlimit;  /* preferred limit on disk space */
> +/*30*/	__le64 dqb_curspace;    /* current space occupied */
> +	__le64 dqb_btime;       /* time limit for excessive disk use */
> +/*40*/	__le64 dqb_itime;       /* time limit for excessive inode use */
> +	__le64 dqb_pad1;
> +/*50*/	__le64 dqb_pad2;
> +};
> +
> +/*
> + *  On-disk structures for local quota file
> + */
> +
> +/* Magic numbers and known versions for local quota files */
> +#define OCFS2_LOCAL_QMAGICS {\
> +	0x0cf524c0, /* USRQUOTA */ \
> +	0x0cf524c1  /* GRPQUOTA */ \
> +}
> +
> +#define OCFS2_LOCAL_QVERSIONS {\
> +	0, \
> +	0, \
> +}
> +
> +/* Quota flags in dqinfo header */
> +#define OLQF_CLEAN	0x0001	/* Quota file is empty (this should be after\
> +				 * quota has been cleanly turned off) */
> +
> +#define OCFS2_LOCAL_INFO_OFF (sizeof(struct ocfs2_disk_dqheader))
> +
> +/* Information header of local quota file (immediately follows the generic
> + * header) */
> +struct ocfs2_local_disk_dqinfo {
> +	__le32 dqi_flags;	/* Flags for quota file */
> +	__le32 dqi_chunks;	/* Number of chunks of quota structures
> +				 * with a bitmap */
> +	__le32 dqi_blocks;	/* Number of blocks allocated for quota file */
> +};
> +
> +/* Header of one chunk of a quota file */
> +struct ocfs2_local_disk_chunk {
> +	__le32 dqc_free;	/* Number of free entries in the bitmap */
> +	u8 dqc_bitmap[0];	/* Bitmap of entries in the corresponding
> +				 * chunk of quota file */
> +};
> +
> +/* One entry in local quota file */
> +struct ocfs2_local_disk_dqblk {
> +/*00*/	__le64 dqb_id;		/* id this quota applies to */
> +	__le64 dqb_spacemod;	/* Change in the amount of used space */
> +/*10*/	__le64 dqb_inodemod;	/* Change in the amount of used inodes */
> +};
> +
>  #ifdef __KERNEL__
>  static inline int ocfs2_fast_symlink_chars(struct super_block *sb)
>  {
> diff --git a/fs/ocfs2/ocfs2_lockid.h b/fs/ocfs2/ocfs2_lockid.h
> index 82c200f..eb6f50c 100644
> --- a/fs/ocfs2/ocfs2_lockid.h
> +++ b/fs/ocfs2/ocfs2_lockid.h
> @@ -46,6 +46,7 @@ enum ocfs2_lock_type {
>  	OCFS2_LOCK_TYPE_DENTRY,
>  	OCFS2_LOCK_TYPE_OPEN,
>  	OCFS2_LOCK_TYPE_FLOCK,
> +	OCFS2_LOCK_TYPE_QINFO,
>  	OCFS2_NUM_LOCK_TYPES
>  };
>  
> @@ -77,6 +78,9 @@ static inline char ocfs2_lock_type_char(enum ocfs2_lock_type type)
>  		case OCFS2_LOCK_TYPE_FLOCK:
>  			c = 'F';
>  			break;
> +		case OCFS2_LOCK_TYPE_QINFO:
> +			c = 'Q';
> +			break;
>  		default:
>  			c = '\0';
>  	}
> @@ -95,6 +99,7 @@ static char *ocfs2_lock_type_strings[] = {
>  	[OCFS2_LOCK_TYPE_DENTRY] = "Dentry",
>  	[OCFS2_LOCK_TYPE_OPEN] = "Open",
>  	[OCFS2_LOCK_TYPE_FLOCK] = "Flock",
> +	[OCFS2_LOCK_TYPE_QINFO] = "Quota",
>  };
>  
>  static inline const char *ocfs2_lock_type_string(enum ocfs2_lock_type type)
> diff --git a/fs/ocfs2/quota.h b/fs/ocfs2/quota.h
> new file mode 100644
> index 0000000..87545ca
> --- /dev/null
> +++ b/fs/ocfs2/quota.h
> @@ -0,0 +1,97 @@
> +/*
> + * quota.h for OCFS2
> + *
> + * On disk quota structures for local and global quota file, in-memory
> + * structures.
> + *
> + */
> +
> +#ifndef _OCFS2_QUOTA_H
> +#define _OCFS2_QUOTA_H
> +
> +#include <linux/types.h>
> +#include <linux/slab.h>
> +#include <linux/quota.h>
> +#include <linux/list.h>
> +#include <linux/dqblk_qtree.h>
> +
> +#include "ocfs2.h"
> +
> +/* Common stuff */
> +/* id number of quota format */
> +#define QFMT_OCFS2 3
> +
> +/* How many bytes to we reserve in each quota file block for our internal
> + * purposes? E.g. checksums... */
> +#define OCFS2_QBLK_RESERVED_SPACE 8
> +
> +/*
> + * In-memory structures
> + */
> +struct ocfs2_dquot {
> +	struct dquot dq_dquot;	/* Generic VFS dquot */
> +	loff_t dq_local_off;	/* Offset in the local quota file */
> +	struct ocfs2_quota_chunk *dq_chunk;	/* Chunk dquot is in */
> +	unsigned int dq_use_count;	/* Number of nodes having reference to this entry in global quota file */
> +	s64 dq_origspace;	/* Last globally synced space usage */
> +	s64 dq_originodes;	/* Last globally synced inode usage */
> +};
> +
> +/* In-memory structure with quota header information */
> +struct ocfs2_mem_dqinfo {
> +	unsigned int dqi_type;		/* Quota type this structure describes */
> +	unsigned int dqi_chunks;	/* Number of chunks in local quota file */
> +	unsigned int dqi_blocks;	/* Number of blocks allocated for local quota file */
> +	unsigned int dqi_syncms;	/* How often should we sync with other nodes */
> +	struct list_head dqi_chunk;	/* List of chunks */
> +	struct inode *dqi_gqinode;	/* Global quota file inode */
> +	struct ocfs2_lock_res dqi_gqlock;	/* Lock protecting quota information structure */
> +	struct buffer_head *dqi_gqi_bh;	/* Buffer head with global quota file inode - set only if inode lock is obtained */
> +	int dqi_gqi_count;		/* Number of holders of dqi_gqi_bh */
> +	struct buffer_head *dqi_lqi_bh;	/* Buffer head with local quota file inode */
> +	struct buffer_head *dqi_ibh;	/* Buffer with information header */
> +	struct qtree_mem_dqinfo dqi_gi;	/* Info about global file */
> +};
> +
> +static inline struct ocfs2_dquot *OCFS2_DQUOT(struct dquot *dquot)
> +{
> +	return container_of(dquot, struct ocfs2_dquot, dq_dquot);
> +}
> +
> +struct ocfs2_quota_chunk {
> +	struct list_head qc_chunk;	/* List of quotafile chunks */
> +	int qc_num;			/* Number of quota chunk */
> +	struct buffer_head *qc_headerbh;	/* Buffer head with chunk header */
> +};
> +
> +extern struct kmem_cache *ocfs2_dquot_cachep;
> +extern struct kmem_cache *ocfs2_qf_chunk_cachep;
> +
> +extern struct qtree_fmt_operations ocfs2_global_ops;
> +
> +ssize_t ocfs2_quota_read(struct super_block *sb, int type, char *data,
> +			 size_t len, loff_t off);
> +ssize_t ocfs2_quota_write(struct super_block *sb, int type,
> +			  const char *data, size_t len, loff_t off);
> +int ocfs2_global_read_info(struct super_block *sb, int type);
> +int ocfs2_global_write_info(struct super_block *sb, int type);
> +int ocfs2_global_read_dquot(struct dquot *dquot);
> +int __ocfs2_sync_dquot(struct dquot *dquot, int freeing);
> +static inline int ocfs2_sync_dquot(struct dquot *dquot)
> +{
> +	return __ocfs2_sync_dquot(dquot, 0);
> +}
> +static inline int ocfs2_global_release_dquot(struct dquot *dquot)
> +{
> +	return __ocfs2_sync_dquot(dquot, 1);
> +}
> +
> +int ocfs2_lock_global_qf(struct ocfs2_mem_dqinfo *oinfo, int ex);
> +void ocfs2_unlock_global_qf(struct ocfs2_mem_dqinfo *oinfo, int ex);
> +struct buffer_head *ocfs2_read_quota_block(struct inode *inode,
> +					   int block, int *err);
> +
> +extern struct dquot_operations ocfs2_quota_operations;
> +extern struct quota_format_type ocfs2_quota_format;
> +
> +#endif /* _OCFS2_QUOTA_H */
> diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
> new file mode 100644
> index 0000000..b937f07
> --- /dev/null
> +++ b/fs/ocfs2/quota_global.c
> @@ -0,0 +1,863 @@
> +/*
> + *  Implementation of operations over global quota file
> + */
> +#include <linux/fs.h>
> +#include <linux/quota.h>
> +#include <linux/quotaops.h>
> +#include <linux/dqblk_qtree.h>
> +
> +#define MLOG_MASK_PREFIX ML_QUOTA
> +#include <cluster/masklog.h>
> +
> +#include "ocfs2_fs.h"
> +#include "ocfs2.h"
> +#include "alloc.h"
> +#include "inode.h"
> +#include "journal.h"
> +#include "file.h"
> +#include "sysfile.h"
> +#include "dlmglue.h"
> +#include "quota.h"
> +
> +static void ocfs2_global_disk2memdqb(struct dquot *dquot, void *dp)
> +{
> +	struct ocfs2_global_disk_dqblk *d = dp;
> +	struct mem_dqblk *m = &dquot->dq_dqb;
> +
> +	/* Update from disk only entries not set by the admin */
> +	if (!test_bit(DQ_LASTSET_B + QIF_ILIMITS_B, &dquot->dq_flags)) {
> +		m->dqb_ihardlimit = le64_to_cpu(d->dqb_ihardlimit);
> +		m->dqb_isoftlimit = le64_to_cpu(d->dqb_isoftlimit);
> +	}
> +	if (!test_bit(DQ_LASTSET_B + QIF_INODES_B, &dquot->dq_flags))
> +		m->dqb_curinodes = le64_to_cpu(d->dqb_curinodes);
> +	if (!test_bit(DQ_LASTSET_B + QIF_BLIMITS_B, &dquot->dq_flags)) {
> +		m->dqb_bhardlimit = le64_to_cpu(d->dqb_bhardlimit);
> +		m->dqb_bsoftlimit = le64_to_cpu(d->dqb_bsoftlimit);
> +	}
> +	if (!test_bit(DQ_LASTSET_B + QIF_SPACE_B, &dquot->dq_flags))
> +		m->dqb_curspace = le64_to_cpu(d->dqb_curspace);
> +	if (!test_bit(DQ_LASTSET_B + QIF_BTIME_B, &dquot->dq_flags))
> +		m->dqb_btime = le64_to_cpu(d->dqb_btime);
> +	if (!test_bit(DQ_LASTSET_B + QIF_ITIME_B, &dquot->dq_flags))
> +		m->dqb_itime = le64_to_cpu(d->dqb_itime);
> +	OCFS2_DQUOT(dquot)->dq_use_count = le32_to_cpu(d->dqb_use_count);
> +}
> +
> +static void ocfs2_global_mem2diskdqb(void *dp, struct dquot *dquot)
> +{
> +	struct ocfs2_global_disk_dqblk *d = dp;
> +	struct mem_dqblk *m = &dquot->dq_dqb;
> +
> +	d->dqb_id = cpu_to_le32(dquot->dq_id);
> +	d->dqb_use_count = cpu_to_le32(OCFS2_DQUOT(dquot)->dq_use_count);
> +	d->dqb_ihardlimit = cpu_to_le64(m->dqb_ihardlimit);
> +	d->dqb_isoftlimit = cpu_to_le64(m->dqb_isoftlimit);
> +	d->dqb_curinodes = cpu_to_le64(m->dqb_curinodes);
> +	d->dqb_bhardlimit = cpu_to_le64(m->dqb_bhardlimit);
> +	d->dqb_bsoftlimit = cpu_to_le64(m->dqb_bsoftlimit);
> +	d->dqb_curspace = cpu_to_le64(m->dqb_curspace);
> +	d->dqb_btime = cpu_to_le64(m->dqb_btime);
> +	d->dqb_itime = cpu_to_le64(m->dqb_itime);
> +	d->dqb_pad1 = d->dqb_pad2 = 0;

Just to be clear - do we definitely want to reset dqb_pad1 and dqb_pad2
every time the header is written? This means that a future version of the
quota code can't put values there without having them overwritten by nodes
which don't understand the new fields...


> +/* Write to quotafile (we know the transaction is already started and has
> + * enough credits) */
> +ssize_t ocfs2_quota_write(struct super_block *sb, int type,
> +			  const char *data, size_t len, loff_t off)
> +{
> +	struct mem_dqinfo *info = sb_dqinfo(sb, type);
> +	struct ocfs2_mem_dqinfo *oinfo = info->dqi_priv;
> +	struct inode *gqinode = oinfo->dqi_gqinode;
> +	int offset = off & (sb->s_blocksize - 1);
> +	sector_t blk = off >> sb->s_blocksize_bits;
> +	int err = 0;
> +	struct buffer_head *bh;
> +	handle_t *handle = journal_current_handle();
> +	size_t tocopy, towrite = len;
> +
> +	if (!handle) {
> +		mlog(ML_ERROR, "Quota write (off=%llu, len=%llu) cancelled "
> +		     "because transaction was not started.\n",
> +		     (unsigned long long)off, (unsigned long long)len);
> +		return -EIO;
> +	}
> +	mutex_lock_nested(&gqinode->i_mutex, I_MUTEX_QUOTA);
> +	if (gqinode->i_size < off + len) {
> +		down_write(&OCFS2_I(gqinode)->ip_alloc_sem);
> +		err = ocfs2_extend_no_holes(gqinode, off + len, off);
> +		up_write(&OCFS2_I(gqinode)->ip_alloc_sem);
> +		if (err < 0)
> +			goto out;
> +		err = ocfs2_simple_size_update(gqinode,
> +					       oinfo->dqi_gqi_bh,
> +					       off + len);
> +		if (err < 0)
> +			goto out;

Is it safe if we crash / error here, after the size has been extended but
before we've written into the newly allocated blocks? In particular, could
we wind up reading those blocks later and wrongly interpreting whatever data
happens to be there? Hmm ok, I guess ocfs2_zero_extend() from
ocfs2_extend_no_holes() fixes that for you, but it's using the page cache.
Does that interact reasonably with what we're doing below?


> +	}
> +	WARN_ON(off >> sb->s_blocksize_bits != \
> +		(off + len) >> sb->s_blocksize_bits);
> +	WARN_ON(((off + len) & ((1 << sb->s_blocksize_bits) - 1)) >
> +		sb->s_blocksize - OCFS2_QBLK_RESERVED_SPACE);
> +	for (towrite = len; towrite > 0; towrite -= tocopy) {
> +		tocopy = min(towrite, (size_t)(sb->s_blocksize - offset));
> +		bh = ocfs2_read_quota_block(gqinode, blk, &err);
> +		if (!bh) {
> +			mlog_errno(err);
> +			return err;
> +		}
> +		err = ocfs2_journal_access(handle, gqinode, bh,
> +						OCFS2_JOURNAL_ACCESS_WRITE);
> +		if (err < 0) {
> +			brelse(bh);
> +			goto out;
> +		}

We can optimize away the disk read if the block is newly allocated. There's
no need to read it off disk, so we can just sb_getblk() it. Likewise, you'd
want to use OCFS2_JOURNAL_ACCESS_CREATE for those. How often does the quota
file get extended though? If it's sufficiently rare, we could save this for
later. Otherwise, it's probably worth the effort imho.
	--Mark

--
Mark Fasheh
