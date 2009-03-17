From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 17 Mar 2009 13:01:02 -0700
Subject: [Ocfs2-devel] [PATCH 12/32] ocfs2: re-order ocfs2_empty_dir checks
In-Reply-To: <1237320082-12921-1-git-send-email-mfasheh@suse.com>
References: <1237320082-12921-1-git-send-email-mfasheh@suse.com>
Message-ID: <1237320082-12921-13-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>

ocfs2_empty_dir() is far more expensive than checking link count. Since both
need to be checked at the same time, we can improve performance by checking
link count first.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/namei.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 67113cf..58c318d 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -834,10 +834,7 @@ static int ocfs2_unlink(struct inode *dir,
 	child_locked = 1;
 
 	if (S_ISDIR(inode->i_mode)) {
-	       	if (!ocfs2_empty_dir(inode)) {
-			status = -ENOTEMPTY;
-			goto leave;
-		} else if (inode->i_nlink != 2) {
+		if (inode->i_nlink != 2 || !ocfs2_empty_dir(inode)) {
 			status = -ENOTEMPTY;
 			goto leave;
 		}
@@ -1280,8 +1277,8 @@ static int ocfs2_rename(struct inode *old_dir,
 
 	if (target_exists) {
 		if (S_ISDIR(new_inode->i_mode)) {
-			if (!ocfs2_empty_dir(new_inode) ||
-			    new_inode->i_nlink != 2) {
+			if (new_inode->i_nlink != 2 ||
+			    !ocfs2_empty_dir(new_inode)) {
 				status = -ENOTEMPTY;
 				goto bail;
 			}
-- 
1.5.6
