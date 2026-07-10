Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B60D4252B2
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Jul 2026 11:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783684687; cv=none; b=F1iBNxTit6eHzfx2UlbHrktfyBv7aZ3URuV5Tbf/5UdYfIkgIG0Y/25lUTx0XpwewHcRUs/acQHDSLV+A3q29pzOkDz0pSP6p1MgrN57H338oSA/mDNNtI2/vwfAXKxjHJvT65U706gdkgktTobjPVacCNLixwBi1Sg4WxrpAVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783684687; c=relaxed/simple;
	bh=+0Tsw2JDdKPzFq03lPk1X/vpjj1tAclF0t1NcvJsNz4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BkHba4AsBORUGkjFOU9aCyXX4e7BuVXQUYKVzvxKAih+BX4A40v3kSCetsM+ODTKDepzqhimW0Q5FH4X70Xq/D8OGpaafFpsPFGR1A5SGHBI3y0mGuHI5GGj1ipuKz4HrZa3rF1Ze53yQspPafdsktMNJ4lHOg9Mq/lT60H0ZxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=cP3nCc0L; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="cP3nCc0L"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783684672; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=bdxWu45eIVaVC9QDMDep/xNtQShWpvZLSrE0kVIt8TY=;
	b=cP3nCc0Lap4o66WDZS/6BTJlWrqtnsEBDafJvlWHThcbYlvNt8E8bRnutVJ8GTWkvNUAo0PDaM4BV11TkWmnEc6MOG2PK+Q/JgjdFELNgqmlNDrdw4P8XfWHxiykY3+dEqJDFevudSkQ/cd6e1ATM+4Xxi8cX9VwqpdV5r6KJPc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R331e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X6nX6q5_1783684670;
Received: from 30.221.145.52(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X6nX6q5_1783684670 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 10 Jul 2026 19:57:51 +0800
Message-ID: <9a7f8287-6139-42e4-a596-fc7c27b4aee6@linux.alibaba.com>
Date: Fri, 10 Jul 2026 19:57:49 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: validate rl_used against rl_count in refcount
 block validator
To: Ibrahim Hashimov <security@auditcode.ai>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260709132609.44233-1-security@auditcode.ai>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260709132609.44233-1-security@auditcode.ai>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/9/26 9:26 PM, Ibrahim Hashimov wrote:
> ocfs2_find_refcount_rec_in_rl() walks the on-disk refcount record
> array with:
> 
> 	for (; i < le16_to_cpu(rb->rf_records.rl_used); i++) {
> 		rec = &rb->rf_records.rl_recs[i];
> 		...
> 
> rl_recs[] lives in a single metadata block (4096 bytes on the common
> configuration), so its real capacity is fixed by
> ocfs2_refcount_recs_per_rb(sb) (247 records for a 4K block with the
> 16-byte ocfs2_refcount_rec). rl_used and rl_count are both read
> directly off disk by ocfs2_validate_refcount_block() and are never
> checked against that capacity, nor against each other, before any
> refcount/reflink/CoW operation walks the array.
> 
> A crafted (or corrupted) refcount block with rl_used == 0xffff makes
> the loop above walk far past the end of the block, dereferencing
> rl_recs[i] for i up to 65534. The resulting index is then handed to
> the sibling ocfs2_insert_refcount_rec(), whose insert-shift does:
> 
> 	if (index < le16_to_cpu(rf_list->rl_used))
> 		memmove(&rf_list->rl_recs[index + 1],
> 			&rf_list->rl_recs[index],
> 			(le16_to_cpu(rf_list->rl_used) - index) *
> 			 sizeof(struct ocfs2_refcount_rec));
> 
> i.e. a memmove() of up to (0xffff - index) * 16 bytes (~1 MiB) from an
> offset already past the block. This is reachable from an ordinary
> reflink (FICLONE) against a crafted/corrupted ocfs2 image: attaching
> an extent whose cpos sorts past every real record in the leaf forces
> the lookup to run off the end instead of returning early on a match.
> The attacker model is local: CAP_SYS_ADMIN mounting a crafted or
> corrupted ocfs2 image, or a raw write to the block device backing an
> already-mounted ocfs2 filesystem.
> 
> ocfs2_validate_refcount_block() already validates the block's ECC,
> signature, rf_blkno and rf_fs_generation, but never rl_count/rl_used
> against the block's actual on-disk capacity. This is the same class
> of gap that ocfs2_validate_extent_block() (fs/ocfs2/alloc.c) already
> closes for the sibling extent-list header, which checks both the
> record capacity and the "used" bound before any code walks
> h_list.l_recs[]:
> 
> 	if (le16_to_cpu(eb->h_list.l_count) != ocfs2_extent_recs_per_eb(sb)) {
> 		rc = ocfs2_error(...);
> 		goto bail;
> 	}
> 
> 	if (le16_to_cpu(eb->h_list.l_next_free_rec) >
> 	    le16_to_cpu(eb->h_list.l_count)) {
> 		rc = ocfs2_error(...);
> 		goto bail;
> 	}
> 
> Add the equivalent pair of checks to ocfs2_validate_refcount_block():
> reject a refcount block whose rl_count does not match the fixed
> per-block capacity returned by ocfs2_refcount_recs_per_rb(), and
> reject rl_used > rl_count. Both checks are skipped when
> OCFS2_REFCOUNT_TREE_FL is set, because in that case the same union
> bytes hold an ocfs2_extent_list (rf_list), not the refcount record
> list (rf_records) -- that layout is already validated separately by
> ocfs2_validate_extent_block() when the referenced extent block is
> read. This mirrors the existing
> "!(rb->rf_flags & OCFS2_REFCOUNT_TREE_FL)" guard used elsewhere in
> this file (e.g. ocfs2_get_refcount_rec()) to decide whether
> rf_records or rf_list is the live member of the union.
> 
> With this in place, a forged rl_used/rl_count is caught at block
> validation time (ocfs2_error()), consistent with every other
> corruption check in this function, instead of driving an
> out-of-bounds read in ocfs2_find_refcount_rec_in_rl() and a
> subsequent out-of-bounds memmove() in ocfs2_insert_refcount_rec().
> 
> Verified against a crafted image on a v6.19 KASAN (KASAN_GENERIC)
> build: replaying the same reflink (FICLONE) reliably hit a KASAN
> report in __ocfs2_increase_refcount()/ocfs2_insert_refcount_rec()
> before this patch, and triggers no report once
> ocfs2_validate_refcount_block() rejects the forged rl_used/rl_count.
> 
> Fixes: f2c870e3b12e ("ocfs2: Add ocfs2_read_refcount_block.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ibrahim Hashimov <security@auditcode.ai>
> Assisted-by: AuditCode-AI:2026.07

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/refcounttree.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> index 7323bde70caa..63d6cb326e30 100644
> --- a/fs/ocfs2/refcounttree.c
> +++ b/fs/ocfs2/refcounttree.c
> @@ -116,6 +116,33 @@ static int ocfs2_validate_refcount_block(struct super_block *sb,
>  				 le32_to_cpu(rb->rf_fs_generation));
>  		goto out;
>  	}
> +
> +	/*
> +	 * rf_records (rl_count/rl_used/rl_recs[]) is only meaningful when
> +	 * this block is not an interior tree block (OCFS2_REFCOUNT_TREE_FL);
> +	 * in that case the same union bytes hold an extent list (rf_list)
> +	 * instead, which is validated by ocfs2_validate_extent_block().
> +	 */
> +	if (!(le32_to_cpu(rb->rf_flags) & OCFS2_REFCOUNT_TREE_FL)) {
> +		if (le16_to_cpu(rb->rf_records.rl_count) !=
> +		    ocfs2_refcount_recs_per_rb(sb)) {
> +			rc = ocfs2_error(sb,
> +					 "Refcount block #%llu has an invalid rl_count of %u\n",
> +					 (unsigned long long)bh->b_blocknr,
> +					 le16_to_cpu(rb->rf_records.rl_count));
> +			goto out;
> +		}
> +
> +		if (le16_to_cpu(rb->rf_records.rl_used) >
> +		    le16_to_cpu(rb->rf_records.rl_count)) {
> +			rc = ocfs2_error(sb,
> +					 "Refcount block #%llu has an invalid rl_used of %u (rl_count %u)\n",
> +					 (unsigned long long)bh->b_blocknr,
> +					 le16_to_cpu(rb->rf_records.rl_used),
> +					 le16_to_cpu(rb->rf_records.rl_count));
> +			goto out;
> +		}
> +	}
>  out:
>  	return rc;
>  }

