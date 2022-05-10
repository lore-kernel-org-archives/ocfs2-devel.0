Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A606C4332F
	for <ocfs2-devel@archiver.kernel.org>; Tue, 10 May 2022 04:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=M2AgnfvpQXnmARQ3E6AtL6EB8iC6Fu7Wj4D/aS6SYBE=;
 b=rNxS+OGYad2dTlyfUZPt1St1a4HJOX4r4NZxaZgnNYw8Ejbkr4UfzFSAvh4jZFnNOQLy+Khc2d4y
   pfGVRlzCErFhAs3+Rwxt+XDciWUp5rlNNs5uLdhKaZ3J28MGuGIwMxv42Jbe6al+8PwmoQVUqPSw
   EMDh2IhD5viI7tEZKPFJp1ufbTfq9wWOpDbIFj0h64DFsGVyLZSIVsxFeX5oTQqTEIByl46ciQNy
   aJW30HSJs+/pxFVHRffAmj2FuWZsrWXxalsokuU8/f5lxzBP6TglAiTQWCouBzff4dxCGP0HR8QT
   Vz8/RBAX85Sfd4ccXbiPqcyXxFgIQD/xOWuucg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=M2AgnfvpQXnmARQ3E6AtL6EB8iC6Fu7Wj4D/aS6SYBE=;
 b=Z5v53w2uOgmiGB9N8z48uTHCtkvvG1++GvjXFfA1RavTQkTDlcbstkqhzOyFPEhFrTZjmpJsanx0
   SCr5EmVYvVTM0fEGMxk9/2hHDnAxYLskj/p565LRRHmmSjxQRTRYundBne8rYTQ6BDzkGreyzY1Q
   tsvDqDYVdrzB7fxdDy491k7PznIKUC5lsCdI6ztrOX2+RTHJkbk5hLEMA8WcPQAOLLP8bjO/kiYO
   EEzJDbt/3KVDeg21Di6bGzg/GumywdXDC1+fPrYoN+ujLNGP84htE/ymQSoe4EgRCFzuGVZ+OtYz
   rLh9YvihLnFbRX/hLybeI8760JADETAV/f6zQg==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220413 64bit (built Apr 13
 2022))
 with ESMTPS id <0RBN005ATFXLYYF0@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 10 May 2022 04:17:45 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1652156250; bh=SIxAJAW+I0aca6ctLYrG98vIl4veIqyF36JyxZQCqc8=;
 h=Date:To:From:Subject:From;
 b=YWMUlnB7zRMIY1Mkq2R86DppLGf3GSLJ3//Fag7/6mdbTG0dc0wkYJJPwjGAo7+2F
 RzPL7o69/V1mjkD57YH8U8UWN7tdKF2TtmGHiFtYN4/qhwO4Ks9B8InXR5/XydXpK4
 +B/r2eYGd7gIwXuW9ofx8fsB4YUo6G2OB+SJqd4E=
Date: Mon, 09 May 2022 21:17:29 -0700
To: mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
 junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
 heming.zhao@suse.com, ghe@suse.com, gechangwei@live.cn,
 ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org
Message-id: <20220510041730.2709BC385A6@smtp.kernel.org>
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10342
 signatures=593155
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 impostorscore=0 clxscore=190 mlxscore=0 lowpriorityscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 phishscore=0 mlxlogscore=999
 priorityscore=151 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205100018
Subject: [Ocfs2-devel] [merged mm-nonmm-stable]
	ocfs2-ocfs2_initialize_super-does-cleanup-job-before-return-error.patch
	removed from -mm tree
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
X-Proofpoint-ORIG-GUID: UKL3E88MWC9DyVDsPq3L-96NEWOWxUy3
X-Proofpoint-GUID: UKL3E88MWC9DyVDsPq3L-96NEWOWxUy3
Reporting-Meta:
 AAEfuOMvJuMO2faTRAVSN0CikplW6rciJz72aqTItBdtafQGBunmv71bZ8YYIMw4
 PoH1CDAaOhnSZNr9+ua/72ST3v/Q7WmyPm+xLms+gXab05xf/yJN4Sgjqc7oT8aV
 ekVAkdQ6Hku1mIUbnmQ0ntsIn+/z3gbHeMgdM2leDb0B9G+4R76+IvWe0nl3Ayw0
 br7xlyhRg63OwrIKqoyNgLgC0vp3vbu4Tk6uKh7Q2lTsMwln3XDx6wJEUSyh9cox
 7ua4+W0FFNfGZiFsA6zNGshEPn7KeTTMhlaGIGN70tmWteY/EheV6GqOF9a+mpYI
 ZYgwxe7TLOKsn6g9FmuYF14CpkQCqmmil8MIKKXV5hhwqLrA7/riYh7kMUvEjCU6
 kxs8FOPnvkU2SthpFQ5VePhvgoR1yJUFsdpcsinD0Ixdpg1e/Dn6NB61xuvdGO3k
 FISRGtlK//Xi0AZiBdOM0KP2xslI+74MPrEXIjHZ7HQcStAxpSJo6+pIydEH5eUj
 L5LMELFiIGj9ek+Yi4bl+aSuKj07mFFflE1ebkF717g=


The quilt patch titled
     Subject: ocfs2: ocfs2_initialize_super does cleanup job before return error
has been removed from the -mm tree.  Its filename was
     ocfs2-ocfs2_initialize_super-does-cleanup-job-before-return-error.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: ocfs2: ocfs2_initialize_super does cleanup job before return error

After this patch, when error, ocfs2_fill_super doesn't take care to
release resources which are allocated in ocfs2_initialize_super.

Link: https://lkml.kernel.org/r/20220424130952.2436-4-heming.zhao@suse.com
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |   59 +++++++++++++++++++++++++++++++--------------
 1 file changed, 41 insertions(+), 18 deletions(-)

--- a/fs/ocfs2/super.c~ocfs2-ocfs2_initialize_super-does-cleanup-job-before-return-error
+++ a/fs/ocfs2/super.c
@@ -2022,7 +2022,7 @@ static int ocfs2_initialize_super(struct
 	if (!osb) {
 		status = -ENOMEM;
 		mlog_errno(status);
-		goto bail;
+		goto out;
 	}
 
 	sb->s_fs_info = osb;
@@ -2083,7 +2083,7 @@ static int ocfs2_initialize_super(struct
 		mlog(ML_ERROR, "Invalid number of node slots (%u)\n",
 		     osb->max_slots);
 		status = -EINVAL;
-		goto bail;
+		goto out;
 	}
 
 	ocfs2_orphan_scan_init(osb);
@@ -2092,7 +2092,7 @@ static int ocfs2_initialize_super(struct
 	if (status) {
 		mlog(ML_ERROR, "Unable to initialize recovery state\n");
 		mlog_errno(status);
-		goto bail;
+		goto out;
 	}
 
 	init_waitqueue_head(&osb->checkpoint_event);
@@ -2116,7 +2116,7 @@ static int ocfs2_initialize_super(struct
 	if (!osb->vol_label) {
 		mlog(ML_ERROR, "unable to alloc vol label\n");
 		status = -ENOMEM;
-		goto bail;
+		goto out_recovery_map;
 	}
 
 	osb->slot_recovery_generations =
@@ -2125,7 +2125,7 @@ static int ocfs2_initialize_super(struct
 	if (!osb->slot_recovery_generations) {
 		status = -ENOMEM;
 		mlog_errno(status);
-		goto bail;
+		goto out_vol_label;
 	}
 
 	init_waitqueue_head(&osb->osb_wipe_event);
@@ -2135,7 +2135,7 @@ static int ocfs2_initialize_super(struct
 	if (!osb->osb_orphan_wipes) {
 		status = -ENOMEM;
 		mlog_errno(status);
-		goto bail;
+		goto out_slot_recovery_gen;
 	}
 
 	osb->osb_rf_lock_tree = RB_ROOT;
@@ -2151,13 +2151,13 @@ static int ocfs2_initialize_super(struct
 		mlog(ML_ERROR, "couldn't mount because of unsupported "
 		     "optional features (%x).\n", i);
 		status = -EINVAL;
-		goto bail;
+		goto out_orphan_wipes;
 	}
 	if (!sb_rdonly(osb->sb) && (i = OCFS2_HAS_RO_COMPAT_FEATURE(osb->sb, ~OCFS2_FEATURE_RO_COMPAT_SUPP))) {
 		mlog(ML_ERROR, "couldn't mount RDWR because of "
 		     "unsupported optional features (%x).\n", i);
 		status = -EINVAL;
-		goto bail;
+		goto out_orphan_wipes;
 	}
 
 	if (ocfs2_clusterinfo_valid(osb)) {
@@ -2178,7 +2178,7 @@ static int ocfs2_initialize_super(struct
 			     "cluster stack label (%s) \n",
 			     osb->osb_cluster_stack);
 			status = -EINVAL;
-			goto bail;
+			goto out_orphan_wipes;
 		}
 		memcpy(osb->osb_cluster_name,
 			OCFS2_RAW_SB(di)->s_cluster_info.ci_cluster,
@@ -2198,7 +2198,7 @@ static int ocfs2_initialize_super(struct
 	 */
 	status = ocfs2_journal_alloc(osb);
 	if (status < 0)
-		goto bail;
+		goto out_orphan_wipes;
 
 	INIT_WORK(&osb->dquot_drop_work, ocfs2_drop_dquot_refs);
 	init_llist_head(&osb->dquot_drop_list);
@@ -2213,7 +2213,7 @@ static int ocfs2_initialize_super(struct
 		mlog(ML_ERROR, "Volume has invalid cluster size (%d)\n",
 		     osb->s_clustersize);
 		status = -EINVAL;
-		goto bail;
+		goto out_journal;
 	}
 
 	total_blocks = ocfs2_clusters_to_blocks(osb->sb,
@@ -2225,14 +2225,14 @@ static int ocfs2_initialize_super(struct
 		mlog(ML_ERROR, "Volume too large "
 		     "to mount safely on this system");
 		status = -EFBIG;
-		goto bail;
+		goto out_journal;
 	}
 
 	if (ocfs2_setup_osb_uuid(osb, di->id2.i_super.s_uuid,
 				 sizeof(di->id2.i_super.s_uuid))) {
 		mlog(ML_ERROR, "Out of memory trying to setup our uuid.\n");
 		status = -ENOMEM;
-		goto bail;
+		goto out_journal;
 	}
 
 	strlcpy(osb->vol_label, di->id2.i_super.s_label,
@@ -2252,7 +2252,7 @@ static int ocfs2_initialize_super(struct
 	if (!osb->osb_dlm_debug) {
 		status = -ENOMEM;
 		mlog_errno(status);
-		goto bail;
+		goto out_uuid_str;
 	}
 
 	atomic_set(&osb->vol_state, VOLUME_INIT);
@@ -2261,7 +2261,7 @@ static int ocfs2_initialize_super(struct
 	status = ocfs2_init_global_system_inodes(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto bail;
+		goto out_dlm_out;
 	}
 
 	/*
@@ -2272,7 +2272,7 @@ static int ocfs2_initialize_super(struct
 	if (!inode) {
 		status = -EINVAL;
 		mlog_errno(status);
-		goto bail;
+		goto out_system_inodes;
 	}
 
 	osb->bitmap_blkno = OCFS2_I(inode)->ip_blkno;
@@ -2285,16 +2285,39 @@ static int ocfs2_initialize_super(struct
 	status = ocfs2_init_slot_info(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto bail;
+		goto out_system_inodes;
 	}
 
 	osb->ocfs2_wq = alloc_ordered_workqueue("ocfs2_wq", WQ_MEM_RECLAIM);
 	if (!osb->ocfs2_wq) {
 		status = -ENOMEM;
 		mlog_errno(status);
+		goto out_slot_info;
 	}
 
-bail:
+	return status;
+
+out_slot_info:
+	ocfs2_free_slot_info(osb);
+out_system_inodes:
+	ocfs2_release_system_inodes(osb);
+out_dlm_out:
+	ocfs2_put_dlm_debug(osb->osb_dlm_debug);
+out_uuid_str:
+	kfree(osb->uuid_str);
+out_journal:
+	kfree(osb->journal);
+out_orphan_wipes:
+	kfree(osb->osb_orphan_wipes);
+out_slot_recovery_gen:
+	kfree(osb->slot_recovery_generations);
+out_vol_label:
+	kfree(osb->vol_label);
+out_recovery_map:
+	kfree(osb->recovery_map);
+out:
+	kfree(osb);
+	sb->s_fs_info = NULL;
 	return status;
 }
 
_

Patches currently in -mm which might be from ocfs2-devel@oss.oracle.com are



_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
