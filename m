Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12EDF2A1CF;
	Sat, 21 Jun 2025 15:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750521450; cv=none; b=Mw09+rAFP4vtv2d4UN+0+iep3m9VpJEXqIDpSomV1L4Qm6vObxz6Ej3Amw0uMJNCJ6MRk9CQbtPgX7WtGuz4l/Km8D5PvQ1SIHZ8H9Z9Eka3KgphXB4UIhAVwgcwFQX1MQKg/QYrIaRCG13KKmTaM/BujkCoDaMJnCCHcoAM+tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750521450; c=relaxed/simple;
	bh=SL5U0+4+41/M+3PBMe6KblhotSdL5x5yMpDncdqrOso=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=N1CdzuyuyLgW1CErJZtwRFy1tUaLa/TdaahWGkVRq4jlF0rAewvUi0awlb5W0jS1rAPaDon28gTweKMLdpWOvwldKGRmNVr+sKAKx+OIDhn6xa0tA6erkQVDrtJfhvL9BdyBfMnE9exP8blxKWCh4HPLi4+Nv14+10JYJ5zCDBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 55LFuntn031917;
	Sun, 22 Jun 2025 00:56:49 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.6] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 55LFunIu031910
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Sun, 22 Jun 2025 00:56:49 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <934355dd-a0b1-4e53-93ac-0a7ae7458051@I-love.SAKURA.ne.jp>
Date: Sun, 22 Jun 2025 00:56:46 +0900
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        jiangyiwen <jiangyiwen@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@lists.linux.dev
Cc: LKML <linux-kernel@vger.kernel.org>
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH] ocfs2: kill osb->system_file_mutex lock
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Virus-Status: clean
X-Anti-Virus-Server: fsav203.rs.sakura.ne.jp

Since calling _ocfs2_get_system_file_inode() twice with the same
arguments returns the same address, there is no need to serialize
_ocfs2_get_system_file_inode() using osb->system_file_mutex lock.

Kill osb->system_file_mutex lock in order to avoid AB-BA deadlock.
cmpxchg() will be sufficient for avoiding the inode refcount leak
problem which commit 43b10a20372d ("ocfs2: avoid system inode ref
confusion by adding mutex lock") tried to address.

Reported-by: Diogo Jahchan Koike <djahchankoike@gmail.com>
Closes: https://lkml.kernel.org/r/000000000000ff2d7a0620381afe@google.com
Fixes: 43b10a20372d ("ocfs2: avoid system inode ref confusion by adding mutex lock")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: jiangyiwen <jiangyiwen@huawei.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/ocfs2.h   | 2 --
 fs/ocfs2/super.c   | 2 --
 fs/ocfs2/sysfile.c | 9 +++------
 3 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 6aaa94c554c1..8bdeea60742a 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -494,8 +494,6 @@ struct ocfs2_super
 	struct rb_root	osb_rf_lock_tree;
 	struct ocfs2_refcount_tree *osb_ref_tree_lru;
 
-	struct mutex system_file_mutex;
-
 	/*
 	 * OCFS2 needs to schedule several different types of work which
 	 * require cluster locking, disk I/O, recovery waits, etc. Since these
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 3d2533950bae..4461daf909cf 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1997,8 +1997,6 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	spin_lock_init(&osb->osb_xattr_lock);
 	ocfs2_init_steal_slots(osb);
 
-	mutex_init(&osb->system_file_mutex);
-
 	atomic_set(&osb->alloc_stats.moves, 0);
 	atomic_set(&osb->alloc_stats.local_data, 0);
 	atomic_set(&osb->alloc_stats.bitmap_data, 0);
diff --git a/fs/ocfs2/sysfile.c b/fs/ocfs2/sysfile.c
index 53a945da873b..b63af8d64904 100644
--- a/fs/ocfs2/sysfile.c
+++ b/fs/ocfs2/sysfile.c
@@ -98,11 +98,9 @@ struct inode *ocfs2_get_system_file_inode(struct ocfs2_super *osb,
 	} else
 		arr = get_local_system_inode(osb, type, slot);
 
-	mutex_lock(&osb->system_file_mutex);
 	if (arr && ((inode = *arr) != NULL)) {
 		/* get a ref in addition to the array ref */
 		inode = igrab(inode);
-		mutex_unlock(&osb->system_file_mutex);
 		BUG_ON(!inode);
 
 		return inode;
@@ -112,11 +110,10 @@ struct inode *ocfs2_get_system_file_inode(struct ocfs2_super *osb,
 	inode = _ocfs2_get_system_file_inode(osb, type, slot);
 
 	/* add one more if putting into array for first time */
-	if (arr && inode) {
-		*arr = igrab(inode);
-		BUG_ON(!*arr);
+	if (inode && arr && !*arr && !cmpxchg(&(*arr), NULL, inode)) {
+		inode = igrab(inode);
+		BUG_ON(!inode);
 	}
-	mutex_unlock(&osb->system_file_mutex);
 	return inode;
 }
 
-- 
2.47.1

