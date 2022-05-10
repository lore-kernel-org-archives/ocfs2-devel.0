Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E671CC4321E
	for <ocfs2-devel@archiver.kernel.org>; Tue, 10 May 2022 04:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=BiT8YoWPEC3yzVW8gBRMscalFCcz3trco688Ans4nxs=;
 b=od+fiD0+N/MHZrMU3fL/8L/G7O6o9Iye6xURngzu2ZS5MhAbtpLEbBg8C7T7GjHXuSNWg0jrKNi8
   VgBOGPqoLlnRZzkjYGASfWCoA7u0j+RnfT/vbhkDP6VlyPK5MqBVanUTt+z9Xx4/Ofw8Y+Z+VT8X
   5xgIyLm7KqkIs4aM06bBhcz37f/+KitMFXWOtzNYIXxzmgHS8T8QDT8BSEfoWqp1CmuOn+D/9Zai
   rEmnHe99pu5uZJp38vXlIM9YXQquoGJ+d+M/l819XzGDhAQwE5Ep0m1sONJLeoDPWFMX6cYkzXU3
   qEyxU7wlF5WjO35zAxLRUHIWDOB6fKVjI9vOOg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=BiT8YoWPEC3yzVW8gBRMscalFCcz3trco688Ans4nxs=;
 b=gr3QOwHPHg39CLOFpAfyq7UHhCwiQq0wao4kq8KdLCK0bGZvQ+wuDGXNC2YQW3LyE+aME2S6zYfH
   Ru6NXavHj18qcUK21si9xvVDg6ysYi1JFo4zAUBc9RX+KIBU4FmuhA+1w5V4edUfdYo0yYPX2Zxp
   e4s+cXDtBJzDI4rWr5CPNM4w3vAaofDM21szKBfqXRtvs3IPamjdOeWjMXLrGxx+oLRppSN5m5vg
   NtGEdP08yVEjrnQWucIZnQahWRATr4ZRHTt1XnJtlx+OxikfKRrLHaKq8EyECvxmT7G+1+6uTU2u
   wSHY8LoiAxwLWXIaI+PX8XA52zAyUjvvjZG28w==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220413 64bit (built Apr 13
 2022))
 with ESMTPS id <0RBN00LUEFXL0D00@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 10 May 2022 04:17:45 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1652156252; bh=15o6V0X4jTZVGPUvTvg04+Mzl1jrHpkbEfQAP+afN7U=;
 h=Date:To:From:Subject:From;
 b=lqXnEAAFSM8ZEKfmXoKST9lTWbdtA7Nd9KLRnteSMpIASXGBHEqy0Xt8mbet84rL1
 vkKMPVwjkNkc7cg3kdjCripC/5H/yekaMIRcjpqEdSpKzP4iPILI8ZsfE04CQ8iTaP
 Xk80wmGZrDJXNurAhr3OqCIGbQnqPSbSkeEjbL/0=
Date: Mon, 09 May 2022 21:17:31 -0700
To: mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
 junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
 heming.zhao@suse.com, ghe@suse.com, gechangwei@live.cn,
 ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org
Message-id: <20220510041732.4E93EC385C5@smtp.kernel.org>
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10342
 signatures=593155
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=190
 adultscore=0 suspectscore=0 priorityscore=151 phishscore=0 bulkscore=0
 mlxscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205100018
Subject: [Ocfs2-devel] [merged mm-nonmm-stable]
	ocfs2-rewrite-error-handling-of-ocfs2_fill_super.patch	removed from -mm tree
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
X-Proofpoint-ORIG-GUID: 0NhRhm6EP9lr4iqlq7HuO74KY22IpM8a
X-Proofpoint-GUID: 0NhRhm6EP9lr4iqlq7HuO74KY22IpM8a
Reporting-Meta:
 AAET+4NoE1o4wjyC76wnO27YPF4oXGhkCPXISpIbxMIEgFPoZ6xfn+C5TKDeNFpk
 ukNaElbCefPE77Lxm062Q/LTx5rdCaYYih0HZvQGGKUHk/ZDOyG3sYPmkZJUfncg
 pLyODcysSxS9lgy4GQhFHsgRDioQWHETBw6fwAQ7+/sKmnl+IWM8111x++/DiET9
 HuCCCaK/fxlw0NZoJtzUKZbfsHV5k3LP0S30WGs5I5F57t8a3QsnSI3NZal/pEJq
 yMhS0L6nYGqS2KODgyWjd72aB/zIBR+IhMsRla+aRGyCOo8Agts0MG9XJ8+Cd/RP
 D+uvjZsQMOu4oGwKtGEQKLC6X9Fy6jQCHMa+zZlvvMj/++w1FyrmseZvQIs6hu7+
 lMFsGTYjxuEYeZ6P1Bba7ewDAvhroJIbLFUsDRKq+GF6eLe1EY1oKZetr1eBrlzE
 qkCGaWl/kli4nPqO3Fp9ViUB6w7ghYJs31PxBERobPgj9EJudECToEgpJ4TqxU5y
 rwHUAhCzETbZSlnjsb1tux90MR32c4FI5FTuNe3FU4k=


The quilt patch titled
     Subject: ocfs2: rewrite error handling of ocfs2_fill_super
has been removed from the -mm tree.  Its filename was
     ocfs2-rewrite-error-handling-of-ocfs2_fill_super.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: ocfs2: rewrite error handling of ocfs2_fill_super

Current ocfs2_fill_super() uses one goto label "read_super_error" to
handle all error cases.  And with previous serial patches, the error
handling should fork more branches to handle different error cases.  This
patch rewrite the error handling of ocfs2_fill_super.

Link: https://lkml.kernel.org/r/20220424130952.2436-6-heming.zhao@suse.com
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



_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
