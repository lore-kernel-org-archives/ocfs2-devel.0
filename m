Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B87EC3DA7A
	for <ocfs2-devel@archiver.kernel.org>; Sun, 25 Dec 2022 15:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=On4mNVTQS5qQEmOmhxYZkotzlUmS67OxRfGkE3Fx04E=;
 b=2O4zB2y8YJ6OhmGFYSW8A+Yoj+1/REKDIpgsKYYyQvcOpOFiC7xpgvp/H5YHi5mT7ImeThDbkGZW
   baX1QtjC/aOEiWVfnoFyoDC+hq6iLH4nPa9xnplfpZh3oYi9FfvyBTnOvwShG5PyPayG9E4i/9Dz
   EFW9qjzzHclljPvL/MYnN86Pd5KslCtwtnAaaO6yo9AyfOdyttY0/8vqqrVM12B+LztgLUtqqDfK
   rWGzMV9X4w/BYneuY4f6pDi9pJ+bP0iwHTeXNoP24GYxh69x4IIUelahT7ZOOFbatmBTI62eJQwm
   5BJOZCw12+9/1gvgxArHk6tgvPckMl3AZxgo/Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=On4mNVTQS5qQEmOmhxYZkotzlUmS67OxRfGkE3Fx04E=;
 b=OjvHsZNw0qgwxgOYNQfbeLcWLUwEduKZmxvDENcorPAOznTXsYGJSF8VPMP7gghi5i0ylWCgiMuv
   vFCbu+fz91oMzWXqtwQ9cHp+NV8wmnlXshdSRWv5uCkFYFHhfxqBTS1hhU3Q8egReAvGiXz8nBYQ
   +T9jRbSuNsFYRoiKrcCeyawcUfRaMrWSP9YU3L4oTfVgFTkZ3H+972lK2JmLzLMmp7HGmorMaGI9
   y22q5w6So+Jbcg3enTNnXeTe4CdfZauQBVBjg3d7oQ4bWXB0rCXekVgqDb+kq2Z0/x8ccwUiss2i
   WXqH17eaOH3K7qR7UmevcNyqVGPOaEYl/rjYSQ==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0RNG00E19ED3G890@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 25 Dec 2022 15:43:51 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1671983019; bh=SaEbez54YGT/rtELSACH76G/xjEytKidcV9h5USh7Bw=;
 h=From:To:Cc:Subject:Date:From;
 b=uYtOoQZyIxctt+snnh0o8pu/tjSiiYlYuS5WprgYLtO9CrNSvDDycQeC488XaXTub
 XrM1dke3sMvp+nTyNfQdI4WFQHNr74oZ3OsdtdB5jiSpN2ydWISyhvLuzwb/P8eCn6
 H0/HwxCVK+B04/1Og+qVkLwPdVN/gZqkmvngjkYeG/3vsrO3Virkq923tNvgF8HXWt
 aJUPLkKsZ9Zp4C2st23oybV7lAfOdscRbRY7892rEBDdoVxRck/iccicAXe98abHZc
 SwDsV5dSlU8VPI93Zn2vErAQpZjHU3/OOlE22djwOROdqlz/Plh28IxqcHK49g4BxK
 mxrDD+6pNbEZg==
To: stable-commits@vger.kernel.org, ocfs2-devel@oss.oracle.com
Date: Sun, 25 Dec 2022 10:43:36 -0500
Message-id: <20221225154336.719746-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-version: 1.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10571
 signatures=596816
Subject: [Ocfs2-devel] Patch
 "ocfs2: ocfs2_mount_volume does cleanup job	before return error" has been
 added to the 5.4-stable tree
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
X-Proofpoint-GUID: Gw7_9I60Y_HRkaWuB0UgD443SdoOizUj
X-Proofpoint-ORIG-GUID: Gw7_9I60Y_HRkaWuB0UgD443SdoOizUj
Reporting-Meta:
 AAFiHzG/dddJJo5FeSNiRB/CPfFJpveia6ibj3ydcP4K7ksFs1dPP6iCHmnf0tVo
 ajEIB1tTA9XmLQYOdZib3pedkyqT+J9g3XUI89eBYvMYuHWADd7s57eIDN7i4eft
 xlKgqAYhO17FYwh4/JH1+WNu3ceJl3MJvQW8cC1/YVAtqyxlefVnjg+fwQrPY1tG
 b62oZas5C2tXscBNZIP71C/6U1iUxJWgyUO03plPJQCyqc9A5nTsCNirYypPuXYM
 1zcvI/2eYc1LMlMo4/9qhiFKzrq4V1XJirwBlBbJUGZYtBluRIvKZat+9ihCwnBA
 JuwMY+09nvKH/QGMaQ8vjqI/1KdUqRAGLxCcfzHk/XlD0dPymjBB/tzx5G8qHjP7
 48n522z7Ea61TuPLnqUoCxG0Ydfw2MUOWZkmQGNyREsHmK0N+iHSYhILaQ7gKY0N
 Gr6/tpCbR59RyCE0eoPvtC0GFgIWrNJ7y4O1+var5QlTyP5MmXkrWM2Q8UxJzwjz
 kW4PJ4DERoUtqTrnJ4BYeeUjTiztpdLniYrpRcGTXaZh

This is a note to let you know that I've just added the patch titled

    ocfs2: ocfs2_mount_volume does cleanup job before return error

to the 5.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ocfs2-ocfs2_mount_volume-does-cleanup-job-before-ret.patch
and it can be found in the queue-5.4 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit d1baf4dd545133b07d36fe63cdb644e7e3b46414
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
index c1cf67b24c19..ead43f95bb43 100644
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
