Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792424866;
	b=Y+mNRm0afBY93bG8u54jaXmkKIPc5+VUTup0GPLCF/5n78x39+IeF+rIsny2U4OK5l1H
	 ApGWm1iO5WbP+i3/epdIzDtdsjI0VICAXF2VoxNtM59lRzjlD+wtVLSUOoWuWV+Dga6Bk
	 J8psXI8G70S6XGztrULw7snp5TOgyVNWBgq71R4kdbj/qtIHCMsn+pKg6qLYnywt4+Rb0
	 EhHo5ZG4YFSrRlQk9Qv+cUlhKO8CrYInjgeQbUmrYxOkJjjjut8Yqf0fFh4RDVAUgPu8r
	 fQN4ii5o3mI+1L7RtidzqOxwQrOaa/mdX2tJq4W9VhNfNhGKnErzOSkVk726dEYcfow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792424866;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J4t4H89v7aV1e5EzzyxhnG8qiUcpvGcd+ixs31MkbCQ=;
	b=VPUN4harxL5Bb0l37c+aszBy2krHMk1MOkFte9nsWpkkoE1lxxXAzRWGzIT225tlRvhZ
	 BqjORnYeqPFEJoJ5RZ7T/By+5R0Iq237STj5IeNkH9WwhA++iTJ4uK3RuIsHqZL6k5LXW
	 h4wS3hnMVyTDaOilSeBZLhsj4i7KE1iDPFtDoLd7vdGGRv4/imoxZyBEjPDVXM1NPptxf
	 2tHnMKxPNEfiZ/cQbatlYq1AQz3Mc5lq4TtUTNqMbVoiyl2kjKKH0W3PX77a2/1sVwqt9
	 F2XgF/H+SbwyfBbIFfTgLzBZb7zxrzk0VpaEruExHxUnhmxJWo840FW1VOY78WNyBMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=OcX00uAJ;
	arc=none smtp.remote-ip=209.85.210.180
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBC8607550F
	for <ocfs2-devel@lists.linux.dev>; Mon, 19 Oct 2026 15:47:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9EBC8607550F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=OcX00uAJ
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-878b44611ffso1276115b3a.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 19 Oct 2026 08:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792424865; x=1793029665; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J4t4H89v7aV1e5EzzyxhnG8qiUcpvGcd+ixs31MkbCQ=;
        b=OcX00uAJqAdyp0pAHoB4CCidtovgGGMJCnndt9w/BPWHTCXNzaT2L7migW9wE1o9pl
         diCxor0Jo73nsZ+aPOqUZYQSpu4Wy3n5xwcBNVoTs7LASRDLMtckEryv75aLldUcBIYM
         311Qt268fdnjS8luaxUumnYc9NMOA+XmBis9y1dFQAV52UktNXqiixpOYpavwfNduocd
         3SzDe9nCSMvrbzRuBYNeuFcF9rd6vsve5hFVaOSBkF6eF6M6bY+gyctYgQdGsB8p9741
         rcDsXh7nSa8nIYH6KQ4ic77NMbcyuGMU/UdNe0OzYDg9gzs6m3Q1R/clN6JiT753Wt1O
         d7aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792424865; x=1793029665;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=J4t4H89v7aV1e5EzzyxhnG8qiUcpvGcd+ixs31MkbCQ=;
        b=chsfIb0/6etgoQguIvrUqbE3q/GJ7jeMHbVz+6nx7NVepMgVTbKVLRkngJmvMBUJYY
         qdbPvOXc58ybJn4mj/MabONkGtcodgxqqFja8X+npN9/HMWTUc4NhbhvN4hECFSs9STW
         35RgoeXrb+QT+yo2eSt+kM8Gng73uxECINFxeJVXBPMd4dFfuIJwTjpLBNncsllEUsfl
         wn7wmgZQVO22Zjcv7x89l/Yswg0ZUMnEgutGbKH3edakce1+gVqi8wpPqczuV0xZlqoC
         7uCyF5OACEr6kipkxbIhne9mgnkDZxDTzDQkkGivf1C/gzz8Ub43YHd5CIU7ayOLJi5J
         wkrQ==
X-Forwarded-Encrypted: i=1; AKwUvBxepZAQpNkRAzltd++BWlZBbJkT4zQmgHJYyAPAa4OnjZG5aX87BsBi8M9DtWDs16ZBkiClYcxoFPWPVQ==@lists.linux.dev
X-Gm-Message-State: AFq9FYJORfFsBOtUNdTV/HcQlY2ORm3iBOmxc7hy9c9mVNohRkj1BHo1
	IFRG39YglGVnRk3pSCAnpTvrtpDuY19yehEposLae9JZ7xPit+RGoN7k
X-Gm-Gg: AYBFou1Ro5VBVAC2ueE6+crymqyo2njjDDuvl9ZafDx0Zp8MRGnnL56TFnt7vE/VFp7
	BYyI/A7IJUSIueEHHyTc584Z1SklcJR+SkAFh8HLs8az6lJMQvAW1oMguNxk4rbMmcHygft0tzd
	xGpEYtjvTTt37wZuSTTBKXlSaw2xCp0fKd4WJxsWJlBMEld2uBwfgxTK2vovz748TRt5utfXuOC
	HdJWLpcWbL+bN3JYCUtMPsMKzmafwOJS5wctfbq9YwfpHhwyNpwXxhlZyZu/PuMXQS38jdfiqcX
	EFFRgSSpODhbz4Z+MGpOhAKM8mjx696fFQxjWdZxZEK7c0OzHULxVY3j+knwcqRqv4/KhP79puJ
	CSgEE2NZ7qpsUs4U6NtHCZgDXbkhsL2m8o3wHLddUO4vgp/Kn47kTZj3ySH9O+jUWVLAgHwwPEv
	qZ5Wmq9Ixizgx1UiFbW55Q73I+Kf2A0KPMZCCg39k8gJI3ZryzZBrMVp5cvuFav6uTYn8/pYw1q
	VOJgDw3NnPKxQQl4ftR
X-Received: by 2002:a05:6a00:7701:b0:89e:37b0:d1b2 with SMTP id d2e1a72fcca58-8a05742b68cmr4299138b3a.37.1792424864745;
        Mon, 19 Oct 2026 08:47:44 -0700 (PDT)
Received: from ustb520lab-MS-7E07.. ([115.25.44.221])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89f5735e513sm4108693b3a.27.2026.10.19.08.47.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 08:47:44 -0700 (PDT)
From: Jiaming Zhang <r772577952@gmail.com>
To: jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev
Cc: r772577952@gmail.com,
	heming.zhao@suse.com,
	linux-kernel@vger.kernel.org,
	syzkaller@googlegroups.com,
	stable@vger.kernel.org
Subject: [PATCH] ocfs2: validate the block count of a local quota file
Date: Mon, 19 Oct 2026 23:47:32 +0800
Message-ID: <20261019154732.3149351-1-r772577952@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CANypQFbjcxXjiigMCCyErN=DSEh3ZG3NMWRpq=Hic8KJ76cwew@mail.gmail.com>
References: <CANypQFbjcxXjiigMCCyErN=DSEh3ZG3NMWRpq=Hic8KJ76cwew@mail.gmail.com>
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Every ocfs2 node keeps a local quota file made of chunks.  A chunk is a
header block, whose bitmap marks the entries in use, followed by up to
ol_chunk_blocks() blocks of entries, and only the last chunk may be
partly filled.  The file header records the number of chunks in
dqi_chunks and the number of blocks in dqi_blocks.  When no chunk has a
free entry, ocfs2_extend_local_quota_file() works out from dqi_blocks
how many entry blocks the last chunk already has, and puts the new entry
right after them:

	chunk_blocks = oinfo->dqi_blocks - ol_quota_chunk_block(sb,
			chunk->qc_num) - 1; ... *offset = chunk_blocks * epb;

olq_alloc_dquot() then sets that bit in the chunk's bitmap, which fits
in a single block.  This is only safe while chunk_blocks is at most
ol_chunk_blocks().

ocfs2_local_read_info() reads dqi_chunks and dqi_blocks from disk at
mount time and never checks that they agree.  With one chunk and a
dqi_blocks of a few thousand, the last chunk appears to hold thousands
of entry blocks, and the bit lands kilobytes past the end of the bitmap.
A dqi_blocks below the last chunk's header block makes chunk_blocks, an
unsigned int, wrap around to the same effect.

The stray write corrupts unrelated kernel memory.  KASAN calls it a
use-after-free only because the page it hits happens to be free; nothing
in ocfs2 was freed.  Reaching it takes mounting a crafted image with
quotas enabled, which needs CAP_SYS_ADMIN, and creating a file.  The
issue was found by fuzzing and not seen in production, the reproducer
can be found in the linked report.

Check in ocfs2_local_read_info() that the last chunk has its header
block and at most ol_chunk_blocks() entry blocks, and that a file
without chunks holds only its info block, since the first new chunk is
placed at block dqi_blocks.  Refuse the file with ocfs2_error()
otherwise, as ocfs2_read_quota_block() does for a corrupted quota file.
The header block of the last chunk is computed in 64 bits because a
crafted dqi_chunks can wrap ol_quota_chunk_block().

Fixes: 9e33d69f553a ("ocfs2: Implementation of local and global quota file handling")
Closes: https://lore.kernel.org/lkml/CANypQFbjcxXjiigMCCyErN=DSEh3ZG3NMWRpq=Hic8KJ76cwew@mail.gmail.com/
Cc: stable@vger.kernel.org
Assisted-by: Claude Code:claude-opus-5-5
Signed-off-by: Jiaming Zhang <r772577952@gmail.com>
---
 fs/ocfs2/quota_local.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index f55810c59b1b..bad913d8bc4f 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -678,6 +678,30 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
 	return status;
 }
 
+/* Check that dqi_blocks agrees with dqi_chunks in local quota file info */
+static int ocfs2_local_check_info(struct super_block *sb, struct inode *lqinode,
+				  struct ocfs2_mem_dqinfo *oinfo)
+{
+	u64 hdr_blk;
+
+	if (!oinfo->dqi_chunks) {
+		if (oinfo->dqi_blocks == ol_quota_chunk_block(sb, 0))
+			return 0;
+	} else {
+		/* Same as ol_quota_chunk_block(), but in 64 bits */
+		hdr_blk = 1 + (u64)(ol_chunk_blocks(sb) + 1) *
+			      (oinfo->dqi_chunks - 1);
+		if (oinfo->dqi_blocks > hdr_blk &&
+		    oinfo->dqi_blocks - hdr_blk - 1 <= ol_chunk_blocks(sb))
+			return 0;
+	}
+
+	return ocfs2_error(sb,
+			   "corrupted local quota file %llu (chunks=%u blocks=%u)\n",
+			   (u64)OCFS2_I(lqinode)->ip_blkno,
+			   oinfo->dqi_chunks, oinfo->dqi_blocks);
+}
+
 /* Read information header from quota file */
 static int ocfs2_local_read_info(struct super_block *sb, int type)
 {
@@ -733,6 +757,10 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
 	oinfo->dqi_blocks = le32_to_cpu(ldinfo->dqi_blocks);
 	oinfo->dqi_libh = bh;
 
+	status = ocfs2_local_check_info(sb, lqinode, oinfo);
+	if (status)
+		goto out_err;
+
 	/* We crashed when using local quota file? */
 	if (!(oinfo->dqi_flags & OLQF_CLEAN)) {
 		rec = OCFS2_SB(sb)->quota_rec;
