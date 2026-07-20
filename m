Received: from forward205a.mail.yandex.net (forward205a.mail.yandex.net [178.154.239.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CFB4014A1
	for <ocfs2-devel@lists.linux.dev>; Mon, 20 Jul 2026 11:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784548070; cv=none; b=YSDoH+hSBNvZbx0Hx7SdJiQJai4kWKtH6JfdPrhkpjcwuk2BNdCoN7hb2MtQG5vipWTodEsRX/bsZM8Prf86fHAr908Atjk4VjScNMGdAnEA6WHPoaNKzay1G7r7ID+eOi1vHIWk8H1nxKQxiryiVD/WOXDNdGUIotUujm0kI5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784548070; c=relaxed/simple;
	bh=dv+nU5hkUZ8BellW0wAl50eXLNdX/rP/9LOQQ7afCVA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iT1kOobMDN9WMHXuNmI60cBiPs1Z/KfGtBxzuj2xAiOrcpX7UL7sPTAJkziajosf5+Yk8x7goFiPvSAExRbX24x0FDJkChvVAcslqkItlerrruo81cLTJlUpjm81H+dAP8Gr51JlFUFVkSRumyPKxyD1xcnGPF0ZS19oJxI2bJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=FJ+Z+/sP; arc=none smtp.client-ip=178.154.239.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="FJ+Z+/sP"
Received: from forward102a.mail.yandex.net (forward102a.mail.yandex.net [IPv6:2a02:6b8:c0e:500:1:45:d181:d102])
	by forward205a.mail.yandex.net (postfix) with ESMTPS id 2EC5BC2B82
	for <ocfs2-devel@lists.linux.dev>; Mon, 20 Jul 2026 14:42:30 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-55.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-55.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1f:582e:0:640:200:0])
	by forward102a.mail.yandex.net (postfix) with ESMTPS id A2D62C0189;
	Mon, 20 Jul 2026 14:42:21 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-55.vla.yp-c.yandex.net (smtp) with ESMTPSA id JgTkit2f4Os0-laKA29ce;
	Mon, 20 Jul 2026 14:42:21 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1784547741; bh=L5C+9XnLV8C8SJ6IQegsVixwjDxGMxTXYx3uGY38tsM=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=FJ+Z+/sPDQSxvFUS+WCpfIkoWqZ4O8P1KeEKqDvuFOXHZac25YPKzUP4fjDt0Gq0X
	 w9mEC487aqW1KtlPJYTMNS9gxr6JTW+lMg+enuQOITo0JyR/1/LqKTl7KcJMRmPa6N
	 Sm6RCmvp3y2fV7AbTPLtcl76epNeBFAT4sl4DuQY=
Authentication-Results: mail-nwsmtp-smtp-production-main-55.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel@lists.linux.dev,
	lvc-project@linuxtesting.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] ocfs2: always run deallocs on copy-on-write completion
Date: Mon, 20 Jul 2026 14:39:57 +0300
Message-ID: <20260720113957.58219-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Local fuzzing of 6.12.94 has found the following memory leak
caused by doing 'copy_file_range()' within the same filesystem:

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

This happens when 'ocfs2_cache_block_dealloc()' called from
'ocfs2_cache_extent_block_free()' uses the suballocator to
schedule extent removal, so 'ocfs2_run_deallocs()' should
be run unconditionally to complete the removal with
'ocfs2_free_cached_blocks()'.

Fixes: 6f70fa519976 ("ocfs2: Add CoW support.")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 fs/ocfs2/refcounttree.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 7323bde70caa..e659313a7383 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -3360,10 +3360,9 @@ static int ocfs2_replace_cow(struct ocfs2_cow_context *context)
 		cow_start += num_clusters;
 	}
 
-	if (ocfs2_dealloc_has_cluster(&context->dealloc)) {
+	if (ocfs2_dealloc_has_cluster(&context->dealloc))
 		ocfs2_schedule_truncate_log_flush(osb, 1);
-		ocfs2_run_deallocs(osb, &context->dealloc);
-	}
+	ocfs2_run_deallocs(osb, &context->dealloc);
 
 	return ret;
 }
-- 
2.55.0

