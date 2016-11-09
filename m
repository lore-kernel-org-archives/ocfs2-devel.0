From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Wed, 09 Nov 2016 14:51:19 -0800
Subject: [Ocfs2-devel] [PATCH 2/6] ocfs2: add newlines to some error messages
In-Reply-To: <147873186646.2820.17513529102740292215.stgit@birch.djwong.org>
References: <147873186646.2820.17513529102740292215.stgit@birch.djwong.org>
Message-ID: <147873187918.2820.9787164404183287043.stgit@birch.djwong.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@versity.com, jlbec@evilplan.org, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

These two error messages are missing the trailing newline.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ocfs2/alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index f72712f..bb2d207 100644
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
