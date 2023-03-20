Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 300DFC7618A
	for <ocfs2-devel@archiver.kernel.org>; Mon, 20 Mar 2023 11:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=cQyKX/KbGQ1gBiDyhOLmH1O9Na2bZ9UXaJ/zKm6j74A=;
 b=YYz/B7IlcJrT15RGfV9Ffx+Wh7rwqDe23aGNPJLGQrPRqwPJZa6bvrwh9F0DrXh9CX7W8AugP690
   M0ygOg81ctXKx6U3DuDFQQ9f1y51siSS0OzsSC9qkCb7cC/vYJG2sTbEGgtJppy5BGvBWV7/rkgF
   BObHhAh+oV5kScaCp8hE1cSzvJ2r8QWd1lc6+PKpSqVzc55DtAgZUDV+ucgiKcLTzK5SuMXKSomj
   tNClF7l8bYMLdVH8JqbSHzORRL/T/KPA57aQMLBciQdf+gU4VeI4Dedp9dWwM8TZGD1pWSdHXIoo
   VOjdvEzNJREKw/j7FXR0kCj2N1iacqpXOOTxkA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=cQyKX/KbGQ1gBiDyhOLmH1O9Na2bZ9UXaJ/zKm6j74A=;
 b=DMxBmYAp7V8ZLt18toFsy+10QHCG7LLEHILj2W7PUur8QxbLRAzXnoyvvLxDA6WFUzjIRBUzVT5B
   S5ZBjGnZS8RJvRXw8xCQ01QtPFfaPHPjSqOhHauCiGGybjMvT2AzpPxw6rAGUQOeoQw77DEzOygm
   pPdsm8oIp7MBl7TXR8efCXICJCDktugjXUpcTC4QwJvDuzl5ClFFGkRhz/WODL/kjzw8orMeUE5v
   AEvlxP20yXHd2MeGMxZyuK2/heZF9Y2LFDVQ69BhyhBXlB1gcv+S4BBR7mfH3fAZe1Btm3Kl0uA6
   uDlD1PENx+KiMDQlaUd2GjWc6bBObnx9FFngEg==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRT00HURINGH240@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 20 Mar 2023 11:59:40 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1679313567; bh=QT6qlnXEq9ixoKUoAaCWJUVpiVG4V2+fBsLqY0Cs3qk=;
 h=Subject:To:Cc:From:Date:From;
 b=FxnlZ6Vkcp82CVYeUn4IcraeIW/YoVwOOzhyf8Pn6pJte27L8h1drVOWL6N3nY3eB
 hRjVV/nHKcSZ8rMmVP1cUvtCFnhzWdT3d2EtO+ArS8KKnkxy8Npc6xYb/WqWYtCD1R
 ytMfKkoWkDCPpcQUvUGhSB1pIC58pXwA0NMsgIjE=
To: akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
 gregkh@linuxfoundation.org, jack@suse.cz, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mark@fasheh.com,
 ocfs2-devel@oss.oracle.com, piaojun@huawei.com
Date: Mon, 20 Mar 2023 12:57:57 +0100
Message-id: <1679313477209243@kroah.com>
MIME-version: 1.0
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10654
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 priorityscore=206 malwarescore=0 adultscore=0
 mlxscore=0 clxscore=230 phishscore=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303200102
Cc: stable-commits@vger.kernel.org
Subject: [Ocfs2-devel] Patch "ocfs2: fix data corruption after failed write"
	has been added to the 6.1-stable tree
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
From: gregkh--- via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: gregkh@linuxfoundation.org
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-stable: commit
X-Patchwork-Hint: ignore
X-ServerName: ams.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:72.55.140.81 ip4:52.25.139.140
 ip4:139.178.84.217 ip6:2604:1380:4641:c500::1 ip4:145.40.68.75
 ip6:2604:1380:4601:e00::1 ip4:145.40.73.55 ip6:2604:1380:40e1:4800::1
 include:_spf.google.com include:amazonses.com include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: HXlLS9xfK4kHMp93NqirSmwZxBAJNJc0
X-Proofpoint-GUID: HXlLS9xfK4kHMp93NqirSmwZxBAJNJc0
Reporting-Meta:
 AAEfl5sscUdE0WXny61mXFfG1lCGZ4ZiAHMQnt8u+NoYtM1iV0Af+VzQc8Nhv1R1
 ENEoVru1+jENyS5SI86RwuYa1sgZQ9iWhREhwVaMtHKAp6mPHonLfGWKoEu2NWCR
 YB18nuxUDpsQcNJggcstbM5PCIc3Vk9O6kS31Rh8DjiOzWWgof0R+uRRYdS+T0lK
 G2KwZYbj22HWX230f0BIkaZJdnuaUeKcXUFJRzgyX6lHqS+el6pwfbb6I1RraT+1
 vjwxQdPjVJ3P6LX912I91VsGSo86CStWdipv6bWHOZtRo6SLFBRprVhqXXnNrmn/
 1kBsDjm2SpMkqXqjhdIqJIcAG90z6e3eNW9mntYV5TJzJWdV0ucrWu2fQoxhzy1a
 TieyweCp0EFJmOVxKLOzILPqaRMrW9NySQqsYWxILhDkyP9gzsZ74tOzATZ7UfxB
 SyQMvaXDmgvR2WJYYP3BNTpK8BwBYoPx7LH+rbmuVmUxdhyT+BQqjdFikbXyKNlT
 YnIzphMlbImjI7ByJI5a0AIU6W21ToheWbRKMjIlVm7Myw==


This is a note to let you know that I've just added the patch titled

    ocfs2: fix data corruption after failed write

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ocfs2-fix-data-corruption-after-failed-write.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From 90410bcf873cf05f54a32183afff0161f44f9715 Mon Sep 17 00:00:00 2001
From: Jan Kara via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Date: Thu, 2 Mar 2023 16:38:43 +0100
Subject: ocfs2: fix data corruption after failed write

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/aops.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1977,11 +1977,26 @@ int ocfs2_write_end_nolock(struct addres
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
+			block_invalidate_folio(page_folio(wc->w_target_page),
+						0, PAGE_SIZE);
+		}
 	}
 	if (wc->w_target_page)
 		flush_dcache_page(wc->w_target_page);


Patches currently in stable-queue which might be from ocfs2-devel@oss.oracle.com are

queue-6.1/ocfs2-fix-data-corruption-after-failed-write.patch

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
