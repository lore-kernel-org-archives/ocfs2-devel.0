From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 14 Jul 2008 15:01:41 -0700
Subject: [Ocfs2-devel] [PATCH 08/17] ocfs2: Fix CONFIG_OCFS2_DEBUG_FS #ifdefs
In-Reply-To: <1216072910-27226-1-git-send-email-mfasheh@suse.com>
References: <1216072910-27226-1-git-send-email-mfasheh@suse.com>
Message-ID: <1216072910-27226-9-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>

From: Joel Becker <joel.becker@oracle.com>

A couple places use OCFS2_DEBUG_FS where they really mean
CONFIG_OCFS2_DEBUG_FS.

Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/journal.c    |    2 +-
 fs/ocfs2/localalloc.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 9698338..a8c19cb 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -329,7 +329,7 @@ int ocfs2_extend_trans(handle_t *handle, int nblocks)
 
 	mlog(0, "Trying to extend transaction by %d blocks\n", nblocks);
 
-#ifdef OCFS2_DEBUG_FS
+#ifdef CONFIG_OCFS2_DEBUG_FS
 	status = 1;
 #else
 	status = journal_extend(handle, nblocks);
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index be774bd..28e492e 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -498,7 +498,7 @@ int ocfs2_reserve_local_alloc_bits(struct ocfs2_super *osb,
 
 	alloc = (struct ocfs2_dinode *) osb->local_alloc_bh->b_data;
 
-#ifdef OCFS2_DEBUG_FS
+#ifdef CONFIG_OCFS2_DEBUG_FS
 	if (le32_to_cpu(alloc->id1.bitmap1.i_used) !=
 	    ocfs2_local_alloc_count_bits(alloc)) {
 		ocfs2_error(osb->sb, "local alloc inode %llu says it has "
-- 
1.5.4.1
