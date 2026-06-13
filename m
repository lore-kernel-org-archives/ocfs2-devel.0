Received: from flow-a7-smtp.messagingengine.com (flow-a7-smtp.messagingengine.com [103.168.172.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C777E73463
	for <ocfs2-devel@lists.linux.dev>; Sat, 13 Jun 2026 13:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781357519; cv=none; b=RAUO6nUU8h3JuivJLiAGjP/akri0K1XoTxBpRYWkFlULKRcJxJao9OvP+GQeONEkWZHFGsSw8p46N9E0U8LDcbnBCj+5OAocdmpsFhouLh53zkDs5In7lhRy4Uo7jYLQH5M63xpfBych/wPTcJ0+SAh9uq6mkOUeT8Kj8SMOWGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781357519; c=relaxed/simple;
	bh=EQu9InT6bP+A7eCeYVG+Sx/uWu7aVbp3dAR8iqxc1JQ=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=YpxchQkTK/7pyCDwiupsZKylGAC87q7PmviwvfGPAdX3nU0fRdysCszl5hc9DOPzVzcrzJlg5rk89690u0x4W7CtJrhfCHXdFCIzveQ5bWQy0Sj4fNu6fW5x8jwVbiTo8Jn1WSPeZbr0JsJTEIcVszOXzHdQkMU1FNICBWHJj30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org; spf=pass smtp.mailfrom=fastmail.org; dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b=hAWuZm6Q; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=EWH0vzDn; arc=none smtp.client-ip=103.168.172.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b="hAWuZm6Q";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="EWH0vzDn"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.phl.internal (Postfix) with ESMTP id E53E51380079;
	Sat, 13 Jun 2026 09:31:55 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Sat, 13 Jun 2026 09:31:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:content-type:content-type:date:date:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to; s=fm1;
	 t=1781357515; x=1781361115; bh=94CgoBBrDZnGnjc9WDHUFo0i+VLFgjMe
	uyZJF6iUVts=; b=hAWuZm6Q6lwzr3krzMsZQMSYKBitE+Z1IrsMvrXQ7f3bRjUu
	KCESHwhZGR8R7TqARSwu4Br/LkhfeqlVkbUF1nGeAnNCGbY5yW3Qa9pgsKBikzJH
	N/p3jXTRfK/kUFp6ueaq03QxdQuv+ptgDSHJQdbhHne7ZOqSUVAT9e4wjPWCP6Ch
	01OrcLWSQNTa1D7FfJk66LvhVkPICZ4N1ZrvGasKmK4huOyEGU9L6Bx7f0WNbbFZ
	tLb3Fmi/oQlK79lWjCM717VspMV0XkGHRM1Ki++pnXFzhbH25XY5cUT3twq9Be0X
	C6odrdrA34ssVvBJmJ3AyIUpok1Lq/iNpIuMQg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:message-id
	:mime-version:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1781357515; x=
	1781361115; bh=94CgoBBrDZnGnjc9WDHUFo0i+VLFgjMeuyZJF6iUVts=; b=E
	WH0vzDnNayxgjPRmJvlPqBCyD40r4rcgUM2g5Z4v8lck0JXl4eSPqUP407ZqZg95
	ZXlqe9ew0TgAxts7ED5iIIRQPrTKgoCD1yXJ4LNVHV3ydEfmY4Lc18HOkY9IfsdV
	srinyOeTIVpN4+gnFB2vsbO/d+jgFg4fj1I9wLj8Q9QT+LrNTw1jAdzPkIPULRPk
	q4ZYzTqZqgTlQ0FeYFHtiiYbi2J7OWbpxKkJReFeRSDVGgqmWGWcC9voNuVBUpmM
	zXmy5ZUPyEzyzY1FHUuvqmuFloBs952stTXJepmkjnEFZCklh4vbg7dAXfz6Wkw7
	ermaGIBpUA9v88CdmryLg==
X-ME-Sender: <xms:y1stamQSvvVFAW2oQGBX_SczQ5CESf0nwuysEABpGrVikpUntKrchA>
    <xme:y1staksGoBZ0dOHQkfAv9N_gJa-Z4xI_xAiHkPn55J6N4qN3dkkBwYWYu307sr0Re
    WpvdwFgUscNXXbBvcNcu6aYg5GmAgrVKijHnwZxWs14O9UOFvvjNMA>
X-ME-Received: <xmr:y1stavZXJ5VxexUfGLw_3UMuJcFjr30yBQoSi2OzvLPmlxVVJIorvx0K7p8>
X-ME-Proxy-Cause: dmFkZTEweCc+svDwM6N47jqDgbPbaY4k7DK6LR8jSANChfAjd1U3wyrulBhNPJp6qpoJCu
    AIr/+1MFF3yI+4sRToC7MrqEKLIBBocGCLP32lVox+mHxt4MBdVAEmAwT9UOXAA9imYu5m
    70tmZOOrcfSeU8KDWDQ8hPSSqy1Iv2YIMFpf6QKCfGWR3+tEC20DvcJ4aBYsxpvfyz2rEm
    NYEa7DYLJntkroMsMha6fHyOoob0+9/Yz0Ad85JtRDHuaVquIcyFRyvV/8IiO6/AmPgOqB
    84s0Pd6IPw3CvmadRAWPstabo555oRjXYYMSHxSxu/Uyh7cIPhrcMBalvSPiTtocf1dLI9
    O3t6Uidb3YRY2EBLYM+6TXq1K25zP5yA6peXsPSyngQEAvz3okDnB19ZuCAwx6469pFvj7
    wBn8O4CQAm7b5mgSeQGGm4mKP2U/BAQHqtu40AYZWCmacokCrJPfrym5yg6E/bxGAqqYcu
    dQ+OcfCTiQR/NmPRFbxyn/vQ8X5t2VpSBqVizZ5uEyNhvFZv50yr0l6KBKBTFAxq+viAAw
    RkjvVDIM5XLX+XyChehHYasxwCosUszUbZ2TsEBPnvorNCyJ7F7DiCzTqRPJigwqayfQ9y
    FDU03hmYVmINxbKP/oZ2viyAsKGbdfd4eZidgLNARjDbvrrjuBv9NgjHjqHQ
X-ME-Proxy: <xmx:y1staiG5AD3Sp4oMOMWM8Hk8A9-XD63yBIAJGA9LL38eYynUcZ4-4g>
    <xmx:y1starzT0TCwVzZhJTFmchBVB3V3LWYZd-r0M9-J2l151e_9lYhwVQ>
    <xmx:y1stasl-z2qPgy445ogbCEEzEzPB_aAUYKpwymTkemM2c-R1UTRlFQ>
    <xmx:y1staslgA3w5LJPioiF2oDD__QWhm8EtlWcGQBozZNqltxSbSvyL0A>
    <xmx:y1stai96GUKYmc0djQsZlEy2f6qStOY8ltMF2OAtVkyisbz2lvaySXUd>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 13 Jun 2026 09:31:55 -0400 (EDT)
Date: Sat, 13 Jun 2026 08:31:53 -0500
From: Ian Bridges <icb@fastmail.org>
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: [PATCH] ocfs2: fix out-of-bounds read in
 ocfs2_duplicate_inline_data()
Message-ID: <ai1byUgMNULbZuLs@dev>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

[BUG]
copy_file_range() (or reflink) of an inline-data file can read and write
out of bounds in ocfs2_duplicate_inline_data() when the source inode's
on-disk id_count exceeds the inline-data capacity. KASAN reports a
use-after-free read past the end of the inode block buffer.

[CAUSE]
ocfs2_duplicate_inline_data() copies the source inline area with a
memcpy() whose length is le16_to_cpu() of the on-disk id_count, taken
straight from the source inode buffer with no bounds check. The inline
capacity is at most ocfs2_max_inline_data_with_xattr() (3896 bytes for a
4K block); a larger id_count overruns the 4096-byte source and target
inode blocks into the adjacent page. ocfs2_validate_inode_block() already
bounds id_count, but it only runs on a disk read; an inode buffer that
was validated and then mutated in the block-device page cache (for
example by a concurrent LOOP_SET_STATUS invalidating the loop bdev) stays
up-to-date and is consumed without re-validation.

[FIX]
Bound the source id_count against ocfs2_max_inline_data_with_xattr() in
ocfs2_duplicate_inline_data() before the memcpy, and return an error via
ocfs2_error() if it is too large.

Fixes: 2f48d593b6ce ("ocfs2: duplicate inline data properly during reflink.")
Reported-by: syzbot+e400b192d6ca035354ee@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e400b192d6ca035354ee
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---
This patch contains a proposed fix for a crash reported by syzbot
in ocfs2_duplicate_inline_data().

The file names and offsets in this description are from commit
7cb1c5b32a2bfde961fff8d5204526b609bcb30a from this repo:
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git

I also have a small test harness that reproduces the original crash
deterministically, which I can make available as well.

The Bug

OCFS2 stores the data of a small file directly inside the inode block,
in the space that would otherwise hold the extent list (the inline-data
feature). The on-disk container is struct ocfs2_inline_data
(fs/ocfs2/ocfs2_fs.h:652):

    __le16  id_count;
    __le16  id_reserved0;
    __le32  id_reserved1;
    __u8    id_data[] __counted_by_le(id_count);

id_count is the capacity of the inline area, not the used length; it is
set at creation to ocfs2_max_inline_data_with_xattr()
(fs/ocfs2/namei.c:589). For a 4K block that capacity is
4096 - offsetof(struct ocfs2_dinode, id2.i_data.id_data) = 3896 bytes,
less any inline-xattr reservation (fs/ocfs2/ocfs2_fs.h:1252).

When copy_file_range() (or FICLONE) targets two files on the same ocfs2
mount and the source is inline, ocfs2 copies the inline bytes directly in
ocfs2_duplicate_inline_data() (fs/ocfs2/refcounttree.c:3918). It memcpys
the source id_data array into the target's, using le16_to_cpu() of the
source id_count as the copy length (fs/ocfs2/refcounttree.c:3946).

id_count is taken straight from the source inode buffer as the copy
length, with no bounds check. If it exceeds the 3896-byte capacity the
memcpy runs off the end of the source inode block, and because the same
count is the write length, off the end of the target block too. Both are
4096-byte buffers, so the access spills into the adjacent page. syzbot's
report is the read side: "Read of size 8483 ..." in
ocfs2_duplicate_inline_data, 8483 being the bad id_count.

How it is reached:

1. With both files on the same super block, vfs_copy_file_range()
   (fs/read_write.c:1554) has no copy_file_range method to call and falls
   back to ocfs2's remap_file_range method, ocfs2_remap_file_range()
   (fs/ocfs2/file.c:2701), with REMAP_FILE_CAN_SHORTEN
   (fs/read_write.c:1599). An over-long copy length is clamped to the
   source i_size.

2. ocfs2_remap_file_range() calls ocfs2_reflink_inodes_lock()
   (fs/ocfs2/refcounttree.c:4698), which takes the inode cluster lock via
   ocfs2_inode_lock_nested() (fs/ocfs2/refcounttree.c:4743), yielding the
   source inode buffer s_bh, then calls ocfs2_reflink_remap_blocks()
   (fs/ocfs2/refcounttree.c:4599).

3. For a whole-file copy of an inline source
   (fs/ocfs2/refcounttree.c:4622) it takes the inline fast path:
   ocfs2_duplicate_inline_data(s_inode, s_bh, ...)
   (fs/ocfs2/refcounttree.c:4625), which runs the memcpy above. A corrupt
   id_count of 8483 overruns the buffers and KASAN reports the
   out-of-bounds read into the freed neighbouring page.

The bad id_count is not present on disk in a freshly read inode.
ocfs2_validate_inode_block() (fs/ocfs2/inode.c:1423) already rejects an
id_count larger than ocfs2_max_inline_data_with_xattr() at read time
(fs/ocfs2/inode.c:1508, added by 7bc5da4842be for the write-side sibling
of this bug), and that check is in the crashing kernel. The bad value
instead reaches s_bh through a buffer that was validated once and then
mutated underneath ocfs2.

The fs is on a loop device; while the copy runs, the test harness issues
LOOP_SET_STATUS with a changed lo_offset/lo_sizelimit. loop_set_status()
(drivers/block/loop.c:1227) then calls invalidate_bdev()
(drivers/block/loop.c:1246), dropping the loop bdev pages that back
ocfs2's cached inode buffer. When the page is refilled from the
offset-shifted backing it holds neighboring garbage, and the inline fast
path reads that id_count without re-validating. (The report's "page last
freed by loop_set_status" is this same churn.) The test harness produces the
state deterministically by writing an oversized id_count straight into the
loop device's page cache at the inode's offset, then issuing the copy.

The Proposed Fix

The fix adds the bound check to ocfs2_duplicate_inline_data() itself,
before the memcpy. If the source id_count exceeds
ocfs2_max_inline_data_with_xattr() for the source inode, the inode is
corrupt, so report it with ocfs2_error() and return. id_count is read
once into a local used for both the check and the copy, so the value
cannot change between them.

The natural instinct, and what the write-side sibling 7bc5da4842be did,
is to reject the value at read time in ocfs2_validate_inode_block(). That
is right for corruption already present on disk when the inode is read,
but it does not stop this bug.

ocfs2_validate_inode_block() does not run on every use of a buffer; it
runs at most once, as the post-I/O callback of a disk read.
ocfs2_read_blocks() (fs/ocfs2/buffer_head_io.c:193) goes to disk only
when the buffer is not already up-to-date (fs/ocfs2/buffer_head_io.c:271);
only that path sets NeedsValidate (fs/ocfs2/buffer_head_io.c:327-328),
and the callback runs only when that flag is set
(fs/ocfs2/buffer_head_io.c:376-382). An already up-to-date buffer is
returned with no I/O and no validation. The validator therefore checks
the bytes when read from disk, not when used.

Because of this, the patch checks the invariant where the value is consumed
(the memcpy site), the only place that sees the live bytes. Putting it in
ocfs2_duplicate_inline_data() also covers both callers
(fs/ocfs2/refcounttree.c:4107 and :4625) and bounds both the source read
and the target write, since one count drives both.

 fs/ocfs2/refcounttree.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 8eee5be4d1ed..eb3ddcaaa049 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -3925,9 +3925,23 @@ static int ocfs2_duplicate_inline_data(struct inode *s_inode,
 	struct ocfs2_super *osb = OCFS2_SB(s_inode->i_sb);
 	struct ocfs2_dinode *s_di = (struct ocfs2_dinode *)s_bh->b_data;
 	struct ocfs2_dinode *t_di = (struct ocfs2_dinode *)t_bh->b_data;
+	u16 id_count = le16_to_cpu(s_di->id2.i_data.id_count);
 
 	BUG_ON(!(OCFS2_I(s_inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL));
 
+	/*
+	 * id_count was validated by ocfs2_validate_inode_block() when the inode
+	 * was read, but the cached buffer can be modified afterward, so re-check
+	 * it before the memcpy.
+	 */
+	if (id_count > ocfs2_max_inline_data_with_xattr(s_inode->i_sb, s_di)) {
+		ret = ocfs2_error(s_inode->i_sb,
+				  "Inode %llu has invalid inline data id_count %u\n",
+				  (unsigned long long)OCFS2_I(s_inode)->ip_blkno,
+				  id_count);
+		goto out;
+	}
+
 	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
@@ -3943,8 +3957,7 @@ static int ocfs2_duplicate_inline_data(struct inode *s_inode,
 	}
 
 	t_di->id2.i_data.id_count = s_di->id2.i_data.id_count;
-	memcpy(t_di->id2.i_data.id_data, s_di->id2.i_data.id_data,
-	       le16_to_cpu(s_di->id2.i_data.id_count));
+	memcpy(t_di->id2.i_data.id_data, s_di->id2.i_data.id_data, id_count);
 	spin_lock(&OCFS2_I(t_inode)->ip_lock);
 	OCFS2_I(t_inode)->ip_dyn_features |= OCFS2_INLINE_DATA_FL;
 	t_di->i_dyn_features = cpu_to_le16(OCFS2_I(t_inode)->ip_dyn_features);
-- 
2.47.3

