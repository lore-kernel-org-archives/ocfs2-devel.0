From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 13 May 2008 13:45:14 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: Add CONFIG_OCFS2_FS_STATS config
	option
Message-ID: <1210711515-30555-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch adds config option CONFIG_OCFS2_FS_STATS to allow building
the fs with instrumentation enabled. An upcoming patch will provide
support to instrument cluster locking, which is a crucial overhead in
a cluster file system. This config option allows users to avoid the cpu
and memory overhead that is involved in gathering such statistics.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/Kconfig |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index cf12c40..c264610 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -470,6 +470,14 @@ config OCFS2_FS_USERSPACE_CLUSTER
 	  It is safe to say Y, as the clustering method is run-time
 	  selectable.
 
+config OCFS2_FS_STATS
+	bool "OCFS2 statistics"
+	depends on OCFS2_FS
+	default y
+	help
+	  This option allows some fs statistics to be captured. Enabling
+	  this option may increase the memory consumption.
+
 config OCFS2_DEBUG_MASKLOG
 	bool "OCFS2 logging support"
 	depends on OCFS2_FS
-- 
1.5.3.6
