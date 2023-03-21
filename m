Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D83A3C6FD1D
	for <ocfs2-devel@archiver.kernel.org>; Tue, 21 Mar 2023 03:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=yYLgZhSxv2502iXF7MHrvWhVGUbQYch3TSTgeDnBER0=;
 b=idE/zznXuBwjbKcICzCTHY59DhytPnboL8aX7jfUi1jJbEpgabN4HyUMPDcU7/grQLrFEf3RRtw4
   Dz2+yK35Gkh/xAKJYW7asqXHOTT/hDsKhYcdfZpCh7oDEyGlZuWwpDOl4YACbPPloGpnb01BVANl
   Rdq7Y/dvAAPrBMOGcoJL0lplvBUFfVGVgQ2xeTc1mNFKH7XxkaSdHFFDoDQdXSAAAYoKiCjXrsCc
   PRtFZlJM4v+BijExPL0I4h6iXSs6wVbY2vIdjYfQTq9EBAxnEA0bxQkT0oDAbO3D944IghgwxmxD
   Bno+arMyPiV3Yn43lv23s0T/bpTfbN74utBUSg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=yYLgZhSxv2502iXF7MHrvWhVGUbQYch3TSTgeDnBER0=;
 b=qXi2QhVRQ4OOsS0y47+dcEJpW2Nbxt3SNCkhzIJQEterzm8DA1uCxx4ss54xkBUS011WHpF0UfjH
   yoz1uvgnoj3kH4CQQVeNQ2PVzQvpp260SkRq+wW6O7HTiFVdFVndFtWvLzJ8t6l0KoAZO4kHcMZe
   FrhAg995+PSHhCD6TL2tTP+xpDBf0jop8r7idSytNPZXehPRNJEBw+LyKyZR+y8XE0LZx+NOxqbz
   6vvJSQ5t0qMeR05wPLR5IjomAJ3HqlhnKqOJpg+2/aHLmYhGse/Wkgg8RssNoWwAM8FSB/Yu4Pk4
   uZfBkY+ToZg1d9JpkFfnXEFVMfD5+qgvwPQcrQ==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRU00DSCPALKHA0@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 21 Mar 2023 03:20:45 +0000 (GMT)
To: stable@vger.kernel.org
Date: Tue, 21 Mar 2023 11:20:24 +0800
Message-id: <20230321032024.165992-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-reply-to: <16793134471133@kroah.com>
References: <16793134471133@kroah.com>
MIME-version: 1.0
X-Source-IP: 115.124.30.119
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10655
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 malwarescore=0 impostorscore=0 suspectscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 clxscore=57 priorityscore=132 mlxscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303210025 domainage_hfrom=8741
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R631e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046049;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=11; SR=0;
 TI=SMTPD_---0VeLC9Fu_1679368827;
X-ServerName: out30-119.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: TBmzjNJu3wQjhid7rv7PijxGuSPMiM5N
X-Proofpoint-ORIG-GUID: TBmzjNJu3wQjhid7rv7PijxGuSPMiM5N
Reporting-Meta:
 AAGAA706d8Wj3QvaCwi6yR38XblTDbxl81oeK9nI7M8GiDQDJ/1YiP67j3pWMFLv
 kM77BEyggLbPIAPByobTxhB6f7SYtuRfD7tXENH4ZI9nkNBmocXIvQ+69ooKedr7
 J5BjM8nB5dqdrhpCGs6LWzDMQh5WhUDX7wrg4aKDxJ/ugP+sZt56L00zmbwrdKUA
 Ca+6UvZ2jMpGXQ1xM7OQ91ivZAoP+tvsB9xfebB1KJDQ6fpl3bqf1sGlKL9+aFmt
 82e9w+MMrhahCSmTkqWkzSkbypzlQ7qIgZ8wLzkyMKyaPvcUAASS1QuF23X2int9
 fWnVQq17yINu62FT2GpeCqn9/eAN3jCQnnZGc5Q74cKgH/EQj3CrpPhu4QSNMX4Y
 nEJmXLm6sZIKqBXDypBKm7RhrYnKtqic10H+njuZfxqIK3oDOYOLbcN+FhT9/oUa
 XOgHPP0TE32sioaVXl/UzVT/fmc+jXCeJeSgoQ0TUoh9sUekptf5Ol9xQ+xHlnGG
 ypZBixUU0lBjVYa83TNi+RvIXnmpeTAlBjSjAknbaKRT

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
index b6948813eb06..1353db3f7f48 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2003,11 +2003,25 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
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
