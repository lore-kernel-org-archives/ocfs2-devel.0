From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 12 May 2008 18:31:35 -0700
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2/net: Silence build warnings
Message-ID: <1210642297-23180-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch silences the build warnings concerning o2net_debugfs_init()
and friends when building without CONFIG_DEBUG_FS enabled.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/tcp.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.h b/fs/ocfs2/cluster/tcp.h
index a705d5d..fd6179e 100644
--- a/fs/ocfs2/cluster/tcp.h
+++ b/fs/ocfs2/cluster/tcp.h
@@ -128,23 +128,23 @@ void o2net_debug_del_nst(struct o2net_send_tracking *nst);
 void o2net_debug_add_sc(struct o2net_sock_container *sc);
 void o2net_debug_del_sc(struct o2net_sock_container *sc);
 #else
-static int o2net_debugfs_init(void)
+static inline int o2net_debugfs_init(void)
 {
 	return 0;
 }
-static void o2net_debugfs_exit(void)
+static inline void o2net_debugfs_exit(void)
 {
 }
-static void o2net_debug_add_nst(struct o2net_send_tracking *nst)
+static inline void o2net_debug_add_nst(struct o2net_send_tracking *nst)
 {
 }
-static void o2net_debug_del_nst(struct o2net_send_tracking *nst)
+static inline void o2net_debug_del_nst(struct o2net_send_tracking *nst)
 {
 }
-static void o2net_debug_add_sc(struct o2net_sock_container *sc)
+static inline void o2net_debug_add_sc(struct o2net_sock_container *sc)
 {
 }
-static void o2net_debug_del_sc(struct o2net_sock_container *sc)
+static inline void o2net_debug_del_sc(struct o2net_sock_container *sc)
 {
 }
 #endif	/* CONFIG_DEBUG_FS */
-- 
1.5.3.6
