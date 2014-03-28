From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Fri, 28 Mar 2014 14:44:57 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Fix panic on kfree(xattr->name)
In-Reply-To: <1396043097-7192-1-git-send-email-srinivas.eeda@oracle.com>
References: <1396043097-7192-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <1396043097-7192-2-git-send-email-srinivas.eeda@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

Commit 9548906b 'xattr: Constify ->name member of "struct xattr".' missed that
ocfs2 is calling kfree(xattr->name). As a result, kernel panic occurs upon
calling kfree(xattr->name) because xattr->name refers static constant names.
This patch removes kfree(xattr->name) from ocfs2_mknod() and ocfs2_symlink().

Reported-by: Tariq Saeed <tariq.x.saeed@oracle.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
---
 fs/ocfs2/namei.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 3683643..feed025f 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -450,7 +450,6 @@ leave:
 
 	brelse(new_fe_bh);
 	brelse(parent_fe_bh);
-	kfree(si.name);
 	kfree(si.value);
 
 	ocfs2_free_dir_lookup_result(&lookup);
@@ -1855,7 +1854,6 @@ bail:
 
 	brelse(new_fe_bh);
 	brelse(parent_fe_bh);
-	kfree(si.name);
 	kfree(si.value);
 	ocfs2_free_dir_lookup_result(&lookup);
 	if (inode_ac)
-- 
1.7.9.5
