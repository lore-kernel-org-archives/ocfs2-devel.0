From: Deepa Dinamani <deepa.kernel@gmail.com>
Date: Wed,  8 Jun 2016 22:04:58 -0700
Subject: [Ocfs2-devel] [PATCH 14/21] fs: ocfs2: Replace CURRENT_TIME with
	ktime_get_real_seconds()
In-Reply-To: <1465448705-25055-1-git-send-email-deepa.kernel@gmail.com>
References: <1465448705-25055-1-git-send-email-deepa.kernel@gmail.com>
Message-ID: <1465448705-25055-15-git-send-email-deepa.kernel@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, y2038@lists.linaro.org, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com

CURRENT_TIME is not y2038 safe.

Use y2038 safe ktime_get_real_seconds() here for timestamps.

struct heartbeat_block's hb_seq is already 64 bits wide and
accommodates times beyond y2038.

Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel at oss.oracle.com
---
 fs/ocfs2/cluster/heartbeat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 6aaf3e3..d13c646 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -737,7 +737,7 @@ static inline void o2hb_prepare_block(struct o2hb_region *reg,
 	hb_block = (struct o2hb_disk_heartbeat_block *)slot->ds_raw_block;
 	memset(hb_block, 0, reg->hr_block_bytes);
 	/* TODO: time stuff */
-	cputime = CURRENT_TIME.tv_sec;
+	cputime = ktime_get_real_seconds();
 	if (!cputime)
 		cputime = 1;
 
-- 
1.9.1
