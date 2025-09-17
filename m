Received: from forward101d.mail.yandex.net (forward101d.mail.yandex.net [178.154.239.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9D61EFFB4
	for <ocfs2-devel@lists.linux.dev>; Wed, 17 Sep 2025 06:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758089061; cv=none; b=QfKjDAVcKtQm2BOsoQ6JyjtEoFRdFlFONaHqg/4s/XCV3uJ/rEKOFdmJxZht0Gznq7vMfSklS0GSeUBsRtsCKvKmzpVVgew2Xog0n9aeA62w9ZGHGtB9Yn350aWChBsmkU6nVFn5oTFF6cIW/zM9G1K/G0Ni9hVeThr4jNP8H0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758089061; c=relaxed/simple;
	bh=ia44e/vNxsQs5dZnKuEpLT9xmciGPas/hsORw4WsZv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=guqFX1YPbKxc9Qpv7vHyi+26epn3L6BobnfJSRlnEjDMziw67w1c/Rch9Y9R/Qcmc9pyuaKVGSXOsd7YzQbRFOh2iDOrfKZTv48XK58jECAHvEOieEjUZK0te2fjx4YPdOEMnEGhl52WZxWGxG9RQIWcZIs4ZFry6jvC1WbCks8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=VooPiBBm; arc=none smtp.client-ip=178.154.239.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="VooPiBBm"
Received: from mail-nwsmtp-smtp-production-main-84.klg.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-84.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:3928:0:640:8b00:0])
	by forward101d.mail.yandex.net (Yandex) with ESMTPS id 3DF23C00E2;
	Wed, 17 Sep 2025 09:04:10 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-84.klg.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id 94KpCZ6L50U0-plLB23bp;
	Wed, 17 Sep 2025 09:04:09 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1758089049; bh=vDMC8iLVY4teZgvRV/oaPCHSQsxOcnAx7aNKhDVgZQ8=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=VooPiBBmd1gNCFHOggr5bQ+VK11xyR2c/T6se3541I7DLxT0GsUIZd9hruxKSaiqT
	 qPztq8f1dz5jR9NiMo2FbBZg7GNKc1jtUzEE8o3TZPzgBYwEhMhM1GlCIkTcL9Hpq7
	 Rif2iJ5sOP7rFmUuANF6p7GZ9z2J+rKs19fPygcU=
Authentication-Results: mail-nwsmtp-smtp-production-main-84.klg.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH v2] ocfs2: avoid extra calls to strlen() after ocfs2_sprintf_system_inode_name()
Date: Wed, 17 Sep 2025 09:02:29 +0300
Message-ID: <20250917060229.1854335-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <bd9f690a-19e6-4373-b0c2-e9622b7bd37b@linux.alibaba.com>
References: <bd9f690a-19e6-4373-b0c2-e9622b7bd37b@linux.alibaba.com>
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
v2: adjust 'ocfs2_find_victim_alloc_group()' to
    not (mis)use loop counter for length (Joseph)
---
 fs/ocfs2/ioctl.c        | 18 +++++++-----------
 fs/ocfs2/move_extents.c |  8 ++++----
 fs/ocfs2/sysfile.c      | 12 ++++++------
 3 files changed, 17 insertions(+), 21 deletions(-)

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
index cbe2f8ed8897..86f2631e6360 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -364,7 +364,7 @@ static int ocfs2_find_victim_alloc_group(struct inode *inode,
 					 int *vict_bit,
 					 struct buffer_head **ret_bh)
 {
-	int ret, i, bits_per_unit = 0;
+	int ret, i, len, bits_per_unit = 0;
 	u64 blkno;
 	char namebuf[40];
 
@@ -375,9 +375,9 @@ static int ocfs2_find_victim_alloc_group(struct inode *inode,
 	struct ocfs2_dinode *ac_dinode;
 	struct ocfs2_group_desc *bg;
 
-	ocfs2_sprintf_system_inode_name(namebuf, sizeof(namebuf), type, slot);
-	ret = ocfs2_lookup_ino_from_name(osb->sys_root_inode, namebuf,
-					 strlen(namebuf), &blkno);
+	len = ocfs2_sprintf_system_inode_name(namebuf, sizeof(namebuf), type, slot);
+	ret = ocfs2_lookup_ino_from_name(osb->sys_root_inode, namebuf, len, &blkno);
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

