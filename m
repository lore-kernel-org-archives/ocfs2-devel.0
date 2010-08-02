From: Tao Ma <tao.ma@oracle.com>
Date: Mon,  2 Aug 2010 11:02:13 +0800
Subject: [Ocfs2-devel] [PATCH 2/4] ocfs2: Remove unused old_id in
	ocfs2_commit_cache.
In-Reply-To: <4C56350A.7090309@oracle.com>
References: <4C56350A.7090309@oracle.com>
Message-ID: <1280718135-11036-2-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/journal.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 47878cf..2a9eac8 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -301,7 +301,6 @@ static int ocfs2_commit_cache(struct ocfs2_super *osb)
 {
 	int status = 0;
 	unsigned int flushed;
-	unsigned long old_id;
 	struct ocfs2_journal *journal = NULL;
 
 	mlog_entry_void();
@@ -326,7 +325,7 @@ static int ocfs2_commit_cache(struct ocfs2_super *osb)
 		goto finally;
 	}
 
-	old_id = ocfs2_inc_trans_id(journal);
+	ocfs2_inc_trans_id(journal);
 
 	flushed = atomic_read(&journal->j_num_trans);
 	atomic_set(&journal->j_num_trans, 0);
-- 
1.7.1.571.gba4d01
