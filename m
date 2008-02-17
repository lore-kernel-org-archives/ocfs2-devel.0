From: Julia Lawall <julia@diku.dk>
Date: Sun, 17 Feb 2008 17:56:08 -0000
Subject: [Ocfs2-devel] [PATCH 3/7] fs/ocfs2: Use BUG_ON
Message-ID: <Pine.LNX.4.64.0802171855070.28055@ask.diku.dk>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mark.fasheh@oracle.com, kurt.hackel@oracle.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

if (...) BUG(); should be replaced with BUG_ON(...) when the test has no
side-effects to allow a definition of BUG_ON that drops the code completely.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@ disable unlikely @ expression E,f; @@

(
  if (<... f(...) ...>) { BUG(); }
|
- if (unlikely(E)) { BUG(); }
+ BUG_ON(E);
)

@@ expression E,f; @@

(
  if (<... f(...) ...>) { BUG(); }
|
- if (E) { BUG(); }
+ BUG_ON(E);
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---

diff -u -p a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c 2008-02-05 20:56:02.000000000 +0100
+++ b/fs/ocfs2/alloc.c 2008-02-17 16:40:41.000000000 +0100
@@ -1029,8 +1029,7 @@ static void ocfs2_rotate_leaf(struct ocf
 	BUG_ON(!next_free);
 
 	/* The tree code before us didn't allow enough room in the leaf. */
-	if (el->l_next_free_rec == el->l_count && !has_empty)
-		BUG();
+	BUG_ON(el->l_next_free_rec == el->l_count && !has_empty);
 
 	/*
 	 * The easiest way to approach this is to just remove the
diff -u -p a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c 2008-02-02 16:09:08.000000000 +0100
+++ b/fs/ocfs2/journal.c 2008-02-17 16:40:59.000000000 +0100
@@ -586,8 +586,7 @@ int ocfs2_journal_load(struct ocfs2_jour
 
 	mlog_entry_void();
 
-	if (!journal)
-		BUG();
+	BUG_ON(!journal);
 
 	osb = journal->j_osb;
 
