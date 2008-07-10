From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 10 Jul 2008 10:02:18 -0700
Subject: [Ocfs2-devel] EIP on ocfs2 flock / stack o2cb
In-Reply-To: <22efb4930807100723y7230cc84n85696367eee93e00@mail.gmail.com>
References: <22efb4930807100723y7230cc84n85696367eee93e00@mail.gmail.com>
Message-ID: <20080710170217.GN28100@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jul 10, 2008 at 09:23:07AM -0500, Geoffrey Pan wrote:
> 2.6.26-rc9 with dlm lock patch applied from 3 days ago..
> 
> Message from syslogd@ at Thu Jul 10 15:12:27 2008 ...
> cs3 kernel: ------------[ cut here ]------------
> Message from syslogd@ at Thu Jul 10 15:12:27 2008 ...
> cs3 kernel: invalid opcode: 0000 [#1] SMP
> Message from syslogd@ at Thu Jul 10 15:12:27 2008 ...
> cs3 kernel: Process easyapache (pid: 18310, ti=e3109000 task=f42d61b0 task.ti=
> e3109000)
> Message from syslogd@ at Thu Jul 10 15:12:27 2008 ...
> cs3 kernel: Stack: f8bb50c9 f8bb5da0 f45c4f00 e3109ee4 f8b6c0ff 00000400
> df416038 0000001f
> Message from syslogd@ at Thu Jul 10 15:12:27 2008 ...
> cs3 kernel:        df416014 df416038 df416014 f8bffded 00000400 df416038
> 0000001f df416014
> Message from syslogd@ at Thu Jul 10 15:12:27 2008 ...
> cs3 kernel:        00000000 00000000 f413f800 00000005 df41601c e30b2cb8
> 00000008 e30b2cb8
> Message from syslogd@ at Thu Jul 10 15:12:27 2008 ...
> cs3 kernel: Call Trace:
> Message from syslogd@ at Thu Jul 10 15:12:27 2008 ...
> cs3 kernel:  [<f8bb50c9>] o2cb_dlm_lock+0x1b/0x57 [ocfs2_stack_o2cb]
> Message from syslogd@ at Thu Jul 10 15:12:27 2008 ...
> cs3 kernel:  [<f8b6c0ff>] ocfs2_dlm_lock+0x2e/0x34 [ocfs2_stackglue]
> Message from syslogd@ at Thu Jul 10 15:12:27 2008 ...
> cs3 kernel:  [<f8bffded>] ocfs2_file_lock+0x2ba/0x523 [ocfs2]
> Message from syslogd@ at Thu Jul 10 15:12:27 2008 ...
> cs3 kernel:  [<c045ecc2>] do_wp_page+0x1b3/0x47f
> Message from syslogd@ at Thu Jul 10 15:12:27 2008 ...
> cs3 kernel:  [<c045ef35>] do_wp_page+0x426/0x47f
> Message from syslogd@ at Thu Jul 10 15:12:27 2008 ...
> cs3 kernel:  [<f8c10734>] ocfs2_flock+0x0/0x1d4 [ocfs2]
> Message from syslogd@ at Thu Jul 10 15:12:27 2008 ...
> cs3 kernel:  [<f8c10849>] ocfs2_flock+0x115/0x1d4 [ocfs2]
> Message from syslogd@ at Thu Jul 10 15:12:27 2008 ...
> cs3 kernel:  [<c044c41a>] audit_syscall_entry+0x102/0x12c
> Message from syslogd@ at Thu Jul 10 15:12:27 2008 ...
> cs3 kernel:  [<c044c6e5>] audit_syscall_exit+0x2a1/0x2bd
> Message from syslogd@ at Thu Jul 10 15:12:27 2008 ...
> cs3 kernel:  [<f8c10734>] ocfs2_flock+0x0/0x1d4 [ocfs2]
> Message from syslogd@ at Thu Jul 10 15:12:27 2008 ...
> cs3 kernel:  [<c0480a12>] sys_flock+0x10a/0x13d
> Message from syslogd@ at Thu Jul 10 15:12:27 2008 ...
> cs3 kernel:  [<c0403882>] syscall_call+0x7/0xb
> Message from syslogd@ at Thu Jul 10 15:12:27 2008 ...
> cs3 kernel:  =======================
> Message from syslogd@ at Thu Jul 10 15:12:27 2008 ...
> cs3 kernel: Code: 81 ca 00 00 80 00 a9 00 00 04 00 74 0b 25 ff ff fb ff 81 ca
> 00 00 02 00 a9 00 00 10 00 74 08 25 ff ff ef ff 80 ca 80 85 c0 74 04 <0f> 0b eb
> fe 89 d0 c3 57 83 fa 05 56 89 cf 53 89 d6 89 c3 7e 04
> Message from syslogd@ at Thu Jul 10 15:12:27 2008 ...
> cs3 kernel: EIP: [<f8bb50a7>] flags_to_o2dlm+0x77/0x7e [ocfs2_stack_o2cb]
> SS:ESP 0068:e3109e68  -- End dryrun test 'Check SSL' --
> 

Thanks for reporting this. Can you tell me soon if this patch fixes the
problem?
	--Mark

--
Mark Fasheh

From: Mark Fasheh <mfasheh@suse.com>

[PATCH] ocfs2: Fix flags in ocfs2_file_lock

The stack-glue merge changed the way we use flags in dlmglue in that we now
use the fs/dlm equivalents. Unfortunately, a merge error left the new flock
code only partially updated. This took a while to show up though, because
the lock level constants are actually identical between o2dlm and fs/dlm.
The *_CONVERT and *_NOQUEUE flags have different values though, which is
eventually causing a crash in flags_to_o2dlm().

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dlmglue.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 394d25a..80e20d9 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -1554,8 +1554,8 @@ out:
  */
 int ocfs2_file_lock(struct file *file, int ex, int trylock)
 {
-	int ret, level = ex ? LKM_EXMODE : LKM_PRMODE;
-	unsigned int lkm_flags = trylock ? LKM_NOQUEUE : 0;
+	int ret, level = ex ? DLM_LOCK_EX : DLM_LOCK_PR;
+	unsigned int lkm_flags = trylock ? DLM_LKF_NOQUEUE : 0;
 	unsigned long flags;
 	struct ocfs2_file_private *fp = file->private_data;
 	struct ocfs2_lock_res *lockres = &fp->fp_flock;
@@ -1582,7 +1582,7 @@ int ocfs2_file_lock(struct file *file, int ex, int trylock)
 		 * Get the lock at NLMODE to start - that way we
 		 * can cancel the upconvert request if need be.
 		 */
-		ret = ocfs2_lock_create(osb, lockres, LKM_NLMODE, 0);
+		ret = ocfs2_lock_create(osb, lockres, DLM_LOCK_NL, 0);
 		if (ret < 0) {
 			mlog_errno(ret);
 			goto out;
@@ -1597,7 +1597,7 @@ int ocfs2_file_lock(struct file *file, int ex, int trylock)
 	}
 
 	lockres->l_action = OCFS2_AST_CONVERT;
-	lkm_flags |= LKM_CONVERT;
+	lkm_flags |= DLM_LKF_CONVERT;
 	lockres->l_requested = level;
 	lockres_or_flags(lockres, OCFS2_LOCK_BUSY);
 
@@ -1664,7 +1664,7 @@ void ocfs2_file_unlock(struct file *file)
 	if (!(lockres->l_flags & OCFS2_LOCK_ATTACHED))
 		return;
 
-	if (lockres->l_level == LKM_NLMODE)
+	if (lockres->l_level == DLM_LOCK_NL)
 		return;
 
 	mlog(0, "Unlock: \"%s\" flags: 0x%lx, level: %d, act: %d\n",
@@ -1678,11 +1678,11 @@ void ocfs2_file_unlock(struct file *file)
 	lockres_or_flags(lockres, OCFS2_LOCK_BLOCKED);
 	lockres->l_blocking = DLM_LOCK_EX;
 
-	gen = ocfs2_prepare_downconvert(lockres, LKM_NLMODE);
+	gen = ocfs2_prepare_downconvert(lockres, DLM_LOCK_NL);
 	lockres_add_mask_waiter(lockres, &mw, OCFS2_LOCK_BUSY, 0);
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
 
-	ret = ocfs2_downconvert_lock(osb, lockres, LKM_NLMODE, 0, gen);
+	ret = ocfs2_downconvert_lock(osb, lockres, DLM_LOCK_NL, 0, gen);
 	if (ret) {
 		mlog_errno(ret);
 		return;
-- 
1.5.4.1
