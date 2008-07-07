From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon,  7 Jul 2008 10:06:29 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2/dlm: Fixes oops in dlm_new_lockres()
Message-ID: <1215450389-7297-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Patch fixes a race that can result in an oops while adding a
lockres to the dlm lockres tracking list.

Bug introduced by mainline commit 29576f8bb54045be944ba809d4fca1ad77c94165.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmmaster.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index efc015c..44f87ca 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -606,7 +606,9 @@ static void dlm_init_lockres(struct dlm_ctxt *dlm,
 
 	res->last_used = 0;
 
+	spin_lock(&dlm->spinlock);
 	list_add_tail(&res->tracking, &dlm->tracking_list);
+	spin_unlock(&dlm->spinlock);
 
 	memset(res->lvb, 0, DLM_LVB_LEN);
 	memset(res->refmap, 0, sizeof(res->refmap));
-- 
1.5.4.5
