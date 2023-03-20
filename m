Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CFC9C7618E
	for <ocfs2-devel@archiver.kernel.org>; Mon, 20 Mar 2023 11:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=HI8m6rphIAMqdlGD1we7Os+ygR2GF0omiCCBnHHQHJI=;
 b=ddfQjP/OZHJZEOrR7XoppyK6QCZCyhUbRAiJJpJwN/OzBOCFeGO0HEEsI2xjkbygghbQI28bdQRw
   UdBSUUBhq9UT2OB2sCyteA/CJ2NbxzqxG7AhOIO6lVi5ThQ3ONNnRLCgsycRuOIqelo44/8BYrwd
   UpgjHdHCiPNxfjn6Rm700l5Vf72bqftpnqfhKjOVmcJqfDqPz6XAYrd2j5tWxvM41DbAjw1N0gTg
   +s/jESwiWcjV8o5xMQztYOjESplL0MvP3hadIYGGuvnhlj348RR93mb/dOg2w343qpWb230g/8XQ
   K2ELR0t4gBnm9BsIH1Gye8fV+jN7j7uJjKRkEg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=HI8m6rphIAMqdlGD1we7Os+ygR2GF0omiCCBnHHQHJI=;
 b=FlMu5euE6YKCfvE+5VOy/6Jc7rB0FwWcWizEjEchcRaVR8hq5iMFaLvsnEdvHTC8yKwfxsxmLOzl
   e9ee3eV8mLHtH1hqQzvDD+RixtnLnemOU8iFzZAOseFiH6JGrOnedZSNRrexxEscTSBoZJzHcyIT
   U5QHNkke4+1PcbTUFAIrRhT/0tm1JbEgqFA/0rwag+Y1kR0GA7Z/hOmQ16+qbqaHvKo3jOpH16Mh
   AvezWIQksQhN2l4ZzjYqqB34UHY2MVg/YKBZCeA7020HnrQ1bewXqhdhKkSPqOBkJryaQeARvInK
   8CIxHo3/qqmT1gkiy5idkRlFt1uKOJxlgROe5Q==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRT00LNXIKGITE0@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 20 Mar 2023 11:57:52 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1679313458; bh=0ZVQDrO+h/5xBcM4V+dySDsLM0Bfo0TSb31AdigL2rI=;
 h=Subject:To:Cc:From:Date:From;
 b=v195Uv6rGABclHO2wr2ipiahXsS5V7CricjmWIgk5pU8CSTfjGVnIDf9gOLVDk6Bi
 oNEeusG437/zy6/AUp2AYS3BlL8izsDg8dgIKoU3sHOEDShaU0C02SNWAW8gTuHecj
 Z8iXQWqFbz4PZE5maS0fIsXEvoWFWhkNaLzIVx14=
To: ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org, gechangwei@live.cn,
 ghe@suse.com, jack@suse.cz, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 junxiao.bi@oracle.com, mark@fasheh.com, piaojun@huawei.com,
 stable@vger.kernel.org
Date: Mon, 20 Mar 2023 12:57:27 +0100
Message-id: <16793134471133@kroah.com>
MIME-version: 1.0
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10654
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=228
 lowpriorityscore=0 phishscore=0 adultscore=0 mlxscore=0 priorityscore=288
 impostorscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303200102
Cc: stable@vger.kernel.org
Subject: [Ocfs2-devel] FAILED: patch
 "[PATCH] ocfs2: fix data corruption	after failed write" failed to apply to
 4.19-stable tree
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
X-ServerName: ams.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:72.55.140.81 ip4:52.25.139.140
 ip4:139.178.84.217 ip6:2604:1380:4641:c500::1 ip4:145.40.68.75
 ip6:2604:1380:4601:e00::1 ip4:145.40.73.55 ip6:2604:1380:40e1:4800::1
 include:_spf.google.com include:amazonses.com include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: QQZ25WWS4b4Nju0S_aDI_e-HX86oL1Bz
X-Proofpoint-ORIG-GUID: QQZ25WWS4b4Nju0S_aDI_e-HX86oL1Bz
Reporting-Meta:
 AAGAbI3McrwbJ5PDbgOhyGUHFxDlZfrHTdNXcJ/TyL8NAWNwhXMcKJhyjOChd2nY
 JKCBi+YXxZ+SqRvjLSWUKcCqUKNfdqIG6iPjyxYpHrC2dExS+Dwe2mQzoiEXYBFc
 bC+25JpYWyPVSFP+hh8+8gxCiVcBitAr2frFlxMiocVMbyTVmBB82B6gd8i7zQtH
 Kakl5pC3zbD1EJ7uYVmxfQ39D85C+NRnJURLriLgXV2VvpZ54/eiTc/seTISG/wm
 JHloKga3pyoUN/FtRdKdG75jj/HBrr9TLFrxbKiL3e8o6TUUdht+v8BDGmIfGYDS
 ermBghAcFsJiG1No4UF3D+QhksVKPrAQqSdd91LM2vZCdNIEMayR5kHD1EwSNTJm
 ePMdW+N/mMY/XZfS2zliaNO7mBF504ZHpHwI+5pXIbWfcXI4UhHUO0rYNIRQEmQZ
 JaxjpUC7npPRpihwueQoIUfA2Di1O4t4FIf5Dlngyv2J2m4r4E20B4IdAHk9zwjW
 rVRZtJr4cuCZUfgUkBbSLrINGimMBlLxzyPJEe3qSrA=


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.19.y
git checkout FETCH_HEAD
git cherry-pick -x 90410bcf873cf05f54a32183afff0161f44f9715
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '16793134471133@kroah.com' --subject-prefix 'PATCH 4.19.y' HEAD^..

Possible dependencies:

90410bcf873c ("ocfs2: fix data corruption after failed write")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 90410bcf873cf05f54a32183afff0161f44f9715 Mon Sep 17 00:00:00 2001
From: Jan Kara via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Date: Thu, 2 Mar 2023 16:38:43 +0100
Subject: [PATCH] ocfs2: fix data corruption after failed write

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

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 1d65f6ef00ca..0394505fdce3 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1977,11 +1977,26 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
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


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
