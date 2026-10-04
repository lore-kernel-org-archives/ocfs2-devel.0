Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B90638F947
	for <ocfs2-devel@lists.linux.dev>; Sun,  4 Oct 2026 07:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791097626; cv=none; b=tPYkj8foAFjAn5mMni/T1e36EKFX0dZW0XH7csj+xU53OiZ2p/SnhdPiORuO6ismG1EXkwl6CQiSGXckJzRhaq1DuOWAhaNidFTFkqLepiS6Rz9haWanv+PcxJbPpI4i/gP9iKHiMudDz01YFoTB6qar7hoV+u9wZTPen3isPR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791097626; c=relaxed/simple;
	bh=DK2eifcovet8h/SmwwScHQv3176cktcJee8HEgGjHIM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ktUcnGHMOpJ/h9F81OI51g9ynBiHBIovIPxWt7OoT5j4tCcFUK0DSxpysuMrYso2yG6xbqHTETPqr23UdssXM6ETGCW2zooLqv/re1BZuUlkHO3JTKIujcfUA8lrQ0gz2P1cs6Cp7W6Ei7zGZdrxxM420Nzp0NS253hIXQXs56Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=lNxJb7az; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="lNxJb7az"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Eo
	fF1pUuYM/8yrp9ow9pXLzzi6rmvkTnwrMZgD5i4Rg=; b=lNxJb7aznl4moU1bzv
	TMujjpXjDIHD4cPzlgP2m7sd107SWELxVddVM5jE/5KruR5kE8CVn89LjuG0HwaC
	eyYKXCly9Hf6B59icr602oHUZv3J0ubQG2LBSwJIl2hWYjymDNvBB8E0OtK8dbEP
	ZWVYgn9oSzQwCwsWV860uEq7Y=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wDXv8vw+sFqXKtkCQ--.30279S2;
	Sun, 04 Oct 2026 15:06:25 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Gang He <ghe@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH v2] ocfs2: validate filecheck inode slots
Date: Sun,  4 Oct 2026 15:06:21 +0800
Message-Id: <20261004070621.1514598-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDXv8vw+sFqXKtkCQ--.30279S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3XF4xWFyfAry8WrWfuryxAFb_yoW7Cr4DpF
	yYvryagrW8JFyxuas7try2qw1Skw1UG347GrsIy34Yvrn0yFyqkF95J347WFyrKry8Xw12
	ga15urW7WayxuaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pEqg47UUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC7xEGQGrB+vHmmQAA3n

The online filecheck path reads inodes with
ocfs2_filecheck_validate_inode_block() instead of
ocfs2_validate_inode_block(). It does not check the slot fields used by
ocfs2_get_system_file_inode() to index slot-local system inodes.

A corrupted dinode can set OCFS2_ORPHANED_FL or
OCFS2_DIO_ORPHANED_FL while carrying an out-of-range orphan slot. An
out-of-range i_suballoc_slot can also bypass the normal validator through
the filecheck path. These values can later cause an out-of-bounds access
when used as slot indices.

Share predicate helpers between the normal and filecheck validators so
both paths enforce the same bounds while retaining their own logging and
error handling. Reject invalid slots in the repair path as well, since the
correct slot cannot be recovered.

This was reproduced on Linux 7.3-rc4 in an x86_64 QEMU guest with KASAN.
Online filecheck of a corrupted inode reported a slab-out-of-bounds read
in ocfs2_evict_inode(), reached from ocfs2_filecheck_attr_store().

Fixes: d56a8f32e4c6 ("ocfs2: check/fix inode block for online file check")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---

Notes:
    Changes in v2:
    - Extract the slot validity conditions from ocfs2_validate_inode_block()
      into predicates shared with the filecheck paths.
    - Keep logging and error handling local to each validator.
    - Fix the Fixes tag and include the KASAN reproduction information.

 fs/ocfs2/inode.c | 68 +++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 62 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 180107a11046..e5a7e53fffe5 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -249,6 +249,33 @@ static int ocfs2_dinode_has_extents(struct ocfs2_dinode *di)
 	return 1;
 }
 
+static int
+ocfs2_dinode_has_invalid_suballoc_slot(struct super_block *sb,
+				       struct ocfs2_dinode *di)
+{
+	u16 slot = le16_to_cpu(di->i_suballoc_slot);
+
+	return slot != (u16)OCFS2_INVALID_SLOT &&
+	       slot >= OCFS2_SB(sb)->max_slots;
+}
+
+static int
+ocfs2_dinode_has_invalid_orphan_slot(struct super_block *sb,
+				     struct ocfs2_dinode *di)
+{
+	return (le32_to_cpu(di->i_flags) & OCFS2_ORPHANED_FL) &&
+	       le16_to_cpu(di->i_orphaned_slot) >= OCFS2_SB(sb)->max_slots;
+}
+
+static int
+ocfs2_dinode_has_invalid_dio_orphan_slot(struct super_block *sb,
+					 struct ocfs2_dinode *di)
+{
+	return (le32_to_cpu(di->i_flags) & OCFS2_DIO_ORPHANED_FL) &&
+	       le16_to_cpu(di->i_dio_orphaned_slot) >=
+	       OCFS2_SB(sb)->max_slots;
+}
+
 /*
  * here's how inodes get read from disk:
  * iget5_locked -> find_actor -> OCFS2_FIND_ACTOR
@@ -1520,24 +1547,21 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
-	if (le16_to_cpu(di->i_suballoc_slot) != (u16)OCFS2_INVALID_SLOT &&
-	    (u32)le16_to_cpu(di->i_suballoc_slot) > OCFS2_SB(sb)->max_slots - 1) {
+	if (ocfs2_dinode_has_invalid_suballoc_slot(sb, di)) {
 		rc = ocfs2_error(sb, "Invalid dinode %llu: suballoc slot %u\n",
 				 (unsigned long long)bh->b_blocknr,
 				 le16_to_cpu(di->i_suballoc_slot));
 		goto bail;
 	}
 
-	if ((le32_to_cpu(di->i_flags) & OCFS2_ORPHANED_FL) &&
-	    le16_to_cpu(di->i_orphaned_slot) >= OCFS2_SB(sb)->max_slots) {
+	if (ocfs2_dinode_has_invalid_orphan_slot(sb, di)) {
 		rc = ocfs2_error(sb, "Invalid dinode %llu: orphaned slot %u\n",
 				 (unsigned long long)bh->b_blocknr,
 				 le16_to_cpu(di->i_orphaned_slot));
 		goto bail;
 	}
 
-	if ((le32_to_cpu(di->i_flags) & OCFS2_DIO_ORPHANED_FL) &&
-	    le16_to_cpu(di->i_dio_orphaned_slot) >= OCFS2_SB(sb)->max_slots) {
+	if (ocfs2_dinode_has_invalid_dio_orphan_slot(sb, di)) {
 		rc = ocfs2_error(sb, "Invalid dinode %llu: DIO orphaned slot %u\n",
 				 (unsigned long long)bh->b_blocknr,
 				 le16_to_cpu(di->i_dio_orphaned_slot));
@@ -1835,6 +1859,33 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	if (ocfs2_dinode_has_invalid_suballoc_slot(sb, di)) {
+		mlog(ML_ERROR,
+		     "Filecheck: invalid dinode #%llu: suballoc slot %u\n",
+		     (unsigned long long)bh->b_blocknr,
+		     le16_to_cpu(di->i_suballoc_slot));
+		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+		goto bail;
+	}
+
+	if (ocfs2_dinode_has_invalid_orphan_slot(sb, di)) {
+		mlog(ML_ERROR,
+		     "Filecheck: invalid dinode #%llu: orphaned slot %u\n",
+		     (unsigned long long)bh->b_blocknr,
+		     le16_to_cpu(di->i_orphaned_slot));
+		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+		goto bail;
+	}
+
+	if (ocfs2_dinode_has_invalid_dio_orphan_slot(sb, di)) {
+		mlog(ML_ERROR,
+		     "Filecheck: invalid dinode #%llu: DIO orphaned slot %u\n",
+		     (unsigned long long)bh->b_blocknr,
+		     le16_to_cpu(di->i_dio_orphaned_slot));
+		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+		goto bail;
+	}
+
 	if (ocfs2_dinode_has_size_without_clusters(sb, di)) {
 		if (S_ISDIR(le16_to_cpu(di->i_mode)))
 			mlog(ML_ERROR,
@@ -1893,6 +1944,11 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
 		return -OCFS2_FILECHECK_ERR_VALIDFLAG;
 	}
 
+	if (ocfs2_dinode_has_invalid_suballoc_slot(sb, di) ||
+	    ocfs2_dinode_has_invalid_orphan_slot(sb, di) ||
+	    ocfs2_dinode_has_invalid_dio_orphan_slot(sb, di))
+		return -OCFS2_FILECHECK_ERR_INVALIDINO;
+
 	if (le64_to_cpu(di->i_blkno) != bh->b_blocknr) {
 		di->i_blkno = cpu_to_le64(bh->b_blocknr);
 		changed = 1;
-- 
2.34.1

