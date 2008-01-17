From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Jan 17 14:36:41 2008
Subject: [Ocfs2-devel] [PATCH 27/30] ocfs2: bump version number
In-Reply-To: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
Message-ID: <1200609356-17788-28-git-send-email-mark.fasheh@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Mark Fasheh <mark.fasheh@oracle.com>

Bump the printed version to 1.5.0. This helps us quickly identify which
version of Ocfs2 a bug filer is running.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/cluster/ver.c  |    2 +-
 fs/ocfs2/dlm/dlmfsver.c |    2 +-
 fs/ocfs2/dlm/dlmver.c   |    2 +-
 fs/ocfs2/ver.c          |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/cluster/ver.c b/fs/ocfs2/cluster/ver.c
index 7286c48..a56eee6 100644
--- a/fs/ocfs2/cluster/ver.c
+++ b/fs/ocfs2/cluster/ver.c
@@ -28,7 +28,7 @@
 
 #include "ver.h"
 
-#define CLUSTER_BUILD_VERSION "1.3.3"
+#define CLUSTER_BUILD_VERSION "1.5.0"
 
 #define VERSION_STR "OCFS2 Node Manager " CLUSTER_BUILD_VERSION
 
diff --git a/fs/ocfs2/dlm/dlmfsver.c b/fs/ocfs2/dlm/dlmfsver.c
index d2be3ad..a733b33 100644
--- a/fs/ocfs2/dlm/dlmfsver.c
+++ b/fs/ocfs2/dlm/dlmfsver.c
@@ -28,7 +28,7 @@
 
 #include "dlmfsver.h"
 
-#define DLM_BUILD_VERSION "1.3.3"
+#define DLM_BUILD_VERSION "1.5.0"
 
 #define VERSION_STR "OCFS2 DLMFS " DLM_BUILD_VERSION
 
diff --git a/fs/ocfs2/dlm/dlmver.c b/fs/ocfs2/dlm/dlmver.c
index 7ef2653..dfc0da4 100644
--- a/fs/ocfs2/dlm/dlmver.c
+++ b/fs/ocfs2/dlm/dlmver.c
@@ -28,7 +28,7 @@
 
 #include "dlmver.h"
 
-#define DLM_BUILD_VERSION "1.3.3"
+#define DLM_BUILD_VERSION "1.5.0"
 
 #define VERSION_STR "OCFS2 DLM " DLM_BUILD_VERSION
 
diff --git a/fs/ocfs2/ver.c b/fs/ocfs2/ver.c
index 5405ce1..e2488f4 100644
--- a/fs/ocfs2/ver.c
+++ b/fs/ocfs2/ver.c
@@ -29,7 +29,7 @@
 
 #include "ver.h"
 
-#define OCFS2_BUILD_VERSION "1.3.3"
+#define OCFS2_BUILD_VERSION "1.5.0"
 
 #define VERSION_STR "OCFS2 " OCFS2_BUILD_VERSION
 
-- 
1.5.3.6
