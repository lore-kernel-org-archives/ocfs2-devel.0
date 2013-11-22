From: Wei Yongjun <weiyj.lk@gmail.com>
Date: Fri, 22 Nov 2013 02:43:28 -0000
Subject: [Ocfs2-devel] [PATCH -next] ocfs2: fix sparse non static symbol
	warning
Message-ID: <CAPgLHd9uPqx0fY7DQp2gWESb-yUZraWh7tpdMW6ao2Bq=DwYCA@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@suse.com, jlbec@evilplan.org
Cc: yongjun_wei@trendmicro.com.cn, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fixes the following sparse warning:

fs/ocfs2/stack_user.c:930:32: warning:
 symbol 'ocfs2_ls_ops' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/ocfs2/stack_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index eca3f93..9b18f4e 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -927,7 +927,7 @@ static void user_recover_done(void *arg, struct dlm_slot *slots,
 	wake_up(&lc->oc_wait);
 }
 
-const struct dlm_lockspace_ops ocfs2_ls_ops = {
+static const struct dlm_lockspace_ops ocfs2_ls_ops = {
 	.recover_prep = user_recover_prep,
 	.recover_slot = user_recover_slot,
 	.recover_done = user_recover_done,
