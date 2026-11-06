Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793963711;
	b=S1QJTtK4ZiKB1ryoOdD2BgzVKoi0Ba01mVYOq8a+pvhTrXuZSHTUQVolxK1SCPJqkfoz
	 x7FRtKRaWyqm0rOYEaHrp9HNIvfDTRmUrTXXGAXRUPTicKy/TO16AxiDQGPO8/CHZoWq9
	 tl0nreRIpXO2ug0PNI3FVs9i6osFm807VbCflt+x8K6XohEEbSDFT5gfbjh2BWb4OnPRi
	 Yfup4WS9VS/CuG5X3XrKoXGjDtN+GNDuLvuqbStmDYHk9wEKsGzNozFPrPFY+okQXIGha
	 XjExV7czeZy9REHw6StZFrq4TlOZeZ7wbNVgXydAKDxiujJjSv8xcg0vWsoJh6kprCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793963711;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=WRQbLV9xK9j8db8LykabLsYxijEPAiJ3b/bGAaI2kjo=;
	b=UQcDXS2xJB1VMQxZ5L2lIctlOicfx0SmGVCK+0B1fWLVuMRrsdR+XOBjoQga39K/Xea3
	 m+ZoiuQCdhotPOoVA3kCjMY6nuFMD/QoTXusqVT8npnxBCX/Ke9Pm3zJSh+Wa3mreWqN5
	 S+wrABK1ls1ifwLFQO3L5V5Ouw2hlznu3PJCTMUDVfmJ5hOkC02+u0WJ8V7btTqMEgQ4+
	 PmN/WaFeVkmXzQVG6Tj980JhleyAp0Q3Mo706CGI9iPwq0FClVbr5ncEootkWxvYUCb+G
	 13xPz8a3/ySefhNYkN8Q/GFvpzCVMGdVpKnGnbTNhpbriktZrGlkrpLr5zRCtc8aDkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=XfsR5BuB;
	arc=none smtp.remote-ip=115.124.30.111
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CFD606D804
	for <ocfs2-devel@lists.linux.dev>; Fri,  6 Nov 2026 11:15:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C5CFD606D804
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=XfsR5BuB
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793963702; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=WRQbLV9xK9j8db8LykabLsYxijEPAiJ3b/bGAaI2kjo=;
	b=XfsR5BuBd9UB/k8mQoHfjcjftWGfhRBaVNUOafvTXAHZBctBU8glRaXXINRwnRTH745ghbMjulcPZJPH5HIDnUnk1EHtJUDjKsrd3vFEtCdZor68F1DmUVscjR5g90C45mNlHf5OY9yaZQRnroPckL6GBxgIPJ3jw0qpBLiL4W4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEBd-1d_1793963701;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEBd-1d_1793963701 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Nov 2026 19:15:01 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v2 03/31] ocfs2: abstract the dinode i_blkno mismatch check
Date: Fri,  6 Nov 2026 19:14:30 +0800
Message-Id: <20261106111458.1467464-4-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20261106111458.1467464-1-joseph.qi@linux.alibaba.com>
References: <20261106111458.1467464-1-joseph.qi@linux.alibaba.com>
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

The same i_blkno against b_blocknr comparison is open-coded in
ocfs2_validate_inode_block(), ocfs2_filecheck_validate_inode_block() and
ocfs2_filecheck_repair_inode_block().  Fold it into a shared predicate.

Each call site keeps its own log message and return code: the normal
validator escalates through ocfs2_error(), filecheck reports
OCFS2_FILECHECK_ERR_BLOCKNO, and repair rewrites the field.

No functional change intended.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 209066321932..587fcea59f5a 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -82,6 +82,11 @@ static bool ocfs2_dinode_has_zero_nlink_or_mode(struct ocfs2_dinode *di)
 	return !ocfs2_read_links_count(di) || !di->i_mode;
 }
 
+static bool ocfs2_dinode_has_wrong_blkno(struct ocfs2_dinode *di, u64 blkno)
+{
+	return le64_to_cpu(di->i_blkno) != blkno;
+}
+
 static bool ocfs2_valid_inode_mode(umode_t mode)
 {
 	return fs_umode_to_ftype(mode) != FT_UNKNOWN;
@@ -1518,7 +1523,7 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
-	if (le64_to_cpu(di->i_blkno) != bh->b_blocknr) {
+	if (ocfs2_dinode_has_wrong_blkno(di, bh->b_blocknr)) {
 		rc = ocfs2_error(sb, "Invalid dinode #%llu: i_blkno is %llu\n",
 				 (unsigned long long)bh->b_blocknr,
 				 (unsigned long long)le64_to_cpu(di->i_blkno));
@@ -1840,7 +1845,7 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 	} else if (rc)
 		goto bail;
 
-	if (le64_to_cpu(di->i_blkno) != bh->b_blocknr) {
+	if (ocfs2_dinode_has_wrong_blkno(di, bh->b_blocknr)) {
 		mlog(ML_ERROR,
 		     "Filecheck: invalid dinode #%llu: i_blkno is %llu\n",
 		     (unsigned long long)bh->b_blocknr,
@@ -1945,7 +1950,7 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
 		return -OCFS2_FILECHECK_ERR_VALIDFLAG;
 	}
 
-	if (le64_to_cpu(di->i_blkno) != bh->b_blocknr) {
+	if (ocfs2_dinode_has_wrong_blkno(di, bh->b_blocknr)) {
 		di->i_blkno = cpu_to_le64(bh->b_blocknr);
 		changed = 1;
 		mlog(ML_ERROR,
-- 
2.39.3

