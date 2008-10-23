From: Tiger Yang <tiger.yang@oracle.com>
Date: Thu, 23 Oct 2008 16:34:44 +0800
Subject: [Ocfs2-devel] [PATCH 4/4] ocfs2: add array bounds checking
In-Reply-To: <49003524.3090405@oracle.com>
References: <49003524.3090405@oracle.com>
Message-ID: <1224750884-10976-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This could avoid arry bounds exceeded issue.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/xattr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 754e5fa..888641d 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -164,7 +164,7 @@ static inline const char *ocfs2_xattr_prefix(int name_index)
 {
 	struct xattr_handler *handler = NULL;
 
-	if (name_index > 0 && name_index < OCFS2_XATTR_MAX)
+	if (name_index > 0 && name_index < ARRAY_SIZE(ocfs2_xattr_handler_map))
 		handler = ocfs2_xattr_handler_map[name_index];
 
 	return handler ? handler->prefix : NULL;
-- 
1.5.4.1
