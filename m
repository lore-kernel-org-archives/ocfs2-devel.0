Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E4A3EF658
	for <ocfs2-devel@lists.linux.dev>; Tue, 21 Jul 2026 01:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784597716; cv=none; b=PmMB5rm5QPQ4Rj0ixXLBvii2giCqju8ZN6KJDQy85VUOWCDCJO2j3Ebof/iZV/YUZhe5scninCB26HT90n7zf+4B9p6orxlV/Jlq5HjI4K+9P+ZWvbV0hBeJaegGSnI/xRVLitjdrZyiM+LCjJLyWfvSW4n4wg8zUnPjExialD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784597716; c=relaxed/simple;
	bh=mSppD302R5mI0hEwlz/wjT0oDv4lhU817kwyylG/sEc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YDhiOlJ6gOUEvCb+AuUGnhKQ4VsjLnKw52oXhwxCCxNU7q6ekg8nG/5+3BsGxdLmzTB0PUWe/OhJqgh7nNqRwVwlmQ84QclrooG16srr2UButx9r7qrqCbvSV9txds+qVdF2yxfQdb6O7D+3toQLoURoMFW376+gnn0SCrTh6fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=TJLdLzqU; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="TJLdLzqU"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784597704; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=aSMwElfZTzA8CWfKXo54o3eJx0WUCAraADGCJkl7+ec=;
	b=TJLdLzqUdJKQSWh3r4tdpeaH4D3rddLQJOhETP2hnV/5uUKZRRQZPaydcqiNoaL9Zh6D8ZAAtTvPxe9zDfjwYcnX33baurPuy/71dfQFLSbrKxxS9DfdzvBUqpLZladcAWUp8HLmaRiUEsQdOVVI3gq87oHoGVNsATUjj3tA+zk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R981e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X7Y0Y98_1784597703;
Received: from 30.221.129.34(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X7Y0Y98_1784597703 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 21 Jul 2026 09:35:03 +0800
Message-ID: <9b036404-0863-420a-9cf4-1cc33d506cd9@linux.alibaba.com>
Date: Tue, 21 Jul 2026 09:35:02 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: always run deallocs on copy-on-write completion
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org
References: <20260720113957.58219-1-dmantipov@yandex.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260720113957.58219-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/20/26 7:39 PM, Dmitry Antipov wrote:
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
> 'ocfs2_free_cached_blocks()'.
> 

The identical idiom also exists in other places:
  ocfs2_attach_refcount_tree
  ocfs2_create_reflink_node
  ocfs2_reflink_remap_blocks
  ocfs2_reflink_xattrs

So please check if it will leak the same way. If so, please apply the
same changes as well.

Thanks,
Joseph

> Fixes: 6f70fa519976 ("ocfs2: Add CoW support.")
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> ---
>  fs/ocfs2/refcounttree.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> index 7323bde70caa..e659313a7383 100644
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

