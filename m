From: Alexander Beregalov <a.beregalov@gmail.com>
Date: Tue, 05 Aug 2008 20:12:20 -0000
Subject: [Ocfs2-devel] [PATCH] ocfs2/cluster/netdebug.c: fix warning
Message-ID: <20080805201036.GC17320@orion>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@suse.com, joel.becker@oracle.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

From: Alexander Beregalov <a.beregalov@gmail.com>

ocfs2/cluster/netdebug.c: fix warning

fs/ocfs2/cluster/netdebug.c:154: warning: format '%lu' expects
	type 'long unsigned int', but argument 17 has type 'suseconds_t'


Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 fs/ocfs2/cluster/netdebug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/cluster/netdebug.c b/fs/ocfs2/cluster/netdebug.c
index d8bfa0e..cdc0ed2 100644
--- a/fs/ocfs2/cluster/netdebug.c
+++ b/fs/ocfs2/cluster/netdebug.c
@@ -151,7 +151,7 @@ static int nst_seq_show(struct seq_file *seq, void *v)
 			   nst->st_send_time.tv_sec,
 			   (unsigned long)nst->st_send_time.tv_usec,
 			   nst->st_status_time.tv_sec,
-			   nst->st_status_time.tv_usec);
+			   (unsigned long)nst->st_status_time.tv_usec);
 	}
 
 	spin_unlock(&o2net_debug_lock);
