Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3CDFC46467
	for <ocfs2-devel@archiver.kernel.org>; Mon, 16 Jan 2023 08:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=uFIfJZTxNMzakcMU5GTGdqmKGvvQwZnc6NLbwDpoeY0=;
 b=1IN+9MsV5CsEfv4BL4zHLFBDqz9Dc181GbbxcQwLkfSIstM17sNoo/7QMGUrYPCtPwZnv+KyxNtI
   bvfZQJRTuF5MrMFfVkNxbSAIzcFo4Bk0F9UsNHKfGxnb4iNQZTSzwYWmrcxKgZIM7rXd64iv+NFM
   d9z5Qn96FWkpVVy1ehGVpWU9eZv4g6qf09V/LYQJWdH7I+48497t2SJjAylz7eFNls6028GKMdVk
   f5ugfVIXd7TjgFoikRmgcVAI+EjNjRPBr/aiexJjcx4g4/XkQh0nsiJJPEwc7da8/6oPzuxcNE0a
   yH2rSKS33PsygVegzzpFymj2EJitxFxhHxOoiQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=uFIfJZTxNMzakcMU5GTGdqmKGvvQwZnc6NLbwDpoeY0=;
 b=D3TrjWHWUBb+QrhssB6SSxilbNvu8OOHUbYhZQAyq/btlqEzlEhT1/4quiIfIR/Kp0jK14x7prIn
   DJwdySnRJe46dzlh6fQDjV7DTdf1zr/CHPXWCHYkQ/6bnITlPr2ifNWhHt3cP/Uk+ewEJps+0cm1
   1PPCSD721u636UMMSkjkQjlx/7Lc4j9z580xnY9vLJA32IGT0tUH8MBLWhHRq6HoL+rcSBCyEPte
   9AYCBYVDmminRYYfhVnnouwwl3QiknoMxe6XTDj6FrttShUM4qb8azswEFJbrudWngQLuqHGHg1j
   YOdGXLUgJhESSbwOEOKmytP/BVwbppCCcayDAg==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0ROK0066LM5BOG40@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 16 Jan 2023 08:55:59 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=jmbxaw5WGTdQC+qZyQllTG4rSUOzrNtp0wkWOB0SkzU=; b=S1YQa0jo9I3cRIkKUvmK7E0LAe
 gZA9QpBJWq/4q1yWw44YdYIyo5lTBj41So0EskMqctZHNAseMRrJiewDt8OHaWv56VCtYWSDkMM/w
 w9ki30AiFExrhcC68KG48eFoFc6lR/EH5r3SoH2VIHGXyq2Oux6Ef4eqSFbmDtn/RMWJ3tT9q01W7
 1hzO9c3PXTWZ+Jn6jZqG5P/iproorCh01i/UL1Yb4qwCDtNfv7F5qAirB3ZYt8p/CzRfUY29D8sYc
 UQ8L5Sp2s3JkHGZy4ZoyT7sXuZbUM0oSRzKF17mun/YTTCQV0TkAwQe1al7rQ1YAH2adR+oAfZlCz
 wb0LDk/g==;
To: Andrew Morton <akpm@linux-foundation.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Evgeniy Dushistov <dushistov@mail.ru>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Mon, 16 Jan 2023 09:55:23 +0100
Message-id: <20230116085523.2343176-7-hch@lst.de>
X-Mailer: git-send-email 2.39.0
In-reply-to: <20230116085523.2343176-1-hch@lst.de>
References: <20230116085523.2343176-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10591
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 bulkscore=0 phishscore=0 adultscore=0 priorityscore=0 lowpriorityscore=0
 mlxlogscore=710 mlxscore=0 impostorscore=0 spamscore=0 suspectscore=0
 clxscore=276 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301160065
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Jan Kara <jack@suse.cz>,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH 6/6] ocfs2: don't use write_one_page in
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
X-Proofpoint-GUID: vTJkmDFMf7kKVIL8RE4-95XiOBGXs5B3
X-Proofpoint-ORIG-GUID: vTJkmDFMf7kKVIL8RE4-95XiOBGXs5B3
Reporting-Meta:
 AAGxzO42fTkOWpF0j0vfY9y5MVgZ79lHtQBNFpM4owXgNW4WFL/GVXL8hTM1QoBH
 OiFjsjVbk6Zam8cDOvmTqIp2LTTVnzB+YKtvXi4FAD6rcS1g0YqypAbDhpLihOXb
 X2jdHSI76nyP+W28kjWNfBAUhX37NQRhZtT0f6kFhRr41Oli/V8E0XgTpofhDe41
 Tvdj+7fVeA8mvVGhXvn7GBxWVOn4oLpWFaACoZPestjpERWoZ92i15Vj1mhlzebH
 2ptycp02LoLYQOrcqajAFtRQ4k0oGoR9zvcNxS5JmwzwIIKJcRYCoSMqyWivnwju
 Lo1y3F6saRjylI6Lv4J/3uPddYsC+hg52ApcF0I/XzLcqMLzu8CMTVzWcTkvPWZR
 LHWup2mtedLl/glXWEtbKVEa/meckWybIptCYzWORaaOOOdq+cY9VB2SNq9rf6kS
 Jp1sn6UvwA9Az01iuGoF4J5F0V8FiehYsqPur6X87WPPnSbgmOO3r0IW82r0Rj3a
 EvrQVE3jKnBjRM1GnDe8mH0+GuEHOtLwKYASHJbiwuN3

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
index 623db358b1efa8..4a73405962ec4f 100644
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
2.39.0


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
