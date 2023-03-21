Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2A42C6FD1D
	for <ocfs2-devel@archiver.kernel.org>; Tue, 21 Mar 2023 03:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=+WrT0Vqb5GndrtJcsS9m5VQFt/StEEi9ZGS7rf775ro=;
 b=eYE6C7eogkbzNd8OilvRlL3WjjoxgUCy6PtU1xUrIla8o69dZYlA9z4XKQBKXAvtRiecyVL0EAWd
   ugpaeMdWMrEpydrHtWs5ScxXqFJm3loatROhreuWwySLJ+pFCft6MPbES0FYSX0p50Ae3w5q652f
   ZHXui3R6DGHHWr+UDoZuKu8fIFdBJSKgneDMWwiU/40H9avAK+vjGHCB1etza7DsUy4yVq1KJcp/
   gOogAYxqjz7gi1Y3HJfX0kg5uFQeb9IjeEPxmpcKjQaoBJrxrfBez7VyikW3my/ruFoFzJPooK4d
   3/K5JJsWa+goo0kDFvlgUw2HM13Jwc4itw+wkw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=+WrT0Vqb5GndrtJcsS9m5VQFt/StEEi9ZGS7rf775ro=;
 b=SXwGYcybXHO/2XpCm2Ba+ymqtvPMeMWyR8/nCAFKk83WeSgYQS9tDwK2n+R5MMwYe6PEkesfINTe
   paG0fE7WYbQgI14QoBIoRLZIdcIGy3aC/9099HdE1nOK5R1W1tHVPG1zxg2meOMNNnwt84VFj8Bt
   608+UxiUlWRZY9kOJ55qAFFLiTSMLp7t4hFnxQpFrf1ptwWZnJgE+oPL4X+zs8YgBggun7/oN/5p
   kmFJkwSxvUgLgtxt2yeEOB4NLFD0ggyNJSyrTKeoUDKLgDtLUtlGPxYhJFmBcDJQ8nPTNMc2DHfy
   7LTi5YEoEpNKsIwZFNaQRrRUWaQtR9djTeGZMg==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRU002J3ODG9UA0@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 21 Mar 2023 03:00:52 +0000 (GMT)
To: stable@vger.kernel.org
Date: Tue, 21 Mar 2023 11:00:32 +0800
Message-id: <20230321030032.237859-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-reply-to: <1679313445246112@kroah.com>
References: <1679313445246112@kroah.com>
MIME-version: 1.0
X-Source-IP: 115.124.30.98
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10655
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 bulkscore=0 clxscore=114 spamscore=0 malwarescore=0 lowpriorityscore=0
 phishscore=0 mlxscore=0 impostorscore=0 adultscore=0 priorityscore=134
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303210022 domainage_hfrom=8741
Cc: Jan Kara <jack@suse.cz>,
 Jan Kara via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix data corruption after failed write
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R911e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018045192;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=11; SR=0;
 TI=SMTPD_---0VeLAXn8_1679367634;
X-ServerName: out30-98.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: mO3sWlXu8jOVaH9dUa7y8Pr6zWdwHZYW
X-Proofpoint-GUID: mO3sWlXu8jOVaH9dUa7y8Pr6zWdwHZYW
Reporting-Meta:
 AAEm5tb/jBMbA2K2LkQgUHaCrXOAMaCwizaVRkz7+w6zqY94JOc8gtu8Gpyx/YEc
 XXJZE56X0AQKZKUUnFdYxO+9sfzvcueZA1iSUl7sdNpzHAMLBnUnIbhybOuuLVmW
 Qb2AR1KP8IG5ued5FaD60chCpTGo2JbS1WgzGjgpnJij067no0d9IeJhKpOLr+b9
 3KnLGAtpFaxWGzLP5TEzeHjR5R21qLxfqjrziDZJ/R4+Cc3tx4FxSkt7gI7GpG+x
 zV5ETDsOV4mMm6RwjkXT3FBWZXv46SPWx5vIm0jzV0y08K8PdJI4V67d/Ca6SKUc
 FkIqWOLMaFJhxTMFD3NuCgRzQYDfJmD6RGWhaEU6FwMIeGkDtMNEENkUa+hkYhTY
 CEwpP24T0l31BOQsrKw6sZI1fN0FVj8nkVivLlVoy/izXNVUAJSa90nsWcQHM6M+
 IkyKXyZkadiyIqABepw6MEOQgP6IlF/JmvWF+0jZkiQAmCkYAU065PEHTaGisTS0
 uZ1cv1mhph+FdDA7Lw49w55gRFWU6cCxyKmU9tc9HzmE

From: Jan Kara via Ocfs2-devel <ocfs2-devel@oss.oracle.com>

commit 90410bcf873cf05f54a32183afff0161f44f9715 upstream.

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
[ replace block_invalidate_folio to block_invalidatepage ]
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/aops.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index ad20403b383f..9b23e74036eb 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1981,11 +1981,25 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
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
+			block_invalidatepage(wc->w_target_page, 0, PAGE_SIZE);
+		}
 	}
 	if (wc->w_target_page)
 		flush_dcache_page(wc->w_target_page);
-- 
2.24.4


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
