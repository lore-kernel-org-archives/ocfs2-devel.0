From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Jan 17 14:37:02 2008
Subject: [Ocfs2-devel] [PATCH 01/30] ocfs2_dlm: Call node eviction callbacks
	from heartbeat handler
In-Reply-To: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
Message-ID: <1200609356-17788-2-git-send-email-mark.fasheh@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Mark Fasheh <mark.fasheh@oracle.com>

With this, a dlm client can take advantage of the group protocol in the dlm
to get full notification whenever a node within the dlm domain leaves
unexpectedly.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/dlm/dlmrecovery.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 2fde7bf..b10f3e3 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -2321,6 +2321,13 @@ void dlm_hb_node_down_cb(struct o2nm_node *node, int idx, void *data)
 	if (!dlm_grab(dlm))
 		return;
 
+	/*
+	 * This will notify any dlm users that a node in our domain
+	 * went away without notifying us first.
+	 */
+	if (test_bit(idx, dlm->domain_map))
+		dlm_fire_domain_eviction_callbacks(dlm, idx);
+
 	spin_lock(&dlm->spinlock);
 	__dlm_hb_node_down(dlm, idx);
 	spin_unlock(&dlm->spinlock);
-- 
1.5.3.6
