Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46234A00
	for <ocfs2-devel@lists.linux.dev>; Wed, 24 Jul 2024 03:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721791222; cv=none; b=kdvyI61i5XgO6p0N1LT2oLBpYbexD4kqcVAEYnUL75YuURYDnKyZBUO9ipYxhE03ynTDHdpfSA7xcmz+dYEZkNyMhp2YjjQl+sYuudL4CCUWZnjeDUb7OGIJUzAc3p8l0TrwdWvIczxYHJ7lDC9zl9ql0NWekYMnGsjbyF/daWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721791222; c=relaxed/simple;
	bh=7Y2esvLbKIg+elxXf1UbAAZRbHPwxlAhyAQjamy9Z5Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i8DypAyvRWipNvOx2RyeQONwGnbmoc/xeEZcZY8vQKYodjR7MQqn3K0t1mdu7p0N1t5ve6i01h65gSQkD7ECEHkQ9ZEhIPdE3t3j0bpWrBTsluHSgzBp6Wp9AV9XVH8cNL1gPARC4CLgNx+XZAdcmwIvKQyD0Tldy0+eC6poNw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=F/dmDyOr; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="F/dmDyOr"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-367963ea053so4516475f8f.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 23 Jul 2024 20:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721791217; x=1722396017; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GxRQQFfktnMIBEArGlArdWsvoWcXPLC1ofHwLqSH5TQ=;
        b=F/dmDyOrA2MTjTr02GLydGmK5ZZcY0rh+rZovR+haKOoeCiRggC8WKSkVY6rnunbKx
         6Hfs5Qyh9+eIqRcdw8WWWP2DdXhaIVCiydRvaWv9X3DMhLhLxzUeFoQ73cXI2Vfh1oN2
         rRz8RdCyD0XQwxUYvV/ulJZHoRteN1J9hZfKf0nR2OrpbBWmyFxyUVu2NpGJchwMibBY
         9hPwDM5iKwmtu28fXYNaw62ItGxnWYUlvTUZDJDnjKJ1wLPItgHaqygNYd7uHA110l0o
         6c5GZrunPqLXJM2xc+atKHUyMZ17rN0eA16J3ckJu9DWvOCXkIDeRwg8Tgl+tRmhoGgr
         w8RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721791217; x=1722396017;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GxRQQFfktnMIBEArGlArdWsvoWcXPLC1ofHwLqSH5TQ=;
        b=eIb2cPRv35RBjsjJC6+pQFH/Y1XmfpMLKc8YkS6LUWjgOof7n3DzzQxDtcKkkro0bN
         RNI+qgxA057qeVAf36Vw0IFFFF40QHPq8bkajSteVW3ssgJwzAFfc9ecbmdKPc+K2Gm/
         BQKs5qA3YUccYk2/H2A+HwTvuXIYiZ6KtqjLwkzztpEgxvR/KuP9541aRjzvqIyqwahJ
         lzDaGGGp+VrF194jntaRVeuVvuUWk/OcXkXO4cJzzseWZ7hpLS0zEbO7051no/M2T8iA
         QsiSFxjeIFknfuiJH2Gc9teUSd0Nish7pp8QDyuoa5aqd88AiuhsMzLTIsxvlSkamxA3
         2YzQ==
X-Gm-Message-State: AOJu0YwX/CmsDs1D9st/WBgAfOzDjIOugaIlxEj+Mb9iGqJeHWhyEnHB
	qhrdMELNuBnCyD4zYKzIA44DVi6pcrA/8usxoXJJPrv/hmbq9urnt18kxAVEcsNy7RadjZuOQk/
	s
X-Google-Smtp-Source: AGHT+IFk8v2EZsavLX4ikdSAKRx3qAjFizqMKF5EDv5dU396ErRpcW9RfYJ0IGaRHx5z3ahL0ecpdw==
X-Received: by 2002:a5d:6188:0:b0:368:4b9d:ee2c with SMTP id ffacd0b85a97d-369f09bcf6amr1350435f8f.19.1721791216828;
        Tue, 23 Jul 2024 20:20:16 -0700 (PDT)
Received: from [10.202.0.23] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fd6f2577e1sm83083955ad.55.2024.07.23.20.20.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jul 2024 20:20:16 -0700 (PDT)
Message-ID: <f97c29f1-f399-4c02-9099-0725996b7f30@suse.com>
Date: Wed, 24 Jul 2024 11:20:13 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ocfs2: give ocfs2 the ability to reclaim suballoc free
 bg
To: Su Yue <glass.su@suse.com>, joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev
References: <20240721104626.19419-1-heming.zhao@suse.com>
 <253cf778-e1b5-45a8-8f96-c2256e95a6d6@suse.com>
 <84ebe4c8-8d1c-4542-a063-df14e7444885@suse.com>
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <84ebe4c8-8d1c-4542-a063-df14e7444885@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/24/24 09:53, Su Yue wrote:
> 
> 
> On 2024/7/23 17:41, Heming Zhao wrote:
>> Hi Glass,
>>
>> Thanks for your great verification job. You found a issue in this patch.
>> Please see my comment below.
>>
>> On 7/21/24 18:46, Heming Zhao wrote:
>>> The current ocfs2 code can't reclaim suballocator block group space.
>>> This cause ocfs2 to hold onto a lot of space in some cases. for example,
>>> when creating lots of small files, the space is held/managed by
>>> '//inode_alloc'. After the user deletes all the small files, the space
>>> never returns to '//global_bitmap'. This issue prevents ocfs2 from
>>> providing the needed space even when there is enough free space in a
>>> small ocfs2 volume.
>>> This patch gives ocfs2 the ability to reclaim suballoc free space when
>>> the block group is free. For performance reasons, ocfs2 doesn't release
>>> the first suballocator block group.
>>>
>>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>>> ---
>>>   fs/ocfs2/suballoc.c | 195 +++++++++++++++++++++++++++++++++++++++++++-
>>>   1 file changed, 192 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
>>> index f7b483f0de2a..4614416417fe 100644
>>> --- a/fs/ocfs2/suballoc.c
>>> +++ b/fs/ocfs2/suballoc.c
>>> @@ -294,6 +294,58 @@ static int ocfs2_validate_group_descriptor(struct super_block *sb,
>>>       return ocfs2_validate_gd_self(sb, bh, 0);
>>>   }
>>> +/*
>>> + * hint gd may already be released in _ocfs2_free_suballoc_bits(),
>>> + * we first check gd descriptor signature, then do the
>>> + * ocfs2_read_group_descriptor() jobs.
>>> + */
>>> +static int ocfs2_read_hint_group_descriptor(struct inode *inode, struct ocfs2_dinode *di,
>>> +                u64 gd_blkno, struct buffer_head **bh)
>>> +{
>>> +    int rc;
>>> +    struct buffer_head *tmp = *bh;
>>> +    struct ocfs2_group_desc *gd;
>>> +
>>> +    rc = ocfs2_read_block(INODE_CACHE(inode), gd_blkno, &tmp, NULL);
>>> +    if (rc)
>>> +        goto out;
>>> +
>>> +    gd = (struct ocfs2_group_desc *) tmp->b_data;
>>> +    if (!OCFS2_IS_VALID_GROUP_DESC(gd))  >> +        /*
>>> +         * Invalid gd cache was set in ocfs2_read_block(),
>>> +         * which will affect block_group allocation.
>>> +         * Path:
>>> +         * ocfs2_reserve_suballoc_bits
>>> +         *  ocfs2_block_group_alloc
>>> +         *   ocfs2_block_group_alloc_contig
>>> +         *    ocfs2_set_new_buffer_uptodate
>>> +         */
>>> +        ocfs2_remove_from_cache(INODE_CACHE(inode), tmp);
>>> +        rc = -EIDRM;
>>> +        goto free_bh;
>>> +    }
>>> +
>>> +    rc = ocfs2_validate_group_descriptor(inode->i_sb, tmp);
>>
>> If mkfs.ocfs2 format disk with ecc enable, above func
>> ocfs2_validate_group_descriptor() will report -5 with "CRC32 failed".
>> The reason is when ocfs2_validate_group_descriptor() is called,
>> the buffer head (parameter:tmp) very likely in jbd cache, and crc
>> is not uptodate, then triggered CRC error.
>>
>> Just as ocfs2_read_blocks() handles input validate(), the correct
>> code should be:
>>          if (buffer_jbd(tmp)) //zhm: bypass the bh in cache
>>                  goto validate_parent; //see below
>>
>>      rc = ocfs2_validate_group_descriptor(inode->i_sb, tmp);
>>
>>> +    if (rc)
>>> +        goto free_bh;
>>> +
>>
>> Add goto label 'validate_parent:' here.
>>
>> Thanks,
>> Heming
>>
>>> +    rc = ocfs2_validate_gd_parent(inode->i_sb, di, tmp, 0);
>>> +    if (rc)
>>> +        goto free_bh;
>>> +
>>> +    /* If ocfs2_read_block() got us a new bh, pass it up. */
>>> +    if (!*bh)
>>> +        *bh = tmp;
>>> +
>>> +    return rc;
>>> +
>>> +free_bh:
>>> +    brelse(tmp);
>>> +out:
>>> +    return rc;
>>> +}
>>> +
>>>   int ocfs2_read_group_descriptor(struct inode *inode, struct ocfs2_dinode *di,
>>>                   u64 gd_blkno, struct buffer_head **bh)
>>>   {
>>> @@ -1730,10 +1782,11 @@ static int ocfs2_search_one_group(struct ocfs2_alloc_context *ac,
>>>       struct ocfs2_dinode *di = (struct ocfs2_dinode *)ac->ac_bh->b_data;
>>>       struct inode *alloc_inode = ac->ac_inode;
>>> -    ret = ocfs2_read_group_descriptor(alloc_inode, di,
>>> +    ret = ocfs2_read_hint_group_descriptor(alloc_inode, di,
>>>                         res->sr_bg_blkno, &group_bh);
>>>       if (ret < 0) {
>>> -        mlog_errno(ret);
>>> +        if (ret != -EIDRM)
>>> +            mlog_errno(ret);
>>>           return ret;
>>>       }
>>> @@ -1961,6 +2014,7 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
>>>           goto bail;
>>>       }
>>> +    /* the hint bg may already be released, we quiet search this group. */
>>>       res->sr_bg_blkno = hint;
>>>       if (res->sr_bg_blkno) {
>>>           /* Attempt to short-circuit the usual search mechanism
>>> @@ -1971,12 +2025,16 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
>>>                           min_bits, res, &bits_left);
>>>           if (!status)
>>>               goto set_hint;
>>> +        if (status == -EIDRM) {
>>> +            res->sr_bg_blkno = 0;
>>> +            goto chain_search;
>>> +        }
>>>           if (status < 0 && status != -ENOSPC) {
>>>               mlog_errno(status);
>>>               goto bail;
>>>           }
>>>       }
>>> -
>>> +chain_search:
>>>       cl = (struct ocfs2_chain_list *) &fe->id2.i_chain;
>>>       victim = ocfs2_find_victim_chain(cl);
>>> @@ -2077,6 +2135,12 @@ int ocfs2_claim_metadata(handle_t *handle,
>>>       return status;
>>>   }
>>> +/*
>>> + * after ocfs2 has the ability to release block group unused space,
>>> + * the ->ip_last_used_group may be invalid. so this function returns
>>> + * ac->ac_last_group need to verify.
>>> + * refer the 'hint' in ocfs2_claim_suballoc_bits() for more details.
>>> + */
>>>   static void ocfs2_init_inode_ac_group(struct inode *dir,
>>>                         struct buffer_head *parent_di_bh,
>>>                         struct ocfs2_alloc_context *ac)
>>> @@ -2534,6 +2598,16 @@ static int _ocfs2_free_suballoc_bits(handle_t *handle,
>>>       struct ocfs2_group_desc *group;
>>>       __le16 old_bg_contig_free_bits = 0;
>>> +    struct buffer_head *main_bm_bh = NULL;
>>> +    struct inode *main_bm_inode = NULL;
>>> +    struct ocfs2_super *osb = OCFS2_SB(alloc_inode->i_sb);
>>> +    struct ocfs2_chain_rec *rec;
>>> +    u64 start_blk;
>>> +    int idx, i, next_free_rec, len = 0;
>>> +    int free_main_bm_inode = 0, free_main_bm_bh = 0;
>>> +    u16 bg_start_bit;
>>> +
>>> +reclaim:
> 
> The label is used for jumping to clearing clusters for global_bitmap.
> I'd suggest factor out the main part into a function and call it twice.
> Just a personal code style taste.
> 

This function (_ocfs2_free_suballoc_bits) is also used to clean
the global_bitmap. If we factor out the patch code, it just calls
_ocfs2_free_suballoc_bits again. So I used a goto label.

>>>       /* The alloc_bh comes from ocfs2_free_dinode() or
>>>        * ocfs2_free_clusters().  The callers have all locked the
>>>        * allocator and gotten alloc_bh from the lock call.  This
>>> @@ -2581,9 +2655,124 @@ static int _ocfs2_free_suballoc_bits(handle_t *handle,
>>>                count);
>>>       tmp_used = le32_to_cpu(fe->id1.bitmap1.i_used);
>>>       fe->id1.bitmap1.i_used = cpu_to_le32(tmp_used - count);
>>> +
>>> +    idx = le16_to_cpu(group->bg_chain);
>>> +    rec = &(cl->cl_recs[idx]);
>>> +
>>> +    /* bypass: global_bitmap, not empty rec, first item in cl_recs[] */
>>> +    if (ocfs2_is_cluster_bitmap(alloc_inode) ||
>>> +        (rec->c_free != (rec->c_total - 1)) ||
>>> +        (le16_to_cpu(cl->cl_next_free_rec) == 1)) {
>>> +        ocfs2_journal_dirty(handle, alloc_bh);
>>> +        goto bail;
>>> +    }
>>> +
>>> +    ocfs2_journal_dirty(handle, alloc_bh);
>>> +    ocfs2_extend_trans(handle, ocfs2_calc_group_alloc_credits(osb->sb,
>>> +                         le16_to_cpu(cl->cl_cpg)));
>>> +    status = ocfs2_journal_access_di(handle, INODE_CACHE(alloc_inode),
>>> +                     alloc_bh, OCFS2_JOURNAL_ACCESS_WRITE);
>>> +    if (status < 0) {
>>> +        mlog_errno(status);
>>> +        goto bail;
>>> +    }
>>> +
>>> +    /*
>>> +     * Only clear the rec item in-place.
>>> +     *
>>> +     * If idx is not the last, we don't compress (remove the empty item)
>>> +     * the cl_recs[]. If not, we need to do lots jobs.
>>> +     *
>>> +     * Compress cl_recs[] code example:
>>> +     * if (idx != cl->cl_next_free_rec - 1)
>>> +     *     memmove(&cl->cl_recs[idx], &cl->cl_recs[idx + 1],
>>> +     *         sizeof(struct ocfs2_chain_rec) *
>>> +     *         (cl->cl_next_free_rec - idx - 1));
>>> +     * for(i = idx; i < cl->cl_next_free_rec-1; i++) {
>>> +     *     group->bg_chain = "later group->bg_chain";
>>> +     *     group->bg_blkno = xxx;
>>> +     *     ... ...
>>> +     * }
>>> +     */
>>> +
>>> +    tmp_used = le32_to_cpu(fe->id1.bitmap1.i_total);
>>> +    fe->id1.bitmap1.i_total = cpu_to_le32(tmp_used - le32_to_cpu(rec->c_total));
>>> +
>>> +    /* Substraction 1 for the block group itself */
>>> +    tmp_used = le32_to_cpu(fe->id1.bitmap1.i_used);
>>> +    fe->id1.bitmap1.i_used = cpu_to_le32(tmp_used - 1);
>>> +
>>> +    tmp_used = le32_to_cpu(fe->i_clusters);
>>> +    fe->i_clusters = cpu_to_le32(tmp_used - le16_to_cpu(cl->cl_cpg));
> 
> It seems fe->i_clusters is protected by OCFS2_I(alloc_inode)->ip_lock too? see ocfs2_group_add().
> 

No need.
In ocfs2_group_add(), the ->ip_lock protects OCFS2_I(main_bm_inode)->ip_clusters
not fe->i_clusters.

>>> +
>>> +    spin_lock(&OCFS2_I(alloc_inode)->ip_lock);
>>> +    OCFS2_I(alloc_inode)->ip_clusters -= le32_to_cpu(fe->i_clusters);
>>> +    fe->i_size = cpu_to_le64(ocfs2_clusters_to_bytes(alloc_inode->i_sb,
>>> +                         le32_to_cpu(fe->i_clusters)));
>>> +    spin_unlock(&OCFS2_I(alloc_inode)->ip_lock);
>>> +    i_size_write(alloc_inode, le64_to_cpu(fe->i_size));
>>> +    alloc_inode->i_blocks = ocfs2_inode_sector_count(alloc_inode);
>>> +
>>>       ocfs2_journal_dirty(handle, alloc_bh);
>>> +    ocfs2_update_inode_fsync_trans(handle, alloc_inode, 0);
>>> +
>>> +    start_blk = rec->c_blkno;
>>> +    count = rec->c_total / le16_to_cpu(cl->cl_bpc);
>>> +
>>> +    next_free_rec = le16_to_cpu(cl->cl_next_free_rec);
> 
> Better to comment what the loop does is that clearing tail empty chain recs.
> 

OK.
>>> +    if (idx == (next_free_rec - 1)) {
>>> +        len++; /* the last item */
>>> +        for (i = (next_free_rec - 2); i > 0; i--)
>>> +            if (cl->cl_recs[i].c_free == cl->cl_recs[i].c_total)
>>> +                len++;
> It should break if recs[i] is not empty. Otherwise next free will point
> the position before some valid recs.

Good catch. I will add 'else break' in v2 patch.

Btw, I found I didn't correctly run ocfs2-test and need to re-run the
test then send the v2 patch.

Thanks,
Heming

> 
> I added some debug output while running fstests/generic/001:
> 
> [ 6317.914239] [  T17758] ======================================================
> [ 6318.619206] [  T18160] jbd2: module verification failed: signature and/or required key missing - tainting kernel
> [ 6318.680271] [  T18159] JBD2: Ignoring recovery information on journal
> [ 6318.681406] [  T18159] ocfs2: Mounting device (253,0) on (node local, slot 0) with ordered data mode.
> [ 6322.902100] [  T18242] JBD2: Ignoring recovery information on journal
> [ 6322.905252] [  T18242] ocfs2: Mounting device (253,1) on (node local, slot 0) with ordered data mode.
> [ 6322.912272] [  T18246] ocfs2: Unmounting device (253,1) on (node local)
> [ 6322.928412] [  T18257] ocfs2: Unmounting device (253,0) on (node local)
> [ 6326.613802] [  T18262] ocfs2: Mounting device (253,0) on (node local, slot 0) with ordered data mode.
> [ 6326.643080] [  T18011] run fstests generic/001 at 2024-07-24 09:40:55
> [ 6345.430856] [  T20794] !!!! _ocfs2_free_suballoc_bits group 20004 rec 0 next free 4
> [ 6345.431887] [  T20794] ....len 0
> [ 6345.432321] [  T20794] ...._ocfs2_free_suballoc_bits group 20004 rec 0 next free 4
> [ 6345.435733] [  T20794] !!!! _ocfs2_free_suballoc_bits group 21028 rec 1 next free 4
> [ 6345.436493] [  T20794] ....len 0
> [ 6345.436812] [  T20794] ...._ocfs2_free_suballoc_bits group 21028 rec 1 next free 4
> [ 6345.440361] [  T20794] !!!! _ocfs2_free_suballoc_bits group 23076 rec 3 next free 4
> [ 6345.441299] [  T20794] ....rec 1 is empty total 0
> [ 6345.441653] [  T20794] ....len 2
> [ 6345.441890] [  T20794] ...._ocfs2_free_suballoc_bits group 23076 rec 3 next free 2
> [ 6345.442578] [  T20794] OCFS2: ERROR (device dm-0): ocfs2_validate_gd_parent: Group descriptor #22052 has bad chain 2 next free chain 2
> [ 6345.443377] [  T20794] On-disk corruption discovered. Please run fsck.ocfs2 once the filesystem is unmounted.
> [ 6345.443952] [  T20794] OCFS2: File system is now read-only.
> [ 6345.444269] [  T20794] (rm,20794,11):_ocfs2_free_suballoc_bits:2631 ERROR: status = -30
> [ 6345.444688] [  T20794] (rm,20794,11):ocfs2_remove_refcount_tree:850 ERROR: status = -30
> [ 6345.445090] [  T20794] (rm,20794,11):ocfs2_wipe_inode:814 ERROR: status = -30
> [ 6345.445432] [  T20794] (rm,20794,11):ocfs2_delete_inode:1082 ERROR: status = -30
> [ 6345.524629] [  T20812] ocfs2: Unmounting device (253,0) on (node local)
> [ 6349.187891] [  T20817] ocfs2: Mounting device (253,0) on (node local, slot 0) with ordered data mode.
> [ 6352.828744] [  T20849] ocfs2: Unmounting device (253,0) on (node local)
> 
> 
> After adding else break. The test passes.
>>> +    } >> +    le16_add_cpu(&cl->cl_next_free_rec, -len);
>>> +
>>> +    rec->c_free = 0;
>>> +    rec->c_total = 0;
>>> +    rec->c_blkno = 0;
>>> +    ocfs2_remove_from_cache(INODE_CACHE(alloc_inode), group_bh);
>>> +    memset(group, 0, sizeof(struct ocfs2_group_desc));
>>> +
>>> +    /* prepare job for reclaim clusters */
>>> +    main_bm_inode = ocfs2_get_system_file_inode(osb,
>>> +                            GLOBAL_BITMAP_SYSTEM_INODE,
>>> +                            OCFS2_INVALID_SLOT);
>>> +    if (!main_bm_inode)
>>> +        goto bail; /* ignore the error in reclaim path */
>>> +
>>> +    inode_lock(main_bm_inode);
>>> +    free_main_bm_inode = 1;
>>> +
>>> +    status = ocfs2_inode_lock(main_bm_inode, &main_bm_bh, 1);
>>> +    if (status < 0)
>>> +        goto bail; /* ignore the error in reclaim path */
>>> +    free_main_bm_bh = 1;
>>> +
>>> +    ocfs2_block_to_cluster_group(main_bm_inode, start_blk, &bg_blkno,
>>> +                     &bg_start_bit);
>>> +    alloc_inode = main_bm_inode;
>>> +    alloc_bh = main_bm_bh;
>>> +    fe = (struct ocfs2_dinode *) alloc_bh->b_data;
>>> +    cl = &fe->id2.i_chain;
>>> +    old_bg_contig_free_bits = 0;
>>> +    brelse(group_bh);
>>> +    group_bh = NULL;
>>> +    start_bit = bg_start_bit;
>>> +    undo_fn = _ocfs2_clear_bit;
>>> +
>>> +    /* reclaim clusters to global_bitmap */
>>> +    goto reclaim;
>>>   bail:
>>> +    if (free_main_bm_bh) {
>>> +        ocfs2_inode_unlock(main_bm_inode, 1);
>>> +        brelse(main_bm_bh);
>>> +    }
>>> +    if (free_main_bm_inode) {
>>> +        inode_unlock(main_bm_inode);
>>> +        iput(main_bm_inode);
>>> +    }
>>>       brelse(group_bh);
>>>       return status;
>>>   }
>>

