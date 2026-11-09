Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794226916;
	b=gFMGA9Jl+KWeKhSRh0qpXZKlZ1NFSITidIzfFaxx9JYj1C+nnzT/OPjLO/YWOXXNokry
	 kmAQgS0dou+0j0yR5CDcBPyd2/Jyq/zaLB8Aaur+vqQ4+KM1+l65L3cFIOiOzqKWPRUuW
	 iSSJ+R3s6r4SdzkJ77wTBYlWWjClJWSrAyR3GfDVG/DVsauvKVe3t8OYwGsMNgwYGFJsV
	 Ccu9xkjbpmJe3jnJBf3PcJ9zpLpJMVTzGXB5wz7XpiAxXHnkoh7khTKKIbPThFfuP1bpK
	 JTbWZzXbLVOHVH2I2KvWDS9ceELjNPPN1VwxruFShudMCmHlRX6G0B3vca3ouu312gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794226916;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=q1LX/Zzu5lJJ68i8CdUH/dCh4TP/qblPJOfMfJ1EhqU=;
	b=XGD4k+hzFib1gool9wgnbqCH18jwSRcen0I74gECDcdILzvjUGgg8Nqz3EW3KBFh0gU6
	 Sjd0Ur+cSEVzl6vqNCywZzwNk60MbdZrlA5RBqgbFuXmnsew9kG00RQcQ3GGC33Z5N9AZ
	 KVbQ8snDyw2lMRlYjRBD+1VUUj43mfhZCWE1OhDjb+3FgIHM7rWp3BdmCEr2vLLafEcOf
	 97+AhbwW2tN0kWQBq4A3gtxc8zkMGJsf6VEhvtRFWBSljvNqQScK/b09ammM/vYQcvSAb
	 fv1xQu417+wKdhiHeCpxJ5w3HYsPxxdttRarq8a+uUHdNmUoTD+M/Eh1iDpYAvrvDoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=WXz65qFo;
	arc=none smtp.remote-ip=115.124.30.133
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC95606A334
	for <ocfs2-devel@lists.linux.dev>; Mon,  9 Nov 2026 12:21:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1FC95606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=WXz65qFo
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794226912; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=q1LX/Zzu5lJJ68i8CdUH/dCh4TP/qblPJOfMfJ1EhqU=;
	b=WXz65qFohtXHLG4f708nOooUfMYr4RjrG3F59nXD4UmShEChj9oyM9RaIewhCaOHgC+J3OxJOw5Eox3jgo6xK9LXFKfPq3nABOC3ULQBNLYUk3kEIKX83n7D4u+ADPM6EaxvUMYMwgtXB2NMGJ0Uyw9c2PAxBCmLcgrsJjbUnAE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEP8aqD_1794226911;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEP8aqD_1794226911 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Nov 2026 20:21:51 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v3 04/31] ocfs2: abstract the dinode OCFS2_VALID_FL check
Date: Mon,  9 Nov 2026 20:20:54 +0800
Message-Id: <20261109122121.21473-5-joseph.qi@linux.alibaba.com>
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

The test for a dinode without OCFS2_VALID_FL is open-coded three times,
and the two spellings have already drifted apart: the normal validator
uses le32_to_cpu(di->i_flags) & OCFS2_VALID_FL while filecheck and repair
use di->i_flags & cpu_to_le32(OCFS2_VALID_FL).  Fold them into one
predicate using the le32_to_cpu() form.

Byteswapping is a bit permutation, so both spellings test the same
on-disk bit on either endianness.  The BUG_ON() in ocfs2_populate_inode()
is left alone; it asserts an invariant the validator has already
established rather than validating on-disk state.

No functional change intended.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 587fcea59f5a..8b4652002ae2 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -87,6 +87,11 @@ static bool ocfs2_dinode_has_wrong_blkno(struct ocfs2_dinode *di, u64 blkno)
 	return le64_to_cpu(di->i_blkno) != blkno;
 }
 
+static bool ocfs2_dinode_has_no_valid_flag(struct ocfs2_dinode *di)
+{
+	return !(le32_to_cpu(di->i_flags) & OCFS2_VALID_FL);
+}
+
 static bool ocfs2_valid_inode_mode(umode_t mode)
 {
 	return fs_umode_to_ftype(mode) != FT_UNKNOWN;
@@ -1530,7 +1535,7 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
-	if (!(le32_to_cpu(di->i_flags) & OCFS2_VALID_FL)) {
+	if (ocfs2_dinode_has_no_valid_flag(di)) {
 		rc = ocfs2_error(sb,
 				 "Invalid dinode #%llu: OCFS2_VALID_FL not set\n",
 				 (unsigned long long)bh->b_blocknr);
@@ -1854,7 +1859,7 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
-	if (!(di->i_flags & cpu_to_le32(OCFS2_VALID_FL))) {
+	if (ocfs2_dinode_has_no_valid_flag(di)) {
 		mlog(ML_ERROR,
 		     "Filecheck: invalid dinode #%llu: OCFS2_VALID_FL "
 		     "not set\n",
@@ -1943,7 +1948,7 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
 		return -OCFS2_FILECHECK_ERR_INVALIDINO;
 	}
 
-	if (!(di->i_flags & cpu_to_le32(OCFS2_VALID_FL))) {
+	if (ocfs2_dinode_has_no_valid_flag(di)) {
 		/* Cannot just add VALID_FL flag back as a fix,
 		 * need more things to check here.
 		 */
-- 
2.39.3

