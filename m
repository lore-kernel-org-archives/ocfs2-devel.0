Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FA93C4332F
	for <ocfs2-devel@archiver.kernel.org>; Sun, 16 Oct 2022 23:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=/DVaEmexCqz14duKXA5vq3lRmq/iu39NU5tuLvwA0PM=;
 b=YFRCuVuAovZ6e81eKl/gJb/lajEUL3JblZiP8YkcpdTUbswHG7a2hw4EOfKzCIA5LOVifnzGdCJ4
   6ESpMBrCl0RqH/X83V5S5bSAfgQHIubii2iQsw0AMPpGYZzbeLRzV4yD44lrf2MplAtV+rB1nkNQ
   OnY8jqwhnv4y7p8yhxKBfxC40VA9Lgh7le3h0twWy/uFNn6qlTuZB5o/YzIQs9+HTxszhf0b6SWg
   JfvKwjwgakArD09FakB6YOB0qtBEhVqfwKpScJNuPfP1SVI5sNvnBXrQCbgWw7LMemcHMpX/J00h
   UW7eqEXQUZGUk07Ge3HjTI6Y4ifO6nFsmt8rhg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=/DVaEmexCqz14duKXA5vq3lRmq/iu39NU5tuLvwA0PM=;
 b=eItXIXbjLu+CGqmzKeGTyxKFjYIWSZEoc4qId9PZTiRs2M63V2RXgIaKw5uELXT7JJIW5d0RP9X7
   YaRAOxykfXk2+kY/j/VeSlxTtJN30DZ3NAuWyDjKrp5Sg8bXQP553ts+67jfERZIFEe1P9RUC3rp
   DGOxydPlZZKm9HIOcp2MnutGYlqD7ImtqozHaXKWF9hgKbbVnQUeZ6tVfBdDRziWceJ2OrJGcOLX
   2qRmr3tjt78FK52uzQkSIRW/4MCRBvgeB57IJkbqRUvBbcvgsTwWfQ4cX89FDwXOLYCeD5pt+oo5
   P0AivqNhq1iGhnxHe4QO8+2vB/BFYlistygc0w==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RJV00EAHDA5D860@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 16 Oct 2022 23:30:05 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1665962991; bh=tKTrSXcrRyuedWQYCfrGbCKVhI6CpGQ7BLZ+S79ShWc=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=LnkSgFPoMjCSjRPr2mgtmej91TMPLAJViO6ulTXqtmpSunBODSL/tiY39LKsx8pNZ
 QmXVs2qMF9tQWNoWY2uEj3EaxmAhp29D/76i/9o+HRGmhjMsmbReto9XdyTm7eSw0N
 R27mWzAmAHQZuyVsnLKpom3bJSF8qgtNruXgjJmY=
Date: Sun, 16 Oct 2022 16:29:50 -0700
To: Gang He <ghe@suse.com>
Message-id: <20221016162950.09db2b5f503ac87823cd1687@linux-foundation.org>
In-reply-to: <db7119a5-f120-cebe-42a1-dc2f64db620d@suse.com>
References: <20210729110230.18983-1-ghe@suse.com>
 <5821fd0f-2018-dc1b-a5c0-f948a7debff4@linux.alibaba.com>
 <c7e1f0a7-e75c-d1e0-870d-dc480d070079@suse.com>
 <71608a14-58f4-dba0-d695-fee65de89192@linux.alibaba.com>
 <801438f5-655a-c708-aa25-343d54a2f11e@suse.com>
 <86e3d724-3147-ccaa-998f-0f857c575f7e@linux.alibaba.com>
 <a0a9710f-461a-99c8-92f6-a99bb11b3a4e@suse.com>
 <4ba3b404-824b-90a3-ef43-9ab6510ee073@linux.alibaba.com>
 <5a1af56c-3eab-5baf-62a3-1c98bac104ba@suse.com>
 <db7119a5-f120-cebe-42a1-dc2f64db620d@suse.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-version: 1.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10502
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=70
 impostorscore=0 malwarescore=0 lowpriorityscore=0 phishscore=0 clxscore=181
 adultscore=0 suspectscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210160144
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: reflink deadlock when clone file to
 the same directory simultaneously
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
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:140.211.169.12/30 include:_spf.kernel.org
 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: WDAzZNgn5g-bm60R5XZW-3KywVFE4WQY
X-Proofpoint-GUID: WDAzZNgn5g-bm60R5XZW-3KywVFE4WQY
Reporting-Meta:
 AAFR6iT6yYFpRbn4SPgxykCB4c/Ix0kodlUUPASEt+sTDO15K9KqH9pCIWpmJMBj
 K1j5RvPZrFkb+Vy6tPmnvObuarijILt+Jj8yDi7yDsEqq71dZqTa2MpYMz/SD9oX
 wMepkg1Fai2Pq4k5+M25wFzFuzzSTJtT/U795UPfGP5gEOLetIZoX5sOPpxGJ1wB
 9IJgAzu4OoA+nSOkC3HhPP6onN6p6W6j6yj1epLZJNPpLSUM4FglxCIkSL7EXt48
 RgyfbMuYz6G17MyJir/giCor9EgFeUbahGVbIuG1TexbnveZaukH56EbY65x2WFP
 UzJM21f1qxtDdeyXK1x5KB1DLkTmHAw8XRqk9GwTHzyS3Q7CB/bSb3NUIzxAm4HH
 WnEOx6vr2jG4eVAc/3GanmAE/qwRGqCIaNWtq+Gz2u5l6H3AOKCHUqscEyBtiDh3
 z84OwWASUZZMV+k4i838Zt8YIt1N+Xw+2Egp147Cx6hwAq39RpBnjSztJ6+TEm5r
 sSuyYk3EPnaUBxcKk/nBV/vWdEBOscE8x8B29Tec88rG

On Thu, 26 Aug 2021 13:56:16 +0800 Gang He <ghe@suse.com> wrote:

> So, I will send a new patch to fix this deadlock problem via dlmglue layer.
> For this patch, I want to change the patch comments as a reflink 
> improvement patch.

Did this ever happen?  I've been sitting on this patch for ages.


From: Gang He <ghe@suse.com>
Subject: ocfs2: reflink deadlock when clone file to the same directory simultaneously

Running reflink from multiple nodes simultaneously to clone a file to the
same directory probably triggers a deadlock issue.  For example, there is
a three node ocfs2 cluster, each node mounts the ocfs2 file system to
/mnt/shared, and run the reflink command from each node repeatedly, like

  reflink "/mnt/shared/test" \
  "/mnt/shared/.snapshots/test.`date +%m%d%H%M%S`.`hostname`"
then, reflink command process will be hung on each node, and you
can't list this file system directory.
The problematic reflink command process is blocked at one node,
task:reflink         state:D stack:    0 pid: 1283 ppid:  4154
Call Trace:
  __schedule+0x2fd/0x750
  schedule+0x2f/0xa0
  schedule_timeout+0x1cc/0x310
  ? ocfs2_control_cfu+0x50/0x50 [ocfs2_stack_user]
  ? 0xffffffffc0e3e000
  wait_for_completion+0xba/0x140
  ? wake_up_q+0xa0/0xa0
  __ocfs2_cluster_lock.isra.41+0x3b5/0x820 [ocfs2]
  ? ocfs2_inode_lock_full_nested+0x1fc/0x960 [ocfs2]
  ocfs2_inode_lock_full_nested+0x1fc/0x960 [ocfs2]
  ocfs2_init_security_and_acl+0xbe/0x1d0 [ocfs2]
  ocfs2_reflink+0x436/0x4c0 [ocfs2]
  ? ocfs2_reflink_ioctl+0x2ca/0x360 [ocfs2]
  ocfs2_reflink_ioctl+0x2ca/0x360 [ocfs2]
  ocfs2_ioctl+0x25e/0x670 [ocfs2]
  do_vfs_ioctl+0xa0/0x680
  ksys_ioctl+0x70/0x80
  __x64_sys_ioctl+0x16/0x20
  do_syscall_64+0x5b/0x1e0
The other reflink command processes are blocked at other nodes,
task:reflink         state:D stack:    0 pid:29759 ppid:  4088
Call Trace:
  __schedule+0x2fd/0x750
  schedule+0x2f/0xa0
  schedule_timeout+0x1cc/0x310
  ? ocfs2_control_cfu+0x50/0x50 [ocfs2_stack_user]
  ? 0xffffffffc0b19000
  wait_for_completion+0xba/0x140
  ? wake_up_q+0xa0/0xa0
  __ocfs2_cluster_lock.isra.41+0x3b5/0x820 [ocfs2]
  ? ocfs2_inode_lock_full_nested+0x1fc/0x960 [ocfs2]
  ocfs2_inode_lock_full_nested+0x1fc/0x960 [ocfs2]
  ocfs2_mv_orphaned_inode_to_new+0x87/0x7e0 [ocfs2]
  ocfs2_reflink+0x335/0x4c0 [ocfs2]
  ? ocfs2_reflink_ioctl+0x2ca/0x360 [ocfs2]
  ocfs2_reflink_ioctl+0x2ca/0x360 [ocfs2]
  ocfs2_ioctl+0x25e/0x670 [ocfs2]
  do_vfs_ioctl+0xa0/0x680
  ksys_ioctl+0x70/0x80
  __x64_sys_ioctl+0x16/0x20
  do_syscall_64+0x5b/0x1e0
or
task:reflink         state:D stack:    0 pid:18465 ppid:  4156
Call Trace:
  __schedule+0x302/0x940
  ? usleep_range+0x80/0x80
  schedule+0x46/0xb0
  schedule_timeout+0xff/0x140
  ? ocfs2_control_cfu+0x50/0x50 [ocfs2_stack_user]
  ? 0xffffffffc0c3b000
  __wait_for_common+0xb9/0x170
  __ocfs2_cluster_lock.constprop.0+0x1d6/0x860 [ocfs2]
  ? ocfs2_wait_for_recovery+0x49/0xd0 [ocfs2]
  ? ocfs2_inode_lock_full_nested+0x30f/0xa50 [ocfs2]
  ocfs2_inode_lock_full_nested+0x30f/0xa50 [ocfs2]
  ocfs2_inode_lock_tracker+0xf2/0x2b0 [ocfs2]
  ? dput+0x32/0x2f0
  ocfs2_permission+0x45/0xe0 [ocfs2]
  inode_permission+0xcc/0x170
  link_path_walk.part.0.constprop.0+0x2a2/0x380
  ? path_init+0x2c1/0x3f0
  path_parentat+0x3c/0x90
  filename_parentat+0xc1/0x1d0
  ? filename_lookup+0x138/0x1c0
  filename_create+0x43/0x160
  ocfs2_reflink_ioctl+0xe6/0x380 [ocfs2]
  ocfs2_ioctl+0x1ea/0x2c0 [ocfs2]
  ? do_sys_openat2+0x81/0x150
  __x64_sys_ioctl+0x82/0xb0
  do_syscall_64+0x61/0xb0

The deadlock is caused by multiple acquiring the destination directory
inode dlm lock in ocfs2_reflink function, we should acquire this directory
inode dlm lock at the beginning, and hold this dlm lock until end of the
function.

Link: https://lkml.kernel.org/r/20210729110230.18983-1-ghe@suse.com
Signed-off-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c        |   32 +++++++++++++-------------------
 fs/ocfs2/namei.h        |    2 ++
 fs/ocfs2/refcounttree.c |   15 +++++++++++----
 fs/ocfs2/xattr.c        |   12 +-----------
 fs/ocfs2/xattr.h        |    1 +
 5 files changed, 28 insertions(+), 34 deletions(-)

--- a/fs/ocfs2/namei.c~ocfs2-reflink-deadlock-when-clone-file-to-the-same-directory-simultaneously
+++ a/fs/ocfs2/namei.c
@@ -2490,6 +2490,7 @@ out:
 }
 
 int ocfs2_create_inode_in_orphan(struct inode *dir,
+				 struct buffer_head **dir_bh,
 				 int mode,
 				 struct inode **new_inode)
 {
@@ -2598,13 +2599,16 @@ leave:
 
 	brelse(new_di_bh);
 
-	if (!status)
-		*new_inode = inode;
-
 	ocfs2_free_dir_lookup_result(&orphan_insert);
 
-	ocfs2_inode_unlock(dir, 1);
-	brelse(parent_di_bh);
+	if (!status) {
+		*new_inode = inode;
+		*dir_bh = parent_di_bh;
+	} else {
+		ocfs2_inode_unlock(dir, 1);
+		brelse(parent_di_bh);
+	}
+
 	return status;
 }
 
@@ -2761,11 +2765,11 @@ bail:
 }
 
 int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
+				   struct buffer_head *dir_bh,
 				   struct inode *inode,
 				   struct dentry *dentry)
 {
 	int status = 0;
-	struct buffer_head *parent_di_bh = NULL;
 	handle_t *handle = NULL;
 	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
 	struct ocfs2_dinode *dir_di, *di;
@@ -2779,14 +2783,7 @@ int ocfs2_mv_orphaned_inode_to_new(struc
 				(unsigned long long)OCFS2_I(dir)->ip_blkno,
 				(unsigned long long)OCFS2_I(inode)->ip_blkno);
 
-	status = ocfs2_inode_lock(dir, &parent_di_bh, 1);
-	if (status < 0) {
-		if (status != -ENOENT)
-			mlog_errno(status);
-		return status;
-	}
-
-	dir_di = (struct ocfs2_dinode *) parent_di_bh->b_data;
+	dir_di = (struct ocfs2_dinode *) dir_bh->b_data;
 	if (!dir_di->i_links_count) {
 		/* can't make a file in a deleted directory. */
 		status = -ENOENT;
@@ -2799,7 +2796,7 @@ int ocfs2_mv_orphaned_inode_to_new(struc
 		goto leave;
 
 	/* get a spot inside the dir. */
-	status = ocfs2_prepare_dir_for_insert(osb, dir, parent_di_bh,
+	status = ocfs2_prepare_dir_for_insert(osb, dir, dir_bh,
 					      dentry->d_name.name,
 					      dentry->d_name.len, &lookup);
 	if (status < 0) {
@@ -2863,7 +2860,7 @@ int ocfs2_mv_orphaned_inode_to_new(struc
 	ocfs2_journal_dirty(handle, di_bh);
 
 	status = ocfs2_add_entry(handle, dentry, inode,
-				 OCFS2_I(inode)->ip_blkno, parent_di_bh,
+				 OCFS2_I(inode)->ip_blkno, dir_bh,
 				 &lookup);
 	if (status < 0) {
 		mlog_errno(status);
@@ -2887,10 +2884,7 @@ orphan_unlock:
 	iput(orphan_dir_inode);
 leave:
 
-	ocfs2_inode_unlock(dir, 1);
-
 	brelse(di_bh);
-	brelse(parent_di_bh);
 	brelse(orphan_dir_bh);
 
 	ocfs2_free_dir_lookup_result(&lookup);
--- a/fs/ocfs2/namei.h~ocfs2-reflink-deadlock-when-clone-file-to-the-same-directory-simultaneously
+++ a/fs/ocfs2/namei.h
@@ -24,6 +24,7 @@ int ocfs2_orphan_del(struct ocfs2_super
 		     struct buffer_head *orphan_dir_bh,
 		     bool dio);
 int ocfs2_create_inode_in_orphan(struct inode *dir,
+				 struct buffer_head **dir_bh,
 				 int mode,
 				 struct inode **new_inode);
 int ocfs2_add_inode_to_orphan(struct ocfs2_super *osb,
@@ -32,6 +33,7 @@ int ocfs2_del_inode_from_orphan(struct o
 		struct inode *inode, struct buffer_head *di_bh,
 		int update_isize, loff_t end);
 int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
+				   struct buffer_head *dir_bh,
 				   struct inode *new_inode,
 				   struct dentry *new_dentry);
 
--- a/fs/ocfs2/refcounttree.c~ocfs2-reflink-deadlock-when-clone-file-to-the-same-directory-simultaneously
+++ a/fs/ocfs2/refcounttree.c
@@ -4222,7 +4222,7 @@ static int ocfs2_reflink(struct dentry *
 {
 	int error, had_lock;
 	struct inode *inode = d_inode(old_dentry);
-	struct buffer_head *old_bh = NULL;
+	struct buffer_head *old_bh = NULL, *dir_bh = NULL;
 	struct inode *new_orphan_inode = NULL;
 	struct ocfs2_lock_holder oh;
 
@@ -4230,7 +4230,7 @@ static int ocfs2_reflink(struct dentry *
 		return -EOPNOTSUPP;
 
 
-	error = ocfs2_create_inode_in_orphan(dir, inode->i_mode,
+	error = ocfs2_create_inode_in_orphan(dir, &dir_bh, inode->i_mode,
 					     &new_orphan_inode);
 	if (error) {
 		mlog_errno(error);
@@ -4276,13 +4276,15 @@ static int ocfs2_reflink(struct dentry *
 
 	/* If the security isn't preserved, we need to re-initialize them. */
 	if (!preserve) {
-		error = ocfs2_init_security_and_acl(dir, new_orphan_inode,
+		error = ocfs2_init_security_and_acl(dir, dir_bh,
+						    new_orphan_inode,
 						    &new_dentry->d_name);
 		if (error)
 			mlog_errno(error);
 	}
 	if (!error) {
-		error = ocfs2_mv_orphaned_inode_to_new(dir, new_orphan_inode,
+		error = ocfs2_mv_orphaned_inode_to_new(dir, dir_bh,
+						       new_orphan_inode,
 						       new_dentry);
 		if (error)
 			mlog_errno(error);
@@ -4300,6 +4302,11 @@ out:
 			iput(new_orphan_inode);
 	}
 
+	if (dir_bh) {
+		ocfs2_inode_unlock(dir, 1);
+		brelse(dir_bh);
+	}
+
 	return error;
 }
 
--- a/fs/ocfs2/xattr.c~ocfs2-reflink-deadlock-when-clone-file-to-the-same-directory-simultaneously
+++ a/fs/ocfs2/xattr.c
@@ -7203,16 +7203,13 @@ out:
 /*
  * Initialize security and acl for a already created inode.
  * Used for reflink a non-preserve-security file.
- *
- * It uses common api like ocfs2_xattr_set, so the caller
- * must not hold any lock expect i_rwsem.
  */
 int ocfs2_init_security_and_acl(struct inode *dir,
+				struct buffer_head *dir_bh,
 				struct inode *inode,
 				const struct qstr *qstr)
 {
 	int ret = 0;
-	struct buffer_head *dir_bh = NULL;
 
 	ret = ocfs2_init_security_get(inode, dir, qstr, NULL);
 	if (ret) {
@@ -7220,17 +7217,10 @@ int ocfs2_init_security_and_acl(struct i
 		goto leave;
 	}
 
-	ret = ocfs2_inode_lock(dir, &dir_bh, 0);
-	if (ret) {
-		mlog_errno(ret);
-		goto leave;
-	}
 	ret = ocfs2_init_acl(NULL, inode, dir, NULL, dir_bh, NULL, NULL);
 	if (ret)
 		mlog_errno(ret);
 
-	ocfs2_inode_unlock(dir, 0);
-	brelse(dir_bh);
 leave:
 	return ret;
 }
--- a/fs/ocfs2/xattr.h~ocfs2-reflink-deadlock-when-clone-file-to-the-same-directory-simultaneously
+++ a/fs/ocfs2/xattr.h
@@ -83,6 +83,7 @@ int ocfs2_reflink_xattrs(struct inode *o
 			 struct buffer_head *new_bh,
 			 bool preserve_security);
 int ocfs2_init_security_and_acl(struct inode *dir,
+				struct buffer_head *dir_bh,
 				struct inode *inode,
 				const struct qstr *qstr);
 #endif /* OCFS2_XATTR_H */
_



_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
