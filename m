From: trix at redhat.com <trix@redhat.com>
Date: Mon, 19 Oct 2020 10:52:16 -0700
Subject: [Ocfs2-devel] [PATCH] fs: ocfs2 remove unneeded break
Message-ID: <20201019175216.2329-1-trix@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, davem@davemloft.net, akpm@linux-foundation.org, willy@infradead.org, alex.shi@linux.alibaba.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>

From: Tom Rix <trix@redhat.com>

A break is not needed if it is preceded by a goto

Signed-off-by: Tom Rix <trix@redhat.com>
---
 fs/ocfs2/cluster/tcp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 79a231719460..3bd8119bed5e 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -1198,7 +1198,6 @@ static int o2net_process_message(struct o2net_sock_container *sc,
 			msglog(hdr, "bad magic\n");
 			ret = -EINVAL;
 			goto out;
-			break;
 	}
 
 	/* find a handler for it */
-- 
2.18.1
