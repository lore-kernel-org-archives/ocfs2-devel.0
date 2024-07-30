Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531A48F5B
	for <ocfs2-devel@lists.linux.dev>; Tue, 30 Jul 2024 01:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722303860; cv=none; b=SqMIfqWyrdMUhi2vZrly8XqFhnYWRoCwacxWQQ6XjNFV3CEyePnbLNeP9LbnuSSXVkdHbKe5NBtIfYjt40AVDr9yTaqQH5LR2bYRNakx8ylUSZhdT1WQVZVqmdaghYIi7EHzqTvQjJjpURGZJuDDwOeBRCwAPlsBCLHuCp3P10o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722303860; c=relaxed/simple;
	bh=ajBmQUR8xdjVXp2HI4UtGfHyhMZUXrkYXYEFb+N2m1Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J3uoKtJC2+Vb3sFXaV+uDErWdpllUiLLOEUsPaIuuzsoqM/rEqKT6MvDxjO3TLQr6NEU45s9YJv07LxtwP/YYrHn7njNj5AK5NiMLL4n4HeCCDgvOLrXSYr7S/edRgYtBhB9Uh1mGX940FAAn0Y8rh/hcZkK076tInYzIMv35U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NMCSN/68; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NMCSN/68"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3684eb5be64so1924492f8f.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 29 Jul 2024 18:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1722303857; x=1722908657; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ljXXu5QJ/Z008UOWeKzY2sxFw1J/4GgEjSsvqqCj+So=;
        b=NMCSN/68mQz6tt0qNgPhu+C+X97wDkTmI+Cahmk4q4Qhy3AyB5qKqegGtOyMt11rcV
         RW1eSb3qWdc1pW0VS3lKNp+5WrL5uWpSgrOg2kiGK7ka2dZDViYpByLw00rjYIJl9tmr
         nlyyOBpr4GzljFstuzX98X7RDNRzv5rXnNGBUZta6ERGPpB4uoDZCFqPjmUtDXBDYX36
         giH0HP19zbKZkkcuDv4ZtDHQWJ/F6HQ0gWCAqli68rat7UYjzfxb1VN9ZyNqkOqueCws
         Z+ao3ZC7DjQgwqvqGxDY8Vi9TzsCl+p7yumsQAjT0iOo9TVTN6GhTp8r0IVeUxIAKldY
         wnUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722303857; x=1722908657;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ljXXu5QJ/Z008UOWeKzY2sxFw1J/4GgEjSsvqqCj+So=;
        b=CxKNPntBoT9mXJs+zVITRfen3zASvATmsRKjOMRqe8B9oIcQ49AF0xlhc4lo187imo
         lCSI0S42dv88OBCSPAYslFTcTAiPDRy0w3Mt6lTmpNXpOonf1848ED4cj2OEvKsOQmN2
         4V+TILky3JZkodG6DSPs9VUVtjAga+uNItmyWLAd6qO65uqpO+7FDtaE3HGqwZMomuhB
         mJIllyxvdYna+sJwTCfbx3ZVhvXLk+MTUEtbwShOgO1Po4j2l62b4ZsrMM6DeqWyxgj8
         ItiOb4A5Zsk4Txe7N8eTcpyhJHaaKBSegPsTQh/17w+8MaNk+RDIINhrIYV0JJP7ikiU
         UIAw==
X-Gm-Message-State: AOJu0YzTL1BxrO6kfMMPgpZjoy4XI/PpI4YqCWjt+uHVQzUoZDK+AqVW
	GXjRoRPvMhK8jkp/EkCItpU8l0GDIfKZ6Swmys8sFv3txb3d1EABjZpqNphRUX8=
X-Google-Smtp-Source: AGHT+IH41iMPY2rzQGhK6LJnTkQ6gwbv6Y5ay7Ei0wab/oWRhCj/77c7u0zyedGAUWbG92nVWCOBxQ==
X-Received: by 2002:adf:f7c1:0:b0:368:4226:4084 with SMTP id ffacd0b85a97d-36b5cee49f1mr6137338f8f.6.1722303856498;
        Mon, 29 Jul 2024 18:44:16 -0700 (PDT)
Received: from [192.168.2.179] ([2406:4440:0:105::28:b])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70ead6e1a35sm7448945b3a.31.2024.07.29.18.44.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jul 2024 18:44:16 -0700 (PDT)
Message-ID: <4a1319ff-5465-4ab4-ac93-63522cc6fe02@suse.com>
Date: Tue, 30 Jul 2024 09:44:13 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] ocfs2: give ocfs2 the ability to reclaim suballoc
 free bg
To: Heming Zhao <heming.zhao@suse.com>, joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev
References: <20240729080454.12771-1-heming.zhao@suse.com>
 <20240729080454.12771-2-heming.zhao@suse.com>
Content-Language: en-US
From: Su Yue <glass.su@suse.com>
In-Reply-To: <20240729080454.12771-2-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2024/7/29 16:04, Heming Zhao wrote:
> The current ocfs2 code can't reclaim suballocator block group space.
> This cause ocfs2 to hold onto a lot of space in some cases. for example,
> when creating lots of small files, the space is held/managed by
> '//inode_alloc'. After the user deletes all the small files, the space
> never returns to '//global_bitmap'. This issue prevents ocfs2 from
> providing the needed space even when there is enough free space in a
> small ocfs2 volume.
> This patch gives ocfs2 the ability to reclaim suballoc free space when
> the block group is free. For performance reasons, ocfs2 doesn't release
> the first suballocator block group.
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>

LGTM:
Reviewed-by: Su Yue <glass.su@suse.com>

> ---
>   fs/ocfs2/suballoc.c | 211 ++++++++++++++++++++++++++++++++++++++++++--
>   1 file changed, 206 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index f7b483f0de2a..1b64f4c87607 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -294,6 +294,60 @@ static int ocfs2_validate_group_descriptor(struct super_block *sb,
>   	return ocfs2_validate_gd_self(sb, bh, 0);
>   }
>   
> +/*
> + * hint gd may already be released in _ocfs2_free_suballoc_bits(),
> + * we first check gd descriptor signature, then do the
> + * ocfs2_read_group_descriptor() jobs.
> + */
> +static int ocfs2_read_hint_group_descriptor(struct inode *inode, struct ocfs2_dinode *di,
> +				u64 gd_blkno, struct buffer_head **bh)
> +{
> +	int rc;
> +	struct buffer_head *tmp = *bh;
> +	struct ocfs2_group_desc *gd;
> +
> +	rc = ocfs2_read_block(INODE_CACHE(inode), gd_blkno, &tmp, NULL);
> +	if (rc)
> +		goto out;
> +
> +	gd = (struct ocfs2_group_desc *) tmp->b_data;
> +	if (!OCFS2_IS_VALID_GROUP_DESC(gd)) {
> +		/*
> +		 * Invalid gd cache was set in ocfs2_read_block(),
> +		 * which will affect block_group allocation.
> +		 * Path:
> +		 * ocfs2_reserve_suballoc_bits
> +		 *  ocfs2_block_group_alloc
> +		 *   ocfs2_block_group_alloc_contig
> +		 *    ocfs2_set_new_buffer_uptodate
> +		 */
> +		ocfs2_remove_from_cache(INODE_CACHE(inode), tmp);
> +		rc = -EIDRM;
> +		goto free_bh;
> +	}
> +
> +	if (!buffer_jbd(tmp)) {
> +		rc = ocfs2_validate_group_descriptor(inode->i_sb, tmp);
> +		if (rc)
> +			goto free_bh;
> +	}
> +
> +	rc = ocfs2_validate_gd_parent(inode->i_sb, di, tmp, 0);
> +	if (rc)
> +		goto free_bh;
> +
> +	/* If ocfs2_read_block() got us a new bh, pass it up. */
> +	if (!*bh)
> +		*bh = tmp;
> +
> +	return rc;
> +
> +free_bh:
> +	brelse(tmp);
> +out:
> +	return rc;
> +}
> +
>   int ocfs2_read_group_descriptor(struct inode *inode, struct ocfs2_dinode *di,
>   				u64 gd_blkno, struct buffer_head **bh)
>   {
> @@ -1730,10 +1784,11 @@ static int ocfs2_search_one_group(struct ocfs2_alloc_context *ac,
>   	struct ocfs2_dinode *di = (struct ocfs2_dinode *)ac->ac_bh->b_data;
>   	struct inode *alloc_inode = ac->ac_inode;
>   
> -	ret = ocfs2_read_group_descriptor(alloc_inode, di,
> +	ret = ocfs2_read_hint_group_descriptor(alloc_inode, di,
>   					  res->sr_bg_blkno, &group_bh);
>   	if (ret < 0) {
> -		mlog_errno(ret);
> +		if (ret != -EIDRM)
> +			mlog_errno(ret);
>   		return ret;
>   	}
>   
> @@ -1961,6 +2016,7 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
>   		goto bail;
>   	}
>   
> +	/* the hint bg may already be released, we quiet search this group. */
>   	res->sr_bg_blkno = hint;
>   	if (res->sr_bg_blkno) {
>   		/* Attempt to short-circuit the usual search mechanism
> @@ -1971,12 +2027,16 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
>   						min_bits, res, &bits_left);
>   		if (!status)
>   			goto set_hint;
> +		if (status == -EIDRM) {
> +			res->sr_bg_blkno = 0;
> +			goto chain_search;
> +		}
>   		if (status < 0 && status != -ENOSPC) {
>   			mlog_errno(status);
>   			goto bail;
>   		}
>   	}
> -
> +chain_search:
>   	cl = (struct ocfs2_chain_list *) &fe->id2.i_chain;
>   
>   	victim = ocfs2_find_victim_chain(cl);
> @@ -2077,6 +2137,12 @@ int ocfs2_claim_metadata(handle_t *handle,
>   	return status;
>   }
>   
> +/*
> + * after ocfs2 has the ability to release block group unused space,
> + * the ->ip_last_used_group may be invalid. so this function returns
> + * ac->ac_last_group need to verify.
> + * refer the 'hint' in ocfs2_claim_suballoc_bits() for more details.
> + */
>   static void ocfs2_init_inode_ac_group(struct inode *dir,
>   				      struct buffer_head *parent_di_bh,
>   				      struct ocfs2_alloc_context *ac)
> @@ -2534,6 +2600,16 @@ static int _ocfs2_free_suballoc_bits(handle_t *handle,
>   	struct ocfs2_group_desc *group;
>   	__le16 old_bg_contig_free_bits = 0;
>   
> +	struct buffer_head *main_bm_bh = NULL;
> +	struct inode *main_bm_inode = NULL;
> +	struct ocfs2_super *osb = OCFS2_SB(alloc_inode->i_sb);
> +	struct ocfs2_chain_rec *rec;
> +	u64 start_blk;
> +	int idx, i, next_free_rec, len = 0;
> +	int free_main_bm_inode = 0, free_main_bm_bh = 0;
> +	u16 bg_start_bit;
> +
> +reclaim:
>   	/* The alloc_bh comes from ocfs2_free_dinode() or
>   	 * ocfs2_free_clusters().  The callers have all locked the
>   	 * allocator and gotten alloc_bh from the lock call.  This
> @@ -2577,13 +2653,138 @@ static int _ocfs2_free_suballoc_bits(handle_t *handle,
>   		goto bail;
>   	}
>   
> -	le32_add_cpu(&cl->cl_recs[le16_to_cpu(group->bg_chain)].c_free,
> -		     count);
> +	idx = le16_to_cpu(group->bg_chain);
> +	rec = &(cl->cl_recs[idx]);
> +
> +	le32_add_cpu(&rec->c_free, count);
>   	tmp_used = le32_to_cpu(fe->id1.bitmap1.i_used);
>   	fe->id1.bitmap1.i_used = cpu_to_le32(tmp_used - count);
>   	ocfs2_journal_dirty(handle, alloc_bh);
>   
> +	/* bypass: global_bitmap, not empty rec, first item in cl_recs[] */
> +	if (ocfs2_is_cluster_bitmap(alloc_inode) ||
> +	    (le32_to_cpu(rec->c_free) != (le32_to_cpu(rec->c_total) - 1)) ||
> +	    (le16_to_cpu(cl->cl_next_free_rec) == 1)) {
> +		goto bail;
> +	}
> +
> +	status = ocfs2_extend_trans(handle,
> +				ocfs2_calc_group_alloc_credits(osb->sb,
> +						 le16_to_cpu(cl->cl_cpg)));
> +	if (status) {
> +		mlog_errno(status);
> +		goto bail;
> +	}
> +	status = ocfs2_journal_access_di(handle, INODE_CACHE(alloc_inode),
> +					 alloc_bh, OCFS2_JOURNAL_ACCESS_WRITE);
> +	if (status < 0) {
> +		mlog_errno(status);
> +		goto bail;
> +	}
> +
> +	/*
> +	 * Only clear the rec item in-place.
> +	 *
> +	 * If idx is not the last, we don't compress (remove the empty item)
> +	 * the cl_recs[]. If not, we need to do lots jobs.
> +	 *
> +	 * Compress cl_recs[] code example:
> +	 * if (idx != cl->cl_next_free_rec - 1)
> +	 * 	memmove(&cl->cl_recs[idx], &cl->cl_recs[idx + 1],
> +	 * 		sizeof(struct ocfs2_chain_rec) *
> +	 * 		(cl->cl_next_free_rec - idx - 1));
> +	 * for(i = idx; i < cl->cl_next_free_rec-1; i++) {
> +	 * 	group->bg_chain = "later group->bg_chain";
> +	 * 	group->bg_blkno = xxx;
> +	 * 	... ...
> +	 * }
> +	 */
> +
> +	tmp_used = le32_to_cpu(fe->id1.bitmap1.i_total);
> +	fe->id1.bitmap1.i_total = cpu_to_le32(tmp_used - le32_to_cpu(rec->c_total));
> +
> +	/* Substraction 1 for the block group itself */
> +	tmp_used = le32_to_cpu(fe->id1.bitmap1.i_used);
> +	fe->id1.bitmap1.i_used = cpu_to_le32(tmp_used - 1);
> +
> +	tmp_used = le32_to_cpu(fe->i_clusters);
> +	fe->i_clusters = cpu_to_le32(tmp_used - le16_to_cpu(cl->cl_cpg));
> +
> +	spin_lock(&OCFS2_I(alloc_inode)->ip_lock);
> +	OCFS2_I(alloc_inode)->ip_clusters -= le32_to_cpu(fe->i_clusters);
> +	fe->i_size = cpu_to_le64(ocfs2_clusters_to_bytes(alloc_inode->i_sb,
> +					     le32_to_cpu(fe->i_clusters)));
> +	spin_unlock(&OCFS2_I(alloc_inode)->ip_lock);
> +	i_size_write(alloc_inode, le64_to_cpu(fe->i_size));
> +	alloc_inode->i_blocks = ocfs2_inode_sector_count(alloc_inode);
> +
> +	ocfs2_journal_dirty(handle, alloc_bh);
> +	ocfs2_update_inode_fsync_trans(handle, alloc_inode, 0);
> +
> +	start_blk = le64_to_cpu(rec->c_blkno);
> +	count = le32_to_cpu(rec->c_total) / le16_to_cpu(cl->cl_bpc);
> +
> +	/*
> +	 * If the rec is the last one, let's compress the chain list by
> +	 * removing the empty cl_recs[] at the end.
> +	 */
> +	next_free_rec = le16_to_cpu(cl->cl_next_free_rec);
> +	if (idx == (next_free_rec - 1)) {
> +		len++; /* the last item */
> +		for (i = (next_free_rec - 2); i > 0; i--) {
> +			if (cl->cl_recs[i].c_free == cl->cl_recs[i].c_total)
> +				len++;
> +			else
> +				break;
> +		}
> +	}
> +	le16_add_cpu(&cl->cl_next_free_rec, -len);
> +
> +	rec->c_free = 0;
> +	rec->c_total = 0;
> +	rec->c_blkno = 0;
> +	ocfs2_remove_from_cache(INODE_CACHE(alloc_inode), group_bh);
> +	memset(group, 0, sizeof(struct ocfs2_group_desc));
> +
> +	/* prepare job for reclaim clusters */
> +	main_bm_inode = ocfs2_get_system_file_inode(osb,
> +						    GLOBAL_BITMAP_SYSTEM_INODE,
> +						    OCFS2_INVALID_SLOT);
> +	if (!main_bm_inode)
> +		goto bail; /* ignore the error in reclaim path */
> +
> +	inode_lock(main_bm_inode);
> +	free_main_bm_inode = 1;
> +
> +	status = ocfs2_inode_lock(main_bm_inode, &main_bm_bh, 1);
> +	if (status < 0)
> +		goto bail; /* ignore the error in reclaim path */
> +	free_main_bm_bh = 1;
> +
> +	ocfs2_block_to_cluster_group(main_bm_inode, start_blk, &bg_blkno,
> +				     &bg_start_bit);
> +	alloc_inode = main_bm_inode;
> +	alloc_bh = main_bm_bh;
> +	fe = (struct ocfs2_dinode *) alloc_bh->b_data;
> +	cl = &fe->id2.i_chain;
> +	old_bg_contig_free_bits = 0;
> +	brelse(group_bh);
> +	group_bh = NULL;
> +	start_bit = bg_start_bit;
> +	undo_fn = _ocfs2_clear_bit;
> +
> +	/* reclaim clusters to global_bitmap */
> +	goto reclaim;
> +
>   bail:
> +	if (free_main_bm_bh) {
> +		ocfs2_inode_unlock(main_bm_inode, 1);
> +		brelse(main_bm_bh);
> +	}
> +	if (free_main_bm_inode) {
> +		inode_unlock(main_bm_inode);
> +		iput(main_bm_inode);
> +	}
>   	brelse(group_bh);
>   	return status;
>   }
