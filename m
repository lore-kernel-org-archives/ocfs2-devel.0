From: Tariq Saeed <tariq.x.saeed@oracle.com>
Date: Fri, 20 Dec 2013 12:14:41 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: ocfs2 punch hole retrun EINVAL if
	the length argument in ioctl is negative
Message-ID: <1387570481-3424-1-git-send-email-tariq.x.saeed@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Orabug:14789508

An unreserve space ioctl OCFS2_IOC_UNRESVSP/64 should reject a negative
length.

Signed-off-by: Tariq Saseed <tariq.x.saeed@oracle.com>
Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
---
 fs/ocfs2/file.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 3261d71..408086e 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1873,7 +1873,8 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 	}
 	size = sr->l_start + sr->l_len;
 
-	if (cmd == OCFS2_IOC_RESVSP || cmd == OCFS2_IOC_RESVSP64) {
+	if (cmd == OCFS2_IOC_RESVSP || cmd == OCFS2_IOC_RESVSP64 ||
+	    cmd == OCFS2_IOC_UNRESVSP || cmd == OCFS2_IOC_UNRESVSP64) {
 		if (sr->l_len <= 0) {
 			ret = -EINVAL;
 			goto out_inode_unlock;
-- 
1.7.1
