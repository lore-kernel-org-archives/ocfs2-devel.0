Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A9D313532
	for <ocfs2-devel@lists.linux.dev>; Mon, 25 May 2026 05:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779687918; cv=none; b=s5BZ1/W9ccMfH13gj0jqhhyaAOUeluX8Dm3QGygnuT7TFaX2GiMTxtwsxYsng2ZyeenN+XyoO2xQLCfABpZW/vKzeccE4MJ6590xYAfRiP1kJpuYjt2ar/TIQI8WQXu1IsdNpgfkSJBZ2VOeG13d4XroNdJaH6zr+L7dQVzCCQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779687918; c=relaxed/simple;
	bh=S/6vZRJDGzgPPIvo/TjZ1T5H+rdkpYx3y7MOy9+fg6Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uJtBBJCnhBe8lYKzWrGKIpmRpL5nvSCTy2DiEGFy+hiOJ5qSohexwGlU9fboroEZfKEovRLRjuOjlALEOMo5XOtD28E7roQhE92JWXPEl2VwKS1UZTTFeZKgC9/lA9IeF0ok20AdXUQ8S/0gPVQC8RGlQpIrF5wK0da7et1+2JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=mZ26b7ro; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="mZ26b7ro"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779687911; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=VxP4o03gtpPckW44F5iK/tM4D/HmTfaWxls6Vy4ix1U=;
	b=mZ26b7roMKRfHYeyETvSQ1b8MBqwbf1Hx93CmEMpmMlXjMlG7GWaIzR14xo1RxYh16DoLsZw1uzpvEToY6v+g5LkwLftJ/Smv7bJWEdzsltuWiwRNA1QvFBBKlMR6AWCGVFfp2Zl2J7usnIIfz9AJSI+fuI0AzYJyVUsxMlEWzE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X3UGA5Q_1779687910;
Received: from 30.221.145.59(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X3UGA5Q_1779687910 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 25 May 2026 13:45:10 +0800
Message-ID: <aa14bbc3-8be6-41be-811b-7de3e118f36d@linux.alibaba.com>
Date: Mon, 25 May 2026 13:45:10 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: reject oversized group bitmap descriptors
To: Zhang Cen <rollkingzzc@gmail.com>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, zerocling0077@gmail.com,
 2045gemini@gmail.com, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>
References: <20260524111248.1429884-1-rollkingzzc@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260524111248.1429884-1-rollkingzzc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/24/26 7:12 PM, Zhang Cen wrote:
> ocfs2_validate_gd_parent() only bounds bg_bits against the parent
> allocator's chain geometry. A malicious descriptor can still claim a
> bg_size/bg_bits pair that exceeds the bitmap bytes that physically fit in
> the group descriptor block, so later bitmap scans and bit updates can run
> past bg_bitmap.
> 
> Add a physical-cap check based on ocfs2_group_bitmap_size() for the
> parent allocator type and reject descriptors whose bg_size or bg_bits
> exceed that capacity. Keep the existing chain geometry check so both the
> on-disk bitmap layout and the allocator metadata must agree before the
> descriptor is used.
> 
> Validation reproduced this kernel report:
> KASAN use-after-free in _find_next_bit+0x7f/0xc0
> Read of size 8
> Call trace:
>   dump_stack_lvl+0x66/0xa0 (?:?)
>   print_report+0xd0/0x630 (?:?)
>   _find_next_bit+0x7f/0xc0 (?:?)
>   srso_alias_return_thunk+0x5/0xfbef5 (?:?)
>   __virt_addr_valid+0x188/0x2f0 (?:?)
>   kasan_report+0xe4/0x120 (?:?)
>   ocfs2_find_max_contig_free_bits+0x35/0x70 (fs/ocfs2/suballoc.c:1375)
>   ocfs2_block_group_set_bits+0x472/0x4b0 (fs/ocfs2/suballoc.c:1457)
>   ocfs2_cluster_group_search+0x16b/0x440 (fs/ocfs2/suballoc.c:86)
>   ocfs2_bg_discontig_fix_result+0x1ef/0x230 (fs/ocfs2/suballoc.c:1786)
>   ocfs2_search_chain+0x8f8/0x10a0 (fs/ocfs2/suballoc.c:1886)
>   get_page_from_freelist+0x70e/0x2370 (?:?)
>   lock_release+0xc6/0x290 (?:?)
>   do_raw_spin_unlock+0x9a/0x100 (?:?)
>   kasan_unpoison+0x27/0x60 (?:?)
>   __bfs+0x147/0x240 (?:?)
>   get_page_from_freelist+0x83d/0x2370 (?:?)
>   ocfs2_claim_suballoc_bits+0x38c/0xe70 (fs/ocfs2/suballoc.c:96)
>   sched_domains_numa_masks_clear+0x70/0xd0 (?:?)
>   check_irq_usage+0xe8/0xb70 (?:?)
>   __ocfs2_claim_clusters+0x18d/0x4c0 (fs/ocfs2/suballoc.c:2497)
>   check_path+0x24/0x50 (?:?)
>   rcu_is_watching+0x20/0x50 (?:?)
>   check_prev_add+0xfd/0xd00 (?:?)
>   ocfs2_add_clusters_in_btree+0x17d/0x810 (fs/ocfs2/suballoc.c:?)
>   __folio_batch_add_and_move+0x1f5/0x3d0 (?:?)
>   ocfs2_add_inode_data+0xd9/0x120 (fs/ocfs2/suballoc.c:?)
>   filemap_add_folio+0x105/0x1f0 (?:?)
>   ocfs2_write_begin_nolock+0x29f7/0x2f80 (fs/ocfs2/suballoc.c:3043)
>   ocfs2_read_inode_block+0xb5/0x110 (fs/ocfs2/suballoc.c:?)
>   down_write+0xf5/0x180 (?:?)
>   ocfs2_write_begin+0x180/0x240 (fs/ocfs2/suballoc.c:?)
>   __mark_inode_dirty+0x758/0x9a0 (?:?)
>   inode_to_bdi+0x41/0x90 (?:?)
>   balance_dirty_pages_ratelimited_flags+0xf8/0x1d0 (?:?)
>   generic_perform_write+0x252/0x440 (?:?)
>   mnt_put_write_access_file+0x16/0x70 (?:?)
>   file_update_time_flags+0xe4/0x200 (?:?)
>   ocfs2_file_write_iter+0x80a/0x1320 (fs/ocfs2/suballoc.c:?)
>   lock_acquire+0x184/0x2f0 (?:?)
>   ksys_write+0xd2/0x170 (?:?)
>   apparmor_file_permission+0xf5/0x310 (?:?)
>   read_zero+0x8d/0x140 (?:?)
>   lock_is_held_type+0x8f/0x100 (?:?)
> 
> Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
> Assisted-by: Codex:gpt-5.5
> Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/suballoc.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index d284e0e37252..a4a2b87a45fe 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -231,8 +231,16 @@ static int ocfs2_validate_gd_parent(struct super_block *sb,
>  				    int resize)
>  {
>  	unsigned int max_bits;
> +	unsigned int max_bitmap_bits;
> +	unsigned int max_bitmap_size;
> +	int suballocator;
>  	struct ocfs2_group_desc *gd = (struct ocfs2_group_desc *)bh->b_data;
>  
> +	suballocator = le64_to_cpu(di->i_blkno) != OCFS2_SB(sb)->bitmap_blkno;
> +	max_bitmap_size = ocfs2_group_bitmap_size(sb, suballocator,
> +						  OCFS2_SB(sb)->s_feature_incompat);
> +	max_bitmap_bits = max_bitmap_size * 8;
> +
>  	if (di->i_blkno != gd->bg_parent_dinode) {
>  		do_error("Group descriptor #%llu has bad parent pointer (%llu, expected %llu)\n",
>  			 (unsigned long long)bh->b_blocknr,
> @@ -240,6 +248,20 @@ static int ocfs2_validate_gd_parent(struct super_block *sb,
>  			 (unsigned long long)le64_to_cpu(di->i_blkno));
>  	}
>  
> +	if (le16_to_cpu(gd->bg_size) > max_bitmap_size) {
> +		do_error("Group descriptor #%llu has bitmap size %u but physical max of %u\n",
> +			 (unsigned long long)bh->b_blocknr,
> +			 le16_to_cpu(gd->bg_size),
> +			 max_bitmap_size);
> +	}
> +
> +	if (le16_to_cpu(gd->bg_bits) > max_bitmap_bits) {
> +		do_error("Group descriptor #%llu has bit count %u but physical max of %u\n",
> +			 (unsigned long long)bh->b_blocknr,
> +			 le16_to_cpu(gd->bg_bits),
> +			 max_bitmap_bits);
> +	}
> +
>  	max_bits = le16_to_cpu(di->id2.i_chain.cl_cpg) * le16_to_cpu(di->id2.i_chain.cl_bpc);
>  	if (le16_to_cpu(gd->bg_bits) > max_bits) {
>  		do_error("Group descriptor #%llu has bit count of %u\n",

