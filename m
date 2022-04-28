Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9133CC433EF
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Apr 2022 22:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=inj559O1/vdbCC50s/nlQrkVMTNkcVb+xcQija2D5ks=;
 b=Sd9TxuO93Xbg29D8qON+s2SL3hjTOq9r3llY+2wgtQpI2ch73536GczslccnqG6t6VS1XKfin5jf
   8o+cNjXjOqBwiSZd2wcamMwfJiQnAU0wKsgBjzGbYcvz5I2hFqH5QpwZh6vksufGYUDOrOJRzYsR
   4nxbbOmh21pBHdMpxiqmoxI8zDfAb2gTq4k45ja3bt0ZwjctT3sCekI+CtZNadxhcr+zenNmHQ3e
   H43KjIhC2TdqKUztMquhvVIhRgsYw1Wev3ypM+xeXKXKSMvsIb/bDSoWhifjDpLMl33HPY+E4W9e
   dCqEhc0zTVMLEU7e+4V0wmxf3ySM28/9pbZECw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=inj559O1/vdbCC50s/nlQrkVMTNkcVb+xcQija2D5ks=;
 b=fEQHZSpuaMicAEzQ2ZoJZldbFZEz/SX7OTI33ZnIebto6vL222SVz/8Zd1ZR/pzVA10NMRFxJs0s
   hdC/D+4xMMqQ5px6i8A4wpJPiMxe2oGyY0Mfzjsho+nwVu3/loeD+5PgSow6SdS49gpC8IGVDgoZ
   EmI+vZl1GnUe4SsFoZmIdTa9fMpfn8wxIyTgu6asHfKXlXFMFYYCmTt6kjgChy/hc1KGWazS0EH8
   Xi32rB6QgLgdSL4NK66hzjz+gYaLtK9RrUyYdttd2WGXZ8A/QiiDkhC0mCJnK/KZBf6djB8EPy61
   F/FzfhqMA4Jixs72O5HBE7VU0iwJxnwqyOPIOA==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RB200M5EL4PIG60@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 28 Apr 2022 22:00:25 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1651183210; bh=Ln9KjwUV8Rfqyjb8oZIh2Mdltn2aWlIUwxsAu7tWB8o=;
 h=Date:To:From:Subject:From;
 b=kpV1xq3A/qNbj5iC34LmFRFNEqA5BahgESdIYfvsVFCnTSx/YUbKgYSRxPRdzWIPn
 +Fwc8qCJGmvHuZg6athRgccr7NVG3h8UBJo9+xPTQGPufnApm8iT1788HTGTdLWXB+
 zxxnSVWeG3cmWqmtymSKIG3q0Rn6HLBhDIUidYzo=
Date: Thu, 28 Apr 2022 15:00:09 -0700
To: mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
 junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
 heming.zhao@suse.com, ghe@suse.com, gechangwei@live.cn,
 ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org
Message-id: <20220428220010.56645C385A9@smtp.kernel.org>
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10331
 signatures=591664
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 malwarescore=0 clxscore=185 mlxlogscore=999 suspectscore=0 impostorscore=0
 bulkscore=0 phishscore=0 spamscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=134 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204280128
Subject: [Ocfs2-devel] +
	ocfs2-ocfs2_mount_volume-does-cleanup-job-before-return-error.patch	added to
 -mm tree
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
X-Proofpoint-GUID: IHLbmYo39MXYXJ0mvPDOEYNWWjNhAD79
X-Proofpoint-ORIG-GUID: IHLbmYo39MXYXJ0mvPDOEYNWWjNhAD79
Reporting-Meta:
 AAEv4NpNGzUwwyd6ySTqwyq2tWasWMurjXgcJrate524715VuHe2liKHxJ6BoG2z
 LOfrIX3l6c8yZQ3yjvcyP+m2bqeTKs0NSD+vCLEqE7DPYf/aE5LaU7MNOuvKUE1S
 5c8kjytBastKXiDB0D6XjtHB4+8lSFSdbM2xKp5fmGfRIOltLULTiZohfVSqKsY1
 AuaGlDqHHglX3bETwJq26+HEAX1ys4ATqsp/IM1xcq2e4bMHukDIoiOIMf+2avDd
 zHxje0kfxvx22k3/KROYdq3cdZxMgpC8zRA46dHxqTMM8mw7NJcfHokeJgoxfDRQ
 TEjeFRqSppTGglBAfCUYBNnt+gLuYDqkyQwGaxb3SnrJVw/wkHnkKQcrBvh3IFk+
 uOpxBhAKaM38v482PFH2904qFjox7ih4wVzMe860y5qkpYViJXAFrRzgCn+Swv9a
 YalMoxvYyuu9O5/vwN+PPB0g1x1ycTRbvTspKYGhyMi8GPXZMvOTCTzJPaEIcP9N
 ZD0vigqEthpZ7Pu1X2aUCFfO3AiutUcSjArvQQ5bZ6kd


The patch titled
     Subject: ocfs2: ocfs2_mount_volume does cleanup job before return error
has been added to the -mm tree.  Its filename is
     ocfs2-ocfs2_mount_volume-does-cleanup-job-before-return-error.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-ocfs2_mount_volume-does-cleanup-job-before-return-error.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-ocfs2_mount_volume-does-cleanup-job-before-return-error.patch

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

ocfs2-fix-mounting-crash-if-journal-is-not-alloced.patch
ocfs2-change-return-type-of-ocfs2_resmap_init.patch
ocfs2-ocfs2_initialize_super-does-cleanup-job-before-return-error.patch
ocfs2-ocfs2_mount_volume-does-cleanup-job-before-return-error.patch
ocfs2-rewrite-error-handling-of-ocfs2_fill_super.patch


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
