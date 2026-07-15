Received: from forward103b.mail.yandex.net (forward103b.mail.yandex.net [178.154.239.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D4A2FF672
	for <ocfs2-devel@lists.linux.dev>; Wed, 15 Jul 2026 14:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784125369; cv=none; b=BC1Mae7TiBC/udnSTTjw2LlnUdgpkgiHhlq8j+BDMNPiQI76YqBQT7CI9V7d0H99E0VRgOL6vMijAZ32h0s4oxNN8SyB6W+sQumauPsyB7GbwsrILhGFoHpTNAfrO9ocKXE4nRew0L/QuwwZ5ZzsORdoA0KXAPfQ6ib0eepUMXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784125369; c=relaxed/simple;
	bh=ekTqoJeSjlVq+frmjaCfm5hE5LlHLgHtkZW28Tt/mAk=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=ESzjpekPNpZsvQc4fMRuYYqDtyX4okQVsfa/++LaCX9ttqkydd/txwGNdwOLUZaam0jmxKLIzke12wpeL4+8YuLdpmnsaJ4h4v+CtCSmT8BJTX9TwbhCR0Ez6J++HKDyZ40tTji/YR+VwyEiC/Nf/SBQKKQGKS660i2E0ZQ/CVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=ittlQ16M; arc=none smtp.client-ip=178.154.239.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="ittlQ16M"
Received: from mail-nwsmtp-smtp-production-main-74.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-74.sas.yp-c.yandex.net [IPv6:2a02:6b8:c24:1698:0:640:befc:0])
	by forward103b.mail.yandex.net (postfix) with ESMTPS id D2B36C008D;
	Wed, 15 Jul 2026 17:22:34 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-74.sas.yp-c.yandex.net (smtp) with ESMTPSA id WMRj8VMhAKo0-FNEE5rLV;
	Wed, 15 Jul 2026 17:22:34 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1784125354; bh=ixGgN3U7JJwddg8mnswaUBeQU6opndnQwdw5lTMrf74=;
	h=Subject:From:Cc:To:Date:Message-ID;
	b=ittlQ16Mnvc5sZRYEFpojDKfy7VFmRPnsZirB2yV8uBqvIsnTQCxTkgs3WEN0Zer6
	 0+d/Bj7UhGSRwrg08kqQMqqZlbGnFmQAYXsO1wGIk3A2wfkfBn4SDGxe9ZNE8wW82i
	 8c9x0U4TYuEnuYuhCTrzZlbmsSIoa3OqFetp1ijE=
Authentication-Results: mail-nwsmtp-smtp-production-main-74.sas.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <a1e86cd9-847b-4f3c-9bbb-d803fe3bd022@yandex.ru>
Date: Wed, 15 Jul 2026 17:20:17 +0300
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@lists.linux.dev
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: Memory leak in ocfs2_unlink_path()
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Local fuzzing of 6.12.94 has found the following memory leak
caused by doing copy_file_range(2) within the same filesystem:

unreferenced object 0xffff88812192c980 (size 32):
   comm "syz.0.49", pid 12095, jiffies 4294964143
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 08 00 00 00 00 00 00 00  ................
     c0 c5 92 21 81 88 ff ff 00 02 00 00 00 06 00 00  ...!............
   backtrace (crc 7068d63f):
     kmemleak_alloc_recursive include/linux/kmemleak.h:42 [inline]
     slab_post_alloc_hook mm/slub.c:4152 [inline]
     slab_alloc_node mm/slub.c:4197 [inline]
     __kmalloc_cache_noprof+0x168/0x2c0 mm/slub.c:4358
     kmalloc_noprof include/linux/slab.h:878 [inline]
     ocfs2_find_per_slot_free_list fs/ocfs2/alloc.c:6618 [inline]
     ocfs2_cache_block_dealloc+0x155/0x4b0 fs/ocfs2/alloc.c:6786
     ocfs2_cache_extent_block_free fs/ocfs2/alloc.c:6819 [inline]
     ocfs2_unlink_path+0x286/0x450 fs/ocfs2/alloc.c:2613
     ocfs2_rotate_subtree_left fs/ocfs2/alloc.c:2779 [inline]
     __ocfs2_rotate_tree_left+0x1f6f/0x2da0 fs/ocfs2/alloc.c:2985
     ocfs2_rotate_tree_left+0x283/0xe00 fs/ocfs2/alloc.c:3237
     ocfs2_try_to_merge_extent+0xf56/0x1a20 fs/ocfs2/alloc.c:3825
     ocfs2_split_extent+0x15f4/0x2940 fs/ocfs2/alloc.c:5138
     ocfs2_clear_ext_refcount+0x2f6/0x550 fs/ocfs2/refcounttree.c:3098
     ocfs2_replace_clusters fs/ocfs2/refcounttree.c:3131 [inline]
     ocfs2_make_clusters_writable fs/ocfs2/refcounttree.c:3255 [inline]
     ocfs2_replace_cow+0x991/0x1660 fs/ocfs2/refcounttree.c:3349
     ocfs2_refcount_cow_hunk fs/ocfs2/refcounttree.c:3427 [inline]
     ocfs2_refcount_cow+0x5e1/0x9f0 fs/ocfs2/refcounttree.c:3470
     ocfs2_prepare_inode_for_write fs/ocfs2/file.c:2340 [inline]
     ocfs2_file_write_iter+0xbda/0x1880 fs/ocfs2/file.c:2451
     iter_file_splice_write+0x890/0xf60 fs/splice.c:743
     do_splice_from fs/splice.c:944 [inline]
     direct_splice_actor+0x232/0x480 fs/splice.c:1167
     splice_direct_to_actor+0x4b4/0xb60 fs/splice.c:1111
     do_splice_direct_actor fs/splice.c:1210 [inline]
     do_splice_direct+0x10f/0x1c0 fs/splice.c:1236
     do_sendfile+0x430/0xbf0 fs/read_write.c:1388

unreferenced object 0xffff88812192c5c0 (size 32):
   comm "syz.0.49", pid 12095, jiffies 4294964143
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     29 70 00 00 00 00 00 00 19 00 00 00 00 00 00 00  )p..............
   backtrace (crc afec850f):
     kmemleak_alloc_recursive include/linux/kmemleak.h:42 [inline]
     slab_post_alloc_hook mm/slub.c:4152 [inline]
     slab_alloc_node mm/slub.c:4197 [inline]
     __kmalloc_cache_noprof+0x168/0x2c0 mm/slub.c:4358
     kmalloc_noprof include/linux/slab.h:878 [inline]
     kzalloc_noprof include/linux/slab.h:1014 [inline]
     ocfs2_cache_block_dealloc+0x25c/0x4b0 fs/ocfs2/alloc.c:6793
     ocfs2_cache_extent_block_free fs/ocfs2/alloc.c:6819 [inline]
     ocfs2_unlink_path+0x286/0x450 fs/ocfs2/alloc.c:2613
     ocfs2_rotate_subtree_left fs/ocfs2/alloc.c:2779 [inline]
     __ocfs2_rotate_tree_left+0x1f6f/0x2da0 fs/ocfs2/alloc.c:2985
     ocfs2_rotate_tree_left+0x283/0xe00 fs/ocfs2/alloc.c:3237
     ocfs2_try_to_merge_extent+0xf56/0x1a20 fs/ocfs2/alloc.c:3825
     ocfs2_split_extent+0x15f4/0x2940 fs/ocfs2/alloc.c:5138
     ocfs2_clear_ext_refcount+0x2f6/0x550 fs/ocfs2/refcounttree.c:3098
     ocfs2_replace_clusters fs/ocfs2/refcounttree.c:3131 [inline]
     ocfs2_make_clusters_writable fs/ocfs2/refcounttree.c:3255 [inline]
     ocfs2_replace_cow+0x991/0x1660 fs/ocfs2/refcounttree.c:3349
     ocfs2_refcount_cow_hunk fs/ocfs2/refcounttree.c:3427 [inline]
     ocfs2_refcount_cow+0x5e1/0x9f0 fs/ocfs2/refcounttree.c:3470
     ocfs2_prepare_inode_for_write fs/ocfs2/file.c:2340 [inline]
     ocfs2_file_write_iter+0xbda/0x1880 fs/ocfs2/file.c:2451
     iter_file_splice_write+0x890/0xf60 fs/splice.c:743
     do_splice_from fs/splice.c:944 [inline]
     direct_splice_actor+0x232/0x480 fs/splice.c:1167
     splice_direct_to_actor+0x4b4/0xb60 fs/splice.c:1111
     do_splice_direct_actor fs/splice.c:1210 [inline]
     do_splice_direct+0x10f/0x1c0 fs/splice.c:1236
     do_sendfile+0x430/0xbf0 fs/read_write.c:1388

This happens when 'ocfs2_replace_cow()' ends with NULL 'c_global_allocator'
but non-NULL 'c_first_suballocator' of 'struct ocfs2_cached_dealloc_ctxt'
involved, so ocfs2_run_deallocs() is never run due to:

     if (ocfs2_dealloc_has_cluster(&context->dealloc)) {
             ocfs2_schedule_truncate_log_flush(osb, 1);
             ocfs2_run_deallocs(osb, &context->dealloc);
     }

An obvious fix is to run 'ocfs2_run_deallocs()' unconditionally, but
1) I have no clue why it is so and 2) I have strong suspection that the
whole picture may be different when doing the same with clustered mount.

To whom it may be interesting, there is no working C repro but ~350K
.syz blob [1] that has to be run via syz-execprog directly.

[1] https://drive.google.com/file/d/1t6DOstv77QVSr76pAsP_dW7nPd10dlhU/view?usp=drive_link

Dmitry
