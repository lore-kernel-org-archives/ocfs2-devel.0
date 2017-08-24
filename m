From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 25 Aug 2017 00:21:12 +0200
Subject: [Ocfs2-devel] [PATCH] ocfs2: remove two unused variables
Message-ID: <20170824222149.759050-1-arnd@arndb.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@versity.com>, Joel Becker <jlbec@evilplan.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Changwei Ge <ge.changwei@h3c.com>, Stephen Rothwell <sfr@canb.auug.org.au>, piaojun <piaojun@huawei.com>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

A reliability fix introduced two local variables but never used
them:

fs/ocfs2/dlm/dlmrecovery.c: In function 'dlm_free_dead_locks':
fs/ocfs2/dlm/dlmrecovery.c:2306:6: error: unused variable 'i' [-Werror=unused-variable]
fs/ocfs2/dlm/dlmrecovery.c:2305:20: error: unused variable 'queue' [-Werror=unused-variable]

This removes them both again.

Fixes: d09f2c6cf3b8 ("ocfs2: re-queue AST or BAST if sending is failed to improve the reliability")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/ocfs2/dlm/dlmrecovery.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 8285485aace3..11cedda5eaf9 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -2302,8 +2302,6 @@ static void dlm_free_dead_locks(struct dlm_ctxt *dlm,
 	struct dlm_lock *lock, *next;
 	unsigned int freed = 0;
 	int reserved_tmp = 0;
-	struct list_head *queue = NULL;
-	int i;
 
 	/* this node is the lockres master:
 	 * 1) remove any stale locks for the dead node
-- 
2.9.0
