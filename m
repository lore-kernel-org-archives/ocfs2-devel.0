From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 13 May 2015 10:52:52 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: fix BUG in
	ocfs2_downconvert_thread_do_work
Message-ID: <5552BC84.2050204@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

BUG_ON(list_empty(&osb->blocked_lock_list)) in
ocfs2_downconvert_thread_do_work can be triggered in the following case:

ocfs2dc has firstly saved osb->blocked_lock_count to local variable
'processed', and then processes the dentry lockres. During the dentry put,
it calls iput and then deletes rw, inode and open lockres from blocked
list in ocfs2_mark_lockres_freeing.  And this causes the variable
'processed' to not reflect the number of blocked lockres to be processed,
which triggers the BUG.

Changes since v1:
As Mark suggested, we can only add it to loop condition and explain the
case with comments instead of BUG.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: <stable@vger.kernel.org>
---
 fs/ocfs2/dlmglue.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 8b23aa2..23157e4 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -4025,9 +4025,13 @@ static void ocfs2_downconvert_thread_do_work(struct ocfs2_super *osb)
 	osb->dc_work_sequence = osb->dc_wake_sequence;

 	processed = osb->blocked_lock_count;
-	while (processed) {
-		BUG_ON(list_empty(&osb->blocked_lock_list));
-
+	/*
+	 * blocked lock processing in this loop might call iput which can
+	 * remove items off osb->blocked_lock_list. Downconvert up to
+	 * 'processed' number of locks, but stop short if we had some
+	 * removed in ocfs2_mark_lockres_freeing when downconverting.
+	 */
+	while (processed && !list_empty(&osb->blocked_lock_list)) {
 		lockres = list_entry(osb->blocked_lock_list.next,
 				     struct ocfs2_lock_res, l_blocked_list);
 		list_del_init(&lockres->l_blocked_list);
-- 
1.8.4.3
