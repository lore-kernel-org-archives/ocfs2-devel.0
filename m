From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 26 Aug 2010 21:07:45 +0800
Subject: [Ocfs2-devel] [PATCH 4/5] ocfs2/dlm: copy lvb from lksb only when
	it's meaningful
Message-ID: <201008261310.o7PHoc65015692@acsinet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Copies lvb from lksb only when it's meaningful(not NULL).

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/dlm/dlmrecovery.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index fa6e5ae..6d2e3ca 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1184,7 +1184,8 @@ static void dlm_prepare_lvb_for_migration(struct dlm_lock *lock,
 		return;
 
 	if (dlm_lvb_is_empty(mres->lvb)) {
-		memcpy(mres->lvb, lock->lksb->lvb, DLM_LVB_LEN);
+		if (lock->lksb->lvb)
+			memcpy(mres->lvb, lock->lksb->lvb, DLM_LVB_LEN);
 		return;
 	}
 
-- 
1.7.2.1
