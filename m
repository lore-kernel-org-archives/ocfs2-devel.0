From: Gechangwei <ge.changwei@h3c.com>
Date: Sat, 7 Jan 2017 12:01:06 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2/journal: fix umount hang after flushing
 journal failure
Message-ID: <63ADC13FD55D6546B7DECE290D39E37342E739A1@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

When journal flushing in ocfs2_commit_cache() fails, following umount procedure at stage of shutting journal may be blocked due to non-zero transactions number.

Once jbd2_journal_flush() fails, the journal will be marked as ABORT state inner JBD2. There is no way to come back afterwards.

So there is no chance to set transactions number to zero, thus, shutting journal may be blocked .


ocfs2_commit_thread()

    ocfs2_commit_cache()

        jbd2_journal_flush() -> failure takes journal into ABORT state, thus, transaction number will never set to zero


The back trace is cited blow:

[<ffffffff8109de0c>] kthread_stop+0x4c/0x150
[<ffffffffc056a887>] ocfs2_journal_shutdown+0xa7/0x400 [ocfs2]
[<ffffffffc059fbde>] ocfs2_dismount_volume+0xbe/0x4a0 [ocfs2]
[<ffffffffc059fff7>] ocfs2_put_super+0x37/0xb0 [ocfs2]
[<ffffffff8120534e>] generic_shutdown_super+0x7e/0x110
[<ffffffff81205410>] kill_block_super+0x30/0x80
[<ffffffff81205669>] deactivate_locked_super+0x59/0x90
[<ffffffff812062ee>] deactivate_super+0x4e/0x70
[<ffffffff81222423>] cleanup_mnt+0x43/0x90
[<ffffffff812224c2>] __cleanup_mnt+0x12/0x20
[<ffffffff8109c247>] task_work_run+0xb7/0xf0
[<ffffffff81016f7c>] do_notify_resume+0x8c/0xa0
[<ffffffff817f8384>] int_signal+0x12/0x17
[<ffffffffffffffff>] 0xffffffffffffffff

Through crash debug tool, It can seen that j_num_trans field is set to 2.

struct ocfs2_journal {
  j_state = OCFS2_JOURNAL_IN_SHUTDOWN,
  j_journal = 0xffff8800b4926000,
  j_inode = 0xffff880122aba298,
  j_osb = 0xffff880093caa000,
  j_bh = 0xffff8800a09df888,
  j_num_trans = {
    counter = 0x2
  },
  j_lock = {
    {
      rlock = {
        raw_lock = {
          {


To solve this issue, I propose a patch. Any comments will be welcomed.

Since journal has been marked as ABORT and flushing journal failure will free all corresponding buffer heads, it will be safe to directly set transactions number to zero.


From 98f42f5f52851ed84eb372a3e09a413a30ea2664 Mon Sep 17 00:00:00 2001
From: gechangwei <ge.changwei@h3c.com><mailto:ge.changwei@h3c.com>
Date: Sat, 7 Jan 2017 19:48:13 +0800
Subject: [PATCH] fix umount hang after flushing journal failure

Signed-off-by: gechangwei <ge.changwei@h3c.com><mailto:ge.changwei@h3c.com>
---
 fs/ocfs2/journal.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index a244f14..dab2094 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -326,6 +326,7 @@ static int ocfs2_commit_cache(struct ocfs2_super *osb)
     status = jbd2_journal_flush(journal->j_journal);
     jbd2_journal_unlock_updates(journal->j_journal);
     if (status < 0) {
+        atomic_set(&journal->j_num_trans, 0);
         up_write(&journal->j_trans_barrier);
         mlog_errno(status);
         goto finally;
--
2.5.1.windows.1



-------------------------------------------------------------------------------------------------------------------------------------
????????????????????????????????????????
????????????????????????????????????????
????????????????????????????????????????
???
This e-mail and its attachments contain confidential information from H3C, which is
intended only for the person or entity whose address is listed above. Any use of the
information contained herein in any way (including, but not limited to, total or partial
disclosure, reproduction, or dissemination) by persons other than the intended
recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
by phone or email immediately and delete it!
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20170107/9a6eeece/attachment.html 
