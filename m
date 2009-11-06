From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri,  6 Nov 2009 15:24:23 -0800
Subject: [Ocfs2-devel] [PATCH 1/2] fiemap: Add new extent flag
	FIEMAP_EXTENT_SHARED
In-Reply-To: <1257549864-18901-1-git-send-email-sunil.mushran@oracle.com>
References: <1257549864-18901-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1257549864-18901-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, hch@lst.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Patch adds flag FIEMAP_EXTENT_SHARED to denote extents that are
shared with other inodes.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Acked-by: Mark Fasheh <mfasheh@suse.com>
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
1.5.6.5
