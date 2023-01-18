Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37C96C38147
	for <ocfs2-devel@archiver.kernel.org>; Wed, 18 Jan 2023 17:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=uFIfJZTxNMzakcMU5GTGdqmKGvvQwZnc6NLbwDpoeY0=;
 b=aHBGJ+1wm8FlOJ6KowxjzMR9UaiMVEPWyF6Iwm0CTY0TFq57aYcggKO9ssGk35WjenOi1Mx3pXhb
   xIYINyYT+IGlEym+R7kXNlKPA0MDIVvqYGHYKoVJys5ytkYvTMIqeTbjLcnLgSZFvbIJvid1wVBc
   aJMcihxEaZuZQsjVlVA4+vQ379PO+3KVm1AtBRRk48vo9mrjfflry2PdiY4Q9iK0xPBldpiVwkzw
   haLkxXwqZ3ykvXGWk7bvSoOBjqfXGas+YybH64G5Flchh7YoZcLYqZKBFEorGSfdBq8Lx5UlJPhx
   3MR27v3nhVRmkX3msSwR+Ppyvrn/YrjJSV+wOg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=uFIfJZTxNMzakcMU5GTGdqmKGvvQwZnc6NLbwDpoeY0=;
 b=ENpCxAhNBB10BEQdAPerlzhCl5JommZjTNWMjsRIySLBJhZZUUN7Y/zIuq4VqYDGpqVTCrTYYh4C
   ryrrB9xkfCajsHqZdguCNiDbfnngy+cRltoKElOayou7fa1Dt9522kKLbAl/xVx3SMjq4yVTRX+j
   6hqW0hB/OHflqehF0gXfbqG/pjlzwmSIra5U6SHPSJlJ01ImEFKMbBbjiWNlSye5SUclL+KvKky+
   N3LIsnoYTzgkZoV6zIwERKnSmP5Fd2kUVOJKbCbSI9rwvajUQBW0lSTUTql4vNgRJ+pxqTiqV0Jx
   RiQaFOjoVquR+zlHJB0UwuPl/0sKzXx8OQFvAA==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0ROO00HAFZBY59B0@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 18 Jan 2023 17:31:10 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=jmbxaw5WGTdQC+qZyQllTG4rSUOzrNtp0wkWOB0SkzU=; b=t/tZrpSSAGJENEbey1iuxkY4ry
 DoU5y3Z4+8vXJK7yr+FX15ymQN81I4eYh+Ld5EsZ7QFqEDndjQwJk3U4pvySdS91GPbZqgEuJzKSc
 3Hb+U6bsZh23jwkljYJIRJmeZmhtzKFA2xT/JLlfnDFLQzDCMBk0IwTSypcYjKrwmJgSb/gtP6Pxa
 vqIncS8uYulKZFlO9T7OpTj0BhbtHHGYpqhOlGXM2HT8Jx9qfzXF+bD/vDHXBFJZqpMAlFvudD4WT
 VHRCcgIEGkyXvIQnY4XTtcmPCC5sJHR2bvvK4vMMsHKgWPKo5D6SKWZhgAk4rd4Vnl+qQfpUU3NGd
 DadoCs/w==;
To: Andrew Morton <akpm@linux-foundation.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Evgeniy Dushistov <dushistov@mail.ru>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Wed, 18 Jan 2023 18:30:27 +0100
Message-id: <20230118173027.294869-8-hch@lst.de>
X-Mailer: git-send-email 2.39.0
In-reply-to: <20230118173027.294869-1-hch@lst.de>
References: <20230118173027.294869-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10594
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 bulkscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 mlxlogscore=709 clxscore=239 malwarescore=0 phishscore=0 priorityscore=60
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301180148
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Jan Kara <jack@suse.cz>,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH 7/7] ocfs2: don't use write_one_page in
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
X-Proofpoint-ORIG-GUID: bZYzocttidcwiAijiD7-ZjmIIq_BIpeX
X-Proofpoint-GUID: bZYzocttidcwiAijiD7-ZjmIIq_BIpeX
Reporting-Meta:
 AAE4UilSdQ8UYp9Ztsby6U8NYi53W2Bhm4BrTEnuwRlu6qh/D5dX8vOp/B7aiGf5
 /ewZTUO/2/9aYUD1J9fLrMRe6mzJSA0wi29lt11cCP3uS0pgLPqU+pOoQViM8Wmf
 VhKV0ZmCzuylXsweSnoNXHj/3RoXmFgTyfP0wrTZWv/ka9rB+/y6NkAwSa/0AOIu
 hMZex4HP0N11E2B1CsxP9YbJwKTXEukXm7lBT82O8iNgIronqhJ+BukgR4WxhhR6
 4AV0Y4QOtko8HpiwuvNUKxEGnBD+fiBxHljoqReoXrZJI7t3h3Bxjyy9LVXTU73s
 xfC3np2gT3l8RnLYaISh0jBddYOHd/CLi/ootlVnXeouEOB3slrgqswEQVbYT6En
 Bj5qJ7SaxuAUtMOGAesIRje4AKRIPDgBOrbsdZS+PQjJGoaf21g+SW76SPJRdcFS
 N5TCDrABHfCQEZY9CQQrgg9CJX57YUYmSDpEzzUQZ++AVBsMc7O+ImLuoii6mtTX
 cQmHoB76mTlkfp+7R3QL4A3DB/D3mqCp8AGVAbGLVT8=

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
