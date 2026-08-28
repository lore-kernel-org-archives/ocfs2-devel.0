Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255E33C9890
	for <ocfs2-devel@lists.linux.dev>; Fri, 28 Aug 2026 05:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787896072; cv=none; b=E9Oqlewvp+MBqvJpTU4OBMcAvtXz8O4gFxDbwszxlv9IH0bIQCOY5h9DdUEIBGuodNBRxn6f8gFDoGyuygqvovlLJQDBeGRBesfDkc3RR7V+LnpPhINOt0HFU4YcAQeDlCs6pmimPEx0+ula0xtGw6JE4dkXDZUCcwXp/S0PFgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787896072; c=relaxed/simple;
	bh=TShFH4xW7ecVJ8KETDCQp0gfcSMrWTIKoq+mKu5G9yg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZtUwcaCdr+TjXaNyt00TY1VJm08wcBUigAm60mnnWb3P6762voCnBk3Ios/gpnZ78KFy9BiGUPJvd8tnZ8HeYyQ0JKYZ7jp6VggWbUOzGE/8howirsITqBmzhp9vUzy3CKW0RuceWqg3rrXd2LfiBMgNsbo1T6WW46PsWk0MvxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LndIvPHg; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LndIvPHg"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6a5f5d37778so90672a12.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 27 Aug 2026 22:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787896068; x=1788500868; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PJ7uaLXF6Mnb3HMMNWcBARhXbxoomrS47xDawyR/q8U=;
        b=LndIvPHgsAet8NEzvB1zJ4N9ENXOgHk+jLga+rlyettBcdPQmU5b62eNgh/WDyjvaN
         NVq24/wyqRWk9p5V/ppXCDP4kFTouHTA5yl4iPYHR08fduKnRPwNBzaz02mAIdXT4Q17
         ihH8USrXOhwEFvvGbYzLBpu7yOjblwHLzROhfesoXDR01i+RzlmCDXka4KTFe9T7YJsv
         hk03Ie0jH6apYweI4nm7EjzEmC0FOJBK4CanA5UhkDLeAj632oS/RnecxZ533RicUdrq
         A0Ga9rnE7h4v/S/+E4WmTdQnpYXD7UI6/h774igfrmYE396fJaauWgNdcYJkSVDeWo3j
         D9wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787896068; x=1788500868;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PJ7uaLXF6Mnb3HMMNWcBARhXbxoomrS47xDawyR/q8U=;
        b=LMfUx9VPPQRAE4SJojnrjHhyY+hbKpyo7HJ2YvIf/Wl4AKYc2NoclCQD943emiFuAb
         9686yuG90SfMhWOoFrowaGyIe9OSlP4HuqMC3ge0BMgDHHe9LSDXB8mONIbrFw6gkrOV
         E9n0g39a+2fJh7HgaxKJGR56C8RXjI7ROWlY+i2hHzKV5lBYMXQ5PmzzDstqu2wDc6lN
         hlxHxj9HlxfgMFnALfbZP6vcfqtz/VPCl+JYbGGCMmu6xusO8Z3uqRMGAZgOQzt1Runn
         yHjRk0Skk/daosEXvl+vk0acrCajv/HWO5dfIWD5FdqE7nNEj4E4ilR4IKEKePcBzjfd
         Zhyg==
X-Forwarded-Encrypted: i=1; AHgh+RqeKWHkMxazA/P8sD4fxKzEBjkJuFWPhVf6Z4W+qt359lOkqfSpbwyNIW7sMu6ZtZoiV8rm0UBfLGPt5g==@lists.linux.dev
X-Gm-Message-State: AFuF++lxY4v7rTLGt6IE2GTVxjC3fUdnaoMTri0d1FZa3WpXfLsy+AqH
	m6f5mRFAwm8MUAIW6AFN35/7e9AAVzOLZgQmPxV7myCgmJLYL0N4OoiQ8xPnAeEZeEI=
X-Gm-Gg: AR+sD10O23/dCF7C2u8Sp2sclkES+8wZ1mKfnICh+DJakYFubKoT/2XGl2B/nqnwe2A
	4CLyOHyvg3SrSvBgb7hjLoK+7r9M27e+QWrDlLFmms+4eHIrOdW07FxrrRn0WFW1CLyheZc74eW
	VSM+G2rhRw0z1GkOr0yRTMx5eEcYOQVjVb/72PEMJQSOoPG80sWfcd7Hr1yawVhIqh+rU35aH5y
	TA4F4GNtrdUlx9bDAvEJJ10MQWnFvO0Ti3q5sDTGuTM3I86RMwiQ8Mye3fSGTWQMv/CeFBPaNOS
	Va1jW/jV/Qqvi07v+I4aZhlHol9YH9pRlZjAoThUPrl4qB4RbeHlXf8N7sZ+ArjUwnBKmavCLOp
	lTBJ3ebsyGMxb5yCkn8hRVVSkldoF5M4Uzflbkb3wXwuD61/uwPd/6z4qtcsL//QKfKjf7Bl2it
	L0nkB/D83p8Fy7zp5fdCdp9eA3vrSwh5cuOAsqETxX4WmNDsVFphvDlNyorCs=
X-Received: by 2002:a17:907:6d0f:b0:c16:1290:11a7 with SMTP id a640c23a62f3a-c2556c1768dmr116094266b.1.1787896068237;
        Thu, 27 Aug 2026 22:47:48 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b0ea80edsm5671491a91.1.2026.08.27.22.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 22:47:47 -0700 (PDT)
Date: Fri, 28 Aug 2026 13:47:43 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ocfs2: defer suballocator block group reclaim to
 workqueue
Message-ID: <apEeXAAo1wd5E5Or@p15>
References: <20260827124313.2692416-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827124313.2692416-1-joseph.qi@linux.alibaba.com>

On Thu, Aug 27, 2026 at 08:43:13PM +0800, Joseph Qi wrote:
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
> Reclaim work can still be queued late in dismount, e.g. when orphan
> dir recovery frees inode bits, so both ocfs2_dismount_volume() and
> the mount error path flush ocfs2_wq right before the journal is
> shut down to make sure no reclaim work is left running.  The worker
> also bails out if the journal is already gone.
> 
> Tested with the ocfs2 testsuite (including aio-stress direct IO)
> and umount/mount cycles on a CONFIG_PROVE_LOCKING kernel: the
> circular locking dependency is gone and freed block groups are
> still returned to the global bitmap.
> 
> Fixes: 4a54331616b3 ("ocfs2: give ocfs2 the ability to reclaim suballocator free bg")
> Assisted-by: Qoder:Qwen3.8-Max
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/ocfs2.h    |   5 ++
>  fs/ocfs2/suballoc.c | 202 +++++++++++++++++++++++++++++++++++++-------
>  fs/ocfs2/suballoc.h |   2 +-
>  fs/ocfs2/super.c    |  12 +++
>  4 files changed, 191 insertions(+), 30 deletions(-)
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
> index c62e389d4dd6..c1aafbb9500a 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1779,6 +1779,9 @@ static int ocfs2_mount_volume(struct super_block *sb)
>  	if (osb->local_alloc_state == OCFS2_LA_ENABLED)
>  		ocfs2_shutdown_local_alloc(osb);
>  	ocfs2_release_system_inodes(osb);
> +	/* Drain pending suballoc reclaim work before the journal goes away */
> +	if (osb->ocfs2_wq)
> +		flush_workqueue(osb->ocfs2_wq);

The flush_workqueue() calls ocfs2_get_system_file_inode() to grab main_bm_inode.
However, after ocfs2_release_system_inodes(), all the cached system inodes are gone,
And the _ocfs2_get_system_file_inode() uses osb->sys_root_inode, which is already
freed by ocfs2_release_system_inodes(). So we should move the
flush_workqueue() calls to before ocfs2_release_system_inodes().

>  	/* before journal shutdown, we should release slot_info */
>  	ocfs2_free_slot_info(osb);
>  	ocfs2_journal_shutdown(osb);
> @@ -1850,6 +1853,10 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
>  
>  	ocfs2_release_system_inodes(osb);
>  
> +	/* Drain pending suballoc reclaim work before the journal goes away */
> +	if (osb->ocfs2_wq)
> +		flush_workqueue(osb->ocfs2_wq);
> +

ditto

Thanks,
Heming
>  	ocfs2_journal_shutdown(osb);
>  
>  	/*
> @@ -2134,6 +2141,11 @@ static int ocfs2_initialize_super(struct super_block *sb,
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
