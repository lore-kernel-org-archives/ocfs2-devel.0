From: Jan Kara <jack@suse.cz>
Date: Tue, 28 Jul 2009 12:18:42 +0200
Subject: [Ocfs2-devel] [PATCH 10/10] Fix tunefs space check when disabling
	SPARSE feature
In-Reply-To: <1248776322-14987-1-git-send-email-jack@suse.cz>
References: <1248776322-14987-1-git-send-email-jack@suse.cz>
Message-ID: <1248776322-14987-3-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Tunefs missed addition of number clusters needed to fill holes when disabling
SPARSE feature and hence the check whether there's enough space in the
filesystem didn't work.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 tunefs.ocfs2/feature_sparse_files.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tunefs.ocfs2/feature_sparse_files.c b/tunefs.ocfs2/feature_sparse_files.c
index 65db46b..e5b3dab 100644
--- a/tunefs.ocfs2/feature_sparse_files.c
+++ b/tunefs.ocfs2/feature_sparse_files.c
@@ -321,6 +321,7 @@ static errcode_t hole_iterate(ocfs2_filesys *fs, struct ocfs2_dinode *di,
 
 	list_add_tail(&file->list, &ctxt->files);
 	ctxt->holecount += file->holes_num;
+	ctxt->more_clusters += file->hole_clusters;
 
 	tools_progress_step(ctxt->prog, 1);
 
-- 
1.6.0.2
