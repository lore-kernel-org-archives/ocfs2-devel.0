Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C715CCA47B
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Jun 2022 15:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=s8KrmFbgQRKKH4XtKAGN9sJfUjEvUFQvsQjn+zTWssQ=;
 b=m0TA+3FrydkmMOkdXHQUZ+iNynrHDy2WVwVvL0xcxE4NAcEYQjlRCiw9enBw1swSUdF4C9HRj4F+
   TPCV1I0RfmAbXJwqVTmt1+FnkZjTw28if3EWPU88NiieyOpn9XLi0XKHRTRZ+8zurYpEdXKviU7A
   3XdhKtGn3w2ZlTMhh6X9tMEMjoY61L15Oy9lsbcYVN29eGGB3gdhmmkhaSSlF2DkZhld5W4gn8e1
   Zh4SKk+8oVV6WlJUj0Hkkm6dOKgZV6dVj7UvXulW5Tn21skh8yFw3aPhnywg3orXu2ENx/WS+2uH
   XRfvcAvYzdqC+KONzc8w5JwaEKysRJt8vzkfkA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=s8KrmFbgQRKKH4XtKAGN9sJfUjEvUFQvsQjn+zTWssQ=;
 b=QAQiTE3KeuWJkEvlvS+V6PI0ZZboiAfmDtb7dteKYc6TeTdlNt+Mo2RrvdzbeWkREEMdxV/GfVM8
   aNOvrKOChlnGWDtly7hI8NhCNpbXsWBKWZE9Yl5fQ7heAdKr4M4qgvHVgsf9BYMwyFUhrm2CEMd/
   yIdMh36fpiGOJ+yM4UJd2RfJdHD4kvjMTWa3YXI/t2/rXVK6qWhoTbf4keGjq/eL0LcQEdU6Tt8I
   VspqM3BhgMlHtsLssMTaid+v/pjOwuRGiy1S1qD8ZH1Xynpsr4ysxj5jtmOmORMRyCahgSKT/bI2
   Ogi0dGDFDLzmV/2lgCeBDn6sDHSMtW0Pr47sgA==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD500CGUZ5PST10@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Jun 2022 15:03:25 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=z93Cnt+g7bn8Rks2qPHkqYOXC3V0vuJ4otfYMlwXMI0=; b=A8DhNIxJJ669f/qkcLeDGf72ZN
 VH8LAA48msbBnAVr0E+7FelEvxIN6WeTVVsY3+XbJ3JFz8o4YxHui00x1Y70h4ocWwm1rEhwBIjKN
 KqmXwNooNqQHQTU0PGaJX9VSpy4TIudFD2m7wXi5brVUZ9sATYKFon0A8unvko2wdijgsEP55z5gw
 LICUf+6yA08O9mkZ2CoaqXjq3c6UpqxZ4JALyMMrvUsNOS/irI5NCXGs3fXnIssRB78QjoY8+rsu6
 2JldLt7koSxVP03aOcqMPx4vsCCm76xYnTTjxDObf8Wn4Fx8tpZC1OJvSXomcGoxR7FYaLBgr8kSN
 KwIQrhwQ==;
To: linux-fsdevel@vger.kernel.org
Date: Wed,  8 Jun 2022 16:02:47 +0100
Message-id: <20220608150249.3033815-18-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220608150249.3033815-1-willy@infradead.org>
References: <20220608150249.3033815-1-willy@infradead.org>
MIME-version: 1.0
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10372
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 mlxlogscore=508 suspectscore=0 mlxscore=0
 phishscore=0 priorityscore=220 bulkscore=0 clxscore=163 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080064 domainage_hfrom=8380
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH v2 17/19] secretmem: Convert to migrate_folio
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
From: "Matthew Wilcox \(Oracle\) via Ocfs2-devel" <ocfs2-devel@oss.oracle.com>
Reply-to: "Matthew Wilcox \(Oracle\)" <willy@infradead.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: casper.infradead.org
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: SjfiCp-lBMFMEBLiV9UP1r0fiucbUtUd
X-Proofpoint-ORIG-GUID: SjfiCp-lBMFMEBLiV9UP1r0fiucbUtUd
Reporting-Meta:
 AAEiy20VH7JJgfXbsHcbh5n9oHYb7IpljKsUarkqZynlMjwA6ZmSeEV6Z2dR5V3+
 HCVYxVhZejKqB5xNgASN03z+MmDWXjZPxOlNjchvtIfeybFfiKNOWL+4mMLrkBpK
 qPpRn+T0wQv4WrAnY2m8usP3u8Xz/gMLGMlWImSwEQYNIdrPCZYmc2xdtjt7bGZA
 4w2zUPylDb90Tt1VKxbJ0XQu2UIxZk3QKBygm1u1OFVfWb0iXRO9gwGYM8HdNxee
 pOgTAIZZ2J8U0k4+3UpzJgCUAbiuvvYUc3PmABlVIjI5vCm4f8O0FH0OxgZBvDNP
 HzPqKWCniiKG7NunvKaNHoXejXByqFgIuyiY3l903uz/Mw3qmaBSG+XUoJFcE3ay
 8/j5jyeyXl7U91GHiMrJ6oXah60yHBb3nXhelxCZvBuG8PAw2TFTgV1SVq39oQP5
 UTR2CYSrHmAsXcit2rcEL5i3O9QhOotcgONeYBDlAJVh4JCecVLvR4D4e5nfVcFN
 N8VLKbCGP23SweJYhNtY6zMI80NiVrdrWP+j9QxkooI=

This is little more than changing the types over; there's no real work
being done in this function.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/secretmem.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/secretmem.c b/mm/secretmem.c
index 1c7f1775b56e..658a7486efa9 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -133,9 +133,8 @@ static const struct file_operations secretmem_fops = {
 	.mmap		= secretmem_mmap,
 };
 
-static int secretmem_migratepage(struct address_space *mapping,
-				 struct page *newpage, struct page *page,
-				 enum migrate_mode mode)
+static int secretmem_migrate_folio(struct address_space *mapping,
+		struct folio *dst, struct folio *src, enum migrate_mode mode)
 {
 	return -EBUSY;
 }
@@ -149,7 +148,7 @@ static void secretmem_free_folio(struct folio *folio)
 const struct address_space_operations secretmem_aops = {
 	.dirty_folio	= noop_dirty_folio,
 	.free_folio	= secretmem_free_folio,
-	.migratepage	= secretmem_migratepage,
+	.migrate_folio	= secretmem_migrate_folio,
 };
 
 static int secretmem_setattr(struct user_namespace *mnt_userns,
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
