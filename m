From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Mon Aug 23 03:05:59 2004
Subject: [Ocfs2-devel] [PATCH] fix big 116 -- umount cause crash after some
	operation
Message-ID: <3ACA40606221794F80A5670F0AF15F840542F8CE@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

before umount, all the lock shall be released first.
this patch can resolve the problem

------------------------------------------------
Index: super.c
===================================================================
--- super.c (revision 1370)
+++ super.c (working copy)
@@ -224,6 +224,7 @@
    tid_t target;

    sb->s_dirt = 0;
+   ocfs_commit_cache(OCFS2_SB(sb));
    target = log_start_commit(OCFS2_SB(sb)->journal->k_journal, NULL);
    log_wait_commit(OCFS2_SB(sb)->journal->k_journal, target);
    return 0;
@@ -234,6 +235,7 @@
    tid_t target;

    sb->s_dirt = 0;
+   ocfs_commit_cache(OCFS2_SB(sb));
    if (journal_start_commit(OCFS2_SB(sb)->journal->k_journal, &target))
{
        if (wait)
            log_wait_commit(OCFS2_SB(sb)->journal->k_journal,
Index: journal.c
===================================================================
--- journal.c   (revision 1370)
+++ journal.c   (working copy)
@@ -61,7 +61,7 @@
                   struct inode *inode);
 static int ocfs_recover_node(struct _ocfs_super *osb, int node_num);
 static int __ocfs_recovery_thread(void *arg);
-static int ocfs_commit_cache (ocfs_super * osb);
+int ocfs_commit_cache (ocfs_super * osb);
 static int ocfs_wait_on_mount(ocfs_super *osb);
 static void ocfs_handle_move_locks(ocfs_journal *journal,
                   ocfs_journal_handle *handle);
@@ -149,7 +149,7 @@
  * This is in journal.c for lack of a better place.
  *
  */
-static int ocfs_commit_cache(ocfs_super *osb)
+int ocfs_commit_cache(ocfs_super *osb)
 {
    int status = 0, tmpstat;
    ocfs_journal * journal = NULL;


-------------------
Ling Xiaofeng(Daniel)

Intel China Software Lab.
iNet: 8-752-1243
8621-52574545-1243(O)

xfling@users.sourceforge.net
Opinions are my own and don't represent those of my employer 
