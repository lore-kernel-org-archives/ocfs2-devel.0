Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BBBCC4332F
	for <ocfs2-devel@archiver.kernel.org>; Thu, 10 Nov 2022 01:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=PMZc0qgN52cDtIbR8Yrxn5D2IwshZh15lexIPIjJCyU=;
 b=ZOjwHomHJGWfKwjABHxXXuKliWUOsGvliIboiUDbZ4yInKnWt7szxybHLliexpbF4ERLbdZLApwr
   W50tx6pp3WT0E9PHhIw80xgeaS/VdUYABDemBAtIfb/2c4VQgYwCKrFhnXJr4UO8lZ7xA5QlAXTA
   EjsG0upQYgmr+L8uJGQCMYHxPTOYGgXP8/GS6B68zdagNvpEcRoO381WVXUoh46VhGBs4tjoWGL1
   BAoSYL5WR+3YQa1NWnkHixb8aoKzetCr5Zohxd19G0sfA6Gg7liWpId42QonfhIz4d0KkQdLU1Zd
   uUwHxKDDD8DdY51IAdMkmraX1xbPydQwIRBfFg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=PMZc0qgN52cDtIbR8Yrxn5D2IwshZh15lexIPIjJCyU=;
 b=gjTYD+wDzcsLgtaWbhSCtR8z36G/3aYR9KA5q4EhADVI98BLtI+boF1ffkEWxORNsHGd5OjrJhgl
   m7AMXuZKyKpNmoxk5DmzZ5a5VPP64lhds43kUCSJLCQvVFOtN3B219S/zf5opb5oqvBHInb1Qud3
   rdBAdEUUXZWT32bz66crfXTgl7z8db6Ba+L18LeBSFUJPW0UBIs4mHiBYpMNDyMziKbNB8sGWklM
   4tUY8hcnm6i+pdpD1KwfSnw/wk5fFOJ321FL6DtafFyVU9EuKQjntZBrUtpI4KGPk3X2BDc+opNJ
   43ZbDHg7QQuYdew7zQndAvj2qd42w5aMhrZ2Vg==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221026 64bit (built Oct 26
 2022))
 with ESMTPS id <0RL300184Y99VVC0@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 10 Nov 2022 01:17:33 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1668043039; bh=rrmLSD1CznvpqjAYOO7eoD2OG4Qn1k7BzctmXYXE3Ek=;
 h=Date:To:From:Subject:From;
 b=P8f6rS/FFpmJ3RgHM81hWdOUH3/iD3lCTDneDSorIcVUnN4yk3osxqOziGNo7yUyI
 i+FPjq6Kwy1p8sg0wsjOZLIbzzJlJInvDX5EQL4EqWnTfkOzbwr0OeYV1GGn83/xxo
 l8CeoADk699FzB18InQKed0OqwKhT7bwTli9dkCA=
Date: Wed, 09 Nov 2022 17:17:18 -0800
To: mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
 lizetao1@huawei.com, junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
 jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
 ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org
Message-id: <20221110011719.55EA1C433D6@smtp.kernel.org>
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10526
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 spamscore=0 priorityscore=203 mlxlogscore=999 malwarescore=0 impostorscore=0
 adultscore=0 clxscore=133 lowpriorityscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211100007
Subject: [Ocfs2-devel] + ocfs2-fix-memory-leak-in-ocfs2_mount_volume.patch
	added to mm-nonmm-unstable branch
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
X-Proofpoint-GUID: 6uzXEUHmpfQlePFH_oFEUnhV4mpXQIla
X-Proofpoint-ORIG-GUID: 6uzXEUHmpfQlePFH_oFEUnhV4mpXQIla
Reporting-Meta:
 AAE003o51HE15jp3Psse0wfkMOshF5ZAzsdXlaKIHZcgswFEOQsZxAXQ+zmn4YVC
 UrKwqHOlkt1nvnIay6245uwzFMH4x2p2lYz5HhZNzSLZZysB1iDXgjkMzOHbD+mZ
 ccFj9jvEkea7n59D4c6HW1DuQ9jYHwS4+L0ixEqiFOVJhteuefKjmRdVUb0F1NQd
 qLER3IRX0K3F8H6pUHtKmc0zwT0NSwP9XkRZi9t7Z/3hF1thxe5gsRJ5yj1PRE8K
 yP/Ij+Uea2B8ENsDCZykenUxELoolG9PNuOxVKhcRxR3ogfEpsbzCiczLmu0Zw9w
 O67MLUTo3sOjJKT2glxEI5pEmUAqAFzm+wUUyGDdhXGgbicZKvCgt4qCyVVrTPOY
 9EBdcTyNTP0MzMa5T/3zDKp0a5WaqDGax2kTBk2w5tZdCPao6tlcKQ4XbXq3Q889
 a+wnux4F9RvkZZif43Oed9djdKd4G0EnJxx//aWT9j2hJ6OVnckvm90JGlHmwxwv
 WHXAK+AwUmf3zq2mu/FtmK9X11S2clXsZT8faQmm/6lG


The patch titled
     Subject: ocfs2: fix memory leak in ocfs2_mount_volume()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-fix-memory-leak-in-ocfs2_mount_volume.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-memory-leak-in-ocfs2_mount_volume.patch

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
From: Li Zetao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
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

ocfs2-fix-memory-leak-in-ocfs2_mount_volume.patch


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
