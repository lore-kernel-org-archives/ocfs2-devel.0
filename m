Received: from forward100a.mail.yandex.net (forward100a.mail.yandex.net [178.154.239.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD331BD9F9
	for <ocfs2-devel@lists.linux.dev>; Tue, 10 Dec 2024 16:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733848690; cv=none; b=MC0hWyxnokXM3+BhpU9HxRnrr3iqwLHES3tuKVVCg0XxHSBQPB96avYlgofMXf/UCHUmD2PpDz2+VBw3WD26ab/9grM7/fQA17v0yEKD4D2czaqrNRt0wAIDpxEZwo5yXjqiyafaP+SpqAcnmEjxBZNJyCaSHNUmzc103BgrnZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733848690; c=relaxed/simple;
	bh=2GGiuRt5m4fR+HfOLxdOZmF6BABvHlu0ZSC+HNhYus8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RV0P1kFf65UAfWpaBmYx6YPN73HIm1F3ntG4nFMtDP/z7uyOKkZ09qqdoqy/g7fhldqLwwOaqVldpoByhmNkz9flXnDSBxqhYxJ+m1qxPevDGDDd+9d8yjLnsjcAIDl66C2OhodcTTsKXZP0XYWOqSJuYs4swTxR83Cqv44OmCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=aeiUmt05; arc=none smtp.client-ip=178.154.239.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="aeiUmt05"
Received: from mail-nwsmtp-smtp-production-main-67.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-67.vla.yp-c.yandex.net [IPv6:2a02:6b8:c15:2c1c:0:640:7de8:0])
	by forward100a.mail.yandex.net (Yandex) with ESMTPS id 6C3E6470BE;
	Tue, 10 Dec 2024 19:37:57 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-67.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id ubp8Sx4OpiE0-n3Cefxn4;
	Tue, 10 Dec 2024 19:37:56 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1733848676; bh=GDtzDCNWWvPTlEeA02bCkmdthSLKu43VRBzKZottOZo=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=aeiUmt05BdfOYzHgHbWRyGfViKRKnKTEiRtLx9HbyvPI2o+WMqfrJt1T4VJWK/XiE
	 BUEdRUBPXf9paEF4FSm+osSBUGKFWBtVfihivbs5w2a4+hTMVohYc9Ak6jtCoyOF8E
	 jrkx3J2IKKh3vNg4sVJjB6o8uFEO9HG66baRWZVA=
Authentication-Results: mail-nwsmtp-smtp-production-main-67.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] ocfs2: avoid extra calls to strlen()
Date: Tue, 10 Dec 2024 19:37:23 +0300
Message-ID: <20241210163723.20137-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since 'ocfs2_sprintf_system_inode_name()' returns the
number of characters emitted, avoid extra calls to
'strlen()' where appropriate. Compile tested only.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 fs/ocfs2/ioctl.c        | 21 +++++++++------------
 fs/ocfs2/move_extents.c |  9 +++++----
 fs/ocfs2/sysfile.c      | 12 ++++++------
 3 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index 71beef7f8a60..cec70bf4e478 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -329,7 +329,7 @@ static int ocfs2_info_handle_freeinode(struct inode *inode,
 	u32 i;
 	u64 blkno = -1;
 	char namebuf[40];
-	int status, type = INODE_ALLOC_SYSTEM_INODE;
+	int len, status, type = INODE_ALLOC_SYSTEM_INODE;
 	struct ocfs2_info_freeinode *oifi = NULL;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct inode *inode_alloc = NULL;
@@ -358,12 +358,11 @@ static int ocfs2_info_handle_freeinode(struct inode *inode,
 				goto bail;
 			}
 		} else {
-			ocfs2_sprintf_system_inode_name(namebuf,
-							sizeof(namebuf),
-							type, i);
+			len = ocfs2_sprintf_system_inode_name(namebuf,
+							      sizeof(namebuf),
+							      type, i);
 			status = ocfs2_lookup_ino_from_name(osb->sys_root_inode,
-							    namebuf,
-							    strlen(namebuf),
+							    namebuf, len,
 							    &blkno);
 			if (status < 0) {
 				status = -ENOENT;
@@ -616,7 +615,7 @@ static int ocfs2_info_handle_freefrag(struct inode *inode,
 {
 	u64 blkno = -1;
 	char namebuf[40];
-	int status, type = GLOBAL_BITMAP_SYSTEM_INODE;
+	int len, status, type = GLOBAL_BITMAP_SYSTEM_INODE;
 
 	struct ocfs2_info_freefrag *oiff;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
@@ -651,12 +650,10 @@ static int ocfs2_info_handle_freefrag(struct inode *inode,
 			goto bail;
 		}
 	} else {
-		ocfs2_sprintf_system_inode_name(namebuf, sizeof(namebuf), type,
-						OCFS2_INVALID_SLOT);
+		len = ocfs2_sprintf_system_inode_name(namebuf, sizeof(namebuf),
+						      type, OCFS2_INVALID_SLOT);
 		status = ocfs2_lookup_ino_from_name(osb->sys_root_inode,
-						    namebuf,
-						    strlen(namebuf),
-						    &blkno);
+						    namebuf, len, &blkno);
 		if (status < 0) {
 			status = -ENOENT;
 			goto bail;
diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index f9d6a4f9ca92..c1b7c6cee95d 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -364,7 +364,7 @@ static int ocfs2_find_victim_alloc_group(struct inode *inode,
 					 int *vict_bit,
 					 struct buffer_head **ret_bh)
 {
-	int ret, i, bits_per_unit = 0;
+	int len, ret, i, bits_per_unit = 0;
 	u64 blkno;
 	char namebuf[40];
 
@@ -375,9 +375,10 @@ static int ocfs2_find_victim_alloc_group(struct inode *inode,
 	struct ocfs2_dinode *ac_dinode;
 	struct ocfs2_group_desc *bg;
 
-	ocfs2_sprintf_system_inode_name(namebuf, sizeof(namebuf), type, slot);
-	ret = ocfs2_lookup_ino_from_name(osb->sys_root_inode, namebuf,
-					 strlen(namebuf), &blkno);
+	len = ocfs2_sprintf_system_inode_name(namebuf, sizeof(namebuf),
+					      type, slot);
+	ret = ocfs2_lookup_ino_from_name(osb->sys_root_inode,
+					 namebuf, len, &blkno);
 	if (ret) {
 		ret = -ENOENT;
 		goto out;
diff --git a/fs/ocfs2/sysfile.c b/fs/ocfs2/sysfile.c
index 53a945da873b..d53a6cc866be 100644
--- a/fs/ocfs2/sysfile.c
+++ b/fs/ocfs2/sysfile.c
@@ -127,14 +127,14 @@ static struct inode * _ocfs2_get_system_file_inode(struct ocfs2_super *osb,
 	char namebuf[40];
 	struct inode *inode = NULL;
 	u64 blkno;
-	int status = 0;
+	int len, status = 0;
 
-	ocfs2_sprintf_system_inode_name(namebuf,
-					sizeof(namebuf),
-					type, slot);
+	len = ocfs2_sprintf_system_inode_name(namebuf,
+					      sizeof(namebuf),
+					      type, slot);
 
-	status = ocfs2_lookup_ino_from_name(osb->sys_root_inode, namebuf,
-					    strlen(namebuf), &blkno);
+	status = ocfs2_lookup_ino_from_name(osb->sys_root_inode,
+					    namebuf, len, &blkno);
 	if (status < 0) {
 		goto bail;
 	}
-- 
2.47.1

