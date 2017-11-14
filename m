From: Changwei Ge <ge.changwei@h3c.com>
Date: Tue, 14 Nov 2017 06:53:03 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: get mle inuse only when it is
	initialized
Message-ID: <63ADC13FD55D6546B7DECE290D39E373CED7A8BE@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When dlm_add_migration_mle returns -EEXIST, previously input mle will
not be initialized. So we can't use its associated dlm object.
And we truly don't need this mle for already launched migration
progress, since oldmle has taken this role.

Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
---
  fs/ocfs2/dlm/dlmmaster.c | 4 +++-
  1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 3e04279446e8..9c3e0f13ca87 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -2616,7 +2616,9 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
          * otherwise the assert_master from the new
          * master will destroy this.
          */
-       dlm_get_mle_inuse(mle);
+       if (ret != -EEXIST)
+               dlm_get_mle_inuse(mle);
+
         spin_unlock(&dlm->master_lock);
         spin_unlock(&dlm->spinlock);

--
2.11.0
