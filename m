From: Joe Perches <joe@perches.com>
Date: Tue,  5 Jan 2010 17:20:19 -0800
Subject: [Ocfs2-devel] [PATCH 7/8] fs/ocfs2/cluster/tcp.c: Remove use of
	NIPQUAD, use %pI4
In-Reply-To: <cover.1262726222.git.joe@perches.com>
References: <cover.1262726222.git.joe@perches.com>
Message-ID: <ec11c9ed70064e4f1137da23e51171a3620943f6.1262726222.git.joe@perches.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mfasheh@suse.com>, Joel Becker <joel.becker@oracle.com>, ocfs2-devel@oss.oracle.com

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ocfs2/cluster/tcp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 334f231..7a9620e 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -72,9 +72,9 @@
 
 #include "tcp_internal.h"
 
-#define SC_NODEF_FMT "node %s (num %u) at %u.%u.%u.%u:%u"
+#define SC_NODEF_FMT "node %s (num %u) at %pI4:%u"
 #define SC_NODEF_ARGS(sc) sc->sc_node->nd_name, sc->sc_node->nd_num,	\
-			  NIPQUAD(sc->sc_node->nd_ipv4_address),	\
+			  &sc->sc_node->nd_ipv4_address,		\
 			  ntohs(sc->sc_node->nd_ipv4_port)
 
 /*
-- 
1.6.6.rc0.57.gad7a
