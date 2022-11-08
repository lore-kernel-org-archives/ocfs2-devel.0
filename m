Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DEB3C43217
	for <ocfs2-devel@archiver.kernel.org>; Tue,  8 Nov 2022 16:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=oUZZx88ijTH5dtJU+tXUuWTDrVUjdL8/Zm/B3cthYv0=;
 b=H4yWJRkEz7Om6tPqYD3ZGUTCtAS2f/eNELIuC1vUxfmGJ14dURG5hlngl8VMHQq3wCUbJMP88tiQ
   3WL6fzkp/Mnx34VPq8HJbFsvZgQzXyrI2w2g7Os0CPbFi5WCMKq44GPuRHXbyutyHTnMM6xeuGHs
   v40Q4JbRDStOKSSosGbClJ73IfAR8JRl3o5PdtOcYU6+d++2h7rySsYzdk6Bo62Gnl7E+/2gsceo
   77yTjxA7jcRDKJKDHdix0asKuBk7QRUQPB8qDurNWL6F/VeFrpczHm741xXoP+d1BFraXBaSTqA+
   exCLRFRVo7otimkKUJ+0EmbgOm4OKNsxFkS++w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=oUZZx88ijTH5dtJU+tXUuWTDrVUjdL8/Zm/B3cthYv0=;
 b=jLV/LgtxhDVQBGCHp4ZbTsR/xKSI81N76DTFc2GRgHq8WTpdi/OYZvloBbRWhEL684dTJ/dV+93A
   q1SLgMaimzGCq79K4M32PmSJPKsG4zuNkYvOhj83JyqyI9i9jMv+w6MJHaeo3muCdDtAtlELJVCz
   Ax0HNs6Cu9/r5DlvxmXzM/OdMDmzjl07kdHFRLRWXB6GI91oqWwU/14WyRE4riWKDk7n66cx/LSs
   /7QFpFxJ1I7NMKWb7Z3g9sKqX3+bWFVNCbWJEZ7RyLmgbeRODZX6UBBF/KKq2lMhuco4Ltky8iVz
   x9rVyw1l2s0SkAFqeNhVsG58Yo/zQUB7N+QezQ==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221026 64bit (built Oct 26
 2022))
 with ESMTPS id <0RL10094UFF1ZDA0@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 08 Nov 2022 16:35:25 +0000 (GMT)
To: <mark@fasheh.com>, <jlbec@evilplan.org>, <joseph.qi@linux.alibaba.com>,
 <srinivas.eeda@oracle.com>
Date: Tue, 8 Nov 2022 23:25:16 +0800
Message-id: <20221108152516.1189165-1-lizetao1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-version: 1.0
X-Originating-IP: [10.67.175.21]
X-Source-IP: 45.249.212.188
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10525
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 bulkscore=0 mlxlogscore=999 priorityscore=194 spamscore=0 suspectscore=0
 phishscore=0 malwarescore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=8 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211080088 domainage_hfrom=8337
Cc: lizetao1@huawei.com, linux-kernel@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix memory leak in ocfs2_mount_volume()
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
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
X-ServerName: szxga02-in.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.32 ip4:45.249.212.35
 ip4:45.249.212.255 ip4:45.249.212.187/29 ip4:45.249.212.191 ip4:168.195.93.47
 ip4:185.176.79.56 ip4:119.8.179.247 ip4:119.8.89.136/31 ip4:119.8.89.135
 ip4:119.8.177.36/31 ip4:119.8.177.38 -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: KwRS-cUHhOAUreO3bdugMm-GG5AthGmH
X-Proofpoint-GUID: KwRS-cUHhOAUreO3bdugMm-GG5AthGmH
X-Mailman-Approved-At: Tue, 08 Nov 2022 16:35:23 +0000
Reporting-Meta:
 AAF0gYfzEr9HPG3N6PtrAxUIR7lkom+Fh3eLMJaoKkFulb/XCgVtravWDDV1UkQ0
 PuSfwHzZeVB7ATza5E+4fDwvhXA/eoMPH1joURFLunII4HCcJvOoRQ4vUHg/MUhR
 P0ENuJq2Y9FS2ixMieTPqZLKyXIeDSIzM1zlFNtzCcIswDfy/DWAHQ2oVS8GTaZ3
 2ISKhACk9MhtVbdI9c7pjKlHmB25+Sq9TErMPFaeNH0UA/NxUi1/+BRmh0UHicmq
 gy6YadEmsgjCJT45zfpv604E74lmerwy79dwvhiQLXSyi4GEehvkmoeC2kQT1L2r
 WpznSWhf8nYtRFK2fj2B5dM7Bs2JPkMnhpYRuigRqAW54DGRpGjeDZEBQT0fMDFv
 daqIHHfnopKqZnxsoYiYWOBEJ1vWGeZQQLus5UiYWwL0sxD++AnHh8wih04zuiN/
 dMMmkHHKJ17z2tnKwronwe3vAYPty5nqXe9snYlUJOfPmKhBaJXtGRzHSbArb1/l
 q0pqRDr7JeNqhta1VDSio0jYptUjBMJeuq34eU1OthY=

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
index 42c993e53924..f8041aebe4ee 100644
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
+		goto out_truncate_log;
 	}
 
 	ocfs2_super_unlock(osb, 1);
 	return 0;
 
+out_truncate_log:
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
