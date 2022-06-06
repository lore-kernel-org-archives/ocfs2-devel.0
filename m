Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2B6AC433EF
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Jun 2022 20:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=SzKxGzaHMyo5iaEhMZ9VmvqryT31JQPgBSwMdN5cpnc=;
 b=Z6DhXeWAPiMKXK9fjGlLmh175wr9j1C6D8Bcn0+VP7PMoeawaz+ug4LhT2cysXUBgFtvFpZiQSbk
   dWJiAdvM7RZ+3jaA+bUedZrPBLJrySn3h7DH3sTVpTD5kXwv28ZAC7eOLNRNhSpSAy5Tn+K+0Pp1
   a5yrhZDypYkpN2khKNGnDCOIK75XtGQMJG2EHU1wG5VzrrCEdX9zHjoEZpo9l9tnuG6gfYgmYcM/
   fEbZKrZjO9kUaTWPeZP6NlMsVIiJutSg0lhEEHYgTCemtgMOV3nQWbBiWyEwn2ciMoDQZS8ubJV+
   frlGCoBHhQeE9cPjQaq89Zi7oIxN3WWgNXvKAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=SzKxGzaHMyo5iaEhMZ9VmvqryT31JQPgBSwMdN5cpnc=;
 b=IENT6nZMrdIqDEL5PQGTZqwK9PMgLoyLYaduipvI9xcBRtrKrdaXZiXUoeI1ea+WHkuXZLoU1XQx
   L5wf4aZix8h4pdcIbp7AYEYsNabeT2YMyZUju+jXxDSJ6VuFA9jEZd/913dBDRQw9ggX5xYhiJDD
   37nSLCHC5xYjwPMNW9VtTKG0QTrfnKr4fQxp7eT1/KhK+DloMCd60FRhb+PdOuPyV6ZvUHwYBvol
   wFhUbES/jjK6CstdzUTp45JnOjmdqPLfbOCqoILAod+h3lTmKGtW/z3QA9CFjAfhughX93oBSBao
   BWdU3UlciJiuKOKlqpISu28ytgGjvFEVHrr4Sw==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD20003LPHI9NF0@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 06 Jun 2022 20:41:42 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=sw3xGMu8EIPPhanldW93F5IagC/JMQIeTrByOXSqams=; b=JRGvxIipv7m6v6BYy6Iv5o96an
 NjXbRwZx1kTpdL1gggi3uNnj2ZYHaGoDzYgFT9yWRY6RNrAPmjSRZuyOiiwaQM/1+M4AVwuYk+PBK
 EhpIMqcN0q2USPv0aKU3dVjpSas0DHRDV7v4Cj/0tVzmx9G3IVaaTh1VHsmINPnXLtdg0pn0oK/os
 mZ5HSWwosmZWEQkulkmXHnZdh3UXU16V/nVWQplhy19ME/Fyl4IioqID8E9V19f67diSrjjEsp+Bj
 J6Yy4FA8M6KmTvtuBy+S1CbohBt8Z1KKKPT8ganbhA1EGJjXoSXsZPQfL0++fMRIBpXima3JffJKS
 uzjNM9wQ==;
To: linux-fsdevel@vger.kernel.org
Date: Mon,  6 Jun 2022 21:40:46 +0100
Message-id: <20220606204050.2625949-17-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220606204050.2625949-1-willy@infradead.org>
References: <20220606204050.2625949-1-willy@infradead.org>
MIME-version: 1.0
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10370
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=159 mlxlogscore=536
 mlxscore=0 bulkscore=0 priorityscore=164 phishscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206060082 domainage_hfrom=8378
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 16/20] secretmem: Convert to migrate_folio
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
X-Proofpoint-GUID: fFXg4b7ZzURE9_pNWpjcXyFDpc2MhKbb
X-Proofpoint-ORIG-GUID: fFXg4b7ZzURE9_pNWpjcXyFDpc2MhKbb
Reporting-Meta:
 AAFoIncgYQltppzQvoGu4W81sOqKD8aOPaGyY4BItN7kLBkcXxiy48u7XqACaa3m
 KUy5WRXJQBTijgfud2BJlbgKlLALLOqAjoAEl2HVNLEzo2lp52pLHm5GXuagXCdd
 wQ5aOC14VQ6qVm+oPpv4g3JZJVDZXxpvq1t1EgVJEFW8UZ10R4EZ6QzANy65uaQj
 K7CCKOq9za3ILseTYVFtMYOl7k/uA6svmKnbB41kXimFg0A0eKc89R+Zmn0WI9wL
 a9uqAWf9M33RKuSXX1aS8VX+D3AKpIgHgTijatAgKiUybEN2FF0L2FZgXHB5gGx6
 XvsFv1JUx9Yca9mJOL7TXIaVn7D2jzhB5QpM5njWs0yAzdhgLzlebUrsHWoqLXLu
 CUgw7Ni6QgHoyU+bQY+n0NlPTWVd87AFzMUTz1vjdvp/Y8W8DD9il6EQra9Yo7ZW
 kwvNLQwMQEaERryl9uVW42NJR+x/JHua3epf6Wcw/sn6VJYriRvEADOWF2Ycwb11
 wJ1pr8j/EIhw2RiRdrgiAiXjwcuTnCMylYzgFuq3nydB

This is little more than changing the types over; there's no real work
being done in this function.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/secretmem.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/secretmem.c b/mm/secretmem.c
index 206ed6b40c1d..9c7f6e3bf3e1 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -138,8 +138,8 @@ static bool secretmem_isolate_page(struct page *page, isolate_mode_t mode)
 	return false;
 }
 
-static int secretmem_migratepage(struct address_space *mapping,
-				 struct page *newpage, struct page *page,
+static int secretmem_migrate_folio(struct address_space *mapping,
+				 struct folio *dst, struct folio *src,
 				 enum migrate_mode mode)
 {
 	return -EBUSY;
@@ -154,7 +154,7 @@ static void secretmem_free_folio(struct folio *folio)
 const struct address_space_operations secretmem_aops = {
 	.dirty_folio	= noop_dirty_folio,
 	.free_folio	= secretmem_free_folio,
-	.migratepage	= secretmem_migratepage,
+	.migrate_folio	= secretmem_migrate_folio,
 	.isolate_page	= secretmem_isolate_page,
 };
 
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
