From: Coly Li <coly.li@suse.de>
Date: Fri, 26 Mar 2010 04:21:39 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: one more warning fix in
	ocfs2_file_aio_write()
Message-ID: <4BABC5D3.50400@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch fixes another compiling warning in ocfs2_file_aio_write() like this,
    fs/ocfs2/file.c: In function ?ocfs2_file_aio_write?:
    fs/ocfs2/file.c:2026: warning: suggest parentheses around ?&&? within ?||?

Signed-off-by: Coly Li <coly.li@suse.de>
---
 fs/ocfs2/file.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 17947dc..c4638fd 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2021,8 +2021,8 @@ out_dio:
 		if (ret < 0)
 			written = ret;

-		if (!ret && (old_size != i_size_read(inode) ||
-		    old_clusters != OCFS2_I(inode)->ip_clusters ||
+		if ((!ret) && ((old_size != i_size_read(inode)) ||
+		    (old_clusters != OCFS2_I(inode)->ip_clusters) ||
 		    has_refcount)) {
 			ret = jbd2_journal_force_commit(osb->journal->j_journal);
 			if (ret < 0)
-- 
Coly Li
SuSE Labs
