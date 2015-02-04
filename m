From: Fabian Frederick <fabf@skynet.be>
Date: Wed,  4 Feb 2015 19:11:16 +0100
Subject: [Ocfs2-devel] [PATCH 1/1 linux-next] ocfs2: make resv_lock spinlock
	static
Message-ID: <1423073476-14697-1-git-send-email-fabf@skynet.be>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

resv_lock is only used in reservations.c

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ocfs2/reservations.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/reservations.c b/fs/ocfs2/reservations.c
index 41ffd36..6a348b0 100644
--- a/fs/ocfs2/reservations.c
+++ b/fs/ocfs2/reservations.c
@@ -39,7 +39,7 @@
 #define OCFS2_CHECK_RESERVATIONS
 #endif
 
-DEFINE_SPINLOCK(resv_lock);
+static DEFINE_SPINLOCK(resv_lock);
 
 #define	OCFS2_MIN_RESV_WINDOW_BITS	8
 #define	OCFS2_MAX_RESV_WINDOW_BITS	1024
-- 
1.9.3
