Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F39436B900
	for <ocfs2-devel@lists.linux.dev>; Sun,  2 Aug 2026 10:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785667002; cv=none; b=uCqV8IMaTaz6vC68hAUS7qsmIK/vOrGtx9Y5Ai978prqCtVdQ4nhE53emILlpFOpiCFV9BCMIpQqDRIIo+BfHrwhq/qI1UaaY4oOKPV+zkWYGwx/ZZeHLSLo4dma70nGW7dCkkMrNe7iklg1Ojnciga766x95OQcri6toIKcTmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785667002; c=relaxed/simple;
	bh=KZXqnowOaSmJPo9uphZAxfHPMgLo0oH9zDt8BIuQZQI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=azhhzM+Mm6FoAD8ffRyu61/5nZlg6kbakerDco3AxYvYlk/1LD1QgoR0CjZ+zFjxJPyU2fic1K2d4yRhC6pExIrd8oiVBDtmxQlv/GzzvCQgU/z8mW2RVuHpsZXY0DKjTGkrWCV303JhnpwOWoosIggZRL2m9tdF/I7yj4QonxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fq5t+/bO; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fq5t+/bO"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-69af1bc780bso432282a12.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 02 Aug 2026 03:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785666999; x=1786271799; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UBdOPMIOP0Zcm7KeXM5AI61Y9yOfoo55E+Ra5GckOXc=;
        b=fq5t+/bOXvVm2Sx4IgmH93SwCqWL1LmzNa4TI/RkkhBtu7cqM9OfLBgcFTcWfrvgIp
         GHLE2aC9DAoAQgS40fx1cmLxSSqmATtGv7rXhSIV+JWqeBhGu62Pw+9K3laI8inioFAd
         v/X434GccG7DMNKoLf7Sv1Srsaj9c39VoZfwWSX9PAjeYbsQeaTTOcRmQK5WTS7DMoQv
         ynEi2W5h09Fn2qK2q1vIOJ5zk+NqjgAih1YtQkrtpTEYuShEBbcGIJV4k0AjN7QZxpRU
         v8OpH4IWxS2OL7Na3K9K6zQ885JFbC+CEJjsBnPiuEb0oTI/l4i61WAU8P5rSPHNCyzP
         QA/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785666999; x=1786271799;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UBdOPMIOP0Zcm7KeXM5AI61Y9yOfoo55E+Ra5GckOXc=;
        b=hFWl2+Ov71yJNtAd0pvQXjaKkWo6yabP/0f8c/gKAqKvmQ5CSQV4gMYM2XgWV65QcL
         wYrQImNkBz5t0lFkVRw+iJUSC8N+nv1bwfhTeIN8LohgFj7ibrxcU5VCc/etVk2lNzx9
         XFQ0N2wMBjxSWsyEmFfFomtg2b4r7LuBBeGRRF15SdeRrj6SkqEMUbU5JjNYYrby8g87
         KbLJRoMBEpKe6dq3GchXHzsTLZ2wnGjiX2r8uZgY+gzN90T2U1nJX9n4vRQ6fIE4zaJH
         E/dZwLB9Eofjz4XtjXXmZwy6SF+kQ5ttGhR73sIiS1x6ZGA+08lOKZyhRw6M4M827tKT
         xlbg==
X-Forwarded-Encrypted: i=1; AHgh+RrMK2AlOC+OBsUgks3dLYg8bxJgny8PhMGrX1GQ+UyVxI+F7GLpxaTFbPIXQ25geAKkDZWBRjd8M7PT2Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YwwsuCsF0vASymCLiA7uEJni2ATl2QF4qD4OmpH0ZFogn64M1zx
	z2nCZiQdGiL+pSLPOS+fwyOH0s/LKi7bhko/3LKJ2L7kffC8KPb3v9EzQF6yzfFd7/s=
X-Gm-Gg: AR+sD11tkqbeAkH+W+YFXemhzEcm5HYYj2PuSePpkLttwXDKuiNbR+mY/6BFgoize8b
	xSLdcsqRC0lHg1MbburqOj577letXhbQlWri6KIEcqecCeMnA9MHzhsvPIqA52U5Mp7v074XuMC
	scS9LTp7+PpsU/rpPaRrkCrJCC+QtuPIngwjj1eq9OXcJlcMcvqY1Na3DO1dXggc/z9V6x+WKvQ
	znMPGoafqlbPEl3bqAsfqMfvKFDAkuIY4uvjKL+hz4jwwva/ym2KODn+b1lPUV+pLdFcqmDustW
	zH4/GN5JburAGcnIp5dvWZ9v+OgoTv1mnbY3iRFMkR9Owfqf1SraBkH5FxWkabvUK+wV3aWm6QD
	E67I3HEN0MZB3DhGWZS53pCNYQcz3GOA0CPku/N6u5Gs+W77wQzfSZn9ZUWY6O+s9LY3IA2vsfV
	TfD4dbgaNsxu3yq8dBOVWBPaQbhBTnAu5k99vOqAvjfoWdH7T+1hlyANnnAw8=
X-Received: by 2002:a17:907:6d26:b0:c1f:a06c:cfde with SMTP id a640c23a62f3a-c1fe82d3415mr288613266b.4.1785666998567;
        Sun, 02 Aug 2026 03:36:38 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04ae5a91asm24965045ad.21.2026.08.02.03.36.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 03:36:37 -0700 (PDT)
Date: Sun, 2 Aug 2026 18:36:32 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, hch@lst.de, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/4] ocfs2: switch dio read path from buffer_head
 to iomap
Message-ID: <am6-LR-78xmgoMAc@p15>
References: <20260727061802.18485-1-heming.zhao@suse.com>
 <20260727061802.18485-3-heming.zhao@suse.com>
 <ade2db84-bdaa-4f73-a008-1028b96b4ebd@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ade2db84-bdaa-4f73-a008-1028b96b4ebd@linux.alibaba.com>

On Tue, Jul 28, 2026 at 01:50:24PM +0800, Joseph Qi wrote:
> 
> 
> On 7/27/26 2:17 PM, Heming Zhao wrote:
> > This patch migrates the DIO read path from the legacy buffer_head
> > infrastructure to the modern and more efficient iomap framework.
> > 
> > The rw cluster-lock level is not stashed in iocb->private: iomap DIO owns
> > that field (it stores a bio there for polled I/O and unconditionally
> > clears it before calling ->end_io), so any side-channel packed into
> > iocb->private is corrupted and would trip the end_io lock-state check.
> > Instead the unlock level is encoded by which iomap_dio_ops is passed -
> > ocfs2_iomap_dio_ops_pr (PRMODE) or ocfs2_iomap_dio_ops_ex (EXMODE) - and
> > the *_iter() functions use the split __iomap_dio_rw() + iomap_dio_complete()
> > API so they can determine unambiguously, from the return value, whether the
> > completion handler already dropped the lock (real I/O, sync or -EIOCBQUEUED)
> > or whether the caller must drop it (no I/O issued, or buffered fallback).
> > 
> > Co-developed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> > Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> > Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> > ---
> >  fs/ocfs2/Kconfig    |   1 +
> >  fs/ocfs2/aops.c     | 113 ++++++++++++++++++++++++++++++++++++++++++++
> >  fs/ocfs2/file.c     |  57 ++++++++++++++++++----
> >  fs/ocfs2/ocfs2.h    |   3 ++
> >  fs/ocfs2/ocfs2_fs.h |   3 ++
> >  5 files changed, 167 insertions(+), 10 deletions(-)
> > 
> > diff --git a/fs/ocfs2/Kconfig b/fs/ocfs2/Kconfig
> > index 2514d36cbe01..bf1678a5eb01 100644
> > --- a/fs/ocfs2/Kconfig
> > +++ b/fs/ocfs2/Kconfig
> > @@ -7,6 +7,7 @@ config OCFS2_FS
> >  	select CRC32
> >  	select QUOTA
> >  	select QUOTA_TREE
> > +	select FS_IOMAP
> >  	select FS_POSIX_ACL
> >  	select LEGACY_DIRECT_IO
> >  	help
> > diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> > index 08df5e3b5196..12f5f2e3530a 100644
> > --- a/fs/ocfs2/aops.c
> > +++ b/fs/ocfs2/aops.c
> > @@ -4,6 +4,7 @@
> >   */
> >  
> >  #include <linux/fs.h>
> > +#include <linux/iomap.h>
> >  #include <linux/slab.h>
> >  #include <linux/highmem.h>
> >  #include <linux/pagemap.h>
> > @@ -2556,6 +2557,118 @@ static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
> >  				    ocfs2_dio_end_io, 0);
> >  }
> >  
> > +static int ocfs2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
> > +		unsigned int flags, struct iomap *iomap, struct iomap *srcmap)
> > +{
> > +	int ret;
> > +	struct ocfs2_map_block map;
> > +	struct ocfs2_inode_info *oi = OCFS2_I(inode);
> > +	u8 blkbits = inode->i_blkbits;
> > +
> > +	if ((offset >> blkbits) > OCFS2_MAX_LOGICAL_BLOCK)
> > +		return -EINVAL;
> > +
> > +	/*
> > +	 * Calculate the first and last logical blocks respectively.
> > +	 */
> > +	map.lblk = offset >> blkbits;
> > +	map.len = min_t(loff_t, (offset + length - 1) >> blkbits,
> > +			OCFS2_MAX_LOGICAL_BLOCK) - map.lblk + 1;
> > +	map.flags = 0;
> > +
> > +	if (flags & IOMAP_WRITE) {
> > +		/* todo */
> 
> This makes the series non-bisectable since ret is uninitialized.
> So return -EOPNOTSUPP instead.
> 
> BTW, 'TODO' is preferred.

Good idea, will change in the next version.
> 
> > +	} else {
> > +		down_read(&oi->ip_alloc_sem);
> > +		ret = ocfs2_map_blocks(inode, &map, 0);
> > +		up_read(&oi->ip_alloc_sem);
> > +	}
> > +
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	/*
> > +	 * Before returning to iomap, let's ensure the allocated mapping
> > +	 * covers the entire requested length for atomic writes.
> > +	 */
> > +	if (flags & IOMAP_ATOMIC) {
> > +		if (map.len < (length >> blkbits)) {
> > +			WARN_ON_ONCE(1);
> > +			return -EINVAL;
> > +		}
> > +	}
> > +
> > +	iomap->bdev = inode->i_sb->s_bdev;
> > +	iomap->offset = (u64)map.lblk << blkbits;
> > +	iomap->length = (u64)map.len << blkbits;
> > +
> > +	if (map.pblk == 0) {
> > +		iomap->type = IOMAP_HOLE;
> > +		iomap->addr = IOMAP_NULL_ADDR;
> > +	} else {
> > +		if (map.flags & OCFS2_MAP_UNWRITTEN) {
> > +			iomap->type = IOMAP_UNWRITTEN;
> > +		} else if (map.flags & OCFS2_MAP_MAPPED) {
> > +			iomap->type = IOMAP_MAPPED;
> > +		} else {
> > +			WARN_ON_ONCE(1);
> > +			return -EIO;
> > +		}
> > +		iomap->addr = (sector_t)map.pblk << blkbits;
> > +	}
> > +
> > +	if (map.flags & OCFS2_MAP_NEW)
> > +		iomap->flags |= IOMAP_F_NEW;
> > +
> > +	return 0;
> > +}
> > +
> > +const struct iomap_ops ocfs2_iomap_ops = {
> > +	.iomap_begin	= ocfs2_iomap_begin,
> > +};
> > +
> > +/*
> > + * Direct I/O completion. Like the old ocfs2_dio_end_io(), we use the rw_lock
> > + * DLM lock to protect io on one node from truncation on another, and drop it
> > + * here once the io has completed. iomap_dio_complete() always calls this,
> > + * including on the buffered-fallback (-ENOTBLK) path, so the rw_lock taken in
> > + * ocfs2_file_{read,write}_iter() is released exactly once.
> > + */
> > +static int ocfs2_iomap_dio_end_io(struct kiocb *iocb, ssize_t size, int error,
> > +				  int level)
> > +{
> > +	struct inode *inode = file_inode(iocb->ki_filp);
> > +
> > +	/*
> > +	 * iomap_dio_complete() calls us even when no I/O was issued because the
> 
> This looks incorrect.
> If __iomap_dio_rw() returns NULL, iomap_dio_complete() is never called.
> 

This function is just a direct copy of your same named function
ocfs2_iomap_dio_end_io(). I will revise the comments:

  When iomap_dio_complete() calls us with size==0 and error==0, it means the
  mapping bounced back to buffered I/O. In that case leave the rw_lock ......

> > +	 * mapping bounced us back to buffered I/O (reported as size == 0 and
> > +	 * error == 0). In that case leave the rw_lock held so
> > +	 * ocfs2_file_{read,write}_iter() keeps it for the buffered retry and
> > +	 * releases it in its own cleanup path.
> > +	 */
> > +	if (size == 0 && error == 0)
> > +		return 0;
> > +
> > +	ocfs2_rw_unlock(inode, level);
> > +	return error;
> > +}
> > +
> > +static int ocfs2_dio_end_io_r_pr(struct kiocb *iocb, ssize_t size,
> > +				int error, unsigned int flags)
> > +{
> > +	if (error)
> > +		mlog_ratelimited(ML_ERROR, "Direct IO failed, bytes = %lld errno:%d",
> > +				 (long long)size, error);
> > +
> > +	error = ocfs2_iomap_dio_end_io(iocb, size, error, 0);
> > +
> > +bail:
> 
> Seems it is a dead label.

I used "git rebase" to adjust the code, which left this dead label.
I will remove it in the next version.

Thanks,
Heming
> 
> > +	return error;
> > +}
> > +
> > +const struct iomap_dio_ops ocfs2_iomap_dio_ops_r_pr = {
> > +	.end_io = ocfs2_dio_end_io_r_pr,
> > +};
> >  const struct address_space_operations ocfs2_aops = {
> >  	.dirty_folio		= block_dirty_folio,
> >  	.read_folio		= ocfs2_read_folio,
> > diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> > index d6e977ba6565..a0b3883216bc 100644
> > --- a/fs/ocfs2/file.c
> > +++ b/fs/ocfs2/file.c
> > @@ -9,6 +9,7 @@
> >  
> >  #include <linux/capability.h>
> >  #include <linux/fs.h>
> > +#include <linux/iomap.h>
> >  #include <linux/types.h>
> >  #include <linux/slab.h>
> >  #include <linux/highmem.h>
> > @@ -2374,6 +2375,19 @@ static int ocfs2_prepare_inode_for_write(struct file *file,
> >  	return ret;
> >  }
> >  
> > +static bool ocfs2_should_use_dio(struct kiocb *iocb, struct iov_iter *iter,
> > +				struct inode *inode)
> > +{
> > +	/*
> > +	 * Fallback to buffered I/O if we see an inode without
> > +	 * extents.
> > +	 */
> > +	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
> > +		return false;
> > +
> > +	return true;
> > +}
> > +
> >  static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
> >  				    struct iov_iter *from)
> >  {
> > @@ -2548,7 +2562,6 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
> >  			filp->f_path.dentry->d_name.name,
> >  			to->nr_segs);	/* GRRRRR */
> >  
> > -
> >  	if (!inode) {
> >  		ret = -EINVAL;
> >  		mlog_errno(ret);
> > @@ -2558,7 +2571,8 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
> >  	if (!direct_io && nowait)
> >  		return -EOPNOTSUPP;
> >  
> > -	ocfs2_iocb_init_rw_locked(iocb);
> > +	if (!iov_iter_count(to))
> > +		return 0; /* skip atime */
> >  
> >  	/*
> >  	 * buffered reads protect themselves in ->read_folio().  O_DIRECT reads
> > @@ -2576,8 +2590,6 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
> >  			goto bail;
> >  		}
> >  		rw_level = 0;
> > -		/* communicate with ocfs2_dio_end_io */
> > -		ocfs2_iocb_set_rw_locked(iocb, rw_level);
> >  	}
> >  
> >  	/*
> > @@ -2598,17 +2610,42 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
> >  	}
> >  	ocfs2_inode_unlock(inode, lock_level);
> >  
> > -	ret = generic_file_read_iter(iocb, to);
> > +	if (direct_io && ocfs2_should_use_dio(iocb, to, inode)) {
> > +		struct iomap_dio *dio;
> > +
> > +		dio = __iomap_dio_rw(iocb, to, &ocfs2_iomap_ops,
> > +				&ocfs2_iomap_dio_ops_r_pr, 0, NULL, 0);
> > +		if (dio == NULL) {
> > +			/* No I/O issued; rw_lock still held. */
> > +			ret = 0;
> > +		} else if (IS_ERR(dio)) {
> > +			ret = PTR_ERR(dio);
> > +			if (ret == -EIOCBQUEUED)
> > +				rw_level = -1;
> > +		} else {
> > +			ret = iomap_dio_complete(dio);
> > +			if (ret != 0)
> > +				rw_level = -1;
> > +		}
> > +		/*
> > +		 * A 0 result means the mapping bounced us back to buffered I/O
> > +		 * (e.g. inline data); the rw_lock is still held. Clear
> > +		 * IOCB_DIRECT so generic_file_read_iter() takes the buffered
> > +		 * path rather than re-entering direct I/O.
> > +		 */
> > +		if (ret == 0) {
> > +			iocb->ki_flags &= ~IOCB_DIRECT;
> > +			ret = generic_file_read_iter(iocb, to);
> > +		}
> > +	} else {
> > +		iocb->ki_flags &= ~IOCB_DIRECT;
> > +		ret = generic_file_read_iter(iocb, to);
> > +	}
> >  	trace_generic_file_read_iter_ret(ret);
> >  
> >  	/* buffered aio wouldn't have proper lock coverage today */
> >  	BUG_ON(ret == -EIOCBQUEUED && !direct_io);
> >  
> > -	/* see ocfs2_file_write_iter */
> > -	if (ret == -EIOCBQUEUED || !ocfs2_iocb_is_rw_locked(iocb)) {
> > -		rw_level = -1;
> > -	}
> > -
> >  bail:
> >  	if (rw_level != -1)
> >  		ocfs2_rw_unlock(inode, rw_level);
> > diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> > index 095f7ae5dded..a775c1869293 100644
> > --- a/fs/ocfs2/ocfs2.h
> > +++ b/fs/ocfs2/ocfs2.h
> > @@ -549,6 +549,9 @@ struct ocfs2_map_block {
> >  	unsigned int flags;
> >  };
> >  
> > +extern const struct iomap_ops ocfs2_iomap_ops;
> > +extern const struct iomap_dio_ops ocfs2_iomap_dio_ops_r_pr;
> > +
> >  /* Flags used by ocfs2_map_blocks() */
> >  #define OCFS2_GET_BLOCKS_CREATE	(0x0001)
> >  
> > diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
> > index c501eb3cdcda..000bd014acbd 100644
> > --- a/fs/ocfs2/ocfs2_fs.h
> > +++ b/fs/ocfs2/ocfs2_fs.h
> > @@ -314,6 +314,9 @@
> >   */
> >  #define OCFS2_CLUSTER_O2CB_GLOBAL_HEARTBEAT	(0x01)
> >  
> > +/* Max logical block we can support */
> > +#define OCFS2_MAX_LOGICAL_BLOCK	(0xFFFFFFFE)
> > +
> >  struct ocfs2_system_inode_info {
> >  	char	*si_name;
> >  	int	si_iflags;
> 
