From: Mark Fasheh <mfasheh@suse.de>
Date: Wed, 28 Jan 2015 14:12:06 -0800
Subject: [Ocfs2-devel] [PATCH 4/6] mkfs: Setup cluster_stack if not setup
	based on args
In-Reply-To: <1422483128-32471-1-git-send-email-mfasheh@suse.de>
References: <1422483128-32471-1-git-send-email-mfasheh@suse.de>
Message-ID: <1422483128-32471-5-git-send-email-mfasheh@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Goldwyn Rodrigues <rgoldwyn@suse.de>

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 mkfs.ocfs2/check.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mkfs.ocfs2/check.c b/mkfs.ocfs2/check.c
index f05dc72..79583bf 100644
--- a/mkfs.ocfs2/check.c
+++ b/mkfs.ocfs2/check.c
@@ -339,6 +339,15 @@ int ocfs2_check_volume(State *s)
 		goto nolock;
 
 	if (!s->force) {
+		if (s->cluster_stack) {
+			ret = o2cb_setup_stack(s->cluster_stack);
+			if (ret) {
+				com_err(s->progname, ret,
+					"while setting up stack\n");
+				return -1;
+			}
+		}
+
 		ret = o2cb_init();
 		if (ret) {
 			com_err(s->progname, ret,
-- 
2.1.2
