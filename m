Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49984C433F5
	for <ocfs2-devel@archiver.kernel.org>; Wed, 18 May 2022 23:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=oot5o0qIZmbDAGZWqKds9BQfufCXugpakMlBP0h8hjQ=;
 b=N4ZwWPYtzYFJi1QLUTirFxYKn5GTCHAF46/3alFfZHEgSL7dQJLTDB8Ue928doco9u7xuRAmxmYQ
   /PzQcvWC4D9a2djn/BvxRn+vRqaCFLnlFOqfmck2+etrydfyGPhhemeKUTAifnIDFHxYPt7rI6tn
   2FaHC5rxmshTkmxniJTN7Kmhd38XplwW1c0QiYzl31UWGq38XSGmHQuUMyjABmTjb8epG+4hsvam
   HZhgz0/j9mIOnezc0pVnvwk6qQwVsNFYttphCAINF7gCDYndlKtqhMZMG26+XWEuaitIjwXAg6M4
   1KNCavHhBntvPF6V1WULqGCaghBjfjdbsH99lw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=oot5o0qIZmbDAGZWqKds9BQfufCXugpakMlBP0h8hjQ=;
 b=ZkpG1zzCO5A2knqQ4KKj/swvxv+krD3sDI52bXPW6kxf0D4nFx4eQW0ulnE6gLJ9EYmVMpZ5zng5
   3ZD5JFiNoT1+FO3BRwE4St+n1p5RuGj1PK3RFX9sjZKy4WRqC19XC/kL/BdA+K1fsK1p1xMrbtBf
   c/sKwCRGnr3Udx5l3IZG6/JMD7HCtrigqm9l9tpz5CAue1KPIOLrMki7KfZzl+MTZDjx2AEQpV8u
   htytMxcBlFn7RNfZ73DkgHUapV5jvUgFdvVC3HJds8ogzpXAcwr+WpovWg525nFoOTzRy8K9P0gl
   Bjd8BH4DadLD2sQsbvWQGh+rnMA1tY0JE1uemw==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220413 64bit (built Apr 13
 2022))
 with ESMTPS id <0RC3004S0RNREU60@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 18 May 2022 23:52:39 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to
 : cc : subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2021-07-09;
 bh=SfUYpXTh3sOhXD4xLozBhzbO6i94j01xvPlCV8ipnhA=;
 b=fmgP8vTAIWFF21Oy1/G6Du1/klnt1x3YOpCFfWJbZg2JZE/pGR0RcXLRmJIjv0asP6jP
 7LqGrkJA2HAT0wL/3PgPMZ8oKzbBGzhWBWygqTrIXV4jlTvR8YOgUrwwgKlFwSm5Zfzf
 J2aUaQlcK3aoBg2Ig3YwG2u5VK/5O5E8ywvp5sPxF4OzwM5z8Qo9fsjD+qSFdsTHxnBz
 wsXhKBCu/UWf+miNweODGu4GFNn+x6v5nf+n9murttM7I2qEXDWNlG+iafCN2mIhvpqF
 B/rhuQIHN9Lu9r5/fW/oQZ7uuCbJHN2Yre12pEJ+UpOkvGybsfMQjmuss18lUAEfwp28 7g==
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jje7/3wlMsCrmANSfFbaukv1g6FYtM5z8e4uDwjLNy0YsJjlJx2wwA5BxqDGTIDEjfVEC5MPtObrAU16VT2HES0KHKMohwNoYQZUpMpRHYGAMqkktryTSElsA7CwPnPBoRWW8rI4Aj26dhJrEkE2cZeIFqR1itu9cvb5Sqnr9VxLrLCDSO07LTX1vSfAFms2eyNikKfmuwhN0e0RwL9MAqPAQjzrhrl9tgklwfygGJZ9BCSF79cgQI/Iz/JcdtRir2APi38G0+d2udH1UNGBuie6wWBOovQllJ6pQQvKAvWlF0bPzqSy3yjl77v0pLgSekXk18oDzYg8vpTZw/sHuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SfUYpXTh3sOhXD4xLozBhzbO6i94j01xvPlCV8ipnhA=;
 b=ccw1j6UkoRa70nQnQtO9TH2ft9j7ssS5Ck+7zrIgN6FbZGw2cGnqUnn3LSPBVxGys5ux+2yFjY+7EJc+Mdjoa3TE2xwVaiI/1fOaUVPDKeOLJ2EsaM9+JP5nV6nUG0rwMdrf55BouGUhV22arnydAC8fimfj21aPgQV08XIVB2t7+yIE2PQkvyzrinP4E4IYpNhif5QudoGCSMqox2DGRP89AcrmVoFNywKE6ODJtTANja2Bf16AvPzz0gfkeIz0bxtWvPy5LW0OJdltLj1eoR5PzkKJ2iP/aMzLQ58Odo9EPJ64cdI6VkQDVS8WrPaqUFPduRd3uwcblaVC3C+PCw==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SfUYpXTh3sOhXD4xLozBhzbO6i94j01xvPlCV8ipnhA=;
 b=aJh9oiqwI82WajwZMd4YU4jA2b9IX4/A0Xo/6oidmZx7PrAA9rD8T+sAdyfVBaL0tPZscf8hcjmSFL9TrWrteANFo09PYZe3RIO/wedZNoAZsPp+NA04bRAodIfqbnHAE2dr60w7p/NRLLO8dU4tmPyzAHCFtd5F+YWK3GNtycQ=
To: ocfs2-devel@oss.oracle.com
Date: Wed, 18 May 2022 16:52:24 -0700
Message-id: <20220518235224.87100-2-junxiao.bi@oracle.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-reply-to: <20220518235224.87100-1-junxiao.bi@oracle.com>
References: <20220518235224.87100-1-junxiao.bi@oracle.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:SJ0PR10MB4752.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 23:52:28.7828 (UTC)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,
 18.0.874 definitions=2022-05-18_06:2022-05-17, 2022-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxscore=0 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205180135
Subject: [Ocfs2-devel] [PATCH v2 2/2] ocfs2: dlmfs: fix error handling of
	user_dlm_destroy_lock
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
From: Junxiao Bi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Junxiao Bi <junxiao.bi@oracle.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: BY3PR04CA0013.namprd04.prod.outlook.com
 (2603:10b6:a03:217::18) To SJ0PR10MB4752.namprd10.prod.outlook.com
 (2603:10b6:a03:2d7::19)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62354cc5-06a8-48f1-30a1-08da39297755
X-MS-TrafficTypeDiagnostic: MWHPR10MB1902:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 kDAAYbCn2ReTz7HhzZ8/QeN3GGuxbXlaz1L4KG6aK2Ss81IdQIlJWBl9ZksY2iKKiWGgqCS2PQgEyOVrVVqgpmwUrF26pSQeNb260+v+s0g0FkgwCY6o4TZLszB9sxKX7dytSlb1yZRXF2XlaahkzzlxD2fYjCwqQGsGkyke0d5Fkex4qR5lZ9wCz0u+Cwbkuf/qD3Bwg78Udn2lkg/GGlXD6oQuiKJ5zvs2Z06gIo9bR7VVAN4uygG1tdzx0ibFyijnfpG8cQAtXRGLui1zUEdsxJ3/LN+avVhbjwDOHoF/B3JxJJnT7e04E4tb5xckLADBdJhj09Iqs8bBLsccsXFP5gidu/1wSWN2tYjNlqqNy2Z94WdJo47Gwf2iNFqywurYrNkCdMzC6TYJE0KLoJScehPcv8I3hSx7o7WKNly02WesCgyBZ2BIB8RW6w02juwh1P4OE+OydbjDHd8bwfeoDDxIEp4azwDp1ycaUNkX0+4dAgx8j8/ceelNRiwKtYqRcfPRc89XGCyQpxvW7Y6l/Uf8LZKCu/cClPTH+d39cfiaDOZIMzidg0esgDl8lNbQohI3Usezl3WxJY6jIFjDga0AxDaNHGEV89fUcwU=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 62354cc5-06a8-48f1-30a1-08da39297755
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 o5CqaUL9oWcHtFFjyPzbL/rtfLyy/IP/8iyIo1Bq0oMNDplwkPtQF7uCPMNJuwiDvQ4RZ+FdG9igTP+K49NHLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1902
X-Proofpoint-ORIG-GUID: pWw6LRUpfolHj0xoIN2_Lszz3kgFyzKP
X-Proofpoint-GUID: pWw6LRUpfolHj0xoIN2_Lszz3kgFyzKP
Reporting-Meta:
 AAHr2FqMk2eYT40gTxlRDJCLOfnIdbEjsGF6iuI/AG6LlaBqvNHEt9roVFhRyzjL
 9KZLAq/xgUlOD442y5FNUmB9+Qyu4AQGz3yM7/NYs/R84U2oNISr/Fey43aedAXs
 88h8kimhi25douqcPYboqzggrp752H8lVQWnap2Ki9k/1yln/DmF7lQ8jC52T3ht
 KAvIijo071OM3QcrwFnJt5yWrLOi6kjshFCvCbkiyrlFtogq7dJuQ5KGZlczzbbd
 XZtJzKjdsIxulU0PfuI1goLlQTPZ+CDqdM5A0GD+mBOnJXHUlfjmWLMlYJ165Ir2
 WagTWOb7oH4erMfofqeWt30fKrk2wZiCn/L8PI366KcohDQTYb+LpLrqAahR6Atv
 R/msX554F7glpUKUms9Xw2umKMj2FIvm9DE1A194o/q1Bp0NUwjN72gllGqmymVQ
 iF8wIofJk0c6KfUzGW1L8HLVoOiPHuyLQmleUUd0hV916GlgNW2jyTNqPbbMlErs
 sJ910O5esfwEqvUYk1n36erLqiJHax5SKfXdBOqlcygI

When user_dlm_destroy_lock failed, it didn't clean up the flags it set
before exit. For USER_LOCK_IN_TEARDOWN, if this function fails because
of lock is still in used, next time when unlink invokes this function,
it will return succeed, and then unlink will remove inode and dentry if
lock is not in used(file closed), but the dlm lock is still linked in dlm
lock resource, then when bast come in, it will trigger a panic due to
user-after-free. See the following panic call trace.
To fix this, USER_LOCK_IN_TEARDOWN should be reverted if fail. And also
error should be returned if USER_LOCK_IN_TEARDOWN is set to let user know
that unlink fail.

For the case of ocfs2_dlm_unlock failure, besides USER_LOCK_IN_TEARDOWN,
USER_LOCK_BUSY is also required to be cleared.
Even though spin lock is released in between, but USER_LOCK_IN_TEARDOWN
is still set, for USER_LOCK_BUSY, if before every place that waits on
this flag, USER_LOCK_IN_TEARDOWN is checked to bail out, that will make
sure no flow waits on the busy flag set by user_dlm_destroy_lock(),
then we can simplely revert USER_LOCK_BUSY when ocfs2_dlm_unlock fails.
Fix user_dlm_cluster_lock() which is the only function not following this.

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

Cc: <stable@vger.kernel.org>
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 fs/ocfs2/dlmfs/userdlm.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/dlmfs/userdlm.c b/fs/ocfs2/dlmfs/userdlm.c
index af0be612589c..617c92e7b925 100644
--- a/fs/ocfs2/dlmfs/userdlm.c
+++ b/fs/ocfs2/dlmfs/userdlm.c
@@ -433,6 +433,11 @@ int user_dlm_cluster_lock(struct user_lock_res *lockres,
 	}
 
 	spin_lock(&lockres->l_lock);
+	if (lockres->l_flags & USER_LOCK_IN_TEARDOWN) {
+		spin_unlock(&lockres->l_lock);
+		status = -EAGAIN;
+		goto bail;
+	}
 
 	/* We only compare against the currently granted level
 	 * here. If the lock is blocked waiting on a downconvert,
@@ -595,7 +600,7 @@ int user_dlm_destroy_lock(struct user_lock_res *lockres)
 	spin_lock(&lockres->l_lock);
 	if (lockres->l_flags & USER_LOCK_IN_TEARDOWN) {
 		spin_unlock(&lockres->l_lock);
-		return 0;
+		goto bail;
 	}
 
 	lockres->l_flags |= USER_LOCK_IN_TEARDOWN;
@@ -609,12 +614,17 @@ int user_dlm_destroy_lock(struct user_lock_res *lockres)
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
@@ -624,6 +634,10 @@ int user_dlm_destroy_lock(struct user_lock_res *lockres)
 
 	status = ocfs2_dlm_unlock(conn, &lockres->l_lksb, DLM_LKF_VALBLK);
 	if (status) {
+		spin_lock(&lockres->l_lock);
+		lockres->l_flags &= ~USER_LOCK_IN_TEARDOWN;
+		lockres->l_flags &= ~USER_LOCK_BUSY;
+		spin_unlock(&lockres->l_lock);
 		user_log_dlm_error("ocfs2_dlm_unlock", status, lockres);
 		goto bail;
 	}
-- 
2.24.3 (Apple Git-128)


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
