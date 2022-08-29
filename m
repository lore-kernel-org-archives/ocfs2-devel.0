Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB924ECAAD5
	for <ocfs2-devel@archiver.kernel.org>; Mon, 29 Aug 2022 07:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=c0fBWcWKLTqaySlDdx7RFWd/TriB1Yv4tBQilW2B1Vs=;
 b=H4fapQgQ1qyNVoAqPRC9hxuo+Xg/lhvb2Tw+YniRHBepZfpyrb1Aa/XdttaoG5gY/f22DPdYXDCM
   4uA8r5+yrwwglTnwWJPYPMnmwkM+ubeATLCo/mXKiyphPZhQpPBynLqCs+I0FsRzApZwpfnj+8T6
   QJMvFqXDn66YRjGWx15HNJ4ljA9JHYuC/Acf61iwwqa0/RfBA7qNIA3zHNuDaa1BD3XqT9gNSuze
   fBQYHB90IC8OZ1khbhEutdy5yJpHYZ0665nqmFW7QpwdMh6UZTfuQb8Lmi47UmmdhsSevD+g8ItN
   KWNQBEZ/YdOujN8/psdCMi5Tr8elpxt3xty7pg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=c0fBWcWKLTqaySlDdx7RFWd/TriB1Yv4tBQilW2B1Vs=;
 b=bRwygHLqakWifTG8nsnRZTSTYoe8KWWWHrwF0ERs+9xt7FLIGmO8hBR4Tfjom8T4Odtl1JYytRK6
   ASd/YRwb6teM4v6J1kHceAv5oE1dmLsPqlOlIKLfpeU+vjEslIcabPnzvkMGOE3v1+xLx2QSPbM5
   i9mNRcwYAf+X6/8e1YEk0foHWTuY4BeKgT/+PWI7fDXOa7RfbZYkx9dh7fQohoCblXE+BKsfgD4+
   4AEyUVsqBDJ+739xhxGWHVjjWQd/1DgWDkwe6MoeUori/HUAFmsyp3xdEt5x6GrtbT+Zlcnx2wbV
   V14q5r9b6T3yJpXVr6EAsEe/g6Q1mBLcu/dNGQ==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHD004KS9UMNK60@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 29 Aug 2022 07:51:58 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1661759503; bh=/EjyRTwXd5enHWZJkBPrKu0xFc4ChMsFdLbtaebQHe0=;
 h=Subject:To:Cc:From:Date:From;
 b=FAeOdFHu1guXSuFEHrlWnMqUzy8HINZFRcmX4ecNV4VR+Ri2x30zhDv2j2pV5NyxE
 7E751SRN0/1PcBbLMfseZBv1mFqDkmk0ZcqIEYNZAxieWDdOyG3VxRv6wRgT+X784Z
 VSh7VCAdbgUBFSgLvjA7rAhNM09weWUahvo6ElWE=
To: akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
 gregkh@linuxfoundation.org, heming.zhao@suse.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mark@fasheh.com,
 ocfs2-devel@oss.oracle.com, piaojun@huawei.com
Date: Mon, 29 Aug 2022 09:49:07 +0200
Message-id: <166175934735189@kroah.com>
MIME-version: 1.0
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10453
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 priorityscore=208 suspectscore=0 clxscore=155 adultscore=0 lowpriorityscore=0
 spamscore=0 mlxscore=0 malwarescore=0 phishscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208290038
Cc: stable-commits@vger.kernel.org
Subject: [Ocfs2-devel] Patch
 "ocfs2: fix freeing uninitialized resource on	ocfs2_dlm_shutdown" has been
 added to the 5.19-stable tree
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
From: gregkh--- via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: gregkh@linuxfoundation.org
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-stable: commit
X-Patchwork-Hint: ignore
X-ServerName: ams.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:72.55.140.81 ip4:52.25.139.140
 ip4:139.178.84.217 ip6:2604:1380:4641:c500::1 ip4:145.40.68.75
 ip6:2604:1380:4601:e00::1 ip4:145.40.73.55 ip6:2604:1380:40e1:4800::1
 include:_spf.google.com include:amazonses.com include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: ARRTSuT3cLasBnnfZAtAMiDD8bvfJJDS
X-Proofpoint-ORIG-GUID: ARRTSuT3cLasBnnfZAtAMiDD8bvfJJDS
Reporting-Meta:
 AAG3HoSpOlsBxa3+kALVCYkqnUb4XG7OuqzTIuug9SEWRJRl793Bq0ijZ9iSITSJ
 YnGQEi5A9jph3gn4ufGf2J/qU5OLEtDrpAgyhW2qBLQF/TRoDrwnOcDm59Uz7TTI
 RnJEyhfBbyARHfZtQQjcRrAoAWcGX4wNHeEmYYye9H7aBvvk5sIw5WyDm4G8kFey
 6oJC4+VEJAo0imYUfwVRQe4nQ21Jw2518Bb9UgbwomoAvhdYgz99iqLNbC3vRvVp
 kErxBlHjsHS+sOQI5P597YLW+yi9JAlqp9LpAwjUURjVYvke43ta8Rmeicsxo4g1
 n5wJNy6KUP7z8h1bXHfGn1JhLz/X8+C6XVwlxvBo9/PU0vgQUvAZ98+fJsTAdthD
 0COKSJNWS6RnAVn2Rv/Hn/VcOS0teUO8GIrBKnNRqzW/FH6/9aDdJvivvE2T5LVJ
 VIkIMRF7t2WmtFIMsZ9ydiOo9N0MkuG1XtkivOC3D3Obmhcxkkw1htYZ1l9yy5ao
 vaLHSGD5bFgxdUBo6VJ9ecn2OQDpzpz2fV3xkDBPNIE1


This is a note to let you know that I've just added the patch titled

    ocfs2: fix freeing uninitialized resource on ocfs2_dlm_shutdown

to the 5.19-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ocfs2-fix-freeing-uninitialized-resource-on-ocfs2_dlm_shutdown.patch
and it can be found in the queue-5.19 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From 550842cc60987b269e31b222283ade3e1b6c7fc8 Mon Sep 17 00:00:00 2001
From: Heming Zhao <ocfs2-devel@oss.oracle.com>
Date: Mon, 15 Aug 2022 16:57:54 +0800
Subject: ocfs2: fix freeing uninitialized resource on ocfs2_dlm_shutdown

From: Heming Zhao <ocfs2-devel@oss.oracle.com>

commit 550842cc60987b269e31b222283ade3e1b6c7fc8 upstream.

After commit 0737e01de9c4 ("ocfs2: ocfs2_mount_volume does cleanup job
before return error"), any procedure after ocfs2_dlm_init() fails will
trigger crash when calling ocfs2_dlm_shutdown().

ie: On local mount mode, no dlm resource is initialized.  If
ocfs2_mount_volume() fails in ocfs2_find_slot(), error handling will call
ocfs2_dlm_shutdown(), then does dlm resource cleanup job, which will
trigger kernel crash.

This solution should bypass uninitialized resources in
ocfs2_dlm_shutdown().

Link: https://lkml.kernel.org/r/20220815085754.20417-1-heming.zhao@suse.com
Fixes: 0737e01de9c4 ("ocfs2: ocfs2_mount_volume does cleanup job before return error")
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/dlmglue.c |    8 +++++---
 fs/ocfs2/super.c   |    3 +--
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3403,10 +3403,12 @@ void ocfs2_dlm_shutdown(struct ocfs2_sup
 	ocfs2_lock_res_free(&osb->osb_nfs_sync_lockres);
 	ocfs2_lock_res_free(&osb->osb_orphan_scan.os_lockres);
 
-	ocfs2_cluster_disconnect(osb->cconn, hangup_pending);
-	osb->cconn = NULL;
+	if (osb->cconn) {
+		ocfs2_cluster_disconnect(osb->cconn, hangup_pending);
+		osb->cconn = NULL;
 
-	ocfs2_dlm_shutdown_debug(osb);
+		ocfs2_dlm_shutdown_debug(osb);
+	}
 }
 
 static int ocfs2_drop_lock(struct ocfs2_super *osb,
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1914,8 +1914,7 @@ static void ocfs2_dismount_volume(struct
 	    !ocfs2_is_hard_readonly(osb))
 		hangup_needed = 1;
 
-	if (osb->cconn)
-		ocfs2_dlm_shutdown(osb, hangup_needed);
+	ocfs2_dlm_shutdown(osb, hangup_needed);
 
 	ocfs2_blockcheck_stats_debugfs_remove(&osb->osb_ecc_stats);
 	debugfs_remove_recursive(osb->osb_debug_root);


Patches currently in stable-queue which might be from ocfs2-devel@oss.oracle.com are

queue-5.19/ocfs2-fix-freeing-uninitialized-resource-on-ocfs2_dlm_shutdown.patch

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
