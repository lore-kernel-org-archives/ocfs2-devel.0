Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 448D9C433F5
	for <ocfs2-devel@archiver.kernel.org>; Thu, 19 May 2022 18:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=uUF/ReozNrLk7Ktq+liA5IxniCjIn554j9GvwNDxP+E=;
 b=tbm0jzkj/Wxv8Iz+Zj0fvXbaKHpYnWWTj9Qqi/95ROrmKaQhRg8NpBM1Rg2eb06SFwEfS7LZI0Hi
   TA/HXWgJu97S0UA3BtL3Dr2/rhtOduYcIBsDPnCNbIupAqtec5RjB+2Xy48LVbIHMUK7ZGlSKL1W
   MgsHyIWG1EwCJuHhCybF1jh6WUsmoHU78UDNiNaj82lSUc5nkr8+qixslg0yO9tSp8VUIDlQJxqk
   a8T6cKBMQfx/PiLcy/PCeMm+wIcPcn/0FxH5b3Rdf/xrLWOCw7pHwzkACSAzCGYMZJj9AmJ4tQsH
   ypxjxjwiX0S3dLTTeFAYjxlNRhW4ofxwZbqYrg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=uUF/ReozNrLk7Ktq+liA5IxniCjIn554j9GvwNDxP+E=;
 b=iZhA2fOus+D+VPNzdWectaBZMmT92tq1BebUDPn3nszCmyO5FBid96BlmEv1FjjB/W/smihN1Hfa
   kkHWTdlgJ0n5IrNOadC0b9FQhlKhzYGKbYQ+280Sub58iIsv4LEvLnzHGmhLaWb9kKk4ikBci0rJ
   ak0iRfSU6MG+gv+rC2dYwqlSeonxFRXH1fIx/Z5DvnxP3GNw30rkEfW2ZV9ffrD5iqukk2xVMg7Y
   J0vdq6UdrRXn1FmFF4gpwF8qxNFQjtSL78ynoUeRLi+rA18Ncy4UhiwgSzuU27k5EXVIWh0dqA/8
   xM12Tcgi231sHVEIGCMpxYy40tce9xQnbCE36Q==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220413 64bit (built Apr 13
 2022))
 with ESMTPS id <0RC500AY68MVQU40@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 19 May 2022 18:56:55 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1652986590; bh=hK5v1h7KwONCMoe0rtFFs2bYt0owafPwOZBAQdoKRBw=;
 h=Date:To:From:Subject:From;
 b=fOEzC7nHmTC2eMb6Iri6LsQAFs+9xlLSLZkcVOBn2OrzSETcYID8mtlBEhM4xGHfa
 YhtInDbgiBOP9ct9ZQSELa8yhjBXZf7iMAJz9gbozoWOntns1uGMXRvyMjSl2EM4Ht
 5y7UpeAxnMxsVfg/3JXKv3x74RvfmAwGl0coXk7I=
Date: Thu, 19 May 2022 11:56:30 -0700
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, piaojun@huawei.com,
 mark@fasheh.com, junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
 jlbec@evilplan.org, jiangqi903@gmail.com, ghe@suse.com, gechangwei@live.cn,
 ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org
Message-id: <20220519185630.CDB11C385AA@smtp.kernel.org>
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10352
 signatures=594197
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 mlxscore=0 malwarescore=0
 phishscore=0 priorityscore=48 adultscore=0 suspectscore=0 mlxlogscore=999
 clxscore=184 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205190106
Subject: [Ocfs2-devel] +
	ocfs2-dlmfs-fix-error-handling-of-user_dlm_destroy_lock.patch	added to
 mm-nonmm-unstable branch
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
From: Andrew Morton via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Andrew Morton <akpm@linux-foundation.org>
MIME-version: 1.0
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: ams.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:140.211.169.12/30 include:_spf.kernel.org
 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-GUID: UROYNpJijAXtor4TkJbTSCKniQYaAEZF
X-Proofpoint-ORIG-GUID: UROYNpJijAXtor4TkJbTSCKniQYaAEZF
Reporting-Meta:
 AAEphJ9xWQjwrSbuSYevs4tnDFfmo3QjvCk2/3uO0CIRatkaGO2ahfd/quxppWPl
 sr2ZSlVzUxnCN4SVeGXsguoWkUdD1SYW5KddUk3MM7dad2xyYZxz8+B2RJBRnrBi
 rGpo4hjWroTn81Yk9j1v8xpTcwtKsi997wWx+inMwH0UONorrpG9O8v6UQRjYvRA
 l4kAJmb4Upgg85SM3TDupagzyN+fkldclc+0dBlevRk+/oOaikV+fhscDZRrI4NW
 fNM01ge44P21Vcn2BHfL9cG+Ya/YwimgzThFR8sb+LiqzPlpuaLXTPkx/bs2Mcwk
 n9ZaR+sE+avehjikIIHfU3x0/SIpSOHdZmP6HGBWdRj4VVe38aDfcnp5VE2l6H0K
 y7bc7sTaRWozrnXyLhcDv14zOEeS5Yqz68d1B4RLtTNYnIcDRFZOLDo9T/lhmsw1
 OgM2SWGUjg7CnugLUdCNWbgxKpg2AxZYcbW7INa2YuZ6GgpP0sDyvFflrJJUD80F
 bvTIepTs/FMJZc0uf1kgE5xtfPgjNJSp5/i22B9uVnID


The patch titled
     Subject: ocfs2: dlmfs: fix error handling of user_dlm_destroy_lock
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-dlmfs-fix-error-handling-of-user_dlm_destroy_lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-dlmfs-fix-error-handling-of-user_dlm_destroy_lock.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Junxiao Bi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: ocfs2: dlmfs: fix error handling of user_dlm_destroy_lock
Date: Wed, 18 May 2022 16:52:24 -0700

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
---

 fs/ocfs2/dlmfs/userdlm.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/dlmfs/userdlm.c~ocfs2-dlmfs-fix-error-handling-of-user_dlm_destroy_lock
+++ a/fs/ocfs2/dlmfs/userdlm.c
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
@@ -624,6 +634,10 @@ int user_dlm_destroy_lock(struct user_lo
 
 	status = ocfs2_dlm_unlock(conn, &lockres->l_lksb, DLM_LKF_VALBLK);
 	if (status) {
+		spin_lock(&lockres->l_lock);
+		lockres->l_flags &= ~USER_LOCK_IN_TEARDOWN;
+		lockres->l_flags &= ~USER_LOCK_BUSY;
+		spin_unlock(&lockres->l_lock);
 		user_log_dlm_error("ocfs2_dlm_unlock", status, lockres);
 		goto bail;
 	}
_

Patches currently in -mm which might be from ocfs2-devel@oss.oracle.com are

ocfs2-dlmfs-not-clear-user_lock_attached-when-destroy-lock.patch
ocfs2-dlmfs-fix-error-handling-of-user_dlm_destroy_lock.patch


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
