From: Zhang, Sonic <sonic.zhang@intel.com>
Date: Mon May 24 19:21:40 2004
Subject: [Ocfs2-devel] [Patch] Patch to fix OCFS bug 73 and 74.
Message-ID: <37FBBA5F3A361C41AB7CE44558C3448E03B65ED0@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

	After investigate in the JBD code in kernel 2.6.6 and OCFS2 svn
929 on IPF, I think I find the cause of dead lock bug 73 and 74.

	In kernel 2.6.6, the bit 12 to 19 of variable b_state in
structure buffer_head is occupied by the linux journaling code as
follows.

enum jbd_state_bits {
        BH_JBD                  /* Has an attached ext3 journal_head */
          = BH_PrivateStart,
        BH_JWrite,              /* Being written to log (@@@ DEBUGGING)
*/
        BH_Freed,               /* Has been freed (truncated) */
        BH_Revoked,             /* Has been revoked from the log */
        BH_RevokeValid,         /* Revoked flag is valid */
        BH_JBDDirty,            /* Is dirty but journaled */
        BH_State,               /* Pins most journal_head state */
        BH_JournalHead,         /* Pins bh->b_private and jh->b_bh */
};

	But, in ocfs2 head io.h, variable BH_Modified and the inode
clean sequence number also occupy some bits in this frame as follows.

#define BH_Modified 18
#define STATE_BIT_MASK		((~0UL)<<19)

	The bit 18 and bit 19 conflict with Linux journaling code in
kernel 2.6.6. When copy a file to the OCFS2 volume, the journaling code
will try to lock bit BH_JournalHead and BH_State of variable b_state in
buffer_head, which have already been set to 1 in OCFS2 routine
ocfs_read_dirnode() and ocfs_insert_dir_node(). So, the dead locks occur
at journaling routine jbd_lock_bh_journal_head() and
jbd_lock_bh_state().

	My patch fixes these 2 bugs by using the empty bits 20 ~ 31. It
is against svn 932. Please refer to the attachment.

	Any comment?


------------------------------------------------------------------------
-----------
--- ocfs2.old/src/inc/io.h	2004-05-24 19:16:00.000000000 -0700
+++ ocfs2/src/inc/io.h	2004-05-24 23:11:57.877670837 -0700
@@ -75,7 +75,7 @@
 
 #define OCFS_NONCACHED(osb,off)  ((off) <
(osb)->vol_layout.data_start_off)
 
-#define BH_Modified 18
+#define BH_Modified 20
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 /* 
@@ -214,10 +214,10 @@
 	ocfs_bh_sem_unlock(bh);
 }
 
-
+#define JBD_STATE_BIT_MAX	21
 #define STATE_BIT_MAX           (1 << 12)
 #define STATE_BIT_MAX_MASK      ((1 << 12)-1)
-#define STATE_BIT_MASK		((~0UL)<<19)
+#define STATE_BIT_MASK		((~0UL)<<JBD_STATE_BIT_MAX)
 
 
 static inline void CLEAR_BH_SEQNUM(struct buffer_head *bh)
@@ -229,7 +229,7 @@
 static inline void SET_BH_SEQNUM(struct inode *inode, struct
buffer_head *bh)
 {
 	unsigned int seq = (atomic_read(GET_INODE_CLEAN_SEQ(inode)) & 
-			    STATE_BIT_MAX_MASK) << 19;
+			    STATE_BIT_MAX_MASK) << JBD_STATE_BIT_MAX;
 
 	CLEAR_BH_SEQNUM(bh);
 	bh->b_state |= seq;
@@ -238,7 +238,7 @@
 static inline int TEST_BH_SEQNUM(struct inode *inode, struct
buffer_head *bh)
 {
 	int ret;
-	unsigned int seq = (bh->b_state & STATE_BIT_MASK) >> 19;
+	unsigned int seq = (bh->b_state & STATE_BIT_MASK) >>
JBD_STATE_BIT_MAX;
 
 	ret = (seq == atomic_read(GET_INODE_CLEAN_SEQ(inode)));
 	return ret;




*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
********************************************* 

-------------- next part --------------
A non-text attachment was scrubbed...
Name: ocfs2-jbd-statebit.patch
Type: application/octet-stream
Size: 1274 bytes
Desc: ocfs2-jbd-statebit.patch
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20040525/895dece7/ocfs2-jbd-statebit.obj
