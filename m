Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 854B2C4167B
	for <ocfs2-devel@archiver.kernel.org>; Sun, 25 Dec 2022 15:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=CC1SXij+YubOf03u3d0S4n6Kvxaq5NsNJNMJt2dNSgI=;
 b=t8PxD3tkMs6M2/nIdZyT7I8vrHQhBWnZJ59ReQjkV08T9X2vKdZSJSOy4BLCjKvY224bzkwBCoic
   4Uops0Olz/75MCgthDns25dh5p7NdFKOcFVD9OS8UrmIsVNl6IaoJybPDjSbju1ZayKYY8xpsi9R
   B9wugJcvAHKLAo3e03SSwws/y683FyEX+o6vd2Mk/6/sp+YQ6e50QmTaHUoG/gROfeUui81XuAuv
   1qlFVJhyFKFGP3Ar5TutYV0yGEcJKhP2rkd2oKm6rOIqgtgxN1MkSyv1rzy9pd+zgqww1MfO/rsY
   27HWAjsRQ+FxyyzKfABAhDWf/eaHWVYkPOdVkg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=CC1SXij+YubOf03u3d0S4n6Kvxaq5NsNJNMJt2dNSgI=;
 b=tRxaBnyz5PfAxLJ89Ef4dx6yVZrvzwBjW7sHmL99+6pH/DmYKM/SFpRfSfxT13CD3v8WcbBsYfz5
   8WJ6JxYasx0FDJqGp2UWAHv9EUS2w03H5NdI468R4QXjjaSuImUqtNoEWfpalint1aB0gR6xQAU3
   gm1clrXkMSFh1esGdQIIzZZsRDyRsVt9Ped1HGothjTg8gEnihkPv7BbWI9s0/a6gT4PrlB8/xkr
   eFrGI99xyYp70EprXVTaKhcjW+uxwl4CYHoc+wER5U/+Rf8J8eNMtad9PBWpcHyMOZLFQ169Fiji
   jFb0xqtvShj3pu0o68y4W6/08Q/oQ6kbuzRvJA==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0RNG00HBED7Z2650@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 25 Dec 2022 15:19:11 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1671981535; bh=eSgJcXqr4vh+BjGLANRdgyef9+Q5+64QtAjmhFwMdZU=;
 h=From:To:Cc:Subject:Date:From;
 b=AcKlOU8dn+SA2FlInw12rCRimdwrASkWQ2SazcOBDHNY+dVs4vFgVUiy8YLBFnLqY
 tzEAbLM//sPMsfrG+IYMWJwXEsL116iLE0vHvyZfcvII7Vin5EY6lCmMAVRdQ8qoxP
 J5/wnpwJTt3ZCybtAqCjcDGcv4oEUr45Xu5yw8ZKBanR+UYQWEkxekJnLQ8btmrFnM
 jN/mH0t32Ov9mZvnDal1cW3JRen5Qk9lIdmEqfk7L3x1DkFrF2XTZp8YGyVNwwRRNb
 fLMmCQj2Mnd40aafg4orFhA32FMOM6t1t5NizMRsWDbv53MxJ//iNBoV3zqu81G6TY
 WFdn7WPSbQIZg==
To: stable-commits@vger.kernel.org, ocfs2-devel@oss.oracle.com
Date: Sun, 25 Dec 2022 10:18:53 -0500
Message-id: <20221225151853.699350-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-version: 1.0
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10571
 signatures=596816
Subject: [Ocfs2-devel] Patch
 "ocfs2: ocfs2_mount_volume does cleanup job	before return error" has been
 added to the 5.10-stable tree
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
X-Proofpoint-GUID: 2YBQixMf5dZasrb-lZXA-ihMK0cvm5yh
X-Proofpoint-ORIG-GUID: 2YBQixMf5dZasrb-lZXA-ihMK0cvm5yh
Reporting-Meta:
 AAHbv1OxW1UI11pID+RMIhkXXPBPD/mK/pxoVwZmL0FK4HMTxvXk8nwsv40Iwnqj
 A4ftE3j1J/2u9m21+mM5/ZPcfjswQB8JvnAMXTqJnCncgd1lNNyLspwWN8pmOoLt
 PuxKsBmMT+LUwRdry4sOLaO3QbEE13Gssy+DwElOa7XjPc2swZS1H0FCeFJYWjnF
 kvIwly7MWqS3yLFdgWHOZeIrD6TE60rvfnWFGXAhGWoxCoxRb67SY5cQrWibb51K
 6XWtwAzgiPSLfausJqKakyqQ6i8y632xty7xN/GupYB2Jb+3Opfv+UphCK/bE5DZ
 7xmrj571mGlvm1buuX7xw80X/loZZapWDEoCnbmNOVU/nnUEc19Nm+Dh1sXpsYF4
 i1jCz5/DL9Llfa71YVbH9C/cThL3XfakvTrgzpi0ShQ3+SLQA11qS9j3ZXzqUAru
 6y5B1LrS6nuIvJFmkQQwYy3uxFv4EbmCyPb39A71u/76qO6JI5hDXXssqi2GMKQq
 Emf1ZdOPQcTztcdVfZyR0YYc9ie9jG3/dLNafK25t+9J

This is a note to let you know that I've just added the patch titled

    ocfs2: ocfs2_mount_volume does cleanup job before return error

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ocfs2-ocfs2_mount_volume-does-cleanup-job-before-ret.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit a8d92e3c8f5227ad605c9980bee552fe5ebbf9fe
Author: Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Date:   Fri Apr 29 14:37:58 2022 -0700

    ocfs2: ocfs2_mount_volume does cleanup job before return error
    
    [ Upstream commit 0737e01de9c411e4db87dcedf4a9789d41b1c5c1 ]
    
    After this patch, when error, ocfs2_fill_super doesn't take care to
    release resources which are allocated in ocfs2_mount_volume.
    
    Link: https://lkml.kernel.org/r/20220424130952.2436-5-heming.zhao@suse.com
    Signed-off-by: Heming Zhao <heming.zhao@suse.com>
    Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
    Cc: Changwei Ge <gechangwei@live.cn>
    Cc: Gang He <ghe@suse.com>
    Cc: Joel Becker <jlbec@evilplan.org>
    Cc: Jun Piao <piaojun@huawei.com>
    Cc: Junxiao Bi <junxiao.bi@oracle.com>
    Cc: Mark Fasheh <mark@fasheh.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Stable-dep-of: ce2fcf1516d6 ("ocfs2: fix memory leak in ocfs2_mount_volume()")
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index c0e5f1bad499..ca0d6debae97 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1787,11 +1787,10 @@ static int ocfs2_get_sector(struct super_block *sb,
 static int ocfs2_mount_volume(struct super_block *sb)
 {
 	int status = 0;
-	int unlock_super = 0;
 	struct ocfs2_super *osb = OCFS2_SB(sb);
 
 	if (ocfs2_is_hard_readonly(osb))
-		goto leave;
+		goto out;
 
 	mutex_init(&osb->obs_trim_fs_mutex);
 
@@ -1801,44 +1800,56 @@ static int ocfs2_mount_volume(struct super_block *sb)
 		if (status == -EBADR && ocfs2_userspace_stack(osb))
 			mlog(ML_ERROR, "couldn't mount because cluster name on"
 			" disk does not match the running cluster name.\n");
-		goto leave;
+		goto out;
 	}
 
 	status = ocfs2_super_lock(osb, 1);
 	if (status < 0) {
 		mlog_errno(status);
-		goto leave;
+		goto out_dlm;
 	}
-	unlock_super = 1;
 
 	/* This will load up the node map and add ourselves to it. */
 	status = ocfs2_find_slot(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto leave;
+		goto out_super_lock;
 	}
 
 	/* load all node-local system inodes */
 	status = ocfs2_init_local_system_inodes(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto leave;
+		goto out_super_lock;
 	}
 
 	status = ocfs2_check_volume(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto leave;
+		goto out_system_inodes;
 	}
 
 	status = ocfs2_truncate_log_init(osb);
-	if (status < 0)
+	if (status < 0) {
 		mlog_errno(status);
+		goto out_system_inodes;
+	}
 
-leave:
-	if (unlock_super)
-		ocfs2_super_unlock(osb, 1);
+	ocfs2_super_unlock(osb, 1);
+	return 0;
 
+out_system_inodes:
+	if (osb->local_alloc_state == OCFS2_LA_ENABLED)
+		ocfs2_shutdown_local_alloc(osb);
+	ocfs2_release_system_inodes(osb);
+	/* before journal shutdown, we should release slot_info */
+	ocfs2_free_slot_info(osb);
+	ocfs2_journal_shutdown(osb);
+out_super_lock:
+	ocfs2_super_unlock(osb, 1);
+out_dlm:
+	ocfs2_dlm_shutdown(osb, 0);
+out:
 	return status;
 }
 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
