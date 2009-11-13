From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 12 Nov 2009 17:47:23 -0800
Subject: [Ocfs2-devel] [PATCH 02/18] ocfs2: Add KAPI_INIT_WORK macro in
	kapi-default.h
In-Reply-To: <1258076859-13538-1-git-send-email-sunil.mushran@oracle.com>
References: <1258076859-13538-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1258076859-13538-3-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Commit dbc80b8f391820b719db97004219327c8cf050bc added KAPI_INIT_WORK
macros to fs/ocfs2/kapi-default.h. This patch adds the same to the
same header in dlm and cluster sub-directories.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/kapi-default.h |    6 ++++++
 fs/ocfs2/dlm/kapi-default.h     |    6 ++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/cluster/kapi-default.h b/fs/ocfs2/cluster/kapi-default.h
index fcf3ac9..21e5e3a 100644
--- a/fs/ocfs2/cluster/kapi-default.h
+++ b/fs/ocfs2/cluster/kapi-default.h
@@ -22,5 +22,11 @@
 #ifndef KAPI_DEFAULT_H
 #define KAPI_DEFAULT_H
 
+#ifndef KAPI_INIT_WORK
+typedef struct work_struct kapi_work_struct_t;
+# define work_to_object(a, b, c)		container_of(a, b, c)
+# define KAPI_INIT_WORK(a, b, c)		INIT_WORK(a, b)
+# define KAPI_INIT_DELAYED_WORK(a, b, c)	INIT_DELAYED_WORK(a, b)
+#endif
 
 #endif
diff --git a/fs/ocfs2/dlm/kapi-default.h b/fs/ocfs2/dlm/kapi-default.h
index fcf3ac9..21e5e3a 100644
--- a/fs/ocfs2/dlm/kapi-default.h
+++ b/fs/ocfs2/dlm/kapi-default.h
@@ -22,5 +22,11 @@
 #ifndef KAPI_DEFAULT_H
 #define KAPI_DEFAULT_H
 
+#ifndef KAPI_INIT_WORK
+typedef struct work_struct kapi_work_struct_t;
+# define work_to_object(a, b, c)		container_of(a, b, c)
+# define KAPI_INIT_WORK(a, b, c)		INIT_WORK(a, b)
+# define KAPI_INIT_DELAYED_WORK(a, b, c)	INIT_DELAYED_WORK(a, b)
+#endif
 
 #endif
-- 
1.5.6.5
