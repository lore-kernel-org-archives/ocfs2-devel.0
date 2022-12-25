Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CF45C3DA7D
	for <ocfs2-devel@archiver.kernel.org>; Sun, 25 Dec 2022 15:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=LloTIucrLuW2z45UZg6Xcy0zXfd7YN3e8e8yGRFDKFc=;
 b=ySR/udd1iiC1n1vPES46mvRbEjXRhGLQTWbXEUOXmrUi4Gz4iGo8wRy70M4p5n1YY/GCWZTkffpV
   GIvM7DjPryHOOF0V2vcLHHCj6HCenMkgO6w9Qq0HkhHBenpx9QSB6Gho7diw13Qvyuhau070BTbE
   4Mw/1zoewz3cWg9kT+04fpzzN0IU+Kg7nUSwpnw5QyZzMUURw2c4R4KsdUz9JlH8obPpToRR+drQ
   db7VE6BlYfZqUGE+uW+yepeKuzuHkGYU3e4qL2ZqM0uT9/JHHm8bKNapRV3b12cmhHcKrJVbw3xd
   ycLsvuyOUAJLo2Iu2mViMgT/jySAZhhaT1P2Qw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=LloTIucrLuW2z45UZg6Xcy0zXfd7YN3e8e8yGRFDKFc=;
 b=hcYlGMvy79jKOBnmhGyBYoZ2t7NQHvPGzPRKocaG5phQtzMkBruVmnWcxpaCrKpMFTJIaujbByEo
   OCqhHtshmTnR/8ExYI8xCoefhg4H1nQemDrw/ws+9W+iTFU5JvMfENDPa92WEn5yADRkAtohKorF
   7H2TMmrcllZDIw4aqbU7i5zVhW2djtQVbBRF1AXQIDxmb7SFFpmgW76R47ybKj405s78P9MDNVWL
   sV0xEWhyEHcBthYdwGdZEJ9UGmUW63cdtrU3AlI98P78Nw7MLBUeqG3L66YVf5QHnWzDqWraxqSu
   3O9XTjhMSATCuppclag9UaYOczFZApzwiQVTmA==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0RNG007IDEDDEQ30@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 25 Dec 2022 15:44:01 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1671983024; bh=NB0TszNaXOcEnW7TenVIKEgG9YbITx0XHGFT34Wc2TI=;
 h=From:To:Cc:Subject:Date:From;
 b=s8PWWKk3tOACEsaduDO3F4iJNOqPi6+C1OuaSEdbRxr4/q8WS2QPJCWPe4o0YzCyL
 xGtd79ZFqlqfqVj4Aw1RXUsA1My/1hr28jNpCsNr5RsGo284I1mAlzlyT7P4G3d1eD
 gHkUvDYZ7NllzL6uF806k/hrBL7rawTOE5D0n/N16dtqNuG6lpEcq3V0eqk6bV2lTl
 ZuGNYCRXugH6J16Lmh5JCX3/OiEoMs5gm4xfCJm20jZDROKR7C/FhVzy40qZYQr+sK
 kkmQ7V5MD44tnE4tOrDVNbOndwxM/dO314dCwc6DltRj7qgebx6U3mj77Ct7CH7guj
 TA52uhnjlmYKQ==
To: stable-commits@vger.kernel.org, ocfs2-devel@oss.oracle.com
Date: Sun, 25 Dec 2022 10:43:42 -0500
Message-id: <20221225154342.719823-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-version: 1.0
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10571
 signatures=596816
Subject: [Ocfs2-devel] Patch "ocfs2: fix memory leak in	ocfs2_mount_volume()"
 has been added to the 5.4-stable tree
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
From: Sasha Levin via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Sasha Levin <sashal@kernel.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Patchwork-Hint: ignore
X-stable: review
X-ServerName: ams.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.kernel.org ~all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-GUID: _TX9NFISaW2e3Q-r7LyhYDGqPGE-7YA3
X-Proofpoint-ORIG-GUID: _TX9NFISaW2e3Q-r7LyhYDGqPGE-7YA3
Reporting-Meta:
 AAGKuqqKrRU/iIveNhmYFBqAqkZcV22mZalpOAiT7M99aZVmZNH2goxjAhk1q12V
 +SI0QkHV8QF+KM4PyT/xB9gJSDoWSc/CjeQLYIAR1Q2Y1fO+ZQtAXiSFJoPzaKzA
 Ji+Jz0FFu5N18rUadaLgR3+74B3x9teWunFX1B6CnGNHONWW3S3wzjkCjMHzm0QK
 zoC3Bj+ghuzhQjeOtGkwclvFiaSSasmyC+1HLU5+Y6bQPH9P7VG2TPQDcEf1pdrc
 2qd6jY6k71o3U8nUKjmoOUKTvode2aR7IKIei8vxoxAhgH1BskEgYM6n/F+8p1Dw
 Ob9IfeJRk7sUAnMU+Wyrr6pIMzw7j4qMVJLr4yXapgAXvOQbsRzeGR7QdMyu5DBH
 NY2Ubde26BJTq7V3CghW2g4AAVQti86AgWciSz/jM8HRbeFEhAsUj05qgxR5Y7c7
 hGyVqzlj8SY1WyxYQIT8IsexLEecxWE0CBJyqeYrbvkatjX8f04UyHO924X6QxFw
 Dz6ZKwYr3zzIDiZFeHvTvL1wrLqiNGa2u0EUJ+eTd27n

This is a note to let you know that I've just added the patch titled

    ocfs2: fix memory leak in ocfs2_mount_volume()

to the 5.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ocfs2-fix-memory-leak-in-ocfs2_mount_volume.patch
and it can be found in the queue-5.4 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 0f71861b1bc50b2e0910e7a3634bb367ff2a6ad8
Author: Li Zetao <ocfs2-devel@oss.oracle.com>
Date:   Wed Nov 9 15:46:27 2022 +0800

    ocfs2: fix memory leak in ocfs2_mount_volume()
    
    [ Upstream commit ce2fcf1516d674a174d9b34d1e1024d64de9fba3 ]
    
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
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 900e4ef686bf..da95ed79c12e 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -159,7 +159,7 @@ static void ocfs2_queue_replay_slots(struct ocfs2_super *osb,
 	replay_map->rm_state = REPLAY_DONE;
 }
 
-static void ocfs2_free_replay_slots(struct ocfs2_super *osb)
+void ocfs2_free_replay_slots(struct ocfs2_super *osb)
 {
 	struct ocfs2_replay_map *replay_map = osb->replay_map;
 
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index bfe611ed1b1d..eb7a21bac71e 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -152,6 +152,7 @@ int ocfs2_recovery_init(struct ocfs2_super *osb);
 void ocfs2_recovery_exit(struct ocfs2_super *osb);
 
 int ocfs2_compute_replay_slots(struct ocfs2_super *osb);
+void ocfs2_free_replay_slots(struct ocfs2_super *osb);
 /*
  *  Journal Control:
  *  Initialize, Load, Shutdown, Wipe a journal.
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 38e51868c2d3..bf4291e0c6bf 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1164,6 +1164,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 out_dismount:
 	atomic_set(&osb->vol_state, VOLUME_DISABLED);
 	wake_up(&osb->osb_mount_event);
+	ocfs2_free_replay_slots(osb);
 	ocfs2_dismount_volume(sb, 1);
 	goto out;
 
@@ -1829,12 +1830,14 @@ static int ocfs2_mount_volume(struct super_block *sb)
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

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
