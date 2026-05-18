Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2133803C2
	for <ocfs2-devel@lists.linux.dev>; Mon, 18 May 2026 04:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779078253; cv=none; b=P5gJvoFjCYKW4XjUxjvTjUa3I/Vh61nAWgKE5UxZgTZ32YF6xtjNkn7e9FQc5uNkESb7XVXdiodMAJLH4InDa/hE5tyhdULkRZNx5yzeSm5ljvaDB2+f+wXLOfi33XUjdPW2NpDZD3A7PTfptVfVoY/6FDYwVAeopc90rxELaj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779078253; c=relaxed/simple;
	bh=JbP0fZ1bzSFQ8oBfVi4g+zDLy3xq4MS6rSvndZRYVck=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Geg83Cm2Rnl2+v1X2t0zEQ+GRR3+3sJc/W/knVvCgeUuLkiPgF83AZe1tiNovTQPXYe6zDyT0od7yh9CMgdkO6neEyZuqnfrCwmz+ttTkQ9UKWRa/ajKGlkKfAXNxM1mDA1wlwyhPzXiOepvAz4yv8WG8Id6YRkyW7ZBGG6IXzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 64I4NhJX081326;
	Mon, 18 May 2026 13:23:43 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.5] (M106072072000.v4.enabler.ne.jp [106.72.72.0])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 64I4NhJp081322
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 18 May 2026 13:23:43 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <fea8d1fd-afb0-4302-a560-c202e2ef7afd@I-love.SAKURA.ne.jp>
Date: Mon, 18 May 2026 13:23:40 +0900
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH v2] ocfs2: kill osb->system_file_mutex lock
To: Heming Zhao <heming.zhao@suse.com>, Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: jiangyiwen <jiangyiwen@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@lists.linux.dev,
        LKML <linux-kernel@vger.kernel.org>
References: <934355dd-a0b1-4e53-93ac-0a7ae7458051@I-love.SAKURA.ne.jp>
 <831c4fc1-c89f-48bc-84c6-25b2cefc2b20@I-love.SAKURA.ne.jp>
 <agc8kA2wxC_7091p@c73> <ageuwl9o3nzktMrz@c73>
 <fb0685c4-bcee-4c7b-8ac4-a1af702b8600@I-love.SAKURA.ne.jp>
 <aghfx-XhwoE4fBYR@c73>
 <670882aa-b637-4565-adf0-ddcd9d7a588b@I-love.SAKURA.ne.jp>
 <agp0sACmJl3tePyr@c73>
Content-Language: en-US
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <agp0sACmJl3tePyr@c73>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Anti-Virus-Server: fsav404.rs.sakura.ne.jp
X-Virus-Status: clean

Commit 43b10a20372d ("ocfs2: avoid system inode ref confusion by adding
mutex lock") tried to avoid a refcount leak caused by allowing multiple
threads to call igrab(inode). But addition of osb->system_file_mutex made
locking dependency complicated and is causing lockdep to warn about
possibility of AB-BA deadlock.

Since _ocfs2_get_system_file_inode() returns the same inode for the same
input arguments, we don't need to serialize _ocfs2_get_system_file_inode().
What we need to make sure is that igrab(inode) is called for only once().
Therefore, replace osb->system_file_mutex with cmpxchg()-based locking.

Fixes: 43b10a20372d ("ocfs2: avoid system inode ref confusion by adding mutex lock")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
Changes in v2:
  Updated patch description.

 fs/ocfs2/ocfs2.h   | 2 --
 fs/ocfs2/super.c   | 2 --
 fs/ocfs2/sysfile.c | 9 +++------
 3 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 7b50e03dfa66..62cad6522c7a 100644
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
index b875f01c9756..6dd45c2153f8 100644
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
index d53a6cc866be..67e492f4b828 100644
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
2.54.0


