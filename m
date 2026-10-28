Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793163774;
	b=qUYvMvW+pSJ+zfg52V/TgaS1el7YOBbdiol3/sr69fduomxHIvCwIh8NpoAvBlRss6gb
	 pJmloDUGLwzR7+xZ4sm6P+ipqf4HYNZEk/mHNJx2kMfzLcK230KI9SypWq6HDZpaddzf9
	 tEfHLxNz3TgPA8rzJyQBLjxxwTw8y9Xwn9ELnRZcbONV/gRTBbGhq5c7DScGbWw4GNffn
	 UoFe/DudXiN+BZxfF/oJfW1nzLaGZTySvZHny+XXEISvOZnu8gLUCZ0dWoNhLf45NmhO9
	 TQ9S9Jm7B5/MUAELp2oreU6DdN/Ezo6Pbd6L+ONfNeZocFWIPiOltBZIpheJLjcImAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793163774;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=Rr2WJEdTQgGpHBcJecdClBEvFz4TlW63veoXIe5tkYM=;
	b=WNdv0TMpevdqTMFo1ZNBEyZxoz+3FlN5ZyshxU4FqUQAO62j0Ra0ldw1WMds3kcmxJqz
	 NHwKUKpJB0eslWWTGpzZKH7HmsbzfYTp1ikblLonM1Mvt3dTlWaX2WrCp5fKuwiMMYPpo
	 //raG5Tr1NRpofJetfaeoOHlKWQVaBkckYFrcZliur8TjVE8l2TQ7j87kVCiu8NGbXakf
	 egzk88pNpvfg0Fp/wlNn33xoStiHBjE1IgIbRihX7ePf3Oo1lkZhPaLPF/YW25zlZy8gS
	 QsOYmU5T4RDTTf+iChduP4xhlMJ/rCQjzZYbnBYCmZsvrpn+q6gWb+MTlscVR9NSumg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=pnl+6fb3;
	arc=none smtp.remote-ip=220.197.31.5
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084A9606A31A
	for <ocfs2-devel@lists.linux.dev>; Wed, 28 Oct 2026 05:02:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 084A9606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=pnl+6fb3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Rr
	2WJEdTQgGpHBcJecdClBEvFz4TlW63veoXIe5tkYM=; b=pnl+6fb30MpIyxA1Sp
	Ex3BZx9q/aUuK7RfxEeU+1xvF3xNi8bwVU3lxenLeXgnun+1GDz8Inm75sebK4r8
	HzPh4RtI1TItQMbjda5XbeWbzRhjbrGttNbcJQajw/QmTHd9eqOQVjM1stNDNHJT
	Zkr67TD+SR9uqR/54vJiEeeZ8=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wD3X6XmgeFqS1hoDQ--.3415S2;
	Wed, 28 Oct 2026 13:02:31 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Tao Ma <tao.ma@oracle.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH] ocfs2: validate xattr bucket count against extent size
Date: Wed, 28 Oct 2026 13:02:29 +0800
Message-Id: <20261028050229.124718-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
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
X-CM-TRANSID:_____wD3X6XmgeFqS1hoDQ--.3415S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxCw1UAw43WF4fAryktw1UWrg_yoW5AFy8pF
	4UKF15tr18t3Z7uF93Ar1DZw1Skr48XF4DXry3tw1avF1DJw1SqFy0qwn0kF1rXryrWrsI
	gF4Ykw1UCa43XaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07joKZAUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzQes5mrhgeejTgAA3A

The first xattr bucket stores the number of valid buckets in its extent.
Lookup and iteration trust this on-disk value even when it exceeds the
number of buckets covered by the extent record. A corrupted value can
therefore make them read blocks beyond the extent.

Validate the count against the extent cluster count before using it.
Reject zero as well because every xattr extent contains at least its first
bucket.

Fixes: 589dc2602f2a ("ocfs2: Add xattr lookup code xattr btrees")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 fs/ocfs2/xattr.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index b2bd06083a14..6b2fc8337c51 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -328,6 +328,22 @@ static inline u16 ocfs2_blocks_per_xattr_bucket(struct super_block *sb)
 	return OCFS2_XATTR_BUCKET_SIZE / (1 << sb->s_blocksize_bits);
 }
 
+static int ocfs2_validate_xattr_bucket_count(struct inode *inode,
+					     struct ocfs2_xattr_header *xh,
+					     u32 num_clusters)
+{
+	u32 num_buckets = le16_to_cpu(xh->xh_num_buckets);
+	u32 max_buckets = num_clusters *
+		ocfs2_xattr_buckets_per_cluster(OCFS2_SB(inode->i_sb));
+
+	if (!num_buckets || num_buckets > max_buckets)
+		return ocfs2_error(inode->i_sb,
+				   "Inode %llu has invalid xattr bucket count %u (max %u)\n",
+				   inode->i_ino, num_buckets, max_buckets);
+
+	return 0;
+}
+
 #define bucket_blkno(_b) ((_b)->bu_bhs[0]->b_blocknr)
 #define bucket_block(_b, _n) ((_b)->bu_bhs[(_n)]->b_data)
 #define bucket_xh(_b) ((struct ocfs2_xattr_header *)bucket_block((_b), 0))
@@ -4295,6 +4311,10 @@ static int ocfs2_xattr_bucket_find(struct inode *inode,
 	}
 
 	xh = bucket_xh(search);
+	ret = ocfs2_validate_xattr_bucket_count(inode, xh, num_clusters);
+	if (ret)
+		goto out;
+
 	high_bucket = le16_to_cpu(xh->xh_num_buckets) - 1;
 	while (low_bucket <= high_bucket) {
 		ocfs2_xattr_bucket_relse(search);
@@ -4480,6 +4500,7 @@ static int ocfs2_iterate_xattr_buckets(struct inode *inode,
 	int i, ret = 0;
 	u32 bpc = ocfs2_xattr_buckets_per_cluster(OCFS2_SB(inode->i_sb));
 	u32 num_buckets = clusters * bpc;
+	struct ocfs2_xattr_header *xh;
 	struct ocfs2_xattr_bucket *bucket;
 
 	bucket = ocfs2_xattr_bucket_new(inode);
@@ -4503,8 +4524,14 @@ static int ocfs2_iterate_xattr_buckets(struct inode *inode,
 		 * The real bucket num in this series of blocks is stored
 		 * in the 1st bucket.
 		 */
-		if (i == 0)
-			num_buckets = le16_to_cpu(bucket_xh(bucket)->xh_num_buckets);
+		if (i == 0) {
+			xh = bucket_xh(bucket);
+			ret = ocfs2_validate_xattr_bucket_count(inode, xh, clusters);
+			if (ret)
+				break;
+
+			num_buckets = le16_to_cpu(xh->xh_num_buckets);
+		}
 
 		trace_ocfs2_iterate_xattr_bucket((unsigned long long)blkno,
 		     le32_to_cpu(bucket_xh(bucket)->xh_entries[0].xe_name_hash));
-- 
2.34.1

