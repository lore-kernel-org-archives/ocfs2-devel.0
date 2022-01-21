Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 270F0C433FE
	for <ocfs2-devel@archiver.kernel.org>; Fri, 21 Jan 2022 07:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=sMctgiUC1r7Faux+nsnnCQ1noNnnHCLBpC31kSkuzi8=;
 b=tvX0zK8ryanfhm2V3XQ8NT7YKeU/y7Xbkga6sB/2IvyULwg9z+dX/E98zfQDluI/Z8l6GEtU5PNw
   vA365qdfQCBab4GFgnyXmJ35k5WVBpgttboIpvgXnM8uSCTUbNFQbphKFHs5Dx1c0SVnlYtGbQAt
   OdgLfVSIQGnP4IH28DdIaQeh2Xyyc+ZQwN0uwQFPJZmG+hU6u7Llyvi1OCe11tg1Iz66xEcVBr6N
   F7jNgNf6VRpBQmWH9GyOhIYQED48XipJ03iGWt4Nv0xGu/PMOvaDmu/j7ZlmYT3EQ8WwozLHw4Jc
   bXPPMbhzfKcbmce7k9pwnARt0c1XPSEYVh1aDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=sMctgiUC1r7Faux+nsnnCQ1noNnnHCLBpC31kSkuzi8=;
 b=DdjLWiGJJLzp+Z+XkboTJSUvv4beR32h5Ou8kEJG1SKc6F4q2HDl1cCy5oIDYkp0M4ePPK34lsG7
   ntVOwo44507OWvJv+j6XsoBFJ1wejJgzkY1u0nMLLt1y9V2sgrOfdLyev/irNCthUoIQcDj1XgKg
   qnAoFW9D//OUJX6lJlugS7Dh5ShhWWG8KHwX6ZHw4uYeMDWuqDT6lcT2f3YPLZPvKbDE2XtIjwtZ
   3W0KFi5MFl5I+9DA0QoZbjO2hCKj53qPKdzNuzaDgVxZ+pdBoNAlMulfZgg+q32mCkjkD8c+PeHy
   zOSiJGV9bFslmIcR9krZqjm7u8BDCGjFyUFfVA==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220104 64bit (built Jan  4
 2022))
 with ESMTPS id <0R610000ZTCPPJC0@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 21 Jan 2022 07:12:25 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=joseph.qi@linux.alibaba.com; dmarc=none
 header.from=linux.alibaba.com
To: akpm@linux-foundation.org, tytso@mit.edu, adilger.kernel@dilger.ca
Date: Fri, 21 Jan 2022 15:12:05 +0800
Message-id: <20220121071205.100648-3-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-reply-to: <20220121071205.100648-1-joseph.qi@linux.alibaba.com>
References: <20220121071205.100648-1-joseph.qi@linux.alibaba.com>
MIME-version: 1.0
X-Source-IP: 115.124.30.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233
 signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0 clxscore=242
 priorityscore=60 impostorscore=0 mlxscore=0 suspectscore=0 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201210046 domainage_hfrom=8317
Cc: linux-ext4@vger.kernel.org, gautham.ananthakrishna@oracle.com,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: fix a deadlock when commit trans
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
From: Joseph Qi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Joseph Qi <joseph.qi@linux.alibaba.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R181e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04426;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=6; SR=0;
 TI=SMTPD_---0V2QUdB3_1642749127;
X-ServerName: out30-133.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: szNEE-tQJ1HhgCqY25iUtKBVvR94JPAb
X-Proofpoint-ORIG-GUID: szNEE-tQJ1HhgCqY25iUtKBVvR94JPAb
Reporting-Meta:
 AAHQLboMmIbUb/aFgehtVZUTBPWDpwSmM+0yT6dIpuddNwqLFVwgKjr8zs2gaZk6
 qJL2rTBxL9x4IsJ89w5XryXmcoJgpqY+U+UOI43wcba51u+9xKWCXBBIh/ugnEtC
 73i7GAFeJbJM5F+Yume3nNzSaHgzwU0Lq8ObCFO53lZbHu/sogBi9p7b3KtEENI8
 U4TzEpLNzU142YDIMltWb/14Ok+eoDY79ci1wVWVOVzVM7nuLeN4/dg0GECck8Xa
 cozAF4jr0FbYm5A+yuaP+HChl2S32A8yQPGpnngrNNrCywT8heRzyIx2rVlhVuGx
 l63ict69VT5IHbIu8KhYEDtSKB0AgjsbM5p2wv90gFrTvrz5brRWEQwcIaWwBVnB
 nnyk5J6usHYjbd2hux9rqmcN3F85OX8OMTO51p8jYCz0rglur/ZcJBCUFVrUmSZp
 +StUUocB9q1ZjPW044TM9UBPh7yuabAx2jgTP0kO7GM+ChIyeYU0dMnXz6fWl9yb
 Y/A6V3jW4fmORaqK9ETMAGgwM8txnJ/QuwEot89TPd8=

commit 6f1b228529ae introduces a regression which can deadlock as
follows:

Task1:                              Task2:
jbd2_journal_commit_transaction     ocfs2_test_bg_bit_allocatable
spin_lock(&jh->b_state_lock)        jbd_lock_bh_journal_head
__jbd2_journal_remove_checkpoint    spin_lock(&jh->b_state_lock)
jbd2_journal_put_journal_head
jbd_lock_bh_journal_head

Task1 and Task2 lock bh->b_state and jh->b_state_lock in different
order, which finally result in a deadlock.

So use jbd2_journal_[grab|put]_journal_head instead in
ocfs2_test_bg_bit_allocatable() to fix it.

Reported-by: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
Fixes: 6f1b228529ae ("ocfs2: fix race between searching chunks and release journal_head from buffer_head")
Cc: <stable@vger.kernel.org>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/suballoc.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 481017e1dac5..166c8918c825 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1251,26 +1251,23 @@ static int ocfs2_test_bg_bit_allocatable(struct buffer_head *bg_bh,
 {
 	struct ocfs2_group_desc *bg = (struct ocfs2_group_desc *) bg_bh->b_data;
 	struct journal_head *jh;
-	int ret = 1;
+	int ret;
 
 	if (ocfs2_test_bit(nr, (unsigned long *)bg->bg_bitmap))
 		return 0;
 
-	if (!buffer_jbd(bg_bh))
+	jh = jbd2_journal_grab_journal_head(bg_bh);
+	if (!jh)
 		return 1;
 
-	jbd_lock_bh_journal_head(bg_bh);
-	if (buffer_jbd(bg_bh)) {
-		jh = bh2jh(bg_bh);
-		spin_lock(&jh->b_state_lock);
-		bg = (struct ocfs2_group_desc *) jh->b_committed_data;
-		if (bg)
-			ret = !ocfs2_test_bit(nr, (unsigned long *)bg->bg_bitmap);
-		else
-			ret = 1;
-		spin_unlock(&jh->b_state_lock);
-	}
-	jbd_unlock_bh_journal_head(bg_bh);
+	spin_lock(&jh->b_state_lock);
+	bg = (struct ocfs2_group_desc *) jh->b_committed_data;
+	if (bg)
+		ret = !ocfs2_test_bit(nr, (unsigned long *)bg->bg_bitmap);
+	else
+		ret = 1;
+	spin_unlock(&jh->b_state_lock);
+	jbd2_journal_put_journal_head(jh);
 
 	return ret;
 }
-- 
2.19.1.6.gb485710b


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
