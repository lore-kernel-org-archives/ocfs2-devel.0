Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6E92F8E96
	for <ocfs2-devel@lists.linux.dev>; Tue, 16 Jun 2026 03:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781581769; cv=none; b=JnEBxJ1tYqqiN8MV6bFLxiDLUB1WpbqbzPkio0hkpoCAZbryu8u5524NqKQdsADj/2vGoUGcJrhSw+S4iUcmSYDJeKORE7iM5V185MNZL4Mu/XlgmtF1zNlYkPA3xJ3qzSlzSxLUQqz4F7Ge6g2/yjh88WnLcIUB/Q/4SMnpU+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781581769; c=relaxed/simple;
	bh=VbSEQWpY70Pw6CCdTsoFz9ygCaBEpH3QlMWci+Am2fU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=B2N2KKJ9+tIk6AaKz1q5TzXwvVHICK7shjsaVOmi/Miezv7sPIsiQxBSZ3AkAuUTqchcgwssAHWBsENiJwcDf5Rd67GyIeq6NXwaeMtuwoZyaM9q+cqnpW0tA1IN9LxKT6/aKkSjgojCSwb9KedIqIdy5B9RoolKgshKE5yGQcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=wDwvNrX1; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="wDwvNrX1"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781581756; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=8moniJIKHxW29OCgFGCqqKe60x3wkhkZVp7syH/ImOg=;
	b=wDwvNrX1rqircNFvm1fx2Ye5IbGNfnCxhUeBSgo0lU+M116nS7BjnQFUmW10RfgxATd7Iq0ctMyNThh8G3RpX9zLkn959/gb5FwdExsW6855SXRWq7eY78Rz9b3EmgpDDx0aadqDrpTC4o/Clg4Ch6g/YIoxy6mNfBGSslxJu/E=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X4zvE19_1781581755;
Received: from 30.221.145.41(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X4zvE19_1781581755 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 16 Jun 2026 11:49:15 +0800
Message-ID: <c86cd029-4d0c-499a-a763-763f42352c92@linux.alibaba.com>
Date: Tue, 16 Jun 2026 11:49:13 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix out-of-bounds read in
 ocfs2_duplicate_inline_data()
To: Ian Bridges <icb@fastmail.org>
References: <ai1byUgMNULbZuLs@dev>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <ai1byUgMNULbZuLs@dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/13/26 9:31 PM, Ian Bridges wrote:
> [BUG]
> copy_file_range() (or reflink) of an inline-data file can read and write
> out of bounds in ocfs2_duplicate_inline_data() when the source inode's
> on-disk id_count exceeds the inline-data capacity. KASAN reports a
> use-after-free read past the end of the inode block buffer.
> 
> [CAUSE]
> ocfs2_duplicate_inline_data() copies the source inline area with a
> memcpy() whose length is le16_to_cpu() of the on-disk id_count, taken
> straight from the source inode buffer with no bounds check. The inline
> capacity is at most ocfs2_max_inline_data_with_xattr() (3896 bytes for a
> 4K block); a larger id_count overruns the 4096-byte source and target
> inode blocks into the adjacent page. ocfs2_validate_inode_block() already
> bounds id_count, but it only runs on a disk read; an inode buffer that
> was validated and then mutated in the block-device page cache (for
> example by a concurrent LOOP_SET_STATUS invalidating the loop bdev) stays
> up-to-date and is consumed without re-validation.
> 
> [FIX]
> Bound the source id_count against ocfs2_max_inline_data_with_xattr() in
> ocfs2_duplicate_inline_data() before the memcpy, and return an error via
> ocfs2_error() if it is too large.
> 
> Fixes: 2f48d593b6ce ("ocfs2: duplicate inline data properly during reflink.")
> Reported-by: syzbot+e400b192d6ca035354ee@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=e400b192d6ca035354ee
> Cc: stable@vger.kernel.org
> Signed-off-by: Ian Bridges <icb@fastmail.org>
> ---
> This patch contains a proposed fix for a crash reported by syzbot
> in ocfs2_duplicate_inline_data().
> 
> The file names and offsets in this description are from commit
> 7cb1c5b32a2bfde961fff8d5204526b609bcb30a from this repo:
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
> 
> I also have a small test harness that reproduces the original crash
> deterministically, which I can make available as well.
> 
> The Bug
> 
> OCFS2 stores the data of a small file directly inside the inode block,
> in the space that would otherwise hold the extent list (the inline-data
> feature). The on-disk container is struct ocfs2_inline_data
> (fs/ocfs2/ocfs2_fs.h:652):
> 
>     __le16  id_count;
>     __le16  id_reserved0;
>     __le32  id_reserved1;
>     __u8    id_data[] __counted_by_le(id_count);
> 
> id_count is the capacity of the inline area, not the used length; it is
> set at creation to ocfs2_max_inline_data_with_xattr()
> (fs/ocfs2/namei.c:589). For a 4K block that capacity is
> 4096 - offsetof(struct ocfs2_dinode, id2.i_data.id_data) = 3896 bytes,
> less any inline-xattr reservation (fs/ocfs2/ocfs2_fs.h:1252).
> 
> When copy_file_range() (or FICLONE) targets two files on the same ocfs2
> mount and the source is inline, ocfs2 copies the inline bytes directly in
> ocfs2_duplicate_inline_data() (fs/ocfs2/refcounttree.c:3918). It memcpys
> the source id_data array into the target's, using le16_to_cpu() of the
> source id_count as the copy length (fs/ocfs2/refcounttree.c:3946).
> 
> id_count is taken straight from the source inode buffer as the copy
> length, with no bounds check. If it exceeds the 3896-byte capacity the
> memcpy runs off the end of the source inode block, and because the same
> count is the write length, off the end of the target block too. Both are
> 4096-byte buffers, so the access spills into the adjacent page. syzbot's
> report is the read side: "Read of size 8483 ..." in
> ocfs2_duplicate_inline_data, 8483 being the bad id_count.
> 
> How it is reached:
> 
> 1. With both files on the same super block, vfs_copy_file_range()
>    (fs/read_write.c:1554) has no copy_file_range method to call and falls
>    back to ocfs2's remap_file_range method, ocfs2_remap_file_range()
>    (fs/ocfs2/file.c:2701), with REMAP_FILE_CAN_SHORTEN
>    (fs/read_write.c:1599). An over-long copy length is clamped to the
>    source i_size.
> 
> 2. ocfs2_remap_file_range() calls ocfs2_reflink_inodes_lock()
>    (fs/ocfs2/refcounttree.c:4698), which takes the inode cluster lock via
>    ocfs2_inode_lock_nested() (fs/ocfs2/refcounttree.c:4743), yielding the
>    source inode buffer s_bh, then calls ocfs2_reflink_remap_blocks()
>    (fs/ocfs2/refcounttree.c:4599).
> 
> 3. For a whole-file copy of an inline source
>    (fs/ocfs2/refcounttree.c:4622) it takes the inline fast path:
>    ocfs2_duplicate_inline_data(s_inode, s_bh, ...)
>    (fs/ocfs2/refcounttree.c:4625), which runs the memcpy above. A corrupt
>    id_count of 8483 overruns the buffers and KASAN reports the
>    out-of-bounds read into the freed neighbouring page.
> 
> The bad id_count is not present on disk in a freshly read inode.
> ocfs2_validate_inode_block() (fs/ocfs2/inode.c:1423) already rejects an
> id_count larger than ocfs2_max_inline_data_with_xattr() at read time
> (fs/ocfs2/inode.c:1508, added by 7bc5da4842be for the write-side sibling
> of this bug), and that check is in the crashing kernel. The bad value
> instead reaches s_bh through a buffer that was validated once and then
> mutated underneath ocfs2.
> 
> The fs is on a loop device; while the copy runs, the test harness issues
> LOOP_SET_STATUS with a changed lo_offset/lo_sizelimit. loop_set_status()
> (drivers/block/loop.c:1227) then calls invalidate_bdev()
> (drivers/block/loop.c:1246), dropping the loop bdev pages that back
> ocfs2's cached inode buffer. When the page is refilled from the
> offset-shifted backing it holds neighboring garbage, and the inline fast
> path reads that id_count without re-validating. (The report's "page last
> freed by loop_set_status" is this same churn.) The test harness produces the
> state deterministically by writing an oversized id_count straight into the
> loop device's page cache at the inode's offset, then issuing the copy.
> 
> The Proposed Fix
> 
> The fix adds the bound check to ocfs2_duplicate_inline_data() itself,
> before the memcpy. If the source id_count exceeds
> ocfs2_max_inline_data_with_xattr() for the source inode, the inode is
> corrupt, so report it with ocfs2_error() and return. id_count is read
> once into a local used for both the check and the copy, so the value
> cannot change between them.
> 
> The natural instinct, and what the write-side sibling 7bc5da4842be did,
> is to reject the value at read time in ocfs2_validate_inode_block(). That
> is right for corruption already present on disk when the inode is read,
> but it does not stop this bug.
> 
> ocfs2_validate_inode_block() does not run on every use of a buffer; it
> runs at most once, as the post-I/O callback of a disk read.
> ocfs2_read_blocks() (fs/ocfs2/buffer_head_io.c:193) goes to disk only
> when the buffer is not already up-to-date (fs/ocfs2/buffer_head_io.c:271);
> only that path sets NeedsValidate (fs/ocfs2/buffer_head_io.c:327-328),
> and the callback runs only when that flag is set
> (fs/ocfs2/buffer_head_io.c:376-382). An already up-to-date buffer is
> returned with no I/O and no validation. The validator therefore checks
> the bytes when read from disk, not when used.
> 
> Because of this, the patch checks the invariant where the value is consumed
> (the memcpy site), the only place that sees the live bytes. Putting it in
> ocfs2_duplicate_inline_data() also covers both callers
> (fs/ocfs2/refcounttree.c:4107 and :4625) and bounds both the source read
> and the target write, since one count drives both.
> 
>  fs/ocfs2/refcounttree.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> index 8eee5be4d1ed..eb3ddcaaa049 100644
> --- a/fs/ocfs2/refcounttree.c
> +++ b/fs/ocfs2/refcounttree.c
> @@ -3925,9 +3925,23 @@ static int ocfs2_duplicate_inline_data(struct inode *s_inode,
>  	struct ocfs2_super *osb = OCFS2_SB(s_inode->i_sb);
>  	struct ocfs2_dinode *s_di = (struct ocfs2_dinode *)s_bh->b_data;
>  	struct ocfs2_dinode *t_di = (struct ocfs2_dinode *)t_bh->b_data;
> +	u16 id_count = le16_to_cpu(s_di->id2.i_data.id_count);
>  
>  	BUG_ON(!(OCFS2_I(s_inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL));
>  
> +	/*
> +	 * id_count was validated by ocfs2_validate_inode_block() when the inode
> +	 * was read, but the cached buffer can be modified afterward, so re-check
> +	 * it before the memcpy.
> +	 */

Ummm... If this is the case, I think it is a code bug in other place.

Not sure if this is relevant with
https://lore.kernel.org/ocfs2-devel/20260529190101.a72cec8337c1b5e908e3afa0@linux-foundation.org/T/#t

Thanks,
Joseph

> +	if (id_count > ocfs2_max_inline_data_with_xattr(s_inode->i_sb, s_di)) {
> +		ret = ocfs2_error(s_inode->i_sb,
> +				  "Inode %llu has invalid inline data id_count %u\n",
> +				  (unsigned long long)OCFS2_I(s_inode)->ip_blkno,
> +				  id_count);
> +		goto out;
> +	}
> +
>  	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
>  	if (IS_ERR(handle)) {
>  		ret = PTR_ERR(handle);
> @@ -3943,8 +3957,7 @@ static int ocfs2_duplicate_inline_data(struct inode *s_inode,
>  	}
>  
>  	t_di->id2.i_data.id_count = s_di->id2.i_data.id_count;
> -	memcpy(t_di->id2.i_data.id_data, s_di->id2.i_data.id_data,
> -	       le16_to_cpu(s_di->id2.i_data.id_count));
> +	memcpy(t_di->id2.i_data.id_data, s_di->id2.i_data.id_data, id_count);
>  	spin_lock(&OCFS2_I(t_inode)->ip_lock);
>  	OCFS2_I(t_inode)->ip_dyn_features |= OCFS2_INLINE_DATA_FL;
>  	t_di->i_dyn_features = cpu_to_le16(OCFS2_I(t_inode)->ip_dyn_features);

