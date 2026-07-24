Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD999374A1E
	for <ocfs2-devel@lists.linux.dev>; Fri, 24 Jul 2026 04:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784869032; cv=none; b=rrhRf8YXon2VU3m7W/XpySfULdxBJQ/W9zH+js4++oDlErcsby7rY3RqwWUjgwoXjdvcL3UWqKnYShJs53X3K0TC4uaY6h3u9Szr0WNIvzgKdQJGpaKDBKuAW6Qcq8JyxLBVb3UvtSigCzMs9fIi0J6FT6XAjzhvSEyX2BGe5oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784869032; c=relaxed/simple;
	bh=SeIVGDGhJLQtAtXwJSZ4HJIHShuKm1xWba7VbuZj+bI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=HIlo6m1x7xuXdFA6mcGm/x38RmzCDRvcnCBx+c3/tGlZ5q0QxhY6Kb1RVbeJTS87HqXUcxQQ0rIb2hTnJto0V2MfZZwojV3qvdZCO9oY6ydlbf/slmgRpVQz95m4DiTz6OibR2XL8aTV1ug9jM4foRya5HMB9ytnBD8LG0S2BII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org; spf=pass smtp.mailfrom=fastmail.org; dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b=MbVmmjmF; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=MpskfeG0; arc=none smtp.client-ip=103.168.172.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b="MbVmmjmF";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="MpskfeG0"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 68CA01400128;
	Fri, 24 Jul 2026 00:57:06 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 24 Jul 2026 00:57:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:message-id:mime-version:reply-to
	:subject:subject:to:to; s=fm2; t=1784869026; x=1784955426; bh=ne
	nyZzlBK2D1i22eaTDG7B3XPxBbIntzWsoNDJRPhiQ=; b=MbVmmjmFymudl1FgRQ
	CIqAs6m6RQXhP1vqEFTfAhxv/roQy7zAhDC4gXdCCYYmHAiNO+4QxFNV2vA2PPdC
	6gAIpzDsBLFjB2ZgE2ffFkoXINl6m8Hf8z0+R4op8fyYb0ulb691j5Uso1Bnw2CZ
	OCAwjlzal0y4s7GQNEg+7IEfL3Skpb5BYLWHC+bhKusCbvlOABg3/9wQKfYcK0Wy
	mu2xrGXkV4shvVNALZPI18utbiiB1/kE2DP8QuzKR4eYOadajb1DbGd8Y1nW8Zch
	gGDmjGWas7xwyi5WsjZa3ljXvJ+UpIsxGO7dOP6I+IyCZ6tBFvUnYrKGmYBtLL6s
	+RxQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1784869026; x=1784955426; bh=nenyZzlBK2D1i22eaTDG7B3XPxBb
	IntzWsoNDJRPhiQ=; b=MpskfeG0tzpDweUuJ/C5ImdtxbFry+jORiXLYItkvDHN
	ktzV06r+/LHKwJfh4PPmG/+nxdxM4qo4Gx+Q0kzmgAABp/XpfK1OnPaI+PSyvRx6
	biP7/EYUKrKI/jzKEwo2Z7LC42fR8uo62XAQebatKZABzv0znQcDiIrENS/gBx6d
	SEc5+ZjvYthknA4gqrWdDJ/DSm+AmJeCQ4T9D1+TSp/Z33XSDMGn6fQttf8UxIfw
	4uHHV5B3m49NVlfBPMGT1CMf4WnbC2+ZQFHL8t8d5UPoFW9andC++jc+ec7WiOEJ
	SlgaAprVRUYNQ11aI8h2crWj9OrOGNXH4Wku27apdg==
X-ME-Sender: <xms:ofBian4p9lTeJGYFdh76Pdrkpk2mBZLiSRTq2hhKFVj2CZQqLoJwsw>
    <xme:ofBial04O96CD0OVgAlocHSStBv8pftJRfWTw2_PdSTE3uNOszVELYpxCLzzgjqFs
    nLsWFuadHefVYJVei4G46fGcufihlc--ToegMcccG_C9olCQHkjXw>
X-ME-Received: <xmr:ofBiaqDVz8XE4MssbtQ0pE6Ie9ZLU8OWGLuU2mTZN5p_cggmhatrJUGBK4Y>
X-ME-Proxy-Cause: dmFkZTGmjuVl5yLUfDt1VWSV8RNi75s6202A2x2GjNywNWBng59wOVNP8On11m8BYkCQxt
    NhvBmBLi3apYzz1oDhsf50JCLgkzSP+JFWUmTvjVKlZ++ErN14r4xDFnBm4ICMQftZ0XmK
    HP0TbOAdXptY06XcTx8lVC1X7A0gJ2MCNwIS//GtsuSilGraRf0wfBjuahrfJEU6Pt8m8F
    ksRBmet6zEeXzb2sUIxTxrS0kOb6riLS2BqpiQJdfNeH1FCos32ChgTpS/VRWVZdRIy/8z
    MKfmqmd5IxNQHxZTwRnWxa5kFmv3HKOk3ruSg/W8qXo55roeORSOUzknTqEJMhp8LZWip5
    GXHQuZf8fxErUlKLbtCMh18c8xHoleIY3rGr3SAjXu5MQ9oiEbwSpeQXRESRDtTr/jB4Oh
    Y6r9lP326j9TenbMOhJTHwn4zoZi4nEPMTfCeDO4eKjxD8f7xM3kcx+OIlT7raSG3sz8LN
    iZeds8ObzK44DovbtqIo5QlFSF2RAg77cLkEjBaA7a2BQrcHeFCFl541dmzYiZrld7CUcI
    0VM3hD7b4mw7jDi3cehI4JEH/9LteFS3OFPMIgdLG9FmtKL2YMZ9GRGaldGG1+OyjsDH68
    2cTq1lqoJT7unPKE+eLwX52Ur4aBfkWmEOhQpJfBMvf3JKpbrz0Muv5Di+8Q
X-ME-Proxy: <xmx:ofBiaoP2XJppTVETCzO9xbcKUHUIX1IsXv2uXZZXmfauVzHbsAahng>
    <xmx:ofBianYClmLqbwxMVz-KpNqZp49izZ9pFK6qknB14oCRvLbZudeXpg>
    <xmx:ofBiavt_yjwlwcVdm0juMUCiwVNCZtewjKDqMA5YzV8suk6VEiaa8A>
    <xmx:ofBiahPPDd0uj9n0GlJbdFrAuJzEwUU6Ne9sVyMX3j9uIPOL7z99Qg>
    <xmx:ovBiaut76VAkKRKYQlP_ttIynOEasiTDrXY7xcukLEidYi3JuM4UK72a>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 24 Jul 2026 00:57:05 -0400 (EDT)
Date: Thu, 23 Jul 2026 23:57:03 -0500
From: Ian Bridges <icb@fastmail.org>
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] ocfs2: fix missing metadata reservation for large
 xattrs
Message-ID: <amLwn3i9tET8yhG7@dev>
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
lsetxattr() panics the kernel when setting a large xattr value on a
fragmented filesystem where the file already has an external xattr
block.

[CAUSE]
ocfs2_calc_xattr_set_need() never reserves metadata blocks for a new
xattr value's extent tree when the file already has an external xattr
block. The not_found path leaves meta_add at zero, so meta_ac is NULL
when ocfs2_xattr_extend_allocation() runs.

A new value root has room for a single extent record. On a fragmented
filesystem, the allocator cannot satisfy the xattr value in one
contiguous run, so each non-contiguous run requires its own extent
record. When the value root's extent list is full and meta_ac is NULL,
ocfs2_add_clusters_in_btree() returns RESTART_META, and
ocfs2_xattr_extend_allocation() hits BUG_ON(why == RESTART_META).

[FIX]
The case where no xattr block exists yet already calls
ocfs2_extend_meta_needed(&def_xv.xv.xr_list) to reserve value tree
metadata. Add the same reservation to the case where an xattr block
already exists, making the two cases consistent.

Replace the BUG_ON with a -ENOSPC return so that if RESTART_META is
returned despite the reservation, the error propagates to userspace
instead of panicking the kernel.

Fixes: a78f9f466894 ("ocfs2: make xattr extension work with new local alloc reservation.")
Reported-by: syzbot+e538032956b1157914a3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e538032956b1157914a3
Signed-off-by: Ian Bridges <icb@fastmail.org>
---
Resend, requested by Joseph Qi [1]. The patch was first posted
2026-05-30 [2]. The diff is unchanged and still applies cleanly to
current mainline and to the mm tree's mm-nonmm-unstable branch.

[1] https://lore.kernel.org/all/882d50db-d579-4794-ad2f-8bb88d2e1ace@linux.alibaba.com/
[2] https://lore.kernel.org/all/ahrxN7dbUaOqX9vT@dev/

This patch contains a proposed fix for a crash reported by syzbot
in ocfs2_xattr_value_truncate().

I also have a small test harness that reproduces the original panic,
which I can make available as well.

The file names and offsets in this description are from mainline
commit 48a5a7ab8d6a.

The Bug

When a user sets an extended attribute (xattr) that requires more
than 80 bytes of storage (OCFS2_XATTR_INLINE_SIZE,
fs/ocfs2/xattr.c:80) on a file, OCFS2 adds a name-root
(ocfs2_xattr_value_root) pair to the file's xattr storage area —
either the inline area at the tail of the inode block or the
external xattr block, depending on which has space. The xattr value
is then stored in separate clusters on disk. The value root is the
entry point for looking up which clusters hold the value.

Each new root is cloned from def_xv (fs/ocfs2/xattr.c:90). The
def_xv template has its l_count member explicitly initialized to 1
(fs/ocfs2/xattr.c:91). l_count = 1 means the embedded
ocfs2_extent_list has room for exactly one extent record.
l_tree_depth is implicitly set to 0.

OCFS2 will attempt to find a single run of contiguous free clusters
to store the xattr value. If it cannot find such a run because the
disk is fragmented, OCFS2 will store the xattr value across multiple
non-contiguous runs of clusters.

The ocfs2_xattr_value_root embedded in the xattr entry is the root
of a B-tree that tracks extent records. Each non-contiguous run of
clusters requires its own extent record in this tree. Since l_count
is 1, the root can only hold a single extent record initially. If
the xattr value requires more than one extent record, the tree must
grow, which requires allocating a new metadata block.

Before opening a transaction to allocate clusters for the xattr
value, ocfs2_xattr_set() calls ocfs2_init_xattr_set_ctxt()
(fs/ocfs2/xattr.c:3293), which calls ocfs2_calc_xattr_set_need()
(fs/ocfs2/xattr.c:3081) to pre-calculate the number of clusters
and metadata blocks the operation will need.

The root cause of the bug is a missing reservation in
ocfs2_calc_xattr_set_need(). When adding a new large-value xattr to
a file that already has an external xattr block, the function never
adds anything to meta_add for the value tree, leaving it at 0. Here
is a breakdown:

 0. ocfs2_calc_xattr_set_need() is called from
    ocfs2_init_xattr_set_ctxt() (fs/ocfs2/xattr.c:3309).
 1. The meta_add local is initialized to 0.
 2. Because we are adding a new xattr, xis->not_found and
    xbs->not_found are both -ENODATA. This means execution is
    transferred to the meta_guess label (fs/ocfs2/xattr.c:3225)
    with meta_add still set to 0.
 3. The reproducer code only sets a few xattrs. The xattrs fill the
    inode inline area and spill into the external xattr block, but
    not enough to cause the block to be indexed. Since the block is
    not indexed, we skip the incrementing of meta_add under the
    meta_guess label (fs/ocfs2/xattr.c:3248), and meta_add remains
    0.
 4. The value of meta_add (still 0) is returned to
    ocfs2_init_xattr_set_ctxt() through the meta_need parameter
    (fs/ocfs2/xattr.c:3309).
 5. extra_meta is 0 because the file is not a refcounted inode, so
    meta_add in ocfs2_init_xattr_set_ctxt() remains 0
    (fs/ocfs2/xattr.c:3316).
 6. Because meta_add is 0, ocfs2_init_xattr_set_ctxt() skips the
    metadata block reservation code
    (ocfs2_reserve_new_metadata_blocks()) and meta_ac remains 0
    (fs/ocfs2/xattr.c:3320).
 7. Eventually, we end up in ocfs2_xattr_extend_allocation()
    (fs/ocfs2/xattr.c:699) with the 0 meta_ac value having been
    propagated into ctxt->meta_ac.
 8. Due to disk fragmentation (which we purposefully cause in the
    reproducer code), the xattr value we set must be split into two
    non-contiguous clusters. This causes us to pass through the
    allocation loop in ocfs2_xattr_extend_allocation() twice.
 9. When ocfs2_add_clusters_in_btree() is called during the first
    pass through the loop (fs/ocfs2/xattr.c:723), the root has one
    free extent slot (l_count (1) - l_next_free_rec (0) = 1). The
    extent record for the first cluster is inserted into that slot,
    and l_next_free_rec is incremented to 1.
 10. Since the entire xattr value did not fit in the first cluster,
     why is set to RESTART_TRANS. This triggers another pass through
     the allocation loop.
 11. During the second pass through the loop, ctxt->meta_ac is
     still 0. Now that there are no more free slots in the root's
     ocfs2_extent_list (l_count (1) - l_next_free_rec (1) = 0),
     ocfs2_add_clusters_in_btree() returns RESTART_META in why
     (fs/ocfs2/alloc.c:4832).
 12. We then hit the BUG_ON assertion (fs/ocfs2/xattr.c:747) and
     panic.

The Proposed Fix

The proposed fix has two parts.

The first part adds the missing reservation in
ocfs2_calc_xattr_set_need(). This change is derived from a similar
pattern (fs/ocfs2/xattr.c:3273), which handles the case where no
xattr block exists yet. This ensures meta_ac is not 0 when
ocfs2_xattr_extend_allocation() runs.

The second part replaces the BUG_ON(why == RESTART_META) assertion
(fs/ocfs2/xattr.c:747) with a -ENOSPC return. If RESTART_META is
returned, the loop breaks and propagates -ENOSPC to userspace
instead of panicking the kernel.

 fs/ocfs2/xattr.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index fcddd3c13acd..5989351aff93 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -740,12 +740,10 @@ static int ocfs2_xattr_extend_allocation(struct inode *inode,
 					 prev_clusters;
 
 		if (why != RESTART_NONE && clusters_to_add) {
-			/*
-			 * We can only fail in case the alloc file doesn't give
-			 * up enough clusters.
-			 */
-			BUG_ON(why == RESTART_META);
-
+			if (why == RESTART_META) {
+				status = -ENOSPC;
+				break;
+			}
 			credits = ocfs2_calc_extend_credits(inode->i_sb,
 							    &vb->vb_xv->xr_list);
 			status = ocfs2_extend_trans(handle, credits);
@@ -3254,6 +3252,14 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
 		} else
 			credits += OCFS2_SUBALLOC_ALLOC + 1;
 
+		/*
+		 * Reserve metadata for the new xattr's value extent tree.
+		 * The not_found path above adds credits for this tree but
+		 * omits meta_add, leaving meta_ac NULL for large values.
+		 */
+		if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE)
+			meta_add += ocfs2_extend_meta_needed(&def_xv.xv.xr_list);
+
 		/*
 		 * This cluster will be used either for new bucket or for
 		 * new xattr block.
-- 
2.47.3

