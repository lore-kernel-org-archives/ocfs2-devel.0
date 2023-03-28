Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F769C6FD18
	for <ocfs2-devel@archiver.kernel.org>; Tue, 28 Mar 2023 14:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=cUXE+K3OzEslCFW/ruplFfOkElPdX9HT+z+xY9flLAw=;
 b=ar+hhoFRKI2CRa6zGWtd6iy82moVy8YSjzlN1EpSvCJBnjf5FacggpXJoGzqBrYqovDzVuJvizUk
   hYiVzZ5y8nkxUZXizqylM6hJvL2caPGiX78zyAvZSvCTvmoIIYPILm6wD6MfR3Rn27u/Hj4bPDCv
   ydI2cDwv7ZNlo9xVC+FOM3z5KEQNPy7uAHakx5Cahl2nTLmdkuh8SkKnRf0pHDsWXVkAOiPbmLdI
   1fswyiFu+xA6ynQ24BX2yNLD8OjQFwbxjCifJw7zjyvv74aFFa07ht5nmF8LLfOABJ4raEheEWo5
   r311vHx/jWvON3j9ldXiysvn0CMUaZnHZlps0Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=cUXE+K3OzEslCFW/ruplFfOkElPdX9HT+z+xY9flLAw=;
 b=oRMBh3I2kNvi7eq1Tcq4Wl8ZepzwMAWkqxaZ0EsXNwkHHU/NWeexC7gxgWvtIXges5YWq5WxixaO
   kV5TYDiITzM8G9yp3dVe+ykHq+Zx/EFG9e1DZUEcOqJywBKX1sGaqSEGmALMCT33Am5MpyQfmE+F
   P6aN2PtCXAMeIYzYpw6M7DyUJ8S2+nIsxIU+OkKFWKrPhDURdkIIpPl7E/3YnGfjHg/fMcRE8Moe
   X2p+Hp+JyTsGo60oGpjybY0hJwCUW1Fkrv+aJiOMbcibCb6wRcn1woeYrgntoba8x65e+CYwlP9S
   pFaXKo8b1ZQUPQSxXBxWBNi2APDL2CB+JqoQfA==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RS80025BHJZA3B0@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 28 Mar 2023 13:59:59 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1680011673; bh=T9VRj1P+NGQM6fAkQ177vQSp4j2FOD73B8dPKcN99lw=;
 h=Subject:To:Cc:From:Date:From;
 b=kIQeslJeZMcJ8bkg8tU0gKvpTkVOf8mlMhEpKHJH+dB65cvakAHQdnUBhhGP4Ysez
 4USvMu8FFH2vrtJOCk12f0kM1L5Qs2s+L6jKz4vtfc/p715R3kuF1hRM4EiSWYVF+p
 4AHh0/Xs9suo/fQKNkgJyX6wWcSrSYtE3tEBLj+M=
To: akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
 gregkh@linuxfoundation.org, jack@suse.cz, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mark@fasheh.com,
 ocfs2-devel@oss.oracle.com, piaojun@huawei.com
Date: Tue, 28 Mar 2023 15:54:30 +0200
Message-id: <1680011670182150@kroah.com>
MIME-version: 1.0
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10662
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=253 lowpriorityscore=0 adultscore=0 impostorscore=0 mlxscore=0
 clxscore=236 phishscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303280110
Cc: stable-commits@vger.kernel.org
Subject: [Ocfs2-devel] Patch "ocfs2: fix data corruption after failed write"
	has been added to the 5.10-stable tree
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
X-Proofpoint-ORIG-GUID: i3Da8CKQcG8L9U1QIdgMn0aBXiCRDO58
X-Proofpoint-GUID: i3Da8CKQcG8L9U1QIdgMn0aBXiCRDO58
Reporting-Meta:
 AAFW1sYWxb8lvYNAwhTqzRWyfoeKLfyhfszt2XOh4D+bu4OG5+8AOot4lMBPg+n3
 4b4bRYkfSE2Z1aP0x0+o9YsiC4dulLFsoDQJ+ClJxF+CcBytxFnoYb2T6KMwrMpq
 RP2kX1Vvqfn3gbhEEkAQY0h2dmuHyQzthc0vvl4BKbbM4eDD1BZD5pvvGthbQx7G
 6NUkDOdQoiaDOP/U92QMwKKtB5Shvm8iAu3KYp0rCnAuUn2HIb4xbwhX+aiJtGRi
 mcCNHYFJo1lzI6djVbFgcsS8cU41DtoKAB1ZxhttupIp7gw0MEGaaFimbiwh/ETR
 gEkxWsSjzIKsjKn1bv50kxStuOdikLTNIqvIj7i3yT6xIG+UL4IMA1TokTJYyEhJ
 wIx9rVVJGHUE5Tx2f7YxzlIpvw0Iknj+1Vr2f0E0hjyOXHjkzCJ0K3DPQNmKL7gj
 51f86GoG41OhsTKa25snNx/RrYFA7Quh0ZNOTk58O3leerkCfe4PzRRaeE8WjqVa
 cBUM1iuMvrmup+1LGPa8cET54ZkU0i/uURIGTsxRou4QPA==


This is a note to let you know that I've just added the patch titled

    ocfs2: fix data corruption after failed write

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ocfs2-fix-data-corruption-after-failed-write.patch
and it can be found in the queue-5.10 subdirectory.

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
@@ -1981,11 +1981,25 @@ int ocfs2_write_end_nolock(struct addres
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

queue-5.10/ocfs2-fix-data-corruption-after-failed-write.patch

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
