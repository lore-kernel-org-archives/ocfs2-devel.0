Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 389E1C61DA4
	for <ocfs2-devel@archiver.kernel.org>; Fri,  3 Mar 2023 23:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=9l4j1VG1ymxlVmMJxlnXPeEiz5BVUucmFTiGP4zeMR8=;
 b=zoKIcaG0VrqJPhzd1t6YojMEeT01b7VekfHcDSzq7Qyq4H0e5u7renLRgBBcnyRA2eqfH4T2YrMM
   Nwy95q6Et2ekmO8/C9sqEEp/Yp4l0bUWO1mbDja+ea1jUoLdb5JNcINHnUT7D0kOdrc0bk0lCTK4
   cLOvyH9HTOecofDd/BAlFeTF/NKiIHnkLFaK2ClIG4bzfNWtsFe6TyZLXh80sAJ+n2Oo9Xtt6+Pn
   xfec42MiaODCYCBk6NVMx6rm4FN5nMdur/e2m6h2cKZyBMNUDXkox/ptgp/eNIBduy6BUwcR3un6
   /Pz52wZtJb9u0g1RWNms8vu+9vLW7EDEnkmOyg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=9l4j1VG1ymxlVmMJxlnXPeEiz5BVUucmFTiGP4zeMR8=;
 b=px8+LZz1u0Fr6oJ0m9rimSxba+CboXIC5Bc9KpoQmmNR3sE3JAgeqVzzCxhksoDnFfI/CnW9L8wi
   ZXa2XAIne9Q40AerUnuimNh0kQkU8IufmbQ33oMmra6qqSTxLjO2yJ4nxYkaqLCMTjvZOWUGBXr9
   ClMAIn3ErcrbW0B0KNxjS2wzLkUvFMOAWeOwUgT41xWE2WSx/RmYZUF1hwZ277QebXWF7sQa64/N
   gaFBTuJHUwq0myqotqjgIdakueM7fttogIqJ7TfaMIeVYAS2MmVAptN9X96vo/+KCSrA9NapsqL5
   /GRM/FZHxpnLyglpuGsNNDDdb2Dtj5BFIbKCCg==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RQY007OTW5KQW90@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 03 Mar 2023 23:05:44 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1677884727; bh=n62ceeWcGjGnzmAy0Jo2RzbuLFttIwzcyIbR8PZ6ls0=;
 h=Date:To:From:Subject:From;
 b=HOLJxFxrhwXrfm/T7L1aEKiHTxJPKj+V8O+Roa7wYX1kwMhoVYDOsG+ZPD2D/PjC8
 EFrSFERZf1p/DTUz7VMDxi0yCUQVkKzE/Vv7hBlHO9V9YgN0pNVHYeYAo8G85V6nxS
 LmQ3pHmOPZ3zBNGcjjxIRMXW0RsIVrKzWxnDA2u4=
Date: Fri, 03 Mar 2023 15:05:26 -0800
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, piaojun@huawei.com,
 mark@fasheh.com, junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
 jlbec@evilplan.org, jack@suse.cz, ghe@suse.com, gechangwei@live.cn,
 ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org
Message-id: <20230303230527.7951CC433EF@smtp.kernel.org>
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10638
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=999
 clxscore=135 lowpriorityscore=0 priorityscore=95 suspectscore=0 mlxscore=0
 spamscore=0 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303030196
Subject: [Ocfs2-devel] + ocfs2-fix-data-corruption-after-failed-write.patch
	added to mm-hotfixes-unstable branch
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
X-Proofpoint-GUID: OBfetSD46rdwZQcTqDhepbPYeE-gGX8D
X-Proofpoint-ORIG-GUID: OBfetSD46rdwZQcTqDhepbPYeE-gGX8D
Reporting-Meta:
 AAHKV3K7avKEIgIJy0kGqly7te24VSm87QnP3hpyQTmm3ScW7gccp8a0h4hhbitf
 yCzY1LPzk1LRCa3fGNidWR0g6HwJco3M06OT0nD/yE9AacPyiEGIzVBrOztjqS5E
 DRsm5Wi/PVgTjl1jI1FirkAO40kH2ilhtTXMjNcJQ+KM0EcE2AxZOMi+nnHS7eRu
 Dm5umqyafTKx5lxdBzX+m25MgwJ3FqJ9v65nZ+Nx4j1cRgSfy5aAFl4Vk8T7DwVR
 COu6u4sd8NI0sJvLY7Gd6czpgJp1z9i1QDeP1pgvnKprfNxdJKFt7Ix0Mnn10TUR
 QRtMG2kdpPMnmaAbQgfH+H6Ojor4TsXND3ATnBHB1jnx2VyetL6woPPNfTodcmu+
 JE0qEeQM/fXi6Tk5GOwSs565+585yjS2RfYLzx3zwwfQ9AsPWaftUo5yRD2AYIwY
 +kGoXDSt5JNEzVm//iZk1+YzyslZJCfZmFmeuFY3zab7Fe1KKXEQjFfHOgK9uE1l
 V1/obLEOPlW4uPH0sLM265so197MtOO3avIAnNU7JVA=


The patch titled
     Subject: ocfs2: fix data corruption after failed write
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ocfs2-fix-data-corruption-after-failed-write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-data-corruption-after-failed-write.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Jan Kara via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: ocfs2: fix data corruption after failed write
Date: Thu, 2 Mar 2023 16:38:43 +0100

When buffered write fails to copy data into underlying page cache page,
ocfs2_write_end_nolock() just zeroes out and dirties the page.  This can
leave dirty page beyond EOF and if page writeback tries to write this page
before write succeeds and expands i_size, page gets into inconsistent
state where page dirty bit is clear but buffer dirty bits stay set
resulting in page data never getting written and so data copied to the
page is lost.  Fix the problem by invalidating page beyond EOF after
failed write.

Link: https://lkml.kernel.org/r/20230302153843.18499-1-jack@suse.cz
Fixes: 6dbf7bb55598 ("fs: Don't invalidate page buffers in block_write_full_page()")
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/ocfs2/aops.c~ocfs2-fix-data-corruption-after-failed-write
+++ a/fs/ocfs2/aops.c
@@ -1977,11 +1977,26 @@ int ocfs2_write_end_nolock(struct addres
 	}
 
 	if (unlikely(copied < len) && wc->w_target_page) {
+		loff_t new_isize;
+
 		if (!PageUptodate(wc->w_target_page))
 			copied = 0;
 
-		ocfs2_zero_new_buffers(wc->w_target_page, start+copied,
-				       start+len);
+		new_isize = max_t(loff_t, i_size_read(inode), pos + copied);
+		if (new_isize > page_offset(wc->w_target_page))
+			ocfs2_zero_new_buffers(wc->w_target_page, start+copied,
+					       start+len);
+		else {
+			/*
+			 * When page is fully beyond new isize (data copy
+			 * failed), do not bother zeroing the page. Invalidate
+			 * it instead so that writeback does not get confused
+			 * put page & buffer dirty bits into inconsistent
+			 * state.
+			 */
+			block_invalidate_folio(page_folio(wc->w_target_page),
+						0, PAGE_SIZE);
+		}
 	}
 	if (wc->w_target_page)
 		flush_dcache_page(wc->w_target_page);
_

Patches currently in -mm which might be from ocfs2-devel@oss.oracle.com are

ocfs2-fix-data-corruption-after-failed-write.patch


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
