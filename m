Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0DC3A7D63
	for <ocfs2-devel@lists.linux.dev>; Tue, 28 Jul 2026 05:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785217304; cv=none; b=RP1hrjsTW5n6IT7lVIeNK8+V7ZCcGUhcDCuCTyzTeBQVBgkeigqFsvQkvDlVjAqodta84A/f5yMK/Zk05O+JXtXUYmdVnBnctcCCa8vBxoV2JBccF37w8LsEoQV2xS5f0tRVAwbCEzDo9EToSntG3Uu+U+6qOx75vXAl9EjhZLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785217304; c=relaxed/simple;
	bh=CcSJ4qF3cCw5hHh5gszBXcOFV9+16BIClmPZpsW+4p4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nNF/iuHZ6HzCiuJ4l21d4xrs7UItXExk3Oi6YFVk5gvzSG1utJiRIX5iEXdhowANbJmKCycvLgS/B1esC013zwpE8TpgKrICA7PHbtyk3ITyNoV88zOZXI0y0ljwuH5clhfMC78DB7CRvj8LUzZ61LpgE/PmJh2U8q+vNotq4EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=PrUchd8l; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="PrUchd8l"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785217294; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=iJT78plklOTfDEJCVMWut+mWdQz71V+7EqTjKqPRfLE=;
	b=PrUchd8lEJApnF0Jju3x12jCYdJXGKR7nXzoV2CtmyYsXrCm5RP0DfGodaLVtmgyuLtpKqXl9pZPVz7n3gVMfvkzZOlbwPM0uGvPX+VKR7FwgJ7KgQGU9Sa9Dqed4WSQl+S5Ce53ZCWf0PLtkA7TJxBnBscHNGRvgjN4ULdeOtk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X7zeofs_1785217292;
Received: from 30.221.129.76(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X7zeofs_1785217292 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 28 Jul 2026 13:41:33 +0800
Message-ID: <7624c381-8c33-4961-bb63-89e21dfcc352@linux.alibaba.com>
Date: Tue, 28 Jul 2026 13:41:31 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 1/4] ocfs2: Add new ocfs2_map_blocks() to introduce
 iomap feature
To: Heming Zhao <heming.zhao@suse.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, hch@lst.de,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260727061802.18485-1-heming.zhao@suse.com>
 <20260727061802.18485-2-heming.zhao@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260727061802.18485-2-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/27/26 2:17 PM, Heming Zhao wrote:
> As part of migrating OCFS2 DIO read/write code paths towards the modern
> and high-performant iomap framework, this patch introduces an iomap API
> to replace old high-overhead VFS buffer_head structure paths.
> 
> This patch establishes the foundational block mapping routines required by
> subsequent iomap integration patches. The implementation draws
> inspiration from ext4_map_blocks().
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/aops.c           | 94 +++++++++++++++++++++++++++++++++++++++
>  fs/ocfs2/aops.h           |  2 +
>  fs/ocfs2/buffer_head_io.c | 12 -----
>  fs/ocfs2/ocfs2.h          | 45 ++++++++++++++++++-
>  4 files changed, 140 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 4acdbb70882c..08df5e3b5196 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -126,6 +126,100 @@ static int ocfs2_lock_get_block(struct inode *inode, sector_t iblock,
>  	return ret;
>  }
>  
> +int ocfs2_map_blocks(struct inode *inode, struct ocfs2_map_block *map,
> +		    int flags)
> +{
> +	int err = 0;
> +	unsigned int ext_flags;
> +	u64 max_blocks = map->len;
> +	u64 p_blkno, count, past_eof;
> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +	int create = flags & OCFS2_GET_BLOCKS_CREATE;
> +
> +	if (OCFS2_I(inode)->ip_flags & OCFS2_INODE_SYSTEM_FILE)
> +		mlog(ML_NOTICE, "map_block on system inode 0x%p (%llu)\n",
> +		     inode, inode->i_ino);
> +
> +	if (S_ISLNK(inode->i_mode)) {
> +		/*
> +		 * TODO: refer ocfs2_get_block() to handle
> +		 * ocfs2_read_folio in the future
> +		 */
> +		mlog(ML_NOTICE, "map_block on S_ISLNK file, node 0x%p (%llu)\n",
> +		     inode, inode->i_ino);
> +		dump_stack();

Here mlog and dump_stack() for debug?
Why not gate behind ML_DEBUG and WARN_ON_ONCE()?

> +		goto bail;
> +	}
> +
> +	err = ocfs2_extent_map_get_blocks(inode, map->lblk, &p_blkno, &count,
> +					  &ext_flags);
> +	if (err) {
> +		mlog(ML_ERROR, "get_blocks() failed, inode: 0x%p, "
> +		     "block: %llu\n", inode, map->lblk);
> +		goto bail;
> +	}
> +
> +	if (max_blocks < count)
> +		count = max_blocks;
> +
> +	map->pblk = p_blkno;
> +	map->len = count;
> +
> +	/*
> +	 * ocfs2 never allocates in this function - the only time we
> +	 * need to use MAP_NEW is when we're extending i_size on a file
> +	 * system which doesn't support holes, in which case MAP_NEW
> +	 * allows __block_write_begin() to zero.
> +	 *
> +	 * If we see this on a sparse file system, then a truncate has
> +	 * raced us and removed the cluster. In this case, we clear
> +	 * the buffers dirty and uptodate bits and let the buffer code
> +	 * ignore it as a hole.
> +	 */
> +	if (create && map->pblk == 0 && ocfs2_sparse_alloc(osb)) {
> +		map->flags &= ~(OCFS2_MAP_DIRTY | OCFS2_MAP_UPTODATE);
> +		goto bail;
> +	}
> +
> +	if (p_blkno) {
> +		if (ext_flags & OCFS2_EXT_UNWRITTEN) {
> +			map->flags |= OCFS2_MAP_UNWRITTEN;
> +		} else if (!(ext_flags & OCFS2_EXT_UNWRITTEN)) {
> +			/* Treat the unwritten extent as a hole for zeroing purposes. */
> +			map->flags |= OCFS2_MAP_MAPPED;
> +		} else {
> +			/* nothing to do */
> +		}
> +	}

It looks odd here. Can simplify to:

if (ext_flags & OCFS2_EXT_UNWRITTEN)
	map->flags |= OCFS2_MAP_UNWRITTEN;
else
	map->flags |= OCFS2_MAP_MAPPED;

> +
> +	if (!ocfs2_sparse_alloc(osb)) {
> +		if (map->pblk == 0) {
> +			err = -EIO;
> +			mlog(ML_ERROR,
> +			     "iblock = %llu p_blkno = %llu blkno=(%llu)\n",
> +			     (unsigned long long)map->lblk,
> +			     (unsigned long long)map->pblk,
> +			     (unsigned long long)OCFS2_I(inode)->ip_blkno);
> +			mlog(ML_ERROR, "Size %llu, clusters %u\n",
> +			     (unsigned long long)i_size_read(inode),
> +			     OCFS2_I(inode)->ip_clusters);
> +			dump_stack();
> +			goto bail;
> +		}
> +	}
> +
> +	past_eof = ocfs2_blocks_for_bytes(inode->i_sb, i_size_read(inode));
> +
> +	if (create && (map->lblk >= past_eof))
> +		map->flags |= OCFS2_MAP_NEW;
> +
> +bail:
> +	if (err < 0)
> +		return -EIO;

Why swallow the error code?
I'd rather propagate the actual error.

> +	else
> +		return map->len;
> +}
> +
>  int ocfs2_get_block(struct inode *inode, sector_t iblock,
>  		    struct buffer_head *bh_result, int create)
>  {
> diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
> index 114efc9111e4..8dd6edd7c1a1 100644
> --- a/fs/ocfs2/aops.h
> +++ b/fs/ocfs2/aops.h
> @@ -42,6 +42,8 @@ int ocfs2_size_fits_inline_data(struct buffer_head *di_bh, u64 new_size);
>  
>  int ocfs2_get_block(struct inode *inode, sector_t iblock,
>  		    struct buffer_head *bh_result, int create);
> +int ocfs2_map_blocks(struct inode *inode, struct ocfs2_map_block *map,
> +		    int flags);
>  /* all ocfs2_dio_end_io()'s fault */
>  #define ocfs2_iocb_is_rw_locked(iocb) \
>  	test_bit(0, (unsigned long *)&iocb->private)
> diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
> index 7bfe377af2df..493f2209cca5 100644
> --- a/fs/ocfs2/buffer_head_io.c
> +++ b/fs/ocfs2/buffer_head_io.c
> @@ -23,18 +23,6 @@
>  #include "buffer_head_io.h"
>  #include "ocfs2_trace.h"
>  
> -/*
> - * Bits on bh->b_state used by ocfs2.
> - *
> - * These MUST be after the JBD2 bits.  Hence, we use BH_JBDPrivateStart.
> - */
> -enum ocfs2_state_bits {
> -	BH_NeedsValidate = BH_JBDPrivateStart,
> -};
> -
> -/* Expand the magic b_state functions */
> -BUFFER_FNS(NeedsValidate, needs_validate);
> -
>  int ocfs2_write_block(struct ocfs2_super *osb, struct buffer_head *bh,
>  		      struct ocfs2_caching_info *ci)
>  {
> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index 62cad6522c7a..095f7ae5dded 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -509,7 +509,50 @@ struct ocfs2_super
>  	struct ocfs2_filecheck_sysfs_entry osb_fc_ent;
>  };
>  
> -#define OCFS2_SB(sb)	    ((struct ocfs2_super *)(sb)->s_fs_info)
> +/*
> + * Bits on bh->b_state used by ocfs2.
> + *
> + * These MUST be after the JBD2 bits.  Hence, we use BH_JBDPrivateStart.
> + */
> +enum ocfs2_state_bits {
> +	BH_NeedsValidate = BH_JBDPrivateStart,
> +};
> +
> +/* Expand the magic b_state functions */
> +BUFFER_FNS(NeedsValidate, needs_validate);
> +
> +/*
> + * Logical to physical block mapping, used by ocfs2_map_blocks()
> + *
> + * This structure is used to pass requests into ocfs2_map_blocks() as
> + * well as to store the information returned by ocfs2_map_blocks().  It
> + * takes less room on the stack than a struct buffer_head.
> + */
> +#define OCFS2_MAP_NEW			BIT(BH_New)
> +#define OCFS2_MAP_MAPPED		BIT(BH_Mapped)
> +#define OCFS2_MAP_UNWRITTEN		BIT(BH_Unwritten)
> +/* useless? #define OCFS2_MAP_BOUNDARY		BIT(BH_Boundary) */
> +/* useless? #define OCFS2_MAP_DELAYED		BIT(BH_Delay) */
> +#define OCFS2_MAP_DIRTY			BIT(BH_Dirty)
> +#define OCFS2_MAP_UPTODATE		BIT(BH_Uptodate)
> +#define OCFS2_MAP_NEEDS_VALIDATE	BIT(BH_NeedsValidate)
> +#define OCFS2_MAP_DEFER_COMPLETION	BIT(BH_Defer_Completion)
> +#define OCFS2_MAP_FLAGS		(OCFS2_MAP_NEW | OCFS2_MAP_MAPPED |\
> +				 OCFS2_MAP_DIRTY | OCFS2_MAP_UPTODATE |\
> +				 OCFS2_MAP_NEEDS_VALIDATE |\
> +				 OCFS2_MAP_DEFER_COMPLETION)
> +
> +struct ocfs2_map_block {
> +	u64 pblk; /* physical block# */
> +	u64 lblk; /* logical block# */
> +	u64 len;  /* number of block */
> +	unsigned int flags;
> +};
> +
> +/* Flags used by ocfs2_map_blocks() */
> +#define OCFS2_GET_BLOCKS_CREATE	(0x0001)
> +
> +#define OCFS2_SB(sb)	((struct ocfs2_super *)(sb)->s_fs_info)
>  
>  /* Useful typedef for passing around journal access functions */
>  typedef int (*ocfs2_journal_access_func)(handle_t *handle,

