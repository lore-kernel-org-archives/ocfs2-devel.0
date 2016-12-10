From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Sat, 10 Dec 2016 12:43:22 -0800
Subject: [Ocfs2-devel] [PATCH 04/11] ocfs2: add newlines to some error
	messages
In-Reply-To: <148140257493.24628.6724911560073347399.stgit@birch.djwong.org>
References: <148140257493.24628.6724911560073347399.stgit@birch.djwong.org>
Message-ID: <148140260203.24628.11352768180158359624.stgit@birch.djwong.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@versity.com, akpm@linux-foundation.org, jlbec@evilplan.org, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, ocfs2-devel@oss.oracle.com

These two error messages are missing the trailing newline.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ocfs2/alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index a0ca49f..d4ec0d8 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -5194,7 +5194,7 @@ int ocfs2_change_extent_flag(handle_t *handle,
 	rec = &el->l_recs[index];
 	if (new_flags && (rec->e_flags & new_flags)) {
 		mlog(ML_ERROR, "Owner %llu tried to set %d flags on an "
-		     "extent that already had them",
+		     "extent that already had them\n",
 		     (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
 		     new_flags);
 		goto out;
@@ -5202,7 +5202,7 @@ int ocfs2_change_extent_flag(handle_t *handle,
 
 	if (clear_flags && !(rec->e_flags & clear_flags)) {
 		mlog(ML_ERROR, "Owner %llu tried to clear %d flags on an "
-		     "extent that didn't have them",
+		     "extent that didn't have them\n",
 		     (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
 		     clear_flags);
 		goto out;
