Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8531C6FD18
	for <ocfs2-devel@archiver.kernel.org>; Tue, 28 Mar 2023 14:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=lj8wkYbmXycbZfMAN3T7SookbFhdkJGb9kpBcD6YGjk=;
 b=j/m2YyZSmUv+2ECizLVLhvOTgEtPdQsz8vwUFsaPQ7mIMlWUoq06umRKr4ZLbSwF88Sw1CDFQhuJ
   epNAM9HLuq9dlRxQubPq7oaXM/suHgaPzm+LNc3guiE5dBYU8G+SDVwskz78sbXv9pDTj9P707kY
   JB+5UE9hnv7v/1fgNJdEmx/VA3UfW3q65WSRPZIV5q61sy5QgNy8goxNtST+7cBoIBEd6huS/oNI
   GXX4BPJO/DbKarWTAXcn0lkgO+DUUkSE6V07nnmt7GewumCiw+hpisU5nhDIZPj4pnhRT0JayPVw
   BvSrKqvrtfWQ650YThrZf9xwvM/vhk/AQyUCeg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=lj8wkYbmXycbZfMAN3T7SookbFhdkJGb9kpBcD6YGjk=;
 b=JenzmADcM0iN7s0Vw1X40wzuNLj/tJ9iqEaNrmmvDGdZNNMymN7ORh4o/gxXXvswSAq1Y5MVZ3ga
   7N4wlGIvP+g+XeZbxZdE2o5nAuXmDAfggfxoBkxfPlU24lzbya65ZHp2hHXc3MMFyZXHD+DOpC6R
   7Z71/UYrczlnegSwyufjtEOUel4O05asJAJ189JbCc2iV8s1R3xkZodO681Kv9BASUz/jpptPY+9
   iMoC41W364hz722dS4NgcdyrsG/f8vPooxoDqbUY/W2ykbBSQymCl0ZKzu3+xfZYYV5q3mEUxroR
   Afehmm3ODjubBndb+RAJa/vjauiPgKZWWqtdpg==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RS8006H3ID9XJD0@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 28 Mar 2023 14:17:33 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1680011689; bh=3AVhO4WhVG19af1cieAm7wMmKIlB3bYK35su1Ir3DDI=;
 h=Subject:To:Cc:From:Date:From;
 b=y3Gi/r9ZEUj6jIjUftYnfWLcy9OcjcJp4UqIJhZB63F5io/eR5uDrQVYUGaL/GHMX
 vmSeYmVUAy1tDO1T6+bGZGl61qYFadnOCnu0lupMsF+U8xKW4poRlbuQIJEQmkW79z
 M1miD5A73qNhih3fZEUzqHpKzoGbxwEAFZNbq7Is=
To: akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
 gregkh@linuxfoundation.org, jack@suse.cz, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mark@fasheh.com,
 ocfs2-devel@oss.oracle.com, piaojun@huawei.com
Date: Tue, 28 Mar 2023 15:54:41 +0200
Message-id: <1680011681101113@kroah.com>
MIME-version: 1.0
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10662
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 impostorscore=0
 spamscore=0 clxscore=273 priorityscore=223 malwarescore=0 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303280110
Cc: stable-commits@vger.kernel.org
Subject: [Ocfs2-devel] Patch "ocfs2: fix data corruption after failed write"
	has been added to the 5.15-stable tree
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
X-Proofpoint-ORIG-GUID: liwAfFTTBXHcTlaTl_Ix9YiJZ755vNTI
X-Proofpoint-GUID: liwAfFTTBXHcTlaTl_Ix9YiJZ755vNTI
Reporting-Meta:
 AAFda4wiy5WHYtlxS2A+UFXoskHzVVJuyuS52eR3gm1xUdDvnqtyVVMXh2ff3qXi
 Zvu14kq/m5owRKLx4Lsc+smDwotQsNeFEqJJw7Me/5dK7/91gMFzwlQP2nMcdnLj
 SsoKhSsOBM792N0Fcr0wbxolBFzEteDBTsExbVJAGiGnZSkwr3/Ki0hwwAcMCqUg
 YmS7f6Yyik+7tlyCVTO30F8Cn0Tvcw0RZj3deY/911kPgdjrTG6Fpul8s9ClJ0yN
 hW/z3C7kIe8blzpndltCqs/YJ9fNrHj5uqf1UedlwMkIMJjpYbY0QCU+tAB/qSBq
 Z8CHobWy/mu9lbr9Uq1uqzDa6xkgXo4IGyLC6UebHpsToQ6Ncq6Rf4BmPmrPSCsc
 02IVjb+WCzQr26DWVhzQyIuoNE8WVzhd4iaFKZkepoaAn68f6rZOz7PI5QCsCXiM
 YevhXrDapuREVBy7DaCGKbvSbn6Nx6SxXdU3ukOfF9TBL/Hvz+FT+D/FlHNe/SWr
 2tnq5LLw6xgsTL4I7X2K69F+iDbKnOtAQ5ECVTuyXbsV


This is a note to let you know that I've just added the patch titled

    ocfs2: fix data corruption after failed write

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ocfs2-fix-data-corruption-after-failed-write.patch
and it can be found in the queue-5.15 subdirectory.

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
@@ -1978,11 +1978,25 @@ int ocfs2_write_end_nolock(struct addres
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

queue-5.15/ocfs2-fix-data-corruption-after-failed-write.patch

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
