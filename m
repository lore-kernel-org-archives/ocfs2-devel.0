Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 931B7C3DA7A
	for <ocfs2-devel@archiver.kernel.org>; Sun, 25 Dec 2022 15:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=EFQ2c3dVFiyedJUn8c1HcDABkGh+8qFrZweFASNFTfw=;
 b=PT/JTi+DdKRRqcEV9M01uJ5wBJ2L4XGVBUQcya7L3JWAL3+jznBABlcbQNRYvAEFYBKyzCaCbL7c
   r72xOLLPzGwKiW7rSbG3UTse3P9L4HfySR01OGoRvNKciMdJ8JQWExISTJEEe6WU5i8QRZEhj3S6
   l6O1YGhYEUAqiyBF+XSXnku9CY9mFaY4hXA55g4zJP0jvq9RvZG6EctF505uhbozCZrn/nsz7U6K
   Pb8yuerekt7SZ/AlaTmjiqEYKfKGFzHgMDUa7Z19Gifxxu6AP8CjFVg+X5VpHm1c4ZSRPmpVMGVm
   2AHr2bcL8wNroQQd8XO42Y+hCOJpMwj8ahYqZw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=EFQ2c3dVFiyedJUn8c1HcDABkGh+8qFrZweFASNFTfw=;
 b=uueFRZ7Rm2q7Kt5gnqm0FnBnks/AhEQIAjj5OBDuPDdk21Hapi51E4VKBDMc7uwmc9GoK6ZhAT+9
   docl3fpL3IxoGqrbTlYFldje+JpvjTzNuXQNILaUCckpob4KrYkoN2Bx2miXRe7ZRf3hEexP7O7x
   hSWkW1XYlEJ4+TRrfZdqMH573IVwoZJP4OAaZIUtVeCIR25A5yhop0GiOx5KW7VrxyQy4UK7HpGq
   BTqpcNkOPEYw/xJPdF6+016j140utLj/ZbsqffkY0VP7S9zkAj+pxIZukZYeoRdx5C5c+DvxEJJ/
   0PwEFXX4Zp+trWyipZsTiR5c+GilKyN9p77log==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0RNG00C63EDA7NA0@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 25 Dec 2022 15:43:58 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1671983022; bh=xQGd45tdEfEpkI+awhE8c621296Rgp5Qo/jxT6PSuSg=;
 h=From:To:Cc:Subject:Date:From;
 b=HEEmRQZCyUXwunHGNztEtWyJ2ynks/3UjgLdM+qFN5ORhL3qQ6Rd6zapH8Cb0fjWU
 uftfHi6EAusv+ZLPhR55fKnjtvCBfQ66Ug12MVlSBLbxiaeLOKGy6wMMlJ4m0LlyiW
 UgwfgySdSeLKz5/UN0rrQPmtJPs4PEUAlvJJfKDBhrx7PsAMMLJ90K9KsRUin++K/4
 jAIRYWW7Vmxa2kRdjUD3t8+0UYW9p/ZOnHLhAgzZ3AZWFTxoLkh6ap/QWixo1RhI6N
 babA8yt15KBK6/Oe+D6jWPPHwvf6XhADWqRt9jTkYXkzOnyojDIFwvHA8DwER8bXxM
 6sdBeigxcBEnQ==
To: stable-commits@vger.kernel.org, ocfs2-devel@oss.oracle.com
Date: Sun, 25 Dec 2022 10:43:39 -0500
Message-id: <20221225154339.719784-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-version: 1.0
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10571
 signatures=596816
Subject: [Ocfs2-devel] Patch
 "ocfs2: rewrite error handling of	ocfs2_fill_super" has been added to the
 5.4-stable tree
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
X-Proofpoint-GUID: kzla_vn361OCbLhiN2kmO1ULGFzSNvGp
X-Proofpoint-ORIG-GUID: kzla_vn361OCbLhiN2kmO1ULGFzSNvGp
Reporting-Meta:
 AAH3lK4sgK36vSUzkkek+r+oBAU7FFAeQrQdbwsIZ7WS12X/OOoYtLdLw0Onv6bj
 3DBzfoGQRmJsYlSNHBCuetPKq2CVjKwx1GHZS0lIxbP8u7smHS8IBfe84x11ktSP
 h5RBMAbMEkhDtIARcH1WFHaatTlqahSCj2C8dKeGhJ+nswNIeB9dkt4RgzsYZIjw
 Xu9KvTKhSfLdp92wfdKOvJGfMwqZ889obv8zGkXkLuGDrf87oFbqf9G4zJQdnh6F
 6hUBecWZIJb35gF5rYwb1UYYrPHY+xnnSMaB1jyKBJTgxdwsa8JV18BLRI2Kf9uc
 Z56ahCnYHXRsLbLS3sbF1t3cO7nD0vVCcaObWwCjQO1LLumG9cRpJjttQKVjFlbz
 gTbj3Bsv+dDk06Ejx+Q+1QM1ltczafHBYeVw3WD0nZ/iNeS7OvRkOaHUaTiV3d2X
 ojQPIhPoCwVzeo/vWHKWcwAWWQqKru5DKQYHrPKOP0pVlaLmNCL+LCnUKhsiI/KS
 w+wNqvsnngqoPQsrXOV5XQUtTbWsxqn2uccaoBqmd0tx

This is a note to let you know that I've just added the patch titled

    ocfs2: rewrite error handling of ocfs2_fill_super

to the 5.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ocfs2-rewrite-error-handling-of-ocfs2_fill_super.patch
and it can be found in the queue-5.4 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 7802c2180ba9fee0389fd097212d8334f02eb5f4
Author: Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Date:   Fri Apr 29 14:37:58 2022 -0700

    ocfs2: rewrite error handling of ocfs2_fill_super
    
    [ Upstream commit f1e75d128b46e3b066e7b2e7cfca10491109d44d ]
    
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
    Stable-dep-of: ce2fcf1516d6 ("ocfs2: fix memory leak in ocfs2_mount_volume()")
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index ead43f95bb43..38e51868c2d3 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -984,28 +984,27 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
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
@@ -1022,7 +1021,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
 	status = ocfs2_verify_userspace_stack(osb, &parsed_options);
 	if (status)
-		goto read_super_error;
+		goto out_super;
 
 	sb->s_magic = OCFS2_SUPER_MAGIC;
 
@@ -1036,7 +1035,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 			status = -EACCES;
 			mlog(ML_ERROR, "Readonly device detected but readonly "
 			     "mount was not specified.\n");
-			goto read_super_error;
+			goto out_super;
 		}
 
 		/* You should not be able to start a local heartbeat
@@ -1045,7 +1044,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 			status = -EROFS;
 			mlog(ML_ERROR, "Local heartbeat specified on readonly "
 			     "device.\n");
-			goto read_super_error;
+			goto out_super;
 		}
 
 		status = ocfs2_check_journals_nolocks(osb);
@@ -1054,9 +1053,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 				mlog(ML_ERROR, "Recovery required on readonly "
 				     "file system, but write access is "
 				     "unavailable.\n");
-			else
-				mlog_errno(status);
-			goto read_super_error;
+			goto out_super;
 		}
 
 		ocfs2_set_ro_flag(osb, 1);
@@ -1072,10 +1069,8 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
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
@@ -1089,15 +1084,14 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
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
@@ -1105,7 +1099,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	if (!osb->osb_dev_kset) {
 		status = -ENOMEM;
 		mlog(ML_ERROR, "Unable to create device kset %s.\n", sb->s_id);
-		goto read_super_error;
+		goto out_dismount;
 	}
 
 	/* Create filecheck sysfs related directories/files at
@@ -1114,14 +1108,13 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
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
@@ -1168,17 +1161,21 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
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

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
