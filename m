Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E6D0C4321E
	for <ocfs2-devel@archiver.kernel.org>; Thu,  1 Dec 2022 00:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=e+hlABoG/0wYoR7IlBHhkoO0p/T+XKACdR8F7iONRMo=;
 b=w2quDlpNGm1rMG7R221VmpusZhozAi+oP3NAKTU1hP/Gak43M5xOLxfbzsmA4o5hND4V+B6odCuF
   DNSMDsuzk62CZ6d14GOYqLqinLyIoAdf1e9RxaDu9MUDvEQMqZ5Dosqbf6ZVcysSHe86174dCfSe
   TEHnc9+qxrSiadI1LrymtmMEvsTAnp2Ah1YjbG4CBI07AhuhM2V8hrJeY/B9mbRb0rLBrehDDXlg
   EIe2Y8ZDg5aQLAgy8NK/1/xvSW0GoXQmT1Bi0HExC8wLsI/XBUW+l0r4U8ork/OyMgSpMZJAMCjR
   AGI/HUWz+vmPU89jC6SLmwnepzYcwwRHC0ZPJA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=e+hlABoG/0wYoR7IlBHhkoO0p/T+XKACdR8F7iONRMo=;
 b=QggjF6l+tpmqf0mNtXUPQz30bvH0Qt+QD2MeFOUQUmtQgPXNmaU5dd4xEDfqTrEN+2JySBMEuSYR
   AyfdpPVSIqp3l9E+BC0zyhm6QhtTpkMQLCUfPrro4M1e2cwXfGxAAPo/da5IsiqoHYxgyv+V1E5T
   jUXP2iYs3XBCqdM1ikNhNfrmPKg8qumlYfDcbK9QRKfUUcNB2ZaATPC4E1ClMm0jccRnd5xsciTW
   DnfPP3LgnbO3puEoIUt+My/ogHKhEePBoH/RO0yHryUZvc5Hz46YCVoPQM/rHL4tiYXDpAS0g/GT
   jTMMvQLEdJJcw5IMvJCq16/52Pls36yHk5II6A==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RM60089JRBNUE30@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 01 Dec 2022 00:14:11 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1669853636; bh=0OhAu01vv0kYa7FKw/IW1S0uDO7kQWYkNxIigKNdTJs=;
 h=Date:To:From:Subject:From;
 b=wMKpgrJQtTZD2hiRpRwNfIPjDmIuyNY9WMqWG/cU1idhJHrENmzttBOofoejgbGmA
 A2ltU6WiqiHhWdejgP92IyDQn+iQ4KBLGoka9UOb3X3kaIWFSxfhorZICUq0B3n7Rb
 fimFx01vezdUg2VSRTl7WoaDZcH7AT/rR6gyZGBw=
Date: Wed, 30 Nov 2022 16:13:55 -0800
To: mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
 lizetao1@huawei.com, junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
 jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
 ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org
Message-id: <20221201001356.7B77AC43470@smtp.kernel.org>
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10547
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 malwarescore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 spamscore=0 priorityscore=143 mlxscore=0 clxscore=247 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211300172
Subject: [Ocfs2-devel] [merged mm-nonmm-stable]
	ocfs2-fix-memory-leak-in-ocfs2_mount_volume.patch removed	from -mm tree
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
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:140.211.169.12/30 include:_spf.kernel.org
 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-GUID: _qY5_lHnV4InqRfnBMY8AUR44G_FkBUf
X-Proofpoint-ORIG-GUID: _qY5_lHnV4InqRfnBMY8AUR44G_FkBUf
Reporting-Meta:
 AAHV/NeRtm99ztB8oEbo7Py27WdizoU21lS+I6E7e17JEulSp6djmVupsR/UzGwO
 0cVjbmNGNqE79qtUA5HDOLrm3XZXcC3h86f9GB+nHdkpr0N1g+z/SFLCzc9x7IhV
 ViYukKQVNXiVepi2PMxt9tdoe1eqxOXQNkeCVf77t0S8JD8Tp+Mc3pra7wscPNWm
 YipnLbsG2lkGjVS/phlYQqHu3fNEtmwEU0QLfDLfu0QrSje1CoFKUVQP4g3s9E+M
 rh6VLmAVnagFy+rFT7MItsyUTQ2fOgIALgVdI5uGVPbvXn8CGubi1viFI+TG3UV0
 wIB4gQbLNg6ipEJsmLZ2+scYY6TtTYfiklOkXd3QITZ1Cv2Ue8sEKkHt9fh+PSZ/
 lld7pM9bLvsEHlQ8PA72ytucDD+lyhCuy4n3m8NYRSr455M9BH3opBkNQHflhmPN
 7UGU2oxui5g1sRQW3iGoiZ3iL0zwm6il5k/api0sFcoAfigTJQdj2iWnR5B49qUb
 3jo3i7k7RuR25X3ukgfjeNyWVW4AjZGsP48+YlhH29uj


The quilt patch titled
     Subject: ocfs2: fix memory leak in ocfs2_mount_volume()
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-memory-leak-in-ocfs2_mount_volume.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li Zetao <ocfs2-devel@oss.oracle.com>
Subject: ocfs2: fix memory leak in ocfs2_mount_volume()
Date: Wed, 9 Nov 2022 15:46:27 +0800

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

This call stack is related to two problems.  Firstly, the ocfs2 super uses
"replay_map" to trace online/offline slots, in order to recover offline
slots during recovery and mount.  But when ocfs2_truncate_log_init()
returns an error in ocfs2_mount_volume(), the memory of "replay_map" will
not be freed in error handling path.  Secondly, the memory of "replay_map"
will not be freed if d_make_root() returns an error in ocfs2_fill_super().
But the memory of "replay_map" will be freed normally when completing
recovery and mount in ocfs2_complete_mount_recovery().

Fix the first problem by adding error handling path to free "replay_map"
when ocfs2_truncate_log_init() fails.  And fix the second problem by
calling ocfs2_free_replay_slots(osb) in the error handling path
"out_dismount".  In addition, since ocfs2_free_replay_slots() is static,
it is necessary to remove its static attribute and declare it in header
file.

Link: https://lkml.kernel.org/r/20221109074627.2303950-1-lizetao1@huawei.com
Fixes: 9140db04ef18 ("ocfs2: recover orphans in offline slots during recovery and mount")
Signed-off-by: Li Zetao <lizetao1@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.c |    2 +-
 fs/ocfs2/journal.h |    1 +
 fs/ocfs2/super.c   |    5 ++++-
 3 files changed, 6 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/journal.c~ocfs2-fix-memory-leak-in-ocfs2_mount_volume
+++ a/fs/ocfs2/journal.c
@@ -157,7 +157,7 @@ static void ocfs2_queue_replay_slots(str
 	replay_map->rm_state = REPLAY_DONE;
 }
 
-static void ocfs2_free_replay_slots(struct ocfs2_super *osb)
+void ocfs2_free_replay_slots(struct ocfs2_super *osb)
 {
 	struct ocfs2_replay_map *replay_map = osb->replay_map;
 
--- a/fs/ocfs2/journal.h~ocfs2-fix-memory-leak-in-ocfs2_mount_volume
+++ a/fs/ocfs2/journal.h
@@ -150,6 +150,7 @@ int ocfs2_recovery_init(struct ocfs2_sup
 void ocfs2_recovery_exit(struct ocfs2_super *osb);
 
 int ocfs2_compute_replay_slots(struct ocfs2_super *osb);
+void ocfs2_free_replay_slots(struct ocfs2_super *osb);
 /*
  *  Journal Control:
  *  Initialize, Load, Shutdown, Wipe a journal.
--- a/fs/ocfs2/super.c~ocfs2-fix-memory-leak-in-ocfs2_mount_volume
+++ a/fs/ocfs2/super.c
@@ -1159,6 +1159,7 @@ static int ocfs2_fill_super(struct super
 out_dismount:
 	atomic_set(&osb->vol_state, VOLUME_DISABLED);
 	wake_up(&osb->osb_mount_event);
+	ocfs2_free_replay_slots(osb);
 	ocfs2_dismount_volume(sb, 1);
 	goto out;
 
@@ -1822,12 +1823,14 @@ static int ocfs2_mount_volume(struct sup
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
_

Patches currently in -mm which might be from ocfs2-devel@oss.oracle.com are



_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
