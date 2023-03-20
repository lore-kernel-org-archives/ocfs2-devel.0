Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B03AC6FD1D
	for <ocfs2-devel@archiver.kernel.org>; Mon, 20 Mar 2023 11:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Zo7eq3060I5thPgRwSK87EyerNWwsFkYwjsfw/HbM74=;
 b=IfilazjMQh/ZOAzfNSrYxfU5e2g0hfa/p1qNF1+GLudkoPlhMsZ0qT9I15v1W1zCPvmYV4D13A43
   UakMZHu2nAgUS2lNdNqL2hrU7Fwwl3uYMu4SDc5W3MWBys3aFOgTWejCqZAvslxbkqUgQ3b8hXsH
   f6pxYhhbFqQsTN4hfwbFERro7ZMslm6TXw/H+fsrlqhtnBpW3rqSpeFyR5Ed2z+Rn7HAbWtcyPzO
   HaFgs1hFcEli/cZ8Z7vGOJNNoM+/TKLzXgeGMthKwOEchs5sIhLPW7JIHhBB6nMQyBWPRivDq1WP
   sp2K7BgaKy6QVcuQpjStnB5tqUrcq7e+8IzjTA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Zo7eq3060I5thPgRwSK87EyerNWwsFkYwjsfw/HbM74=;
 b=CZBre/zS+Kgx5/mEoqEk++me7hQZMveSdHmFadHT/dx/TntOlLW0sWH8Z+PpcCPd8b64zX77pl0a
   +VhbgQ1UonqIh2CLjhDbiXf60D+UcCrRUuc0haEuFEaiBTCpdzmxl/9MLWWEocjZxziwDgJAaLb1
   i801l369/auEQoikji8P6dZ03+cpqwNavwqjkrnC29G5PNqui53bIRQ1HBb5VA15PQpAajBMrSie
   TlMq8RVAwGIdTza6AwwipDd0j6AY3cQKybnpdtAJWKlZ0idVM4s75Bgt3Yjyo9qKO2bOh1TmIni1
   QylY7jghAti773SICB5sf6FuEv55NP4mKRkdZg==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRT00NV7ILKEZ10@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 20 Mar 2023 11:58:32 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1679313501; bh=+i3RUbIGF2wwBuWp1u8CwA5k1dH8NDULm4RPTMOB/ZM=;
 h=Subject:To:Cc:From:Date:From;
 b=1bEPNz02zEvu8hHpYJwZWZ97RWngTpLik7KLKgJdeQUCdmDU6+Id4BTUXGJ84EOaw
 QPzeD0ZvOQsyJpU5jmE4t70BmcRi/MJMTo8UHHRwAz3Op7iTbQUr9QZ2UeuVqogYCX
 gFt0yNM0NHUNRP9LUJjqpqBifxqY8zATF7b/EoOI=
To: akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
 gregkh@linuxfoundation.org, jack@suse.cz, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mark@fasheh.com,
 ocfs2-devel@oss.oracle.com, piaojun@huawei.com
Date: Mon, 20 Mar 2023 12:57:34 +0100
Message-id: <16793134543281@kroah.com>
MIME-version: 1.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10654
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 bulkscore=0 clxscore=166 spamscore=0 malwarescore=0 lowpriorityscore=0
 phishscore=0 mlxscore=0 impostorscore=0 adultscore=0 priorityscore=200
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303200102
Cc: stable-commits@vger.kernel.org
Subject: [Ocfs2-devel] Patch "ocfs2: fix data corruption after failed write"
	has been added to the 6.2-stable tree
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
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:72.55.140.81 ip4:52.25.139.140
 ip4:139.178.84.217 ip6:2604:1380:4641:c500::1 ip4:145.40.68.75
 ip6:2604:1380:4601:e00::1 ip4:145.40.73.55 ip6:2604:1380:40e1:4800::1
 include:_spf.google.com include:amazonses.com include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: RYVcHrgfDpXeV3t9_IH8Ii_vZa7ZxOxG
X-Proofpoint-ORIG-GUID: RYVcHrgfDpXeV3t9_IH8Ii_vZa7ZxOxG
Reporting-Meta:
 AAFHULMfhlNbfSuPw3G2fFPadBP2SrZLG1j9vAPpZpJB9IQ92mrjnQr7riwMrf0e
 XUMbz7KNRuDo01zSluFeIzg6BeiuQ/1LuE8fA/7yhcZ33mR9ip0V+kdYdgWuQCxu
 h59wzb6M8aEZQYgOz3Is+FHMn5xl1/c9s/hRXhiXnqLrVjpqPU8sVou1JqxskHBe
 UP2dOzh0g448Ij/DrWw+sgKdpv7Mi56HioSKIAZOLbNmSc7yKCbw7emJ5aDmXBVW
 sBm72PjwlLMC8RXAwGVWRSWL8NLJdE27Y6XtRimnw+JGGQsAm3V5bEVlMry6aRfz
 yCle7FgfO676SLtL+gy9FXk2evxYqE0UZpOEEVFM1bK85GH6yj8zP0C0Nf2JODLq
 jFp4WCgDi6s/fepVrPHWwbqQL3rJ/Z5dAtnNLxmIsQYmkon+dEKM7qT2I2TL4geC
 np7ysOr2urmCWn9ANvoYZfkFCyRu28DVioYcsIRGXcZOD7+Z6xLiQ36Y5vsGQJjG
 l7Up6T33bNSBcI/Oic4fpH+cMBRQrQXZXmrT3fOim4Z3


This is a note to let you know that I've just added the patch titled

    ocfs2: fix data corruption after failed write

to the 6.2-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ocfs2-fix-data-corruption-after-failed-write.patch
and it can be found in the queue-6.2 subdirectory.

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

queue-6.2/ocfs2-fix-data-corruption-after-failed-write.patch

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
