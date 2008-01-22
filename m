From: Jan Engelhardt <jengelh@computergmbh.de>
Date: Tue, 22 Jan 2008 19:53:07 -0000
Subject: [Ocfs2-devel] [PATCH] [OCFS2]: constify function pointer tables
In-Reply-To: <54038cd4f87a03884e4f59f8f3697889dfb63c54.1201030614.git.jengelh@computergmbh.de>
References: <54038cd4f87a03884e4f59f8f3697889dfb63c54.1201030614.git.jengelh@computergmbh.de>
Message-ID: <Pine.LNX.4.64.0801222052070.5722@fbirervta.pbzchgretzou.qr>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 fs/ocfs2/dlmglue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 4e97dcc..ba27657 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2211,7 +2211,7 @@ static int ocfs2_dlm_seq_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static struct seq_operations ocfs2_dlm_seq_ops = {
+static const struct seq_operations ocfs2_dlm_seq_ops = {
 	.start =	ocfs2_dlm_seq_start,
 	.stop =		ocfs2_dlm_seq_stop,
 	.next =		ocfs2_dlm_seq_next,
-- 
1.5.3.4
