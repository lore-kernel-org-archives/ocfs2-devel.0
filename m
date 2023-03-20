Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23E6AC6FD1D
	for <ocfs2-devel@archiver.kernel.org>; Mon, 20 Mar 2023 11:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Sxc33eLwqGSTfyUJi3rpCNDR+nfnDL0CxTmZRo2abBM=;
 b=Q6Cvx9rYVR6CYv6Z5LXoSVUhRLIeIlOMBedaK5RQbaO/sHaL2vLymuvxZBwyKXjmkE4fV6Sd3tFP
   pt+qQtwo/E1iud9Gl+6yg+YmOo8sxzfLfowf6NGCu0oZZ+uVzlW2htztB986zrTe+UrXzPPEP4Md
   a/r3QT8s2DVTOU18/MVQ8+B/RiDejBRCErWkMvk5iGO0eZBRfrfhhWM2fqDI+f3L/Y8/1pL5CuKn
   tPUUZbhxkeJ/hn7HynQAL3xIw8F8fuLU0gwIRugsSZgtVrQga349HTRIrcuw5obrf9y4/XomKiOm
   1qenMZjUsQZJItaZPqzsJWEdIUK20N6FARhEFQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Sxc33eLwqGSTfyUJi3rpCNDR+nfnDL0CxTmZRo2abBM=;
 b=r4lgU9Oz5yUm9ZTi64KqGoRROo6o5MIGbLIYo8EnrPlmBVKEUzg0NkEbyqXK77LDUl/ldncLiGma
   TLIjgejf72tG7qPl2+t78FsD5ALftvb+BeFdNfDSzVkIHD4y5Mr+mNH7pCHx54mOSU5pkpczqaVk
   LLPj4O5nYgP+upgkRjres9nKs+rtBnPoFEiEVsuifhAvb/6IlbE7Rzk0VTsv+nQ4W+YKozZP04YX
   AK0qENZTJ5ZiNxiA742F91WBycgGem5eyp0eU8ox+eZg1dZTOpLTZvu9MAXdSxbDZyV90nRv1NX1
   eGlUfZYVBKQ6fEdJPjSZnyTvd6xXsO7iCOn7FQ==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRT0021VIKCEL60@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 20 Mar 2023 11:57:48 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1679313455; bh=b4YEZ67x4s9hrhD7g8bgqJy4L1TBV4LjN14UtwOj9jg=;
 h=Subject:To:Cc:From:Date:From;
 b=L064tQS/GtntE1BHV53vaVJ+UQZarqYVNTAB/pQKX3EwEzg2zZIO7oB1Lcmvytwk3
 Y8Z9ilMl5+8XAu8YVeyQTmFf/zHnOMiaqWMx4VBjKn3xPqZVjoSm7UPYVUyvFr8Zo3
 gr3nNm8uoy5tRZVANGi8e7zeYqkEC0vr4Y6OEG0Y=
To: ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org, gechangwei@live.cn,
 ghe@suse.com, jack@suse.cz, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 junxiao.bi@oracle.com, mark@fasheh.com, piaojun@huawei.com,
 stable@vger.kernel.org
Date: Mon, 20 Mar 2023 12:57:26 +0100
Message-id: <167931344613222@kroah.com>
MIME-version: 1.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10654
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=165
 lowpriorityscore=0 phishscore=0 adultscore=0 mlxscore=0 priorityscore=200
 impostorscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303200102
Cc: stable@vger.kernel.org
Subject: [Ocfs2-devel] FAILED: patch
 "[PATCH] ocfs2: fix data corruption	after failed write" failed to apply to
 5.4-stable tree
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
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:72.55.140.81 ip4:52.25.139.140
 ip4:139.178.84.217 ip6:2604:1380:4641:c500::1 ip4:145.40.68.75
 ip6:2604:1380:4601:e00::1 ip4:145.40.73.55 ip6:2604:1380:40e1:4800::1
 include:_spf.google.com include:amazonses.com include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: wi2Kxr_igIWVEG-b3SAbfBmwD9piSY5y
X-Proofpoint-ORIG-GUID: wi2Kxr_igIWVEG-b3SAbfBmwD9piSY5y
Reporting-Meta:
 AAGsSBMgIpH4qtYlp2eGmFgHkOZuc/y2gNV5D76ZBoqfn64qbc7OIhBckKX2nUpV
 eMUA6tmFrQ24ufT1mwvKQ4jBwONUkG7VpTWlOCv9xIdqBAahNQ2DqDWIBsvqu3Pi
 6YicIt8YVLq/U1Y8VkOiW9cSsEaE4w3VVmquHoZVIqi4jiozKxWOd+apRvqAsPkU
 jukFzGOeo3yqg5yYvmkYsQRmkLJJjk1rh/LRmZgJBaXKSk/yO/FDq+2VPzLCEig2
 /U7CNkxADCKPet9BKFWYhFK9rOpSQjsqpDpEsmpVykihVceYXD7WN/VEjnMbAgI/
 hZTIvGs0aVTEi+J9G2tcqnDQfnszLpwCt0PKD3HuAL6j+LUUs7gNlU6EgquxQg3s
 vi0hsoCJ+VqHye+RPy5DCOaJzppuQNCKGIoNXjCtQe3OtLOoBrlgokio8eTsPWso
 Ja64ftuEOzSj4/lzZuVwSgzXODGA38bNgjrwt+XmIcpRyyAP/8P4NuNzLUarlCH2
 abdDeDVruZrSUHSXQpLK7jKGciUu57Z8NcCKJIMBgwYQ


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.4.y
git checkout FETCH_HEAD
git cherry-pick -x 90410bcf873cf05f54a32183afff0161f44f9715
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167931344613222@kroah.com' --subject-prefix 'PATCH 5.4.y' HEAD^..

Possible dependencies:

90410bcf873c ("ocfs2: fix data corruption after failed write")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 90410bcf873cf05f54a32183afff0161f44f9715 Mon Sep 17 00:00:00 2001
From: Jan Kara via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Date: Thu, 2 Mar 2023 16:38:43 +0100
Subject: [PATCH] ocfs2: fix data corruption after failed write

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

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 1d65f6ef00ca..0394505fdce3 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1977,11 +1977,26 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
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


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
