From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon,  9 Nov 2009 16:08:54 -0800
Subject: [Ocfs2-devel] [PATCH 1/4] ocfs2: Add .gitignore
In-Reply-To: <1257811737-10835-1-git-send-email-sunil.mushran@oracle.com>
References: <1257811737-10835-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1257811737-10835-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 .gitignore                  |   43 +++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/.gitignore         |   35 +++++++++++++++++++++++++++++++++++
 fs/ocfs2/cluster/.gitignore |   35 +++++++++++++++++++++++++++++++++++
 fs/ocfs2/dlm/.gitignore     |   35 +++++++++++++++++++++++++++++++++++
 4 files changed, 148 insertions(+), 0 deletions(-)
 create mode 100644 .gitignore
 create mode 100644 fs/ocfs2/.gitignore
 create mode 100644 fs/ocfs2/cluster/.gitignore
 create mode 100644 fs/ocfs2/dlm/.gitignore

diff --git a/.gitignore b/.gitignore
new file mode 100644
index 0000000..9346a6d
--- /dev/null
+++ b/.gitignore
@@ -0,0 +1,43 @@
+#
+# Normal rules
+#
+#
+.*
+*.o
+*.o.*
+*.a
+*.s
+*.ko
+*.mod.c
+*.i
+.*.sw?
+*.pc
+
+#
+# Top-level generic files
+#
+!.gitignore
+!.mailmap
+
+# cscope files
+cscope.*
+ncscope.*
+
+# autoconf files
+Config.make
+autom4te.cache
+config.log
+config.status
+configure
+
+# misc
+stamp-md5
+*.orig
+*~
+\#*#
+
+Module.markers
+Module.symvers
+
+ocfs2-*.src.rpm
+ocfs2-*.tar.gz
diff --git a/fs/ocfs2/.gitignore b/fs/ocfs2/.gitignore
new file mode 100644
index 0000000..eca2a17
--- /dev/null
+++ b/fs/ocfs2/.gitignore
@@ -0,0 +1,35 @@
+#
+# Normal rules
+#
+#
+.*
+*.o
+*.o.*
+*.a
+*.s
+*.ko
+*.mod.c
+*.i
+
+#
+# Top-level generic files
+#
+!.gitignore
+!.mailmap
+
+# cscope files
+cscope.*
+ncscope.*
+
+# autoconf files
+Config.make
+autom4te.cache
+config.log
+config.status
+configure
+
+# misc
+stamp-md5
+*.orig
+*~
+\#*#
diff --git a/fs/ocfs2/cluster/.gitignore b/fs/ocfs2/cluster/.gitignore
new file mode 100644
index 0000000..eca2a17
--- /dev/null
+++ b/fs/ocfs2/cluster/.gitignore
@@ -0,0 +1,35 @@
+#
+# Normal rules
+#
+#
+.*
+*.o
+*.o.*
+*.a
+*.s
+*.ko
+*.mod.c
+*.i
+
+#
+# Top-level generic files
+#
+!.gitignore
+!.mailmap
+
+# cscope files
+cscope.*
+ncscope.*
+
+# autoconf files
+Config.make
+autom4te.cache
+config.log
+config.status
+configure
+
+# misc
+stamp-md5
+*.orig
+*~
+\#*#
diff --git a/fs/ocfs2/dlm/.gitignore b/fs/ocfs2/dlm/.gitignore
new file mode 100644
index 0000000..eca2a17
--- /dev/null
+++ b/fs/ocfs2/dlm/.gitignore
@@ -0,0 +1,35 @@
+#
+# Normal rules
+#
+#
+.*
+*.o
+*.o.*
+*.a
+*.s
+*.ko
+*.mod.c
+*.i
+
+#
+# Top-level generic files
+#
+!.gitignore
+!.mailmap
+
+# cscope files
+cscope.*
+ncscope.*
+
+# autoconf files
+Config.make
+autom4te.cache
+config.log
+config.status
+configure
+
+# misc
+stamp-md5
+*.orig
+*~
+\#*#
-- 
1.5.6.5
