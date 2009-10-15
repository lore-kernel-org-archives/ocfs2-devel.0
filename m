From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 15 Oct 2009 15:41:23 -0700
Subject: [Ocfs2-devel] [PATCH] fiemap: Add new extent flag
	FIEMAP_EXTENT_SHARED
Message-ID: <1255646484-28357-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

Patch adds flag FIEMAP_EXTENT_SHARED to denote extents that are
shared with other inodes.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 include/linux/fiemap.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/fiemap.h b/include/linux/fiemap.h
index 934e22d..d830747 100644
--- a/include/linux/fiemap.h
+++ b/include/linux/fiemap.h
@@ -62,5 +62,7 @@ struct fiemap {
 #define FIEMAP_EXTENT_MERGED		0x00001000 /* File does not natively
 						    * support extents. Result
 						    * merged for efficiency. */
+#define FIEMAP_EXTENT_SHARED		0x00002000 /* Space shared with other
+						    * files. */
 
 #endif /* _LINUX_FIEMAP_H */
-- 
1.6.0.4
