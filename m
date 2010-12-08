From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Wed,  8 Dec 2010 20:34:39 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: make existing convertion precedent
	over new lock
Message-ID: <201012081237.oB7Ibeoo012391@acsinet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Make existing convertion precedent over new lock. It makes o2dlm locking more
like fair locking.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/dlm/dlmlock.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmlock.c b/fs/ocfs2/dlm/dlmlock.c
index 69cf369..7009292 100644
--- a/fs/ocfs2/dlm/dlmlock.c
+++ b/fs/ocfs2/dlm/dlmlock.c
@@ -106,6 +106,9 @@ static int dlm_can_grant_new_lock(struct dlm_lock_resource *res,
 
 		if (!dlm_lock_compatible(tmplock->ml.type, lock->ml.type))
 			return 0;
+		if (!dlm_lock_compatible(tmplock->ml.convert_type,
+					 lock->ml.type))
+			return 0;
 	}
 
 	return 1;
-- 
1.7.2.3
