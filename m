From: Jeff Liu <jeff.liu@oracle.com>
Date: Tue,  7 Jul 2009 15:51:40 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2-devel: trivial fix for
	s/migrate/migration/ in dlmrecovery.c, line 1121
In-Reply-To: <>
References: <>
Message-ID: <1246953100-8889-1-git-send-email-jeff.liu@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

in dlmrecovery.c:1121, replace 'migrate' to 'migration' to keep the consistency
by comparing to other lines with the similar log info in the same file.

Signed-off-by: Jeff Liu <jeff.liu@oracle.com>
---
 fs/ocfs2/dlm/dlmrecovery.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index bcb9260..43e6e32 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1118,7 +1118,7 @@ static int dlm_send_mig_lockres_msg(struct dlm_ctxt *dlm,
 
 	mlog(0, "%s:%.*s: sending mig lockres (%s) to %u\n",
 	     dlm->name, res->lockname.len, res->lockname.name,
-	     orig_flags & DLM_MRES_MIGRATION ? "migrate" : "recovery",
+	     orig_flags & DLM_MRES_MIGRATION ? "migration" : "recovery",
 	     send_to);
 
 	/* send it */
-- 
1.5.4.3
