Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793963713;
	b=Oudm4dBhVouvvJbIfd5KJBiPzWHGtADLnnmETXfYn0v/J/LJYUj2DKOn53Mv2LvZ8jYg
	 dzLCdo/CzPXyJcIR+VMBc9SZuFpPG2fetvr5+kF2cqgwdcwGLQnmFOA4/uwmmH6wems+O
	 tmGyjhXOVw7ixmnllZQ7StrT0scnNauyWWmNF41ILhODnKDb41Nj/4Q8QQlIxsaeipVOK
	 whIkGoPwOi05O/L2+aTfduJOv9eK/sD1qA0w3iuebOWQU7t8155bxoOCO7wCt4KZ+w+L+
	 Q8Gi2hyTzBPVyoPhzkL3P3OK9XgX6v9jfZ13+5Bcbhyifi5RooAZYlK2ae2bdnCfBxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793963713;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=DzTSlh9T8WL7TXENBVvmpXROLhx1mNSREYu24yi9dUY=;
	b=Sj7RMtUlneBeZyTEIPykDyZ44zG6nN+qKkAbRbJz76zymiKDmEnvvFUGFV8CenRRtFyD
	 aRJz6Q3YUf/fQb+wFReOSp3Vi+8PD0YNObDsqU4BDc3VU8qXK06LVls38WHBdkIsAOHr7
	 hxZjPFMwZTgUHF39mPv1PxRDrnrasQPrJiF9T5ZnNkZtGYopHap8J6862ZeGGV7Byxgzt
	 v/zn/bEABhsZ92IF12kK+oftnMCe//LnPFmSch9QKw/DMef5WOKFBQIVHEvmmcHxJp9K0
	 +NU+5w/g2wMxPG39CUfBD4KGTzYWjHa4kL/duyNSw7/PhjYAAh14UhiurL1tI4WTSLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ioR4yU23;
	arc=none smtp.remote-ip=115.124.30.124
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D781606EE96
	for <ocfs2-devel@lists.linux.dev>; Fri,  6 Nov 2026 11:15:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D781606EE96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ioR4yU23
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793963709; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=DzTSlh9T8WL7TXENBVvmpXROLhx1mNSREYu24yi9dUY=;
	b=ioR4yU23nOQNZJG/Xb8pbg6pAlRKEE1xo76/1r0yk0uJCF2kQR6jqgELEt8gLqruxFMfz6ilNZo/iA75zfpw+9hXtsErJ9fwG4icn/4bGtHR8MVPcZ/eN+6bxyR/iXFRYcBAFziFI+ww1jYpVFFCyqbbBMp3A4ZvQpEKW1ffgjM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R961e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEBd-49_1793963707;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEBd-49_1793963707 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Nov 2026 19:15:08 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v2 10/31] ocfs2: abstract the inline data dinode guard and cluster check
Date: Fri,  6 Nov 2026 19:14:37 +0800
Message-Id: <20261106111458.1467464-11-joseph.qi@linux.alibaba.com>
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

Introduce ocfs2_dinode_has_inline_data() for the OCFS2_INLINE_DATA_FL
test that selects the id2.i_data union arm, and
ocfs2_dinode_has_inline_clusters() for the rule that an inline-data
inode must not also have allocated clusters.

The guard stays above the sub-checks: reading id_count or i_clusters
against the wrong id2 arm would produce false positives on valid inodes.

No functional change intended.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 17d546a9245d..2aac1918562a 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -164,6 +164,16 @@ static bool ocfs2_dinode_has_size_without_clusters(struct super_block *sb,
 	return !ocfs2_sparse_alloc(OCFS2_SB(sb)) && S_ISREG(mode);
 }
 
+static bool ocfs2_dinode_has_inline_data(struct ocfs2_dinode *di)
+{
+	return le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL;
+}
+
+static bool ocfs2_dinode_has_inline_clusters(struct ocfs2_dinode *di)
+{
+	return le32_to_cpu(di->i_clusters) != 0;
+}
+
 void ocfs2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = OCFS2_I(inode)->ip_attr;
@@ -1726,10 +1736,10 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 	if (rc)
 		goto bail;
 
-	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) {
+	if (ocfs2_dinode_has_inline_data(di)) {
 		struct ocfs2_inline_data *data = &di->id2.i_data;
 
-		if (le32_to_cpu(di->i_clusters)) {
+		if (ocfs2_dinode_has_inline_clusters(di)) {
 			rc = ocfs2_error(sb,
 					 "Invalid dinode %llu: %u clusters\n",
 					 (unsigned long long)bh->b_blocknr,
-- 
2.39.3

