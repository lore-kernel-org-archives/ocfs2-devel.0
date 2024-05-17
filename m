Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AAB22EF8
	for <ocfs2-devel@lists.linux.dev>; Fri, 17 May 2024 09:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715938934; cv=none; b=WjUkXM9zD24d2ORvOrc70nECkmLLQbWHHHklB1mfTBJCnj7DOEdU8DCvC2xl1z8ukT2B02ATe4CG7oN35FLdp90w/enVzQHe9wBPa0MpG8m+sdKGA251E2wXILZTblBng9hr1K82cVACWR/0MepqNbdS10d8hAOn25JVIoDSwbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715938934; c=relaxed/simple;
	bh=g2mtvEDKT6K/qKPF1XuOt7jvGo9xLXUL9uFTaUoQL74=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sQx4fCP3NfGctwpadsDLJn/KT4JdWts1q2wn8j4JYE1eVOGc7j3VpZ6MfYJu45NoJ3JHqkCvgV4ixNZm8elfaUR1yT7lnClKKCSgKfAAZOAfzfVEvdCAumtVqrKezRiniddKzXfrCu04iAIahQhEank2Fa7mANs2zC3axeY1qpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=SqHlweC7; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="SqHlweC7"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1715938929; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=jOPrgQph3RGN8jKqsS+ujDSxSagogaAaFxEI3R+UkrM=;
	b=SqHlweC73EQI6reHhTzOzg/IKidEybGlLgUYltFK3K3tZJdp5OwfFVmwBCaOfZvGyTqbOTa2bnjZCKr6NsvCQp0ptpwVObyB6iiQTsUBfugsGFhJ3O4ir7X8OR8FfYTBHHPlxW6G9wpnVDetnWSza20w+FHiZhDZLiWwW9fVnak=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033068173054;MF=mengferry@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0W6eF4Lh_1715938925;
Received: from j66c13357.sqa.eu95.tbsite.net(mailfrom:mengferry@linux.alibaba.com fp:SMTPD_---0W6eF4Lh_1715938925)
          by smtp.aliyun-inc.com;
          Fri, 17 May 2024 17:42:07 +0800
From: Ferry Meng <mengferry@linux.alibaba.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	Ferry Meng <mengferry@linux.alibaba.com>
Subject: [PATCH v2 2/2] ocfs2: strict bound check before memcmp in ocfs2_xattr_find_entry()
Date: Fri, 17 May 2024 17:41:47 +0800
Message-Id: <20240517094147.87133-3-mengferry@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20240517094147.87133-1-mengferry@linux.alibaba.com>
References: <20240517094147.87133-1-mengferry@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xattr in ocfs2 maybe 'non-indexed', which saved with additional space
requested. It's better to check if the memory is out of bound before
memcmp, although this possibility mainly comes from crafted poisonous
images.

Signed-off-by: Ferry Meng <mengferry@linux.alibaba.com>
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
2.32.0.3.g01195cf9f

