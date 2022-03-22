Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53178C433EF
	for <ocfs2-devel@archiver.kernel.org>; Tue, 22 Mar 2022 03:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=RKFqqTWmELu9sDd8QUaqqpnCgD3gLbw+/lXv7TFJldo=;
 b=TSmnQk39rClEz2QsyhQ/QLZMO0z0Dii5/KahgX8lu3a7q/KzO7fy4SyuQTLjKgeV77mcE5/Fmyep
   S9H+tsqYoTSTdk3Mts6ef3eBwmfWLw8m8nO+Oxns7OFzVcG+z7SVghk2dMza5jwTvRPFR7xiLjaG
   kj5nOXh66gzi04JWEt0WgTEfJ2GgyeQglUyq1z1x5NZCupAD2Qn5BR5MG3IWeAG2ivOR2F8I1oym
   x2awl60ZfWZSR9AK+bUWF/EaJ7Kb38SXlK2APY+zxHPQzwMvWXbU39GRSe5oDLUIO+WvxuSUjEUo
   3Rp9ua7lRiaOr2P5xXV1d5A7WrrlSuWSyF2xig==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=RKFqqTWmELu9sDd8QUaqqpnCgD3gLbw+/lXv7TFJldo=;
 b=G87KigyzTq26omeDVas16omqwL+pvOseZeNdQ9ZwbRsbeKdp4g7O7mtlFxdkgpOb8vmiGcRC2NNJ
   WuOxnBmtZl1D7xbvlpoo/GRhhIPvzMvqdwgPH6JleFEwtkRtdA5QAjTTUAo4XZDzF+8e8/7qXj4N
   ydkknCFLixizus9OEk1FDcl6KUO4+zQ50FVoBjm55cI/AagHc6RIDgXOwbAXU9EiM+gr2lC7Cp/c
   K/uGHyiWYBNFZL3ucuTZQrKsrMhF/R/9udtI0EmgIiukrxmPsYZocx3XWpcyjoSiEdAnv4YIANOa
   N85+bkkowxNUdKE6z5MwJvtT1bqMAWgMIuIyDQ==
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220222 64bit (built Feb 22
 2022))
 with ESMTPS id <0R94002J8MBAS380@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 22 Mar 2022 03:13:58 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=vvidic@valentin-vidic.from.hr; dkim=pass header.s=2020
 header.d=valentin-vidic.from.hr; dmarc=pass header.from=valentin-vidic.from.hr
X-Virus-Scanned: Debian amavisd-new at valentin-vidic.from.hr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=valentin-vidic.from.hr;
 s=2020; t=1647918800; bh=aRmYkly1RGZHmy3TH6RlWN9as6ukPrXy80Syj7vfxUc=;
 h=From:To:Cc:Subject:Date:From;
 b=lzUdIL9jYoTOFPBh1KxcfINx/BcxnxrySaVZPaEpb/dxnzCssKxD49qzaThJao8K5
 4OW2hyQQi+GC7z8yKH761uqVSXIRadrcalGNQS35iiUraOSCl1Rs7Tgk5k1tH6JYtq
 jH003YB6RA+3Urk13GNff8vvVlVlqeUFoHEhVd8jZS7RhAkaD4qOV5Eg2XAA43RnEw
 el0ZIEJu2wt9p39Q/6iDAklGNBhXipfYVfAnwiDEuNsS+Bm8WZn3ebn9oRoDfSArmV
 pQXjYrSZw9FEAfalpEb7NP8SykwVhsSBi6yiyr8JbRdL0NLojnBFVbjac178o9d5dZ
 U+gJUhLuK84fu/guc8kC2VYNcbZOxKXUCcRa6YfsJdkEJfi9vRWCX+ILV/GNbYwJMP
 w0mRTiYOTMTf6HVPNbAKoARcjfGvFYbb1AFoT0v4ui/OC2RkLRvZJoH20Hcq+hUZQG
 sbEYoHjg+eKOHTB+URVy+fDJFMepV1jT6HTmwDm7oyUSC8p0HpoWy8YEewpNlNJgK9
 MitpqjRDQIPK6WOGnSWFqwcjg47XMwD3480RXK/5PbcTspoSlYTrE51qkRJZcHCNLv
 1HMglzUHGY1cdsltSjfvI4ZeBww3uHdGi71Db/ieNOzWop905JTVBWrgpmLCJt8+m+
 Owh1veLjh0mhD+KmSjamGrRg=
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Tue, 22 Mar 2022 04:12:15 +0100
Message-id: <20220322031215.1449435-1-vvidic@valentin-vidic.from.hr>
X-Mailer: git-send-email 2.30.2
X-Source-IP: 109.200.23.17
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10293
 signatures=694221
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 malwarescore=0 priorityscore=0 spamscore=0 clxscore=232 phishscore=0
 bulkscore=0 impostorscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203220016
Cc: Valentin Vidic <vvidic@valentin-vidic.from.hr>,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Tuo Li <islituo@gmail.com>, Dayvison <sathlerds@gmail.com>,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH] ocfs2: quota_local: fix mount crash of
	filesystems with quota enabled
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
From: Valentin Vidic via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Valentin Vidic <vvidic@valentin-vidic.from.hr>
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: valentin-vidic.from.hr
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx -all
X-Spam: Clean
X-Proofpoint-GUID: i8TiA44snebwefqb1UwFaJVk7Rv43xsG
X-Proofpoint-ORIG-GUID: i8TiA44snebwefqb1UwFaJVk7Rv43xsG
Reporting-Meta:
 AAFSCF//aDlF0fIeCvRqwp4ovsG84HFDBD6UrM/s8tDTN+9srTTw+HN92KdlD22p
 vEv+2dEJs8+wATJnS9Hd+77UomJEakVenqtovFbzoAuuRuIxzHE/dLbGyxFoc9MV
 iI1Om5EaxbhZFr2wcDtKYVPo+3lVYn263ZXjyLQaFICtLJd57ptKdIh+fBRdv+Le
 S85xasjDbYwLcydJtJQ56KegPjxTa79mZTs8uQtTeQl4+GgacxYIZrZ6/O3SVCPt
 oZlJYyn1pVkM126UG7oeQppljo/4VAjoV/vB6FXvUEVzydStOFPLaxbmmLkLx4f3
 2w3pvIaGHDR/goZjp0ZronFCgwrsqZOhlRvFILttDb5G8rL15g5JsYoewYFJZY4R
 NwegrXtnF/KkLWRCnGTSf5hEF+wuPBtYeT0PhtDJC1cLpBiaSTB7Dg+V80Wm/6+C
 4RJK1d8pz5RwcG18VsOns1slyRAYotqZ50zjvwLGxVtqt5b5kr1pn7scPk5TIQ7C
 hWSHaAHz6dWGZU7DrUMCUVXSTjP/Ea3N/+3Oa4Lav7Yb

ocfs2_qinfo_lock_res_init is called too early while oinfo->dqi_gi.dqi_sb
is still a NULL pointer causing a crash on mount when quotas are enabled.
Restore ocfs2_qinfo_lock_res_init original call location in
ocfs2_global_read_info after the value of oinfo->dqi_gi.dqi_sb is set.

[  389.111864] ocfs2: Mounting device (254,16) on (node 2, slot 0) with ordered data mode.
[  389.160182] BUG: kernel NULL pointer dereference, address: 0000000000000398
[  389.160295] #PF: supervisor read access in kernel mode
[  389.160343] #PF: error_code(0x0000) - not-present page
[  389.160390] PGD 0 P4D 0
[  389.160432] Oops: 0000 [#1] PREEMPT SMP PTI
[  389.160477] CPU: 0 PID: 836 Comm: mount.ocfs2 Not tainted 5.16.0-4-amd64 #1  Debian 5.16.12-1
[  389.160591] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
[  389.160714] RIP: 0010:ocfs2_qinfo_lock_res_init+0x44/0x50 [ocfs2]
[  389.161290] Code: 00 00 00 48 63 b3 b8 01 00 00 e8 87 bb ff ff 49 89 d8 48 89 ee ba 08 00 00 00 48 8b 83 b0 01 00 00 48 c7 c1 a0 e0 dc c0 5b 5d <48> 8b b8 98 03 00 00 e9 70 c4 ff ff 0f 1f 44 00 00 41 56 41 89 ce
[  389.161460] RSP: 0018:ffffb2c0c0047be8 EFLAGS: 00010282
[  389.161510] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffffc0dce0a0
[  389.161619] RDX: 0000000000000008 RSI: ffff8b685c343c30 RDI: ffffb2c0c0047bb8
[  389.161747] RBP: ffff8b685c343c00 R08: ffff8b685c343c00 R09: 0000000000000000
[  389.161809] R10: ffffb2c0c0047bb0 R11: ffffffffc0d8f030 R12: ffff8b685c343c18
[  389.161868] R13: ffff8b68462d3ec8 R14: 0000000000000000 R15: ffff8b6848fb6800
[  389.161929] FS:  00007f7956901c00(0000) GS:ffff8b687ec00000(0000) knlGS:0000000000000000
[  389.162009] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  389.162060] CR2: 0000000000000398 CR3: 000000000554a004 CR4: 0000000000370ef0
[  389.162129] Call Trace:
[  389.162184]  <TASK>
[  389.162211]  ocfs2_local_read_info+0xb9/0x6f0 [ocfs2]
[  389.162479]  ? ocfs2_local_check_quota_file+0x197/0x390 [ocfs2]
[  389.162774]  dquot_load_quota_sb+0x216/0x470
[  389.162849]  ? preempt_count_add+0x68/0xa0
[  389.162895]  dquot_load_quota_inode+0x85/0x100
[  389.162943]  ocfs2_enable_quotas+0xa0/0x1c0 [ocfs2]
[  389.163151]  ocfs2_fill_super.cold+0xc8/0x1bf [ocfs2]
[  389.163374]  mount_bdev+0x185/0x1b0
[  389.163431]  ? ocfs2_initialize_super.isra.0+0xf40/0xf40 [ocfs2]
[  389.163673]  legacy_get_tree+0x27/0x40
[  389.163726]  vfs_get_tree+0x25/0xb0
[  389.163764]  path_mount+0x465/0xac0
[  389.163804]  __x64_sys_mount+0x103/0x140
[  389.163844]  do_syscall_64+0x3b/0xc0
[  389.163919]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  389.164016] RIP: 0033:0x7f7956e0258a
[  389.164057] Code: 48 8b 0d e9 28 0d 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b6 28 0d 00 f7 d8 64 89 01 48
[  389.164206] RSP: 002b:00007fff9be78718 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
[  389.164273] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f7956e0258a
[  389.164334] RDX: 000055bffbe230ae RSI: 000055bffc7ec370 RDI: 000055bffc7f33f0
[  389.164395] RBP: 00007fff9be788d0 R08: 000055bffc7f3390 R09: 00007fff9be76110
[  389.164454] R10: 0000000000000000 R11: 0000000000000246 R12: 000055bffbe230ae
[  389.164514] R13: 000055bffc7ec301 R14: 00007fff9be787c0 R15: 00007fff9be78740
[  389.166469]  </TASK>
[  389.168355] Modules linked in: ocfs2 quota_tree ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager ocfs2_stackglue sctp ip6_udp_tunnel udp_tunnel libcrc32c intel_rapl_msr intel_rapl_common intel_pmc_core_pltdrv intel_pmc_core kvm_intel kvm irqbypass ghash_clmulni_intel snd_hda_codec_generic ledtrig_audio snd_hda_intel snd_intel_dspcfg snd_intel_sdw_acpi aesni_intel crypto_simd qxl snd_hda_codec cryptd drm_ttm_helper rapl snd_hda_core ttm snd_hwdep snd_pcm serio_raw snd_timer iTCO_wdt pcspkr intel_pmc_bxt iTCO_vendor_support drm_kms_helper snd virtio_rng rng_core soundcore virtio_balloon virtio_console cec evdev joydev i6300esb rc_core watchdog qemu_fw_cfg button auth_rpcgss sunrpc drm fuse configfs ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2 crc32c_generic hid_generic usbhid hid virtio_net net_failover failover virtio_blk ahci xhci_pci libahci libata xhci_hcd crct10dif_pclmul crct10dif_common crc32_pclmul crc32c_intel virtio_pci virtio_pci_legacy_dev virtio_pci_modern
 _dev
[  389.168645]  virtio psmouse usbcore scsi_mod i2c_i801 i2c_smbus scsi_common lpc_ich usb_common virtio_ring
[  389.187016] CR2: 0000000000000398
[  389.188963] ---[ end trace 571e3ca036b59855 ]---

Fixes: 6c85c2c72819 ("ocfs2: quota_local: fix possible uninitialized-variable access in ocfs2_local_read_info()")
Reported-by: Dayvison <sathlerds@gmail.com>
Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1007141
Cc: stable@vger.kernel.org
Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>
---
 fs/ocfs2/quota_global.c | 1 +
 fs/ocfs2/quota_local.c  | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index f033de733adb..eda83487c9ec 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -357,6 +357,7 @@ int ocfs2_global_read_info(struct super_block *sb, int type)
 	}
 	oinfo->dqi_gi.dqi_sb = sb;
 	oinfo->dqi_gi.dqi_type = type;
+	ocfs2_qinfo_lock_res_init(&oinfo->dqi_gqlock, oinfo);
 	oinfo->dqi_gi.dqi_entry_size = sizeof(struct ocfs2_global_disk_dqblk);
 	oinfo->dqi_gi.dqi_ops = &ocfs2_global_ops;
 	oinfo->dqi_gqi_bh = NULL;
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 0e4b16d4c037..e6037e4a1641 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -703,7 +703,6 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
 	oinfo->dqi_type = type;
 	INIT_LIST_HEAD(&oinfo->dqi_chunk);
 	oinfo->dqi_gqinode = NULL;
-	ocfs2_qinfo_lock_res_init(&oinfo->dqi_gqlock, oinfo);
 	oinfo->dqi_rec = NULL;
 	oinfo->dqi_lqi_bh = NULL;
 	oinfo->dqi_libh = NULL;
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
