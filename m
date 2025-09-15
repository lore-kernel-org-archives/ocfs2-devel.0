Received: from forward101a.mail.yandex.net (forward101a.mail.yandex.net [178.154.239.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633BC306D3F
	for <ocfs2-devel@lists.linux.dev>; Mon, 15 Sep 2025 12:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757938780; cv=none; b=iX0wCSb7G8+BnRevJNbJxPyQQ5QfVJuQ2rR7EVx7TyzgmqrX7XFohElmlxNxMPtyF0LGurppE7qNGCp/LrijbUpP937RPOAi49LLjJrTPmqP0Tw6/A7lH15LzVUpZl/odhSQgVTytevQeBJQd435B1s7RI6a9BpV1zh/s1LY/ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757938780; c=relaxed/simple;
	bh=2oCTa0uy7LSyBk1zthRNcSj/CMeHHgTnNxQetcxqgzU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Lqfpq0qofDy7pJ82FPpeKEuKvUqbMVLzpIcCeOcgG/aCXzZ/dttezJWCFAteRuw0NKGU5KDkvDLtwNk+ZCQQJPwFxzMDmduXibsqTbVjosG7S/uQdkdTVtdEeWV41zMn/06sX8a1NrtxF1YcHQn7SGKZ6IC7xpWGiuPpiHojgd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=Kqaa4XyD; arc=none smtp.client-ip=178.154.239.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="Kqaa4XyD"
Received: from mail-nwsmtp-smtp-production-main-55.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-55.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1f:582e:0:640:200:0])
	by forward101a.mail.yandex.net (Yandex) with ESMTPS id 8055980CFA;
	Mon, 15 Sep 2025 15:19:28 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-55.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id QJO92Q0MKmI0-ApRv4P7i;
	Mon, 15 Sep 2025 15:19:27 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1757938767; bh=r0IPCvh+lPpt196yVQRAAClGo2CwIJlqhqjQiFO7oFQ=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=Kqaa4XyDTdZSfhOyGZR8ZMFr6u8cj5imqvf/WOM2A/5xqwKKMZLSXb13B+2Bk1kw9
	 /5k5j21+lUsmWkgXUOF4Rg2NqNZa9HJNA4RY2ZY8gnKY0ZxJRXfgjTBRpHcxCznjYo
	 ZDkKJDYGFFVeLXigAUTrQqCD1zc/iUvj5oVO8P90=
Authentication-Results: mail-nwsmtp-smtp-production-main-55.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] ocfs2: avoid extra calls to strlen() after ocfs2_sprintf_system_inode_name()
Date: Mon, 15 Sep 2025 15:19:06 +0300
Message-ID: <20250915121906.514039-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since 'ocfs2_sprintf_system_inode_name()' uses 'snprintf()' and returns
the number of characters emitted, callers of the former are better to
use that return value instead of an explicit calls to 'strlen()'.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 fs/ocfs2/ioctl.c        | 18 +++++++-----------
 fs/ocfs2/move_extents.c |  6 +++---
 fs/ocfs2/sysfile.c      | 12 ++++++------
 3 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index db14c92302a1..b6864602814c 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -358,13 +358,11 @@ static int ocfs2_info_handle_freeinode(struct inode *inode,
 				goto bail;
 			}
 		} else {
-			ocfs2_sprintf_system_inode_name(namebuf,
-							sizeof(namebuf),
-							type, i);
+			int len = ocfs2_sprintf_system_inode_name(namebuf,
+								  sizeof(namebuf),
+								  type, i);
 			status = ocfs2_lookup_ino_from_name(osb->sys_root_inode,
-							    namebuf,
-							    strlen(namebuf),
-							    &blkno);
+							    namebuf, len, &blkno);
 			if (status < 0) {
 				status = -ENOENT;
 				goto bail;
@@ -651,12 +649,10 @@ static int ocfs2_info_handle_freefrag(struct inode *inode,
 			goto bail;
 		}
 	} else {
-		ocfs2_sprintf_system_inode_name(namebuf, sizeof(namebuf), type,
-						OCFS2_INVALID_SLOT);
+		int len = ocfs2_sprintf_system_inode_name(namebuf, sizeof(namebuf),
+							  type, OCFS2_INVALID_SLOT);
 		status = ocfs2_lookup_ino_from_name(osb->sys_root_inode,
-						    namebuf,
-						    strlen(namebuf),
-						    &blkno);
+						    namebuf, len, &blkno);
 		if (status < 0) {
 			status = -ENOENT;
 			goto bail;
diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index cbe2f8ed8897..a2b4c3f2a71c 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -375,9 +375,9 @@ static int ocfs2_find_victim_alloc_group(struct inode *inode,
 	struct ocfs2_dinode *ac_dinode;
 	struct ocfs2_group_desc *bg;
 
-	ocfs2_sprintf_system_inode_name(namebuf, sizeof(namebuf), type, slot);
-	ret = ocfs2_lookup_ino_from_name(osb->sys_root_inode, namebuf,
-					 strlen(namebuf), &blkno);
+	i = ocfs2_sprintf_system_inode_name(namebuf, sizeof(namebuf), type, slot);
+	ret = ocfs2_lookup_ino_from_name(osb->sys_root_inode, namebuf, i, &blkno);
+
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
2.51.0

