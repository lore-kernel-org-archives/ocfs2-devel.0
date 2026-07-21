Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E83C3E7BCA
	for <ocfs2-devel@lists.linux.dev>; Tue, 21 Jul 2026 11:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784634478; cv=none; b=XSlg1eZCrsoVEKpLipn6FNS3nBhIaW6mr9Qn4vRk+gnVAFdOKIqyKcmlWCkuv+6qbVN9sVpTKxCAvhCOn3rhS7/8pjzBI+Rj0XYxw2GyG3aAAQHB+Kor0wXhSFpNwfl2BBVFxhc8QUIz7Lh1s1o/DGwQ3g9ZC13lAYEJKmw8vkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784634478; c=relaxed/simple;
	bh=zW+ZmwwHEWU7Vg2vqRzSIQktmjhrt637emAFKqoR2cU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oPDbWe3+r8BYa4bWAGbjFqFokYQ21/C0q/hYF7Di2XsXUtRXuW1qPNwhrIjaUxkL3/mYJxu179QKR+C3hvPNd36ovuS0ylvEdPe65mQQ7HHKz2m4wYvE4dIYYm265zM4mFTefbzbO6fbnzFxxmsQPaKHUqD3tcBnw8FI7BgHTaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=W1je1zkp; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="W1je1zkp"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784634468; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=xOdH+PZwsf7SHwHBwXmBUeC/OOcSHm/V9TbkDIIfdMo=;
	b=W1je1zkpheGaTj9fGmPgxujZKm38Gd1syk0HOoSi4NCSersP1gBH0iYuQWMlnGUvL7IkRFnl3GeiQ9F+ckGsBQHTjU/VYxrKwqygMyaxGCrFrKT6uc7kz7AYx7wX+zkibiP++40ATwbjLl6Yr+wlsPZphSfMVH0gme6oULF7U1A=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R951e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X7a0KCX_1784634467;
Received: from 30.221.129.34(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X7a0KCX_1784634467 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 21 Jul 2026 19:47:48 +0800
Message-ID: <c300e7ac-b119-414d-af27-cd8ddfa705fd@linux.alibaba.com>
Date: Tue, 21 Jul 2026 19:47:47 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: always run deallocs on copy-on-write completion
To: Dmitry Antipov <dmantipov@yandex.ru>, akpm <akpm@linux-foundation.org>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org
References: <0b60eb13-564f-445f-9bcb-cd0a2a147af0@linux.alibaba.com>
 <20260721102840.387663-1-dmantipov@yandex.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260721102840.387663-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/21/26 6:28 PM, Dmitry Antipov wrote:
> Local fuzzing of 6.12.94 has found the following memory leak
> caused by doing 'copy_file_range()' within the same filesystem:
> 
> unreferenced object 0xffff88812192c980 (size 32):
>   comm "syz.0.49", pid 12095, jiffies 4294964143
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 08 00 00 00 00 00 00 00  ................
>     c0 c5 92 21 81 88 ff ff 00 02 00 00 00 06 00 00  ...!............
>   backtrace (crc 7068d63f):
>     kmemleak_alloc_recursive include/linux/kmemleak.h:42 [inline]
>     slab_post_alloc_hook mm/slub.c:4152 [inline]
>     slab_alloc_node mm/slub.c:4197 [inline]
>     __kmalloc_cache_noprof+0x168/0x2c0 mm/slub.c:4358
>     kmalloc_noprof include/linux/slab.h:878 [inline]
>     ocfs2_find_per_slot_free_list fs/ocfs2/alloc.c:6618 [inline]
>     ocfs2_cache_block_dealloc+0x155/0x4b0 fs/ocfs2/alloc.c:6786
>     ocfs2_cache_extent_block_free fs/ocfs2/alloc.c:6819 [inline]
>     ocfs2_unlink_path+0x286/0x450 fs/ocfs2/alloc.c:2613
>     ocfs2_rotate_subtree_left fs/ocfs2/alloc.c:2779 [inline]
>     __ocfs2_rotate_tree_left+0x1f6f/0x2da0 fs/ocfs2/alloc.c:2985
>     ocfs2_rotate_tree_left+0x283/0xe00 fs/ocfs2/alloc.c:3237
>     ocfs2_try_to_merge_extent+0xf56/0x1a20 fs/ocfs2/alloc.c:3825
>     ocfs2_split_extent+0x15f4/0x2940 fs/ocfs2/alloc.c:5138
>     ocfs2_clear_ext_refcount+0x2f6/0x550 fs/ocfs2/refcounttree.c:3098
>     ocfs2_replace_clusters fs/ocfs2/refcounttree.c:3131 [inline]
>     ocfs2_make_clusters_writable fs/ocfs2/refcounttree.c:3255 [inline]
>     ocfs2_replace_cow+0x991/0x1660 fs/ocfs2/refcounttree.c:3349
>     ocfs2_refcount_cow_hunk fs/ocfs2/refcounttree.c:3427 [inline]
>     ocfs2_refcount_cow+0x5e1/0x9f0 fs/ocfs2/refcounttree.c:3470
>     ocfs2_prepare_inode_for_write fs/ocfs2/file.c:2340 [inline]
>     ocfs2_file_write_iter+0xbda/0x1880 fs/ocfs2/file.c:2451
>     iter_file_splice_write+0x890/0xf60 fs/splice.c:743
>     do_splice_from fs/splice.c:944 [inline]
>     direct_splice_actor+0x232/0x480 fs/splice.c:1167
>     splice_direct_to_actor+0x4b4/0xb60 fs/splice.c:1111
>     do_splice_direct_actor fs/splice.c:1210 [inline]
>     do_splice_direct+0x10f/0x1c0 fs/splice.c:1236
>     do_sendfile+0x430/0xbf0 fs/read_write.c:1388
> 
> unreferenced object 0xffff88812192c5c0 (size 32):
>   comm "syz.0.49", pid 12095, jiffies 4294964143
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     29 70 00 00 00 00 00 00 19 00 00 00 00 00 00 00  )p..............
>   backtrace (crc afec850f):
>     kmemleak_alloc_recursive include/linux/kmemleak.h:42 [inline]
>     slab_post_alloc_hook mm/slub.c:4152 [inline]
>     slab_alloc_node mm/slub.c:4197 [inline]
>     __kmalloc_cache_noprof+0x168/0x2c0 mm/slub.c:4358
>     kmalloc_noprof include/linux/slab.h:878 [inline]
>     kzalloc_noprof include/linux/slab.h:1014 [inline]
>     ocfs2_cache_block_dealloc+0x25c/0x4b0 fs/ocfs2/alloc.c:6793
>     ocfs2_cache_extent_block_free fs/ocfs2/alloc.c:6819 [inline]
>     ocfs2_unlink_path+0x286/0x450 fs/ocfs2/alloc.c:2613
>     ocfs2_rotate_subtree_left fs/ocfs2/alloc.c:2779 [inline]
>     __ocfs2_rotate_tree_left+0x1f6f/0x2da0 fs/ocfs2/alloc.c:2985
>     ocfs2_rotate_tree_left+0x283/0xe00 fs/ocfs2/alloc.c:3237
>     ocfs2_try_to_merge_extent+0xf56/0x1a20 fs/ocfs2/alloc.c:3825
>     ocfs2_split_extent+0x15f4/0x2940 fs/ocfs2/alloc.c:5138
>     ocfs2_clear_ext_refcount+0x2f6/0x550 fs/ocfs2/refcounttree.c:3098
>     ocfs2_replace_clusters fs/ocfs2/refcounttree.c:3131 [inline]
>     ocfs2_make_clusters_writable fs/ocfs2/refcounttree.c:3255 [inline]
>     ocfs2_replace_cow+0x991/0x1660 fs/ocfs2/refcounttree.c:3349
>     ocfs2_refcount_cow_hunk fs/ocfs2/refcounttree.c:3427 [inline]
>     ocfs2_refcount_cow+0x5e1/0x9f0 fs/ocfs2/refcounttree.c:3470
>     ocfs2_prepare_inode_for_write fs/ocfs2/file.c:2340 [inline]
>     ocfs2_file_write_iter+0xbda/0x1880 fs/ocfs2/file.c:2451
>     iter_file_splice_write+0x890/0xf60 fs/splice.c:743
>     do_splice_from fs/splice.c:944 [inline]
>     direct_splice_actor+0x232/0x480 fs/splice.c:1167
>     splice_direct_to_actor+0x4b4/0xb60 fs/splice.c:1111
>     do_splice_direct_actor fs/splice.c:1210 [inline]
>     do_splice_direct+0x10f/0x1c0 fs/splice.c:1236
>     do_sendfile+0x430/0xbf0 fs/read_write.c:1388
> 
> This happens when 'ocfs2_cache_block_dealloc()' called from
> 'ocfs2_cache_extent_block_free()' uses the suballocator to
> schedule extent removal, so 'ocfs2_run_deallocs()' should
> be run unconditionally to complete the removal with
> 'ocfs2_free_cached_blocks()'. An extra semi-automated static
> analysis [1] suspects that the same scenario looks possible in
> 'ocfs2_attach_refcount_tree()' and 'ocfs2_reflink_remap_blocks()'
> as well, but, since 'ocfs2_run_deallocs()' is a safe no-op for
> an empty dealloc context, 'ocfs2_create_reflink_node()' and
> 'ocfs2_reflink_xattrs()' may be adjusted in the same way too,
> thus keeping the code pattern consistent.
> 
> [1] https://lore.kernel.org/ocfs2-devel/f1d7e266-4b44-41b9-98c0-5b3868a8d9c3@yandex.ru
> 
> Fixes: 6f70fa519976 ("ocfs2: Add CoW support.")
> Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/refcounttree.c | 20 ++++++++------------
>  fs/ocfs2/xattr.c        |  5 ++---
>  2 files changed, 10 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> index 7323bde70caa..b36f6143a0f6 100644
> --- a/fs/ocfs2/refcounttree.c
> +++ b/fs/ocfs2/refcounttree.c
> @@ -3360,10 +3360,9 @@ static int ocfs2_replace_cow(struct ocfs2_cow_context *context)
>  		cow_start += num_clusters;
>  	}
>  
> -	if (ocfs2_dealloc_has_cluster(&context->dealloc)) {
> +	if (ocfs2_dealloc_has_cluster(&context->dealloc))
>  		ocfs2_schedule_truncate_log_flush(osb, 1);
> -		ocfs2_run_deallocs(osb, &context->dealloc);
> -	}
> +	ocfs2_run_deallocs(osb, &context->dealloc);
>  
>  	return ret;
>  }
> @@ -3846,10 +3845,9 @@ static int ocfs2_attach_refcount_tree(struct inode *inode,
>  	ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
>  	brelse(ref_root_bh);
>  
> -	if (!ret && ocfs2_dealloc_has_cluster(&dealloc)) {
> +	if (!ret && ocfs2_dealloc_has_cluster(&dealloc))
>  		ocfs2_schedule_truncate_log_flush(osb, 1);
> -		ocfs2_run_deallocs(osb, &dealloc);
> -	}
> +	ocfs2_run_deallocs(osb, &dealloc);
>  out:
>  	/*
>  	 * Empty the extent map so that we may get the right extent
> @@ -4135,10 +4133,9 @@ static int ocfs2_create_reflink_node(struct inode *s_inode,
>  	ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
>  	brelse(ref_root_bh);
>  out:
> -	if (ocfs2_dealloc_has_cluster(&dealloc)) {
> +	if (ocfs2_dealloc_has_cluster(&dealloc))
>  		ocfs2_schedule_truncate_log_flush(osb, 1);
> -		ocfs2_run_deallocs(osb, &dealloc);
> -	}
> +	ocfs2_run_deallocs(osb, &dealloc);
>  
>  	return ret;
>  }
> @@ -4691,10 +4688,9 @@ loff_t ocfs2_reflink_remap_blocks(struct inode *s_inode,
>  	}
>  
>  out:
> -	if (ocfs2_dealloc_has_cluster(&dealloc)) {
> +	if (ocfs2_dealloc_has_cluster(&dealloc))
>  		ocfs2_schedule_truncate_log_flush(osb, 1);
> -		ocfs2_run_deallocs(osb, &dealloc);
> -	}
> +	ocfs2_run_deallocs(osb, &dealloc);
>  
>  	return ret;
>  }
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index fcddd3c13acd..412e647334ad 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -7235,10 +7235,9 @@ int ocfs2_reflink_xattrs(struct inode *old_inode,
>  				   ref_tree, 1);
>  	brelse(ref_root_bh);
>  
> -	if (ocfs2_dealloc_has_cluster(&dealloc)) {
> +	if (ocfs2_dealloc_has_cluster(&dealloc))
>  		ocfs2_schedule_truncate_log_flush(OCFS2_SB(old_inode->i_sb), 1);
> -		ocfs2_run_deallocs(OCFS2_SB(old_inode->i_sb), &dealloc);
> -	}
> +	ocfs2_run_deallocs(OCFS2_SB(old_inode->i_sb), &dealloc);
>  
>  out:
>  	return ret;

