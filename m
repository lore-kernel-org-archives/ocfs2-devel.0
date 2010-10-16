From: Andrea Gelmini <andrea.gelmini@gelma.net>
Date: Sat, 16 Oct 2010 13:19:37 -0000
Subject: [Ocfs2-devel] [PATCH 02/16] ocfs2: fixed typo
In-Reply-To: <1287235165-27841-1-git-send-email-andrea.gelmini@gelma.net>
References: <1287235165-27841-1-git-send-email-andrea.gelmini@gelma.net>
Message-ID: <1287235165-27841-2-git-send-email-andrea.gelmini@gelma.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

"vaild"

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 fs/ocfs2/cluster/tcp_internal.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp_internal.h b/fs/ocfs2/cluster/tcp_internal.h
index 96fa7eb..15fdbdf 100644
--- a/fs/ocfs2/cluster/tcp_internal.h
+++ b/fs/ocfs2/cluster/tcp_internal.h
@@ -129,7 +129,7 @@ struct o2net_node {
 
 struct o2net_sock_container {
 	struct kref		sc_kref;
-	/* the next two are vaild for the life time of the sc */
+	/* the next two are valid for the life time of the sc */
 	struct socket		*sc_sock;
 	struct o2nm_node	*sc_node;
 
-- 
1.7.3.1.181.g784b8
