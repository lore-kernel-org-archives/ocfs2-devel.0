From: Mark Fasheh <mfasheh@suse.de>
Date: Wed, 28 Jan 2015 14:12:07 -0800
Subject: [Ocfs2-devel] [PATCH 5/6] Auto setup o2cb stack as default if no
	stack is setup
In-Reply-To: <1422483128-32471-1-git-send-email-mfasheh@suse.de>
References: <1422483128-32471-1-git-send-email-mfasheh@suse.de>
Message-ID: <1422483128-32471-6-git-send-email-mfasheh@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Goldwyn Rodrigues <rgoldwyn@suse.de>

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 libo2cb/o2cb_abi.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/libo2cb/o2cb_abi.c b/libo2cb/o2cb_abi.c
index 4414ff2..fa1b1d2 100644
--- a/libo2cb/o2cb_abi.c
+++ b/libo2cb/o2cb_abi.c
@@ -177,7 +177,9 @@ static errcode_t determine_stack(void)
 	ssize_t len;
 	char line[100];
 	errcode_t err = O2CB_ET_SERVICE_UNAVAILABLE;
+	int setup_performed = 0;
 
+redo:
 	len = read_stack_file(line, sizeof(line));
 	if (len > 0) {
 		if (line[len - 1] == '\n') {
@@ -197,8 +199,11 @@ static errcode_t determine_stack(void)
 			err = 0;
 		}
 	} else if (len == -ENOENT) {
-		current_stack = &classic_stack;
-		err = 0;
+		if (!setup_performed) {
+			o2cb_setup_stack(OCFS2_CLASSIC_CLUSTER_STACK);
+			setup_performed = 1;
+			goto redo;
+		}
 	}
 
 	return err;
-- 
2.1.2
