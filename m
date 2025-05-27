Received: from mail.nfschina.com (unknown [42.101.60.213])
	by smtp.subspace.kernel.org (Postfix) with SMTP id C07211DF26E
	for <ocfs2-devel@lists.linux.dev>; Tue, 27 May 2025 09:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=42.101.60.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748337839; cv=none; b=j31BJA5Vun/Rq0bkdkHgU3yKInWrI1feMWvdPfBGraVkB5laZqwIBKtSXJzyvnt25xx/kv8ieDjvP0EvuV0f8d4Ap1QjTRkjeYjJiTavj71C0ifKLHhMtVkrEYQiNLNbLl7ZT0m1ZyUtn06GqHjtT6zkDAMoexL8SdDShecSC1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748337839; c=relaxed/simple;
	bh=CCnEkgpQ+1TwgxHxoM1weGp5sp+orJMr3Y29XrJbaHg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=B18gNAT1ikDMKQDIdBBZfWCQGk5dNZUu/qewDbZVqcRBcQ6WeCOQ07KP3rU9evlECL3JEcLy2of2YCwYIVlhW7vEBjY5ru8jLz3nabMQ6SI1sLyrjDMJpJomfWxSlVqj3HTLCLtrflwrO9TjqEdtex3/ZfOJa8wmrWPEJG4f/DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nfschina.com; spf=pass smtp.mailfrom=nfschina.com; arc=none smtp.client-ip=42.101.60.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nfschina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nfschina.com
Received: from longsh.shanghai.nfschina.local (unknown [180.167.10.98])
	by mail.nfschina.com (MailData Gateway V2.8.8) with ESMTPSA id 58D6660190AA4;
	Tue, 27 May 2025 17:23:48 +0800 (CST)
X-MD-Sfrom: suhui@nfschina.com
X-MD-SrcIP: 180.167.10.98
From: Su Hui <suhui@nfschina.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: Su Hui <suhui@nfschina.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH] ocfs2: Replace simple_strtol with kstrtol
Date: Tue, 27 May 2025 17:23:34 +0800
Message-Id: <20250527092333.1917391-1-suhui@nfschina.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kstrtol() is better because simple_strtol() ignores overflow. And using
kstrtol() is more concise.

Signed-off-by: Su Hui <suhui@nfschina.com>
---
 fs/ocfs2/stack_user.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index 77edcd70f72c..0f045e45fa0c 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -360,7 +360,6 @@ static int ocfs2_control_do_setnode_msg(struct file *file,
 					struct ocfs2_control_message_setn *msg)
 {
 	long nodenum;
-	char *ptr = NULL;
 	struct ocfs2_control_private *p = file->private_data;
 
 	if (ocfs2_control_get_handshake_state(file) !=
@@ -375,8 +374,7 @@ static int ocfs2_control_do_setnode_msg(struct file *file,
 		return -EINVAL;
 	msg->space = msg->newline = '\0';
 
-	nodenum = simple_strtol(msg->nodestr, &ptr, 16);
-	if (!ptr || *ptr)
+	if (kstrtol(msg->nodestr, 16, &nodenum))
 		return -EINVAL;
 
 	if ((nodenum == LONG_MIN) || (nodenum == LONG_MAX) ||
@@ -391,7 +389,6 @@ static int ocfs2_control_do_setversion_msg(struct file *file,
 					   struct ocfs2_control_message_setv *msg)
 {
 	long major, minor;
-	char *ptr = NULL;
 	struct ocfs2_control_private *p = file->private_data;
 	struct ocfs2_protocol_version *max =
 		&ocfs2_user_plugin.sp_max_proto;
@@ -409,11 +406,9 @@ static int ocfs2_control_do_setversion_msg(struct file *file,
 		return -EINVAL;
 	msg->space1 = msg->space2 = msg->newline = '\0';
 
-	major = simple_strtol(msg->major, &ptr, 16);
-	if (!ptr || *ptr)
+	if (kstrtol(msg->major, 16, &major))
 		return -EINVAL;
-	minor = simple_strtol(msg->minor, &ptr, 16);
-	if (!ptr || *ptr)
+	if (kstrtol(msg->minor, 16, &minor))
 		return -EINVAL;
 
 	/*
@@ -441,7 +436,6 @@ static int ocfs2_control_do_down_msg(struct file *file,
 				     struct ocfs2_control_message_down *msg)
 {
 	long nodenum;
-	char *p = NULL;
 
 	if (ocfs2_control_get_handshake_state(file) !=
 	    OCFS2_CONTROL_HANDSHAKE_VALID)
@@ -456,8 +450,7 @@ static int ocfs2_control_do_down_msg(struct file *file,
 		return -EINVAL;
 	msg->space1 = msg->space2 = msg->newline = '\0';
 
-	nodenum = simple_strtol(msg->nodestr, &p, 16);
-	if (!p || *p)
+	if (kstrtol(msg->nodestr, 16, &nodenum))
 		return -EINVAL;
 
 	if ((nodenum == LONG_MIN) || (nodenum == LONG_MAX) ||
-- 
2.30.2

