Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A426FC433FE
	for <ocfs2-devel@archiver.kernel.org>; Wed,  9 Nov 2022 06:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=oCpvHwcidXPHAbBU92IjpL4Xx7GRhrIUGE2+r316oJg=;
 b=kL4nxOiuuGCYn07KsyORgI68NTZ6IPoqmCey/pdPhR8yyvvScjo2SKRnbtHMZ/OoCGKQUwRVt7EW
   j3xNZ4r+4CEphwFt92LHawZdYdmOamm65QuOFspjgV24kHeUlYjSmo8MS1xyJzkm98X3eYXWHYeZ
   Vn4t3SpkvKm5SIYY3iXN4Xun7a09r+P434cGROsXYdj2xaEDlJk2NIJi1fvpqBmPawZuqj+o0Ybu
   5bV5yr+ak3jMhzPnf8HeGn4g96b9e8dwrYD8ks1UA+Rv9jtQr2ro0itCCqCW0Ru7TUaRtHsjS/S6
   8daQG3h+HkFy2iEK/JbY2PCDdxh3vdIYIkdibg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=oCpvHwcidXPHAbBU92IjpL4Xx7GRhrIUGE2+r316oJg=;
 b=sMdC3lbXCayCtzVkVOgTe8FVnI8/R4exXujbWrkaZZ1Utt6nn8StbGAYdfGECzZyhz7knOukA7dP
   w65rPLH+R3prvr49vdpBpTC0O7NlM5I2lpi0xmXSKh4K60C6dmzQ78a+WmcD+L6Jm50hJz+G7pJY
   1kWQAk6mbZpWgYOn5yC5JgQdpRQg6eUJNe5XCUO6OwZpFaCEX4aIlMcB3iQ+NeQ28BIE2t5hOIsZ
   SiD1AdfFxC20KgIEAB5Ue/uwAje9ubb3hnCllfXFzbxV66SrDaw3dABoac1YSXLJEzSQ6s7coYYf
   osTprmr8+S22SVWde3BlplrkbRT+PDeTP4CaZw==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221026 64bit (built Oct 26
 2022))
 with ESMTPS id <0RL200HPTJF1Q9B0@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 09 Nov 2022 06:59:25 +0000 (GMT)
To: <joseph.qi@linux.alibaba.com>
Date: Wed, 9 Nov 2022 15:46:27 +0800
Message-id: <20221109074627.2303950-1-lizetao1@huawei.com>
X-Mailer: git-send-email 2.25.1
In-reply-to: <05c24286-427d-e572-aa70-8f1d882b9602@linux.alibaba.com>
References: <05c24286-427d-e572-aa70-8f1d882b9602@linux.alibaba.com>
MIME-version: 1.0
X-Originating-IP: [10.67.175.21]
X-Source-IP: 45.249.212.187
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10525
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 impostorscore=0 bulkscore=0
 spamscore=0 priorityscore=186 clxscore=121 mlxscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211090053 domainage_hfrom=8338
Cc: lizetao1@huawei.com, linux-kernel@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: fix memory leak in	ocfs2_mount_volume()
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
From: Li Zetao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Li Zetao <lizetao1@huawei.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
X-ServerName: szxga01-in.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.32 ip4:45.249.212.35
 ip4:45.249.212.255 ip4:45.249.212.187/29 ip4:45.249.212.191 ip4:168.195.93.47
 ip4:185.176.79.56 ip4:119.8.179.247 ip4:119.8.89.136/31 ip4:119.8.89.135
 ip4:119.8.177.36/31 ip4:119.8.177.38 -all
X-Spam: Clean
X-Proofpoint-GUID: VCZ2Uz4qz71MPqADw7JwWZvT3uyvKOmb
X-Proofpoint-ORIG-GUID: VCZ2Uz4qz71MPqADw7JwWZvT3uyvKOmb
Reporting-Meta:
 AAHo4AE/zIJNVAaUExZetvpkYZiBW6LLoQBy7feVBk8RB/IgOv8oYcPkqYBnHLXM
 UzDn/Z1DqOhRYr52TO3HbpomPvMCa+OkZd2rqroPcyco9nGzxbwasjoDPMmR0yS3
 Mhe3fz6wqtHXf83KCItmp4nLettx9jlt1OPwnWDIDr8wT03DAcuKcpTiYguw6EQu
 W/G5SIS3Aygblz5xSuj6UY5B25sD8KgJQrfCIgq0AuDX+Ebrv2bbd20xyMus8S+a
 amLht7/hwZdF1NtjcP9TtnJBzP92auDRwqBbyYhkfyLZTJVgG+Qn+bnPFTJ0kZ4h
 SwMDuyp6Wh4k3ka7t+kkGMQRmiYI7LXUS43QlfzMLXlX4tnSyyeiQRrair8u8nMk
 1IpvFKGY+QYrazMyfLNaupE8f5tLMgAOOBL1ejRDhCOXdJ77S1DjGAKgntbfOLJA
 fOTlEjSL0E0ufsNGvJ4VvlyBXOopVCwmEfF5qR5080/o9Z7RLRqaV3qnLTfxPVv3
 qQVF4nYjzlm2+TuvkRQM4he93uO26nRpK1rI7s0Eh15C

There is a memory leak reported by kmemleak:

  unreferenced object 0xffff88810cc65e60 (size 32):
    comm "mount.ocfs2", pid 23753, jiffies 4302528942 (age 34735.105s)
    hex dump (first 32 bytes):
      10 00 00 00 00 00 00 00 00 01 01 01 01 01 01 01  ................
      01 01 01 01 01 01 01 01 00 00 00 00 00 00 00 00  ................
    backtrace:
      [<ffffffff8170f73d>] __kmalloc+0x4d/0x150
      [<ffffffffa0ac3f51>] ocfs2_compute_replay_slots+0x121/0x330 [ocfs2]
      [<ffffffffa0b65165>] ocfs2_check_volume+0x485/0x900 [ocfs2]
      [<ffffffffa0b68129>] ocfs2_mount_volume.isra.0+0x1e9/0x650 [ocfs2]
      [<ffffffffa0b7160b>] ocfs2_fill_super+0xe0b/0x1740 [ocfs2]
      [<ffffffff818e1fe2>] mount_bdev+0x312/0x400
      [<ffffffff819a086d>] legacy_get_tree+0xed/0x1d0
      [<ffffffff818de82d>] vfs_get_tree+0x7d/0x230
      [<ffffffff81957f92>] path_mount+0xd62/0x1760
      [<ffffffff81958a5a>] do_mount+0xca/0xe0
      [<ffffffff81958d3c>] __x64_sys_mount+0x12c/0x1a0
      [<ffffffff82f26f15>] do_syscall_64+0x35/0x80
      [<ffffffff8300006a>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

This call stack is related to two problems. Firstly, the ocfs2 super uses
"replay_map" to trace online/offline slots, in order to recover offline
slots during recovery and mount. But when ocfs2_truncate_log_init()
returns an error in ocfs2_mount_volume(), the memory of "replay_map"
will not be freed in error handling path. Secondly, the memory of
"replay_map" will not be freed if d_make_root() returns an error in
ocfs2_fill_super(). But the memory of "replay_map" will be freed normally
when completing recovery and mount in ocfs2_complete_mount_recovery().

Fix the first problem by adding error handling path to free "replay_map"
when ocfs2_truncate_log_init() fails. And fix the second problem by
calling ocfs2_free_replay_slots(osb) in the error handling path
"out_dismount". In addition, since ocfs2_free_replay_slots() is static,
it is necessary to remove its static attribute and declare it in header
file.

Fixes: 9140db04ef18 ("ocfs2: recover orphans in offline slots during recovery and mount")
Signed-off-by: Li Zetao <lizetao1@huawei.com>
---
v1 was posted at: https://lore.kernel.org/all/20221108152516.1189165-1-lizetao1@huawei.com/
v1 -> v2: Rename the label "out_truncate_log" to "out_check_volume"

 fs/ocfs2/journal.c | 2 +-
 fs/ocfs2/journal.h | 1 +
 fs/ocfs2/super.c   | 5 ++++-
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 126671e6caed..3fb98b4569a2 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -157,7 +157,7 @@ static void ocfs2_queue_replay_slots(struct ocfs2_super *osb,
 	replay_map->rm_state = REPLAY_DONE;
 }
 
-static void ocfs2_free_replay_slots(struct ocfs2_super *osb)
+void ocfs2_free_replay_slots(struct ocfs2_super *osb)
 {
 	struct ocfs2_replay_map *replay_map = osb->replay_map;
 
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 969d0aa28718..41c382f68529 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -150,6 +150,7 @@ int ocfs2_recovery_init(struct ocfs2_super *osb);
 void ocfs2_recovery_exit(struct ocfs2_super *osb);
 
 int ocfs2_compute_replay_slots(struct ocfs2_super *osb);
+void ocfs2_free_replay_slots(struct ocfs2_super *osb);
 /*
  *  Journal Control:
  *  Initialize, Load, Shutdown, Wipe a journal.
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 42c993e53924..0b0e6a132101 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1159,6 +1159,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 out_dismount:
 	atomic_set(&osb->vol_state, VOLUME_DISABLED);
 	wake_up(&osb->osb_mount_event);
+	ocfs2_free_replay_slots(osb);
 	ocfs2_dismount_volume(sb, 1);
 	goto out;
 
@@ -1822,12 +1823,14 @@ static int ocfs2_mount_volume(struct super_block *sb)
 	status = ocfs2_truncate_log_init(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto out_system_inodes;
+		goto out_check_volume;
 	}
 
 	ocfs2_super_unlock(osb, 1);
 	return 0;
 
+out_check_volume:
+	ocfs2_free_replay_slots(osb);
 out_system_inodes:
 	if (osb->local_alloc_state == OCFS2_LA_ENABLED)
 		ocfs2_shutdown_local_alloc(osb);
-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
