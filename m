Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFC81ACEDE
	for <ocfs2-devel@lists.linux.dev>; Tue,  2 Jun 2026 01:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780364823; cv=none; b=jyD4tkXZG7tAWj6TTtSwy5xTjc1BN5/9oYJSADyT+WSsfMn29T9/YTgX9PSQiwm6usy4PeB1ymHzvvdbo9zzeq33yv2jXnw4S3FGM2NGPuQctfVmIdyH/qOso4YmL2ItCDy0Guwf6hoZuiW5qDavP44w+60yn6U4fR0UB6lRDRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780364823; c=relaxed/simple;
	bh=Ze7ol1cQDsK49Z0BRTgCTwpaaW3glHxZbCKXLKpveKU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=FpgtxkVHPP9Yizi/BIFOgWZl6Wt0gyqXFUC4WUZdoYteXa8rb/c56gAGIXM3f6UfbEpeKjUc252SpUB1WnAdvq3n9ZBO+9mPg/sUl3LtHTMlbCbHpwGpnjOutyqb/oP2UmZMeLoGX5LyeszxW0OHPCJPysgPKdLupVPgZLoujfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=CXF71FIF; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="CXF71FIF"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780364818; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=AQm6EYn+Fi9AfvtonZdXgEsAZjFZAGHDm3h+LYtEaKw=;
	b=CXF71FIFIIMakJhUqdgAgSug5z2uBMq7zb0FJIT5pupNUJlg99wXA5R3uGsh4p5TXnijA604GjQJyNzx+kECFcQt89bqz+bEd8SOyz1yvUvo2gyN42wCW/Ztk3xBZTe8Soo6KFR/68VXmwUtjLmKX6Po23nnaJAG/v6VB84rdEM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R591e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X42Q9s3_1780364816;
Received: from 30.221.145.10(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X42Q9s3_1780364816 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 02 Jun 2026 09:46:57 +0800
Message-ID: <ef679c1c-c8cb-45d4-9624-2bc6346e4415@linux.alibaba.com>
Date: Tue, 2 Jun 2026 09:46:56 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix UBSAN array-index-out-of-bounds in
 ocfs2_sum_rightmost_rec
To: Ian Bridges <icb@fastmail.org>
References: <ah2ljwKRw-Xsi4Ga@dev>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <ah2ljwKRw-Xsi4Ga@dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 6/1/26 11:30 PM, Ian Bridges wrote:
> [BUG]
> On-disk corruption setting l_next_free_rec to 0 in an inode's inline
> extent list triggers a UBSAN panic on the next write to that file.
> 
> [CAUSE]
> ocfs2_sum_rightmost_rec() computes
> i = le16_to_cpu(el->l_next_free_rec) - 1
> and accesses el->l_recs[i] without validating i. When l_next_free_rec
> is 0, i becomes -1; when l_next_free_rec exceeds l_count, i falls
> past the end of the array. Either case violates the
> __counted_by_le(l_count) annotation on l_recs[] and triggers UBSAN.
> 
> [FIX]
> Read l_count once into a local variable to eliminate a TOCTOU between
> the bounds check and the __counted_by_le-generated check at the array
> access. Validate i against both bounds before dereferencing l_recs[].
> On an out-of-bounds index call ocfs2_error() since both cases indicate
> filesystem corruption.
> 
> Update the signature to accept a struct ocfs2_caching_info *ci and
> return int, with the cluster sum returned through a u32 out-parameter.
> Update both callers to pass et->et_ci and propagate the error.
> 
> Fixes: 2f26f58df041 ("ocfs2: annotate flexible array members with __counted_by_le()")
> Reported-by: syzbot+be16e33db01e6644db7a@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=be16e33db01e6644db7a
> Signed-off-by: Ian Bridges <icb@fastmail.org>
> ---
> This patch contains a proposed fix for a crash reported by syzbot
> in ocfs2_grow_tree().
> 
> The file names and offsets in this description are from commit
> 7cb1c5b32a2bfde961fff8d5204526b609bcb30a from this repo:
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
> 
> I also have a small test harness that reproduces the original panic,
> which I can make available as well.
> 
> The Bug
> 
> The ocfs2_extent_list structure (fs/ocfs2/ocfs2_fs.h:458) contains
> two fields relevant to this bug: l_count, the total number of extent
> record slots in the list, and l_next_free_rec, the index of the next
> unused slot. The extent record array l_recs is annotated
> __counted_by_le(l_count) (fs/ocfs2/ocfs2_fs.h:472), which instructs
> UBSAN to bounds-check every access to l_recs against l_count.
> 
> ocfs2_sum_rightmost_rec() (fs/ocfs2/alloc.c:1106) is a helper used
> by both ocfs2_add_branch() and ocfs2_shift_tree_depth() to compute
> the logical cluster position just past the rightmost occupied extent
> record. It derives the index of that record as:
> 
> i = le16_to_cpu(el->l_next_free_rec) - 1;  /* alloc.c:1110 */
> 
> and then accesses el->l_recs[i] (fs/ocfs2/alloc.c:1112) without
> first checking that i is a valid index. This is the root cause of
> the bug.
> 
> The syzbot report shows index -1 at the crash site, which means
> l_next_free_rec was 0 at the point of the crash. The crash occurs
> inside ocfs2_shift_tree_depth() (fs/ocfs2/alloc.c:1375), which is
> reached when ocfs2_find_branch_target() returns 1. That return value
> is only produced when l_next_free_rec equals l_count
> (fs/ocfs2/alloc.c:1530). Since l_next_free_rec is 0, l_count must
> also be 0 for this condition to hold.
> 
> The normal inode read path, ocfs2_validate_inode_block()
> (fs/ocfs2/inode.c:1423), does not validate the inline extent list
> fields l_count or l_next_free_rec. A filesystem image with these
> fields set to 0 in an inode's inline extent list therefore passes
> read-time validation without error.
> 

So why not move the check into ocfs2_validate_inode_block()?
Seems that is the right place to do this kind of work.

Thanks,
Joseph

> The syzbot console log shows a separate validation error at mount
> time — "Invalid dinode #17058: Corrupt state (nlink = 0 or mode =
> 0)" — indicating that the mounted filesystem contained at least one
> other corrupted inode. No reproducer was available in the report, so
> the exact mechanism by which the corruption was introduced is not
> known.
> 
> Here is a breakdown of how the crash is triggered:
> 
> 1. A write syscall eventually calls into ocfs2_insert_extent() to
> record the newly allocated cluster in the inode's extent tree.
> 
> 2. ocfs2_insert_extent() determines that the extent tree has no room
> for a new record and calls ocfs2_grow_tree() (fs/ocfs2/alloc.c:1550).
> 
> 3. ocfs2_grow_tree() calls ocfs2_find_branch_target()
> (fs/ocfs2/alloc.c:1561) to walk the tree and find a node with a
> free slot. Because l_tree_depth is 0, the traversal loop
> (fs/ocfs2/alloc.c:1491) does not execute. At
> fs/ocfs2/alloc.c:1530, the condition
> 
> el->l_next_free_rec == el->l_count   /* 0 == 0 */
> 
> evaluates to true, so the function returns 1, indicating the tree
> must grow by shifting its depth.
> 
> 4. Back in ocfs2_grow_tree(), shift is 1, so ocfs2_shift_tree_depth()
> is called (fs/ocfs2/alloc.c:1581).
> 
> 5. ocfs2_shift_tree_depth() (fs/ocfs2/alloc.c:1375) allocates a new
> extent block and copies the root extent list into it. At
> fs/ocfs2/alloc.c:1420, it sets:
> 
> eb_el->l_next_free_rec = root_el->l_next_free_rec;  /* = 0 */
> 
> The copy loop at fs/ocfs2/alloc.c:1421 runs zero iterations since
> l_next_free_rec is 0, so eb_el is left with an empty extent list.
> 
> 6. ocfs2_shift_tree_depth() then calls
> ocfs2_sum_rightmost_rec(eb_el) (fs/ocfs2/alloc.c:1433) to determine
> the cluster count for the new root record.
> 
> 7. Inside ocfs2_sum_rightmost_rec(), i is computed as:
> 
> i = le16_to_cpu(eb_el->l_next_free_rec) - 1 = 0 - 1 = -1
> 
> The subsequent access to el->l_recs[-1] (fs/ocfs2/alloc.c:1112)
> violates the __counted_by_le(l_count) annotation on l_recs[]
> (fs/ocfs2/ocfs2_fs.h:472). __counted_by_le is a macro defined in
> include/linux/compiler_types.h that expands to __counted_by, which
> is the GCC/Clang attribute UBSAN uses for array bounds checking. The
> UBSAN error message reports __counted_by rather than __counted_by_le
> because the check is performed against the expanded attribute. This
> triggers a UBSAN array-index-out-of-bounds panic.
> 
> The Proposed Fix
> 
> The fix modifies ocfs2_sum_rightmost_rec() with three changes.
> 
> First, l_count is read once into a local variable before the bounds
> check. The __counted_by_le(l_count) annotation causes the compiler
> to emit a separate read of el->l_count at the array access site for
> the UBSAN check. Without the local variable, there are two
> independent reads of l_count — one for the guard and one at the
> array access site, where __counted_by_le causes the compiler to
> re-read it for the UBSAN check — creating a TOCTOU between them.
> Reading l_count once before the guard reduces this window to the
> minimum.
> 
> Second, the index is checked against both bounds before dereferencing
> l_recs[]. Both checks are sound: i < 0 compares against the constant
> 0, requiring no trust in any on-disk value; i >= count checks the
> invariant l_next_free_rec <= l_count, which holds on any valid
> filesystem independent of the actual field values. Neither check can
> fire on a valid extent list. Corruption that keeps l_next_free_rec
> within [1, l_count] will pass the check and produce an incorrect
> result, but this is pre-existing behaviour — not a regression — and
> cannot be avoided without an external ground truth for l_count, which
> I do not believe exists for the inode's inline extent list.
> 
> Third, on an out-of-bounds index, ocfs2_error() is called rather than
> silently returning a usable value.
> 
> To accommodate these changes the function signature is updated: a
> struct ocfs2_caching_info *ci parameter is added for superblock
> access, the return type changes from u32 to int, the cluster sum is
> returned via a new u32 out-parameter, and the inline qualifier is
> removed since the function is no longer a trivial helper. Both
> callers, ocfs2_add_branch() and ocfs2_shift_tree_depth(), already
> have status variables and bail labels, and are updated to pass
> et->et_ci, check the return value, and propagate any error up their
> respective call chains.
