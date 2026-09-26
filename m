Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by smtp.subspace.kernel.org (Postfix) with SMTP id DBA20449B2B
	for <ocfs2-devel@lists.linux.dev>; Sat, 26 Sep 2026 13:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790430916; cv=none; b=iGBM3VLYhy9zSy/1lPXZNnRBUlLtVWwHc5sAsCeiqGREHRHBOd/DsSFGRPI+D4yopc0ttAK9B4s+JS2ZfyH5hVnr7La8Mf0FZXsghipjWcQGvbkirfuUULJGvK+VD/ckpSd//+qtG55l24evKIaWiI8IkH77uqH/wMBFAjXJnAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790430916; c=relaxed/simple;
	bh=YSm7PDSD7YQ5Kyna8L6yagS8jxKfWLhHBOiXFGWWYtQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JBoe1Mzm/RgrRYIc6qmyLaHnY86lwk18qSBVddaEGiVH78QGir93Xv7I9sgiRlvUFU0yKFDy7/Luv61kpDeG/eTQUFBZNUVmWxduppUNm/T8/OZU57wPZLW7B0lTB84U4E0lH31SNKGfzjjDkCl+t/pBRcmKHy121sycmJD/cZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=M/ePmRZy; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="M/ePmRZy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Ot
	yj80G23cc+R05rO+2Y+56r/yE3PniSD5GFFqBi3OE=; b=M/ePmRZyu4u6gmRp81
	FsN6EpNyFpzq4FiFxpsFfHnUcoPTEX0HonzWp4U/apr5DRgeNE15y3EeIazUA68j
	uIPbOVpMphNHIQxmDL11F3G49zKpmu2TQZ6QwHPafz1dcoyKoYJx7lF0zACBpnff
	zLx5yQZ5hyOaGqtzlgGob5Nf8=
Received: from pc.localdomain (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgAH11JzzrdqHnkHBg--.10131S2;
	Sat, 26 Sep 2026 21:53:56 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	ZhengYuan Huang <gality369@gmail.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH] ocfs2: validate filecheck inode slots
Date: Sat, 26 Sep 2026 21:53:53 +0800
Message-Id: <20260926135354.3420193-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgAH11JzzrdqHnkHBg--.10131S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxWr17KFWfZry7XF4xKr15urg_yoW5uFW5pF
	1a9r1agr18GF1xu3Z3t34UXr1Skw1rWry7GFsaya45Xrn5tF9Fkas5Ary7WFyftr90q3W2
	9a15ZFW7u34xuaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pEubyLUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC8BRZk2q3znStPgAA3a

The online filecheck path reads inodes with
ocfs2_filecheck_validate_inode_block() instead of
ocfs2_validate_inode_block().  It does not check the slot fields that
are used as indices into arrays sized by osb->max_slots.

A corrupted dinode can set OCFS2_ORPHANED_FL or
OCFS2_DIO_ORPHANED_FL while carrying an out-of-range orphan slot.  An
out-of-range i_suballoc_slot can also bypass the normal validator
through the filecheck path.  These values can later be used to index
the slot-local system inode array.

Mirror the normal validator's slot checks in the filecheck validator.
Reject invalid slots in the repair path as well, since the correct
slot cannot be recovered.

Fixes: bb88131c9831 ("ocfs2: validate DIO orphan slot during inode read")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 fs/ocfs2/inode.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 180107a11046..ab82cf9146ef 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1754,6 +1754,44 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 	return rc;
 }
 
+/*
+ * Validate the slot fields used as indices into arrays sized by
+ * osb->max_slots.  The filecheck path uses this validator instead of
+ * ocfs2_validate_inode_block(), so it must enforce the same bounds.
+ */
+static int ocfs2_filecheck_validate_slots(struct super_block *sb,
+					  struct ocfs2_dinode *di,
+					  unsigned long long blkno)
+{
+	struct ocfs2_super *osb = OCFS2_SB(sb);
+
+	if (le16_to_cpu(di->i_suballoc_slot) != (u16)OCFS2_INVALID_SLOT &&
+	    (u32)le16_to_cpu(di->i_suballoc_slot) > osb->max_slots - 1) {
+		mlog(ML_ERROR,
+		     "Filecheck: invalid dinode #%llu: suballoc slot %u\n",
+		     blkno, le16_to_cpu(di->i_suballoc_slot));
+		return -OCFS2_FILECHECK_ERR_INVALIDINO;
+	}
+
+	if ((le32_to_cpu(di->i_flags) & OCFS2_ORPHANED_FL) &&
+	    le16_to_cpu(di->i_orphaned_slot) >= osb->max_slots) {
+		mlog(ML_ERROR,
+		     "Filecheck: invalid dinode #%llu: orphaned slot %u\n",
+		     blkno, le16_to_cpu(di->i_orphaned_slot));
+		return -OCFS2_FILECHECK_ERR_INVALIDINO;
+	}
+
+	if ((le32_to_cpu(di->i_flags) & OCFS2_DIO_ORPHANED_FL) &&
+	    le16_to_cpu(di->i_dio_orphaned_slot) >= osb->max_slots) {
+		mlog(ML_ERROR,
+		     "Filecheck: invalid dinode #%llu: DIO orphaned slot %u\n",
+		     blkno, le16_to_cpu(di->i_dio_orphaned_slot));
+		return -OCFS2_FILECHECK_ERR_INVALIDINO;
+	}
+
+	return 0;
+}
+
 static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 						struct buffer_head *bh)
 {
@@ -1835,6 +1873,10 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	rc = ocfs2_filecheck_validate_slots(sb, di, bh->b_blocknr);
+	if (rc)
+		goto bail;
+
 	if (ocfs2_dinode_has_size_without_clusters(sb, di)) {
 		if (S_ISDIR(le16_to_cpu(di->i_mode)))
 			mlog(ML_ERROR,
@@ -1893,6 +1935,9 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
 		return -OCFS2_FILECHECK_ERR_VALIDFLAG;
 	}
 
+	if (ocfs2_filecheck_validate_slots(sb, di, bh->b_blocknr))
+		return -OCFS2_FILECHECK_ERR_INVALIDINO;
+
 	if (le64_to_cpu(di->i_blkno) != bh->b_blocknr) {
 		di->i_blkno = cpu_to_le64(bh->b_blocknr);
 		changed = 1;
-- 
2.34.1

