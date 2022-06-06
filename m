Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B642C43334
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Jun 2022 12:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Rnc9uFePcF6+sAttn6mjjPkxpTvaje8opGGOxXUnTws=;
 b=kY3lAliLM2j4dEZZXxvi9iLn7Bc8noc6n1tpfhTnI6hNE4BEv+WSiAVJXH4P9bDGui2rpVwp01hT
   RgMPClx7/FCXToAqLRIw9EKz0dnVpcruIOOarNA81qhpghPM53dz7JrJ49to288PSuty8izHGivZ
   375YRAoTP1566s2AUsAHZV1Xl8EhCCDZh4x+3SMKdV6GDKeyVFyRtkERbdJy66VS5usXRIcfYcBt
   mTe31dxKEjA9YjR51T+Fxsamom6SwVZFs2yyQtolKB1gO273PczCu3CWEAsSxxGhxvauAs50YIcP
   BpoqAFpaO/Il6XJhR+gMYBStFhZXi/8NmQV97Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Rnc9uFePcF6+sAttn6mjjPkxpTvaje8opGGOxXUnTws=;
 b=dxapcXzzX3v1Uu9qe00XpntMI1h0EiK582fhyGfNVVRD61TsiuUE3u1NDNVaLZGHOgboTCAbQsAX
   PSpulAhKMDO0RDJXzRseTK+785SmX6umrJd1SDbMCl5YgDGTlkhYuA4pLEyfIFUlCoXeAhCZWY5N
   VG8307Ybqxu8JIomfyfbjKjhzJwPOCk/IxFUh49YACdYYdGK3A9Sgi9/oCapp/AN7b53UgXREDg0
   JdF8mfpC+ockdOcXH3biBk1dioiLiA24b+/HdNh41Ph9tQ7g+Fpu0Z4jcPBGtPR0CvWnIAgX1QgS
   S7z8PVTET1CEcTuxlzqKbTNf4/pAMF734rQPhw==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD200J1U36BOK50@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 06 Jun 2022 12:39:47 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1654519173; bh=XOkT1c9ZInliMoOdneRpWL0z23tAAD0FhxQU6hBwjGc=;
 h=Subject:To:Cc:From:Date:From;
 b=mhJ79Oas9Mjh/fT1ALF+vN+ix8QIObITn6OhZ5PJeJiWGQ3JRuLOaYtTzKx/RJFXd
 qcno8zoCVEA1+2XYFKuEWSKL7Y2gVOJlI352sybpbI2fexYX5W/uL1Ee+HQU7AHhrn
 XpZIVMEGNmhZ5k1Rabp+sqhQdiI63G2I2nEs54fE=
To: akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
 gregkh@linuxfoundation.org, jiangqi903@gmail.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mark@fasheh.com,
 ocfs2-devel@oss.oracle.com, piaojun@huawei.com
Date: Mon, 06 Jun 2022 14:37:56 +0200
Message-id: <16545190760108@kroah.com>
MIME-version: 1.0
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10369
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=136 clxscore=172 lowpriorityscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 impostorscore=0 spamscore=0 malwarescore=0 suspectscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206060058
Cc: stable-commits@vger.kernel.org
Subject: [Ocfs2-devel] Patch
 "ocfs2: dlmfs: fix error handling of	user_dlm_destroy_lock" has been added to
 the 5.15-stable tree
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
X-ServerName: ams.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:72.55.140.81 ip4:52.25.139.140
 ip4:139.178.84.217 ip6:2604:1380:4641:c500::1 ip4:145.40.68.75
 ip6:2604:1380:4601:e00::1 ip4:145.40.73.55 ip6:2604:1380:40e1:4800::1
 include:_spf.google.com include:amazonses.com include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: u9QlzbihbeXmPWiRRHsj2UHpeq74QHUO
X-Proofpoint-ORIG-GUID: u9QlzbihbeXmPWiRRHsj2UHpeq74QHUO
Reporting-Meta:
 AAGqYACzfH7jc42AfX8Qv93D4h6TvXBpbADILuhHnYLtwhFs2MGYOpCXV7FCyAc+
 OR15CPBi4xsDwcN7QhdskLQBwLRddAvyfjVsfGrJWJetTkLs0LZTkTiPFQa/+0H/
 g+wc3B3K7sx9WCTMeaKTJgPwEKw1RGxGKZ+0Tx4xhaVkzEdm7SmLChGUPmhCJENT
 BMF5xPsVojVuLfOCFZe3Sscj1RnLBq27l75f+9At1Gp3iUUYBTn3xu0b2S56ESq0
 9mxxTonWy4K0DTcNF/EM8pKHDmVAeQWkQQTJGrODO+cixcVdRTfBJwK7z9El53Mb
 BBQFH0FKjkqSe4t9uww6YANIU/pT4n1og1VQiOyjHROY3gfVw8gulLbhwIojxx7y
 11+cWnS/3z7f3zc5/afQcuaDmLnfHUdGtzFCaLVaW5PC+I59aO07vGU/JhPfmSEv
 CdQVpWVVadcNL95cPNG5dBz4Wrf4/6ltrmp5T+/9mExVNDBBW3AtMcdruRtJUh3k
 JaggK4RELtK7LnUcssG+PIm9d41iEITdDZy21VJqSxlw


This is a note to let you know that I've just added the patch titled

    ocfs2: dlmfs: fix error handling of user_dlm_destroy_lock

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ocfs2-dlmfs-fix-error-handling-of-user_dlm_destroy_lock.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From 863e0d81b6683c4cbc588ad831f560c90e494bef Mon Sep 17 00:00:00 2001
From: Junxiao Bi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Date: Wed, 18 May 2022 16:52:24 -0700
Subject: ocfs2: dlmfs: fix error handling of user_dlm_destroy_lock

From: Junxiao Bi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>

commit 863e0d81b6683c4cbc588ad831f560c90e494bef upstream.

When user_dlm_destroy_lock failed, it didn't clean up the flags it set
before exit.  For USER_LOCK_IN_TEARDOWN, if this function fails because of
lock is still in used, next time when unlink invokes this function, it
will return succeed, and then unlink will remove inode and dentry if lock
is not in used(file closed), but the dlm lock is still linked in dlm lock
resource, then when bast come in, it will trigger a panic due to
user-after-free.  See the following panic call trace.  To fix this,
USER_LOCK_IN_TEARDOWN should be reverted if fail.  And also error should
be returned if USER_LOCK_IN_TEARDOWN is set to let user know that unlink
fail.

For the case of ocfs2_dlm_unlock failure, besides USER_LOCK_IN_TEARDOWN,
USER_LOCK_BUSY is also required to be cleared.  Even though spin lock is
released in between, but USER_LOCK_IN_TEARDOWN is still set, for
USER_LOCK_BUSY, if before every place that waits on this flag,
USER_LOCK_IN_TEARDOWN is checked to bail out, that will make sure no flow
waits on the busy flag set by user_dlm_destroy_lock(), then we can
simplely revert USER_LOCK_BUSY when ocfs2_dlm_unlock fails.  Fix
user_dlm_cluster_lock() which is the only function not following this.

[  941.336392] (python,26174,16):dlmfs_unlink:562 ERROR: unlink
004fb0000060000b5a90b8c847b72e1, error -16 from destroy
[  989.757536] ------------[ cut here ]------------
[  989.757709] kernel BUG at fs/ocfs2/dlmfs/userdlm.c:173!
[  989.757876] invalid opcode: 0000 [#1] SMP
[  989.758027] Modules linked in: ksplice_2zhuk2jr_ib_ipoib_new(O)
ksplice_2zhuk2jr(O) mptctl mptbase xen_netback xen_blkback xen_gntalloc
xen_gntdev xen_evtchn cdc_ether usbnet mii ocfs2 jbd2 rpcsec_gss_krb5
auth_rpcgss nfsv4 nfsv3 nfs_acl nfs fscache lockd grace ocfs2_dlmfs
ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager ocfs2_stackglue configfs bnx2fc
fcoe libfcoe libfc scsi_transport_fc sunrpc ipmi_devintf bridge stp llc
rds_rdma rds bonding ib_sdp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad
rdma_cm ib_cm iw_cm falcon_lsm_serviceable(PE) falcon_nf_netcontain(PE)
mlx4_vnic falcon_kal(E) falcon_lsm_pinned_13402(E) mlx4_ib ib_sa ib_mad
ib_core ib_addr xenfs xen_privcmd dm_multipath iTCO_wdt iTCO_vendor_support
pcspkr sb_edac edac_core i2c_i801 lpc_ich mfd_core ipmi_ssif i2c_core ipmi_si
ipmi_msghandler
[  989.760686]  ioatdma sg ext3 jbd mbcache sd_mod ahci libahci ixgbe dca ptp
pps_core vxlan udp_tunnel ip6_udp_tunnel megaraid_sas mlx4_core crc32c_intel
be2iscsi bnx2i cnic uio cxgb4i cxgb4 cxgb3i libcxgbi ipv6 cxgb3 mdio
libiscsi_tcp qla4xxx iscsi_boot_sysfs libiscsi scsi_transport_iscsi wmi
dm_mirror dm_region_hash dm_log dm_mod [last unloaded:
ksplice_2zhuk2jr_ib_ipoib_old]
[  989.761987] CPU: 10 PID: 19102 Comm: dlm_thread Tainted: P           OE
4.1.12-124.57.1.el6uek.x86_64 #2
[  989.762290] Hardware name: Oracle Corporation ORACLE SERVER
X5-2/ASM,MOTHERBOARD,1U, BIOS 30350100 06/17/2021
[  989.762599] task: ffff880178af6200 ti: ffff88017f7c8000 task.ti:
ffff88017f7c8000
[  989.762848] RIP: e030:[<ffffffffc07d4316>]  [<ffffffffc07d4316>]
__user_dlm_queue_lockres.part.4+0x76/0x80 [ocfs2_dlmfs]
[  989.763185] RSP: e02b:ffff88017f7cbcb8  EFLAGS: 00010246
[  989.763353] RAX: 0000000000000000 RBX: ffff880174d48008 RCX:
0000000000000003
[  989.763565] RDX: 0000000000120012 RSI: 0000000000000003 RDI:
ffff880174d48170
[  989.763778] RBP: ffff88017f7cbcc8 R08: ffff88021f4293b0 R09:
0000000000000000
[  989.763991] R10: ffff880179c8c000 R11: 0000000000000003 R12:
ffff880174d48008
[  989.764204] R13: 0000000000000003 R14: ffff880179c8c000 R15:
ffff88021db7a000
[  989.764422] FS:  0000000000000000(0000) GS:ffff880247480000(0000)
knlGS:ffff880247480000
[  989.764685] CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
[  989.764865] CR2: ffff8000007f6800 CR3: 0000000001ae0000 CR4:
0000000000042660
[  989.765081] Stack:
[  989.765167]  0000000000000003 ffff880174d48040 ffff88017f7cbd18
ffffffffc07d455f
[  989.765442]  ffff88017f7cbd88 ffffffff816fb639 ffff88017f7cbd38
ffff8800361b5600
[  989.765717]  ffff88021db7a000 ffff88021f429380 0000000000000003
ffffffffc0453020
[  989.765991] Call Trace:
[  989.766093]  [<ffffffffc07d455f>] user_bast+0x5f/0xf0 [ocfs2_dlmfs]
[  989.766287]  [<ffffffff816fb639>] ? schedule_timeout+0x169/0x2d0
[  989.766475]  [<ffffffffc0453020>] ? o2dlm_lock_ast_wrapper+0x20/0x20
[ocfs2_stack_o2cb]
[  989.766738]  [<ffffffffc045303a>] o2dlm_blocking_ast_wrapper+0x1a/0x20
[ocfs2_stack_o2cb]
[  989.767010]  [<ffffffffc0864ec6>] dlm_do_local_bast+0x46/0xe0 [ocfs2_dlm]
[  989.767217]  [<ffffffffc084f5cc>] ? dlm_lockres_calc_usage+0x4c/0x60
[ocfs2_dlm]
[  989.767466]  [<ffffffffc08501f1>] dlm_thread+0xa31/0x1140 [ocfs2_dlm]
[  989.767662]  [<ffffffff816f78da>] ? __schedule+0x24a/0x810
[  989.767834]  [<ffffffff816f78ce>] ? __schedule+0x23e/0x810
[  989.768006]  [<ffffffff816f78da>] ? __schedule+0x24a/0x810
[  989.768178]  [<ffffffff816f78ce>] ? __schedule+0x23e/0x810
[  989.768349]  [<ffffffff816f78da>] ? __schedule+0x24a/0x810
[  989.768521]  [<ffffffff816f78ce>] ? __schedule+0x23e/0x810
[  989.768693]  [<ffffffff816f78da>] ? __schedule+0x24a/0x810
[  989.768893]  [<ffffffff816f78ce>] ? __schedule+0x23e/0x810
[  989.769067]  [<ffffffff816f78da>] ? __schedule+0x24a/0x810
[  989.769241]  [<ffffffff810ce4d0>] ? wait_woken+0x90/0x90
[  989.769411]  [<ffffffffc084f7c0>] ? dlm_kick_thread+0x80/0x80 [ocfs2_dlm]
[  989.769617]  [<ffffffff810a8bbb>] kthread+0xcb/0xf0
[  989.769774]  [<ffffffff816f78da>] ? __schedule+0x24a/0x810
[  989.769945]  [<ffffffff816f78da>] ? __schedule+0x24a/0x810
[  989.770117]  [<ffffffff810a8af0>] ? kthread_create_on_node+0x180/0x180
[  989.770321]  [<ffffffff816fdaa1>] ret_from_fork+0x61/0x90
[  989.770492]  [<ffffffff810a8af0>] ? kthread_create_on_node+0x180/0x180
[  989.770689] Code: d0 00 00 00 f0 45 7d c0 bf 00 20 00 00 48 89 83 c0 00 00
00 48 89 83 c8 00 00 00 e8 55 c1 8c c0 83 4b 04 10 48 83 c4 08 5b 5d c3 <0f>
0b 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 55 41 54 53 48 83
[  989.771892] RIP  [<ffffffffc07d4316>]
__user_dlm_queue_lockres.part.4+0x76/0x80 [ocfs2_dlmfs]
[  989.772174]  RSP <ffff88017f7cbcb8>
[  989.772704] ---[ end trace ebd1e38cebcc93a8 ]---
[  989.772907] Kernel panic - not syncing: Fatal exception
[  989.773173] Kernel Offset: disabled

Link: https://lkml.kernel.org/r/20220518235224.87100-2-junxiao.bi@oracle.com
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/dlmfs/userdlm.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/dlmfs/userdlm.c
+++ b/fs/ocfs2/dlmfs/userdlm.c
@@ -433,6 +433,11 @@ again:
 	}
 
 	spin_lock(&lockres->l_lock);
+	if (lockres->l_flags & USER_LOCK_IN_TEARDOWN) {
+		spin_unlock(&lockres->l_lock);
+		status = -EAGAIN;
+		goto bail;
+	}
 
 	/* We only compare against the currently granted level
 	 * here. If the lock is blocked waiting on a downconvert,
@@ -595,7 +600,7 @@ int user_dlm_destroy_lock(struct user_lo
 	spin_lock(&lockres->l_lock);
 	if (lockres->l_flags & USER_LOCK_IN_TEARDOWN) {
 		spin_unlock(&lockres->l_lock);
-		return 0;
+		goto bail;
 	}
 
 	lockres->l_flags |= USER_LOCK_IN_TEARDOWN;
@@ -609,12 +614,17 @@ int user_dlm_destroy_lock(struct user_lo
 	}
 
 	if (lockres->l_ro_holders || lockres->l_ex_holders) {
+		lockres->l_flags &= ~USER_LOCK_IN_TEARDOWN;
 		spin_unlock(&lockres->l_lock);
 		goto bail;
 	}
 
 	status = 0;
 	if (!(lockres->l_flags & USER_LOCK_ATTACHED)) {
+		/*
+		 * lock is never requested, leave USER_LOCK_IN_TEARDOWN set
+		 * to avoid new lock request coming in.
+		 */
 		spin_unlock(&lockres->l_lock);
 		goto bail;
 	}
@@ -625,6 +635,10 @@ int user_dlm_destroy_lock(struct user_lo
 
 	status = ocfs2_dlm_unlock(conn, &lockres->l_lksb, DLM_LKF_VALBLK);
 	if (status) {
+		spin_lock(&lockres->l_lock);
+		lockres->l_flags &= ~USER_LOCK_IN_TEARDOWN;
+		lockres->l_flags &= ~USER_LOCK_BUSY;
+		spin_unlock(&lockres->l_lock);
 		user_log_dlm_error("ocfs2_dlm_unlock", status, lockres);
 		goto bail;
 	}


Patches currently in stable-queue which might be from ocfs2-devel@oss.oracle.com are

queue-5.15/ocfs2-dlmfs-fix-error-handling-of-user_dlm_destroy_lock.patch

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
