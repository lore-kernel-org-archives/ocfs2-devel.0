Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579D838AC64
	for <ocfs2-devel@lists.linux.dev>; Sun,  2 Aug 2026 11:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785670122; cv=none; b=Q4gZ+nFN/TRTzhCutwplWny4wvmO+WIRTr+nJKXO8ynEbvvImK+1tt2D1EATxt90GYCR3p02SdYf221Yn1SPm8TFB3m/ORdygdFfY6UW0HhaMsdGy/PsHiZ5l3lrRrwftwto3dXBjdX+tfcCgRU7DBDxdWkUQDAvST2wexGBhRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785670122; c=relaxed/simple;
	bh=1x6qVo872qGUdG3tEvCS1xiZUTuu54AOx7BHl6JORtw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M86Kbi/wSW33+tcJSrfOu4Rk5y5uclAMsg4Vv6QsLevA7iOQifuL0Ec+c0ZZitlugiQkP5ZUl9EvifM0IfT4TdtMgFE/+Nw8lR4fZa97oE68uGExdu/eTQwffX+kybfxAMSOEUjqTPcCPB/4kW8+eB6bpw5rponE25CQRdUfgZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=S43D1xHd; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="S43D1xHd"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c16111a9b8dso22160166b.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 02 Aug 2026 04:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785670117; x=1786274917; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=M0kkCYm0sN0i4Rj4mTmbr110erA5ZAzDrWmc0gKFkiA=;
        b=S43D1xHd0k7zUr2BHfrfcrtv4li7HCdiswT31KKEgkhNH5gvx7kVJizAOyjHU2CxZE
         JGT6HsPxdjan3+b+tLkA8CI5Qu9GY1rNvpa32wiSNJeEeE0iNHwjFudBfNc9en+Vapjk
         4GCY5+atQMU6DCQRKd2oJRT133I1C7WlBH3dVBMeEyA6so4meZQVJsTXP8I/GtGnelqw
         TF+xCoN3GsEfN+xdIkU1jGrry4Pn0tYBIlIjF5/Z5x1DmSQgF+f9quL8j6ILstBbb3jy
         ourGMU+QmHzW4bbrxfN81v1rZMkTyCkKhLXp2Ajw3x6YHl1IiVFbyYPw8dLwo5Kk/YaT
         ui+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785670117; x=1786274917;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M0kkCYm0sN0i4Rj4mTmbr110erA5ZAzDrWmc0gKFkiA=;
        b=obxxX+x1P3HXO8eTuZZBIXefgDvJ+qaZOBap/pjKxCW9jZbJvoOHgU9TLNBjTUiiw+
         2hCMFK5izJjPxN2tEenuHUl78KHIphxCvdxMFMbTTcV1FWnaYDUxKLMmThwI0MLI1u33
         3uT0OjWQrnyLTmNAyMRq8U7t494MIsMBKI58gGbPv8QtYfZRUwduWC1TtV4GTiYHrGaS
         +dShP1eQfog1uC5V0BUuu8bam1ZG+4L7aIzpjmxfcBZZubLsjkAbCqn83Rx2e08aH2qj
         iZW/sBdQLmNyoz7JSNEOE2EIpej0ig+ubiqHpGFx5+0ZNXomAuca/gJQIgiDiFb/e6vB
         GLmw==
X-Forwarded-Encrypted: i=1; AHgh+Rq5hDFW8vgLnY0K7loS34/OnUT6Dh7bKe6w5O38By5LuBG0VWn/DkYNXWkeKB3D7980kHd1LBske0yQHQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyOXJiSnBx65hpIKa/Z7fZVvqYLamsd1syrPoF/KaXbyfRKVgU4
	viAIZID7fftwEPegoYLNIjJmeR2lYzTgfPrjFb/j6D9H2HjUm4yBT1zp1j5FANrCFkI=
X-Gm-Gg: AR+sD12GhgTd21zxD+SdHa+RLX3DhGpsig4VvV4G6Sd2vFziSyNhUzI7ABh+zxCZSQU
	RHqVxpJx6JNX/89J9AupDofdVkE79ocN0Abpj9cORBXeUWAwBtoEqmamF+ofjXKfKIb69GTpb1y
	mddfdM0GTiPHmq5WOwYrK1G5t+jA3EMyhZW6ng5WTcyGQHUe8PFwxufoXdsWOu5ODN0Wq/PW/gF
	vBKUSe5pE5N0qHATRczk/ESav8oSuzHlYrFeer7+BE+C9J01RJkoeOnAlJLAiF10wlsymqB6gLQ
	SxC/+K9mZ5qU8B5NHcj/16HElinhictpHGY6Y/A7mjy+8mOflFbPW+RT1trxuYwk1DkSoulDrZ7
	P1LnapGo36L9G0fyL77OkZg+gv8wh+V8LRJBdzEp1fKyaqBSNYDyRlAZA9BtLVDwaN2Dh/axhTn
	48D7SEdZg6VYxuJEXYQPdbw3bnTNEHjYnFRRS77s+Qc18Z0qorNfl4jWHuBrM=
X-Received: by 2002:a05:6402:50cf:b0:69e:1246:a86a with SMTP id 4fb4d7f45d1cf-6a0a7bc92d0mr2610884a12.0.1785670117419;
        Sun, 02 Aug 2026 04:28:37 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84edbe869c7sm2449801b3a.26.2026.08.02.04.28.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 04:28:35 -0700 (PDT)
Date: Sun, 2 Aug 2026 19:28:30 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, hch@lst.de, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/4] ocfs2: Add new ocfs2_map_blocks() to
 introduce iomap feature
Message-ID: <am8oSsQDQrynSXBf@p15>
References: <20260727061802.18485-1-heming.zhao@suse.com>
 <20260727061802.18485-2-heming.zhao@suse.com>
 <7624c381-8c33-4961-bb63-89e21dfcc352@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7624c381-8c33-4961-bb63-89e21dfcc352@linux.alibaba.com>

Looking at my thunderbird inbox, I noticed the previous mail was formatted
incorrectly. I must have hit the wrong shortcut in neomutt before sending it.
Resending again.

On Tue, Jul 28, 2026 at 01:41:31PM +0800, Joseph Qi wrote:
> 
> 
> On 7/27/26 2:17 PM, Heming Zhao wrote:
> > As part of migrating OCFS2 DIO read/write code paths towards the modern
> > and high-performant iomap framework, this patch introduces an iomap API
> > to replace old high-overhead VFS buffer_head structure paths.
> > 
> > This patch establishes the foundational block mapping routines required by
> > subsequent iomap integration patches. The implementation draws
> > inspiration from ext4_map_blocks().
> > 
> > Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> > ---
> >  fs/ocfs2/aops.c           | 94 +++++++++++++++++++++++++++++++++++++++
> >  fs/ocfs2/aops.h           |  2 +
> >  fs/ocfs2/buffer_head_io.c | 12 -----
> >  fs/ocfs2/ocfs2.h          | 45 ++++++++++++++++++-
> >  4 files changed, 140 insertions(+), 13 deletions(-)
> > 
> > diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> > index 4acdbb70882c..08df5e3b5196 100644
> > --- a/fs/ocfs2/aops.c
> > +++ b/fs/ocfs2/aops.c
> > @@ -126,6 +126,100 @@ static int ocfs2_lock_get_block(struct inode *inode, sector_t iblock,
> >  	return ret;
> >  }
> >  
> > +int ocfs2_map_blocks(struct inode *inode, struct ocfs2_map_block *map,
> > +		    int flags)
> > +{
> > +	int err = 0;
> > +	unsigned int ext_flags;
> > +	u64 max_blocks = map->len;
> > +	u64 p_blkno, count, past_eof;
> > +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> > +	int create = flags & OCFS2_GET_BLOCKS_CREATE;
> > +
> > +	if (OCFS2_I(inode)->ip_flags & OCFS2_INODE_SYSTEM_FILE)
> > +		mlog(ML_NOTICE, "map_block on system inode 0x%p (%llu)\n",
> > +		     inode, inode->i_ino);
> > +
> > +	if (S_ISLNK(inode->i_mode)) {
> > +		/*
> > +		 * TODO: refer ocfs2_get_block() to handle
> > +		 * ocfs2_read_folio in the future
> > +		 */
> > +		mlog(ML_NOTICE, "map_block on S_ISLNK file, node 0x%p (%llu)\n",
> > +		     inode, inode->i_ino);
> > +		dump_stack();
> 
> Here mlog and dump_stack() for debug?
> Why not gate behind ML_DEBUG and WARN_ON_ONCE()?
> 

I will follow this suggestion in the next version.

This function shouldn't handle symlink files in the current version.
However, since it derives from ocfs2_get_block() (which handles the S_ISLNK case)
and I eventually plan to replace ocfs2_get_block() with ocfs2_map_blocks(), I
left the WARN here to alert us during the migration. And also notify us when
we call this function on a symlink file.

> > +		goto bail;
> > +	}
> > +
> > +	err = ocfs2_extent_map_get_blocks(inode, map->lblk, &p_blkno, &count,
> > +					  &ext_flags);
> > +	if (err) {
> > +		mlog(ML_ERROR, "get_blocks() failed, inode: 0x%p, "
> > +		     "block: %llu\n", inode, map->lblk);
> > +		goto bail;
> > +	}
> > +
> > +	if (max_blocks < count)
> > +		count = max_blocks;
> > +
> > +	map->pblk = p_blkno;
> > +	map->len = count;
> > +
> > +	/*
> > +	 * ocfs2 never allocates in this function - the only time we
> > +	 * need to use MAP_NEW is when we're extending i_size on a file
> > +	 * system which doesn't support holes, in which case MAP_NEW
> > +	 * allows __block_write_begin() to zero.
> > +	 *
> > +	 * If we see this on a sparse file system, then a truncate has
> > +	 * raced us and removed the cluster. In this case, we clear
> > +	 * the buffers dirty and uptodate bits and let the buffer code
> > +	 * ignore it as a hole.
> > +	 */
> > +	if (create && map->pblk == 0 && ocfs2_sparse_alloc(osb)) {
> > +		map->flags &= ~(OCFS2_MAP_DIRTY | OCFS2_MAP_UPTODATE);
> > +		goto bail;
> > +	}
> > +
> > +	if (p_blkno) {
> > +		if (ext_flags & OCFS2_EXT_UNWRITTEN) {
> > +			map->flags |= OCFS2_MAP_UNWRITTEN;
> > +		} else if (!(ext_flags & OCFS2_EXT_UNWRITTEN)) {
> > +			/* Treat the unwritten extent as a hole for zeroing purposes. */
> > +			map->flags |= OCFS2_MAP_MAPPED;
> > +		} else {
> > +			/* nothing to do */
> > +		}
> > +	}
> 
> It looks odd here. Can simplify to:
> 
> if (ext_flags & OCFS2_EXT_UNWRITTEN)
> 	map->flags |= OCFS2_MAP_UNWRITTEN;
> else
> 	map->flags |= OCFS2_MAP_MAPPED;
> 

I wrote this logic to set up a framework for future code. I added some macro
definitions in ocfs2.h (e.g., OCFS2_MAP_NEW, OCFS2_MAP_NEEDS_VALIDATE, etc.).

I would like to keep the current logic and add a comment like:

   /* TODO: handling other OCFS2_MAP_XX in the future */

Do you agree?

> > +
> > +	if (!ocfs2_sparse_alloc(osb)) {
> > +		if (map->pblk == 0) {
> > +			err = -EIO;
> > +			mlog(ML_ERROR,
> > +			     "iblock = %llu p_blkno = %llu blkno=(%llu)\n",
> > +			     (unsigned long long)map->lblk,
> > +			     (unsigned long long)map->pblk,
> > +			     (unsigned long long)OCFS2_I(inode)->ip_blkno);
> > +			mlog(ML_ERROR, "Size %llu, clusters %u\n",
> > +			     (unsigned long long)i_size_read(inode),
> > +			     OCFS2_I(inode)->ip_clusters);
> > +			dump_stack();
> > +			goto bail;
> > +		}
> > +	}
> > +
> > +	past_eof = ocfs2_blocks_for_bytes(inode->i_sb, i_size_read(inode));
> > +
> > +	if (create && (map->lblk >= past_eof))
> > +		map->flags |= OCFS2_MAP_NEW;
> > +
> > +bail:
> > +	if (err < 0)
> > +		return -EIO;
> 
> Why swallow the error code?
> I'd rather propagate the actual error.
> 

I keep the legacy ocfs2_get_block() logic here.
I have tested the logic where it returns 'err' by xfstests, and the results look
fine.
Will update the return logic in the next version.

Thanks,
Heming

> > +	else
> > +		return map->len;
> > +}
> > +
> >  int ocfs2_get_block(struct inode *inode, sector_t iblock,
> >  		    struct buffer_head *bh_result, int create)
> >  {
> > diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
> > index 114efc9111e4..8dd6edd7c1a1 100644
> > --- a/fs/ocfs2/aops.h
> > +++ b/fs/ocfs2/aops.h
> > @@ -42,6 +42,8 @@ int ocfs2_size_fits_inline_data(struct buffer_head *di_bh, u64 new_size);
> >  
> >  int ocfs2_get_block(struct inode *inode, sector_t iblock,
> >  		    struct buffer_head *bh_result, int create);
> > +int ocfs2_map_blocks(struct inode *inode, struct ocfs2_map_block *map,
> > +		    int flags);
> >  /* all ocfs2_dio_end_io()'s fault */
> >  #define ocfs2_iocb_is_rw_locked(iocb) \
> >  	test_bit(0, (unsigned long *)&iocb->private)
> > diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
> > index 7bfe377af2df..493f2209cca5 100644
> > --- a/fs/ocfs2/buffer_head_io.c
> > +++ b/fs/ocfs2/buffer_head_io.c
> > @@ -23,18 +23,6 @@
> >  #include "buffer_head_io.h"
> >  #include "ocfs2_trace.h"
> >  
> > -/*
> > - * Bits on bh->b_state used by ocfs2.
> > - *
> > - * These MUST be after the JBD2 bits.  Hence, we use BH_JBDPrivateStart.
> > - */
> > -enum ocfs2_state_bits {
> > -	BH_NeedsValidate = BH_JBDPrivateStart,
> > -};
> > -
> > -/* Expand the magic b_state functions */
> > -BUFFER_FNS(NeedsValidate, needs_validate);
> > -
> >  int ocfs2_write_block(struct ocfs2_super *osb, struct buffer_head *bh,
> >  		      struct ocfs2_caching_info *ci)
> >  {
> > diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> > index 62cad6522c7a..095f7ae5dded 100644
> > --- a/fs/ocfs2/ocfs2.h
> > +++ b/fs/ocfs2/ocfs2.h
> > @@ -509,7 +509,50 @@ struct ocfs2_super
> >  	struct ocfs2_filecheck_sysfs_entry osb_fc_ent;
> >  };
> >  
> > -#define OCFS2_SB(sb)	    ((struct ocfs2_super *)(sb)->s_fs_info)
> > +/*
> > + * Bits on bh->b_state used by ocfs2.
> > + *
> > + * These MUST be after the JBD2 bits.  Hence, we use BH_JBDPrivateStart.
> > + */
> > +enum ocfs2_state_bits {
> > +	BH_NeedsValidate = BH_JBDPrivateStart,
> > +};
> > +
> > +/* Expand the magic b_state functions */
> > +BUFFER_FNS(NeedsValidate, needs_validate);
> > +
> > +/*
> > + * Logical to physical block mapping, used by ocfs2_map_blocks()
> > + *
> > + * This structure is used to pass requests into ocfs2_map_blocks() as
> > + * well as to store the information returned by ocfs2_map_blocks().  It
> > + * takes less room on the stack than a struct buffer_head.
> > + */
> > +#define OCFS2_MAP_NEW			BIT(BH_New)
> > +#define OCFS2_MAP_MAPPED		BIT(BH_Mapped)
> > +#define OCFS2_MAP_UNWRITTEN		BIT(BH_Unwritten)
> > +/* useless? #define OCFS2_MAP_BOUNDARY		BIT(BH_Boundary) */
> > +/* useless? #define OCFS2_MAP_DELAYED		BIT(BH_Delay) */
> > +#define OCFS2_MAP_DIRTY			BIT(BH_Dirty)
> > +#define OCFS2_MAP_UPTODATE		BIT(BH_Uptodate)
> > +#define OCFS2_MAP_NEEDS_VALIDATE	BIT(BH_NeedsValidate)
> > +#define OCFS2_MAP_DEFER_COMPLETION	BIT(BH_Defer_Completion)
> > +#define OCFS2_MAP_FLAGS		(OCFS2_MAP_NEW | OCFS2_MAP_MAPPED |\
> > +				 OCFS2_MAP_DIRTY | OCFS2_MAP_UPTODATE |\
> > +				 OCFS2_MAP_NEEDS_VALIDATE |\
> > +				 OCFS2_MAP_DEFER_COMPLETION)
> > +
> > +struct ocfs2_map_block {
> > +	u64 pblk; /* physical block# */
> > +	u64 lblk; /* logical block# */
> > +	u64 len;  /* number of block */
> > +	unsigned int flags;
> > +};
> > +
> > +/* Flags used by ocfs2_map_blocks() */
> > +#define OCFS2_GET_BLOCKS_CREATE	(0x0001)
> > +
> > +#define OCFS2_SB(sb)	((struct ocfs2_super *)(sb)->s_fs_info)
> >  
> >  /* Useful typedef for passing around journal access functions */
> >  typedef int (*ocfs2_journal_access_func)(handle_t *handle,
> 
