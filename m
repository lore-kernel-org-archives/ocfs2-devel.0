From: Jan Kara <jack@suse.cz>
Date: Wed, 14 Oct 2009 20:08:59 +0200
Subject: [Ocfs2-devel] [PATCH 5/5] Don't account space used for system files
	when disabling sparse feature
In-Reply-To: <1255543739-23844-1-git-send-email-jack@suse.cz>
References: <1255543739-23844-1-git-send-email-jack@suse.cz>
Message-ID: <1255543739-23844-6-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

System files (except for root directory) are not accounted in quota. So we
should not add the space used to fill holes in them when disabling sparse
feature.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 tunefs.ocfs2/feature_sparse_files.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/tunefs.ocfs2/feature_sparse_files.c b/tunefs.ocfs2/feature_sparse_files.c
index 4f8c0db..a8e8b7b 100644
--- a/tunefs.ocfs2/feature_sparse_files.c
+++ b/tunefs.ocfs2/feature_sparse_files.c
@@ -489,7 +489,9 @@ static errcode_t fill_sparse_files(ocfs2_filesys *fs,
 			if (ret)
 				break;
 		}
-		if (di->i_clusters != file->old_clusters) {
+		if (di->i_clusters != file->old_clusters && 
+		    (!(di->i_flags & OCFS2_SYSTEM_FL) ||
+		    file->blkno == super->s_root_blkno)) {
 			long long change;
 
 			if (di->i_clusters > file->old_clusters) {
-- 
1.6.0.2
