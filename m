Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4F96C77B6E
	for <ocfs2-devel@archiver.kernel.org>; Tue, 28 Mar 2023 23:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=8ZNYp01RHA0Cmmdtn8miPxOlgrNETUsmHGfF4A4N0c4=;
 b=T2j9L1J7wOdNx8AeYhuK1+TUgDsxPL34rpTK32QBzcqaxmkYcvkDZ/47+4kV1BMW7XFrs+oh0e05
   bcGTD80zMUhhpUJhNjK7hlKQJJRy9vMoLu0r284uySL6Aml3I3eCa3cGEqK8SOxkHBU7kHrqOeZo
   oAmtKHLwe31WkF4OH6u9vLXwp4SXE4szFdfruFMNSe6Ff8rvzEnEEhbfXKn+DxAUKvKcjqeGh6xx
   F1ErgCdJibaGaaZ1mraNBSWzt+fcEDcoyN/MipD2axGhJ894F5EZ+O8UCuH0iBopkqniwDLJOZOF
   b2SuSOIZwlSriz5fzXV1QmHJIinQ/sDtT2y4NQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=8ZNYp01RHA0Cmmdtn8miPxOlgrNETUsmHGfF4A4N0c4=;
 b=suXMmuNwUmBLtsw1gOYmwJwX6c/tbb5qsG9vy8L3VS9kI1GbWI9rPlm0xgiY4QDTCzFTdXWuk8P9
   kkWdz4nqROIFXqec+Gf40qriGamsm8fbKhckym1sZPTQ1vcdyH1awSvOlrk1QIb0E+ZHvDuL8K2S
   VlW6FdepD7f5euLYQcDj29WGI/wwsHKleNoyhW2abqG08dg0yhcpQC/E3UwAyfbTA3brU+m8rsAJ
   Dh5/yx5j19l1Br4E9Fh7HAUl50QUrxjCx3c72f7m9HmBhqAzsESTAd2eU6d1iVzG0XKC5p1BjSMR
   Wmi6uNd1gfPaxnN2YBHmbmchQvzaXMFvcf++BA==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RS900G7U7L06O20@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 28 Mar 2023 23:22:12 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1680045715; bh=/WSGuEQVnoddeWqG42XlhiaesRMA04POD0IoTG9BCPk=;
 h=Date:To:From:Subject:From;
 b=tfsHtnJoCQ4E6XyxdIG+hJKrnDC+3xB6n5FWeCfOSAQ9sBHlGgdQLgLPbU+SBp1SY
 Wp2DEQ02alTLHYEJajBKuNEc8E+jcP8rGnCO8IyWAS1gkeTt+AEVFuUZQXyTLaTlnz
 HSTk4u58recjMAsJ1q4VuERjc9Ma4RInq39kBAtI=
Date: Tue, 28 Mar 2023 16:21:54 -0700
To: mm-commits@vger.kernel.org, willy@infradead.org, piaojun@huawei.com,
 ocfs2-devel@oss.oracle.com, mark@fasheh.com, junxiao.bi@oracle.com,
 joseph.qi@linux.alibaba.com, jlbec@evilplan.org, jiangqi903@gmail.com,
 jack@suse.cz, ghe@suse.com, gechangwei@live.cn, dushistov@mail.ru,
 dave.kleikamp@oracle.com, hch@lst.de, akpm@linux-foundation.org
Message-id: <20230328232155.1A07EC4339C@smtp.kernel.org>
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10663
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 impostorscore=0 spamscore=0 priorityscore=173 malwarescore=0 bulkscore=0
 clxscore=229 lowpriorityscore=0 mlxscore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303280180
Subject: [Ocfs2-devel] [merged mm-stable]
	ocfs2-dont-use-write_one_page-in-ocfs2_duplicate_clusters_by_page.patch
	removed from -mm tree
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
From: Andrew Morton via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Andrew Morton <akpm@linux-foundation.org>
MIME-version: 1.0
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:140.211.169.12/30 include:_spf.kernel.org
 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-GUID: 9prKoqS3w2Loj3Ez8boepH9kxz0PoE57
X-Proofpoint-ORIG-GUID: 9prKoqS3w2Loj3Ez8boepH9kxz0PoE57
Reporting-Meta:
 AAF594EigxBgFt9fAn87aEX4JcrKbXh9t5jmeSeh2Zg8ZAgHWMWf4DVrNwsJC6kx
 Zwf089ta3jCylcLYMOnCwilXBpmSRF5H6mBFdu1jYgGjSVpVIYrGVhbVykMpovXo
 8DYUEikfE+q7pfk0yGu+8wi0IMAyk+R5bt5fGngPjy4hOM447aR5D2VgRTlvStbr
 wp07+2YKVxeOjn7MQe4IoAJ8PWWCI7+/JLBtGE2gkbem3jYr42stRpQ0FgEIic8V
 ayVWzsvA4lh7Bu0bS7gQmQaUnWFzjVrLUElCwJpRbwGXQ7AUkylnrJvFYxBrblAr
 E2mIZsgROfvrH1EToT/6edN0HWmMX14OQYuGJC2rPIj/KWGANsKRUcs8Nxji6x3i
 At/y4wR/PWAYA6IfX374yj5CATBk5GMGsXOr1Nhvy+n10qFv9rnJhrwctaMWm6jm
 HzvYj3oPerYkrlBxw9pFJKcTu+IzPPLHukgADqNzsxti4Rd0hP89BDOlslYQ45XH
 pBTXerffJPbMbzFuAlfihF+fX78SUMGKUtZXlWuPXLYJ


The quilt patch titled
     Subject: ocfs2: don't use write_one_page in ocfs2_duplicate_clusters_by_page
has been removed from the -mm tree.  Its filename was
     ocfs2-dont-use-write_one_page-in-ocfs2_duplicate_clusters_by_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: ocfs2: don't use write_one_page in ocfs2_duplicate_clusters_by_page
Date: Tue, 7 Mar 2023 15:31:24 +0100

Use filemap_write_and_wait_range to write back the range of the dirty page
instead of write_one_page in preparation of removing write_one_page and
eventually ->writepage.

Link: https://lkml.kernel.org/r/20230307143125.27778-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Gang He <ghe@suse.com>
Cc: Jan Kara via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/refcounttree.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/ocfs2/refcounttree.c~ocfs2-dont-use-write_one_page-in-ocfs2_duplicate_clusters_by_page
+++ a/fs/ocfs2/refcounttree.c
@@ -2952,10 +2952,11 @@ retry:
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
_

Patches currently in -mm which might be from hch@lst.de are

mm-dont-look-at-xarray-value-entries-in-split_huge_pages_in_file.patch
mm-make-mapping_get_entry-available-outside-of-filemapc.patch
mm-use-filemap_get_entry-in-filemap_get_incore_folio.patch
shmem-open-code-the-page-cache-lookup-in-shmem_get_folio_gfp.patch
mm-remove-fgp_entry.patch
mm-return-an-err_ptr-from-__filemap_get_folio.patch
mm-return-an-err_ptr-from-__filemap_get_folio-fix.patch


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
