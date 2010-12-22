From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 22 Dec 2010 12:39:37 -0800
Subject: [Ocfs2-devel] [PATCH 1/6] ocfs2: Add DEBUG_FS dependency
In-Reply-To: <1293050382-3636-1-git-send-email-sunil.mushran@oracle.com>
References: <1293050382-3636-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1293050382-3636-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Make OCFS2_FS_STATS depend on DEBUG_FS.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/Kconfig b/fs/ocfs2/Kconfig
index 0d84066..ab152c0 100644
--- a/fs/ocfs2/Kconfig
+++ b/fs/ocfs2/Kconfig
@@ -51,7 +51,7 @@ config OCFS2_FS_USERSPACE_CLUSTER
 
 config OCFS2_FS_STATS
 	bool "OCFS2 statistics"
-	depends on OCFS2_FS
+	depends on OCFS2_FS && DEBUG_FS
 	default y
 	help
 	  This option allows some fs statistics to be captured. Enabling
-- 
1.7.1
