Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C404392C46
	for <ocfs2-devel@lists.linux.dev>; Tue, 11 Aug 2026 02:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786416239; cv=none; b=MuP78pjY2EN3PRb6YZOI6pIcjoauDbdmf0/VbYu4xIYexeqzdsAuoVmlJUn3l2XHs7eHOY/02T8scJ9xHeVDNAATKWl3W7H32JwMsSSfvD96LWVpj6JifhGdjSzYWMutCjpXqCXIKh1sSuQGZxJYjQ9ipgO56Iw69XOt5hwnt/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786416239; c=relaxed/simple;
	bh=WYEkUN4XgLmb2QSzxZbiGMtSGYajLh3kk1LmW6qb5KA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SM6yULSXUDqL6crS8SQrExEnM5XbdQ8xLPucZCjCQfbBuU0K8V7Gxsk3gM2BBWZcey0s0ZfelubD1Hhg5SkT66xRWK4jIXH4KOexblLSQo9yq7aroOsZaLQe+YjkaiBYTtstF+wafu0w8rdoxkrRsPC/5diWopDhm5N3nyXoqYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lg75sR5W; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lg75sR5W"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2cc73e322dbso28423285ad.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 10 Aug 2026 19:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786416231; x=1787021031; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6rsMUA23aPPjN53adP0mvTSV6XbtGX1aRtlR4t+CMFI=;
        b=Lg75sR5W8hcKJvYz8pLhc0Xy2pTd2lL6NRw9LNoZsal2VIu1EbKTYdIHoCNMo1ClUd
         x7NTxXtd8y5+Vd13ktKQl2+wDBmASlGc6k3faQr1zYhs7+GTPnzgSp7sNoTqPCIKKaUx
         NUVRk5azKDkL0yoAkkQVdKR0sz0xIMt6SMeSwQ5RzizBaMFPJVwlBm1nZ4eLB9QYcRHh
         eKpvyLAQQQ8WefzfJ7YO45X2lu3NOhJUxWFNqlCNUw7/m3dvrYZh9DkiX8bYXEdu60B/
         ds84QYbb7GtSMU48ioSqkYAE+DnXJbSkGdD+hVt8P2OnKzyZM/Q+/t4kSjHgq8Dz7Um6
         xClQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786416231; x=1787021031;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6rsMUA23aPPjN53adP0mvTSV6XbtGX1aRtlR4t+CMFI=;
        b=eoBLSV1qRKvuSdkQIEM0iq6Jl34YDKchBbhu5X3iyda6WtlHYKtDUZ581loVA9//9G
         ubHSFwJeHCjcjJgKr3cDjrgFtNJDHkV2IOhW4xWlXTArXYnaPDp2cInvC3nF+wWZBZ/M
         sQ/68SV+NBnGGE6FdnfKC6eFtBY9xzSQqjE1S4PX4Cu/JKC2Jhw7dPP/yxadwo0bdN23
         FfHCKY4GYG6q1YDSbr34rTyAuLo6r5N181rwM6K2MDb9748SPGmYRm/TZ6BA7Hn5MAne
         9UXBT9iuu9JQOGcQ/k+uSCUT2Bb6gJEmOZ5qqSoq0UJcZTo04h2XEvpeCe61lwqhFG0L
         X7Xg==
X-Forwarded-Encrypted: i=1; AHgh+Rqi46IcTo/3TjhZiTNUkyWL4f26sPKRT4o8jTARLUzozE12tsx1Sk4BQXQEFKe+82mkU0Y761QfycV45Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YzY0h2wBFcY/OluEo9LNT0AQUCYlkqEQPUBRcuTa7i3c2xDxFy7
	BT5VduXZVSHMEyEvgV1sUCFxZojt6wYKeud4zvob5wRWiT6c5BpxLWWV
X-Gm-Gg: AR+sD13P7bzM5Wch1k0FKva78MQLvnLaQ0uFfFgOiyZke4l8KhvMylQ0blsBj/cY88K
	tvWgzy993iQkQyLueBwRUKLDhD/7mNSJ3CQBTbROoMJBh9pmSgF8CO0JeWY+/qPCO+JGaZqI4sg
	tklvrtd81TjCG8YaULOTxxxlkxXr5jNlwpJL+tu/eHQt6AghuyYQlD75QXMx+LcAxyBg6QJ73nX
	ouHWzD+VbfwG2Y5iJ6Lbl7cyBWmWsi8BanXJUw1cgQiHvaWQEzVByEevcEnN8UBOLhYOysYNkI3
	oZKrR6TNJaDgK2oA9Ctdp59fvzGP3vwsfCY9ZkRY4hnN780Y8vFRntvAQWIi14LtVL7hgrYEFGT
	Mq8wY7saU6ptbKRKDgd8vqYczdlaL3QMACVFnKzoyrfoZYlHh4Z4bzGRJjIZ7uEeU7fZi2Kht4f
	w1xcZ7E9MIKxRXfzfU1MOWLXL7W0Z2tkyxgnOL18lBz/iwiwRcXDu9zV8SnKQJ/MzGgbJTJlb2a
	mGM2Xyhab6OxcZo
X-Received: by 2002:a17:902:f708:b0:2c9:d8c6:1dc3 with SMTP id d9443c01a7336-2d3175fee1fmr3925505ad.0.1786416231387;
        Mon, 10 Aug 2026 19:43:51 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d3160f47easm464165ad.64.2026.08.10.19.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 19:43:50 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
X-Google-Original-From: Zhan Xusheng <zhanxusheng@xiaomi.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com
Subject: [PATCH v2 1/2] ocfs2: bound-check dir entries in the readdir re-validation scan
Date: Tue, 11 Aug 2026 10:43:36 +0800
Message-ID: <20260811024337.3972976-2-zhanxusheng@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260811024337.3972976-1-zhanxusheng@xiaomi.com>
References: <20260811024337.3972976-1-zhanxusheng@xiaomi.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the inode version changed since the last readdir(),
ocfs2_dir_foreach_blk_el() re-scans the directory block from its start to
relocate the current position:

	for (i = 0; i < sb->s_blocksize && i < offset; ) {
		de = (struct ocfs2_dir_entry *)(bh->b_data + i);
		if (le16_to_cpu(de->rec_len) < OCFS2_DIR_REC_LEN(1))
			break;
		i += le16_to_cpu(de->rec_len);
	}

i walks the block on rec_len values taken from the block itself and the
only thing tested is that rec_len is not too small, so a single bogus
rec_len
leaves i anywhere in the block, including its last OCFS2_DIR_REC_LEN(1) - 1
bytes.  @offset comes from ctx->pos, which userspace moves with lseek() on
the directory fd, and decides how far the walk gets.

Two bounds are missing, both of which ocfs2_check_dir_entry() applies for
the emit loop below.

de->rec_len sits at byte offset 8 within the entry, so dereferencing de in
that tail reads past the s_blocksize buffer.  ocfs2_check_dir_entry()
declines to look at an entry that close to the end:

	size - buf_offset < OCFS2_DIR_REC_LEN(1)

Nothing bounds i += rec_len either, so i can end up past the block.  The
emit loop that follows is guarded by offset < sb->s_blocksize and does not
run, but

	offset = i;
	ctx->pos = (ctx->pos & ~((loff_t)sb->s_blocksize - 1)) | offset;

runs first and ORs a value with bits above the block mask into ctx->pos,
corrupting the block number readdir() resumes from.
ocfs2_check_dir_entry() rejects that as "directory entry overrun":

	next_offset = buf_offset + rlen;
	... next_offset > size

Apply both bounds.  For a consistent directory this changes nothing:
entries are at least OCFS2_DIR_REC_LEN(1) bytes and do not cross the end of
the block, so no valid entry is skipped.

Found by the sashiko review tool; fix approach suggested by Joseph Qi.

Link: https://sashiko.dev/#/patchset/20260806022044.167962-1-zhanxusheng@xiaomi.com
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
 fs/ocfs2/dir.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index c30a86856d5b..39ce60874e17 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -1903,7 +1903,10 @@ static int ocfs2_dir_foreach_blk_el(struct inode *inode,
 		 * dirent right now.  Scan from the start of the block
 		 * to make sure. */
 		if (!inode_eq_iversion(inode, *f_version)) {
-			for (i = 0; i < sb->s_blocksize && i < offset; ) {
+			for (i = 0; i + OCFS2_DIR_REC_LEN(1) <= sb->s_blocksize &&
+			     i < offset;) {
+				unsigned int rec_len;
+
 				de = (struct ocfs2_dir_entry *) (bh->b_data + i);
 				/* It's too expensive to do a full
 				 * dirent test each time round this
@@ -1911,10 +1914,11 @@ static int ocfs2_dir_foreach_blk_el(struct inode *inode,
 				 * least that it is non-zero.  A
 				 * failure will be detected in the
 				 * dirent test below. */
-				if (le16_to_cpu(de->rec_len) <
-				    OCFS2_DIR_REC_LEN(1))
+				rec_len = le16_to_cpu(de->rec_len);
+				if (rec_len < OCFS2_DIR_REC_LEN(1) ||
+				    i + rec_len > sb->s_blocksize)
 					break;
-				i += le16_to_cpu(de->rec_len);
+				i += rec_len;
 			}
 			offset = i;
 			ctx->pos = (ctx->pos & ~((loff_t)sb->s_blocksize - 1))
-- 
2.43.0

