From: Joel Becker <joel.becker@oracle.com>
Date: Wed Mar  5 17:14:29 2008
Subject: [Ocfs2-devel] [PATCH 09/10] ocfs2: Add kbuild for
	ocfs2_stack_user.ko
In-Reply-To: <1204766038-31721-1-git-send-email-joel.becker@oracle.com>
References: <1204766038-31721-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1204766038-31721-10-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

Add ocfs2_stack_user.ko to the Makefile so that it builds.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/Makefile |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index b734254..b8d6d02 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -2,7 +2,11 @@ EXTRA_CFLAGS += -Ifs/ocfs2
 
 EXTRA_CFLAGS += -DCATCH_BH_JBD_RACES
 
-obj-$(CONFIG_OCFS2_FS) += ocfs2.o ocfs2_stackglue.o ocfs2_stack_o2cb.o
+obj-$(CONFIG_OCFS2_FS) += 	\
+	ocfs2.o			\
+	ocfs2_stackglue.o	\
+	ocfs2_stack_o2cb.o	\
+	ocfs2_stack_user.o
 
 ocfs2-objs := \
 	alloc.o 		\
@@ -33,6 +37,7 @@ ocfs2-objs := \
 
 ocfs2_stackglue-objs := stackglue.o
 ocfs2_stack_o2cb-objs := stack_o2cb.o
+ocfs2_stack_user-objs := stack_user.o
 
 obj-$(CONFIG_OCFS2_FS) += cluster/
 obj-$(CONFIG_OCFS2_FS) += dlm/
-- 
1.5.3.8
