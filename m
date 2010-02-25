From: Coly Li <coly.li@suse.de>
Date: Thu, 25 Feb 2010 14:57:13 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix warning in ocfs2_file_aio_write()
Message-ID: <4B861F49.6070904@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch fixes a compiling warning in ocfs2_file_aio_write().

Signed-off-by: Coly Li <coly.li@suse.de>
---
 fs/ocfs2/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 558ce03..a712094 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2043,7 +2043,7 @@ out_dio:
 	 * async dio is going to do it in the future or an end_io after an
 	 * error has already done it.
 	 */
-	if (ret == -EIOCBQUEUED || !ocfs2_iocb_is_rw_locked(iocb)) {
+	if ((ret == -EIOCBQUEUED) || (!ocfs2_iocb_is_rw_locked(iocb))) {
 		rw_level = -1;
 		have_alloc_sem = 0;
 	}
-- 
Coly Li
SuSE Labs
