From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu,  7 Oct 2010 17:15:36 -0700
Subject: [Ocfs2-devel] [PATCH 22/22] ocfs2/dlm: Bump up dlm protocol to
	version 1.1
In-Reply-To: <1286496936-17072-1-git-send-email-sunil.mushran@oracle.com>
References: <1286496936-17072-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1286496936-17072-23-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

dlm protocol 1.1. activates messages DLM_QUERY_REGION and DLM_QUERY_NODEINFO
that are a must for global heartbeat.

It also activates o2hb_global_heartbeat_active().

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c |    2 +-
 fs/ocfs2/dlm/dlmdomain.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 29aee21..6a1280a 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -2429,6 +2429,6 @@ EXPORT_SYMBOL_GPL(o2hb_get_all_regions);
 
 int o2hb_global_heartbeat_active(void)
 {
-	return 0;
+	return (o2hb_heartbeat_mode == O2HB_HEARTBEAT_GLOBAL);
 }
 EXPORT_SYMBOL(o2hb_global_heartbeat_active);
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 78d428f..58a93b9 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -135,7 +135,7 @@ static DECLARE_WAIT_QUEUE_HEAD(dlm_domain_events);
  */
 static const struct dlm_protocol_version dlm_protocol = {
 	.pv_major = 1,
-	.pv_minor = 0,
+	.pv_minor = 1,
 };
 
 #define DLM_DOMAIN_BACKOFF_MS 200
-- 
1.7.0.4
