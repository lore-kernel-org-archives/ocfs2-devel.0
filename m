Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE7920E334
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Jul 2026 04:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783656325; cv=none; b=hZjpNj785YwCuwLkWAKYSlDODgZGJ6W3OqJMzYxD0gU0BgQsznPVUbX2GoJt6ebxhEfd5Y1bjQ2VlQfVHqOnwLoANRJPQ9OHvu26cqYxqRQr57uT458VkI1bY0I4m1bEOXTXm4HjGJOdWnMeorj92Me20hVmiizwvVsOWY6elLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783656325; c=relaxed/simple;
	bh=rm79TWkic+Rq06rKReJm9mEJujRKDTmzQSoOVpmtwUI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gNXZ1WYLqUwKX7zNioiN8HcdnmXAsIyUJ70I4QgWNSGmIloEx0+KAz1BDN95joSXFVVsrrThD9E46SrtNYfs884I3GKYgK49iuKdQAKdHjJKvXB2E63ubEjWhbh89MzkUrthgagVhFAQqGKIstTwjW0omaLTWz/em3v6U4TueU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=A+H1nci7; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="A+H1nci7"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783656313; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=WlUeLkABVKtf7psjdIBHU9lx9UC31omiBN1CwOJFo3A=;
	b=A+H1nci7EcpJM4QYXPrChftVcSgRrHkxod9o/PFhVjC+G4No1+BsfT4MHiEeS/K9deTDhDrRjp+ABG3IMfTj2YbOpFjAlaj6v4entYiHezxUxFXj8JGyCoBYr5YgbOCyNsAyeW2TPieBBX3aQkTV5saFCWJXkcAhGO4+6MDJBc0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R301e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X6mRzPB_1783656312;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X6mRzPB_1783656312 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 10 Jul 2026 12:05:12 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Dmitry Antipov <dmantipov@yandex.ru>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ocfs2: fix boundary check in ocfs2_check_dir_entry() to use buffer offset
Date: Fri, 10 Jul 2026 12:05:12 +0800
Message-Id: <20260710040512.3310736-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 390ac56cf0f6 ("ocfs2: add boundary check to ocfs2_check_dir_entry()")
added an out-of-bounds guard using the caller-supplied 'offset' argument:

	if (offset > size - OCFS2_DIR_REC_LEN(1))
		return 0;

However, 'offset' and 'size' are not measured against the same base for
all callers. In the block-based lookup path, ocfs2_find_entry_el() passes
'offset' as an absolute offset into the whole directory:

	i = ocfs2_search_dirblock(bh, dir, name, namelen,
				  block << sb->s_blocksize_bits,
				  bh->b_data, sb->s_blocksize, res_dir);

while 'size' is a single block size (sb->s_blocksize). For any directory
entry located in the second or later block, 'offset' is >= sb->s_blocksize,
so the guard rejects every such entry even though it is perfectly valid and
lies entirely within its block buffer.

This makes mounting fail for filesystems whose system directory spans more
than one block, e.g. a volume formatted with a small block size:

  mkfs.ocfs2 -b 512 -C 4096 -N 2 -T datafiles --fs-features=usrquota,grpquota

  ocfs2_check_dir_entry:314 ERROR: directory entry (#18: offset=512) too close to end or out-of-bounds
  ocfs2_init_local_system_inodes:496 ERROR: status=-22, sysfile=12, slot=0
  ocfs2_mount_volume:1757 ERROR: status = -22

The dirent's position within the buffer being validated is
((char *)de - buf), which is what the rest of the function already uses
(via next_offset) and what must be bounds-checked against 'size'. Compute
that buffer-relative offset and use it for the guard. The subtraction is
reordered to size - buf_offset < OCFS2_DIR_REC_LEN(1) to avoid an unsigned
underflow when size is smaller than the minimal record length.

Fixes: 390ac56cf0f6 ("ocfs2: add boundary check to ocfs2_check_dir_entry()")
Cc: stable@vger.kernel.org
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/dir.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 8e6b032383278..d7fc3cccf2f4b 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -302,10 +302,11 @@ static int ocfs2_check_dir_entry(struct inode *dir,
 				 unsigned long offset)
 {
 	const char *error_msg = NULL;
+	unsigned long buf_offset = (char *)de - buf;
 	unsigned long next_offset;
 	int rlen;
 
-	if (offset > size - OCFS2_DIR_REC_LEN(1)) {
+	if (buf_offset > size || size - buf_offset < OCFS2_DIR_REC_LEN(1)) {
 		/* Dirent is (maybe partially) beyond the buffer
 		 * boundaries so touching 'de' members is unsafe.
 		 */
@@ -316,7 +317,7 @@ static int ocfs2_check_dir_entry(struct inode *dir,
 	}
 
 	rlen = le16_to_cpu(de->rec_len);
-	next_offset = ((char *) de - buf) + rlen;
+	next_offset = buf_offset + rlen;
 
 	if (unlikely(rlen < OCFS2_DIR_REC_LEN(1)))
 		error_msg = "rec_len is smaller than minimal";
-- 
2.39.3

