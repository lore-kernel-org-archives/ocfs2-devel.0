Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872179;
	b=wZhOTsGrlwCM/GkyWR9IvlTOKQXiU0xgigIZwO/XzFaXpJ1luEuf/7V63wJfCS0gSVZs
	 hMCbE6wqkJ1ORTBEUKXkozhoK4PdJcavdGF4tuW2dpHp6h2W3FplHxrAlS8qPvhgOD++K
	 3qb/i51knizIKIy3oSbCmVh9y9UFo8CQ4VmN0IiB2t9X7tqs9nqpR+gRrKI6gSiUSdABn
	 uHNk98ocZSMTjAXV8RFl/WqeLYO+iqdgTYgtITykAbqMHmfqNf8AnMohae5VgvRzIag2M
	 FizLECKn4Ydg3DSt8jIqKPqVeq21fg8lJJ5EXlgUaHf5peUWHvIHxn7xNa/tnwroscQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872179;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=yFXGpC73aaXQJ8o0Gd/Kq95bm/2xP/CRC8ILl7iv9LM=;
	b=TU8Dg6ofXEPfuc7EQWxuCF7TOk/5L7Bycf8QsonApCMb+Ws7DBLKxHkxslDMCWkzBpM7
	 dUuKJ7UkqgxPREcw9qBLzUyDeGf/s5lcjTZ0nEDhAcaJHVpra/tAlz4O3x/qcg9Ine3W/
	 peXJb9qpDHuLhnQNwqYn6TIAhH+R/25n2FurqG7vZXrHH7lJGxrwn1pjRfmIBlJDKMiGt
	 Hu/VbtSf6M88bwlkze+Zir1yoG5J0ivt5wVIy9lcovVeFh4ao6kRcgpcBXlWH4M3dFq2j
	 Jnpz/FUVMOGO7EmvaD3NYKsFxRezzMqWFYD5Ds/bif6qIaQIe5pS46GM9tZ9a7kW/rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Ewolm5Ks;
	arc=none smtp.remote-ip=115.124.30.101
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DEC5606EE94
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Nov 2026 09:49:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8DEC5606EE94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Ewolm5Ks
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793872170; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=yFXGpC73aaXQJ8o0Gd/Kq95bm/2xP/CRC8ILl7iv9LM=;
	b=Ewolm5KsHGmXIdjSYlt6bU2fhoyIZJ50skC/tu0dbql686OJSgY1bQC42Hme2yZVfE0uBW51DaJhX1j/dJgeQ2wkaguHrbnR+93xCm2WCd4LQrVIoOgxtkJl2tf2/m7TgVC2IkFiVQ63vMoicPNPURUa2C8PHvvwTwsox7u4xDI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R791e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XE8K7-J_1793872168;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XE8K7-J_1793872168 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 17:49:29 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 02/30] ocfs2: abstract the dinode i_blkno mismatch check
Date: Thu,  5 Nov 2026 17:48:58 +0800
Message-Id: <20261105094926.3203416-3-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20261105094926.3203416-1-joseph.qi@linux.alibaba.com>
References: <20261105094926.3203416-1-joseph.qi@linux.alibaba.com>
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
index bffd64e0a1c0..b13c7a9b54f3 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -72,6 +72,11 @@ static bool ocfs2_dinode_has_zero_nlink_or_mode(struct ocfs2_dinode *di)
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
@@ -1507,7 +1512,7 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
-	if (le64_to_cpu(di->i_blkno) != bh->b_blocknr) {
+	if (ocfs2_dinode_has_wrong_blkno(di, bh->b_blocknr)) {
 		rc = ocfs2_error(sb, "Invalid dinode #%llu: i_blkno is %llu\n",
 				 (unsigned long long)bh->b_blocknr,
 				 (unsigned long long)le64_to_cpu(di->i_blkno));
@@ -1829,7 +1834,7 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 	} else if (rc)
 		goto bail;
 
-	if (le64_to_cpu(di->i_blkno) != bh->b_blocknr) {
+	if (ocfs2_dinode_has_wrong_blkno(di, bh->b_blocknr)) {
 		mlog(ML_ERROR,
 		     "Filecheck: invalid dinode #%llu: i_blkno is %llu\n",
 		     (unsigned long long)bh->b_blocknr,
@@ -1934,7 +1939,7 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
 		return -OCFS2_FILECHECK_ERR_VALIDFLAG;
 	}
 
-	if (le64_to_cpu(di->i_blkno) != bh->b_blocknr) {
+	if (ocfs2_dinode_has_wrong_blkno(di, bh->b_blocknr)) {
 		di->i_blkno = cpu_to_le64(bh->b_blocknr);
 		changed = 1;
 		mlog(ML_ERROR,
-- 
2.39.3

