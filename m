Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DDD5C678D5
	for <ocfs2-devel@archiver.kernel.org>; Tue,  7 Mar 2023 21:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=vQ2+nr7OwRmDIng7uc9sBBrDoS5HKzRqCECSJGBD4P8=;
 b=rU/2SKnpuL6I8jk7YQVqJmh9V2XYYnpZRFs6zt934GscRoEtNz8N282P+W5a88UOZ+7kEQxqm+rC
   flHyK8gkLAzrfrbyMO+3xBQI12jSza9bEN/TBA6reWoTJORDIuBb1u3Yxt4MpHxxAfYlRjwSMLmb
   hymcqu+Z5YuZMXxQd5ELY4gEwUoCQEZMcebaZE9PmJ/oIEfw50HP2Y5nP/2w7lghd/sYHbedUOeV
   px9IphjKbKJimijit3stAA7iQT7SU0cbCriZZL+5vk+2UlIbrDmSjS+FAq9HkoJd4CLmu79rq4g8
   15tm4EQCTNylQ2JgZSZtVHzjrOg+WaNLthT+3A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=vQ2+nr7OwRmDIng7uc9sBBrDoS5HKzRqCECSJGBD4P8=;
 b=ZJIvbWYJtwaO1Ystw1uQF6Y2dVSlPldVGH02TeuWwIC/YfdwjNYZU9Y8fEp0ei7Ocwwq7Nh3uVMm
   9PFuj57Ti+i9fFb6ePEIb+i/dx/hHJuxrx83WNtS2NBGfuTdQ1wdp+HefqXzySFOXsC5TU2BxSlL
   zIHtHSLr6nrPTFaUBCvoNnaFyCkgq6ZcVmC/6vaVnjI+EWhCrHpBRry94lb2JcQytJ7P0Buf6aou
   EOD6BtqIIqw41FRucHfUMwCv9WcDfdH1B0hp0WkhFw7oOJ6//92w+89Gi3vYzFlji5xiRUDQhdBY
   wVQ5nhQWQjifsWZrR19aVJVLNKBBKNg6BotprA==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RR600AOS6TW9KE0@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 07 Mar 2023 21:39:32 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1678225157; bh=PqKA1JZc3i4xXa2V8DEc3+xOH19uoe0Mzp/6mWxLp4A=;
 h=Date:To:From:Subject:From;
 b=bj3nmh8CvWNcEcBq4P9fDAP4K6tqU0nPHpLRae1OPYbj6FBLjiqCsSmICKUzUf0t9
 McYKpxhJm3WTIM4OFk0ZK0ZQ2k1DTEOumcS+jTPEmYteb8368cDF3JJmBb+NkDqAt/
 StOTM6Mcll9V3iRs5RFf2IgbeEv79C/LhVXed2rQ=
Date: Tue, 07 Mar 2023 13:39:16 -0800
To: mm-commits@vger.kernel.org, willy@infradead.org, piaojun@huawei.com,
 ocfs2-devel@oss.oracle.com, mark@fasheh.com, junxiao.bi@oracle.com,
 joseph.qi@linux.alibaba.com, jlbec@evilplan.org, jiangqi903@gmail.com,
 jack@suse.cz, ghe@suse.com, gechangwei@live.cn, dushistov@mail.ru,
 dave.kleikamp@oracle.com, hch@lst.de, akpm@linux-foundation.org
Message-id: <20230307213917.20113C433D2@smtp.kernel.org>
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10642
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 suspectscore=0 priorityscore=30 phishscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 lowpriorityscore=0 clxscore=20
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303070192
Subject: [Ocfs2-devel] +
	ocfs2-dont-use-write_one_page-in-ocfs2_duplicate_clusters_by_page.patch	added
 to mm-unstable branch
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
X-Proofpoint-GUID: VLh3tJmFZaaSnbwI_El1Teniratl_dzM
X-Proofpoint-ORIG-GUID: VLh3tJmFZaaSnbwI_El1Teniratl_dzM
Reporting-Meta:
 AAFqZ2zkHudRO62szXTp8fu+Bg0Nm8aYBHhCwvbEqaV2XBUfNb7HILbFmotntRD4
 WCxG9Frqv4kY62HyGk69lbLwsD2M4SdKE/++jP4/gmP3EYKvlISceVMKvLMdEQUr
 03yWWwjJNGBgULRfKI7uyzTM3DIoWSKj2XjduUD7ZbKLoPuJAK/bvWQciNNsQKA3
 DjAfnKiDDfEMIE/jne2OAJn8ep9m0Z/DJ2+mk6Dv/AKwHiNpbjmhYSamzkxOk+4N
 cMKMDgV8ko6HGyOuE+42BeTHfn0ddA97mCnVG8wfbS0GmlRkhAmbxfGJpV/s0Cea
 uv7gUaCUizOh6OeT/YBMfYTlog5VhUeKXQcXmDupKb3vfj4Rgk+k1b54USBSrlYp
 0guBlmEYrD8Cray69LqlUn/ajGlsPLakfbfnsopE8gf9gMvtQHDsSha6+HAM6+46
 Spqwg0OZDC4P+Gx0FPbQ6g4fvmzJJyO48v5eHXpdONx+sArHeqGOFCHfz8ywTtlm
 7S/6vjWjVEeKz/UPdoibPX5F3lc3lOsFVrt1AQvxE8c=


The patch titled
     Subject: ocfs2: don't use write_one_page in ocfs2_duplicate_clusters_by_page
has been added to the -mm mm-unstable branch.  Its filename is
     ocfs2-dont-use-write_one_page-in-ocfs2_duplicate_clusters_by_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-dont-use-write_one_page-in-ocfs2_duplicate_clusters_by_page.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: ocfs2: don't use write_one_page in ocfs2_duplicate_clusters_by_page
Date: Tue, 7 Mar 2023 15:31:24 +0100

Use filemap_write_and_wait_range to write back the range of the dirty page
instead of write_one_page in preparation of removing write_one_page and
eventually ->writepage.

Link: https://lkml.kernel.org/r/20230307143125.27778-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Gang He <ghe@suse.com>
Cc: Jan Kara via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/refcounttree.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/ocfs2/refcounttree.c~ocfs2-dont-use-write_one_page-in-ocfs2_duplicate_clusters_by_page
+++ a/fs/ocfs2/refcounttree.c
@@ -2952,10 +2952,11 @@ retry:
 		 */
 		if (PAGE_SIZE <= OCFS2_SB(sb)->s_clustersize) {
 			if (PageDirty(page)) {
-				/*
-				 * write_on_page will unlock the page on return
-				 */
-				ret = write_one_page(page);
+				unlock_page(page);
+				put_page(page);
+
+				ret = filemap_write_and_wait_range(mapping,
+						offset, map_end - 1);
 				goto retry;
 			}
 		}
_

Patches currently in -mm which might be from hch@lst.de are

ufs-dont-flush-page-immediately-for-dirsync-directories.patch
ocfs2-dont-use-write_one_page-in-ocfs2_duplicate_clusters_by_page.patch
mmjfs-move-write_one_page-folio_write_one-to-jfs.patch


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
