Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3560FC4167E
	for <ocfs2-devel@archiver.kernel.org>; Tue, 10 May 2022 04:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=pUGN47ZTqPug8RS62FS9WDcBo8/4qF62ipq6TicCuu0=;
 b=QNJCtP8Jh51ddmvdRwUtnH5mHhr0V9aYgrLVmUvWnOKAzM1ikXlkpSDP4ZNMmu3fVvoa0hQKaHtn
   S2pNg+R623J7dHlSsoqdANNK4yooo5goDGEEVZ6WbskPWBPHPcU3sCFvanj34Po8QetQF75laKXu
   DgONLluAnds4n9D5T4xDoWOZRUn9YhkgKXLq7X4FlcmLIKw6klrz/D78TUA8pg09RpuMEmD69+38
   lUK1V+jT5ggiI8zT1fSVqO9v6st46i+X5kedtMc3c21lJgNV7FQ2Ivic3buaEgB5dZuAq0MUSy5r
   i8w+N69oZRkV91aaDGGJFOyUUql4NH5z0YPyTw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=pUGN47ZTqPug8RS62FS9WDcBo8/4qF62ipq6TicCuu0=;
 b=T/R20WSrUHq7qQDz8WU/yN8D0fGy4R4qcL783E/yGbSFq4VEFbDPX5/dSjZGnEqdF3Ra6eehhsOo
   Enn0i+iA4L1ReOViOZ7vaDOymIJF8oR2ZbgkxYcvLxCyR3WvUXNAO+DA4RantPwTOrPS/xYPz0nf
   YxPZtfRVjcrIwgSiQO2Xmzsv2rHxcGIgcKB6SxzW3d6yYvq+/lPQgMjLwysOqoo3v1SyFL82e25R
   DHL9wIue+YT4EWnfcALnsBvNsztIYG2FUNp4aaM8ekYmdYXdRhdPdLMdty76rGjN0+SySCSJ8eac
   P3gmV0GZAMqgZOjXM8OZP33MbN/STatAfLyyxg==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220413 64bit (built Apr 13
 2022))
 with ESMTPS id <0RBN0045XFXNZGB0@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 10 May 2022 04:17:47 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1652156251; bh=Ywr22M+rOwkrTzxNPtVretQRFsuu4texbLElra41Ru0=;
 h=Date:To:From:Subject:From;
 b=uDWu8XKb/b4ws+KUl7sGUBUiMjsTBb6fFBjksHd3mfqXLbvdMtYAbUxhsmxhmDlLC
 pBzsdbSkJggosUEbXEF43tSjbgoxxdYO+i0d8oEY/AX5620KH7Akat9QQRfPWGO4Tm
 PrhgO0a1z0gja0wyuP9Lamui8Tv1jpjwsKIBdU+0=
Date: Mon, 09 May 2022 21:17:30 -0700
To: mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
 junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
 heming.zhao@suse.com, ghe@suse.com, gechangwei@live.cn,
 ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org
Message-id: <20220510041731.39412C385D8@smtp.kernel.org>
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10342
 signatures=593155
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=108 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0 clxscore=191
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205100018
Subject: [Ocfs2-devel] [merged mm-nonmm-stable]
	ocfs2-ocfs2_mount_volume-does-cleanup-job-before-return-error.patch	removed
 from -mm tree
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
X-Proofpoint-ORIG-GUID: ilQI1_Wkt45fmkHG3E0EquRN5kAo0NgF
X-Proofpoint-GUID: ilQI1_Wkt45fmkHG3E0EquRN5kAo0NgF
Reporting-Meta:
 AAH6lJyuKiC6HayDWshegOwppSBYonVZEVf5slEpk57wIVfCeR67jOv32GYr3yl1
 nOdKY5U814Y+ckTwg3xt32DKETHyql8Fkwiq5s5dJCVrvjLl0KR4NyMauhbN8cQk
 XZ3CPm2PTaMGpF+Yy2memV08cxayg3gpdRFhrAXXQjiZuNRiNwI40Fi4qbHodrdJ
 hDJ7eM3x89MCPtCez5frExFEcR5ptVEJWDXqljFX+fAQMyRTqkOntpXprNvQQNR2
 pJbD1jtVwfZdSKT33X0iurjxEmkz3w3GHSfDsKU3wdIdPh2wAS10h39o5VxWzL7q
 rCfIO5CM/lcbNLCDHNniOrCba73Nufo/Kg3CrQhdu84WpB9tTN6puOlE+plPZ7wx
 gMvFGqrQqADX48suzGigQ3JSKJDN/6klwqDlgmM3nTpomQQlZ+sdoDhU3wl2Nd7p
 BwXekpIrauDXEZ4zYMMJFfw0rqSt1Rj9bHhxIIh8vDU8O5Kz6W9QT4B7auYVi/c2
 nVJT18PVNAHw+ySL68wmEIdIJKYNLhQ0rlbJJYPoi1c=


The quilt patch titled
     Subject: ocfs2: ocfs2_mount_volume does cleanup job before return error
has been removed from the -mm tree.  Its filename was
     ocfs2-ocfs2_mount_volume-does-cleanup-job-before-return-error.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: ocfs2: ocfs2_mount_volume does cleanup job before return error

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
---

 fs/ocfs2/super.c |   35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

--- a/fs/ocfs2/super.c~ocfs2-ocfs2_mount_volume-does-cleanup-job-before-return-error
+++ a/fs/ocfs2/super.c
@@ -1803,11 +1803,10 @@ static int ocfs2_get_sector(struct super
 static int ocfs2_mount_volume(struct super_block *sb)
 {
 	int status = 0;
-	int unlock_super = 0;
 	struct ocfs2_super *osb = OCFS2_SB(sb);
 
 	if (ocfs2_is_hard_readonly(osb))
-		goto leave;
+		goto out;
 
 	mutex_init(&osb->obs_trim_fs_mutex);
 
@@ -1817,44 +1816,56 @@ static int ocfs2_mount_volume(struct sup
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
 
_

Patches currently in -mm which might be from ocfs2-devel@oss.oracle.com are



_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
