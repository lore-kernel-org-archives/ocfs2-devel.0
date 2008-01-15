From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue Jan 15 10:43:01 2008
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: Fix backport patch commit
	bb43f1e0ae88a80c40499a0b27d1fc0090e40892
In-Reply-To: <1200422553-21064-1-git-send-email-sunil.mushran@oracle.com>
References: <1200422553-21064-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1200422553-21064-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The workqueue backport patch was missing a one-liner.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmrecovery.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 3cf4f49..d6a46c7 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -156,7 +156,7 @@ static inline void dlm_reset_recovery(struct dlm_ctxt *dlm)
 void dlm_dispatch_work(kapi_work_struct_t *work)
 {
 	struct dlm_ctxt *dlm =
-		container_of(work, struct dlm_ctxt, dispatched_work);
+		work_to_object(work, struct dlm_ctxt, dispatched_work);
 	LIST_HEAD(tmp_list);
 	struct dlm_work_item *item, *next;
 	dlm_workfunc_t *workfunc;
-- 
1.5.2.5
