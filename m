Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58723134CF
	for <ocfs2-devel@lists.linux.dev>; Mon, 20 Jul 2026 02:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784515640; cv=none; b=Va09qFKz6+Axqj/EFdouXewqpuSnzLj1T6/kXwxq2Fbvq0FwUKq95YkJ3H4saMRo//GFPQJhHQ0iYy9rA9dSqm3FT1DUzshZUZFifEyuxrj2mumWIirePFh6JCcUOfRr7JjQjofF5G5j2go83n0DIGoyhldOrEqRyJAzpGiP6Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784515640; c=relaxed/simple;
	bh=hNIRl+3aX/vBT9zD08DhIk34w9eWEGDq6tADaDcI8/k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oPq1OqtxxkEEmhpfKmdv0D0EDcDTL7fbhzXkRmUb2FY95vqbbAj3Enn8W8s6KLZIZo4xSx+c3v4/tm4ANJu+K41ubRuuAdsOljds+wEK0HVtKQIvHlLoDA5lWOPXrxsNiYAn1kN0wvJ73uTNuHtaZpoQVZKEkAM5v091LhsKuiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=c+OEFYxq; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="c+OEFYxq"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784515629; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=e5LOcmX7xKjMVM12F6UNulCpTZdxcjkBqRkDZ93KUDs=;
	b=c+OEFYxqmHDv8VgwwAYeL0VKBu52gQcoR5gibbsKa4/xmRnIePg/PjFrPnWVCJ4mb5ejIzpAGxOpVbOvfSX2r2AMkm3RYdF4GUhofb0djCTEb7WBzQIsvpmnWuhFOxjdbyaq/4N6RRzRA5LIpR4fimhfIdIhQ+FAfMgDd8QQpKQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R281e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X7NGMCB_1784515626;
Received: from 30.166.0.112(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X7NGMCB_1784515626 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 20 Jul 2026 10:47:07 +0800
Message-ID: <96c6f014-8e3e-464a-9ce2-bfa910f1edc1@linux.alibaba.com>
Date: Mon, 20 Jul 2026 10:47:06 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Memory leak in ocfs2_unlink_path()
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@lists.linux.dev
References: <a1e86cd9-847b-4f3c-9bbb-d803fe3bd022@yandex.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <a1e86cd9-847b-4f3c-9bbb-d803fe3bd022@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 7/15/26 10:20 PM, Dmitry Antipov wrote:
> Local fuzzing of 6.12.94 has found the following memory leak
> caused by doing copy_file_range(2) within the same filesystem:
> 
> unreferenced object 0xffff88812192c980 (size 32):
>   comm "syz.0.49", pid 12095, jiffies 4294964143
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 08 00 00 00 00 00 00 00  ................
>     c0 c5 92 21 81 88 ff ff 00 02 00 00 00 06 00 00  ...!............
>   backtrace (crc 7068d63f):
>     kmemleak_alloc_recursive include/linux/kmemleak.h:42 [inline]
>     slab_post_alloc_hook mm/slub.c:4152 [inline]
>     slab_alloc_node mm/slub.c:4197 [inline]
>     __kmalloc_cache_noprof+0x168/0x2c0 mm/slub.c:4358
>     kmalloc_noprof include/linux/slab.h:878 [inline]
>     ocfs2_find_per_slot_free_list fs/ocfs2/alloc.c:6618 [inline]
>     ocfs2_cache_block_dealloc+0x155/0x4b0 fs/ocfs2/alloc.c:6786
>     ocfs2_cache_extent_block_free fs/ocfs2/alloc.c:6819 [inline]
>     ocfs2_unlink_path+0x286/0x450 fs/ocfs2/alloc.c:2613
>     ocfs2_rotate_subtree_left fs/ocfs2/alloc.c:2779 [inline]
>     __ocfs2_rotate_tree_left+0x1f6f/0x2da0 fs/ocfs2/alloc.c:2985
>     ocfs2_rotate_tree_left+0x283/0xe00 fs/ocfs2/alloc.c:3237
>     ocfs2_try_to_merge_extent+0xf56/0x1a20 fs/ocfs2/alloc.c:3825
>     ocfs2_split_extent+0x15f4/0x2940 fs/ocfs2/alloc.c:5138
>     ocfs2_clear_ext_refcount+0x2f6/0x550 fs/ocfs2/refcounttree.c:3098
>     ocfs2_replace_clusters fs/ocfs2/refcounttree.c:3131 [inline]
>     ocfs2_make_clusters_writable fs/ocfs2/refcounttree.c:3255 [inline]
>     ocfs2_replace_cow+0x991/0x1660 fs/ocfs2/refcounttree.c:3349
>     ocfs2_refcount_cow_hunk fs/ocfs2/refcounttree.c:3427 [inline]
>     ocfs2_refcount_cow+0x5e1/0x9f0 fs/ocfs2/refcounttree.c:3470
>     ocfs2_prepare_inode_for_write fs/ocfs2/file.c:2340 [inline]
>     ocfs2_file_write_iter+0xbda/0x1880 fs/ocfs2/file.c:2451
>     iter_file_splice_write+0x890/0xf60 fs/splice.c:743
>     do_splice_from fs/splice.c:944 [inline]
>     direct_splice_actor+0x232/0x480 fs/splice.c:1167
>     splice_direct_to_actor+0x4b4/0xb60 fs/splice.c:1111
>     do_splice_direct_actor fs/splice.c:1210 [inline]
>     do_splice_direct+0x10f/0x1c0 fs/splice.c:1236
>     do_sendfile+0x430/0xbf0 fs/read_write.c:1388
> 
> unreferenced object 0xffff88812192c5c0 (size 32):
>   comm "syz.0.49", pid 12095, jiffies 4294964143
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     29 70 00 00 00 00 00 00 19 00 00 00 00 00 00 00  )p..............
>   backtrace (crc afec850f):
>     kmemleak_alloc_recursive include/linux/kmemleak.h:42 [inline]
>     slab_post_alloc_hook mm/slub.c:4152 [inline]
>     slab_alloc_node mm/slub.c:4197 [inline]
>     __kmalloc_cache_noprof+0x168/0x2c0 mm/slub.c:4358
>     kmalloc_noprof include/linux/slab.h:878 [inline]
>     kzalloc_noprof include/linux/slab.h:1014 [inline]
>     ocfs2_cache_block_dealloc+0x25c/0x4b0 fs/ocfs2/alloc.c:6793
>     ocfs2_cache_extent_block_free fs/ocfs2/alloc.c:6819 [inline]
>     ocfs2_unlink_path+0x286/0x450 fs/ocfs2/alloc.c:2613
>     ocfs2_rotate_subtree_left fs/ocfs2/alloc.c:2779 [inline]
>     __ocfs2_rotate_tree_left+0x1f6f/0x2da0 fs/ocfs2/alloc.c:2985
>     ocfs2_rotate_tree_left+0x283/0xe00 fs/ocfs2/alloc.c:3237
>     ocfs2_try_to_merge_extent+0xf56/0x1a20 fs/ocfs2/alloc.c:3825
>     ocfs2_split_extent+0x15f4/0x2940 fs/ocfs2/alloc.c:5138
>     ocfs2_clear_ext_refcount+0x2f6/0x550 fs/ocfs2/refcounttree.c:3098
>     ocfs2_replace_clusters fs/ocfs2/refcounttree.c:3131 [inline]
>     ocfs2_make_clusters_writable fs/ocfs2/refcounttree.c:3255 [inline]
>     ocfs2_replace_cow+0x991/0x1660 fs/ocfs2/refcounttree.c:3349
>     ocfs2_refcount_cow_hunk fs/ocfs2/refcounttree.c:3427 [inline]
>     ocfs2_refcount_cow+0x5e1/0x9f0 fs/ocfs2/refcounttree.c:3470
>     ocfs2_prepare_inode_for_write fs/ocfs2/file.c:2340 [inline]
>     ocfs2_file_write_iter+0xbda/0x1880 fs/ocfs2/file.c:2451
>     iter_file_splice_write+0x890/0xf60 fs/splice.c:743
>     do_splice_from fs/splice.c:944 [inline]
>     direct_splice_actor+0x232/0x480 fs/splice.c:1167
>     splice_direct_to_actor+0x4b4/0xb60 fs/splice.c:1111
>     do_splice_direct_actor fs/splice.c:1210 [inline]
>     do_splice_direct+0x10f/0x1c0 fs/splice.c:1236
>     do_sendfile+0x430/0xbf0 fs/read_write.c:1388
> 
> This happens when 'ocfs2_replace_cow()' ends with NULL 'c_global_allocator'
> but non-NULL 'c_first_suballocator' of 'struct ocfs2_cached_dealloc_ctxt'
> involved, so ocfs2_run_deallocs() is never run due to:
> 
>     if (ocfs2_dealloc_has_cluster(&context->dealloc)) {
>             ocfs2_schedule_truncate_log_flush(osb, 1);
>             ocfs2_run_deallocs(osb, &context->dealloc);
>     }
> 
> An obvious fix is to run 'ocfs2_run_deallocs()' unconditionally, but
> 1) I have no clue why it is so and 2) I have strong suspection that the
> whole picture may be different when doing the same with clustered mount.
> 

Yes, when ocfs2_cache_extent_block_free() -> ocfs2_cache_block_dealloc(),
entries are added to c_first_suballocator.
So it seems run ocfs2_run_deallocs() unconditionally is right.
In ocfs2_xattr_set(), it seems use the correct pattern.

Thanks,
Joseph

> To whom it may be interesting, there is no working C repro but ~350K
> .syz blob [1] that has to be run via syz-execprog directly.
> 
> [1] https://drive.google.com/file/d/1t6DOstv77QVSr76pAsP_dW7nPd10dlhU/view?usp=drive_link
> 
> Dmitry

