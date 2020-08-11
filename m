From: Randy Dunlap <rdunlap@infradead.org>
Date: Mon, 10 Aug 2020 19:18:45 -0700
Subject: [Ocfs2-devel] [PATCH] fs: ocfs2: delete repeated words in comments
Message-ID: <20200811021845.25134-1-rdunlap@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@oss.oracle.com

Drop duplicated words {the, and} in comments.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: ocfs2-devel at oss.oracle.com
---
 fs/ocfs2/alloc.c      |    2 +-
 fs/ocfs2/localalloc.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20200807.orig/fs/ocfs2/alloc.c
+++ linux-next-20200807/fs/ocfs2/alloc.c
@@ -6013,7 +6013,7 @@ int __ocfs2_flush_truncate_log(struct oc
 		goto out;
 	}
 
-	/* Appending truncate log(TA) and and flushing truncate log(TF) are
+	/* Appending truncate log(TA) and flushing truncate log(TF) are
 	 * two separated transactions. They can be both committed but not
 	 * checkpointed. If crash occurs then, both two transaction will be
 	 * replayed with several already released to global bitmap clusters.
--- linux-next-20200807.orig/fs/ocfs2/localalloc.c
+++ linux-next-20200807/fs/ocfs2/localalloc.c
@@ -677,7 +677,7 @@ int ocfs2_reserve_local_alloc_bits(struc
 		/*
 		 * Under certain conditions, the window slide code
 		 * might have reduced the number of bits available or
-		 * disabled the the local alloc entirely. Re-check
+		 * disabled the local alloc entirely. Re-check
 		 * here and return -ENOSPC if necessary.
 		 */
 		status = -ENOSPC;
