From: Joel Becker <joel.becker@oracle.com>
Date: Mon, 20 Oct 2008 19:08:15 -0700
Subject: [Ocfs2-devel] [PATCH 2/5] ocfs2: Don't return -EFAULT from a
	corrupt xattr entry.
In-Reply-To: <1224554898-3928-1-git-send-email-joel.becker@oracle.com>
References: <1224554898-3928-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1224554898-3928-3-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

If the xattr disk structures are corrupt, return -EIO, not -EFAULT.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 44d58f1..ec262ef 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1226,7 +1226,7 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 
 	free = min_offs - ((void *)last - xs->base) - sizeof(__u32);
 	if (free < 0)
-		return -EFAULT;
+		return -EIO;
 
 	if (!xs->not_found) {
 		size_t size = 0;
-- 
1.5.6.5
