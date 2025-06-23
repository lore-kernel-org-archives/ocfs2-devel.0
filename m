Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD6E17A319;
	Mon, 23 Jun 2025 14:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750690502; cv=none; b=RDRBA4iRxaVWFWn1qhdmrfFpwSHbm8+u4wcEouElz980UdpTB1x/RNU8CnkI2RUU0ST3aaSMy6xru4o9+ERqqKpDuZmlvXvTIZUptaU/f4c7lqKNVXnhIYpn/9U1/4++dYaZkPIawUxkt5KJlw6xhoOSDuT5cK8lhmJkdsHO8zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750690502; c=relaxed/simple;
	bh=neJ53zTqVIf2HXeu7VaFVXtQeMPgtZV6OqaLCTC6XUY=;
	h=Message-ID:Date:MIME-Version:From:To:Subject:Content-Type; b=sedRFv+fccbdD2h+DmmrykXeS2T+sRlqsdBGM2agUYvFO4BS33MMAopxYr/58C0e3rU5WFOw0ipayn1Pk8J2TKesEzipwQiKkFL53EWc5Iki95pdFz1twhzUwDBLc59Hk1u+zp+gkP79kedIJQS/x+CdNQ7b7qoFQdvBM1HrDPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 55NEsKbf098991;
	Mon, 23 Jun 2025 23:54:20 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.6] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 55NEsKIL098986
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 23 Jun 2025 23:54:20 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <29348724-639c-443d-bbce-65c3a0a13a38@I-love.SAKURA.ne.jp>
Date: Mon, 23 Jun 2025 23:54:20 +0900
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@lists.linux.dev,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ocfs2: embed actual values into ocfs2_sysfile_lock_key names
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Virus-Status: clean
X-Anti-Virus-Server: fsav304.rs.sakura.ne.jp

Since lockdep_set_class() uses stringified key name via macro, calling
lockdep_set_class() with an array causes lockdep warning messages to
report variable name than actual index number.

Change ocfs2_init_locked_inode() to pass actual index number for better
readability of lockdep reports. This patch does not change behavior.


Before:

  Chain exists of:
    &ocfs2_sysfile_lock_key[args->fi_sysfile_type] --> jbd2_handle --> &oi->ip_xattr_sem

   Possible unsafe locking scenario:

         CPU0                    CPU1
         ----                    ----
    lock(&oi->ip_xattr_sem);
                                 lock(jbd2_handle);
                                 lock(&oi->ip_xattr_sem);
    lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]);

   *** DEADLOCK ***

After:

  Chain exists of:
    &ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE] --> jbd2_handle --> &oi->ip_xattr_sem

   Possible unsafe locking scenario:

         CPU0                    CPU1
         ----                    ----
    lock(&oi->ip_xattr_sem);
                                 lock(jbd2_handle);
                                 lock(&oi->ip_xattr_sem);
    lock(&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]);

   *** DEADLOCK ***


Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/ocfs2/inode.c | 70 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 66 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 12e5d1f73325..14bf440ea4df 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -50,8 +50,6 @@ struct ocfs2_find_inode_args
 	unsigned int	fi_sysfile_type;
 };
 
-static struct lock_class_key ocfs2_sysfile_lock_key[NUM_SYSTEM_INODES];
-
 static int ocfs2_read_locked_inode(struct inode *inode,
 				   struct ocfs2_find_inode_args *args);
 static int ocfs2_init_locked_inode(struct inode *inode, void *opaque);
@@ -250,14 +248,77 @@ static int ocfs2_find_actor(struct inode *inode, void *opaque)
 static int ocfs2_init_locked_inode(struct inode *inode, void *opaque)
 {
 	struct ocfs2_find_inode_args *args = opaque;
+#ifdef CONFIG_LOCKDEP
+	static struct lock_class_key ocfs2_sysfile_lock_key[NUM_SYSTEM_INODES];
 	static struct lock_class_key ocfs2_quota_ip_alloc_sem_key,
 				     ocfs2_file_ip_alloc_sem_key;
+#endif
 
 	inode->i_ino = args->fi_ino;
 	OCFS2_I(inode)->ip_blkno = args->fi_blkno;
-	if (args->fi_sysfile_type != 0)
+#ifdef CONFIG_LOCKDEP
+	switch (args->fi_sysfile_type) {
+	case BAD_BLOCK_SYSTEM_INODE:
+		break;
+	case GLOBAL_INODE_ALLOC_SYSTEM_INODE:
+		lockdep_set_class(&inode->i_rwsem,
+				  &ocfs2_sysfile_lock_key[GLOBAL_INODE_ALLOC_SYSTEM_INODE]);
+		break;
+	case SLOT_MAP_SYSTEM_INODE:
+		lockdep_set_class(&inode->i_rwsem,
+				  &ocfs2_sysfile_lock_key[SLOT_MAP_SYSTEM_INODE]);
+		break;
+	case HEARTBEAT_SYSTEM_INODE:
+		lockdep_set_class(&inode->i_rwsem,
+				  &ocfs2_sysfile_lock_key[HEARTBEAT_SYSTEM_INODE]);
+		break;
+	case GLOBAL_BITMAP_SYSTEM_INODE:
+		lockdep_set_class(&inode->i_rwsem,
+				  &ocfs2_sysfile_lock_key[GLOBAL_BITMAP_SYSTEM_INODE]);
+		break;
+	case USER_QUOTA_SYSTEM_INODE:
+		lockdep_set_class(&inode->i_rwsem,
+				  &ocfs2_sysfile_lock_key[USER_QUOTA_SYSTEM_INODE]);
+		break;
+	case GROUP_QUOTA_SYSTEM_INODE:
+		lockdep_set_class(&inode->i_rwsem,
+				  &ocfs2_sysfile_lock_key[GROUP_QUOTA_SYSTEM_INODE]);
+		break;
+	case ORPHAN_DIR_SYSTEM_INODE:
+		lockdep_set_class(&inode->i_rwsem,
+				  &ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
+		break;
+	case EXTENT_ALLOC_SYSTEM_INODE:
 		lockdep_set_class(&inode->i_rwsem,
-			&ocfs2_sysfile_lock_key[args->fi_sysfile_type]);
+				  &ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]);
+		break;
+	case INODE_ALLOC_SYSTEM_INODE:
+		lockdep_set_class(&inode->i_rwsem,
+				  &ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]);
+		break;
+	case JOURNAL_SYSTEM_INODE:
+		lockdep_set_class(&inode->i_rwsem,
+				  &ocfs2_sysfile_lock_key[JOURNAL_SYSTEM_INODE]);
+		break;
+	case LOCAL_ALLOC_SYSTEM_INODE:
+		lockdep_set_class(&inode->i_rwsem,
+				  &ocfs2_sysfile_lock_key[LOCAL_ALLOC_SYSTEM_INODE]);
+		break;
+	case TRUNCATE_LOG_SYSTEM_INODE:
+		lockdep_set_class(&inode->i_rwsem,
+				  &ocfs2_sysfile_lock_key[TRUNCATE_LOG_SYSTEM_INODE]);
+		break;
+	case LOCAL_USER_QUOTA_SYSTEM_INODE:
+		lockdep_set_class(&inode->i_rwsem,
+				  &ocfs2_sysfile_lock_key[LOCAL_USER_QUOTA_SYSTEM_INODE]);
+		break;
+	case LOCAL_GROUP_QUOTA_SYSTEM_INODE:
+		lockdep_set_class(&inode->i_rwsem,
+				  &ocfs2_sysfile_lock_key[LOCAL_GROUP_QUOTA_SYSTEM_INODE]);
+		break;
+	default:
+		WARN_ONCE(1, "Unknown sysfile type %d\n", args->fi_sysfile_type);
+	}
 	if (args->fi_sysfile_type == USER_QUOTA_SYSTEM_INODE ||
 	    args->fi_sysfile_type == GROUP_QUOTA_SYSTEM_INODE ||
 	    args->fi_sysfile_type == LOCAL_USER_QUOTA_SYSTEM_INODE ||
@@ -267,6 +328,7 @@ static int ocfs2_init_locked_inode(struct inode *inode, void *opaque)
 	else
 		lockdep_set_class(&OCFS2_I(inode)->ip_alloc_sem,
 				  &ocfs2_file_ip_alloc_sem_key);
+#endif
 
 	return 0;
 }
-- 
2.49.0


