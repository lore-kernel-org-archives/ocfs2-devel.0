Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D44EDDAB
	for <ocfs2-devel@lists.linux.dev>; Mon, 20 May 2024 02:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716173150; cv=none; b=gF1AulSGNK4buT53DwjVAFHg73Frxv8cAFG2zsmOrvnYl7dTe6Zx9nobHz31JSsE+fAXknHzSV7BcRWkROyqbEZbF1fLfkCXLAXVyhqRHy1nhMctGBKGgS3w5V1FxK6r2vz3nc8N3oDTluPkvD8nMX/ziIF6sb72XXp+3tU3zn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716173150; c=relaxed/simple;
	bh=8q84+SQ1tI8uWNV6FzzSc3/C2DI2E/i8pQPOKUw/+bk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Okvq0yGCGh+gFpWLTkelG7XGvxqr9zsMp8aRg6+f5gT4e5DLvK7I7BsfkQ38f4h7Ws2r8XiRcp9PDNWISI3hpAkbotzT2sJuG0vjNxHL8mP5c/A+K3cucvvNSvYWcHX26uUeOS2jVqdwjMI4G6YevBW03Y2vqxklZQFPsnruJTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=E6Q3lfqD; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="E6Q3lfqD"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1716173144; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=kgzyrYDPnLL6KJ+9K9Vnkr8YK8FdPI843zsuvVSwxGs=;
	b=E6Q3lfqD1dDHXCpr3EdwPxm6U85eZXSp73Zqa9q4qlM8xAUjsOe4uDTA0AfeEdrmb57htT7qaUyGx/sj1nx70mu6wv/GABGSLk6730iYhsyJepB82hayuj4OTalCVh9+KXwLGgkr6L9DNb0d5aAp2wBf+B6xg+MT6uESTqM9HSc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045075189;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0W6kvpYc_1716172826;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W6kvpYc_1716172826)
          by smtp.aliyun-inc.com;
          Mon, 20 May 2024 10:40:27 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Ferry Meng <mengferry@linux.alibaba.com>,
	lei lu <llfamsec@gmail.com>
Cc: ocfs2-devel@lists.linux.dev
Subject: [PATCH RESNED 2/2] ocfs2: strict bound check before memcmp in ocfs2_xattr_find_entry()
Date: Mon, 20 May 2024 10:40:24 +0800
Message-Id: <20240520024024.1976129-2-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240520024024.1976129-1-joseph.qi@linux.alibaba.com>
References: <20240520024024.1976129-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ferry Meng <mengferry@linux.alibaba.com>

From: Ferry Meng <mengferry@linux.alibaba.com>

xattr in ocfs2 maybe 'non-indexed', which saved with additional space
requested. It's better to check if the memory is out of bound before
memcmp, although this possibility mainly comes from crafted poisonous
images.

Reported-by: lei lu <llfamsec@gmail.com>
Signed-off-by: Ferry Meng <mengferry@linux.alibaba.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/xattr.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 8aea94c90739..35c0cc2a51af 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1068,7 +1068,7 @@ static int ocfs2_xattr_find_entry(struct inode *inode, int name_index,
 {
 	struct ocfs2_xattr_entry *entry;
 	size_t name_len;
-	int i, cmp = 1;
+	int i, name_offset, cmp = 1;
 
 	if (name == NULL)
 		return -EINVAL;
@@ -1083,10 +1083,15 @@ static int ocfs2_xattr_find_entry(struct inode *inode, int name_index,
 		cmp = name_index - ocfs2_xattr_get_type(entry);
 		if (!cmp)
 			cmp = name_len - entry->xe_name_len;
-		if (!cmp)
-			cmp = memcmp(name, (xs->base +
-				     le16_to_cpu(entry->xe_name_offset)),
-				     name_len);
+		if (!cmp) {
+			name_offset = le16_to_cpu(entry->xe_name_offset);
+			if ((xs->base + name_offset + name_len) > xs->end) {
+				ocfs2_error(inode->i_sb,
+					    "corrupted xattr entries");
+				return -EFSCORRUPTED;
+			}
+			cmp = memcmp(name, (xs->base + name_offset), name_len);
+		}
 		if (cmp == 0)
 			break;
 		entry += 1;
-- 
2.39.3

