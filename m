From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Mon, 27 Dec 2010 11:55:08 -0800
Subject: [Ocfs2-devel] [PATCH -next] ocfs2: fix build for OCFS2_FS_STATS not
	enabled
In-Reply-To: <20101227170451.a9a9f873.sfr@canb.auug.org.au>
References: <20101227170451.a9a9f873.sfr@canb.auug.org.au>
Message-ID: <20101227115508.8136331b.randy.dunlap@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Stephen Rothwell <sfr@canb.auug.org.au>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <joel.becker@oracle.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com

From: Randy Dunlap <randy.dunlap@oracle.com>

When CONFIG_OCFS2_FS_STATS is not enabled:

fs/ocfs2/cluster/tcp.c:1254: error: implicit declaration of function 'o2net_update_recv_stats'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Mark Fasheh <mfasheh@suse.com>
Cc:	Joel Becker <joel.becker@oracle.com>
Cc:	ocfs2-devel at oss.oracle.com
---
 fs/ocfs2/cluster/tcp.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-next-20101227.orig/fs/ocfs2/cluster/tcp.c
+++ linux-next-20101227/fs/ocfs2/cluster/tcp.c
@@ -257,6 +257,8 @@ static void o2net_update_recv_stats(stru
 
 # define o2net_update_send_stats(a, b)
 
+# define o2net_update_recv_stats(sc)
+
 #endif /* CONFIG_OCFS2_FS_STATS */
 
 static inline int o2net_reconnect_delay(void)
