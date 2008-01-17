From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Jan 17 14:37:07 2008
Subject: [Ocfs2-devel] [PATCH 28/30] configfs: Remove EXPERIMENTAL
In-Reply-To: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
Message-ID: <1200609356-17788-29-git-send-email-mark.fasheh@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>

From: Joel Becker <joel.becker@oracle.com>

configfs has been alive and kicking for a while now.  It underpins some
non-EXPERIMENTAL subsystems, such as OCFS2's cluster stack.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 605ee07..eb353f5 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1022,8 +1022,8 @@ config HUGETLB_PAGE
 	def_bool HUGETLBFS
 
 config CONFIGFS_FS
-	tristate "Userspace-driven configuration filesystem (EXPERIMENTAL)"
-	depends on SYSFS && EXPERIMENTAL
+	tristate "Userspace-driven configuration filesystem"
+	depends on SYSFS
 	help
 	  configfs is a ram-based filesystem that provides the converse
 	  of sysfs's functionality. Where sysfs is a filesystem-based
-- 
1.5.3.6
