Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09E23C04A68
	for <ocfs2-devel@archiver.kernel.org>; Sat, 30 Jul 2022 14:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=zu/SoZSLA3uL43vMdG5WMtoKFly6WYs60j5GqZ/h4z4=;
 b=G9vPptVoxFAVWwct8Oh5y7bCIli/z2wBF8Tm62Pf6Ke4JQEWajYE/u/7CId0DTzcn0sFIdq5D8m5
   vEl95BhkxNdoIq+9O853g8qfes7TsGyFRi57iCdKS3kOzWZQz8hRVHz9v+GFTn+xPTZJRHioJn/O
   KQOIK8f0aB7ygkXVOInk1mDgjc4XzMdtM/kxYyoFstlyBsln+rmor5myJCg88K35YOOmr5J5Cyiu
   JxJmFgHB7dxuKGq/wHQo7lwDVHU3Rxy2pZlKYJNcYZ6f5Bzc43UkolFQ3ym259pJiMANic9U8Y80
   frT/mptbNX5vMVyGQAlxGxIKq/0UvH2rZRtbcA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=zu/SoZSLA3uL43vMdG5WMtoKFly6WYs60j5GqZ/h4z4=;
 b=hz3N1NDkOy88hoSonq94Sk3fsEWQXlXMEiPQDtj8pD2G1shlVeS5SB/b/NWSJOFurs0LvqHRCGAY
   4LIr+DaN03GMkI/QpVpHe80/XPskmCWuHUxtXuATyYhLww5Kui/Msn44rxNeC/Kh+2gEaOCaVsIQ
   I3IUInozXibSYTjFTOPw2ABW43l9qx6h4De1KTRnMCxZ8FgVd0TZIFm6Umn6HT6obB9XJbYq4z63
   FemPPam3MLVb9n7Q14hHq3vYSwCnmobEifXfkZ+mCbewdlXD72mcnC8Z2eFm+nJeLC0i8BTFYBJ1
   NyNkrmfloKxsDYPu6LLzLzffagHG8ssqnQ4p4Q==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220621 64bit (built Jun 21
 2022))
 with ESMTPS id <0RFU00F5V9DU1P10@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 30 Jul 2022 14:53:54 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1659192822; bh=dKaUQe5uQ//jb7za/iC/n1UGFv+JZI8mb+BChmmD8X0=;
 h=Subject:To:Cc:From:Date:From;
 b=BKSSODLOoQsc95SOAYmPigCPCgL+QicQIQI6kku35MI2D2hZT6uvM5Pq8lJ2/DvXr
 w9aYu+UBKn5fF+wRQG7nypNev1c8EgQIgOz3PtSdGPaNpMGlB2DxCQNlTFAS2jbZhu
 2dsaKg7v4dHsZhvK4r7lZpF0Vxy7aI7qf8OAG2Us=
To: akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
 gregkh@linuxfoundation.org, heming.zhao@suse.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mark@fasheh.com,
 ocfs2-devel@oss.oracle.com, piaojun@huawei.com
Date: Sat, 30 Jul 2022 16:52:43 +0200
Message-id: <165919276321437@kroah.com>
MIME-version: 1.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10424
 signatures=596356
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=121
 priorityscore=273 adultscore=0 impostorscore=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207300074
Cc: stable-commits@vger.kernel.org
Subject: [Ocfs2-devel] Patch "Revert "ocfs2: mount shared volume without ha
	stack"" has been added to the 5.18-stable tree
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: gregkh--- via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: gregkh@linuxfoundation.org
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-stable: commit
X-Patchwork-Hint: ignore
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:72.55.140.81 ip4:52.25.139.140
 ip4:139.178.84.217 ip6:2604:1380:4641:c500::1 ip4:145.40.68.75
 ip6:2604:1380:4601:e00::1 ip4:145.40.73.55 ip6:2604:1380:40e1:4800::1
 include:_spf.google.com include:amazonses.com include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: rBzaFUijtRmh7FjGqSNxuVwkdv70Ztdg
X-Proofpoint-ORIG-GUID: rBzaFUijtRmh7FjGqSNxuVwkdv70Ztdg
Reporting-Meta:
 AAGZMKAu9LbfURXjPbo30vW98qOASC3yiSI87reF0ChUU/OkFAcQWGDMk/6Uizhk
 AhDL9kU+m0z5MVvtK92IwW0M5CGzwOJ/ouM3h2Df+zoO4XO14rtBMgiMSBmg1MG8
 ym06O8+Cd1IByy8WlanTet15IvQjMzZDQg6pJNIWPYC31k3h4ZSBVYuDEAMdagQY
 NnL2Imi06gPc5ghCCUateEe5zJ98xBFrp5EOxazlhGTgVTw8BJaNhogiKB5ze9cw
 N5xbR1XPJF6WaREjekhlQU9tK/B0R9BEWYimJGPrck98H8j16zgNGFp9/gqg40wA
 V02lijzwYb85/NdJgb6wrwfXGZIq7+CYWMCeL2mK9Geho43+SeAUv8Nv5YyL9yoy
 jlHKpoJfZmLl8JbEQYLqNjLjSJJr7fkBoZHWu25czcvmX9N4rKrHFS52Q+sfe+C2
 IJDH42kzuooiIA5UuMFom49CoKOEt95MHQb2DLpaBZYTzuJOuGrJFCDxiEMyfpkh
 lksMcB6PMQUGz5SC8C6EHiKQnl/a1oeVh74sWXU0ILKB


This is a note to let you know that I've just added the patch titled

    Revert "ocfs2: mount shared volume without ha stack"

to the 5.18-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     revert-ocfs2-mount-shared-volume-without-ha-stack.patch
and it can be found in the queue-5.18 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From c80af0c250c8f8a3c978aa5aafbe9c39b336b813 Mon Sep 17 00:00:00 2001
From: Junxiao Bi <ocfs2-devel@oss.oracle.com>
Date: Fri, 3 Jun 2022 15:28:01 -0700
Subject: Revert "ocfs2: mount shared volume without ha stack"

From: Junxiao Bi <ocfs2-devel@oss.oracle.com>

commit c80af0c250c8f8a3c978aa5aafbe9c39b336b813 upstream.

This reverts commit 912f655d78c5d4ad05eac287f23a435924df7144.

This commit introduced a regression that can cause mount hung.  The
changes in __ocfs2_find_empty_slot causes that any node with none-zero
node number can grab the slot that was already taken by node 0, so node 1
will access the same journal with node 0, when it try to grab journal
cluster lock, it will hung because it was already acquired by node 0.
It's very easy to reproduce this, in one cluster, mount node 0 first, then
node 1, you will see the following call trace from node 1.

[13148.735424] INFO: task mount.ocfs2:53045 blocked for more than 122 seconds.
[13148.739691]       Not tainted 5.15.0-2148.0.4.el8uek.mountracev2.x86_64 #2
[13148.742560] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[13148.745846] task:mount.ocfs2     state:D stack:    0 pid:53045 ppid: 53044 flags:0x00004000
[13148.749354] Call Trace:
[13148.750718]  <TASK>
[13148.752019]  ? usleep_range+0x90/0x89
[13148.753882]  __schedule+0x210/0x567
[13148.755684]  schedule+0x44/0xa8
[13148.757270]  schedule_timeout+0x106/0x13c
[13148.759273]  ? __prepare_to_swait+0x53/0x78
[13148.761218]  __wait_for_common+0xae/0x163
[13148.763144]  __ocfs2_cluster_lock.constprop.0+0x1d6/0x870 [ocfs2]
[13148.765780]  ? ocfs2_inode_lock_full_nested+0x18d/0x398 [ocfs2]
[13148.768312]  ocfs2_inode_lock_full_nested+0x18d/0x398 [ocfs2]
[13148.770968]  ocfs2_journal_init+0x91/0x340 [ocfs2]
[13148.773202]  ocfs2_check_volume+0x39/0x461 [ocfs2]
[13148.775401]  ? iput+0x69/0xba
[13148.777047]  ocfs2_mount_volume.isra.0.cold+0x40/0x1f5 [ocfs2]
[13148.779646]  ocfs2_fill_super+0x54b/0x853 [ocfs2]
[13148.781756]  mount_bdev+0x190/0x1b7
[13148.783443]  ? ocfs2_remount+0x440/0x440 [ocfs2]
[13148.785634]  legacy_get_tree+0x27/0x48
[13148.787466]  vfs_get_tree+0x25/0xd0
[13148.789270]  do_new_mount+0x18c/0x2d9
[13148.791046]  __x64_sys_mount+0x10e/0x142
[13148.792911]  do_syscall_64+0x3b/0x89
[13148.794667]  entry_SYSCALL_64_after_hwframe+0x170/0x0
[13148.797051] RIP: 0033:0x7f2309f6e26e
[13148.798784] RSP: 002b:00007ffdcee7d408 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
[13148.801974] RAX: ffffffffffffffda RBX: 00007ffdcee7d4a0 RCX: 00007f2309f6e26e
[13148.804815] RDX: 0000559aa762a8ae RSI: 0000559aa939d340 RDI: 0000559aa93a22b0
[13148.807719] RBP: 00007ffdcee7d5b0 R08: 0000559aa93a2290 R09: 00007f230a0b4820
[13148.810659] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffdcee7d420
[13148.813609] R13: 0000000000000000 R14: 0000559aa939f000 R15: 0000000000000000
[13148.816564]  </TASK>

To fix it, we can just fix __ocfs2_find_empty_slot.  But original commit
introduced the feature to mount ocfs2 locally even it is cluster based,
that is a very dangerous, it can easily cause serious data corruption,
there is no way to stop other nodes mounting the fs and corrupting it.
Setup ha or other cluster-aware stack is just the cost that we have to
take for avoiding corruption, otherwise we have to do it in kernel.

Link: https://lkml.kernel.org/r/20220603222801.42488-1-junxiao.bi@oracle.com
Fixes: 912f655d78c5("ocfs2: mount shared volume without ha stack")
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/ocfs2.h    |    4 +---
 fs/ocfs2/slot_map.c |   46 +++++++++++++++++++---------------------------
 fs/ocfs2/super.c    |   21 ---------------------
 3 files changed, 20 insertions(+), 51 deletions(-)

--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -277,7 +277,6 @@ enum ocfs2_mount_options
 	OCFS2_MOUNT_JOURNAL_ASYNC_COMMIT = 1 << 15,  /* Journal Async Commit */
 	OCFS2_MOUNT_ERRORS_CONT = 1 << 16, /* Return EIO to the calling process on error */
 	OCFS2_MOUNT_ERRORS_ROFS = 1 << 17, /* Change filesystem to read-only on error */
-	OCFS2_MOUNT_NOCLUSTER = 1 << 18, /* No cluster aware filesystem mount */
 };
 
 #define OCFS2_OSB_SOFT_RO	0x0001
@@ -673,8 +672,7 @@ static inline int ocfs2_cluster_o2cb_glo
 
 static inline int ocfs2_mount_local(struct ocfs2_super *osb)
 {
-	return ((osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_LOCAL_MOUNT)
-		|| (osb->s_mount_opt & OCFS2_MOUNT_NOCLUSTER));
+	return (osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_LOCAL_MOUNT);
 }
 
 static inline int ocfs2_uses_extended_slot_map(struct ocfs2_super *osb)
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -252,16 +252,14 @@ static int __ocfs2_find_empty_slot(struc
 	int i, ret = -ENOSPC;
 
 	if ((preferred >= 0) && (preferred < si->si_num_slots)) {
-		if (!si->si_slots[preferred].sl_valid ||
-		    !si->si_slots[preferred].sl_node_num) {
+		if (!si->si_slots[preferred].sl_valid) {
 			ret = preferred;
 			goto out;
 		}
 	}
 
 	for(i = 0; i < si->si_num_slots; i++) {
-		if (!si->si_slots[i].sl_valid ||
-		    !si->si_slots[i].sl_node_num) {
+		if (!si->si_slots[i].sl_valid) {
 			ret = i;
 			break;
 		}
@@ -456,30 +454,24 @@ int ocfs2_find_slot(struct ocfs2_super *
 	spin_lock(&osb->osb_lock);
 	ocfs2_update_slot_info(si);
 
-	if (ocfs2_mount_local(osb))
-		/* use slot 0 directly in local mode */
-		slot = 0;
-	else {
-		/* search for ourselves first and take the slot if it already
-		 * exists. Perhaps we need to mark this in a variable for our
-		 * own journal recovery? Possibly not, though we certainly
-		 * need to warn to the user */
-		slot = __ocfs2_node_num_to_slot(si, osb->node_num);
+	/* search for ourselves first and take the slot if it already
+	 * exists. Perhaps we need to mark this in a variable for our
+	 * own journal recovery? Possibly not, though we certainly
+	 * need to warn to the user */
+	slot = __ocfs2_node_num_to_slot(si, osb->node_num);
+	if (slot < 0) {
+		/* if no slot yet, then just take 1st available
+		 * one. */
+		slot = __ocfs2_find_empty_slot(si, osb->preferred_slot);
 		if (slot < 0) {
-			/* if no slot yet, then just take 1st available
-			 * one. */
-			slot = __ocfs2_find_empty_slot(si, osb->preferred_slot);
-			if (slot < 0) {
-				spin_unlock(&osb->osb_lock);
-				mlog(ML_ERROR, "no free slots available!\n");
-				status = -EINVAL;
-				goto bail;
-			}
-		} else
-			printk(KERN_INFO "ocfs2: Slot %d on device (%s) was "
-			       "already allocated to this node!\n",
-			       slot, osb->dev_str);
-	}
+			spin_unlock(&osb->osb_lock);
+			mlog(ML_ERROR, "no free slots available!\n");
+			status = -EINVAL;
+			goto bail;
+		}
+	} else
+		printk(KERN_INFO "ocfs2: Slot %d on device (%s) was already "
+		       "allocated to this node!\n", slot, osb->dev_str);
 
 	ocfs2_set_slot(si, slot, osb->node_num);
 	osb->slot_num = slot;
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -172,7 +172,6 @@ enum {
 	Opt_dir_resv_level,
 	Opt_journal_async_commit,
 	Opt_err_cont,
-	Opt_nocluster,
 	Opt_err,
 };
 
@@ -206,7 +205,6 @@ static const match_table_t tokens = {
 	{Opt_dir_resv_level, "dir_resv_level=%u"},
 	{Opt_journal_async_commit, "journal_async_commit"},
 	{Opt_err_cont, "errors=continue"},
-	{Opt_nocluster, "nocluster"},
 	{Opt_err, NULL}
 };
 
@@ -618,13 +616,6 @@ static int ocfs2_remount(struct super_bl
 		goto out;
 	}
 
-	tmp = OCFS2_MOUNT_NOCLUSTER;
-	if ((osb->s_mount_opt & tmp) != (parsed_options.mount_opt & tmp)) {
-		ret = -EINVAL;
-		mlog(ML_ERROR, "Cannot change nocluster option on remount\n");
-		goto out;
-	}
-
 	tmp = OCFS2_MOUNT_HB_LOCAL | OCFS2_MOUNT_HB_GLOBAL |
 		OCFS2_MOUNT_HB_NONE;
 	if ((osb->s_mount_opt & tmp) != (parsed_options.mount_opt & tmp)) {
@@ -865,7 +856,6 @@ static int ocfs2_verify_userspace_stack(
 	}
 
 	if (ocfs2_userspace_stack(osb) &&
-	    !(osb->s_mount_opt & OCFS2_MOUNT_NOCLUSTER) &&
 	    strncmp(osb->osb_cluster_stack, mopt->cluster_stack,
 		    OCFS2_STACK_LABEL_LEN)) {
 		mlog(ML_ERROR,
@@ -1144,11 +1134,6 @@ static int ocfs2_fill_super(struct super
 	       osb->s_mount_opt & OCFS2_MOUNT_DATA_WRITEBACK ? "writeback" :
 	       "ordered");
 
-	if ((osb->s_mount_opt & OCFS2_MOUNT_NOCLUSTER) &&
-	   !(osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_LOCAL_MOUNT))
-		printk(KERN_NOTICE "ocfs2: The shared device (%s) is mounted "
-		       "without cluster aware mode.\n", osb->dev_str);
-
 	atomic_set(&osb->vol_state, VOLUME_MOUNTED);
 	wake_up(&osb->osb_mount_event);
 
@@ -1455,9 +1440,6 @@ static int ocfs2_parse_options(struct su
 		case Opt_journal_async_commit:
 			mopt->mount_opt |= OCFS2_MOUNT_JOURNAL_ASYNC_COMMIT;
 			break;
-		case Opt_nocluster:
-			mopt->mount_opt |= OCFS2_MOUNT_NOCLUSTER;
-			break;
 		default:
 			mlog(ML_ERROR,
 			     "Unrecognized mount option \"%s\" "
@@ -1569,9 +1551,6 @@ static int ocfs2_show_options(struct seq
 	if (opts & OCFS2_MOUNT_JOURNAL_ASYNC_COMMIT)
 		seq_printf(s, ",journal_async_commit");
 
-	if (opts & OCFS2_MOUNT_NOCLUSTER)
-		seq_printf(s, ",nocluster");
-
 	return 0;
 }
 


Patches currently in stable-queue which might be from ocfs2-devel@oss.oracle.com are

queue-5.18/revert-ocfs2-mount-shared-volume-without-ha-stack.patch

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
