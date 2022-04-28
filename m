Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52A78C433EF
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Apr 2022 22:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=yxQtf14gMpIAy2rMsSpNYrKQXPNZPL4ORPtA0i03RnM=;
 b=CFL0mL2pLQwkRWXlxx5Hzu6fHiHM/Jmq6V0qNSzb4OtSb2byF9XlgFJ5kWpu6WPAXKmJ2wIDB67r
   eQs3DW8cxCOlW2m8NdHj0Utb6ycgu6ohKwPwAENT+67nEsPMiJFyXgJ4rCBrpO6e5DZMHFuFFalB
   JSlxfo62+pqX8SHfFyjQcIMb62mR0DuCFk+ddmiQRu4BYn8Pd7E43Z64Ino90t1vZRwy5+/qjL5/
   9MT8JI2eHcfQa8RlIulMqw5D1ATAKvo8FpVVLx0XMp5BlipoK0sKyONY7Jrkj+vqHnLPaf1MvsPq
   A8GPwBAPWaAFiO5bVb11Cfx36Ztvz5T85LT0OQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=yxQtf14gMpIAy2rMsSpNYrKQXPNZPL4ORPtA0i03RnM=;
 b=SSeDF30JNbbuZc0Qt5h82OTm54/hy3/Q6DX7VG/eLpW20V1krfA8F8/2wX5Cyq9vflVE/P6jRbo/
   ioKtrXENolqUH2YeaGHH654PIQjTtC7oyxzFjo9H1aY9LvgvJOJgdmuS3y2ADGQQDEO41fSR5M9C
   t44mG2Y736pr4e97ZrBQVvhLExs4Kq1rJ32OlMfqs53ANgroNIGHw60l373JN0bdGOEd1KdDGv7n
   V3g0KeJr+kAPWgj6A2EkNwxYE/XHK4mB0ca3mFeyU7hBPMmjLDFLam8hDDecTbMDfEkKDwtzW8Y7
   nUs/mXnzVQcUGFSA/Aj+CA+K0qOTZfJj8IpGLQ==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RB2007A2L4SA0E0@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 28 Apr 2022 22:00:28 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1651183212; bh=FORrbZFkCIqQbA6qADXmUdqv/8roWXZ1KZuWCR1RJ24=;
 h=Date:To:From:Subject:From;
 b=ewLsU/TnyW3QPQ1UTX4Xj2dVF3uLfBxcq7mYw1tWsVz5alEuNMA9ZX/pNGIUrdt8b
 Sie02a5M//ypYx6lwJt5jCMhctbDzkE49ByEMn+D/Bo0+5GwNK1cUc+zdopEGuBNiP
 DqDXSVoTA+QGRnKkMY/U6BtWe2BQSY4Rwt+wJCfc=
Date: Thu, 28 Apr 2022 15:00:11 -0700
To: mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
 junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
 heming.zhao@suse.com, ghe@suse.com, gechangwei@live.cn,
 ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org
Message-id: <20220428220012.34FD2C385A9@smtp.kernel.org>
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10331
 signatures=591664
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 priorityscore=60
 lowpriorityscore=0 bulkscore=0 clxscore=184 impostorscore=0 mlxscore=0
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204280128
Subject: [Ocfs2-devel] +	ocfs2-rewrite-error-handling-of-ocfs2_fill_super.patch
 added	to -mm tree
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
X-Proofpoint-GUID: qzs9PuTTgy8JXg0Rs38OVTYH__XMdwqO
X-Proofpoint-ORIG-GUID: qzs9PuTTgy8JXg0Rs38OVTYH__XMdwqO
Reporting-Meta:
 AAF6HdaxjD3hKj1aNSSX6B31MVD7QRVC1MwFGkMluFJ1UCpMYvVFKJ1xeari8XWc
 s2srSoourfEcI+r16fSjugUFqF+94szUiiXlNNhDvLCEm0uJgl3ihv+Rym5iqclZ
 uNUVlyKp2X9B3BMNbNzT9Q9NztdtYKPGCjRBb+mgjmhlrBTxLX/LPhvf4rVTm9d+
 KXITvzy+XHZjsmNUWt76wfgu3GWv+e9+G096HuQ3IH1iRqko11twHRho4YgyAoZZ
 +jbtGGCeNAkiEfSvoM0o0JVmogdfP5djxtbw2QxGAydzc5COLNmqF6xag38xUtgi
 S4MCjL+rh0FpT1vPi/LBYZcm9I+rvYuBoRDfWs4alVM+pq34LxFqCLe3OyyQwYpL
 9c+6G2dKA1iKWYrzYol0pR5YHs/pLkRlpR7fLen7xneI7wpbAf+Cpbtr6t42kKGx
 VZrhgg0nLIowQWxTi+cmsn52WJ822LGdqGZPTK1WTWU12+ZKMy40XPQwqSMk9lUQ
 cAomhO3f1RoZpWqhmR3PNGMh1EtN+DgPbwLq6HqREy5O


The patch titled
     Subject: ocfs2: rewrite error handling of ocfs2_fill_super
has been added to the -mm tree.  Its filename is
     ocfs2-rewrite-error-handling-of-ocfs2_fill_super.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-rewrite-error-handling-of-ocfs2_fill_super.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-rewrite-error-handling-of-ocfs2_fill_super.patch

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
Subject: ocfs2: rewrite error handling of ocfs2_fill_super

Current ocfs2_fill_super() uses one goto label "read_super_error" to
handle all error cases.  And with previous serial patches, the error
handling should fork more branches to handle different error cases.  This
patch rewrite the error handling of ocfs2_fill_super.

Link: https://lkml.kernel.org/r/20220424130952.2436-6-heming.zhao@suse.com
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |   67 +++++++++++++++++++++------------------------
 1 file changed, 32 insertions(+), 35 deletions(-)

--- a/fs/ocfs2/super.c~ocfs2-rewrite-error-handling-of-ocfs2_fill_super
+++ a/fs/ocfs2/super.c
@@ -989,28 +989,27 @@ static int ocfs2_fill_super(struct super
 
 	if (!ocfs2_parse_options(sb, data, &parsed_options, 0)) {
 		status = -EINVAL;
-		goto read_super_error;
+		goto out;
 	}
 
 	/* probe for superblock */
 	status = ocfs2_sb_probe(sb, &bh, &sector_size, &stats);
 	if (status < 0) {
 		mlog(ML_ERROR, "superblock probe failed!\n");
-		goto read_super_error;
+		goto out;
 	}
 
 	status = ocfs2_initialize_super(sb, bh, sector_size, &stats);
-	osb = OCFS2_SB(sb);
-	if (status < 0) {
-		mlog_errno(status);
-		goto read_super_error;
-	}
 	brelse(bh);
 	bh = NULL;
+	if (status < 0)
+		goto out;
+
+	osb = OCFS2_SB(sb);
 
 	if (!ocfs2_check_set_options(sb, &parsed_options)) {
 		status = -EINVAL;
-		goto read_super_error;
+		goto out_super;
 	}
 	osb->s_mount_opt = parsed_options.mount_opt;
 	osb->s_atime_quantum = parsed_options.atime_quantum;
@@ -1027,7 +1026,7 @@ static int ocfs2_fill_super(struct super
 
 	status = ocfs2_verify_userspace_stack(osb, &parsed_options);
 	if (status)
-		goto read_super_error;
+		goto out_super;
 
 	sb->s_magic = OCFS2_SUPER_MAGIC;
 
@@ -1041,7 +1040,7 @@ static int ocfs2_fill_super(struct super
 			status = -EACCES;
 			mlog(ML_ERROR, "Readonly device detected but readonly "
 			     "mount was not specified.\n");
-			goto read_super_error;
+			goto out_super;
 		}
 
 		/* You should not be able to start a local heartbeat
@@ -1050,7 +1049,7 @@ static int ocfs2_fill_super(struct super
 			status = -EROFS;
 			mlog(ML_ERROR, "Local heartbeat specified on readonly "
 			     "device.\n");
-			goto read_super_error;
+			goto out_super;
 		}
 
 		status = ocfs2_check_journals_nolocks(osb);
@@ -1059,9 +1058,7 @@ static int ocfs2_fill_super(struct super
 				mlog(ML_ERROR, "Recovery required on readonly "
 				     "file system, but write access is "
 				     "unavailable.\n");
-			else
-				mlog_errno(status);
-			goto read_super_error;
+			goto out_super;
 		}
 
 		ocfs2_set_ro_flag(osb, 1);
@@ -1077,10 +1074,8 @@ static int ocfs2_fill_super(struct super
 	}
 
 	status = ocfs2_verify_heartbeat(osb);
-	if (status < 0) {
-		mlog_errno(status);
-		goto read_super_error;
-	}
+	if (status < 0)
+		goto out_super;
 
 	osb->osb_debug_root = debugfs_create_dir(osb->uuid_str,
 						 ocfs2_debugfs_root);
@@ -1094,15 +1089,14 @@ static int ocfs2_fill_super(struct super
 
 	status = ocfs2_mount_volume(sb);
 	if (status < 0)
-		goto read_super_error;
+		goto out_debugfs;
 
 	if (osb->root_inode)
 		inode = igrab(osb->root_inode);
 
 	if (!inode) {
 		status = -EIO;
-		mlog_errno(status);
-		goto read_super_error;
+		goto out_dismount;
 	}
 
 	osb->osb_dev_kset = kset_create_and_add(sb->s_id, NULL,
@@ -1110,7 +1104,7 @@ static int ocfs2_fill_super(struct super
 	if (!osb->osb_dev_kset) {
 		status = -ENOMEM;
 		mlog(ML_ERROR, "Unable to create device kset %s.\n", sb->s_id);
-		goto read_super_error;
+		goto out_dismount;
 	}
 
 	/* Create filecheck sysfs related directories/files at
@@ -1119,14 +1113,13 @@ static int ocfs2_fill_super(struct super
 		status = -ENOMEM;
 		mlog(ML_ERROR, "Unable to create filecheck sysfs directory at "
 			"/sys/fs/ocfs2/%s/filecheck.\n", sb->s_id);
-		goto read_super_error;
+		goto out_dismount;
 	}
 
 	root = d_make_root(inode);
 	if (!root) {
 		status = -ENOMEM;
-		mlog_errno(status);
-		goto read_super_error;
+		goto out_dismount;
 	}
 
 	sb->s_root = root;
@@ -1178,17 +1171,21 @@ static int ocfs2_fill_super(struct super
 
 	return status;
 
-read_super_error:
-	brelse(bh);
-
-	if (status)
-		mlog_errno(status);
+out_dismount:
+	atomic_set(&osb->vol_state, VOLUME_DISABLED);
+	wake_up(&osb->osb_mount_event);
+	ocfs2_dismount_volume(sb, 1);
+	goto out;
 
-	if (osb) {
-		atomic_set(&osb->vol_state, VOLUME_DISABLED);
-		wake_up(&osb->osb_mount_event);
-		ocfs2_dismount_volume(sb, 1);
-	}
+out_debugfs:
+	debugfs_remove_recursive(osb->osb_debug_root);
+out_super:
+	ocfs2_release_system_inodes(osb);
+	kfree(osb->recovery_map);
+	ocfs2_delete_osb(osb);
+	kfree(osb);
+out:
+	mlog_errno(status);
 
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
