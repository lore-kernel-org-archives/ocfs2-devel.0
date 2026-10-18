Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312E2476694
	for <ocfs2-devel@lists.linux.dev>; Sun, 18 Oct 2026 11:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792323725; cv=none; b=BLpcEU1Xq7KzekoYXuyGEGARhiEO2YqQ4UidsCPSEAtXogGyQGshmpn50j3Zw/xz6t5AdRgNPxur0KckAlVSc6ybuI86LB2tv20kdYfIZ1hojD0Hh8sNVKqD8dl8rrFodQkeOf/X7f4rk2KHg5lavVJ1Pqsiem+9NC2OrVMxie8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792323725; c=relaxed/simple;
	bh=bXsCJRA4jNQvLgIs0l8usy3AHnQsGPJyeWifaqvT02E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oWdEeZl3vqJaprKTqLKh6nBCLVtgSO6URXvwIDnyC3YaC3O33Q9U8ZcwAAuTEQtUH87y7H4Y4wmGvobf9XzdW0c+BuEo3dRG1WUIPHAvcYDvySriWvBJ6F9H0H/Zn7GSVunY0P1O87IIKy+9Zxrep2bcj4LajEP59GF797MZTxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=XQ0OYWr9; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="XQ0OYWr9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=2F
	zkbN2+A67YXpUgKZhi6vxnkn1VkyqkN/cg0BQ5fpQ=; b=XQ0OYWr9TGHRp/n+o6
	OoOzZO0sKrlkv9zUNGiJZee27VIWgscgi0hE2px14xJdxLs5iSld4f/SiYgGTi/y
	q3xpBih7ETIKdRdeU5r0CmkESu+oL+l18IY+zspogZjSGfLhJI+RE0BSixR3qEGE
	Z3VhdRdXMWXP859ICV0bUesiA=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wDnt9ltsNRqcMzBAg--.63058S2;
	Sun, 18 Oct 2026 19:41:34 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Tristan Ye <tristan.ye@oracle.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH] ocfs2: use validated allocator metadata for move extents
Date: Sun, 18 Oct 2026 19:41:31 +0800
Message-Id: <20261018114131.927291-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnt9ltsNRqcMzBAg--.63058S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ur1UCw43tr4Utw1fZw15CFg_yoW8Kry3pa
	y3AFnxKr93J34I9w1kta4DX3WF9ay8Ga17GFWrJw1xXF4jqw1qg34ktr15uFyrtFW8Jr1j
	vr4YyF18Jw45KaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piU5r7UUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzQ4XUWrUsG6VUgAA3i

ocfs2_find_victim_alloc_group() reads the allocator inode and group
descriptors as raw blocks. It then uses their chain counts, bitmap sizes,
and chain indices without validation. Malformed metadata can therefore
cause out-of-bounds chain or bitmap accesses.

Obtain the allocator system inode and use the standard inode and group
descriptor readers so all metadata is validated before use.

Fixes: 1c06b9126130 ("Ocfs2/move_extents: find the victim alloc group, where the given #blk fits.")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 fs/ocfs2/move_extents.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index ad1678ee7cc4..38c3757251ad 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -370,26 +370,23 @@ static int ocfs2_find_victim_alloc_group(struct inode *inode,
 					 int *vict_bit,
 					 struct buffer_head **ret_bh)
 {
-	int ret, i, len, bits_per_unit = 0;
-	u64 blkno;
-	char namebuf[40];
-
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct buffer_head *ac_bh = NULL, *gd_bh = NULL;
 	struct ocfs2_chain_list *cl;
 	struct ocfs2_chain_rec *rec;
 	struct ocfs2_dinode *ac_dinode;
 	struct ocfs2_group_desc *bg;
+	struct inode *alloc_inode;
+	int ret, i, bits_per_unit = 0;
+	u64 blkno;
 
-	len = ocfs2_sprintf_system_inode_name(namebuf, sizeof(namebuf), type, slot);
-	ret = ocfs2_lookup_ino_from_name(osb->sys_root_inode, namebuf, len, &blkno);
-
-	if (ret) {
-		ret = -ENOENT;
+	alloc_inode = ocfs2_get_system_file_inode(osb, type, slot);
+	if (!alloc_inode) {
+		ret = -EIO;
 		goto out;
 	}
 
-	ret = ocfs2_read_blocks_sync(osb, blkno, 1, &ac_bh);
+	ret = ocfs2_read_inode_block(alloc_inode, &ac_bh);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -431,7 +428,8 @@ static int ocfs2_find_victim_alloc_group(struct inode *inode,
 				gd_bh = NULL;
 			}
 
-			ret = ocfs2_read_blocks_sync(osb, blkno, 1, &gd_bh);
+			ret = ocfs2_read_group_descriptor(alloc_inode, ac_dinode,
+				     blkno, &gd_bh);
 			if (ret) {
 				mlog_errno(ret);
 				goto out;
@@ -458,6 +456,7 @@ static int ocfs2_find_victim_alloc_group(struct inode *inode,
 	ret = -EINVAL;
 out:
 	brelse(ac_bh);
+	iput(alloc_inode);
 
 	/*
 	 * caller has to release the gd_bh properly.
-- 
2.34.1

