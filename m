Received: from flow-a3-smtp.messagingengine.com (flow-a3-smtp.messagingengine.com [103.168.172.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648433E1723
	for <ocfs2-devel@lists.linux.dev>; Mon,  1 Jun 2026 15:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780327836; cv=none; b=jN5lwxYKExytjhnRjQgPC78+6PMlLMJTgq5KXCn0mBjAUXPF3QlpCCcDV7v0z+unX+y+NYUZB/ul6BSXbcZzut1BSfEIhDXPp664eoDu5mW0PjfNz/ZV+duoFsyUj92ThjbLtuHlnqALAPWbQ5bDfOAQFhe1X/bOkFCIY99yJug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780327836; c=relaxed/simple;
	bh=RN8kEFYpDEckSNQUExkE8ryRc69uTByggIxwLWHCYEs=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ulekAo0M3xmdDQ/9rTpI5/6411oCWloRaxq0Z6he18KN0Wad9ujEgGllfEllj1l2Hxbpc9Jbkn/riF6H2MaLeVBUeSQ5RDagOUMrhcl+A/6k5PNHTCBefwkKt0l4bfXHmc4p5uzSU9p58CPX3mG0ETNO/UOX5K8CHnYiszUGEHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org; spf=pass smtp.mailfrom=fastmail.org; dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b=AIOXyrVN; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=RC63byJQ; arc=none smtp.client-ip=103.168.172.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b="AIOXyrVN";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="RC63byJQ"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.phl.internal (Postfix) with ESMTP id 702AE138037F;
	Mon,  1 Jun 2026 11:30:26 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Mon, 01 Jun 2026 11:30:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm1; t=1780327826; x=1780331426; bh=co/KTSIHu3
	29EBHCInlOEAiTyw+/eYiIk4XmIeJNrp4=; b=AIOXyrVNw8kZ6pxSOr8Zj4h3ys
	1zn8ac8zijVwg61yJlf6U3Zb33hFRCcnC50Qk5TgoqTkr/sR5pShUXWdSvMa+OJJ
	8UBjV1clQDv4vB6z3bXWERsG242kZhu2uNkne5o6D4E9AknCNXirzULqIpITD6pG
	wbgm+4Rjj+nXkcHgL1JaBJQ1TJ5f8NuWJJTibyHoRJ0Wl83FGVhnHQvyO8z8zDMk
	XwjOT7FmhkTvDqExrFuX7vDDAaNQoAntm/UPlmkSCZW9k+48t4QQsPWLTKi5bcNr
	WPS61RhzKJF9Bi/THmRPlLdl3K/OukiWwFQWQH/U+e0NRvtWEAPus4b3RreQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1780327826; x=1780331426; bh=co/KTSIHu329EBHCInlOEAiTyw+/eYiIk4X
	mIeJNrp4=; b=RC63byJQFDbkgoGMXs2pB8bdMgLbO/4dlx66og4N3uFGpuG1dXy
	glYPZZP40fvcvRhXpWQnTz0Lrvk4hiYB7FnU5a9Hl8peHiVXgOAOnOLQ6jjaHFEa
	waGAreJKO60791Y+reuiHSrUC/esGnCU8rIvURq7aiQEf9/vbfENFI183ae42prg
	OYeAdYMPCUaCEoUYrGSO7TxD9IJAYRINjazhIoKdNRrlGRcBdib+TZpDcNU60eza
	rZwBbHdK64zLnTHRoo8a2n1EOZZRzzLniHfSP1WtSl2o0ZLYZeqz80+eMB2q1MQc
	BNkOT1bVLxN7DPCT0tgJhEpCLaBTB1Gn+SA==
X-ME-Sender: <xms:kaUdanE3-n22PISaFhbe_pRKVfbVzyLqdBffP7Q2SGox3CZIsEjRmw>
    <xme:kaUdatR6gY83FHk0TmzKfDYGDWDUsaUqZ72gr3qW6Fu8veJS2lAR-d3qPWE_DnxgT
    BlwhgC4HuTrZuTmYNnfkCvCyPzxWACYYl6GDUA7opZSok0RGXuVxg>
X-ME-Received: <xmr:kaUdaksMJdj14h3-C2f_-HGvRV25nKFZGydWmMLT7XnyggmUckQE6WvYt3c>
X-ME-Proxy-Cause: dmFkZTF0D5n8BqUHZTt0OMUnG3mYM4WZWLZjAU4Rx37CxPwToe+d1bVGPMx+5FjEKTwbEK
    TyIjxkg5zr3Zw9KLfrpBzgDsbR1WrQ9z/950qWhIp73fCWRU+93nmuJUBrxcXCyr+QIWPp
    dMrnnRrIL94+IAzmBpzynctb0pwB3ARTU3iCJUu9X8TtABifkdf6VQkALKYAbzARV1XbSP
    0NsUkdgW+2B53+vCXRm2h909bCDjW2AkSs1UoDLsmT5HJ10i4zEzIwwWM1MvHTvCNHDETh
    W2iuSoRiZOfMlDpZYMY0p4piBLd5M4N+A9F+7ydJTIQ80xUfJbVFUZ1ZJZpxaPH79WQTVZ
    Sz63z9KxtgKuAac0qY8Z1hsIROEpgjSawKwknrp9K72LT6U28Vi04M04IYHyp+fU8KKv3K
    mThZoEdqkBQGKbO+jt4jURjrbEC0wdnu7bk5GG3hPYZWr2V02CEC9ZQgP27RUQU3oz0X5Q
    fdsIKxdJD+gUGut5kHYsUjg6EUknx4hf3tEF8BbrUltnAu5++XcCYClQWGw5Z7DUmqHrzl
    89BwvqFf0CzQMpGVYI9O005AKkmEfa1ikjn2GDIri1yQUg+uNCVeZVpz58HlW3rgpatn0J
    tfZrKBcD/FA7R1mlIIMZifVbhkq0r/UnujGPGa5uC+Z/OdKQRaKFclN/8Etw
X-ME-Proxy: <xmx:kaUdalLfZqfzcdAH30-bqwHD_r81HaDRExGowrFGx9thF-EsUNEF4A>
    <xmx:kaUdapkczPeOWZLYcJpWRR8S9z5lkyGlUqRrFn_mci1Z2exoP1UpsQ>
    <xmx:kaUdauISk9IX9SqmTK99BB6hPqjkzSGyARbr3m8QMJUyRo849163jQ>
    <xmx:kaUdam7lY5YRvFQi5x6qoQ9vfa6N5ZSAt1nDcqzlb-4i_qTSRp0_Kw>
    <xmx:kqUdahRfy1JqRDiWql5gpNPZXat-kY9-T2xLoZUuHz7uCg2IvUTFPzTV>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 1 Jun 2026 11:30:25 -0400 (EDT)
Date: Mon, 1 Jun 2026 10:30:23 -0500
From: Ian Bridges <icb@fastmail.org>
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: [PATCH] ocfs2: fix UBSAN array-index-out-of-bounds in
 ocfs2_sum_rightmost_rec
Message-ID: <ah2ljwKRw-Xsi4Ga@dev>
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
On-disk corruption setting l_next_free_rec to 0 in an inode's inline
extent list triggers a UBSAN panic on the next write to that file.

[CAUSE]
ocfs2_sum_rightmost_rec() computes
i = le16_to_cpu(el->l_next_free_rec) - 1
and accesses el->l_recs[i] without validating i. When l_next_free_rec
is 0, i becomes -1; when l_next_free_rec exceeds l_count, i falls
past the end of the array. Either case violates the
__counted_by_le(l_count) annotation on l_recs[] and triggers UBSAN.

[FIX]
Read l_count once into a local variable to eliminate a TOCTOU between
the bounds check and the __counted_by_le-generated check at the array
access. Validate i against both bounds before dereferencing l_recs[].
On an out-of-bounds index call ocfs2_error() since both cases indicate
filesystem corruption.

Update the signature to accept a struct ocfs2_caching_info *ci and
return int, with the cluster sum returned through a u32 out-parameter.
Update both callers to pass et->et_ci and propagate the error.

Fixes: 2f26f58df041 ("ocfs2: annotate flexible array members with __counted_by_le()")
Reported-by: syzbot+be16e33db01e6644db7a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=be16e33db01e6644db7a
Signed-off-by: Ian Bridges <icb@fastmail.org>
---
This patch contains a proposed fix for a crash reported by syzbot
in ocfs2_grow_tree().

The file names and offsets in this description are from commit
7cb1c5b32a2bfde961fff8d5204526b609bcb30a from this repo:
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git

I also have a small test harness that reproduces the original panic,
which I can make available as well.

The Bug

The ocfs2_extent_list structure (fs/ocfs2/ocfs2_fs.h:458) contains
two fields relevant to this bug: l_count, the total number of extent
record slots in the list, and l_next_free_rec, the index of the next
unused slot. The extent record array l_recs is annotated
__counted_by_le(l_count) (fs/ocfs2/ocfs2_fs.h:472), which instructs
UBSAN to bounds-check every access to l_recs against l_count.

ocfs2_sum_rightmost_rec() (fs/ocfs2/alloc.c:1106) is a helper used
by both ocfs2_add_branch() and ocfs2_shift_tree_depth() to compute
the logical cluster position just past the rightmost occupied extent
record. It derives the index of that record as:

i = le16_to_cpu(el->l_next_free_rec) - 1;  /* alloc.c:1110 */

and then accesses el->l_recs[i] (fs/ocfs2/alloc.c:1112) without
first checking that i is a valid index. This is the root cause of
the bug.

The syzbot report shows index -1 at the crash site, which means
l_next_free_rec was 0 at the point of the crash. The crash occurs
inside ocfs2_shift_tree_depth() (fs/ocfs2/alloc.c:1375), which is
reached when ocfs2_find_branch_target() returns 1. That return value
is only produced when l_next_free_rec equals l_count
(fs/ocfs2/alloc.c:1530). Since l_next_free_rec is 0, l_count must
also be 0 for this condition to hold.

The normal inode read path, ocfs2_validate_inode_block()
(fs/ocfs2/inode.c:1423), does not validate the inline extent list
fields l_count or l_next_free_rec. A filesystem image with these
fields set to 0 in an inode's inline extent list therefore passes
read-time validation without error.

The syzbot console log shows a separate validation error at mount
time — "Invalid dinode #17058: Corrupt state (nlink = 0 or mode =
0)" — indicating that the mounted filesystem contained at least one
other corrupted inode. No reproducer was available in the report, so
the exact mechanism by which the corruption was introduced is not
known.

Here is a breakdown of how the crash is triggered:

1. A write syscall eventually calls into ocfs2_insert_extent() to
record the newly allocated cluster in the inode's extent tree.

2. ocfs2_insert_extent() determines that the extent tree has no room
for a new record and calls ocfs2_grow_tree() (fs/ocfs2/alloc.c:1550).

3. ocfs2_grow_tree() calls ocfs2_find_branch_target()
(fs/ocfs2/alloc.c:1561) to walk the tree and find a node with a
free slot. Because l_tree_depth is 0, the traversal loop
(fs/ocfs2/alloc.c:1491) does not execute. At
fs/ocfs2/alloc.c:1530, the condition

el->l_next_free_rec == el->l_count   /* 0 == 0 */

evaluates to true, so the function returns 1, indicating the tree
must grow by shifting its depth.

4. Back in ocfs2_grow_tree(), shift is 1, so ocfs2_shift_tree_depth()
is called (fs/ocfs2/alloc.c:1581).

5. ocfs2_shift_tree_depth() (fs/ocfs2/alloc.c:1375) allocates a new
extent block and copies the root extent list into it. At
fs/ocfs2/alloc.c:1420, it sets:

eb_el->l_next_free_rec = root_el->l_next_free_rec;  /* = 0 */

The copy loop at fs/ocfs2/alloc.c:1421 runs zero iterations since
l_next_free_rec is 0, so eb_el is left with an empty extent list.

6. ocfs2_shift_tree_depth() then calls
ocfs2_sum_rightmost_rec(eb_el) (fs/ocfs2/alloc.c:1433) to determine
the cluster count for the new root record.

7. Inside ocfs2_sum_rightmost_rec(), i is computed as:

i = le16_to_cpu(eb_el->l_next_free_rec) - 1 = 0 - 1 = -1

The subsequent access to el->l_recs[-1] (fs/ocfs2/alloc.c:1112)
violates the __counted_by_le(l_count) annotation on l_recs[]
(fs/ocfs2/ocfs2_fs.h:472). __counted_by_le is a macro defined in
include/linux/compiler_types.h that expands to __counted_by, which
is the GCC/Clang attribute UBSAN uses for array bounds checking. The
UBSAN error message reports __counted_by rather than __counted_by_le
because the check is performed against the expanded attribute. This
triggers a UBSAN array-index-out-of-bounds panic.

The Proposed Fix

The fix modifies ocfs2_sum_rightmost_rec() with three changes.

First, l_count is read once into a local variable before the bounds
check. The __counted_by_le(l_count) annotation causes the compiler
to emit a separate read of el->l_count at the array access site for
the UBSAN check. Without the local variable, there are two
independent reads of l_count — one for the guard and one at the
array access site, where __counted_by_le causes the compiler to
re-read it for the UBSAN check — creating a TOCTOU between them.
Reading l_count once before the guard reduces this window to the
minimum.

Second, the index is checked against both bounds before dereferencing
l_recs[]. Both checks are sound: i < 0 compares against the constant
0, requiring no trust in any on-disk value; i >= count checks the
invariant l_next_free_rec <= l_count, which holds on any valid
filesystem independent of the actual field values. Neither check can
fire on a valid extent list. Corruption that keeps l_next_free_rec
within [1, l_count] will pass the check and produce an incorrect
result, but this is pre-existing behaviour — not a regression — and
cannot be avoided without an external ground truth for l_count, which
I do not believe exists for the inode's inline extent list.

Third, on an out-of-bounds index, ocfs2_error() is called rather than
silently returning a usable value.

To accommodate these changes the function signature is updated: a
struct ocfs2_caching_info *ci parameter is added for superblock
access, the return type changes from u32 to int, the cluster sum is
returned via a new u32 out-parameter, and the inline qualifier is
removed since the function is no longer a trivial helper. Both
callers, ocfs2_add_branch() and ocfs2_shift_tree_depth(), already
have status variables and bail labels, and are updated to pass
et->et_ci, check the return value, and propagate any error up their
respective call chains.

 fs/ocfs2/alloc.c | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 6e5fd3f12a84..329bda065a7a 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -1103,14 +1103,22 @@ static int ocfs2_create_new_meta_bhs(handle_t *handle,
  * ocfs2_shift_tree_depth() uses this to determine the # clusters
  * value for the new topmost tree record.
  */
-static inline u32 ocfs2_sum_rightmost_rec(struct ocfs2_extent_list  *el)
+static int ocfs2_sum_rightmost_rec(struct ocfs2_caching_info *ci,
+				   struct ocfs2_extent_list *el,
+				   u32 *result)
 {
-	int i;
+	u16 count = le16_to_cpu(el->l_count);
+	int i = le16_to_cpu(el->l_next_free_rec) - 1;
 
-	i = le16_to_cpu(el->l_next_free_rec) - 1;
+	if (i < 0 || i >= count)
+		return ocfs2_error(ocfs2_metadata_cache_get_super(ci),
+				   "Owner %llu has invalid l_next_free_rec %u (l_count %u)\n",
+				   (unsigned long long)ocfs2_metadata_cache_owner(ci),
+				   le16_to_cpu(el->l_next_free_rec), count);
 
-	return le32_to_cpu(el->l_recs[i].e_cpos) +
-		ocfs2_rec_clusters(el, &el->l_recs[i]);
+	*result = le32_to_cpu(el->l_recs[i].e_cpos) +
+		  ocfs2_rec_clusters(el, &el->l_recs[i]);
+	return 0;
 }
 
 /*
@@ -1199,8 +1207,16 @@ static int ocfs2_add_branch(handle_t *handle,
 	new_blocks = le16_to_cpu(el->l_tree_depth);
 
 	eb = (struct ocfs2_extent_block *)(*last_eb_bh)->b_data;
-	new_cpos = ocfs2_sum_rightmost_rec(&eb->h_list);
-	root_end = ocfs2_sum_rightmost_rec(et->et_root_el);
+	status = ocfs2_sum_rightmost_rec(et->et_ci, &eb->h_list, &new_cpos);
+	if (status < 0) {
+		mlog_errno(status);
+		goto bail;
+	}
+	status = ocfs2_sum_rightmost_rec(et->et_ci, et->et_root_el, &root_end);
+	if (status < 0) {
+		mlog_errno(status);
+		goto bail;
+	}
 
 	/*
 	 * If there is a gap before the root end and the real end
@@ -1430,7 +1446,11 @@ static int ocfs2_shift_tree_depth(handle_t *handle,
 		goto bail;
 	}
 
-	new_clusters = ocfs2_sum_rightmost_rec(eb_el);
+	status = ocfs2_sum_rightmost_rec(et->et_ci, eb_el, &new_clusters);
+	if (status < 0) {
+		mlog_errno(status);
+		goto bail;
+	}
 
 	/* update root_bh now */
 	le16_add_cpu(&root_el->l_tree_depth, 1);
-- 
2.47.3

