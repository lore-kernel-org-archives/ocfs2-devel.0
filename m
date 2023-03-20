Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51547C7618D
	for <ocfs2-devel@archiver.kernel.org>; Mon, 20 Mar 2023 11:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Pzn3SlDwEUtv5zfSmcMAe0oqUbAuOrAbCqYkIsPNaQI=;
 b=YQrlP01k3mVPrCVwtYkbchRGFV2uK1+mzvXZDV/a+YXuEFGyJziyoGHrtNSYo2EIKMZFwx+f4/Ug
   k5WkkTk+nL8sjxVAAJ3JG7c276HQDg7FASH05i4RdKya646iAdR+G+GDjzea3OzqmEj9pV/Eo5ZZ
   LNBQqYQYYw719aDo+D1Y7Tzsio1WfvHCKAvecCBHLAOXHcSXtuJJnxErn4b7gYFcevWwdfEJQbAk
   PahL1UhZc67UvXUiNIA1Zys+GRN90wuu2JCoEEKMbBdZACZtMyHCVRSGmeMw2eWk/1PBGYJykr3d
   fsF46K+trzoE8sP6zvngU8BYrMqsYZYv0FuTLQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Pzn3SlDwEUtv5zfSmcMAe0oqUbAuOrAbCqYkIsPNaQI=;
 b=csdx6BVaCL9eQXuHNGosykCRmvP/nLSvhgr/ZLafTCYya1SmQNc34BhxrhIKyVxVgLrMYgfJkqAX
   2XyY2G0a9j9u2RVrWroSCX56tjolnlym3Od5d5Oa47bHlBu/Yw7S0Vt7gEHAoK76uQ7yzKwg1goH
   kdaYWspD77n8IqiE73GggPlKvJ/EdfL3XwBqHfGAniKVkgO4bEBqsI0tvQQtKmxTAaMT96gwhWmX
   8do7pCZSTBrYTvf/AxT3obQdfmTSscjT6MqJ/8JOBDMWviMoFNegENq25O6tf9wq8yTVatzqgYrw
   wj93ywJ6ImW0KO1zsV8l7QW5EOmX4XT004HA6A==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRT0029OIKEC190@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 20 Mar 2023 11:57:50 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1679313451; bh=5qhNwThhRUuYbn5u7+wYmLTKT5vZk3AFW4TW9FGrxHY=;
 h=Subject:To:Cc:From:Date:From;
 b=A5NzPaP+O2QXWKL5dn51tifC2izaNw90m5AhLnFRIAla+S/Fm3uI6imoUtmNN4+OM
 29s4b/lEY9pBiA+qqyiHvqD3Hr46RmyJpQ5dCImsJMpanYOjAToiF0cgqndqzsimd1
 7+hNCODRqM79gPXxIR1fNLJkcuI+eQ7mA3vkb38I=
To: ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org, gechangwei@live.cn,
 ghe@suse.com, jack@suse.cz, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 junxiao.bi@oracle.com, mark@fasheh.com, piaojun@huawei.com,
 stable@vger.kernel.org
Date: Mon, 20 Mar 2023 12:57:25 +0100
Message-id: <1679313445246112@kroah.com>
MIME-version: 1.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10654
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=288 spamscore=0 malwarescore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 clxscore=228 adultscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303200102
Cc: stable@vger.kernel.org
Subject: [Ocfs2-devel] FAILED: patch
 "[PATCH] ocfs2: fix data corruption	after failed write" failed to apply to
 5.10-stable tree
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
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:72.55.140.81 ip4:52.25.139.140
 ip4:139.178.84.217 ip6:2604:1380:4641:c500::1 ip4:145.40.68.75
 ip6:2604:1380:4601:e00::1 ip4:145.40.73.55 ip6:2604:1380:40e1:4800::1
 include:_spf.google.com include:amazonses.com include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: 7v2KQmmG1wCNdb9WrpRYEfOLEvTmYXNW
X-Proofpoint-GUID: 7v2KQmmG1wCNdb9WrpRYEfOLEvTmYXNW
Reporting-Meta:
 AAFGTy+PsImZqMv0s67k4OXmHARwj/M+J1YjAJyM54IkD4YawR9i1NUD/uuhMQNc
 KqjYqPvtNiV5hakujnewaKodIj7iFU/QNWOLk+XBvxs0hLkNeOnG/PNLL4HKD1tH
 t/2dcxzFXy3WSXgH1dANYoRxlpDEnVGTzcTtQJqHgZmn3HHpZxv5YzKd7Pm9yCar
 dkLeaBqMiPY93+aQsu5j7jdhTi0UEKGlzqe/yHp5iygn9m1LJzNsEhf4DFgwR3CS
 HoUIM/80m/rtqHPEtoW4mKXm8CxcbagXFzYZlz7LtySQ9g8Sv6j3YgsMzTaItNrD
 GnowyWLLTTRrUDkS3YR69lNEb2YODV6uGUIo3RM/JwtQ8stxZiWvCq8ZNhh/StrK
 1PJ04mA+DhWE5kPQ7PjvHA2F56H4t6R4ZX16TSvjXE8uJ0CL+sviC1Vj9LTmfSTx
 OLxbqmRl3ACTaKQ5hCMQFQFW407SmeK7es1J+T3RVU6Rv4Eub2nE4ie416IkNAWD
 bE7oQQ6iiWookJjEZPFHEWp66Vz1aPuRA9C/fiS7RRjV


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
git checkout FETCH_HEAD
git cherry-pick -x 90410bcf873cf05f54a32183afff0161f44f9715
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1679313445246112@kroah.com' --subject-prefix 'PATCH 5.10.y' HEAD^..

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
