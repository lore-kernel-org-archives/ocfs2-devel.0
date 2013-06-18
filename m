From: Younger Liu <younger.liu@huawei.com>
Date: Tue, 18 Jun 2013 14:02:59 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Free sc->sc_page in sc_kref_release()
	v2
Message-ID: <51BFF813.80608@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

There is a memory leak in sc_kref_release().
When free struct o2net_sock_container (sc), 
we should release sc->sc_page.

Signed-off-by: Younger Liu <younger.liu@huawei.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/ocfs2/cluster/tcp.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index aa88bd8..bb9a48b 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -406,6 +406,9 @@ static void sc_kref_release(struct kref *kref)
 	sc->sc_node = NULL;
 
 	o2net_debug_del_sc(sc);
+
+	if (sc->sc_page)
+		__free_page(sc->sc_page);
 	kfree(sc);
 }
 
-- 
1.7.9.7
