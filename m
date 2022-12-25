Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB734C4332F
	for <ocfs2-devel@archiver.kernel.org>; Sun, 25 Dec 2022 14:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=3loKlBXMSkmi6089imW3eMejqrPUJvlKqjq1ZeuTeXc=;
 b=lqjz9q4DYsOzIco03jcyuUpnO5fH4WFbC13N8zeGVa5aIyhqs4sKOKQo9u/X27fbP8lrGTt5xP+C
   +lcrcIvoshgE54wf616ZDzbBQj0iyz0WIz3q+kw1jBNCeCL+LSx5PddWzcZyF8aStCAL6pALvQGu
   gAW28NhaxPpAaUxEwwJ2HRiu1lNrJSAMO1AjLH/4ku2Xzze+8dcL7V/rzAR33fTNQRyJL8iSKpFJ
   dYXmiSeDA3dswUFkRi91TzDj8VX4sUfaCOLPFNkCSDYZDIxgmfLAcnPDyM9ICa/dUrS8oBBuIR03
   2NGF6YrDIocIwh5XnL045ixA3g9t/V7MJ+HKuA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=3loKlBXMSkmi6089imW3eMejqrPUJvlKqjq1ZeuTeXc=;
 b=JbCfv2HocVYeuNlE4S96o8fKwt1oTEBWoSg22JO6U4cwpRmKlXgjxNGZMtB3Zd1rYg0p0PUPB/TR
   dTftaWZLnJD2E/QWJUWBXKTUjhcXEqUgMO+xaxOerqqbSenDpHX8FMjH/4f+UtPZTk3qpOvvYZwn
   YumFXrVj/2cjrff8bCFrBI84y5TW8UKuyE2I6yF+rYJylDjHCAQxowL19FHAEzPE0F9l93TpJPbA
   ztPHliJTQ/3bilRlK7RJjDLPP7ZmDbSCNTNx/VTIFdRb0hDShIeC/pYW6EP9T6RpJP2TNa6J8+GW
   AIXDTkGmgwYJeEt7zfmaaSE8huJR+YRbHKQkbw==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0RNG003YB9NS5BA0@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 25 Dec 2022 14:02:16 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1671976916; bh=1E/4NXvqexIq72i2+ymXabgNYv04seB9B6SerPgBYJQ=;
 h=From:To:Cc:Subject:Date:From;
 b=pRR0sCkJ4agTtol5/+MS88K+emXvzwID5aW39hs19gkDmmqqvjXlm0ZPS3IsO0xb8
 Tv98Biu7g7uOtjQgIUCETid0FIPo0OVKlWS2HpwASfvN0jhnhdYILdEj0EWcd2+tx0
 oSXD4TkjysI+hKl1Y5veaS9aOGxHoY6Dw1k1lXchzOB0qSbkYjjNweIQzy3tREum4E
 ff8NpfI+6rACMuPMzGfVUIjBdDYfjXiA7+Sl8pH8j49zFBQ4M0GtQ9+vAEYy+5YKLe
 GFeWZGycGYS8nlIU/Pk9UMVNNZ5Uef258HHi5468OQPi0Xotl40vMMF2HiKXn/w5Ob
 wVyzgC6l2C9CA==
To: stable-commits@vger.kernel.org, ocfs2-devel@oss.oracle.com
Date: Sun, 25 Dec 2022 09:01:54 -0500
Message-id: <20221225140154.636753-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-version: 1.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10571
 signatures=596816
Subject: [Ocfs2-devel] Patch "ocfs2: fix memory leak in	ocfs2_mount_volume()"
 has been added to the 6.0-stable tree
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
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.kernel.org ~all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-ORIG-GUID: dRogE_83PyVHWwwlkcnsDFiIvUfBsu2W
X-Proofpoint-GUID: dRogE_83PyVHWwwlkcnsDFiIvUfBsu2W
Reporting-Meta:
 AAEVVpoq0kxurzgLKn2Tn5BQ2U+8PgI5C0cU0WMNRIXQVFfo+PH2kS6O1Ve2U3nM
 ++GKIa2wG1cGSAOflp0kh/Yz7lzijdmsYlhcRlTk5TUdAMRYuayQsWtlPYJMkFW9
 pcB3fDfe3AG3hRd73MOhKnHCcpALOS82S/SIF6oxOQSUGyF/bCyH6VureCuNItW/
 9mtouir6Gy9mPmIrPf8t1yBJOfbt6O+L0z29BdPB3XmeY0WTwd1LkyLDSP5JEYTS
 Oq4fRyGzrXSevjiOqXk1vYRbxl4iq9+DA7mbzzAajhXVJC6VE71crR6tdPPyBW64
 SwKsu0pk++5kIrw0w4XYJFRai+5DhXsPsTW6hM93DASmp4g1NhBw99ziWEtNTKKW
 fHS3iB+TPjpb0T/fpo4cbVRJPFYFPYdiMAA1XuPFoUoKgbqZZ2KTbme0nhiV47sh
 A7K9EPvh2uevgMhbXxeLsWJxl5KA/JLS5w+2ZKewG/9Eg+InMneDsj2KKOZbyXSk
 f0ZNkk94r/ti3ISOjriMRt1EkDg/9gqlETNNOXGBUaE=

This is a note to let you know that I've just added the patch titled

    ocfs2: fix memory leak in ocfs2_mount_volume()

to the 6.0-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ocfs2-fix-memory-leak-in-ocfs2_mount_volume.patch
and it can be found in the queue-6.0 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 9e0b8249d0f7a37755ba170d7ea5769f5e2d869b
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
index fa87d89cf754..1be7d440eff3 100644
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
index e2cc9eec287c..78441e466e6f 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1159,6 +1159,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 out_dismount:
 	atomic_set(&osb->vol_state, VOLUME_DISABLED);
 	wake_up(&osb->osb_mount_event);
+	ocfs2_free_replay_slots(osb);
 	ocfs2_dismount_volume(sb, 1);
 	goto out;
 
@@ -1824,12 +1825,14 @@ static int ocfs2_mount_volume(struct super_block *sb)
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
