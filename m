From: Coly Li <coyli@suse.de>
Date: Tue, 02 Dec 2008 19:20:22 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: add comments on ocfs2_do_flock()
Message-ID: <493519F6.5070308@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch adds a comment to explain when file is locked and F_SETLKW is set, -EWOULDBLOCK should be
returned other than -EAGAIN.
It helps the code to be more understandable.

Signed-off-by: Coly Li <coyli@suse.de>
---
 fs/ocfs2/locks.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/locks.c b/fs/ocfs2/locks.c
index 544ac62..cc9d947 100644
--- a/fs/ocfs2/locks.c
+++ b/fs/ocfs2/locks.c
@@ -75,6 +75,9 @@ static int ocfs2_do_flock(struct file *file, struct inode *inode,

 	ret = ocfs2_file_lock(file, level, trylock);
 	if (ret) {
+		/* The file is locked and the F_SETLKW
+		 * flag is NOT set in cmd.
+		 */
 		if (ret == -EAGAIN && trylock)
 			ret = -EWOULDBLOCK;
 		else

-- 
Coly Li
SuSE PRC Labs
