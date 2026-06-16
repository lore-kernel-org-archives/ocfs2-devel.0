Received: from flow-a1-smtp.messagingengine.com (flow-a1-smtp.messagingengine.com [103.168.172.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1057F428837
	for <ocfs2-devel@lists.linux.dev>; Tue, 16 Jun 2026 10:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781605494; cv=none; b=trnT+dP4YkS95HbkugJOt5qYnp2KBDHCoVUgNa0JAuJbbbx5iZ5VD1DjABTVYs1LH3XTlEujM6v10794o3qo5oWW/XP5CbZg8BcXGZGkXKUWO4By02kDgCHueVrpLYtDXNeMAojBRHHzGWnr0hx1sbEZoaKDdhZXtqCyV27odPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781605494; c=relaxed/simple;
	bh=TH3TiIppWIbm/nj35twEyG6g+3WWxUZ8BWTs90Tc8GI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hu8Nlzi+pD/oRTD7tBY3j+5sr8CuGxEo3WOfN0hy0d0odPaZX5MHv9zBa8175ABr64FvEweOuEL9FVc0dQA9b03LFoHRCS4N1S9u3u2tMAl7aewpXmCF28379k0akSw+EkRxDByEY6l5nMLIeSXNoYmvZtsagziN+dPlxDRiD4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org; spf=pass smtp.mailfrom=fastmail.org; dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b=ff3NMvKI; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ax2BF82o; arc=none smtp.client-ip=103.168.172.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b="ff3NMvKI";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ax2BF82o"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.phl.internal (Postfix) with ESMTP id 4158513806A2;
	Tue, 16 Jun 2026 06:24:51 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Tue, 16 Jun 2026 06:24:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1781605491; x=1781609091; bh=MKIGClAUH8
	AcNh4xi0z0A0UkrGfbxLD3MJTWWthpbio=; b=ff3NMvKImG1nsxBzOixPY9QVer
	8h2Cf8M1Mr7eGLaYvhzhW+h/quj9Vs8BmTCJPo/Zdf1pB1t932WfToWy0mRUxLkJ
	wluQWVyssKE0KHVGIsk5Ab02yraOn5rbzmnrD8HqhLy6QFkw3CqVm36Z5E7ujkxf
	vQTrkY0ci0xwpKyQC/ZOTWWloiP3kGrYcCI5M12FUHgKkLjZ4n6WMasD3+MSLP0H
	KLX8KlB1B1f+X7DHkiyDlEUfw9NjJS9C1OkOsUX7BmJ6jSpudR0fczshg8lt7htH
	rMvSLFnilYpywl7L1ujUcaIrpf3FqDN+iwyEb+wgzgejhhmk93QKy2H2Tf5A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1781605491; x=1781609091; bh=MKIGClAUH8AcNh4xi0z0A0UkrGfbxLD3MJT
	WWthpbio=; b=ax2BF82oohALNnxUmJw9oIFi/od7wiRW21YH6WOh2vzusanB0O3
	VATw7MlwedfppHnkmHeuYkP1DKkfY7L0nQSJBJc7CZVA/wrk55cY1ps+qSSR6OoJ
	sI8PrNWyGNXsB7exprpEvCl7oB7E2S/rw3JyuFaTUtOJnmeefS9/BBkHM4obi0Hy
	aF2yx/5I2HeQXUWH7so3QNzjdl6VKu4mIYKctwOlEhCh3gUOWpvnPzBH2a5squEK
	CBRMJUrlLPF92JpGnACxOBLaYj/cTTnwIoBoucy3jX0dtWRnRaMVAzNnibltnl1Q
	8dbkMiItmI1G7LOH/qpCaeoPuax340UBTjg==
X-ME-Sender: <xms:ciQxaqKWJv-8kmetstcehh_l63lRu9KZuXPccgXwdFxZlChg04tQEA>
    <xme:ciQxarEIGKyN1F5Fk40gABq86Qee6mK3VCb5mBETfdBsEf7WjoyaOB98-35fyweR-
    eaVTG9otj71lPcxduQoTTTGRP4rLvGIOc0vhBMLspkC_9Zwhr8XpPP8>
X-ME-Received: <xmr:ciQxamQBcLXfmItovintSpuNBa-b5_LoM5MvO7AXUfqCYpmM_c6oXrXmHtw>
X-ME-Proxy-Cause: dmFkZTEDPxP4Y6tg5g8f6UP7Xq4MvyyPQH6KVERBpA1HLB7fLzwV6ccGkmTUfNm2W/OY7J
    LQGp5rbJMvt+AV39wd3Pt12I2tpO8GSpYYJXq0V4h1sV9luluV+lxePrHwFPotaLKScZs/
    q8HDOE5osqzHOfmrwwKZ1fmaex2dl1gv1SOp0Eyzyfpl1I2XQWILJljGRFUjOEGhYV2DqN
    PqBg42Ekjf3SL5tl/Tb3mbb0OllC/aSXCDp9+sR9X/5X2d5eWsKgEB1wVgLiWcRNyvoWvQ
    ETUfarxI1DlTPWk6W0C2QhLjuEGfp83BKPl3nnnA9hEahcjedqkKU30UdPPl08Z5TM3MQ2
    Bgj5CG+hEWbHBkFSNZDTxr97z8kl3J6UwZgIiMoTxogPCCUE3O43wbmpFjPoBhaL+35LPZ
    xp8vxpVxM3qY0Vjgc1yUYyl1dqODIBqgas8If7uBuVDXYcZraEKCniAOnAh88+Fg6iPHxi
    UYxe/AEpWlHpJjJo+77sF36k8nlGTusOtbYdoD3GVvubzgaglYZObrRd3hQjOGgEsQ7nT7
    J5DvHe5FNmIqBRZ+JStv6i/6LcwCqAR1U7AYtAJSZuONSegHdvbm8rzHYulyPvj4+aUkBx
    fmwdg4sx+wyjNH3De4huxb7sXBHdo9p0AVXLofSdsUbUgi5ZHmRWat7lR/wQ
X-ME-Proxy: <xmx:ciQxavewkdkH0rKXPvD-nWKLVgvL5AtgpjhN09DZBu3Glao7P6gejw>
    <xmx:ciQxatqdfSZ_6fgGQCUJOZdkizMrAPJv4JQD4Kfsnl2W2H2uj_ds7Q>
    <xmx:ciQxao-BM7SD_hT8Zr_NvWrLUcSKTy--CVi8Dk9o5isBDyCZkHsnKw>
    <xmx:ciQxahdzntj2OPuI-n30xS3qsJd1uX1oSqyJgW710BrBGZtITQfZEw>
    <xmx:cyQxav05V-kDPAN-ajPugnmsU1YqrNFm9KCcgkZtamBZ5CBBvgUv5d4z>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 16 Jun 2026 06:24:50 -0400 (EDT)
Date: Tue, 16 Jun 2026 05:24:47 -0500
From: Ian Bridges <icb@fastmail.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	"ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ocfs2: fix out-of-bounds read in
 ocfs2_duplicate_inline_data()
Message-ID: <ajEkb9FVecEqHh6F@dev>
References: <ai1byUgMNULbZuLs@dev>
 <c86cd029-4d0c-499a-a763-763f42352c92@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c86cd029-4d0c-499a-a763-763f42352c92@linux.alibaba.com>

On Tue, Jun 16, 2026 at 11:49:13AM +0800, Joseph Qi wrote:
> 
> 
> On 6/13/26 9:31 PM, Ian Bridges wrote:
> > [BUG]
> > copy_file_range() (or reflink) of an inline-data file can read and write
> > out of bounds in ocfs2_duplicate_inline_data() when the source inode's
> > on-disk id_count exceeds the inline-data capacity. KASAN reports a
> > use-after-free read past the end of the inode block buffer.
> > 
> > [CAUSE]
> > ocfs2_duplicate_inline_data() copies the source inline area with a
> > memcpy() whose length is le16_to_cpu() of the on-disk id_count, taken
> > straight from the source inode buffer with no bounds check. The inline
> > capacity is at most ocfs2_max_inline_data_with_xattr() (3896 bytes for a
> > 4K block); a larger id_count overruns the 4096-byte source and target
> > inode blocks into the adjacent page. ocfs2_validate_inode_block() already
> > bounds id_count, but it only runs on a disk read; an inode buffer that
> > was validated and then mutated in the block-device page cache (for
> > example by a concurrent LOOP_SET_STATUS invalidating the loop bdev) stays
> > up-to-date and is consumed without re-validation.
> > 
> > [FIX]
> > Bound the source id_count against ocfs2_max_inline_data_with_xattr() in
> > ocfs2_duplicate_inline_data() before the memcpy, and return an error via
> > ocfs2_error() if it is too large.
> > 
> > Fixes: 2f48d593b6ce ("ocfs2: duplicate inline data properly during reflink.")
> > Reported-by: syzbot+e400b192d6ca035354ee@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=e400b192d6ca035354ee
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Ian Bridges <icb@fastmail.org>
> > ---
> > This patch contains a proposed fix for a crash reported by syzbot
> > in ocfs2_duplicate_inline_data().
> > 
> > The file names and offsets in this description are from commit
> > 7cb1c5b32a2bfde961fff8d5204526b609bcb30a from this repo:
> > git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
> > 
> > I also have a small test harness that reproduces the original crash
> > deterministically, which I can make available as well.
> > 
> > The Bug
> > 
> > OCFS2 stores the data of a small file directly inside the inode block,
> > in the space that would otherwise hold the extent list (the inline-data
> > feature). The on-disk container is struct ocfs2_inline_data
> > (fs/ocfs2/ocfs2_fs.h:652):
> > 
> >     __le16  id_count;
> >     __le16  id_reserved0;
> >     __le32  id_reserved1;
> >     __u8    id_data[] __counted_by_le(id_count);
> > 
> > id_count is the capacity of the inline area, not the used length; it is
> > set at creation to ocfs2_max_inline_data_with_xattr()
> > (fs/ocfs2/namei.c:589). For a 4K block that capacity is
> > 4096 - offsetof(struct ocfs2_dinode, id2.i_data.id_data) = 3896 bytes,
> > less any inline-xattr reservation (fs/ocfs2/ocfs2_fs.h:1252).
> > 
> > When copy_file_range() (or FICLONE) targets two files on the same ocfs2
> > mount and the source is inline, ocfs2 copies the inline bytes directly in
> > ocfs2_duplicate_inline_data() (fs/ocfs2/refcounttree.c:3918). It memcpys
> > the source id_data array into the target's, using le16_to_cpu() of the
> > source id_count as the copy length (fs/ocfs2/refcounttree.c:3946).
> > 
> > id_count is taken straight from the source inode buffer as the copy
> > length, with no bounds check. If it exceeds the 3896-byte capacity the
> > memcpy runs off the end of the source inode block, and because the same
> > count is the write length, off the end of the target block too. Both are
> > 4096-byte buffers, so the access spills into the adjacent page. syzbot's
> > report is the read side: "Read of size 8483 ..." in
> > ocfs2_duplicate_inline_data, 8483 being the bad id_count.
> > 
> > How it is reached:
> > 
> > 1. With both files on the same super block, vfs_copy_file_range()
> >    (fs/read_write.c:1554) has no copy_file_range method to call and falls
> >    back to ocfs2's remap_file_range method, ocfs2_remap_file_range()
> >    (fs/ocfs2/file.c:2701), with REMAP_FILE_CAN_SHORTEN
> >    (fs/read_write.c:1599). An over-long copy length is clamped to the
> >    source i_size.
> > 
> > 2. ocfs2_remap_file_range() calls ocfs2_reflink_inodes_lock()
> >    (fs/ocfs2/refcounttree.c:4698), which takes the inode cluster lock via
> >    ocfs2_inode_lock_nested() (fs/ocfs2/refcounttree.c:4743), yielding the
> >    source inode buffer s_bh, then calls ocfs2_reflink_remap_blocks()
> >    (fs/ocfs2/refcounttree.c:4599).
> > 
> > 3. For a whole-file copy of an inline source
> >    (fs/ocfs2/refcounttree.c:4622) it takes the inline fast path:
> >    ocfs2_duplicate_inline_data(s_inode, s_bh, ...)
> >    (fs/ocfs2/refcounttree.c:4625), which runs the memcpy above. A corrupt
> >    id_count of 8483 overruns the buffers and KASAN reports the
> >    out-of-bounds read into the freed neighbouring page.
> > 
> > The bad id_count is not present on disk in a freshly read inode.
> > ocfs2_validate_inode_block() (fs/ocfs2/inode.c:1423) already rejects an
> > id_count larger than ocfs2_max_inline_data_with_xattr() at read time
> > (fs/ocfs2/inode.c:1508, added by 7bc5da4842be for the write-side sibling
> > of this bug), and that check is in the crashing kernel. The bad value
> > instead reaches s_bh through a buffer that was validated once and then
> > mutated underneath ocfs2.
> > 
> > The fs is on a loop device; while the copy runs, the test harness issues
> > LOOP_SET_STATUS with a changed lo_offset/lo_sizelimit. loop_set_status()
> > (drivers/block/loop.c:1227) then calls invalidate_bdev()
> > (drivers/block/loop.c:1246), dropping the loop bdev pages that back
> > ocfs2's cached inode buffer. When the page is refilled from the
> > offset-shifted backing it holds neighboring garbage, and the inline fast
> > path reads that id_count without re-validating. (The report's "page last
> > freed by loop_set_status" is this same churn.) The test harness produces the
> > state deterministically by writing an oversized id_count straight into the
> > loop device's page cache at the inode's offset, then issuing the copy.
> > 
> > The Proposed Fix
> > 
> > The fix adds the bound check to ocfs2_duplicate_inline_data() itself,
> > before the memcpy. If the source id_count exceeds
> > ocfs2_max_inline_data_with_xattr() for the source inode, the inode is
> > corrupt, so report it with ocfs2_error() and return. id_count is read
> > once into a local used for both the check and the copy, so the value
> > cannot change between them.
> > 
> > The natural instinct, and what the write-side sibling 7bc5da4842be did,
> > is to reject the value at read time in ocfs2_validate_inode_block(). That
> > is right for corruption already present on disk when the inode is read,
> > but it does not stop this bug.
> > 
> > ocfs2_validate_inode_block() does not run on every use of a buffer; it
> > runs at most once, as the post-I/O callback of a disk read.
> > ocfs2_read_blocks() (fs/ocfs2/buffer_head_io.c:193) goes to disk only
> > when the buffer is not already up-to-date (fs/ocfs2/buffer_head_io.c:271);
> > only that path sets NeedsValidate (fs/ocfs2/buffer_head_io.c:327-328),
> > and the callback runs only when that flag is set
> > (fs/ocfs2/buffer_head_io.c:376-382). An already up-to-date buffer is
> > returned with no I/O and no validation. The validator therefore checks
> > the bytes when read from disk, not when used.
> > 
> > Because of this, the patch checks the invariant where the value is consumed
> > (the memcpy site), the only place that sees the live bytes. Putting it in
> > ocfs2_duplicate_inline_data() also covers both callers
> > (fs/ocfs2/refcounttree.c:4107 and :4625) and bounds both the source read
> > and the target write, since one count drives both.
> > 
> >  fs/ocfs2/refcounttree.c | 17 +++++++++++++++--
> >  1 file changed, 15 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> > index 8eee5be4d1ed..eb3ddcaaa049 100644
> > --- a/fs/ocfs2/refcounttree.c
> > +++ b/fs/ocfs2/refcounttree.c
> > @@ -3925,9 +3925,23 @@ static int ocfs2_duplicate_inline_data(struct inode *s_inode,
> >  	struct ocfs2_super *osb = OCFS2_SB(s_inode->i_sb);
> >  	struct ocfs2_dinode *s_di = (struct ocfs2_dinode *)s_bh->b_data;
> >  	struct ocfs2_dinode *t_di = (struct ocfs2_dinode *)t_bh->b_data;
> > +	u16 id_count = le16_to_cpu(s_di->id2.i_data.id_count);
> >  
> >  	BUG_ON(!(OCFS2_I(s_inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL));
> >  
> > +	/*
> > +	 * id_count was validated by ocfs2_validate_inode_block() when the inode
> > +	 * was read, but the cached buffer can be modified afterward, so re-check
> > +	 * it before the memcpy.
> > +	 */
> 
> Ummm... If this is the case, I think it is a code bug in other place.
> 
> Not sure if this is relevant with
> https://lore.kernel.org/ocfs2-devel/20260529190101.a72cec8337c1b5e908e3afa0@linux-foundation.org/T/#t
> 
> Thanks,
> Joseph

Thank you for pointing me to that thread. After review, I believe that patch
significantly mitigates the issue I described in the first email in this thread.
While the TOCTOU issue still exists after the application of that patch (and
the reproducer code confirms this), it is only triggerable by a user with
CAP_SYS_ADMIN and on a kernel configured with bdev_allow_write_mounted set to
TRUE. Requiring CAP_SYS_ADMIN likely places this scenario outside a reasonable
threat model, so I'm withdrawing the patch submission.

Ian

> 
> > +	if (id_count > ocfs2_max_inline_data_with_xattr(s_inode->i_sb, s_di)) {
> > +		ret = ocfs2_error(s_inode->i_sb,
> > +				  "Inode %llu has invalid inline data id_count %u\n",
> > +				  (unsigned long long)OCFS2_I(s_inode)->ip_blkno,
> > +				  id_count);
> > +		goto out;
> > +	}
> > +
> >  	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
> >  	if (IS_ERR(handle)) {
> >  		ret = PTR_ERR(handle);
> > @@ -3943,8 +3957,7 @@ static int ocfs2_duplicate_inline_data(struct inode *s_inode,
> >  	}
> >  
> >  	t_di->id2.i_data.id_count = s_di->id2.i_data.id_count;
> > -	memcpy(t_di->id2.i_data.id_data, s_di->id2.i_data.id_data,
> > -	       le16_to_cpu(s_di->id2.i_data.id_count));
> > +	memcpy(t_di->id2.i_data.id_data, s_di->id2.i_data.id_data, id_count);
> >  	spin_lock(&OCFS2_I(t_inode)->ip_lock);
> >  	OCFS2_I(t_inode)->ip_dyn_features |= OCFS2_INLINE_DATA_FL;
> >  	t_di->i_dyn_features = cpu_to_le16(OCFS2_I(t_inode)->ip_dyn_features);
> 
