Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85F7127E12
	for <ocfs2-devel@lists.linux.dev>; Wed, 15 May 2024 13:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715779797; cv=none; b=Q+p6i3yTDmoz7E1gdqVUDbIQ8UC56jaZAy3ociYna3UbtII91pu2l2S4pyr076TRoOmRHPMGivAmiALmNS/VLQq5V5IFK8goEXtFszwDb5AN7StiMNoqnh8+9XB1JhftmEhXZZ6CryoNXt9s4s+ULPzBSO2tH6IXFXbJnvltfSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715779797; c=relaxed/simple;
	bh=mkKjpPpuGEd4/WEi+kqlcv0kfuYm/u5RzqJD/2y2c7s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CXB+mlxQqyJ6zu9WVt+HKAJGzit5LrlxqUkD9JLlU1frUykZ3wHtnLY3ZOWbpNhygkcPrm6Kv90fDn0WskzHK69YFMoMX9NJd2t3pxj9NyrJ/ndkJPW45tjouU7nwaJ2mQw3waxzdmTe6ypr3J1H4j0f3S54EN37toQze85gLhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=GCdrhXMP; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="GCdrhXMP"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1715779792; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=YOi4tDk8CK2U3Nzvqq2F2lyNfJlKybMBPqcVB0ycB68=;
	b=GCdrhXMP6A06ppJDsUWat8B6+aiQk/Xr3Jq6UlblPFi3O+HpptS41nu3jr4OWIz0KRWWQu8ACW24NvD0a9H3fxSOIO6YV6v/TRZhGmr8KkD92jTXjf0kgMWEW1DkboOqBD/MqwyJu3MqNEJJOpReiXQq7FCQjia3OGLbcDTLn84=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037067110;MF=mengferry@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0W6YDIG7_1715779788;
Received: from j66c13357.sqa.eu95.tbsite.net(mailfrom:mengferry@linux.alibaba.com fp:SMTPD_---0W6YDIG7_1715779788)
          by smtp.aliyun-inc.com;
          Wed, 15 May 2024 21:29:50 +0800
From: Ferry Meng <mengferry@linux.alibaba.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	Ferry Meng <mengferry@linux.alibaba.com>
Subject: [PATCH 2/2] ocfs2: strict bound check before memcmp in ocfs2_xattr_find_entry()
Date: Wed, 15 May 2024 21:29:34 +0800
Message-Id: <20240515132934.69511-3-mengferry@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20240515132934.69511-1-mengferry@linux.alibaba.com>
References: <20240515132934.69511-1-mengferry@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xattr in ocfs2 maybe not INLINE, but saved with additional space
requested. It's better to check if the memory is out of bound before
memcmp, although this possibility mainly comes from custom poisonous
images.

Signed-off-by: Ferry Meng <mengferry@linux.alibaba.com>
---
 fs/ocfs2/xattr.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 37be4a286faf..4ceb0cb4cb71 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1083,10 +1083,15 @@ static int ocfs2_xattr_find_entry(struct inode *inode, void *end,
 		cmp = name_index - ocfs2_xattr_get_type(entry);
 		if (!cmp)
 			cmp = name_len - entry->xe_name_len;
-		if (!cmp)
+		if (!cmp) {
+			if ((xs->base + le16_to_cpu(entry->xe_name_offset) + name_len) > end) {
+				ocfs2_error(inode->i_sb, "corrupted xattr entries");
+				return -EFSCORRUPTED;
+			}
 			cmp = memcmp(name, (xs->base +
 				     le16_to_cpu(entry->xe_name_offset)),
 				     name_len);
+		}
 		if (cmp == 0)
 			break;
 		entry += 1;
-- 
2.32.0.3.g01195cf9f

