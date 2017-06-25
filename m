From: piaojun <piaojun@huawei.com>
Date: Sun, 25 Jun 2017 20:46:28 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: free 'dummy_sc' in sc_fop_release() in
 case of memory leak
Message-ID: <594FB0A4.2050105@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@versity.com, jlbec@evilplan.org
Cc: linux-kernel@vger.kernel.org, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>

'sd->dbg_sock' is malloc in sc_common_open(), but not freed at the end
of sc_fop_release().

Signed-off-by: Jun Piao <piaojun@huawei.com>
---
 fs/ocfs2/cluster/netdebug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ocfs2/cluster/netdebug.c b/fs/ocfs2/cluster/netdebug.c
index 564c504..74a21f6 100644
--- a/fs/ocfs2/cluster/netdebug.c
+++ b/fs/ocfs2/cluster/netdebug.c
@@ -426,6 +426,7 @@ static int sc_fop_release(struct inode *inode, struct file *file)
 	struct o2net_sock_container *dummy_sc = sd->dbg_sock;

 	o2net_debug_del_sc(dummy_sc);
+	kfree(dummy_sc);
 	return seq_release_private(inode, file);
 }

-- 
