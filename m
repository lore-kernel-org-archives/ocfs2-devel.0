Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE49FC77B6E
	for <ocfs2-devel@archiver.kernel.org>; Wed, 12 Apr 2023 08:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=/DoZhbB9JFEA48DEuFyaLV5gWDhA8xxlK0iq4tr0hM8=;
 b=z4ztmZC2w54E3tcsfnXB6dOEc6U9SPvoGOO7+JibUuw34RMgppzn1a4HboscByT/I0MUkaiJ5qUQ
   oql7xAUWSrbxREkthVTxOuP82Rr8nu69C0qA+7trWUJgX1r9gWr8mgENhf86+WNDbaB7z8JZWiid
   yz8r5shVrLIIgzjJUp8pRP/cIXq6xx/Tz47AtxtJA7+gaTsYoWCSamHPWcpiL9X6FooUfR7JJzk6
   4fvChFufRzwNOnfyKk3dwTKa5CRUh+TmptFMTHYv9QORsFg1pXkHbmfiJ0lYHFHrBZOUvpp/Smn3
   k6bqmOjIgi6u3UFIYKuu5SPQCzo0f4Km1qSDeQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=/DoZhbB9JFEA48DEuFyaLV5gWDhA8xxlK0iq4tr0hM8=;
 b=RzYcGBSofQUKDhM2SI4yiBgsNDSBFfT/7KZ66MS+/DBmwwMVq+L9lhORjGH7XjQAYnnPLtBlip95
   +UB/7HIG6MdjK2Ldtm6hDivkEfSIh3UgCx0mvJYEC/qUto3vtABkcsbKny2aleRB8fTODPQUEpfA
   JWR97OKIzb6jRf5to5RIJIyIoVaCKuFjr07nJAXItCGzYGuE/Wiod1xOgNx9uWi7DgqFcymHuoyf
   DonPS1sy4MpPc6aGoKznWvIBw4HNxJJ6kNlZLxnfgxl9iQHG5qlIhr8gob/Vrm027Sfo5SU+lcqP
   vm4Skv8l0/Ry0l58X76vI2gLMQHm7ZoW0YJXQQ==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RSZ00IXZVEUW720@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 12 Apr 2023 08:54:30 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1681289655; bh=1OJVB0ldD2ZgTOu4PaJAND29jSfl8ug1eWWtSDse6fc=;
 h=Subject:To:Cc:From:Date:From;
 b=vzS07Q2eFeF51fWpKQYuRC//JinJzjreYEAzYZL8tQtq2MUXG4gczRgmf7m53MMD1
 9Y6VlX87p87JXo9j8Snt/ijdIwYKbHyXKVjXFyrUJIPRhSfBPQB09gkSDIGPwRzUt+
 7J2vORefyT+6byb3yC4p7zrr+n/k7+1ji6Ngpq9U=
To: akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
 gregkh@linuxfoundation.org, heming.zhao@suse.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mark@fasheh.com,
 ocfs2-devel@oss.oracle.com, piaojun@huawei.com
Date: Wed, 12 Apr 2023 10:48:01 +0200
Message-id: <2023041201-sliceable-sincerity-26e8@gregkh>
MIME-version: 1.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10677
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 adultscore=0 lowpriorityscore=0 bulkscore=0 impostorscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 clxscore=236 spamscore=0
 priorityscore=315 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304120080 domainage_hfrom=7764
Cc: stable-commits@vger.kernel.org
Subject: [Ocfs2-devel] Patch
 "ocfs2: fix freeing uninitialized resource on	ocfs2_dlm_shutdown" has been
 added to the 5.10-stable tree
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
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:72.55.140.81 ip4:52.25.139.140
 ip4:139.178.84.217 ip6:2604:1380:4641:c500::1 ip4:145.40.68.75
 ip6:2604:1380:4601:e00::1 ip4:145.40.73.55 ip6:2604:1380:40e1:4800::1
 include:_spf.google.com include:amazonses.com include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: 4pb0gAWlViTh9J5z7AGYGX7N8ihlUMvy
X-Proofpoint-ORIG-GUID: 4pb0gAWlViTh9J5z7AGYGX7N8ihlUMvy
Reporting-Meta:
 AAG8Fd3VFjRF4Nw+3ZiZE9eqJ2vobyj47TYgty+81A/T1DkryEQ56AlYeT//+y3G
 attDkAqhL3jyt3sAXvVBL6nnEzuMUDj1YuN7sXcZUjUUD/csSLZfKPz9BFrJ6s/R
 BAdY9dkd4p9uDAJSBYrrTVR43N4eo5j7HUPUiiYHAiZAnIfc3eY43MFkFvoefXz1
 UQ2enO7dw3X1FNo6woBFiJTMnJEux7phHSuQzE1Z0vA6xoMfdCvJ/EolkVkcITk0
 LC4QGhsdF4llez5wgdBIGIoi0/ztEaV6sEDWQ5f5utAVA8ngs7LJDsEYbp+awlx6
 Q/EcOgRgpxUcftheCYQzc06MUq72VHpSiZgQHMFudZLaFzbg95qTiXyZ8E+KpA8X
 +FdAUImdkfNulkEwK/mrxsbbwRwEhXYgt66g5Fdw6oM0LRZ0c54YU6Afs3BhN36Q
 CYvvUmURNzDBcvChrypuuJWv/gpLB/iuUxTzNJ+jmyU5toxQnhX0uOiWn432DNf8
 DHAiLiO+YAC+DxhGe68K/xR6Eygt8LChAkRdyYS2mDomVg==


This is a note to let you know that I've just added the patch titled

    ocfs2: fix freeing uninitialized resource on ocfs2_dlm_shutdown

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ocfs2-fix-freeing-uninitialized-resource-on-ocfs2_dlm_shutdown.patch
and it can be found in the queue-5.10 subdirectory.

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
@@ -3396,10 +3396,12 @@ void ocfs2_dlm_shutdown(struct ocfs2_sup
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
@@ -1922,8 +1922,7 @@ static void ocfs2_dismount_volume(struct
 	    !ocfs2_is_hard_readonly(osb))
 		hangup_needed = 1;
 
-	if (osb->cconn)
-		ocfs2_dlm_shutdown(osb, hangup_needed);
+	ocfs2_dlm_shutdown(osb, hangup_needed);
 
 	ocfs2_blockcheck_stats_debugfs_remove(&osb->osb_ecc_stats);
 	debugfs_remove_recursive(osb->osb_debug_root);


Patches currently in stable-queue which might be from ocfs2-devel@oss.oracle.com are

queue-5.10/ocfs2-fix-freeing-uninitialized-resource-on-ocfs2_dlm_shutdown.patch

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
