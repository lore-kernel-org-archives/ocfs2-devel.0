Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D697EC6FD18
	for <ocfs2-devel@archiver.kernel.org>; Tue, 28 Mar 2023 14:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=PbS93Pl1oSf7yxMOQG+j8iI+bXUL6HTAKOG5foYU76Y=;
 b=3BTat34gJKkEvA+vAOuLW+JBKN5hrtMlVE6+weAsPdo+wQaE/UoutdH+5C5D4jQaFcv/Y+ER3LGd
   4ox9ZviEgnu/7zm9y8a9FBvWeY5xnN3VydCWI0LhDMvK51vtdzovHF6Ek3vZ7miKHsJ7+lIJBAW9
   w2pcaTR0nfORWtUdCWVpgZRL9TT6VG3dr8PPcHLBRW5zrKZFGEnLGp/158QvYpeyztonBaBiJv+B
   lZJWOpmgKi0ROMAV9k22uJoS4UU2OTxQu/lq/juYAGAXs0Bfl17BqF0P9BnITN9F6HcRnexv4Y4D
   Kt0APydqjxgCf7+FGTIoo8acRURvyOhobgIH+w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=PbS93Pl1oSf7yxMOQG+j8iI+bXUL6HTAKOG5foYU76Y=;
 b=Oe/9z6dq3VKwPKCqzY4nNSrNNLAajzIsUZdeer+i/f9xWQQYwaVkGEq/Vc/rzHG6Hm7M7Ez4fR8D
   nU/R1a59Ehu3RXbBZSFspnPVXjCL3x/WizsLgV2+tJ3jhnuN3tqUkfTqOqak2KqZnzjApEzSTDTl
   K7ZGq6i0Lt6ZLFx+bBaCEC7LlY1TKfio4DYZHcclrF2m99YyPI9I6pjs1ol5URo2x1+t9b3mnpZ1
   iJd1/fntfM+kQJ6rQwt9PbCi3B7CuRu5lFBrdAX7dcaNFqciXeEwUvUlaF1erlvBNfBJUeEbqP3E
   MrNIX9bdN20vKT8y4mcnqVQ6jZQxXy0ZkgXD6Q==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RS8003ACIDRAL90@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 28 Mar 2023 14:17:51 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1680011663; bh=mAyk/AUzMiVuJx4brjC7E3pd8oFjvgUrjVwoWo0/+rI=;
 h=Subject:To:Cc:From:Date:From;
 b=wVTlXYdPY+PrvYr1Tb7BYH/dAzX4OLJwXR9joWzYitxjdqBRGm7Osgb06FJj74Szb
 TClt4xD2M4yK0Sd7ymkNVsv1D3KK+Ef8BFuURPm9VfnATtcNrgcNhaDu+5iL2QmuXL
 3QVR0hA1zlShO5nRfGlrhkT8pPFK/ASh7XkSvV1o=
To: akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
 gregkh@linuxfoundation.org, jack@suse.cz, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mark@fasheh.com,
 ocfs2-devel@oss.oracle.com, piaojun@huawei.com
Date: Tue, 28 Mar 2023 15:54:20 +0200
Message-id: <168001166021133@kroah.com>
MIME-version: 1.0
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10662
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 bulkscore=0 priorityscore=223 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 lowpriorityscore=0 phishscore=0 impostorscore=0 clxscore=247
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303280110
Cc: stable-commits@vger.kernel.org
Subject: [Ocfs2-devel] Patch "ocfs2: fix data corruption after failed write"
	has been added to the 5.4-stable tree
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
X-Proofpoint-GUID: yxIHleHnpCp-siT8rWYRkLZpDWNvIj-s
X-Proofpoint-ORIG-GUID: yxIHleHnpCp-siT8rWYRkLZpDWNvIj-s
Reporting-Meta:
 AAHfRJWkYlsTiwL/aPm5iFIcOC3RRnPrZUX1QhN4FZB01NWhTbtyFRIX6D2bkGtm
 dKRAMDPjbLP/8TwjunfUtB8omQalHx5PNlH46ZJ2pVCUCVG3gu6B1yuwq2GYX4pT
 n/EFJ9kxDM2lVh0ZNpCqlJHA7vclagzAFrWPSO/wzs8oens0N1JRwdHXgxE5Slsh
 ZlenUBb69Y65HST0WpFeHR8n7G/WOYs6d2FyiHo2/cS5HUU+4/vNcEbBVVn/pgPy
 YENAhnOEJJ8v2ztZbx8GHvPjr8FyRU4y9K9kOjWAilbBSn2hKamVeWPd3Hq1Xq3I
 wBgAN0QS4VxSy3YQVlEhlCFHkBptjAX/HbXbkEax14pcCDBn2FKa50x6HAHefD4C
 K/igY1ISzAYO4NTVMokyl7N0ZNprD8l61w1CoRf2re4J2IFSDAApmyE6R4W0BFT5
 FdDAh4SXWpdrcUsuZZhlicroAubhhUiZQSfsv60AHa6RxkCD4FvaPTmB0nv3qxsk
 GYKnObDPW4nWDPT5H5n+cnqADxA1zBOXsSAFoLHg18V3


This is a note to let you know that I've just added the patch titled

    ocfs2: fix data corruption after failed write

to the 5.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ocfs2-fix-data-corruption-after-failed-write.patch
and it can be found in the queue-5.4 subdirectory.

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
[ replace block_invalidate_folio to block_invalidatepage ]
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/aops.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1990,11 +1990,25 @@ int ocfs2_write_end_nolock(struct addres
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


Patches currently in stable-queue which might be from ocfs2-devel@oss.oracle.com are

queue-5.4/ocfs2-fix-data-corruption-after-failed-write.patch

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
