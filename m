Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B285B2571A9
	for <ocfs2-devel@lists.linux.dev>; Tue, 28 Jul 2026 05:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785217839; cv=none; b=Ki1fDrlrsdYQrEYNxyo8TrF3X4uV0ZF97TBRRJcq1oQnwOkItWiZsbUQWa6nApYomQ8Qjr+Mfgv/P2jtUjWHiAJLvx4AFKjJAxNhRk+2ZhgugOk9CPhz4kufydTwUoPks1l6h3Mx934odEsQALuCUnjZhl1EEWIijBUjZ620KVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785217839; c=relaxed/simple;
	bh=YyuLC9Epf6LnHZsZS9Mn+vjmeGM8CP7N7s/AxPOlyq0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M/qEWT/bK102mCIRAr12fIyGm7tUCsSame+uGIbgcWsBSCFSekkVVcj99mBmv6z7UPl87dnwu4Za2EBsC62ZaGjrafQ1MlARSZj5inds7sCo6Bh9dsMCgMfgxOZzij83uZq3w7yGQ3X6YUqmd0yQekBScGanAslC9V6kp3qcPa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=CUGVmf0q; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="CUGVmf0q"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785217825; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=30BeqE8EG8r/laGO92c2Ighh2KNgG6z5NNkSjoVpiio=;
	b=CUGVmf0qoDsEKIMpvJhFCLFP9FsWeRD/W7I2cd5u5CjUba0630tyzfwzbEawtqJ2TmyR6mJsOMkTPYsjvHR0cV2ZHgm0qBzMi0YVx0Ub6p9htz5GIuvIOA1t5z9lGY/9Nwxyt06IqzmUxhCvbMeyHJVB/zXv+oVe+xgZrGZCKmU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R931e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X7zfaiz_1785217824;
Received: from 30.221.129.76(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X7zfaiz_1785217824 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 28 Jul 2026 13:50:25 +0800
Message-ID: <ade2db84-bdaa-4f73-a008-1028b96b4ebd@linux.alibaba.com>
Date: Tue, 28 Jul 2026 13:50:24 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 2/4] ocfs2: switch dio read path from buffer_head
 to iomap
To: Heming Zhao <heming.zhao@suse.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, hch@lst.de,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260727061802.18485-1-heming.zhao@suse.com>
 <20260727061802.18485-3-heming.zhao@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260727061802.18485-3-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/27/26 2:17 PM, Heming Zhao wrote:
> This patch migrates the DIO read path from the legacy buffer_head
> infrastructure to the modern and more efficient iomap framework.
> 
> The rw cluster-lock level is not stashed in iocb->private: iomap DIO owns
> that field (it stores a bio there for polled I/O and unconditionally
> clears it before calling ->end_io), so any side-channel packed into
> iocb->private is corrupted and would trip the end_io lock-state check.
> Instead the unlock level is encoded by which iomap_dio_ops is passed -
> ocfs2_iomap_dio_ops_pr (PRMODE) or ocfs2_iomap_dio_ops_ex (EXMODE) - and
> the *_iter() functions use the split __iomap_dio_rw() + iomap_dio_complete()
> API so they can determine unambiguously, from the return value, whether the
> completion handler already dropped the lock (real I/O, sync or -EIOCBQUEUED)
> or whether the caller must drop it (no I/O issued, or buffered fallback).
> 
> Co-developed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/Kconfig    |   1 +
>  fs/ocfs2/aops.c     | 113 ++++++++++++++++++++++++++++++++++++++++++++
>  fs/ocfs2/file.c     |  57 ++++++++++++++++++----
>  fs/ocfs2/ocfs2.h    |   3 ++
>  fs/ocfs2/ocfs2_fs.h |   3 ++
>  5 files changed, 167 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ocfs2/Kconfig b/fs/ocfs2/Kconfig
> index 2514d36cbe01..bf1678a5eb01 100644
> --- a/fs/ocfs2/Kconfig
> +++ b/fs/ocfs2/Kconfig
> @@ -7,6 +7,7 @@ config OCFS2_FS
>  	select CRC32
>  	select QUOTA
>  	select QUOTA_TREE
> +	select FS_IOMAP
>  	select FS_POSIX_ACL
>  	select LEGACY_DIRECT_IO
>  	help
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 08df5e3b5196..12f5f2e3530a 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -4,6 +4,7 @@
>   */
>  
>  #include <linux/fs.h>
> +#include <linux/iomap.h>
>  #include <linux/slab.h>
>  #include <linux/highmem.h>
>  #include <linux/pagemap.h>
> @@ -2556,6 +2557,118 @@ static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>  				    ocfs2_dio_end_io, 0);
>  }
>  
> +static int ocfs2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
> +		unsigned int flags, struct iomap *iomap, struct iomap *srcmap)
> +{
> +	int ret;
> +	struct ocfs2_map_block map;
> +	struct ocfs2_inode_info *oi = OCFS2_I(inode);
> +	u8 blkbits = inode->i_blkbits;
> +
> +	if ((offset >> blkbits) > OCFS2_MAX_LOGICAL_BLOCK)
> +		return -EINVAL;
> +
> +	/*
> +	 * Calculate the first and last logical blocks respectively.
> +	 */
> +	map.lblk = offset >> blkbits;
> +	map.len = min_t(loff_t, (offset + length - 1) >> blkbits,
> +			OCFS2_MAX_LOGICAL_BLOCK) - map.lblk + 1;
> +	map.flags = 0;
> +
> +	if (flags & IOMAP_WRITE) {
> +		/* todo */

This makes the series non-bisectable since ret is uninitialized.
So return -EOPNOTSUPP instead.

BTW, 'TODO' is preferred.

> +	} else {
> +		down_read(&oi->ip_alloc_sem);
> +		ret = ocfs2_map_blocks(inode, &map, 0);
> +		up_read(&oi->ip_alloc_sem);
> +	}
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	/*
> +	 * Before returning to iomap, let's ensure the allocated mapping
> +	 * covers the entire requested length for atomic writes.
> +	 */
> +	if (flags & IOMAP_ATOMIC) {
> +		if (map.len < (length >> blkbits)) {
> +			WARN_ON_ONCE(1);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	iomap->bdev = inode->i_sb->s_bdev;
> +	iomap->offset = (u64)map.lblk << blkbits;
> +	iomap->length = (u64)map.len << blkbits;
> +
> +	if (map.pblk == 0) {
> +		iomap->type = IOMAP_HOLE;
> +		iomap->addr = IOMAP_NULL_ADDR;
> +	} else {
> +		if (map.flags & OCFS2_MAP_UNWRITTEN) {
> +			iomap->type = IOMAP_UNWRITTEN;
> +		} else if (map.flags & OCFS2_MAP_MAPPED) {
> +			iomap->type = IOMAP_MAPPED;
> +		} else {
> +			WARN_ON_ONCE(1);
> +			return -EIO;
> +		}
> +		iomap->addr = (sector_t)map.pblk << blkbits;
> +	}
> +
> +	if (map.flags & OCFS2_MAP_NEW)
> +		iomap->flags |= IOMAP_F_NEW;
> +
> +	return 0;
> +}
> +
> +const struct iomap_ops ocfs2_iomap_ops = {
> +	.iomap_begin	= ocfs2_iomap_begin,
> +};
> +
> +/*
> + * Direct I/O completion. Like the old ocfs2_dio_end_io(), we use the rw_lock
> + * DLM lock to protect io on one node from truncation on another, and drop it
> + * here once the io has completed. iomap_dio_complete() always calls this,
> + * including on the buffered-fallback (-ENOTBLK) path, so the rw_lock taken in
> + * ocfs2_file_{read,write}_iter() is released exactly once.
> + */
> +static int ocfs2_iomap_dio_end_io(struct kiocb *iocb, ssize_t size, int error,
> +				  int level)
> +{
> +	struct inode *inode = file_inode(iocb->ki_filp);
> +
> +	/*
> +	 * iomap_dio_complete() calls us even when no I/O was issued because the

This looks incorrect.
If __iomap_dio_rw() returns NULL, iomap_dio_complete() is never called.

> +	 * mapping bounced us back to buffered I/O (reported as size == 0 and
> +	 * error == 0). In that case leave the rw_lock held so
> +	 * ocfs2_file_{read,write}_iter() keeps it for the buffered retry and
> +	 * releases it in its own cleanup path.
> +	 */
> +	if (size == 0 && error == 0)
> +		return 0;
> +
> +	ocfs2_rw_unlock(inode, level);
> +	return error;
> +}
> +
> +static int ocfs2_dio_end_io_r_pr(struct kiocb *iocb, ssize_t size,
> +				int error, unsigned int flags)
> +{
> +	if (error)
> +		mlog_ratelimited(ML_ERROR, "Direct IO failed, bytes = %lld errno:%d",
> +				 (long long)size, error);
> +
> +	error = ocfs2_iomap_dio_end_io(iocb, size, error, 0);
> +
> +bail:

Seems it is a dead label.

> +	return error;
> +}
> +
> +const struct iomap_dio_ops ocfs2_iomap_dio_ops_r_pr = {
> +	.end_io = ocfs2_dio_end_io_r_pr,
> +};
>  const struct address_space_operations ocfs2_aops = {
>  	.dirty_folio		= block_dirty_folio,
>  	.read_folio		= ocfs2_read_folio,
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index d6e977ba6565..a0b3883216bc 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -9,6 +9,7 @@
>  
>  #include <linux/capability.h>
>  #include <linux/fs.h>
> +#include <linux/iomap.h>
>  #include <linux/types.h>
>  #include <linux/slab.h>
>  #include <linux/highmem.h>
> @@ -2374,6 +2375,19 @@ static int ocfs2_prepare_inode_for_write(struct file *file,
>  	return ret;
>  }
>  
> +static bool ocfs2_should_use_dio(struct kiocb *iocb, struct iov_iter *iter,
> +				struct inode *inode)
> +{
> +	/*
> +	 * Fallback to buffered I/O if we see an inode without
> +	 * extents.
> +	 */
> +	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
> +		return false;
> +
> +	return true;
> +}
> +
>  static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
>  				    struct iov_iter *from)
>  {
> @@ -2548,7 +2562,6 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
>  			filp->f_path.dentry->d_name.name,
>  			to->nr_segs);	/* GRRRRR */
>  
> -
>  	if (!inode) {
>  		ret = -EINVAL;
>  		mlog_errno(ret);
> @@ -2558,7 +2571,8 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
>  	if (!direct_io && nowait)
>  		return -EOPNOTSUPP;
>  
> -	ocfs2_iocb_init_rw_locked(iocb);
> +	if (!iov_iter_count(to))
> +		return 0; /* skip atime */
>  
>  	/*
>  	 * buffered reads protect themselves in ->read_folio().  O_DIRECT reads
> @@ -2576,8 +2590,6 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
>  			goto bail;
>  		}
>  		rw_level = 0;
> -		/* communicate with ocfs2_dio_end_io */
> -		ocfs2_iocb_set_rw_locked(iocb, rw_level);
>  	}
>  
>  	/*
> @@ -2598,17 +2610,42 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
>  	}
>  	ocfs2_inode_unlock(inode, lock_level);
>  
> -	ret = generic_file_read_iter(iocb, to);
> +	if (direct_io && ocfs2_should_use_dio(iocb, to, inode)) {
> +		struct iomap_dio *dio;
> +
> +		dio = __iomap_dio_rw(iocb, to, &ocfs2_iomap_ops,
> +				&ocfs2_iomap_dio_ops_r_pr, 0, NULL, 0);
> +		if (dio == NULL) {
> +			/* No I/O issued; rw_lock still held. */
> +			ret = 0;
> +		} else if (IS_ERR(dio)) {
> +			ret = PTR_ERR(dio);
> +			if (ret == -EIOCBQUEUED)
> +				rw_level = -1;
> +		} else {
> +			ret = iomap_dio_complete(dio);
> +			if (ret != 0)
> +				rw_level = -1;
> +		}
> +		/*
> +		 * A 0 result means the mapping bounced us back to buffered I/O
> +		 * (e.g. inline data); the rw_lock is still held. Clear
> +		 * IOCB_DIRECT so generic_file_read_iter() takes the buffered
> +		 * path rather than re-entering direct I/O.
> +		 */
> +		if (ret == 0) {
> +			iocb->ki_flags &= ~IOCB_DIRECT;
> +			ret = generic_file_read_iter(iocb, to);
> +		}
> +	} else {
> +		iocb->ki_flags &= ~IOCB_DIRECT;
> +		ret = generic_file_read_iter(iocb, to);
> +	}
>  	trace_generic_file_read_iter_ret(ret);
>  
>  	/* buffered aio wouldn't have proper lock coverage today */
>  	BUG_ON(ret == -EIOCBQUEUED && !direct_io);
>  
> -	/* see ocfs2_file_write_iter */
> -	if (ret == -EIOCBQUEUED || !ocfs2_iocb_is_rw_locked(iocb)) {
> -		rw_level = -1;
> -	}
> -
>  bail:
>  	if (rw_level != -1)
>  		ocfs2_rw_unlock(inode, rw_level);
> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index 095f7ae5dded..a775c1869293 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -549,6 +549,9 @@ struct ocfs2_map_block {
>  	unsigned int flags;
>  };
>  
> +extern const struct iomap_ops ocfs2_iomap_ops;
> +extern const struct iomap_dio_ops ocfs2_iomap_dio_ops_r_pr;
> +
>  /* Flags used by ocfs2_map_blocks() */
>  #define OCFS2_GET_BLOCKS_CREATE	(0x0001)
>  
> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
> index c501eb3cdcda..000bd014acbd 100644
> --- a/fs/ocfs2/ocfs2_fs.h
> +++ b/fs/ocfs2/ocfs2_fs.h
> @@ -314,6 +314,9 @@
>   */
>  #define OCFS2_CLUSTER_O2CB_GLOBAL_HEARTBEAT	(0x01)
>  
> +/* Max logical block we can support */
> +#define OCFS2_MAX_LOGICAL_BLOCK	(0xFFFFFFFE)
> +
>  struct ocfs2_system_inode_info {
>  	char	*si_name;
>  	int	si_iflags;

