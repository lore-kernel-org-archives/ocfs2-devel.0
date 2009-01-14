From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 13 Jan 2009 17:47:19 -0800
Subject: [Ocfs2-devel] [PATCH 14/15] trivial: fix then -> than typos in
	comments and documentation
In-Reply-To: <1231897640-31410-1-git-send-email-sunil.mushran@oracle.com>
References: <1231897640-31410-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1231897640-31410-15-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Frederik Schwarzer <schwarzerf@gmail.com>

Mainline commit 025dfdafe77f20b3890981a394774baab7b9c827

- (better, more, bigger ...) then -> (...) than

Signed-off-by: Frederik Schwarzer <schwarzerf@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 fs/ocfs2/cluster/heartbeat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 999e7e5..3e52fa3 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -862,7 +862,7 @@ static int o2hb_thread(void *data)
 
 	while (!kthread_should_stop() && !reg->hr_unclean_stop) {
 		/* We track the time spent inside
-		 * o2hb_do_disk_heartbeat so that we avoid more then
+		 * o2hb_do_disk_heartbeat so that we avoid more than
 		 * hr_timeout_ms between disk writes. On busy systems
 		 * this should result in a heartbeat which is less
 		 * likely to time itself out. */
-- 
1.5.6.3
