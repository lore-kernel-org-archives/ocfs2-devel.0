From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 17 Nov 2011 16:33:00 -0800
Subject: [Ocfs2-devel] [PATCH 4/6] ocfs2/dlm: Use track_lock when
	manipulating tracking_list
In-Reply-To: <1321576382-18521-1-git-send-email-sunil.mushran@oracle.com>
References: <1321576382-18521-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1321576382-18521-4-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Commit b0d4f817ba5de8adb875ace594554a96d7737710 introduced dlm->track_lock
to protect operations on dlm->tracking_list. But it was still using the
older lock (dlm->spin_lock) to add new resources to the list.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmmaster.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 005261c..347d588 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -597,9 +597,9 @@ static void dlm_init_lockres(struct dlm_ctxt *dlm,
 
 	res->last_used = 0;
 
-	spin_lock(&dlm->spinlock);
+	spin_lock(&dlm->track_lock);
 	list_add_tail(&res->tracking, &dlm->tracking_list);
-	spin_unlock(&dlm->spinlock);
+	spin_unlock(&dlm->track_lock);
 
 	memset(res->lvb, 0, DLM_LVB_LEN);
 	memset(res->refmap, 0, sizeof(res->refmap));
-- 
1.7.5.4
