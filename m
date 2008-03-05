From: Joel Becker <joel.becker@oracle.com>
Date: Wed Mar  5 17:14:29 2008
Subject: [Ocfs2-devel] [PATCH 10/10] ocfs2: Allow selection of cluster
	plug-ins.
In-Reply-To: <1204766038-31721-1-git-send-email-joel.becker@oracle.com>
References: <1204766038-31721-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1204766038-31721-11-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

ocfs2 now supports plug-ins for the classic O2CB stack as well as
userspace cluster stacks in conjunction with fs/dlm.  This allows zero,
one, or both of the plug-ins to be selected in Kconfig.  For local mounts
(non-clustered), neither plug-in is needed.  Both plugins can be loaded
at one time, the runtime will select the one needed for the cluster
systme in use.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/Kconfig        |   26 ++++++++++++++++++++++++++
 fs/ocfs2/Makefile |   10 ++++++----
 2 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index d731282..1b0e775 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -444,6 +444,32 @@ config OCFS2_FS
 	  For more information on OCFS2, see the file
 	  <file:Documentation/filesystems/ocfs2.txt>.
 
+config OCFS2_FS_O2CB
+	tristate "O2CB Kernelspace Clustering"
+	depends on OCFS2_FS
+	default y
+	help
+	  OCFS2 includes a simple kernelspace clustering package, the OCFS2
+	  Cluster Base.  It only requires a very small userspace compontent
+	  to configure it. This comes with the standard ocfs2-tools package.
+	  O2CB is limited to maintaining a cluster for OCFS2 file systems.
+	  It cannot manage any other cluster applications.
+
+	  It is always safe to say Y here, as the clustering method is
+	  run-time selectable.
+
+config OCFS2_FS_USERSPACE_CLUSTER
+	tristate "OCFS2 Userspace Clustering"
+	depends on OCFS2_FS && DLM
+	default y
+	help
+	  This option will allow OCFS2 to use userspace clustering services
+	  in conjunction with the DLM in fs/dlm.  If you are using a
+	  userspace cluster manager, say Y here.
+
+	  It is safe to say Y, as the clustering method is run-time
+	  selectable.
+
 config OCFS2_DEBUG_MASKLOG
 	bool "OCFS2 logging support"
 	depends on OCFS2_FS
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index b8d6d02..f6956de 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -4,9 +4,10 @@ EXTRA_CFLAGS += -DCATCH_BH_JBD_RACES
 
 obj-$(CONFIG_OCFS2_FS) += 	\
 	ocfs2.o			\
-	ocfs2_stackglue.o	\
-	ocfs2_stack_o2cb.o	\
-	ocfs2_stack_user.o
+	ocfs2_stackglue.o
+
+obj-$(CONFIG_OCFS2_FS_O2CB) += ocfs2_stack_o2cb.o
+obj-$(CONFIG_OCFS2_FS_USERSPACE_CLUSTER) += ocfs2_stack_user.o
 
 ocfs2-objs := \
 	alloc.o 		\
@@ -39,5 +40,6 @@ ocfs2_stackglue-objs := stackglue.o
 ocfs2_stack_o2cb-objs := stack_o2cb.o
 ocfs2_stack_user-objs := stack_user.o
 
+# cluster/ is always needed when OCFS2_FS for masklog support
 obj-$(CONFIG_OCFS2_FS) += cluster/
-obj-$(CONFIG_OCFS2_FS) += dlm/
+obj-$(CONFIG_OCFS2_FS_O2CB) += dlm/
-- 
1.5.3.8
