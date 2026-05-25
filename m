Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E1E34EF04
	for <ocfs2-devel@lists.linux.dev>; Mon, 25 May 2026 05:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779687881; cv=none; b=q4zcZzADq433hgKV86WF6uUFfpUGnKIDj++Nw7nG8dAOlKpRmacw5zBkELOElwU8bv79WlR07iaNkFt6CpISD4rQKi/fzSbxl35rr4hIjw01DQ+/G8D096lW/MuacFJMPOYKsFYR0t8Wpi7z+M8lv/5xOCFJsNebSMTFgkpQsk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779687881; c=relaxed/simple;
	bh=grK57SHW4J6DlymaM8CLnpfBYfNJOjKcqvcS7tn3NS0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JyrkGnEQWqORTChImgyibz5wKwwpWerOxDK9PAS/KoAdvO62/92WOcjGvGUKCpQlKRpqYFsLexyFnna61zAZutJe+QcRT7+tYIDj0M9T3kEfjeXKWbpUvv0Q5/lHJjxCd54yWXUaIjY0BFf/WdNG8Q6DlI3Hdc9dJbKKRCgjCJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=meu+LEyS; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="meu+LEyS"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779687873; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=E1qk2n7eUow0Eea8wxM+QqN6ckHRRzQ34cw8b8+nmks=;
	b=meu+LEySFM84TLtZY/QctO9Go4Xhainqbbrx/oDMd1LfaqamlEzT2uHOaHHAJmvdgVAz8kjE55+8p/uJ6ndXKOEnpwEeLGuyxst4+NKrJb+CyaLYCeCUq25oI8amLHnAZL7465K24Gv2js8xFGdMtczNereMZtd6uQJ5GeO3uNQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X3UG9yy_1779687872;
Received: from 30.221.145.59(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X3UG9yy_1779687872 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 25 May 2026 13:44:32 +0800
Message-ID: <bb8e479c-6f7c-4c95-b063-1bf0fa4d9673@linux.alibaba.com>
Date: Mon, 25 May 2026 13:44:31 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: reject oversized group bitmap descriptors
To: Zhang Cen <rollkingzzc@gmail.com>
Cc: ocfs2-devel@lists.linux.dev, zerocling0077@gmail.com,
 2045gemini@gmail.com, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>
References: <20260525043547.4160868-1-rollkingzzc@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260525043547.4160868-1-rollkingzzc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/25/26 12:35 PM, Zhang Cen wrote:
> ocfs2_validate_gd_parent() only bounds bg_bits against the parent
> allocator's chain geometry. A malicious descriptor can still claim a
> bg_size/bg_bits pair that exceeds the bitmap bytes that physically fit in
> the group descriptor block, so later bitmap scans and bit updates can run
> past bg_bitmap.
> 
> Use ocfs2_group_bitmap_size() for the allocator inode's bitmap layout and
> reject descriptors whose bg_size or bg_bits exceed that capacity. Keep the
> existing chain geometry check so both the on-disk bitmap layout and the
> allocator metadata must agree before the descriptor is used.
> 
> Validation reproduced this kernel report:
> KASAN use-after-free in _find_next_bit+0x7f/0xc0
> Read of size 8
> Call trace:
>   dump_stack_lvl+0x66/0xa0
>   print_report+0xd0/0x630
>   _find_next_bit+0x7f/0xc0
>   srso_alias_return_thunk+0x5/0xfbef5
>   __virt_addr_valid+0x188/0x2f0
>   kasan_report+0xe4/0x120
>   ocfs2_find_max_contig_free_bits+0x35/0x70 (fs/ocfs2/suballoc.c:1375)
>   ocfs2_block_group_set_bits+0x472/0x4b0 (fs/ocfs2/suballoc.c:1457)
>   ocfs2_cluster_group_search+0x16b/0x440 (fs/ocfs2/suballoc.c:1624)
>   ocfs2_bg_discontig_fix_result+0x1ef/0x230 (fs/ocfs2/suballoc.c:1786)
>   ocfs2_search_chain+0x8f8/0x10a0 (fs/ocfs2/suballoc.c:1886)
>   get_page_from_freelist+0x70e/0x2370
>   lock_release+0xc6/0x290
>   do_raw_spin_unlock+0x9a/0x100
>   kasan_unpoison+0x27/0x60
>   __bfs+0x147/0x240
>   get_page_from_freelist+0x83d/0x2370
>   ocfs2_claim_suballoc_bits+0x38c/0xe70 (fs/ocfs2/suballoc.c:2041)
>   sched_domains_numa_masks_clear+0x70/0xd0
>   check_irq_usage+0xe8/0xb70
>   __ocfs2_claim_clusters+0x18d/0x4c0 (fs/ocfs2/suballoc.c:2497)
>   check_path+0x24/0x50
>   rcu_is_watching+0x20/0x50
>   check_prev_add+0xfd/0xd00
>   ocfs2_add_clusters_in_btree+0x17d/0x810 (fs/ocfs2/alloc.c:4793)
>   __folio_batch_add_and_move+0x1f5/0x3d0
>   ocfs2_add_inode_data+0xd9/0x120 (fs/ocfs2/file.c:537)
>   filemap_add_folio+0x105/0x1f0
>   ocfs2_write_begin_nolock+0x29f7/0x2f80 (fs/ocfs2/aops.c:1625)
>   ocfs2_read_inode_block+0xb5/0x110 (fs/ocfs2/inode.c:1757)
>   down_write+0xf5/0x180
>   ocfs2_write_begin+0x180/0x240 (fs/ocfs2/aops.c:1861)
>   __mark_inode_dirty+0x758/0x9a0
>   inode_to_bdi+0x41/0x90
>   balance_dirty_pages_ratelimited_flags+0xf8/0x1d0
>   generic_perform_write+0x252/0x440
>   mnt_put_write_access_file+0x16/0x70
>   file_update_time_flags+0xe4/0x200
>   ocfs2_file_write_iter+0x80a/0x1320 (fs/ocfs2/file.c:2372)
>   lock_acquire+0x184/0x2f0
>   ksys_write+0xd2/0x170
>   apparmor_file_permission+0xf5/0x310
>   read_zero+0x8d/0x140
>   lock_is_held_type+0x8f/0x100
> 
> Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
> Assisted-by: Codex:gpt-5.5
> Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
> ---
> v2:
> Use !ocfs2_is_cluster_bitmap() to choose the allocator bitmap layout, as
> suggested by Joseph Qi.
> Pass the allocator inode through the resize descriptor check so the helper
> is used there too.
> 

Oh, my fault. Unnoticed it has to use 'inode' as input parameter.
So it seems we don't have to touch ocfs2_check_group_descriptor() prototype
int this fix. So I'll prefer the former version.

Thanks,
Joseph

>  fs/ocfs2/resize.c   |  2 +-
>  fs/ocfs2/suballoc.c | 33 ++++++++++++++++++++++++++++-----
>  fs/ocfs2/suballoc.h |  2 +-
>  3 files changed, 30 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
> index 6375d5035972..2432c9670f30 100644
> --- a/fs/ocfs2/resize.c
> +++ b/fs/ocfs2/resize.c
> @@ -388,7 +388,7 @@ static int ocfs2_check_new_group(struct inode *inode,
>  		(struct ocfs2_group_desc *)group_bh->b_data;
>  	u16 cl_bpc = le16_to_cpu(di->id2.i_chain.cl_bpc);
>  
> -	ret = ocfs2_check_group_descriptor(inode->i_sb, di, group_bh);
> +	ret = ocfs2_check_group_descriptor(inode, di, group_bh);
>  	if (ret)
>  		goto out;
>  
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index d284e0e37252..8b106bb4fe95 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -225,14 +225,22 @@ static int ocfs2_validate_gd_self(struct super_block *sb,
>  	return 0;
>  }
>  
> -static int ocfs2_validate_gd_parent(struct super_block *sb,
> +static int ocfs2_validate_gd_parent(struct inode *inode,
>  				    struct ocfs2_dinode *di,
>  				    struct buffer_head *bh,
>  				    int resize)
>  {
> +	struct super_block *sb = inode->i_sb;
>  	unsigned int max_bits;
> +	unsigned int max_bitmap_bits;
> +	unsigned int max_bitmap_size;
>  	struct ocfs2_group_desc *gd = (struct ocfs2_group_desc *)bh->b_data;
>  
> +	max_bitmap_size = ocfs2_group_bitmap_size(sb,
> +						  !ocfs2_is_cluster_bitmap(inode),
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
> @@ -266,11 +288,12 @@ static int ocfs2_validate_gd_parent(struct super_block *sb,
>   * This version only prints errors.  It does not fail the filesystem, and
>   * exists only for resize.
>   */
> -int ocfs2_check_group_descriptor(struct super_block *sb,
> +int ocfs2_check_group_descriptor(struct inode *inode,
>  				 struct ocfs2_dinode *di,
>  				 struct buffer_head *bh)
>  {
>  	int rc;
> +	struct super_block *sb = inode->i_sb;
>  	struct ocfs2_group_desc *gd = (struct ocfs2_group_desc *)bh->b_data;
>  
>  	BUG_ON(!buffer_uptodate(bh));
> @@ -288,7 +311,7 @@ int ocfs2_check_group_descriptor(struct super_block *sb,
>  	} else
>  		rc = ocfs2_validate_gd_self(sb, bh, 1);
>  	if (!rc)
> -		rc = ocfs2_validate_gd_parent(sb, di, bh, 1);
> +		rc = ocfs2_validate_gd_parent(inode, di, bh, 1);
>  
>  	return rc;
>  }
> @@ -372,7 +395,7 @@ static int ocfs2_read_hint_group_descriptor(struct inode *inode,
>  			goto free_bh;
>  	}
>  
> -	rc = ocfs2_validate_gd_parent(inode->i_sb, di, tmp, 0);
> +	rc = ocfs2_validate_gd_parent(inode, di, tmp, 0);
>  	if (rc)
>  		goto free_bh;
>  
> @@ -399,7 +422,7 @@ int ocfs2_read_group_descriptor(struct inode *inode, struct ocfs2_dinode *di,
>  	if (rc)
>  		goto out;
>  
> -	rc = ocfs2_validate_gd_parent(inode->i_sb, di, tmp, 0);
> +	rc = ocfs2_validate_gd_parent(inode, di, tmp, 0);
>  	if (rc) {
>  		brelse(tmp);
>  		goto out;
> diff --git a/fs/ocfs2/suballoc.h b/fs/ocfs2/suballoc.h
> index bcf2ed4a8631..b6ce3c6aa4a2 100644
> --- a/fs/ocfs2/suballoc.h
> +++ b/fs/ocfs2/suballoc.h
> @@ -188,7 +188,7 @@ u64 ocfs2_which_cluster_group(struct inode *inode, u32 cluster);
>   * and then checking it with this function.  This is only resize, really.
>   * Everyone else should be using ocfs2_read_group_descriptor().
>   */
> -int ocfs2_check_group_descriptor(struct super_block *sb,
> +int ocfs2_check_group_descriptor(struct inode *inode,
>  				 struct ocfs2_dinode *di,
>  				 struct buffer_head *bh);
>  /*

