From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 21 Dec 2009 14:11:36 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/trivial: Add default mask log for
	heartbeat.c
Message-ID: <1261375896-11322-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I just noticed today that we have no default mask
prefix for fs/ocfs2/cluster/heartbeat.c, but we have
2 places that use "mlog(0,...)". So add the default
prefix so that these "mlog(0, ...)" can work.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index c452d11..edec9bf 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -40,6 +40,7 @@
 #include "nodemanager.h"
 #include "quorum.h"
 
+#define MLOG_MASK_PREFIX ML_HEARTBEAT
 #include "masklog.h"
 
 
-- 
1.5.5
