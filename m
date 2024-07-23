Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1106914A4FF
	for <ocfs2-devel@lists.linux.dev>; Tue, 23 Jul 2024 09:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721727674; cv=none; b=NiAtNT/ECiJUOjWyL3iRSq41iPfjkDyhVwcngwd9bp3KLyI4l41qxDcpud0HyLzDMQfLvBAreVqBe10lnriomJu8dl52I8m4BbT0WVG9EU+VTx2tFdVyS5XviP00VnIeDxrLmynRujQtE0XUQLhFIGhEZ/CbcLGMYsUf5KB6yM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721727674; c=relaxed/simple;
	bh=NlipLNDpQFf1Bf8+wOrEJscfbLYDjVCshBTXdngbJ3A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UtZOl8VFOYcnDZSZtjzkfhtUe65IyCOkKcO1NDTbxO+amFvhB34RxfV/VZLaphz1DC3GGbbc3Uu9k/mVRvS+mqDN+0nBVQ0h8MMihqauzKst83zKn7WcaLEgKTjmUsaW9cODLnbaC3JiWy7RU1gA1eLXTUS5rS2SezscUQmuadc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gURKyGhS; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gURKyGhS"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2ef2d582e31so21729681fa.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 23 Jul 2024 02:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721727670; x=1722332470; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lwJVipCHdwa6iAV2RVBVP/4dntjgBh/eZ9z0UdFtpu0=;
        b=gURKyGhS3Gey1IWOJ3WZ62deS49EoFJ10xrJziq/Zbu8E9jMiDj1XoZyYDROlo5vKS
         zTZmfw6XkRF9X36xrIaD1RjOEJQhMCIGQuvY/5FG1FESYsFlXqaQF/Avje8ZMd9rxMJV
         nuPbEtEf3+YA/h5ed8WqCQQMCMlS7/PYTZsqsuuWnSds3XIQZzWA1CgBCTDodx1A+JTx
         IwSp6twaMZYR/iiXPn3uEmJUPBTDntKCYPZ+s+5XmYnpk1hgVCzPw0/Deu9D+E5ytrey
         kPJ9yztNZ6dsd8AvSoECSNyQJ3y4L00IDle/oUHpd71TOWqpV0Suknlo+lOhvmGGqqWu
         hDlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721727670; x=1722332470;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lwJVipCHdwa6iAV2RVBVP/4dntjgBh/eZ9z0UdFtpu0=;
        b=tSxODIl9+TcuIfqeHtVIP98pbTtHNcDXOHtPET1Za5gtBEIlexFInlCYIa0Fh31Dbd
         YFXZs+oFuXGxiNnlTbwye6b2Qdg7rMKlaDciYfxZVuf1v72TJFaarqSOrRdaza2k55i/
         eLsFEQujg+GjMyKEbuxtJFdLapPg2XaIlmjvIaSqBM5G8mJIut20hO/bWVJ0183A34gS
         VOKAhS+DV0U2Zlxz/FKJTynmo2OjVn6fz151mCC7ADEOacMezjhKTFROWRSs4FVukH/8
         9npYIum3IT9YryEtLiYKABfdgypoS/7aFbTU1JFtYZIcQNDTGOrwpmWMmWEOY+PzzDd+
         VkVg==
X-Gm-Message-State: AOJu0Ywy09HCVvPrql7a97OCXkORV7aU7VbT5VYWcztpRUKyC4KDqjbQ
	8il2S9GX8wKFgODn9JVplNTMxKEscdRq1GaCiykxzLShX+quY0Qt9IIyc0RKmlM=
X-Google-Smtp-Source: AGHT+IEvl1/nBKtULRf/QcpRQcBwRc1q1eNBggV0aT+LUuFgQJ/yZMbZNTCC+dLFh9N9W1RMO5Anvg==
X-Received: by 2002:a2e:92d5:0:b0:2ef:2cbc:9074 with SMTP id 38308e7fff4ca-2ef2cbc91c3mr40326791fa.21.1721727670048;
        Tue, 23 Jul 2024 02:41:10 -0700 (PDT)
Received: from [10.202.0.23] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7a06a7cb603sm5084627a12.62.2024.07.23.02.41.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jul 2024 02:41:09 -0700 (PDT)
Message-ID: <253cf778-e1b5-45a8-8f96-c2256e95a6d6@suse.com>
Date: Tue, 23 Jul 2024 17:41:06 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ocfs2: give ocfs2 the ability to reclaim suballoc free
 bg
Content-Language: en-US
To: joseph.qi@linux.alibaba.com, glass.su@suse.com
Cc: ocfs2-devel@lists.linux.dev
References: <20240721104626.19419-1-heming.zhao@suse.com>
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <20240721104626.19419-1-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Glass,

Thanks for your great verification job. You found a issue in this patch.
Please see my comment below.

On 7/21/24 18:46, Heming Zhao wrote:
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
> ---
>   fs/ocfs2/suballoc.c | 195 +++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 192 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index f7b483f0de2a..4614416417fe 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -294,6 +294,58 @@ static int ocfs2_validate_group_descriptor(struct super_block *sb,
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
> +	rc = ocfs2_validate_group_descriptor(inode->i_sb, tmp);

If mkfs.ocfs2 format disk with ecc enable, above func
ocfs2_validate_group_descriptor() will report -5 with "CRC32 failed".
The reason is when ocfs2_validate_group_descriptor() is called,
the buffer head (parameter:tmp) very likely in jbd cache, and crc
is not uptodate, then triggered CRC error.

Just as ocfs2_read_blocks() handles input validate(), the correct
code should be:
         if (buffer_jbd(tmp)) //zhm: bypass the bh in cache
                 goto validate_parent; //see below

	rc = ocfs2_validate_group_descriptor(inode->i_sb, tmp);

> +	if (rc)
> +		goto free_bh;
> +

Add goto label 'validate_parent:' here.

Thanks,
Heming

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
> @@ -1730,10 +1782,11 @@ static int ocfs2_search_one_group(struct ocfs2_alloc_context *ac,
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
> @@ -1961,6 +2014,7 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
>   		goto bail;
>   	}
>   
> +	/* the hint bg may already be released, we quiet search this group. */
>   	res->sr_bg_blkno = hint;
>   	if (res->sr_bg_blkno) {
>   		/* Attempt to short-circuit the usual search mechanism
> @@ -1971,12 +2025,16 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
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
> @@ -2077,6 +2135,12 @@ int ocfs2_claim_metadata(handle_t *handle,
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
> @@ -2534,6 +2598,16 @@ static int _ocfs2_free_suballoc_bits(handle_t *handle,
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
> @@ -2581,9 +2655,124 @@ static int _ocfs2_free_suballoc_bits(handle_t *handle,
>   		     count);
>   	tmp_used = le32_to_cpu(fe->id1.bitmap1.i_used);
>   	fe->id1.bitmap1.i_used = cpu_to_le32(tmp_used - count);
> +
> +	idx = le16_to_cpu(group->bg_chain);
> +	rec = &(cl->cl_recs[idx]);
> +
> +	/* bypass: global_bitmap, not empty rec, first item in cl_recs[] */
> +	if (ocfs2_is_cluster_bitmap(alloc_inode) ||
> +	    (rec->c_free != (rec->c_total - 1)) ||
> +	    (le16_to_cpu(cl->cl_next_free_rec) == 1)) {
> +		ocfs2_journal_dirty(handle, alloc_bh);
> +		goto bail;
> +	}
> +
> +	ocfs2_journal_dirty(handle, alloc_bh);
> +	ocfs2_extend_trans(handle, ocfs2_calc_group_alloc_credits(osb->sb,
> +						 le16_to_cpu(cl->cl_cpg)));
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
>   	ocfs2_journal_dirty(handle, alloc_bh);
> +	ocfs2_update_inode_fsync_trans(handle, alloc_inode, 0);
> +
> +	start_blk = rec->c_blkno;
> +	count = rec->c_total / le16_to_cpu(cl->cl_bpc);
> +
> +	next_free_rec = le16_to_cpu(cl->cl_next_free_rec);
> +	if (idx == (next_free_rec - 1)) {
> +		len++; /* the last item */
> +		for (i = (next_free_rec - 2); i > 0; i--)
> +			if (cl->cl_recs[i].c_free == cl->cl_recs[i].c_total)
> +				len++;
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
>   
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

