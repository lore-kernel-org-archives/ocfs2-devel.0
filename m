Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A937439CD02
	for <ocfs2-devel@lists.linux.dev>; Tue,  1 Sep 2026 12:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788267150; cv=none; b=tsj7Mp3+KROkmlg4wwJrhwZzuc4EcFRvp9Rth9gd8uSVA2WN1M13i8V0nNcz4iTbIDCXdW4SDokXDrYYU0IT6EDOYENGQXjLarEytas9vRE28KE/HQh44gfoVBtCakDSo1nGF2J2aBCzIhS1162M2AllBVx0p3RWBzUd7U+RxU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788267150; c=relaxed/simple;
	bh=5R3l83+AnsGOP1omiDNJHnYYx4quuehlLcZf3o7Rddc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gkiPPv3YeOd7adKVXpEo+X2DWM8vU1EXuvFIDG8zy9jra4mfKlwQnp/WlLOUiKsfzZV6lrE1l/T8fS90wnShXWWNoA920KaoUyIK9evmjAZf4wxVXjjIqprPH6VThcACsIwl8YOSvqOGw48jPn4TDnnM62b2YKhoOIQO/LWpgr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=mJAiKH3T; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="mJAiKH3T"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788267143; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=yVWRK7fUCEudtcuozwBanmc7BlPTtipZ34kWdaYysDw=;
	b=mJAiKH3T60O0uxTJHp2D5foTpe3eMB572RH1adiJ22rKYJ7DkVh03qFg5y4HasVb/KJy1AVIoiPxVXpgycnTaloH8XIJQmnOpK3vr+Wd6mHmq/66rkGr5A9MD3L9SGdS848NM/RJrRiYi+ZnY8ep4VyFgorcZYIDXeCNGjdOyZE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XA8SdiZ_1788267142;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XA8SdiZ_1788267142 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 01 Sep 2026 20:52:23 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/4] ocfs2: restrict OCFS2_INVALID_SLOT suballoc slot to system inodes
Date: Tue,  1 Sep 2026 20:52:18 +0800
Message-Id: <20260901125221.1634686-2-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260901125221.1634686-1-joseph.qi@linux.alibaba.com>
References: <20260901125221.1634686-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_validate_inode_block() currently permits i_suballoc_slot to be
OCFS2_INVALID_SLOT for any dinode.  Only system inodes created by
mkfs.ocfs2 are allocated from the global allocator and thus
legitimately carry this value; regular inodes are always allocated
from a per-slot suballocator and hence must have a valid slot.

If a corrupted regular inode with OCFS2_INVALID_SLOT is accepted,
ocfs2_remove_inode() will pass the slot to ocfs2_get_system_file_inode()
and get_local_system_inode() will hit BUG_ON(slot == OCFS2_INVALID_SLOT)
when the inode is deleted.  This can be triggered by an unprivileged
user unlinking such a corrupted file.

Reject OCFS2_INVALID_SLOT for non-system dinodes during validation,
while still accepting it for system inodes.  Note that a crafted dinode
carrying OCFS2_SYSTEM_FL passes the check above, yet a plain lookup of
it still used to BUG() in ocfs2_read_locked_inode() ("system file state
is ambiguous").  Since i_flags comes from disk, handle that mismatch
with ocfs2_error() instead of BUG_ON() as well.

Fixes: fe7a283b3916 ("ocfs2: add suballoc slot check in ocfs2_validate_inode_block()")
Cc: stable@vger.kernel.org
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 180107a11046..9228d6ef23c2 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -638,14 +638,18 @@ static int ocfs2_read_locked_inode(struct inode *inode,
 	fe = (struct ocfs2_dinode *) bh->b_data;
 
 	/*
-	 * This is a code bug. Right now the caller needs to
-	 * understand whether it is asking for a system file inode or
-	 * not so the proper lock names can be built.
+	 * The caller must know whether it is asking for a system file inode
+	 * or not so the proper lock names can be built.  Since i_flags comes
+	 * from disk, a mismatch is filesystem corruption instead of a code
+	 * bug, so handle it with ocfs2_error() rather than BUG_ON().
 	 */
-	mlog_bug_on_msg(!!(fe->i_flags & cpu_to_le32(OCFS2_SYSTEM_FL)) !=
-			!!(args->fi_flags & OCFS2_FI_FLAG_SYSFILE),
-			"Inode %llu: system file state is ambiguous\n",
-			(unsigned long long)args->fi_blkno);
+	if (!!(fe->i_flags & cpu_to_le32(OCFS2_SYSTEM_FL)) !=
+	    !!(args->fi_flags & OCFS2_FI_FLAG_SYSFILE)) {
+		status = ocfs2_error(osb->sb,
+				     "Inode %llu: system file state is ambiguous\n",
+				     (unsigned long long)args->fi_blkno);
+		goto bail;
+	}
 
 	if (S_ISCHR(le16_to_cpu(fe->i_mode)) ||
 	    S_ISBLK(le16_to_cpu(fe->i_mode)))
@@ -1520,8 +1524,23 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
-	if (le16_to_cpu(di->i_suballoc_slot) != (u16)OCFS2_INVALID_SLOT &&
-	    (u32)le16_to_cpu(di->i_suballoc_slot) > OCFS2_SB(sb)->max_slots - 1) {
+	/*
+	 * Only system inodes created by mkfs.ocfs2 are allocated from the
+	 * global allocator and thus legitimately carry OCFS2_INVALID_SLOT.
+	 * Regular inodes are always allocated from a per-slot suballocator.
+	 * If a regular inode with OCFS2_INVALID_SLOT was accepted here,
+	 * deleting it would pass the slot to get_local_system_inode() via
+	 * ocfs2_remove_inode() and trigger BUG_ON(slot == OCFS2_INVALID_SLOT).
+	 */
+	if (le16_to_cpu(di->i_suballoc_slot) == (u16)OCFS2_INVALID_SLOT) {
+		if (!(le32_to_cpu(di->i_flags) & OCFS2_SYSTEM_FL)) {
+			rc = ocfs2_error(sb,
+					 "Invalid dinode %llu: suballoc slot %u for non-system inode\n",
+					 (unsigned long long)bh->b_blocknr,
+					 le16_to_cpu(di->i_suballoc_slot));
+			goto bail;
+		}
+	} else if ((u32)le16_to_cpu(di->i_suballoc_slot) > OCFS2_SB(sb)->max_slots - 1) {
 		rc = ocfs2_error(sb, "Invalid dinode %llu: suballoc slot %u\n",
 				 (unsigned long long)bh->b_blocknr,
 				 le16_to_cpu(di->i_suballoc_slot));
-- 
2.39.3

