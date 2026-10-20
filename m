Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792464460;
	b=g062+YFR5Ob2O+Qd6BtMkRv+bA0x/yKI3qe272o/TJAou5PzgpOzsZEIhyD64HQFi9jI
	 7l7hGjTuN1xxXTWnOLaFRseJ1B1nCHathbyupJcdyp5nN/ZWvSZPJlqa0xzgbCGtTGk5m
	 QneM+VaNKHqUtFRt2Dul7WMk02FICSbWC7GnJbvcgITADG8vn7GRCGv2CP/KcfEXstV7q
	 SVg3mIfh6JyHX2H/EnDuzXxPjgx3PtALAcOj98f/hKD44weL0YqVCrgqsSDiYQk+SRHK0
	 GqG0lYJyijj3Z/ekkoQxiXXC2UpOwnNWK1dcuhQ+yw4OoNqOoywsNe4VE0jQXWaUMmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792464460;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=QXaPhUMmKeWG8DuIUSmDwV9SB0ZMGDge3lOsVfysPhg=;
	b=bbmzyzQfpqQhCe/xepBToQRZehRBEHdW52cbmVCvlELrxLPL4zLziTRnecdMlpuWggnn
	 V85E86GKUAXTJVkIk/a1sC1Jp58GnIElWiETNEg7nNcF6BwQaMj/M/I78QSj8kz9Z9ZLP
	 yLtEx8CvRDdWxRHsbIXc2qWxAZvO15UAktUi0p3EqdnAFXXxh+FAR/tDi3xn2iIawU7hX
	 mbY1dLF1WAnP/5s19GuwDOrkFHe8f3TCKrNJ1R9k0Eyt7Ofbo6Lg5O+cqQFQd17zWA6X4
	 C9qNYQ2zUfgIUqLJ9VQBCa7qP3BSz0dSEgcX14HDHSzIOK0cnDhC7BG41VBas/RAKVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=X2CWIjWu;
	arc=none smtp.remote-ip=209.85.215.169
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C93606A31D
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Oct 2026 02:47:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84C93606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=X2CWIjWu
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cc4c02ddd62so1330274a12.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 19 Oct 2026 19:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792464459; x=1793069259; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QXaPhUMmKeWG8DuIUSmDwV9SB0ZMGDge3lOsVfysPhg=;
        b=X2CWIjWuSLRAU6MMvlFcCzdA3yEE7q+SX9uDxBTu2SYGKcYAt4PS4OpV30ZqaRVnkM
         cTleI3CEBhGfivHJuyXOpKQl2xzf0+PxEWWps1bq8BfrGANs4IdpStWh/zIySnEOIB8V
         qs8XSiPURd0ssQkS7A8D++habIQSja1tSt92lix3LuJDarfBT9iGBjdYqAbstedI5Sm3
         XgeyjiI1tNeJiMuUFI7JM46U7MVwujFc9S+0Ae/YHoc8XKsHQsyX9S/m0wfn2QA0UJ9t
         BrBGblfeYnIvcVF9nxBHQYsIfY6z+Beqj0KfptOPfBTVkgfhTeTEEPuKUh6kAevY+lpP
         WJFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792464459; x=1793069259;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QXaPhUMmKeWG8DuIUSmDwV9SB0ZMGDge3lOsVfysPhg=;
        b=gSp8wJHDjj3snLgYtkK7SdJYDDXgx4A/NKa6GpTXqIo1D0zoa4p8TzLm+T4DDlUoR+
         mPJS+FDHWd86Zm/gh4v2n+8OvnUxdT7I29M2Lj3xPOP2kkkdWX+RhFqjvaWe8FUvPyk+
         elrTacE9yhlFSQSqjuc6pd4sXZXZO9SHZEzMwXP59Wwpjh+XpAiMcH/9UyORuNT64dyI
         ZVtOe9Zq/cVhofYb9gy8KdSrAcHKueBBeR0NM9m6Sg0nDMmz6vvfNlO2gQOKs6eR9RRu
         xDUgsQEoLMZFJatSxK8rbsmAkoYhCRnwAWfuhZYD2s+RgJYGpvA8aZsGw69nwYGmdvQF
         2lKA==
X-Forwarded-Encrypted: i=1; AKwUvBxk0tOeh4gi4CuMADWlx/C8DbSqQVHiWf/KFYods58fPusGVPQvH+UQkJC+TiYtobkpYJGVVt1VG/pjtw==@lists.linux.dev
X-Gm-Message-State: AFq9FYJhppzcAJBN1AK0kuivzERUttVd1e6DFnpHU9lHvL3qn7qVRTE0
	umemkMA+xNurSHRm3OuLxpXn0jvtqpKsRWdM54D7Pm+F52A+tsIQegKy
X-Gm-Gg: AYBFou2JiybMCRslCxta5et6qDip6UfNgbmjVXeCBLMisQc/fyw3XUX1zCMQ6g02fLd
	O1bAFyJg7Nm/doh6zuIwor62URPi/rT0C5UaYRRHg2BjwQDARQ5tXCZ+kdOXgfWps8D8kMxdKZg
	uKwvgvCGiBohKgVDRU1PrASX2gVOQBoioQe+H6ryNexw78jHYzdrYJyQOVSN/99wO3of0AQz+u+
	U9nY12xrgyBvEVdv/mgeJH4zoFmfnp5PByr/1fE+BwjrcMxWqCnrmsPH1F5BsWNmujn2cAH8dCi
	eQ/NKmn/3kSksdAwfyeAoGp80NkGDNBtNCn8U5gQrCAZq6ayFMCyestevqQ/Q2KM8HsiT1gqroR
	eO/peW6LBOJp+++XvB7Cy01CwlLBpZtKa9vKdxzpy4OJditHgs8u1AShGLKEMUdfE+BliGcHpSE
	CgAzkkZSLbiUXgEfiVUwRkSwZY6ty+DFHqbZbHkwuktCawpE1K/2Lhr8f/tSyhI+zGzGYJ3dUhX
	bXRu7Ub/Da7jhpqAFxDFBkyEx40CR7UHTjha5gnnq4BQIYOfVAsqY6kuT/m+yKQPQE=
X-Received: by 2002:a05:6a20:a127:b0:3e1:1e2d:88d2 with SMTP id adf61e73a8af0-3e2660baef7mr1856048637.70.1792464458360;
        Mon, 19 Oct 2026 19:47:38 -0700 (PDT)
Received: from ustb520lab-MS-7E07.. ([115.25.44.221])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd654a33681sm4580970a12.29.2026.10.19.19.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 19:47:37 -0700 (PDT)
From: Jiaming Zhang <r772577952@gmail.com>
To: jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev
Cc: r772577952@gmail.com,
	heming.zhao@suse.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2] ocfs2: validate the block count of a local quota file
Date: Tue, 20 Oct 2026 10:46:50 +0800
Message-ID: <20261020024651.3217554-1-r772577952@gmail.com>
X-Mailer: git-send-email 2.43.0
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

	chunk_blocks = oinfo->dqi_blocks -
			ol_quota_chunk_block(sb, chunk->qc_num) - 1;
	...
	*offset = chunk_blocks * epb;

olq_alloc_dquot() then sets that bit in the chunk's bitmap, which fits
in a single block.  This is only safe while chunk_blocks is at most
ol_chunk_blocks().

ocfs2_local_read_info() reads dqi_chunks and dqi_blocks from disk at
mount time and never checks that they agree.  With one chunk and a
dqi_blocks of a few thousand, the last chunk appears to hold thousands
of entry blocks, and the bit lands kilobytes past the end of the bitmap.
A dqi_blocks below the last chunk's header block makes chunk_blocks, an
unsigned int, wrap around to the same effect.  dqi_blocks is not checked
against the file size either, and a dqi_blocks past the end of the file
can make the kernel write the new block of the file to block 0 of the
device.

The stray bit write corrupts unrelated kernel memory.  KASAN calls it a
use-after-free only because the page it hits happens to be free; nothing
in ocfs2 was freed.  The second case overwrites block 0 of the device.
Triggering either issue requires mounting a crafted image with quotas
enabled, which needs CAP_SYS_ADMIN, and creating a file.  The first
issue was found by fuzzing and has not been seen in production; the
reproducer can be found in the linked report.

Check in ocfs2_local_read_info() that the last chunk has its header
block and at most ol_chunk_blocks() entry blocks, and that a file
without chunks holds only its info block, since the first new chunk is
placed at block dqi_blocks.  Also check that dqi_blocks does not exceed
the file size.  Refuse the file with ocfs2_error() otherwise, as
ocfs2_read_quota_block() does for a corrupted quota file.  The header
block of the last chunk is computed in 64 bits because a crafted
dqi_chunks can wrap ol_quota_chunk_block().

Fixes: 9e33d69f553a ("ocfs2: Implementation of local and global quota file handling")
Closes: https://lore.kernel.org/lkml/CANypQFbjcxXjiigMCCyErN=DSEh3ZG3NMWRpq=Hic8KJ76cwew@mail.gmail.com/
Cc: stable@vger.kernel.org
Assisted-by: Claude Code:claude-opus-5-5
Signed-off-by: Jiaming Zhang <r772577952@gmail.com>
---
Changes in v2:
- Reject a dqi_blocks larger than the file size.  Suggested by the
  Sashiko review of v1.
- Print i_size in the error message.
- v1: https://lore.kernel.org/lkml/20261019154732.3149351-1-r772577952@gmail.com/

 fs/ocfs2/quota_local.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index f55810c59b1b..f3eb366f8fae 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -678,6 +678,39 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
 	return status;
 }
 
+/* Check dqi_blocks against dqi_chunks and the size of the local quota file */
+static int ocfs2_local_check_info(struct super_block *sb, struct inode *lqinode,
+				  struct ocfs2_mem_dqinfo *oinfo)
+{
+	u64 hdr_blk;
+
+	/*
+	 * i_size is grown before dqi_blocks, so the file may have more blocks
+	 * than dqi_blocks, but should not have fewer.
+	 */
+	if (oinfo->dqi_blocks > (i_size_read(lqinode) >> sb->s_blocksize_bits))
+		goto corrupted;
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
+corrupted:
+	return ocfs2_error(sb,
+			   "corrupted local quota file %llu (chunks=%u blocks=%u size=%lld)\n",
+			   (u64)OCFS2_I(lqinode)->ip_blkno,
+			   oinfo->dqi_chunks, oinfo->dqi_blocks,
+			   i_size_read(lqinode));
+}
+
 /* Read information header from quota file */
 static int ocfs2_local_read_info(struct super_block *sb, int type)
 {
@@ -733,6 +766,10 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
 	oinfo->dqi_blocks = le32_to_cpu(ldinfo->dqi_blocks);
 	oinfo->dqi_libh = bh;
 
+	status = ocfs2_local_check_info(sb, lqinode, oinfo);
+	if (status)
+		goto out_err;
+
 	/* We crashed when using local quota file? */
 	if (!(oinfo->dqi_flags & OLQF_CLEAN)) {
 		rec = OCFS2_SB(sb)->quota_rec;
