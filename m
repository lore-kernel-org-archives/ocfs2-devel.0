Received: from flow-b3-smtp.messagingengine.com (flow-b3-smtp.messagingengine.com [202.12.124.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0236E3ECBC7
	for <ocfs2-devel@lists.linux.dev>; Mon,  1 Jun 2026 18:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780339482; cv=none; b=NidV5iChRtJZAC6sd8e0eJN2Ziv+C7Iezh1PIZQAMq8xKr36StwvFmKbHCqzRGL6+Hsz+Uamrgz+qk0KthyloatSTA4cjQC+YYoq8sRdKFqdGGkSoprJoPta79y+o2XDxHFxq7nnoV3RJFKhIZFOxvcN/ctw5xBZSKQ/T7irPAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780339482; c=relaxed/simple;
	bh=gqJyzY/r7WScL2JfTTv5i/w2OOf08Dju+G/LmqlTt6w=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Gg2sAAYre2WAQ/HWljmyv5GKsHZ8w6QKl1o0EFWT0/boG6ZBvYQ1C/+YDFDoNEEMBKDuAQbg8j0sqqrI9jpzfOsVjn1JbEgTKki8qiCpWz9Wxii5UYCLVT9C9ST0rY9YL/9sOPj+WIFgc2lbbxBQpWMlxCKLN2Jyd2R10AAU3Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org; spf=pass smtp.mailfrom=fastmail.org; dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b=Oe8IsZQP; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=bg0mcSQu; arc=none smtp.client-ip=202.12.124.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b="Oe8IsZQP";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="bg0mcSQu"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id BA20C13008CF;
	Mon,  1 Jun 2026 14:44:37 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Mon, 01 Jun 2026 14:44:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm1; t=1780339477; x=1780343077; bh=ALDwtMFyGJ
	wzai8kKXQaDi+hhWyW8dXcwRJELpOZoJo=; b=Oe8IsZQPVB7S2hVyGs+H1SpKPY
	THHexB8K1F6ml+bcI+nNbAdsHzhqYNhQ4Q/ce09O+GWIFDjktU7X4o1xfNn82dwG
	zDIrTEPW4dROaw88RnM4y0hkvL7zk1scQ4Vks50M2J4/PS7VhVYbJBuWB8LMO9eI
	QosE51Nh9CTFUxIKWMeZDFrRfvLYx8GnBaNrrP7bDUY9DjyLrT31Q7aJaC8UfSYw
	jUjlN/55o+xxKbY2C5KJDojejQMjBTSsXp39k+0Zu+J2ElqBdcVj9t2Hiy2u7KIT
	fbJ1zvlWUj82+W26AxlSFazHzeOCgaWlVdsq1EiIzfK9K30GlCQjF4hybIcg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1780339477; x=1780343077; bh=ALDwtMFyGJwzai8kKXQaDi+hhWyW8dXcwRJ
	ELpOZoJo=; b=bg0mcSQu4p7r6liIvbHqJucF8ubUmAg1xyDcFLER6kibEmzTuSp
	ea8apO4iUxpyVl3JC1a7+CODgwmAtIhvGFjy8UDTFPej3feMovtU23j+DksXnbPX
	pFfcckG3r87YuYrMR0wDcRH4fV3bp+5mkm4pQ5X0aSIpTtL2fUOvagrKswrZ6t+i
	rz192F5reVyVYc41GbJ+L4PGXsjOC+80Ji1XKIiJgPR7X5gcuta882+pROpQmbuu
	1SnI96tSkWPCe59mVntkYGzkEDYMUaMMSU7axmWMRFXnYCBHX++XF9fwiHkaniUn
	jdpfw7fYQ1rw8wi7PNWwQfhOYjEBVIbTaTQ==
X-ME-Sender: <xms:FNMdauphgdrS0Egy7mW1Ke3O9LpiyA4fwi6jZn6blTKYGMAT0_1R0g>
    <xme:FNMdallGw3pXUzTi-9GwiDDxPIdhxgFkJ0hUsftOHXlm8PEVrG9d4NiwUvsB-3AWR
    NrzkChah5eZZY0AIbVoAIZeMaj8tfximYP0LPVey2gXjvGZPNg3p0I>
X-ME-Received: <xmr:FNMdauwxnhTMq2ImAgk9SIIafV8b0KUjEB9gonhgpRSyW6pzg7furVs4bvU>
X-ME-Proxy-Cause: dmFkZTFEmPPdPpuQj+EUc6lNCVvXlDczVOBjz0ebpJn8KVbWb2dloKw4Xlpz5wTK2AGefU
    Flr1sxCYB9zmci/BgnPEKhqnwReMcxxjA9LtdK6CHOM8LruaYxxZuCAV4C3ANdbI6Kbjyl
    0K6ICGMNOtul8AN2vu40MljGzO8ZJZ7fTPU9YHXcGOVUZkVybcyj4XDERBVootXQUhmt+0
    EjF/JNh6ZaIW9WUE/asALuy8od8lSTRH2FCl7yrfwgQ+7iqZQZX9WQ+m3TjqPgv9qTgPUJ
    YGBCzH+JN5TOa1M3TslSNgIq7zhjNbgt6GdqAzzRsGK0OVcvxeMR7Frv0GML745JSZ65EN
    e6tdRLyoyaXv3/8QxD7JTB+7h5sdKe1uVzyvwEJLW9RQ1ogJv8xOTZXjMumAbSDodJ2X9e
    KIc4NAdeQa37y/L/L5A2Typ/rlPilzYS9KM0pS/ZkNU+KInMXtzKUprbyRINBSMoJdU9+8
    LLh2nNZrRQT5EoYHKwiq5IMgcwVXtZnu1x6H3tO0z7n58A/igKXfDcgLHEMKf661EsRBEr
    FDzMgx3pDad5yZ9EE+BjN9RXCd/6quPe39EIL+yOwkMQG8K0gu0boSfaccd9dNFk6OkMeN
    JurRs0aTEvrhSH6/y8N7TpqbmMiauAgJbgd8QW0MzEdNb1TD7R7I37nM7MCA
X-ME-Proxy: <xmx:FNMdat-KNo38c0u9MmV5KKKjtwmLReTDbAHW-f-gvMheom5E71BRqg>
    <xmx:FNMdaqLVVNHdM6nLVnupgb0yEMsc55retxU5jN4HtTgF3c3xDAC0Fw>
    <xmx:FNMdarfxU6o2x-KXuATRtxK2n-Cij-jby1x4pH79TjJcy3t59Jqf6w>
    <xmx:FNMdah8kEt6K9TetNh0CMCFyniQ3dWqs97_k13sBWmC8eEfuuruLEQ>
    <xmx:FdMdagWF53tZYvCHn-EVxS_E6C2flWA3znQuiSzEaSL7lVX-u_9-Swsp>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 1 Jun 2026 14:44:36 -0400 (EDT)
Date: Mon, 1 Jun 2026 13:44:33 -0500
From: Ian Bridges <icb@fastmail.org>
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: [PATCH] ocfs2: fix out-of-bounds write in
 ocfs2_remove_refcount_extent
Message-ID: <ah3TESOsEO9j_JLU@dev>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

[BUG]
Unlinking a refcounted file whose refcount tree has leaf blocks
triggers a fortify panic due to an out-of-bounds write.

[CAUSE]
When the last leaf block is removed from a refcount tree,
ocfs2_remove_refcount_extent() converts the root back to leaf mode
with a bulk memset on &rb->rf_records. rf_records sits in an anonymous
union with rf_list. rf_list.l_tree_depth aliases rf_records.rl_count,
and is 0 for a single-level tree. With rl_count equal to 0, the memset
writes past the 16-byte declared size of rf_records, which the fortify
checker catches.

[FIX]
Replace the bulk memset on &rb->rf_records with a correctly-bounded
memset on rl_recs[] alone, after setting rl_count to the correct value.

Fixes: 2f26f58df041 ("ocfs2: annotate flexible array members with __counted_by_le()")
Reported-by: syzbot+3ef989aae096b30f1663@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3ef989aae096b30f1663
Signed-off-by: Ian Bridges <icb@fastmail.org>
---
This patch contains a proposed fix for a crash reported by syzbot
in __ocfs2_decrease_refcount().

The file names and offsets in this description are from commit
7cb1c5b32a2bfde961fff8d5204526b609bcb30a from this repo:
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git

I also have a small test harness that reproduces the original panic,
which I can make available as well.

The Bug

The ocfs2_refcount_list structure (fs/ocfs2/ocfs2_fs.h:935) contains
two fields relevant to this bug: rl_count, the maximum number of
refcount record slots, and rl_used, the number of occupied slots. The
flexible array member rl_recs is annotated __counted_by_le(rl_count)
(fs/ocfs2/ocfs2_fs.h:942), which instructs the compiler to use
rl_count as the runtime bound for __builtin_dynamic_object_size
queries on rl_recs when CONFIG_FORTIFY_SOURCE is enabled.

ocfs2_remove_refcount_extent() (fs/ocfs2/refcounttree.c:2066) is
called when the last refcount record is removed from a leaf block. If
that leaf was also the last one, the root is converted back from tree
mode to leaf mode. The restore path (fs/ocfs2/refcounttree.c:2131–2137)
zeros the header fields and resets the on-disk record area with a memset
on &rb->rf_records (fs/ocfs2/refcounttree.c:2134).

This is an out-of-bounds write of the rf_records struct member.
rf_records and rf_list share the same memory in an anonymous union; the
first field of rf_list, l_tree_depth, occupies the same bytes as
rf_records.rl_count. A refcount tree is always single-level, so
l_tree_depth is 0, which means rl_count reads as 0 at the memset call
site. The declared size of rf_records is therefore 16 bytes (the fixed
header with zero record slots), but the memset writes the full remainder
of the block (past the end of the struct member).

Here is a step-by-step breakdown of how the crash is triggered by
unlinking a refcounted file:

0. Inode eviction calls through to ocfs2_commit_truncate()
(fs/ocfs2/alloc.c:7241), which calls ocfs2_remove_btree_range()
(fs/ocfs2/alloc.c:5714) for each extent range. Because the extents
are refcounted, ocfs2_decrease_refcount() (fs/ocfs2/alloc.c:5800)
is called to decrement the reference count for each cluster.
1. For each cluster whose reference count reaches zero,
ocfs2_decrease_refcount_rec() (fs/ocfs2/refcounttree.c:2158)
removes the corresponding record from the leaf block.
2. When the last record is removed from a leaf block, rl_used reaches
0 and ocfs2_remove_refcount_extent() (fs/ocfs2/refcounttree.c:2203)
is called to detach it from the tree root's extent list.
3. If that was the last leaf, the root has no remaining extents and
the restore-to-leaf-mode path at fs/ocfs2/refcounttree.c:2125 is
entered.
4. The memset at fs/ocfs2/refcounttree.c:2134 writes past the
16-byte declared size of rf_records. The fortify checker reads
rl_count, which is 0 because it aliases l_tree_depth in the union,
and fires.

The Proposed Fix

Replace the bulk memset on &rb->rf_records with explicit initialisation
of each header field of ocfs2_refcount_list, followed by a
correctly-bounded memset on rl_recs[] alone. rl_count is set before the
memset so that the fortify checker can read it at runtime to verify the
write against the declared array size.

 fs/ocfs2/refcounttree.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 8eee5be4d1ed..7323bde70caa 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -2131,10 +2131,15 @@ static int ocfs2_remove_refcount_extent(handle_t *handle,
 		rb->rf_flags = 0;
 		rb->rf_parent = 0;
 		rb->rf_cpos = 0;
-		memset(&rb->rf_records, 0, sb->s_blocksize -
-		       offsetof(struct ocfs2_refcount_block, rf_records));
+		rb->rf_records.rl_used = 0;
+		rb->rf_records.rl_reserved2 = 0;
+		rb->rf_records.rl_reserved1 = 0;
+		/* rl_count determines the memset size and fortify object size. */
 		rb->rf_records.rl_count =
 				cpu_to_le16(ocfs2_refcount_recs_per_rb(sb));
+		memset(rb->rf_records.rl_recs, 0,
+		       le16_to_cpu(rb->rf_records.rl_count) *
+		       sizeof(*rb->rf_records.rl_recs));
 	}
 
 	ocfs2_journal_dirty(handle, ref_root_bh);
-- 
2.47.3

