Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8EF4611FC
	for <ocfs2-devel@lists.linux.dev>; Wed,  3 Jun 2026 12:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780490330; cv=none; b=ChEHFFKYOOF8lYmOtkJY93dyw9Hj6rawrCgHfobsUt+59RO+nlBzWDrkTzu7eCfTRboCHwiZvuxxk+DZKxfrWWIKBRgLn+Ba76hmg7AgCO8aaWfIcJJBbglt+dS2E5s+baEWAHawMLXh8vFmwddLENoeplWilIUMyMEzXuJZypU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780490330; c=relaxed/simple;
	bh=rhOrhGqrLtKL5FbvAwzt50Am28EYyxK/hjYwT71VFKs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dQJe1ZqDMnYmkdA3zqAIRuHHwN8AA7Pul4/tWrjOW4U9NWOGVuQorE2mg9Tvuqe96l1/Jic9wVYMdQNtbk+iJd6irz5GrL54b7pprusb2Kf3194jPe0EbNQx34UV6TGpxVu17OKj1TozBM44R0dsOt0gjthaqvKHOBAIHZ2OZIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org; spf=pass smtp.mailfrom=fastmail.org; dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b=W/NSKjlh; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=HhwVYQor; arc=none smtp.client-ip=202.12.124.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b="W/NSKjlh";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="HhwVYQor"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id 830301300193;
	Wed,  3 Jun 2026 08:38:43 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Wed, 03 Jun 2026 08:38:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1780490323;
	 x=1780493923; bh=NMF7kKc2gK1n4Tzh1GbjI74wVDHa55vUP/SItIqGRwk=; b=
	W/NSKjlhmmLyEl0a86NBo1O8N4jPRcWGjsks/eSinztqgWaVIYMiRnUpCZIumzkb
	1A1Yy1P7OzXHXNp4/3pDPnycvsqOpuOOorVZLyRMGsDge4WwNClhfYo82Gfove3T
	wwfxarGEqAzgJS7DOBly36ACBLSIDkJAhht4tEeXYSjhggSu1AcI7U4urz7KTNqV
	wWRjpuSbZ9yHqBgMCmotKuS8kjAosevB9AwaCF3b7gTdJJ081LlU876Q0u99xDGi
	AJYWH2SL7mFny25npwPkD3SFCIgnrmyIsjVatRY/JpewDQYMqj55ad5U8xmu9A/K
	WLNn0TPqu/jCZhi4yixkDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1780490323; x=
	1780493923; bh=NMF7kKc2gK1n4Tzh1GbjI74wVDHa55vUP/SItIqGRwk=; b=H
	hwVYQorO7PirS/5/Nmymj7p+Zg+emFdxmI1OP5O/47Kl7thOyfOYzyLT/rEvMd+D
	zxTc8oUXGyp+VR6J1yWlcA+OGp8xY0b0cqZsBNFd/AIM9EBxmD9bW9dEuC/DgfeW
	C+McOiARHdogPBMpKWiG1KMhJ0Gc8SgGgWp591iKsQ9GM/AWfPMAI+FFNHBynmuG
	0t3655Wtdn5pMVoRW95xTZ5SgvpcBxmtMGX0VlUPDGoYAbP+9QkiapUIufwAqgp5
	+Yw8u6kqR1nYkSgUkxBPj+l5+J2syhq1/lcuca8DG4g+6Z9HfACjPZL/UgWr1aMQ
	M5nvMmBD7LfYXBIxzB0mw==
X-ME-Sender: <xms:UiAgaqw5J8UdnpvM8hY_wW1f8qgazOlvhdhmW-2Vu5tWrZNO0HpOUw>
    <xme:UiAgaoga4oBqas0774Pz3HeIB3chDRVNAJHA9SwyEY1KX6Zhw2vkcL9YUO6Li8lCA
    1t5_DL08fr_2MEwqS0EeE4bdu1vSorbop05CsfiMuBMZaknZ5tdA9g>
X-ME-Received: <xmr:UiAgaulXv1Sdc45TIK4-UFXl7zhl9borBNGwKochryzqHy2lv9R_p1_CDqw>
X-ME-Proxy-Cause: dmFkZTFDcJKQYwpKPf1/fLpnMfucWfCBviGJMl7aEFmOcyqKJ+Xisv5hQYrdah+0yEKpJv
    iX8cJu5aHaDAMPsxfBnwoNKDi95OKl5NpnUmPAfBqr0EOmk9eKSMBp5EVuCRzHwLEzKxe6
    PjTvcJqNUBWfrOOmKiUusPSo47ADkJNMl/wVFrpzIXdnvzO2JMRNEz0U77023P3vyYfhP2
    3RY1FoSL8BaTeHnmPkEkP2JaCEzmYSTE8JRH3Ct8L/RVxw6bAkQM/WRonfAABix/sQSs2+
    4weAFcYUQsStImzdm+u5M0e2tph3NIl3NWT7CnjojZbI8Pnt7GKLlTgXbdtnDj8cc0Z2Im
    +0go2yLK9wXxDWuQNXPmzinEzVbius2ukXvqDrcb12MJ2QEkZ9NuNHe1fBhmKVnyL6Lzq/
    +PEW/AuVe0OzZ5NjvPwS/avc4hQ8ecSiK8caDlL02zb469ViWdlD2v6KWBI1m0ET1a2eNG
    NQXDzQz5ulC0A1F4jiZbt8NCijGgf73ePnmFFzX+F2N8iAkwLzTGV1CvFFkXxhacLepApx
    EUZ5Y6FRAs5Kw7+uGDC4R0TdZhRqfQsWbFmNBBG/LERLBQkJnJB/n+BfDuCzIspfYK2/AH
    HhK9fU4B9Do1Es1c4XQ28gYVguDnjdR6aHovHuTX4FE6c6OTI9MTXrOZUoSA
X-ME-Proxy: <xmx:UiAgamgy76WwYiK-_AMHDhYAba9PVFqgq0sxc9ujxqoCTwqP47ak2w>
    <xmx:UiAgaq26tn28zMnllnCUbej9UlSQYFSCVCvgNY8LMUD_j6OSz2Gt0g>
    <xmx:UiAganJJTiJdegWgfzwNOXC6_YOU_-O7R_dQIIz4WZV5C22UXWEREg>
    <xmx:UiAgaiwNRPYhJZqFKOHouR-q4XvSbeJFguDTHopsp3klwFowO9FPhQ>
    <xmx:UyAgahKgWXygFNs3J4kOTuB1Uq8iCDhyTNOE7-qNr36QeK9YHEYrIISc>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 3 Jun 2026 08:38:42 -0400 (EDT)
Date: Wed, 3 Jun 2026 07:38:39 -0500
From: Ian Bridges <icb@fastmail.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ocfs2: fix UBSAN array-index-out-of-bounds in
 ocfs2_sum_rightmost_rec
Message-ID: <aiAgT5EvkkCsc6Dl@dev>
References: <ah2ljwKRw-Xsi4Ga@dev>
 <ef679c1c-c8cb-45d4-9624-2bc6346e4415@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ef679c1c-c8cb-45d4-9624-2bc6346e4415@linux.alibaba.com>

On Tue, Jun 02, 2026 at 09:46:56AM +0800, Joseph Qi wrote:
> 
> 
> On 6/1/26 11:30 PM, Ian Bridges wrote:
> > [BUG]
> > On-disk corruption setting l_next_free_rec to 0 in an inode's inline
> > extent list triggers a UBSAN panic on the next write to that file.
> > 
> > [CAUSE]
> > ocfs2_sum_rightmost_rec() computes
> > i = le16_to_cpu(el->l_next_free_rec) - 1
> > and accesses el->l_recs[i] without validating i. When l_next_free_rec
> > is 0, i becomes -1; when l_next_free_rec exceeds l_count, i falls
> > past the end of the array. Either case violates the
> > __counted_by_le(l_count) annotation on l_recs[] and triggers UBSAN.
> > 
> > [FIX]
> > Read l_count once into a local variable to eliminate a TOCTOU between
> > the bounds check and the __counted_by_le-generated check at the array
> > access. Validate i against both bounds before dereferencing l_recs[].
> > On an out-of-bounds index call ocfs2_error() since both cases indicate
> > filesystem corruption.
> > 
> > Update the signature to accept a struct ocfs2_caching_info *ci and
> > return int, with the cluster sum returned through a u32 out-parameter.
> > Update both callers to pass et->et_ci and propagate the error.
> > 
> > Fixes: 2f26f58df041 ("ocfs2: annotate flexible array members with __counted_by_le()")
> > Reported-by: syzbot+be16e33db01e6644db7a@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=be16e33db01e6644db7a
> > Signed-off-by: Ian Bridges <icb@fastmail.org>
> > ---
> > This patch contains a proposed fix for a crash reported by syzbot
> > in ocfs2_grow_tree().
> > 
> > The file names and offsets in this description are from commit
> > 7cb1c5b32a2bfde961fff8d5204526b609bcb30a from this repo:
> > git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
> > 
> > I also have a small test harness that reproduces the original panic,
> > which I can make available as well.
> > 
> > The Bug
> > 
> > The ocfs2_extent_list structure (fs/ocfs2/ocfs2_fs.h:458) contains
> > two fields relevant to this bug: l_count, the total number of extent
> > record slots in the list, and l_next_free_rec, the index of the next
> > unused slot. The extent record array l_recs is annotated
> > __counted_by_le(l_count) (fs/ocfs2/ocfs2_fs.h:472), which instructs
> > UBSAN to bounds-check every access to l_recs against l_count.
> > 
> > ocfs2_sum_rightmost_rec() (fs/ocfs2/alloc.c:1106) is a helper used
> > by both ocfs2_add_branch() and ocfs2_shift_tree_depth() to compute
> > the logical cluster position just past the rightmost occupied extent
> > record. It derives the index of that record as:
> > 
> > i = le16_to_cpu(el->l_next_free_rec) - 1;  /* alloc.c:1110 */
> > 
> > and then accesses el->l_recs[i] (fs/ocfs2/alloc.c:1112) without
> > first checking that i is a valid index. This is the root cause of
> > the bug.
> > 
> > The syzbot report shows index -1 at the crash site, which means
> > l_next_free_rec was 0 at the point of the crash. The crash occurs
> > inside ocfs2_shift_tree_depth() (fs/ocfs2/alloc.c:1375), which is
> > reached when ocfs2_find_branch_target() returns 1. That return value
> > is only produced when l_next_free_rec equals l_count
> > (fs/ocfs2/alloc.c:1530). Since l_next_free_rec is 0, l_count must
> > also be 0 for this condition to hold.
> > 
> > The normal inode read path, ocfs2_validate_inode_block()
> > (fs/ocfs2/inode.c:1423), does not validate the inline extent list
> > fields l_count or l_next_free_rec. A filesystem image with these
> > fields set to 0 in an inode's inline extent list therefore passes
> > read-time validation without error.
> > 
> 
> So why not move the check into ocfs2_validate_inode_block()?
> Seems that is the right place to do this kind of work.
> 
> Thanks,
> Joseph

When I wrote the patch, I tried to place the check as close to the use
to prevent potential TOCTOU issues. However, after reviewing the code
again, I do thing ofcs2_validate_inode_block() is the correct location
for check. I will work on resubmitting an updated patch.

Ian

> 
> > The syzbot console log shows a separate validation error at mount
> > time — "Invalid dinode #17058: Corrupt state (nlink = 0 or mode =
> > 0)" — indicating that the mounted filesystem contained at least one
> > other corrupted inode. No reproducer was available in the report, so
> > the exact mechanism by which the corruption was introduced is not
> > known.
> > 
> > Here is a breakdown of how the crash is triggered:
> > 
> > 1. A write syscall eventually calls into ocfs2_insert_extent() to
> > record the newly allocated cluster in the inode's extent tree.
> > 
> > 2. ocfs2_insert_extent() determines that the extent tree has no room
> > for a new record and calls ocfs2_grow_tree() (fs/ocfs2/alloc.c:1550).
> > 
> > 3. ocfs2_grow_tree() calls ocfs2_find_branch_target()
> > (fs/ocfs2/alloc.c:1561) to walk the tree and find a node with a
> > free slot. Because l_tree_depth is 0, the traversal loop
> > (fs/ocfs2/alloc.c:1491) does not execute. At
> > fs/ocfs2/alloc.c:1530, the condition
> > 
> > el->l_next_free_rec == el->l_count   /* 0 == 0 */
> > 
> > evaluates to true, so the function returns 1, indicating the tree
> > must grow by shifting its depth.
> > 
> > 4. Back in ocfs2_grow_tree(), shift is 1, so ocfs2_shift_tree_depth()
> > is called (fs/ocfs2/alloc.c:1581).
> > 
> > 5. ocfs2_shift_tree_depth() (fs/ocfs2/alloc.c:1375) allocates a new
> > extent block and copies the root extent list into it. At
> > fs/ocfs2/alloc.c:1420, it sets:
> > 
> > eb_el->l_next_free_rec = root_el->l_next_free_rec;  /* = 0 */
> > 
> > The copy loop at fs/ocfs2/alloc.c:1421 runs zero iterations since
> > l_next_free_rec is 0, so eb_el is left with an empty extent list.
> > 
> > 6. ocfs2_shift_tree_depth() then calls
> > ocfs2_sum_rightmost_rec(eb_el) (fs/ocfs2/alloc.c:1433) to determine
> > the cluster count for the new root record.
> > 
> > 7. Inside ocfs2_sum_rightmost_rec(), i is computed as:
> > 
> > i = le16_to_cpu(eb_el->l_next_free_rec) - 1 = 0 - 1 = -1
> > 
> > The subsequent access to el->l_recs[-1] (fs/ocfs2/alloc.c:1112)
> > violates the __counted_by_le(l_count) annotation on l_recs[]
> > (fs/ocfs2/ocfs2_fs.h:472). __counted_by_le is a macro defined in
> > include/linux/compiler_types.h that expands to __counted_by, which
> > is the GCC/Clang attribute UBSAN uses for array bounds checking. The
> > UBSAN error message reports __counted_by rather than __counted_by_le
> > because the check is performed against the expanded attribute. This
> > triggers a UBSAN array-index-out-of-bounds panic.
> > 
> > The Proposed Fix
> > 
> > The fix modifies ocfs2_sum_rightmost_rec() with three changes.
> > 
> > First, l_count is read once into a local variable before the bounds
> > check. The __counted_by_le(l_count) annotation causes the compiler
> > to emit a separate read of el->l_count at the array access site for
> > the UBSAN check. Without the local variable, there are two
> > independent reads of l_count — one for the guard and one at the
> > array access site, where __counted_by_le causes the compiler to
> > re-read it for the UBSAN check — creating a TOCTOU between them.
> > Reading l_count once before the guard reduces this window to the
> > minimum.
> > 
> > Second, the index is checked against both bounds before dereferencing
> > l_recs[]. Both checks are sound: i < 0 compares against the constant
> > 0, requiring no trust in any on-disk value; i >= count checks the
> > invariant l_next_free_rec <= l_count, which holds on any valid
> > filesystem independent of the actual field values. Neither check can
> > fire on a valid extent list. Corruption that keeps l_next_free_rec
> > within [1, l_count] will pass the check and produce an incorrect
> > result, but this is pre-existing behaviour — not a regression — and
> > cannot be avoided without an external ground truth for l_count, which
> > I do not believe exists for the inode's inline extent list.
> > 
> > Third, on an out-of-bounds index, ocfs2_error() is called rather than
> > silently returning a usable value.
> > 
> > To accommodate these changes the function signature is updated: a
> > struct ocfs2_caching_info *ci parameter is added for superblock
> > access, the return type changes from u32 to int, the cluster sum is
> > returned via a new u32 out-parameter, and the inline qualifier is
> > removed since the function is no longer a trivial helper. Both
> > callers, ocfs2_add_branch() and ocfs2_shift_tree_depth(), already
> > have status variables and bail labels, and are updated to pass
> > et->et_ci, check the return value, and propagate any error up their
> > respective call chains.
