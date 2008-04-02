From: Mark Fasheh <mfasheh@suse.com>
Date: Wed,  2 Apr 2008 13:24:56 -0700
Subject: [Ocfs2-devel] [PATCH 60/62] ocfs2: Use BUG_ON
In-Reply-To: 12071673121124-git-send-email-mfasheh@suse.com
References: 12071673121124-git-send-email-mfasheh@suse.com
Message-ID: <12071679011207-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Julia Lawall <julia@diku.dk>

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/alloc.c   |    3 +--
 fs/ocfs2/journal.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index a268821..41f84c9 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -1029,8 +1029,7 @@ static void ocfs2_rotate_leaf(struct ocfs2_extent_list *el,
 	BUG_ON(!next_free);
 
 	/* The tree code before us didn't allow enough room in the leaf. */
-	if (el->l_next_free_rec == el->l_count && !has_empty)
-		BUG();
+	BUG_ON(el->l_next_free_rec == el->l_count && !has_empty);
 
 	/*
 	 * The easiest way to approach this is to just remove the
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index bffd2d7..9698338 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -717,8 +717,7 @@ int ocfs2_journal_load(struct ocfs2_journal *journal, int local)
 
 	mlog_entry_void();
 
-	if (!journal)
-		BUG();
+	BUG_ON(!journal);
 
 	osb = journal->j_osb;
 
-- 
1.5.4.1
