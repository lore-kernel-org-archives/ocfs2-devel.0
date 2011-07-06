From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Wed, 6 Jul 2011 12:40:33 +0800
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: let ocfs2_dir_foreach return the
	error turned by filldir
Message-ID: <201107060539.p665dfRB020547@acsmt356.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Let ocfs2_dir_foreach return the error turned by filldir.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/dir.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 8582e3f..6d7560a 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -2005,6 +2005,8 @@ int ocfs2_dir_foreach(struct inode *inode, loff_t *f_pos, void *priv,
 
 	if (ret > 0)
 		ret = -EIO;
+	if (!ret)
+		ret = filldir_err;
 
 	return 0;
 }
-- 
1.7.5.2
