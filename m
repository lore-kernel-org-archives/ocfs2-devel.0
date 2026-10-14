Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB2F4F4D0C
	for <ocfs2-devel@lists.linux.dev>; Wed, 14 Oct 2026 11:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791977007; cv=none; b=ZB/veMuy7Gz1HvKsyGPEk8zoq0P9kKs7c0qUq6+UYyDzyHuZnwAVdZV7PHWJxxKKpwf7dT0S7v/A0By1IB7NEoVDUe63JAzZMgdimMF9ubxCXYdDqV2SUzsV2VvQoctRu3uQDFmTmhdarRZ9N2PZRwQiNO0lfdiPsDvNe6mFiBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791977007; c=relaxed/simple;
	bh=gvZblxMbNnPBwlfPk4lfkDR4K+EEAEYN0ydugwx77/s=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oUaUUTqEXhp3r8mCCFXS8GzozxGv+mboRfp2NZTsDH6QbyUlr2dF/uC9sFas+XiVdfzjOYY5fiP5UqcwIEfIifTBB9UcUA5OB/Ze/MsBXWUwHVEIZjysSCQ97tag31uMGMBRvet3ggg4GW0rOhonUbk9309dqS6ldGKh9HC1yZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=SkHe+nrx; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="SkHe+nrx"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791977002; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=caGDUFxt5LVNaqNJ4efKRsvklAhDC/F8AjH3Q+78AlA=;
	b=SkHe+nrxrBZW5758aA9sh8rA63Kj/jyPMmRcrN7sJT6cO5vkMj8hhK/ZfJIUdQb0246mtQLwk+g98Eg4tPyw3zpxnlHMbUdyzhCxbopaywzMA84K30GbVejIcTbzVkXnxT0u4aEZSsNZD1Okd8kI+Go4KPDJU3lsugfkJvEEbF4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XCoySAW_1791977001;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XCoySAW_1791977001 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 14 Oct 2026 19:23:21 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ocfs2/dlm: hold the lookup reference across convert AST enqueue
Date: Wed, 14 Oct 2026 19:23:21 +0800
Message-Id: <20261014112321.2955584-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dlm_convert_lock_handler() drops the reference it took when it found the
lock on res->granted at its leave label, one statement before it calls
dlm_queue_ast().  dlm_free_dead_locks() takes res->spinlock and drops the
list and base references, so a peer death landing in that gap leaves the
handler's own put as the one that frees the lock, and __dlm_queue_ast()
then reads lock->lockres from freed memory.

The handler is registered next to dlm_create_lock_handler(), so a convert
message buffered on a dying peer's socket arrives on the same o2net
receive work that o2net_disconnect_node() does not wait for.  The two can
interleave as follows, with the reference counts as they are before this
fix:

  Socket data-ready       Node-down thread      Receive worker
  -----------------       ----------------      --------------
  o2net_data_ready()
    select sc under
    callback read lock
                          o2net_disconnect_node()
                            queue shutdown
                            begin flush; new color
    queue sc_rx_work
    in the new color
    release callback lock
                            shutdown socket
                            flush returns
                                                read buffered convert_lock
                                                dlm_convert_lock_handler()
                                                  find lock on res->granted
                                                  dlm_lock_get()  refs = 3
                                                  lock res->spinlock
                                                  __dlmconvert_master()
                                                    call_ast = 1
                                                  unlock res->spinlock
                          DLM node-down cleanup
                            lock res->spinlock
                            dlm_free_dead_locks()
                              unlink lock
                              put list ref  refs = 2
                              put base ref  refs = 1
                            unlock res->spinlock
                                                dlm_lock_put()  refs = 0
                                                  free lock
                                                dlm_queue_ast()
                                                  __dlm_queue_ast()
                                                  read lock->lockres
                                                  (use-after-free)

__dlmconvert_master() only moves the lock between lists, so the count
entering the gap is base, list and lookup.  Drop the lookup reference
after the AST is queued instead of before it and the race ends with the
one __dlm_queue_ast() took, which dlm_flush_asts() releases later with
ast_pending cleared and ast_list unlinked.  No extra get is needed, and
the normal case ends with the same count as before.

dlmconvert_master() has the same shape but is only reached from dlmlock()
for a lock this node owns, which dlm_free_dead_locks() never matches.

Fixes: 2c5c54aca9d0 ("ocfs2/dlm: Add missing dlm_lock_put()s")
Cc: <stable@vger.kernel.org>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/dlm/dlmconvert.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmconvert.c b/fs/ocfs2/dlm/dlmconvert.c
index 450d46eefab32..8a828448ba958 100644
--- a/fs/ocfs2/dlm/dlmconvert.c
+++ b/fs/ocfs2/dlm/dlmconvert.c
@@ -534,15 +534,19 @@ int dlm_convert_lock_handler(struct o2net_msg *msg, u32 len, void *data,
 	}
 
 leave:
-	if (lock)
-		dlm_lock_put(lock);
-
 	/* either queue the ast or release it, if reserved */
 	if (call_ast)
 		dlm_queue_ast(dlm, lock);
 	else if (ast_reserved)
 		dlm_lockres_release_ast(dlm, res);
 
+	/*
+	 * Keep the lock alive through AST enqueue: a concurrent
+	 * dlm_free_dead_locks() drops the list and base references.
+	 */
+	if (lock)
+		dlm_lock_put(lock);
+
 	if (kick_thread)
 		dlm_kick_thread(dlm, res);
 
-- 
2.39.3

