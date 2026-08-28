Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B3D3E0C46
	for <ocfs2-devel@lists.linux.dev>; Fri, 28 Aug 2026 07:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787902962; cv=none; b=P+5UZvojArNvXBNwwkxDntyxgk9ynmzk7lbGTB6h/b/Rld95RAigZVcOkgaCZW8zGXOhePZqbYuDy/QytvxP8z7hYDYrfXCFVwHGx+gncFZaco40cEuK4Aq/XegoHfyaO67oTWasHwBBjh76iQ1yzk03p8jH3ClHp00oueQKdrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787902962; c=relaxed/simple;
	bh=EwakACTH3XyCTJQiltY4d0x0BcikcJgEefmgMx9NuEc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tixDwFziajnvERvlRBCJIjW4KX58KY/tMaTnPK373V2KWN/ZSecelW3PDxudipawCmG11cOApvaUNM5MAVlpGgfvuYFP+rfArjrJwFBK0D8cokZS4ZTZpNw+Q9SAaivtr8R6QEUEWXs0vYUzdAxCrvLZrxCihTgSzHym/N6vb5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AEckakhg; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AEckakhg"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-482e06fda73so73726f8f.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 28 Aug 2026 00:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787902954; x=1788507754; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XXD+d8I5arGkNFtQ0BXYyTruYZG0cFWg6qmgxXzAIhQ=;
        b=AEckakhgjNtgJ/7w2/9p5oe4T8uDikCyyA91ucd/ZuqkGp29ypid3H/fRpdRpfyKPK
         tgA7kpqjbsCXH7ZlCWtBCALXZNkXrDMMS15NVcrR+QkRVxGM3YannZhkXkajB2hn5gmA
         P7dFnx/bo+l9mqov0l6y4ow9h0XFbfzxgjRIcaVytzmtHPNpqvJx1w0lCBH/8AY7WrO6
         9932noyoIyEn0zkB/cDYpeu7QHHJJQM9uJmkOzYPx3QWKmRXplukolBWojb1ayCSA74Q
         Yh9yTV35KRTx8M7Jx7ulcfbNuKXeM1yk5OyeE7So1FdlM/vSlDVG9OEUvCWCLgnrw8X+
         hl/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787902954; x=1788507754;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XXD+d8I5arGkNFtQ0BXYyTruYZG0cFWg6qmgxXzAIhQ=;
        b=hu72ugUnvRJDCTutESF1K2YFqi0RKTkJh/q59F7DHm09ia2iO4yla+5MJxWyrVKOVn
         tpRqFZaI7RyE10/uCjFpnF0HzxNFKTmV32pMZcOrvd42F7g5fC1DBLPgNnfh22Up4BmF
         PgcurtkcJVpQIRgKvsPtLTHcPa8ioqoeDkTb0WS8z83MsxiDvikUlFMOKSk7w6WldMEp
         mB1vqPrb/UOE3skc/Sj3h7kPNmSdj6jhxKCDEuT7kvwFgSREJSIPnDbXG8f9BMYQJEt7
         qliMYPx57RZEO4L01tukEQQ4MgX10hA71HdPA7LgQ9aRBfY+jXXrtblcjUb3JA/1Kgx4
         7nig==
X-Forwarded-Encrypted: i=1; AHgh+RqtEqIcQdvEdRPCekT+x1PKS25SRmAcHlb5Kz7iEG9rG6rNSh06bllKEcvtZp+Hp1Ie3iWzpO+IuiyX4w==@lists.linux.dev
X-Gm-Message-State: AFuF++kaJd/J67Cx3Uu1JrF8AVXyYOWePgQZzGCxzOXTLVg9RNZlMKWW
	RYw553oPeMnHgbQ0NEUvBmlSilKt5FTJTNdc1T4cZI80ddT43X02hg/hRyk+cXw54w4=
X-Gm-Gg: AR+sD12mJ27CJMFpCy0y3IwFJ38sq2Z0Ya8W6rNs81CV2MJMHZ78w1fB8BwjbhcDl8m
	qCBKE4dHKNrJSoyn6hhpzB+a9jNwaZk7f4LWUvSdEFXG/W0rj/UacrwkgWSDr9G+HTSB9ygYyns
	+0VF/BJkbO54SwN6Bnwf7L8Xd9z9yjSNa8HcLFFY/NZvbioJC45/KkAoCnYiD/JcLPsmf642R4U
	TgBOVQKN3Y8Rcxjof7Deb1GjiXCxc1R0BbRU31GkWi19D/Tl1m5kE4TG+LNu/PHGbbdwHwhXlAy
	kWGO64fv4TE5JYYF3XfmfCWKazGDbdTfGavVKznP7tzWmBU2baU4pAO1WpHhxThpvG8CXPLE6Eo
	sy38lU9Q8M6tpwtem+WGVfpK/WumFtGXRESQm+XDxi4btGiN0Ca/N6C/2wLWnJ2Dit6A/Hed9pP
	L2kaf3siybKHB3t52SZ/hXI2Ac0XRrV+7ZeABHgcD6N/f6Zjeuoo4+5GoZ5Tv934p7JFxNDA==
X-Received: by 2002:a05:600c:4686:b0:499:d95a:41f with SMTP id 5b1f17b1804b1-49b91bd68famr37595685e9.0.1787902953887;
        Fri, 28 Aug 2026 00:42:33 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d7598b9444sm2918075ad.74.2026.08.28.00.42.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 00:42:32 -0700 (PDT)
Date: Fri, 28 Aug 2026 15:42:29 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] ocfs2: defer suballocator block group reclaim to
 workqueue
Message-ID: <apE7yQDlxTJKlG0Z@p15>
References: <20260828071553.262254-1-joseph.qi@linux.alibaba.com>
 <20260828071553.262254-2-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260828071553.262254-2-joseph.qi@linux.alibaba.com>

On Fri, Aug 28, 2026 at 03:15:53PM +0800, Joseph Qi wrote:
> When the last bit in a suballocator block group is freed,
> _ocfs2_free_suballoc_bits() reclaims the group back to the global
> bitmap.  The reclaim takes inode_lock() on the global bitmap inode
> while running inside the freeing transaction, adding a lock
> dependency of
> 
>   j_trans_barrier -> global bitmap inode i_rwsem
> 
> This forms a circular dependency with paths such as
> ocfs2_shutdown_local_alloc(), which take the global bitmap inode
> lock before starting a transaction:
> 
>   Task1 (dealloc):
>     ocfs2_run_deallocs
>       ocfs2_free_cached_blocks
>         ocfs2_start_trans
>           down_read(j_trans_barrier)
>         _ocfs2_free_suballoc_bits
>           _ocfs2_reclaim_suballoc_to_main
>             inode_lock(main_bm_inode)  <- wait on Task2
> 
>   Task2 (dismount):
>     ocfs2_shutdown_local_alloc
>       inode_lock(main_bm_inode)
>       ocfs2_start_trans
>         down_read(j_trans_barrier)  <- wait on Task3
> 
>   Task3 (ocfs2cmt):
>     ocfs2_commit_cache
>       down_write(j_trans_barrier)  <- wait on Task1's handle
>       jbd2_journal_flush
> 
> Task1 waits for Task2's inode_lock(), Task2 waits for the
> j_trans_barrier down_write() held by ocfs2cmt, and ocfs2cmt waits
> for Task1's running transaction to commit - a real deadlock,
> observed with aio-stress direct IO writes racing dismount.
> 
> Fix it by deferring the reclaim to the per-superblock ocfs2_wq
> workqueue, so the freeing transaction no longer takes the global
> bitmap inode lock.  The worker re-checks under the suballocator
> locks that the block group is still fully freed (it may have been
> allocated from again in the meantime), takes the global bitmap
> inode locks before starting its own transaction, and performs the
> same suballocator cleanup and space return.  The inode lock order
> (suballocator inode -> global bitmap inode) is consistent with the
> existing "inode lock before transaction" order, breaking the cycle.
> 
> Reclaim work can still be queued late in dismount, e.g. when the
> truncate log is flushed or orphan dir recovery frees inode bits, so
> both ocfs2_dismount_volume() and the mount error path flush
> ocfs2_wq right before the system inodes are released, while the
> journal is still alive, to make sure no reclaim work is left
> running.  The worker also bails out if the journal is already gone.
> 
> Tested with the ocfs2 testsuite (including aio-stress direct IO)
> and umount/mount cycles on a CONFIG_PROVE_LOCKING kernel: the
> circular locking dependency is gone and freed block groups are
> still returned to the global bitmap.
> 
> Fixes: 4a54331616b3 ("ocfs2: give ocfs2 the ability to reclaim suballocator free bg")
> Assisted-by: Qoder:Qwen3.8-Max
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>

LGTM
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/ocfs2.h    |   5 ++
>  fs/ocfs2/suballoc.c | 202 +++++++++++++++++++++++++++++++++++++-------
>  fs/ocfs2/suballoc.h |   2 +-
>  fs/ocfs2/super.c    |  16 ++++
>  4 files changed, 195 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index 62cad6522c7a..b747cdec1787 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -502,6 +502,11 @@ struct ocfs2_super
>  	 */
>  	struct workqueue_struct *ocfs2_wq;
>  
> +	/* deferred reclaim of fully freed suballocator block groups */
> +	spinlock_t os_suballoc_reclaim_lock;
> +	struct list_head os_suballoc_reclaim_list;
> +	struct work_struct os_suballoc_reclaim_work;
> +
>  	/* sysfs directory per partition */
>  	struct kset *osb_dev_kset;
>  
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 20c3aec6b987..453b56be9624 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -2687,16 +2687,24 @@ static int ocfs2_block_group_clear_bits(handle_t *handle,
>   * cleanup rec/alloc_inode job, then switches to the main bitmap
>   * to reclaim released space.
>   *
> + * Callers must hold inode_lock() and ocfs2_inode_lock() on
> + * main_bm_inode, i.e. the global bitmap inode locks must be taken
> + * before starting the transaction.
> + *
>   * handle: The transaction handle
>   * alloc_inode: The suballoc inode
>   * alloc_bh: The buffer_head of suballoc inode
>   * group_bh: The group descriptor buffer_head of suballocator managed.
> - *           Caller should release the input group_bh.
> + *           This function takes ownership of it and will release it.
> + * main_bm_inode: The global bitmap inode
> + * main_bm_bh: The buffer_head of the global bitmap inode
>   */
>  static int _ocfs2_reclaim_suballoc_to_main(handle_t *handle,
>  			struct inode *alloc_inode,
>  			struct buffer_head *alloc_bh,
> -			struct buffer_head *group_bh)
> +			struct buffer_head *group_bh,
> +			struct inode *main_bm_inode,
> +			struct buffer_head *main_bm_bh)
>  {
>  	int idx, status = 0;
>  	int i, next_free_rec, len = 0;
> @@ -2706,8 +2714,6 @@ static int _ocfs2_reclaim_suballoc_to_main(handle_t *handle,
>  	u64 bg_blkno, start_blk;
>  	unsigned int count;
>  	struct ocfs2_chain_rec *rec;
> -	struct buffer_head *main_bm_bh = NULL;
> -	struct inode *main_bm_inode = NULL;
>  	struct ocfs2_super *osb = OCFS2_SB(alloc_inode->i_sb);
>  	struct ocfs2_dinode *fe = (struct ocfs2_dinode *) alloc_bh->b_data;
>  	struct ocfs2_chain_list *cl = &fe->id2.i_chain;
> @@ -2794,24 +2800,12 @@ static int _ocfs2_reclaim_suballoc_to_main(handle_t *handle,
>  	ocfs2_remove_from_cache(INODE_CACHE(alloc_inode), group_bh);
>  	memset(group, 0, sizeof(struct ocfs2_group_desc));
>  
> -	/* prepare job for reclaim clusters */
> -	main_bm_inode = ocfs2_get_system_file_inode(osb,
> -						    GLOBAL_BITMAP_SYSTEM_INODE,
> -						    OCFS2_INVALID_SLOT);
> -	if (!main_bm_inode)
> -		goto bail; /* ignore the error in reclaim path */
> -
> -	inode_lock(main_bm_inode);
> -
> -	status = ocfs2_inode_lock(main_bm_inode, &main_bm_bh, 1);
> -	if (status < 0)
> -		goto free_bm_inode; /* ignore the error in reclaim path */
> -
>  	ocfs2_block_to_cluster_group(main_bm_inode, start_blk, &bg_blkno,
>  				     &start_bit);
>  	fe = (struct ocfs2_dinode *) main_bm_bh->b_data;
>  	cl = &fe->id2.i_chain;
> -	/* reuse group_bh, caller will release the input group_bh */
> +	/* release the suballocator group descriptor before reuse */
> +	brelse(group_bh);
>  	group_bh = NULL;
>  
>  	/* reclaim clusters to global_bitmap */
> @@ -2819,7 +2813,7 @@ static int _ocfs2_reclaim_suballoc_to_main(handle_t *handle,
>  					     &group_bh);
>  	if (status < 0) {
>  		mlog_errno(status);
> -		goto free_bm_bh;
> +		goto bail;
>  	}
>  	group = (struct ocfs2_group_desc *) group_bh->b_data;
>  
> @@ -2827,7 +2821,7 @@ static int _ocfs2_reclaim_suballoc_to_main(handle_t *handle,
>  		ocfs2_error(alloc_inode->i_sb,
>  			"reclaim length (%d) beyands block group length (%d)",
>  			count + start_bit, le16_to_cpu(group->bg_bits));
> -		goto free_group_bh;
> +		goto bail;
>  	}
>  
>  	old_bg_contig_free_bits = group->bg_contig_free_bits;
> @@ -2837,7 +2831,7 @@ static int _ocfs2_reclaim_suballoc_to_main(handle_t *handle,
>  					      _ocfs2_clear_bit);
>  	if (status < 0) {
>  		mlog_errno(status);
> -		goto free_group_bh;
> +		goto bail;
>  	}
>  
>  	status = ocfs2_journal_access_di(handle, INODE_CACHE(main_bm_inode),
> @@ -2847,7 +2841,7 @@ static int _ocfs2_reclaim_suballoc_to_main(handle_t *handle,
>  		ocfs2_block_group_set_bits(handle, main_bm_inode, group, group_bh,
>  				start_bit, count,
>  				le16_to_cpu(old_bg_contig_free_bits), 1);
> -		goto free_group_bh;
> +		goto bail;
>  	}
>  
>  	idx = le16_to_cpu(group->bg_chain);
> @@ -2858,19 +2852,168 @@ static int _ocfs2_reclaim_suballoc_to_main(handle_t *handle,
>  	fe->id1.bitmap1.i_used = cpu_to_le32(tmp_used - count);
>  	ocfs2_journal_dirty(handle, main_bm_bh);
>  
> -free_group_bh:
> +bail:
>  	brelse(group_bh);
> +	return status;
> +}
> +
> +/*
> + * When a suballocator block group becomes fully freed, its space is
> + * reclaimed back to the global bitmap. Taking the global bitmap inode
> + * lock inside the freeing transaction would create a lock dependency
> + * of "j_trans_barrier -> global bitmap inode i_rwsem", which forms a
> + * circular dependency with paths like ocfs2_shutdown_local_alloc() that
> + * take the inode lock before starting a transaction, and can lead to a
> + * real deadlock with the ocfs2cmt journal commit thread. So queue the
> + * reclaim to the workqueue and let it run outside the freeing
> + * transaction.
> + */
> +struct ocfs2_suballoc_reclaim_work {
> +	struct list_head list;
> +	struct inode *alloc_inode;
> +	u64 bg_blkno;
> +};
> +
> +static void ocfs2_queue_suballoc_reclaim(struct ocfs2_super *osb,
> +					 struct inode *alloc_inode,
> +					 u64 bg_blkno)
> +{
> +	struct ocfs2_suballoc_reclaim_work *reclaim_work;
> +
> +	reclaim_work = kmalloc_obj(*reclaim_work, GFP_NOFS);
> +	if (!reclaim_work) {
> +		/*
> +		 * Reclaim is only a space return optimization. If we can't
> +		 * queue it, the freed block group just stays owned by the
> +		 * suballocator.
> +		 */
> +		return;
> +	}
> +
> +	igrab(alloc_inode);
> +	reclaim_work->alloc_inode = alloc_inode;
> +	reclaim_work->bg_blkno = bg_blkno;
> +
> +	spin_lock(&osb->os_suballoc_reclaim_lock);
> +	list_add_tail(&reclaim_work->list, &osb->os_suballoc_reclaim_list);
> +	spin_unlock(&osb->os_suballoc_reclaim_lock);
>  
> -free_bm_bh:
> +	queue_work(osb->ocfs2_wq, &osb->os_suballoc_reclaim_work);
> +}
> +
> +static void ocfs2_do_suballoc_reclaim(struct ocfs2_super *osb,
> +				struct ocfs2_suballoc_reclaim_work *reclaim_work)
> +{
> +	int status, i;
> +	handle_t *handle;
> +	struct inode *alloc_inode = reclaim_work->alloc_inode;
> +	struct inode *main_bm_inode;
> +	struct buffer_head *alloc_bh = NULL, *group_bh = NULL;
> +	struct buffer_head *main_bm_bh = NULL;
> +	struct ocfs2_dinode *fe;
> +	struct ocfs2_chain_list *cl;
> +	struct ocfs2_chain_rec *rec;
> +
> +	/* journal already gone, e.g. during dismount cleanup */
> +	if (!osb->journal)
> +		return;
> +
> +	inode_lock(alloc_inode);
> +	status = ocfs2_inode_lock(alloc_inode, &alloc_bh, 1);
> +	if (status < 0)
> +		goto out_alloc;
> +
> +	fe = (struct ocfs2_dinode *) alloc_bh->b_data;
> +	cl = &fe->id2.i_chain;
> +
> +	/*
> +	 * The block group may have been allocated from again since the
> +	 * reclaim work was queued, re-check that it is still fully freed.
> +	 * A stale work item can also reference a group that is no longer
> +	 * chained, whose descriptor would fail validation and trigger a
> +	 * spurious ocfs2_error(), so verify chain membership first.
> +	 */
> +	for (i = 0; i < le16_to_cpu(cl->cl_next_free_rec); i++) {
> +		rec = &cl->cl_recs[i];
> +		if (le64_to_cpu(rec->c_blkno) == reclaim_work->bg_blkno)
> +			break;
> +	}
> +	if (i == le16_to_cpu(cl->cl_next_free_rec) ||
> +	    ocfs2_is_cluster_bitmap(alloc_inode) ||
> +	    (le32_to_cpu(rec->c_free) != (le32_to_cpu(rec->c_total) - 1)) ||
> +	    (le16_to_cpu(cl->cl_next_free_rec) == 1))
> +		goto out_alloc_unlock;
> +
> +	status = ocfs2_read_group_descriptor(alloc_inode, fe,
> +					     reclaim_work->bg_blkno, &group_bh);
> +	if (status < 0)
> +		goto out_alloc_unlock;
> +
> +	main_bm_inode = ocfs2_get_system_file_inode(osb,
> +						    GLOBAL_BITMAP_SYSTEM_INODE,
> +						    OCFS2_INVALID_SLOT);
> +	if (!main_bm_inode)
> +		goto out_group;
> +
> +	inode_lock(main_bm_inode);
> +	status = ocfs2_inode_lock(main_bm_inode, &main_bm_bh, 1);
> +	if (status < 0)
> +		goto out_main;
> +
> +	handle = ocfs2_start_trans(osb, OCFS2_SUBALLOC_FREE);
> +	if (IS_ERR(handle)) {
> +		status = PTR_ERR(handle);
> +		mlog_errno(status);
> +		goto out_main_unlock;
> +	}
> +
> +	status = _ocfs2_reclaim_suballoc_to_main(handle, alloc_inode,
> +						 alloc_bh, group_bh,
> +						 main_bm_inode, main_bm_bh);
> +	/* group_bh ownership passed to _ocfs2_reclaim_suballoc_to_main() */
> +	group_bh = NULL;
> +	if (status < 0)
> +		mlog_errno(status);
> +
> +	ocfs2_commit_trans(osb, handle);
> +
> +out_main_unlock:
>  	ocfs2_inode_unlock(main_bm_inode, 1);
>  	brelse(main_bm_bh);
> -
> -free_bm_inode:
> +out_main:
>  	inode_unlock(main_bm_inode);
>  	iput(main_bm_inode);
> +out_group:
> +	brelse(group_bh);
> +out_alloc_unlock:
> +	ocfs2_inode_unlock(alloc_inode, 1);
> +	brelse(alloc_bh);
> +out_alloc:
> +	inode_unlock(alloc_inode);
> +}
>  
> -bail:
> -	return status;
> +void ocfs2_suballoc_reclaim_worker(struct work_struct *work)
> +{
> +	struct ocfs2_super *osb = container_of(work, struct ocfs2_super,
> +					       os_suballoc_reclaim_work);
> +	struct ocfs2_suballoc_reclaim_work *reclaim_work;
> +
> +	while (1) {
> +		spin_lock(&osb->os_suballoc_reclaim_lock);
> +		if (list_empty(&osb->os_suballoc_reclaim_list)) {
> +			spin_unlock(&osb->os_suballoc_reclaim_lock);
> +			break;
> +		}
> +		reclaim_work = list_first_entry(&osb->os_suballoc_reclaim_list,
> +					struct ocfs2_suballoc_reclaim_work,
> +					list);
> +		list_del(&reclaim_work->list);
> +		spin_unlock(&osb->os_suballoc_reclaim_lock);
> +
> +		ocfs2_do_suballoc_reclaim(osb, reclaim_work);
> +		iput(reclaim_work->alloc_inode);
> +		kfree(reclaim_work);
> +	}
>  }
>  
>  /*
> @@ -2955,7 +3098,8 @@ static int _ocfs2_free_suballoc_bits(handle_t *handle,
>  		goto bail;
>  	}
>  
> -	_ocfs2_reclaim_suballoc_to_main(handle, alloc_inode, alloc_bh, group_bh);
> +	ocfs2_queue_suballoc_reclaim(OCFS2_SB(alloc_inode->i_sb), alloc_inode,
> +				     bg_blkno);
>  
>  bail:
>  	brelse(group_bh);
> diff --git a/fs/ocfs2/suballoc.h b/fs/ocfs2/suballoc.h
> index bcf2ed4a8631..6042abc032f9 100644
> --- a/fs/ocfs2/suballoc.h
> +++ b/fs/ocfs2/suballoc.h
> @@ -206,7 +206,7 @@ int ocfs2_lock_allocators(struct inode *inode, struct ocfs2_extent_tree *et,
>  
>  int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res);
>  
> -
> +void ocfs2_suballoc_reclaim_worker(struct work_struct *work);
>  
>  /*
>   * The following two interfaces are for ocfs2_create_inode_in_orphan().
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index f785c39d1fb8..b7c29d3c0321 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1787,6 +1787,9 @@ static int ocfs2_mount_volume(struct super_block *sb)
>  out_system_inodes:
>  	if (osb->local_alloc_state == OCFS2_LA_ENABLED)
>  		ocfs2_shutdown_local_alloc(osb);
> +	/* Drain pending suballoc reclaim work before the journal goes away */
> +	if (osb->ocfs2_wq)
> +		flush_workqueue(osb->ocfs2_wq);
>  	ocfs2_release_system_inodes(osb);
>  	/* before journal shutdown, we should release slot_info */
>  	ocfs2_free_slot_info(osb);
> @@ -1857,6 +1860,14 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
>  	if (osb->cconn)
>  		ocfs2_super_unlock(osb, 1);
>  
> +	/*
> +	 * Drain pending suballoc reclaim work while the system inodes and
> +	 * the journal are still alive, since the worker needs to look up
> +	 * the global bitmap inode and start a transaction.
> +	 */
> +	if (osb->ocfs2_wq)
> +		flush_workqueue(osb->ocfs2_wq);
> +
>  	ocfs2_release_system_inodes(osb);
>  
>  	ocfs2_journal_shutdown(osb);
> @@ -2143,6 +2154,11 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	INIT_WORK(&osb->dquot_drop_work, ocfs2_drop_dquot_refs);
>  	init_llist_head(&osb->dquot_drop_list);
>  
> +	spin_lock_init(&osb->os_suballoc_reclaim_lock);
> +	INIT_LIST_HEAD(&osb->os_suballoc_reclaim_list);
> +	INIT_WORK(&osb->os_suballoc_reclaim_work,
> +		  ocfs2_suballoc_reclaim_worker);
> +
>  	/* get some pseudo constants for clustersize bits */
>  	osb->s_clustersize_bits =
>  		le32_to_cpu(di->id2.i_super.s_clustersize_bits);
> -- 
> 2.39.3
> 
