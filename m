Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17078C678D4
	for <ocfs2-devel@archiver.kernel.org>; Tue,  7 Mar 2023 14:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=YcebhLoim+Fy6UoGTzHAq5EVgTZLWtFHRZ0y6Wj0+HQ=;
 b=BW4Yxzhbn19CKdFaHsmW8KznsLrgnMauT3Q8p0dqXKGvkWH5crFrlKn3uM10dMuesx8PYZS8KORD
   4sB0hzme01d38fDZz6i1lMke5MGJoCC8ONXKx31kVJpMvPPygJ+svCX9TkPWOcIHdxibMDth7c10
   TJWT+tG96Ds9MkhPQjRs778vFXdw1rwo2zmPfcP/+cFDrh+UCwTntZjh6H+UFgjLr3PtjrY2kHPS
   S8tfIft2vPxGmPF5QC9RxPcJ1sDug99JYr1JVDPjEwgzmngJiHdcomm2mla/pZGTc9ZDHqRfSD3D
   Tfz0RYbN+rgaf4Lc0sJsKocVSQvLuds3LT4Aaw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=YcebhLoim+Fy6UoGTzHAq5EVgTZLWtFHRZ0y6Wj0+HQ=;
 b=TWr5FablNS0P4DD1HxTrvmeLGfo+EfT58TgN3jV/j0HHJPGcg6FCbIpiG0rh59jHypfXHssO5L+g
   ZMwgzoVqnYwjZVcsX8gfKxz0flNs2KTybuS8Bf/YOKSo9SqPrtGtBkai93ksMVS+Wq8+QdSJyS0v
   gh2HgFETPA8iqGpVVUHwTq1x8CKx5LBaC13T2vPcIOOgME9JtkzDxWmf8ZKApejOL7P6LE9ZrGEk
   zxnFhXzwIKFZYjsKtfcANchRfG2EchgSFj+u86bEiaRqhRewqR7m0WJMAY0OPR4z+whV9Nhfwo70
   jqgpLcpmdzsR93xoW/zAIOqeOb6RcF6D12FBaQ==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RR500H12N1AD000@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 07 Mar 2023 14:31:58 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=UGWQTbH2jOdjm5UmRPO29E2KQdhHJ0tZTkacHHl1ybM=; b=hHmIfAdmONUXB7VfpMgzlTeP/f
 vKEmQRnyu+zF3eg7XfFFFAa+9LXiDmWUlg9nR7yFg9d6CbyAN8m8ldDcuAw91co1/eWjkcRLm2Ruf
 bxto6xenQm3yG4Dq4enOdlzb18L/K0ZmgpJM9UVFIZmgTy5soXMGsbnUkvR9zHB43OSR708JVpT0W
 mncs7Q0O7fGPxVX1oOdZxhq8vv1tFEXoX1edvvxKmydDxR2bvyXYsyU43D+lRH2u+z0pgTHzj3Cox
 Lxb8Ox1vcK/GcArTVFy8OQj1inKpNwkqKmOYNLepslNx/zZtXX7NGacblLoLxnJBAzAaUA3hsqViC
 NPAlh4zQ==;
To: Andrew Morton <akpm@linux-foundation.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Evgeniy Dushistov <dushistov@mail.ru>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Tue,  7 Mar 2023 15:31:24 +0100
Message-id: <20230307143125.27778-3-hch@lst.de>
X-Mailer: git-send-email 2.39.1
In-reply-to: <20230307143125.27778-1-hch@lst.de>
References: <20230307143125.27778-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10642
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=679 malwarescore=0 priorityscore=0
 clxscore=176 mlxscore=0 impostorscore=0 spamscore=0 suspectscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303070130
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Jan Kara <jack@suse.cz>,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: don't use write_one_page in
	ocfs2_duplicate_clusters_by_page
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
From: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Christoph Hellwig <hch@lst.de>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-ServerName: bombadil.infradead.org
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: DLPvO9ZkGZe2GvH7pJ-9QfJ8JBYzK_Jd
X-Proofpoint-ORIG-GUID: DLPvO9ZkGZe2GvH7pJ-9QfJ8JBYzK_Jd
Reporting-Meta:
 AAF62uKuZfFzfsfLHrq+ZOxkyIVaZtaqnTZYgXdjVWVNWzonDCXA8Y+gSFPxa4P+
 gej2MiwqCmD5EuQyGP52Sjt5dU7Yri4Vw4CyeHwK2tUOgKVx91SvFqhrPzYx/ml5
 JE85G3JQc1E/I7i6yuqyZnTuUyOBcSHS3u19zjdbia8X6933o6uXU0xM/ETN5e8m
 qNQbtmpDldOXYxp6C/ECkIK66v8DZxTIqzfZilxhu9dEZzy+5qfhKnMjsxervfQ2
 mqaXUyv7oAgj/EG904JqJ1/WWLWH2KBnOb2ie9zZ6wpOPRAuxpwpcN+vuHHXQd5j
 DLAnuHmdZF6QkCL/xpOgt3S3u2u88hDHy9xn/bVF1ANyXzGnKAJ2D5nq8hQQgC18
 OHGTNLqRWidGEWBv7NvWTFd3BBvamu3aSVfcmiFSotsvQ3dTEeHbg7zNjbAwcrHR
 HU6YipfPNgOH8IL7wMKitQsl5jYlQoOkxJO5ifFOPIiQaB2Yrk24CWM+QJyaGw6y
 tScun+W06g9k0oXtVPVLXbGZuROUlSfId0jW+UeQqORD

Use filemap_write_and_wait_range to write back the range of the dirty
page instead of write_one_page in preparation of removing write_one_page
and eventually ->writepage.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/refcounttree.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 5a656dc683f108..564ab48d03effa 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -2952,10 +2952,11 @@ int ocfs2_duplicate_clusters_by_page(handle_t *handle,
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
-- 
2.39.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
