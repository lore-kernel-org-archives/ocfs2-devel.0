From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri Feb  8 10:49:59 2008
Subject: [Ocfs2-devel] [PATCH 1/4] ocfs2: Fix broken rpm build
In-Reply-To: <1202496577-21982-1-git-send-email-sunil.mushran@oracle.com>
References: <1202496577-21982-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1202496577-21982-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Commit 959aeecc8cdaf7ce6046227062086624d4eb7031 in this tree missed
including kapi-include/include/mandatory_lock.h to Makefile.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 4a290cf..8e17890 100644
--- a/Makefile
+++ b/Makefile
@@ -31,7 +31,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/writeback_control.h \
 	kapi-compat/include/blkcnt_t.h \
 	kapi-compat/include/read_mapping_page.h \
-	kapi-compat/include/aiovec.h
+	kapi-compat/include/aiovec.h \
+	kapi-compat/include/mandatory_lock.h
 
 PATCH_FILES =
 
-- 
1.5.2.5
