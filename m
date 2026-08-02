Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A637C2D5C68
	for <ocfs2-devel@lists.linux.dev>; Sun,  2 Aug 2026 10:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785667056; cv=none; b=ABYbomXgpEHmMnzEou0tOjQCuT34NSaYn0lsy/jD39pjR8uOAU95FvkvgapefXZkTkdwt91prE+aNO44UBgyakx4nAwOSgn3LkFdVkMdRxyjOUhI8ti4M5esSpFnxpPj/ThFzLKXomUqMNK9fUq8iQpzsMbnTASwdUbaGubCYAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785667056; c=relaxed/simple;
	bh=InKrJCk1a+fYtFFg5XL4yD/BmpaibaLkfR031TRLIf8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZHzrt4XIkJ8M8SVgwcHYT7QconTLbnqkDSi9kXccHvD/f7G8o0NIV7e3F+sWh4Bj/NhWB70Tr40uI1XSyk67WfYyQ8E0XD4/uRWpg+1A4o/iSF71OzkEgO+u5V1E+30Ch41onlU5ymmxxYvLQjYM/AztsWZ2gaLX6c2tJCV3cQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YHFXZqPi; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YHFXZqPi"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-47fc4037340so209543f8f.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 02 Aug 2026 03:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785667053; x=1786271853; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OcFGvJhCANWpgLUVs3lL6SLMUlm/Sqd+TRsG69oeBjM=;
        b=YHFXZqPioHx+ocNEjYvXV8bs2OzIh0ygQ4CAIxFvIypFb98oTjCLW7ZVU2HgIAgUOr
         WOi8oYUpVbsF6CB4Ze8EVARpf5+CtaQbfNwv5ctsThhL8ahiihiXeM3Z70b+QMyXFhFE
         dyt/jNnkpzXzT5l9in6+Lena8xwHIlyidTeoGWsm5kOHj+A/ETw9I4iK2Hwb7bYvLfiO
         SUF55wUB2nlvT/hc0UAzngv64g+65iEcIhAPAahHIF7NyesTwrWku4cNyjd3MRwWL2PF
         U9C65ba7OmJBRa8D9MrEXjzWdprikGdovB98ZV4ViyA+WSU51OjEGj/ufQ16hES7Lk8n
         5EDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785667053; x=1786271853;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OcFGvJhCANWpgLUVs3lL6SLMUlm/Sqd+TRsG69oeBjM=;
        b=BuG1jdIc7I9JOPrqp3ZlJnghTgYwBLiFrSCRhjmdKZcDktOMNK3cB57f5qB2Qr8jZN
         EtvkCae5rvlsoZyBgD8yNNq3Q0LKsI4aKhHrPeTk+xC01ksvtis00lPUJjM+UxvYo9tb
         qcgf4ocT1zr6faXgWZgJllOx4dKlYwGBcIHujkW1e4H9KAYjWl6wSOdj6yh/p4dyObPT
         rPmEtikbOydIgBuP/fjPf/KVS+vq+9SbSgWFCvOti0gS2XUHkCXx80K1CPzCw73FqW1y
         mFAabfXJ/4XxMF7z1O6EfkSPAPoOJyM0dwODAruAughWV3AnVHyENaTIgXueyeMMqY6V
         ZbWQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro087ap3DOesSgqChSIvIkkgV7TObFA22pK2vKrE15PBnKxPyp8x/3APImmhYxS4YxV/zc9++YKlD1CiA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzYTCPGEsSS1lUJ3nBkayUTsk3PJEfhRqGDTgWnX9uaLmm8yRqH
	/8A1ah417ex6U+LcVQsSxcptMpNkpgltlqmgtwTgnUhQyyHrG/ABjDKLUosKlRXZ9m1sIA66BbW
	nSM3xJzc=
X-Gm-Gg: AR+sD11+X22j0Cy83qAhikobTaQyd5vYS0zZzPjKI+L/z+s6sL3R7mZ7M1Xv+qJLbMg
	lemrmQe77rzPkhCetJtuK4goYbDvSNlb9EZyyR2Tw51ZiWFth17wAcPwTySRS98gom6XdcoIDtg
	Wbnd4oRnBJhE+xUPnP7URNKAYmSzfBq+E9Za9hACLa3E1h1AHZ6ABBLh6CsqWgIhM7BlNlpb7g8
	HCxaBe01DFjeOLyl9NPOaucS3OpNWD55hiLrx6YEdIUpZakW2nKqisLdNOAq59Sk/GtLfV0yh2o
	OaNrvyVBhsHJpucEk0xhj1gTl4cVI4PvMbsTr6K620TCcQSkDliKPnMJup8HJLwM8As5zAIRskq
	bjTtl+560Ll+CAofAzW8CV7uNADswkExqKdD2uViWiYGrxd+H5QBkteGuTlJ+N3eCtpGjL+jIcY
	VUDPcv6m/lCyK4OgIQuaF9vJu8Mix9h/Kmzj6GNltYBTWUED40pXnub2OypXc=
X-Received: by 2002:a05:6000:1a8c:b0:46f:7d90:8124 with SMTP id ffacd0b85a97d-47fd7315ec8mr9835131f8f.2.1785667052846;
        Sun, 02 Aug 2026 03:37:32 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38fb2e10549sm2696080a91.2.2026.08.02.03.37.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 03:37:31 -0700 (PDT)
Date: Sun, 2 Aug 2026 18:37:27 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, hch@lst.de, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/4] ocfs2: switch dio write path from buffer_head
 to iomap
Message-ID: <am79Sf7c1TMxzAom@p15>
References: <20260727061802.18485-1-heming.zhao@suse.com>
 <20260727061802.18485-4-heming.zhao@suse.com>
 <b4942947-86cd-45d1-8f31-c8f55e0ae71d@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4942947-86cd-45d1-8f31-c8f55e0ae71d@linux.alibaba.com>

On Tue, Jul 28, 2026 at 02:07:42PM +0800, Joseph Qi wrote:
> 
> 
> On 7/27/26 2:17 PM, Heming Zhao wrote:
> > This patch converts OCFS2's DIO write path from the legacy
> > buffer_head infrastructure to the modern iomap framework.
> > 
> > Key modifications and designs are as follows:
> > 
> > 1. Dynamic Context Allocation:
> >    Refactor 'struct ocfs2_write_ctxt' to use a flexible array 'w_desc[]'
> >    instead of a fixed-size array. Dynamically allocate the context based on
> >    the write length ('w_clen') in 'ocfs2_alloc_write_ctxt()'. This prevents
> >    static limits overflow and optimizes kernel heap memory utilization.
> > 
> > 2. Robust Mapping and Limits:
> >    Introduce 'ocfs2_dio_wr_map_blocks()' to allocate and map direct write
> >    blocks. Implement a 1 MiB cap ('OCFS2_DIO_WR_MAX_MAX_BYTES') per mapping
> >    call to restrict allocation granularity, preventing JBD2 transaction
> >    credit exhaustion during huge asynchronous sequential writes.
> > 
> > 3. Reliable Completion Work and Fallback:
> >    - Implement 'ocfs2_iomap_dio_end_io_write()' to handle metadata completion.
> >      It converts UNWRITTEN extents, updates inode size (EOF), and deletes the
> >      inode from the orphan directory if it was appended.
> >    - Implement 'ocfs2_dio_write_end_io()' to finalize the dio lifecycle and
> >      release cluster locks safely.
> >    - Intercept '-ENOTBLK' errors from 'iomap_dio_rw()' caused by page cache
> >      invalidation failures (due to mmap/buffered collisions). Gracefully clear
> >      the error, strip the IOCB_DIRECT flag, and fall back to buffered write
> > 
> > 4. Moved ocfs2_add_inode_to_orphan():
> >    - moved ocfs2_add_inode_to_orphan() from ocfs2_dio_wr_map_blocks() to
> >      ocfs2_file_write_iter().
> > 
> > 5. Uncertain logic in code
> >    For the following code block in ocfs2_dio_wr_map_blocks():
> >    ```
> >      if (extend) {
> >              if (ocfs2_sparse_alloc(osb))
> >                      ret = ocfs2_zero_tail(inode, di_bh, pos);
> >              else
> >                      ret = ocfs2_expand_nonsparse_inode(inode, di_bh, pos,
> >                                                          map_len, NULL);
> >              if (ret < 0) {
> >                      mlog_errno(ret);
> >                      goto unlock;
> >              }
> >      }
> >    ```
> >    I am not completely certain whether it is called only once per
> >    ocfs2_file_write_iter(), but I believe calling it multiple times will
> >    not introduce any side effects. Furthermore, testing across various
> >    scenarios showed no instances of multiple calls.
> > 
> > Assisted-by: Gemini:gemini-3.5-flash
> > Assisted-by: Claude:claude-sonnet-4-5
> > Co-developed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> > Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> > Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> > ---
> >  fs/ocfs2/aops.c           | 394 ++++++++++++++++++++++++++++++++++++--
> >  fs/ocfs2/buffer_head_io.c |   7 +-
> >  fs/ocfs2/file.c           |  91 +++++++--
> >  fs/ocfs2/ocfs2.h          |   2 +
> >  4 files changed, 459 insertions(+), 35 deletions(-)
> > 
> > diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> > index 12f5f2e3530a..9a079436c9c0 100644
> > --- a/fs/ocfs2/aops.c
> > +++ b/fs/ocfs2/aops.c
> 
> ...
> 
> > +
> > +	ocfs2_free_unwritten_list(inode, &wc->w_unwritten_list);
> > +	ret = ocfs2_write_end_nolock(inode->i_mapping, pos, map_len, map_len, wc);
> > +	BUG_ON(ret != map_len);
> 
> Under memory pressure, folio allocation may fail. In this case,
> ocfs2_write_end_nolock() can return a short count.
> So we must handle this case gracefully.

I simply copied the code logic from ocfs2_dio_wr_get_block().

IIUC, folio allocation mainly happens in ocfs2_write_begin_nolock =>
ocfs2_grab_pages_for_write. while ocfs2_write_end_nolock is responsible for
marking pages dirty.
If the code encounters memory pressure issue, the existing error handling should
be enough (I mean the error handling after ocfs2_write_begin_nolock()).

> 
> > +	ret = 0;
> > +
> > +unlock:
> > +	up_write(&oi->ip_alloc_sem);
> > +	ocfs2_inode_unlock(inode, 1);
> > +	brelse(di_bh);
> > +
> > +out:
> > +	return ret;
> > +}
> > +
> >  static int ocfs2_dio_end_io_write(struct inode *inode,
> >  				  struct ocfs2_dio_write_ctxt *dwc,
> >  				  loff_t offset,
> 
> ...
> 
> > +static int ocfs2_iomap_dio_end_io_write(struct inode *inode,
> > +				  loff_t offset,
> > +				  ssize_t bytes)
> > +{
> > +	struct ocfs2_cached_dealloc_ctxt dealloc;
> > +	struct ocfs2_extent_tree et;
> > +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> > +	struct ocfs2_inode_info *oi = OCFS2_I(inode);
> > +	struct buffer_head *di_bh = NULL;
> > +	struct ocfs2_dinode *di;
> > +	struct ocfs2_alloc_context *data_ac = NULL;
> > +	struct ocfs2_alloc_context *meta_ac = NULL;
> > +	handle_t *handle = NULL;
> > +	loff_t end = offset + bytes;
> > +	int ret = 0, credits = 0;
> > +	struct ocfs2_map_block map;
> > +	unsigned int blkbits = inode->i_blkbits;
> > +	unsigned int max_blocks;
> > +	unsigned int ue_cpos = 0, ue_phys = 0, ue_len = 0;
> > +	unsigned int curr_lblk, end_lblk;
> > +
> > +	map.lblk = offset >> blkbits;
> > +	max_blocks = (bytes + offset) >> osb->s_clustersize_bits;
> 
> Seems unused.
> 

Yes.
> ...
> 
> > +	curr_lblk = offset >> blkbits;
> > +	/*
> > +	 * Round the end up so the final partial block (sub-block direct I/O)
> > +	 * is included; otherwise the last, partially-written cluster is left
> > +	 * unwritten and reads back as zero.
> > +	 */
> > +	end_lblk = (offset + bytes + (1 << blkbits) - 1) >> blkbits;
> > +	while (ret >= 0 && curr_lblk < end_lblk) {
> > +		memset(&map, 0, sizeof(map));
> > +		map.lblk += curr_lblk;
> 
> Since map is memset just now, so here we can use "map.lblk = curr_lblk"
> directly.

Agree.
> 
> > +		map.len = end_lblk - curr_lblk;
> > +
> > +		ret = ocfs2_assure_trans_credits(handle, credits);
> > +		if (ret < 0) {
> > +			mlog_errno(ret);
> > +			break;
> > +		}
> > +
> 
> ...
> 
> > +
> > +static int ocfs2_dio_write_end_io(struct kiocb *iocb, ssize_t size,
> > +			int error, unsigned int flags, int level)
> > +{
> > +	struct inode *inode = file_inode(iocb->ki_filp);
> > +	loff_t offset = iocb->ki_pos;
> > +	int ret = 0;
> > +
> > +	if (error)
> > +		mlog_ratelimited(ML_ERROR, "Direct IO failed, bytes = %lld errno:%d",
> > +				 (long long)size, error);
> > +
> > +	if (size && ((flags & IOMAP_DIO_UNWRITTEN) ||
> > +		    (offset + size > i_size_read(inode)))) {
> 
> Is it safe to do i_size_read() in case async dio completion?
> 

I set IOMAP_DIO_FORCE_WAIT in ocfs2_file_write_iter() when the inode extends the
i_size. Without IOMAP_DIO_FORCE_WAIT, xfstests will fail in many cases.

Thanks,
Heming
