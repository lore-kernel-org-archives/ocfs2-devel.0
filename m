From: David Sterba <dsterba@suse.cz>
Date: Tue, 02 Nov 2010 22:36:07 -0000
Subject: [Ocfs2-devel] fs/ocfs2/dlm: Use GFP_ATOMIC under spin_lock
Message-ID: <20101102223601.GA27513@ds.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org, mfasheh@suse.com, joel.becker@oracle.com

coccinelle check scripts/coccinelle/locks/call_kern.cocci found that
in fs/ocfs2/dlm/dlmdomain.c an allocation with GFP_KERNEL is done
with locks held:

dlm_query_region_handler
  spin_lock(dlm_domain_lock)
    dlm_match_regions
      kmalloc(GFP_KERNEL)

Change it to GFP_ATOMIC.

Signed-off-by: David Sterba <dsterba@suse.cz>
CC: Joel Becker <joel.becker@oracle.com>
CC: Mark Fasheh <mfasheh@suse.com>
CC: ocfs2-devel at oss.oracle.com

--
Exists in v2.6.37-rc1 and current linux-next.

diff -u -p a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
--- a/fs/ocfs2/dlm/dlmdomain.c 2010-10-22 10:23:23.502434402 +0200
+++ b/fs/ocfs2/dlm/dlmdomain.c 2010-11-02 17:11:06.000000000 +0100
@@ -959,7 +959,7 @@ static int dlm_match_regions(struct dlm_
                r += O2HB_MAX_REGION_NAME_LEN;
        }

-       local = kmalloc(sizeof(qr->qr_regions), GFP_KERNEL);
+       local = kmalloc(sizeof(qr->qr_regions), GFP_ATOMIC);
        if (!local) {
                status = -ENOMEM;
                goto bail;
