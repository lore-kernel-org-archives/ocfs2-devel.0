Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.97
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793963713;
	b=cYLKDdeexZ/n8RLccP9ZKRcoc1htCYzQ/aNZ24VojiRmDXp86AATnOHPzoxXPD1usgie
	 tzZJ7GLuPhUGu7E7LgIbSCMDvN+3CbngMWnRutx3WUfMcD8UGlWk3QoYBYbuxZWOa3Kvd
	 EOY36kCM7ecuah1eYcoFnwUhjEPPcAO1XWtCX9yFWWz9pWRLM3XgdT9mFIqbCmgKqsFJg
	 Hn4mQzfo3MTTmrT/VhI7PuEMGGB6pJ8v4u0Wr1HSBsRcz7+++8zYoOTk8FrWZ8HuZgh0n
	 i9H++/p/UyvGUE1swg16oKFBsxRoaewbjtV6+gfaDL3FFqYV5juwPinZkIFotbAJp3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793963713;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=fMu03X4wbz04Z9kIe0M1Zt3sPWaYbThV3APfzRBOM2g=;
	b=cSymmbPOv/sTtQLl461hBvgMiX9DgMX8oLuCnGXG3V7eDKuEZA+NDkGNmgFNDk6I8egk
	 GjKOPkc8QMUgeBx3qBlSuml5Yr9r6MNXCFTjluEHHUDNyRLjsJkRRT39lswYZGlQpB6dT
	 NQG2v49anEgYd1YZgieHuciN5YiK295MajKMSNg4x1viXqPYEcgSJxA2PnEB4nAcJH3Vb
	 xeHMLvcouJog5QN03rbIoBecDtLHzUkn9YJ8zO/6enD6Q9dWSSF/29+N8NNQHL/zQRl63
	 iYTx0l/TvwwDDDOXo+nkqV705aYKKrAjLZ7uMt211k8TLTeKrs+jKB/Y3fdmtLPnfGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=gJLomZnq;
	arc=none smtp.remote-ip=115.124.30.97
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2B0606EE8D
	for <ocfs2-devel@lists.linux.dev>; Fri,  6 Nov 2026 11:15:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB2B0606EE8D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=gJLomZnq
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793963709; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=fMu03X4wbz04Z9kIe0M1Zt3sPWaYbThV3APfzRBOM2g=;
	b=gJLomZnqozeX7eZ/aiD+2TYhydpKaY/Vz+R86TSal0YC/F5s68k0iczAmwzF3SDQ+u6+7l+rX/9RJ6GBgm07jrcYTWMKIEBmlAhiTShrCWGJ5xlEYOoeuEHKVRXI4enGCMtIivrZKhwgsQ5GZRlVea32SNAg6MhH7tlpzpOHUGc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEBSvPH_1793963708;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEBSvPH_1793963708 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Nov 2026 19:15:09 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v2 11/31] ocfs2: abstract the inline data id_count bound check
Date: Fri,  6 Nov 2026 19:14:38 +0800
Message-Id: <20261106111458.1467464-12-joseph.qi@linux.alibaba.com>
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

Fold the id_count against ocfs2_max_inline_data_with_xattr() test into a
predicate.

The comparison stays signed.  ocfs2_max_inline_data_with_xattr() returns
int and subtracts the unvalidated on-disk i_xattr_inline_size from the
space available in the inode block, so it can go negative on small block
sizes.  Caching it in an unsigned local would turn a negative maximum
into a huge bound and silently accept the oversized id_count.  The
message keeps its %d for the same reason.

No functional change intended.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 2aac1918562a..259f44661f37 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -174,6 +174,19 @@ static bool ocfs2_dinode_has_inline_clusters(struct ocfs2_dinode *di)
 	return le32_to_cpu(di->i_clusters) != 0;
 }
 
+static bool ocfs2_dinode_has_oversized_inline_data(struct super_block *sb,
+						   struct ocfs2_dinode *di)
+{
+	/*
+	 * The maximum is a signed int and can go negative, because
+	 * i_xattr_inline_size is itself unvalidated.  Keep the comparison
+	 * signed: an unsigned bound would turn a negative maximum into a
+	 * huge one and let the oversized id_count through.
+	 */
+	return le16_to_cpu(di->id2.i_data.id_count) >
+		ocfs2_max_inline_data_with_xattr(sb, di);
+}
+
 void ocfs2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = OCFS2_I(inode)->ip_attr;
@@ -1747,8 +1760,7 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 			goto bail;
 		}
 
-		if (le16_to_cpu(data->id_count) >
-		    ocfs2_max_inline_data_with_xattr(sb, di)) {
+		if (ocfs2_dinode_has_oversized_inline_data(sb, di)) {
 			rc = ocfs2_error(sb,
 					 "Invalid dinode #%llu: inline data id_count %u exceeds max %d\n",
 					 (unsigned long long)bh->b_blocknr,
-- 
2.39.3

