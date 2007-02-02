From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri Feb  2 09:28:36 2007
Subject: [Ocfs2-devel] [git patches] ocfs2 fixes
Message-ID: <20070202172830.GM14799@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

One more regression fix for 2.6.20.

For some reason my test pulls aren't going through right now. Just to be
safe, I'll also include the entire patch and commit message below in a
manner suitable for commit from an e-mail.
	--Mark

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following update:


From: Mark Fasheh <mark.fasheh@oracle.com>
[PATCH] ocfs2: ocfs2_link() journal credits update

Commit 592282cf2eaa33409c6511ddd3f3ecaa57daeaaa fixed some missing directory
c/mtime updates in part by introducing a dinode update in ocfs2_add_entry().
Unfortunately, ocfs2_link() (which didn't update the directory inode before)
is now missing a single journal credit. Fix this by doubling the number of
inode updates expected during hard link creation.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/journal.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index e121636..d026b4f 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -306,8 +306,8 @@ #define OCFS2_WINDOW_MOVE_CREDITS (OCFS2
  * for the dinode, one for the new block. */
 #define OCFS2_SIMPLE_DIR_EXTEND_CREDITS (2)
 
-/* file update (nlink, etc) + dir entry block */
-#define OCFS2_LINK_CREDITS  (OCFS2_INODE_UPDATE_CREDITS + 1)
+/* file update (nlink, etc) + directory mtime/ctime + dir entry block */
+#define OCFS2_LINK_CREDITS  (2*OCFS2_INODE_UPDATE_CREDITS + 1)
 
 /* inode + dir inode (if we unlink a dir), + dir entry block + orphan
  * dir inode link */
-- 
1.4.2.3
