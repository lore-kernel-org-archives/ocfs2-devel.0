From: Joseph Qi <joseph.qi@huawei.com>
Date: Fri, 21 Aug 2015 08:56:19 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: remove unneeded code in
	dlm_register_domain_handlers
Message-ID: <55D67733.7060207@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The last goto statement is unneeded, so remove it.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/dlm/dlmdomain.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 4f75070..019459b 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -1846,8 +1846,6 @@ static int dlm_register_domain_handlers(struct dlm_ctxt *dlm)
 					sizeof(struct dlm_exit_domain),
 					dlm_begin_exit_domain_handler,
 					dlm, NULL, &dlm->dlm_domain_handlers);
-	if (status)
-		goto bail;

 bail:
 	if (status)
-- 
1.8.4.3
