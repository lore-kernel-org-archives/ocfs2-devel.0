From: Tao Ma <tao.ma@oracle.com>
Date: Mon,  2 Aug 2010 11:02:14 +0800
Subject: [Ocfs2-devel] [PATCH 3/4] ocfs2: Remove obsolete comments before
	ocfs2_start_trans.
In-Reply-To: <4C56350A.7090309@oracle.com>
References: <4C56350A.7090309@oracle.com>
Message-ID: <1280718135-11036-3-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/journal.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 2a9eac8..ac2ea71 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -341,9 +341,6 @@ finally:
 	return status;
 }
 
-/* pass it NULL and it will allocate a new handle object for you.  If
- * you pass it a handle however, it may still return error, in which
- * case it has free'd the passed handle for you. */
 handle_t *ocfs2_start_trans(struct ocfs2_super *osb, int max_buffs)
 {
 	journal_t *journal = osb->journal->j_journal;
-- 
1.7.1.571.gba4d01
