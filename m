Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21CC379EEF
	for <ocfs2-devel@lists.linux.dev>; Fri,  8 May 2026 06:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778220094; cv=none; b=YRlarcD+VzkIG1Z5Y5J/P5qp/DjMfSQbZROqdhW4G3oC2244o3YASbK4nk1XkPrPVmp6ORfO5PnUWqUxCefBiHP1R0zxzZ/PVS22An1+XxQXyZlx59POuKIfS/ty0t/HTg562t90Tm6RTDIT8n75WiRI+uN/86vn/adgPhpw04Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778220094; c=relaxed/simple;
	bh=AcVLNMoijIP9j19UaTOpxp6gaTeB3Aa7wgpZrNrRI0k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uCKNdynvaC691KZcBZokMUtO8wIhgYEM8Z6Sq0Jf6FGZ+jA3iROS8lYg+ExAKLBxGmseC5+1UozmlT/FeYT+cDOFBJyDqav3iQKab+b8aIPWoYERmKuHsyy/zjHCdRWrP36pQqWh+aOq6MnId/pwnsAjUf/Gr5qAmQwKN1d3Qww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mails.ucas.ac.cn; spf=pass smtp.mailfrom=mails.ucas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mails.ucas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mails.ucas.ac.cn
Received: from fric.. (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowAC3XmokfP1pyl2WDw--.20964S2;
	Fri, 08 May 2026 14:01:08 +0800 (CST)
From: Jiakai Xu <xujiakai24@mails.ucas.ac.cn>
To: linux-kernel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev
Cc: Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Kurt Hackel <kurt.hackel@oracle.com>,
	Mark Fasheh <mark@fasheh.com>,
	Jiakai Xu <xujiakai24@mails.ucas.ac.cn>
Subject: [PATCH] ocfs2: fix use-after-free in ocfs2_inode_lock_full_nested during unmount
Date: Fri,  8 May 2026 06:01:07 +0000
Message-Id: <20260508060107.2666033-1-xujiakai24@mails.ucas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowAC3XmokfP1pyl2WDw--.20964S2
X-Coremail-Antispam: 1UD129KBjvJXoW7AFyDGw4ftr1UtF1UAw1rtFb_yoW8uF17pa
	yrCw1fKws7Ja48Cw1kta93Xryfuayqka17Gr1rZ34UXF4Dtw1qqryjyr1j9F45X3y5Jw1a
	qFy5Kw17Ww1xArDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr0_Cr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IE
	rcIFxwCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUjAwIDUUUUU==
X-CM-SenderInfo: 50xmxthndljko6pdxz3voxutnvoduhdfq/

A race condition exists between filesystem unmount and inode permission
operations. When ocfs2_dismount_volume() frees the ocfs2_super (osb)
structure, concurrent access via OCFS2_SB(inode->i_sb) in
ocfs2_inode_lock_full_nested() can dereference freed memory, causing a
page fault in __pv_queued_spin_lock_slowpath via
ocfs2_is_hard_readonly() -> spin_lock(&osb->osb_lock).

Fix this with two changes:

1. In ocfs2_dismount_volume(): set sb->s_fs_info = NULL before
   kfree(osb), so OCFS2_SB() returns NULL instead of a dangling pointer
   during the teardown race window.

2. In ocfs2_inode_lock_full_nested(): add a NULL check on osb after
   OCFS2_SB(), returning -EIO if the superblock info is already gone.
   This ensures the crash path is handled gracefully when the
   filesystem is being torn down.

Signed-off-by: Jiakai Xu <xujiakai24@mails.ucas.ac.cn>
Fixes: ccd979bdbce9f ("OCFS2: The Second Oracle Cluster Filesystem")
---
 fs/ocfs2/dlmglue.c | 3 +++
 fs/ocfs2/super.c   | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 7283bb2c5a31..cd619958a0a2 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2435,6 +2435,9 @@ int ocfs2_inode_lock_full_nested(struct inode *inode,
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct buffer_head *local_bh = NULL;
 
+	if (!osb)
+		return -EIO;
+
 	mlog(0, "inode %llu, take %s META lock\n",
 	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
 	     ex ? "EXMODE" : "PRMODE");
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index b875f01c9756..3fd56638e4f0 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1881,10 +1881,10 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 	printk(KERN_INFO "ocfs2: Unmounting device (%s) on (node %s)\n",
 	       osb->dev_str, nodestr);
 
+	sb->s_fs_info = NULL;
 	ocfs2_delete_osb(osb);
 	kfree(osb);
 	sb->s_dev = 0;
-	sb->s_fs_info = NULL;
 }
 
 static int ocfs2_setup_osb_uuid(struct ocfs2_super *osb, const unsigned char *uuid,
-- 
2.34.1

