Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E07CC433FE
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Apr 2022 22:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=2ZWZ4u5Aqr8IAv2JpL0Uj677R3zpnfrZJQcI/9Nx0dA=;
 b=xkeu26KvSmMG1QS94l9t3xJ40cvX3iOM1WoDfauYI+jY+BBILVvNNik/bojdUUljS6bceKD2AGPg
   XOwZdfMSIVWK57jYLvEf/7xstF3FgjaPOHdpMoiaWlBRTW7UrRehBL5LEYrSjGetajjLhTS8fV4B
   bCzFuocVRQcMjkTfKc+i0v5ky5ax+LArIsd7B0yNcuaApAjYHhJujenNC10x+0V2/YJWxKTBuYSc
   KGjnW0B6zX04126oxH3Vdk5GFPu/DR7irc1RismrSEkv59g6DUr9dFAcJlEhWH5FoEnuY0nI9r0i
   dzUhnVDLKr5feUB5z1QhAXrRphnivjhvS3OQ0w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=2ZWZ4u5Aqr8IAv2JpL0Uj677R3zpnfrZJQcI/9Nx0dA=;
 b=JgMefHrk9/TFzcyQCyOpA5j1WuVY5DN38KFyVWAwnsgZMAXxoCJ6ho2lM8c9/QIZRq9t/2WaNeAS
   3qj1HbHHsjKJmHL7IWDN2eNQRb/VbvLn++qE5+B34Ig092VQE0vHMWXnr0ca+Lga/ZSOfKweOA8p
   BfPNc+i7QiyOvK+wmc34qkP6gdzaVM6HCGlu9tGeZ7BxWhgZlOb6WHhmqAnq2A1io7uFOOo4CWXC
   wsuXYtXuASjc8OLJYZhQoaEfX0yYLMaRhC43vQzhe3D/GmuKmIfPSWSz/h7ivUVAMmgMteYmxF1y
   rPRE+7vRLEO+OL4P5eR4SVIlRz4k4nLys0vXQw==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RB200DQ6L4LA9C0@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 28 Apr 2022 22:00:21 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1651183208; bh=+NJo2+vj+uvr6f5dbJ3VaDgixafkpUL8X12nKoLYZOE=;
 h=Date:To:From:Subject:From;
 b=oCO9IBTGC57daRoNng7Ife4vu4218G4akSUstLp+FsehxmzEOfzeAMM4mD1Nm9FJP
 853Ics7GbzqoasDr2jpqHV83UsgBDA2JLvUD7HuYZCAGr4TX3ZXWeOHqfHSKUN3Bae
 EWIFKKnimboh1qSHupbC72zchEb+l87Gb64Ez4Xk=
Date: Thu, 28 Apr 2022 15:00:07 -0700
To: mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
 junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
 heming.zhao@suse.com, ghe@suse.com, gechangwei@live.cn,
 ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org
Message-id: <20220428220008.69981C385AD@smtp.kernel.org>
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10331
 signatures=591664
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 mlxlogscore=999 impostorscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=90 malwarescore=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 clxscore=178 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204280128
Subject: [Ocfs2-devel] +
	ocfs2-ocfs2_initialize_super-does-cleanup-job-before-return-error.patch	added
 to -mm tree
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
X-Proofpoint-ORIG-GUID: KXBAXeamxkwAqOBtx3oaK32GKGTnXBzU
X-Proofpoint-GUID: KXBAXeamxkwAqOBtx3oaK32GKGTnXBzU
Reporting-Meta:
 AAHFG38j5b2WODVZHi8dLdEBK2OY5Hi0H3GQvaRu8DPJIDODPlDlrEgywt2Qieib
 MnoloE6PZ8ASeYJBWsbynCUZ7obkzL0yUTaQAM96Tp+v664RyaH6uhkVzASsPo0o
 sQQFazTvV7mF5JfrICYwh1B6MCmCphaA1jZJ7QEgMjaWh+MOEGbmGb5YjSA1Dam2
 G53FO35enQxky6UxEQuD6boDWV8ac+RhXU3efaivQuFtA8+kSUmx6eF4TV2Horua
 nySUOAIySxZ3QiN/DOK8VsxqY2nlQO41VsYGMfn7UwM7nuHUoKLN8dFuqr/iqN1G
 tkwFaNsnuBp87W4hMMYIWbYXbcnUseR+xAn23yJ9g3+/5y8Fs+bGJV1qh0daL8Hu
 Ceups7Ef+kbi/yOq/SUT9Ns77IR1Zg9XbEHGJn3AyLX5K4yTPktSstcYEpBKurmh
 c+qMSHEz3od262zz/1KyY9XUSZ0R6ytenO7loiUELEfuxIlVENYHrY4A1cjR5xhj
 pBAT18zkx0N8mEYlfhRYR7+UV4mKG5auRfnlwi8SKEo=


The patch titled
     Subject: ocfs2: ocfs2_initialize_super does cleanup job before return error
has been added to the -mm tree.  Its filename is
     ocfs2-ocfs2_initialize_super-does-cleanup-job-before-return-error.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-ocfs2_initialize_super-does-cleanup-job-before-return-error.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-ocfs2_initialize_super-does-cleanup-job-before-return-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-fix-mounting-crash-if-journal-is-not-alloced.patch
ocfs2-change-return-type-of-ocfs2_resmap_init.patch
ocfs2-ocfs2_initialize_super-does-cleanup-job-before-return-error.patch
ocfs2-ocfs2_mount_volume-does-cleanup-job-before-return-error.patch
ocfs2-rewrite-error-handling-of-ocfs2_fill_super.patch


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
