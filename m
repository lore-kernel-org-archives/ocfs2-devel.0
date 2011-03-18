From: Rakib Mullick <rakib.mullick@gmail.com>
Date: Fri, 18 Mar 2011 17:01:08 +0600
Subject: [Ocfs2-devel] [PATCH] fs,
	ocfs2: Move o2net_get_func_run_time under CONFIG_OCFS2_FS_STATS.
Message-ID: <AANLkTi=uysftkFdzEE2Xshg3br_tFB=hhZ4BwX-TzLm0@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: LKML <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, Sunil Mushran <sunil.mushran@oracle.com>

When CONFIG_DEBUG_FS=y and CONFIG_OCFS2_FS_STATS=n, we get the
following warning:

fs/ocfs2/cluster/tcp.c:213:16: warning: ?o2net_get_func_run_time?
defined but not used

Since o2net_get_func_run_time is only called from
o2net_update_recv_stats, so move it under CONFIG_OCFS2_FS_STATS.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 3b11cb1..ee04ff5 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -210,10 +210,6 @@ static inline void
o2net_set_func_stop_time(struct o2net_sock_container *sc)
 	sc->sc_tv_func_stop = ktime_get();
 }

-static ktime_t o2net_get_func_run_time(struct o2net_sock_container *sc)
-{
-	return ktime_sub(sc->sc_tv_func_stop, sc->sc_tv_func_start);
-}
 #else  /* CONFIG_DEBUG_FS */
 # define o2net_init_nst(a, b, c, d, e)
 # define o2net_set_nst_sock_time(a)
@@ -227,10 +223,14 @@ static ktime_t o2net_get_func_run_time(struct
o2net_sock_container *sc)
 # define o2net_set_advance_stop_time(a)
 # define o2net_set_func_start_time(a)
 # define o2net_set_func_stop_time(a)
-# define o2net_get_func_run_time(a)		(ktime_t)0
 #endif /* CONFIG_DEBUG_FS */

 #ifdef CONFIG_OCFS2_FS_STATS
+static ktime_t o2net_get_func_run_time(struct o2net_sock_container *sc)
+{
+	return ktime_sub(sc->sc_tv_func_stop, sc->sc_tv_func_start);
+}
+
 static void o2net_update_send_stats(struct o2net_send_tracking *nst,
 				    struct o2net_sock_container *sc)
 {
