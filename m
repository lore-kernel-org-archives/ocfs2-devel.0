From: Richard Weinberger <richard@nod.at>
Date: Sat, 02 Mar 2013 15:33:13 -0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: Update version string
Message-ID: <1362238380-11303-1-git-send-email-richard@nod.at>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com
Cc: mfasheh@suse.com, jlbec@evilplan.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Richard Weinberger <richard@nod.at>

The current version string is outdated.
Update it to 1.8.0 to reflect the real OCFS2 feature set.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 fs/ocfs2/ver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/ver.c b/fs/ocfs2/ver.c
index e2488f4..cae2a2c 100644
--- a/fs/ocfs2/ver.c
+++ b/fs/ocfs2/ver.c
@@ -29,7 +29,7 @@
 
 #include "ver.h"
 
-#define OCFS2_BUILD_VERSION "1.5.0"
+#define OCFS2_BUILD_VERSION "1.8.0"
 
 #define VERSION_STR "OCFS2 " OCFS2_BUILD_VERSION
 
-- 
1.8.1.2
