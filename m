Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794226918;
	b=SIgP7UgfIGdH0Gm2amfel9HSAGGkVV6vuc5i4intey70VycjrkteUIHJ2E2OzSdQlLlq
	 q1fQSWFNWq72CeUEXb+JQAM4BqonzejU1tpkSc4Gpu/6soCYv98AY2lX7oqhvh4TGZvOM
	 2lBSnRmgJS8OjyyemL04twvH+48vVljfRPczs5fjKsRGpUU+bW8nFyFs9gTnt6jTiYMe8
	 D8QZWIjJTokNH30t0WGcBN8DinY+OLXNGglfMa+oB67cmBQb26QHldu7riFnOqKcAicQt
	 cGEvfPbU0VweeUkph2i40QFfu7ZtGLZUov56NT0aioHsYxDjTbqLN+POmrdDsnD2SUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794226918;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=m5MTk+iMSF8IJK5g5CfhcVnBo8V+eg0v1q4zXApCeQM=;
	b=imfIPQOr+6TOz2gpxnAnECHp4dQL6bWarWLIPukmjJWYICSw7gqSRfLOumjkM9SpHmtB
	 RWyJ/CdQy+YLS2WsCHPAmoalERMaAQHMu9XZn1+InqOPiCwpTKFuVU4+6TEaoaNCioMeW
	 XNRXzHilNG5os68J6EQfmSpWNhF6qYL3kkAlXpiGskWTUTvDapdBK6WxbtXocK8+K+GuM
	 pa+a5Y4Hyv98K7uMwNNpa5Z4EZ0UKaoFyJb5wx6PoX/yL96OHdxuUHQ+F+shQR4kv1M4r
	 am/MStffbW9YoNmAeDEKU1+AucGEEggzEOvB629FtuDLebKtJyefbtSmJFVu8HWTAzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Kdk24kOH;
	arc=none smtp.remote-ip=115.124.30.131
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CC7606A325
	for <ocfs2-devel@lists.linux.dev>; Mon,  9 Nov 2026 12:21:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 52CC7606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Kdk24kOH
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794226914; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=m5MTk+iMSF8IJK5g5CfhcVnBo8V+eg0v1q4zXApCeQM=;
	b=Kdk24kOHNdO2KtmkIUqmQFGmX+SsmvMFnM+1KLdJEamSg/JQcGISOsIhVwoCXCW3omCLR1qzt4TlsIt7KUgJovl5aZKpRqvWXRiGPrU6+W+5f3Simj0rqDx+yNbG7sCmrIFWYuhinaJpZaSUyDxrTlhJipLisdGeIVF3uPd0OIo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R641e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEOZNhC_1794226912;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEOZNhC_1794226912 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Nov 2026 20:21:52 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v3 05/31] ocfs2: abstract the dinode fs_generation mismatch check
Date: Mon,  9 Nov 2026 20:20:55 +0800
Message-Id: <20261109122121.21473-6-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20261109122121.21473-1-joseph.qi@linux.alibaba.com>
References: <20261109122121.21473-1-joseph.qi@linux.alibaba.com>
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

The comparison against OCFS2_SB(sb)->fs_generation is open-coded in the
normal validator, the filecheck validator and the repair path.  Fold it
into a shared predicate.

Each call site keeps its own log message and return code: the normal
validator escalates through ocfs2_error(), filecheck reports
OCFS2_FILECHECK_ERR_GENERATION, and repair rewrites the field.

No functional change intended.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 8b4652002ae2..6b78b3f3c5fa 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -92,6 +92,12 @@ static bool ocfs2_dinode_has_no_valid_flag(struct ocfs2_dinode *di)
 	return !(le32_to_cpu(di->i_flags) & OCFS2_VALID_FL);
 }
 
+static bool ocfs2_dinode_has_wrong_fs_generation(struct super_block *sb,
+						 struct ocfs2_dinode *di)
+{
+	return le32_to_cpu(di->i_fs_generation) != OCFS2_SB(sb)->fs_generation;
+}
+
 static bool ocfs2_valid_inode_mode(umode_t mode)
 {
 	return fs_umode_to_ftype(mode) != FT_UNKNOWN;
@@ -1542,8 +1548,7 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
-	if (le32_to_cpu(di->i_fs_generation) !=
-	    OCFS2_SB(sb)->fs_generation) {
+	if (ocfs2_dinode_has_wrong_fs_generation(sb, di)) {
 		rc = ocfs2_error(sb,
 				 "Invalid dinode #%llu: fs_generation is %u\n",
 				 (unsigned long long)bh->b_blocknr,
@@ -1868,8 +1873,7 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
-	if (le32_to_cpu(di->i_fs_generation) !=
-	    OCFS2_SB(sb)->fs_generation) {
+	if (ocfs2_dinode_has_wrong_fs_generation(sb, di)) {
 		mlog(ML_ERROR,
 		     "Filecheck: invalid dinode #%llu: fs_generation is %u\n",
 		     (unsigned long long)bh->b_blocknr,
@@ -1964,8 +1968,7 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
 		     (unsigned long long)le64_to_cpu(di->i_blkno));
 	}
 
-	if (le32_to_cpu(di->i_fs_generation) !=
-	    OCFS2_SB(sb)->fs_generation) {
+	if (ocfs2_dinode_has_wrong_fs_generation(sb, di)) {
 		di->i_fs_generation = cpu_to_le32(OCFS2_SB(sb)->fs_generation);
 		changed = 1;
 		mlog(ML_ERROR,
-- 
2.39.3

