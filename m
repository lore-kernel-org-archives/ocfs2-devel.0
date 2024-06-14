Received: from smtp.smtpout.orange.fr (smtp-13.smtpout.orange.fr [80.12.242.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F5282C67
	for <ocfs2-devel@lists.linux.dev>; Fri, 14 Jun 2024 20:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718398713; cv=none; b=QxUf0wQIUnNZviXiLvkqiIuDfyKBpWdAJu9rWYttEjZjnuGW6sFzjqdIFqDZ+0PZYIPM+Dk3PWrWIfdafwBWS8elsC8vUxqGWfSp4rN8Sio1MWaEys+K4DsKS0RodpnfCkcc9JTKf0U5DHfbiU+BnX6CHn1FMbSsu+pIowgiBrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718398713; c=relaxed/simple;
	bh=KMO7Zfugy9M15xMn9DWM7ExCCPIjAnsh8V/2u166Wjk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JPn5+i7qshcp3ESaiAgMzBymKXCXMLttsKDrrKMySXEwr8HZc5z2QfeXdKIACkILoCP9THtEaiZqcCZxJWwycrpU1XdarHJ47NMRL+NHQyOy9+rEkZtn/nzdfhoTitVzLYrCSUlHs4+6kyl14cprwgo+vw/yJy1iIrpI/YZv++M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=c7RwiNFj; arc=none smtp.client-ip=80.12.242.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="c7RwiNFj"
Received: from fedora.home ([86.243.222.230])
	by smtp.orange.fr with ESMTPA
	id IDz0sVzold4AbIDz0shQqo; Fri, 14 Jun 2024 22:57:21 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1718398641;
	bh=0gqOmh8tdr4J+MkHrhErZNEY+dxRqhfQP+7M6D3WdV0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=c7RwiNFjjLHdqSblMkJBWPJfoTE6MCtHwN7i+OaI4OZa6UlluTrA+5uRTcpd34uS3
	 U4mdmvU/04dh4Sn6aHNgHbaQn0B28XF/pi9hZIl3S8DVwxQmyDL9Sp+0s6wMtk6aVU
	 xubrZyUSzfvHM4O1wZH6PVY6wVR3b0oF4JzdRyzqTDuKM0abKgxuWvOdv+sXg7nGr9
	 Xvp5WeG5DoI6b+iONI4HyFCrOOF990Af8cednrtrIuAGXDa4La5mO0h5nEqlkd/VIb
	 iI0wTGpOszyubW8KXjjCC7YdpZelgqMIttaAnsJnQUuG2+1KZT1SkdK/v4anT5Kwiz
	 mb3ZTiGR/9xhg==
X-ME-Helo: fedora.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 14 Jun 2024 22:57:21 +0200
X-ME-IP: 86.243.222.230
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	ocfs2-devel@lists.linux.dev
Subject: [PATCH] ocfs2: Constify struct ocfs2_stack_operations
Date: Fri, 14 Jun 2024 22:57:09 +0200
Message-ID: <f52dab89ee0049ec6271de29183a781efbb275ab.1718398605.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

"struct ocfs2_stack_operations" are not modified in this driver.

Constifying this structure moves some data to a read-only section, so
increase overall security.

In order to do it, "struct ocfs2_stack_plugin" also needs to be adjusted to
this new const qualifier.

On a x86_64, with allmodconfig:
Before:
======
   text	   data	    bss	    dec	    hex	filename
   6241	    644	      0	   6885	   1ae5	fs/ocfs2/stack_o2cb.o

After:
=====
   text	   data	    bss	    dec	    hex	filename
   6337	    548	      0	   6885	   1ae5	fs/ocfs2/stack_o2cb.o

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 fs/ocfs2/stack_o2cb.c | 2 +-
 fs/ocfs2/stack_user.c | 2 +-
 fs/ocfs2/stackglue.h  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/stack_o2cb.c b/fs/ocfs2/stack_o2cb.c
index c973c03f6fd8..10157d9d7a9c 100644
--- a/fs/ocfs2/stack_o2cb.c
+++ b/fs/ocfs2/stack_o2cb.c
@@ -404,7 +404,7 @@ static int o2cb_cluster_this_node(struct ocfs2_cluster_connection *conn,
 	return 0;
 }
 
-static struct ocfs2_stack_operations o2cb_stack_ops = {
+static const struct ocfs2_stack_operations o2cb_stack_ops = {
 	.connect	= o2cb_cluster_connect,
 	.disconnect	= o2cb_cluster_disconnect,
 	.this_node	= o2cb_cluster_this_node,
diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index c11406cd87a8..77edcd70f72c 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -1065,7 +1065,7 @@ static int user_cluster_this_node(struct ocfs2_cluster_connection *conn,
 	return 0;
 }
 
-static struct ocfs2_stack_operations ocfs2_user_plugin_ops = {
+static const struct ocfs2_stack_operations ocfs2_user_plugin_ops = {
 	.connect	= user_cluster_connect,
 	.disconnect	= user_cluster_disconnect,
 	.this_node	= user_cluster_this_node,
diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
index 3636847fae19..02ab072c528a 100644
--- a/fs/ocfs2/stackglue.h
+++ b/fs/ocfs2/stackglue.h
@@ -223,7 +223,7 @@ struct ocfs2_stack_operations {
  */
 struct ocfs2_stack_plugin {
 	char *sp_name;
-	struct ocfs2_stack_operations *sp_ops;
+	const struct ocfs2_stack_operations *sp_ops;
 	struct module *sp_owner;
 
 	/* These are managed by the stackglue code. */
-- 
2.45.2

