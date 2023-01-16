Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75894C67871
	for <ocfs2-devel@archiver.kernel.org>; Mon, 16 Jan 2023 08:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=lSLHW6NBJEWSo4eRLy1SR6gt7q4rfkqrhZNyZZDlLz0=;
 b=POTOpgnnoJ8L5dtRJtTq7cZwGhxpL6OzpGE4BQfCQfogVW6c5fceBhnMpZJNA5ti8kg2F8nbgWym
   GFemQsVxOT7bYAf0gi2S3eUDNONai7GH3ietccVQ2vlm+j6qGIsrozWyohaIK9Wgs8bz9t59QYrU
   OgXSbeLySs/yPOa5RL1UyOv5H2Z8GmcTIbho1Kib7RD9jp/gQB9qiP3fYK6ehReLkgrNtbZWqkrG
   WA2CHScxxF2hiWUVuA4lKM9mndWPsXEniegdFjFXEEgfaqrRerOJYZC2FtdZBSH5RfaB84mYThrt
   Cogk+qTPiAS8SY8nqSx7yQDjUNvsugRgk3cJaA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=lSLHW6NBJEWSo4eRLy1SR6gt7q4rfkqrhZNyZZDlLz0=;
 b=Zv/cckhRrVJ3a2+WyGXh2YqxCtpZDri64eE+gCLJdMCJ1BzMl2nLF6urXuxt4ygHXQmeom6qRs2Y
   3PZ1uIw5F84DRjrTDnq/zIPuLhVQX6CeSvMDS8yqCdJ/ylHEvBEehZ+nHF8UkwJzpuOI+vLs+myS
   FxlVwCgiEaqaKQKrsx6iY3YcUXX4hdfq+TdBmvz4tvJewG6nluNu8S1fGLhLkISrZNXZbAQyFtwW
   PpNpjno4iJr1JFW82wOLpY3op2/kFxKUnAGEBWpoEZ2V9WM71uhWe3E2DJzBiALgkLgnsPDzj3Dn
   qTzvD+BccLKYaqYpz9QIpa/t0ve2d/I45MYYQA==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0ROK00IQGM53SPC0@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 16 Jan 2023 08:55:51 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=OG2B/ZSWByZRN4fMNjXk/odq7YMNkG/R7DDN5iMhUtQ=; b=Jv+WhniY9VGch/zC8+PJm+chhT
 /+rHupK5uBALMlQaZjsepoMcl0mFl8uuNrYuXeGgWwGj280ui4kquded1Op5jmigdG0CjbLd+GpKk
 XFjxxRaTMGGMYG/Opr2gTEVG87otTdyk3f8TYMf9cI3e7X5AhB4ud2Di9Ptan7y6agqCRO2RhWRsv
 Hhx+g/gzwuId7dh/3Wc8WfDcAdvNfyWswpDFfQCatswiEOV9LxxHcAHtjbj0lRK9O/lYSyK3ZTARP
 3MFPat1picSmsva4N/FL6ON2qSYkYLSo9kJf0HEAU3aCjtxxKnU9sMTH3fcrzJ3qOIfIKQjh4fQoa
 FeKc/8kQ==;
To: Andrew Morton <akpm@linux-foundation.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Evgeniy Dushistov <dushistov@mail.ru>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Mon, 16 Jan 2023 09:55:18 +0100
Message-id: <20230116085523.2343176-2-hch@lst.de>
X-Mailer: git-send-email 2.39.0
In-reply-to: <20230116085523.2343176-1-hch@lst.de>
References: <20230116085523.2343176-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10591
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 mlxscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 priorityscore=0 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0
 clxscore=281 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301160065
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH 1/6] minix: fix error handling in
	minix_delete_entry
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
X-Proofpoint-ORIG-GUID: DanXZ6hxo3XOQpq-OGDLTcMrVxFta0iO
X-Proofpoint-GUID: DanXZ6hxo3XOQpq-OGDLTcMrVxFta0iO
Reporting-Meta:
 AAF52hXlZbKCsi6KFkGGog+inSxsRNW1S0LLVo6sX5gGWAfuAlerj1MVinMqhUmM
 DdxDBLr7OYWKUm/ELd0hQoVuekn4JDgm4Fszmy/KpJ+I1NaUqdoK8cod8TepjM0Q
 FlRlsSz3gGKvHvwXJrR1L9cvhuxm4GwmcSJPy0pc0B9fwt/afwLjv0D/vo9hFa6E
 NGu99JBWSdq2eDfNdVlBhhW7dpn4Qv5LipPhNIqB2lOtlf6iExxV376HQBAyZeEx
 1jpyFD4iN3j1QfNG0FHkDW8TQOzwbMeC87zMjcyY2rBMofQrytWqntmGyXqPJRyi
 USi/GbzEIpoYw48YBffENEHgLDLzHNFEkrw1IJiN64saqHdbJOkL4kX3x74elkc9
 Be4YsT2Qa0XcA9dPrPGt58fSYepzZnFazZxpuzPg7uRR7Lmir0mqstvjBzQPPts8
 m6B+qpdnpefmH5uasZycqWGFBhGcuYrqsZjBAI+rlO0hKcYz1MDcpyWlEJRaZgEd
 a0ivh0pZWo4eOprt45gl2jpV/9kwkQEHGgGeKUwPN9++

If minix_prepare_chunk fails, updating c/mtime and marking the
dir inode dirty is wrong, as the inode hasn't been modified.

Note that this moves the dir_put_page call later, but that matches
other uses of this helper in the directory code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/minix/dir.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/minix/dir.c b/fs/minix/dir.c
index dcfe5b25378b54..a8e76284cb71ec 100644
--- a/fs/minix/dir.c
+++ b/fs/minix/dir.c
@@ -297,18 +297,19 @@ int minix_delete_entry(struct minix_dir_entry *de, struct page *page)
 
 	lock_page(page);
 	err = minix_prepare_chunk(page, pos, len);
-	if (err == 0) {
-		if (sbi->s_version == MINIX_V3)
-			((minix3_dirent *) de)->inode = 0;
-		else
-			de->inode = 0;
-		err = dir_commit_chunk(page, pos, len);
-	} else {
+	if (err) {
 		unlock_page(page);
+		goto out_put_page;
 	}
-	dir_put_page(page);
+	if (sbi->s_version == MINIX_V3)
+		((minix3_dirent *)de)->inode = 0;
+	else
+		de->inode = 0;
+	err = dir_commit_chunk(page, pos, len);
 	inode->i_ctime = inode->i_mtime = current_time(inode);
 	mark_inode_dirty(inode);
+out_put_page:
+	dir_put_page(page);
 	return err;
 }
 
-- 
2.39.0


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
