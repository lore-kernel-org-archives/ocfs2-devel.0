From: J. Bruce Fields <bfields@fieldses.org>
Date: Tue, 31 Jul 2012 18:33:23 -0400
Subject: [Ocfs2-devel] [RFC PATCH] ocfs2: don't depend on DCACHE_DISCONNECTED
Message-ID: <20120731223323.GA32253@fieldses.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org

From: "J. Bruce Fields" <bfields@redhat.com>

XXX: I don't understand this code, but I also can't see how it can be
right as is: a dentry marked DCACHE_DISCONNECTED can in fact be a
fully-connected member of the dcache.  Is IS_ROOT() the right check
instead?

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
---
 fs/ocfs2/dcache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
index e5ba348..2a66620 100644
--- a/fs/ocfs2/dcache.c
+++ b/fs/ocfs2/dcache.c
@@ -461,7 +461,7 @@ static void ocfs2_dentry_iput(struct dentry *dentry, struct inode *inode)
 		 * No dentry lock is ok if we're disconnected or
 		 * unhashed.
 		 */
-		if (!(dentry->d_flags & DCACHE_DISCONNECTED) &&
+		if (!IS_ROOT(dentry)) &&
 		    !d_unhashed(dentry)) {
 			unsigned long long ino = 0ULL;
 			if (inode)
-- 
1.7.11.2
