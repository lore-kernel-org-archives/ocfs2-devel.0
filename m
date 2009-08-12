From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 12 Aug 2009 14:42:47 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: release the buffer head in
	ocfs2_do_truncate.
Message-ID: <1250059367-14040-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_do_truncate, we forget to release last_eb_bh which
will cause memleak. So call brelse in the end.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index f9a3e89..ab513dd 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6851,7 +6851,7 @@ static int ocfs2_do_truncate(struct ocfs2_super *osb,
 	}
 	status = 0;
 bail:
-
+	brelse(last_eb_bh);
 	mlog_exit(status);
 	return status;
 }
-- 
1.5.5
