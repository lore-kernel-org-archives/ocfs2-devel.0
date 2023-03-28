Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0644C76196
	for <ocfs2-devel@archiver.kernel.org>; Tue, 28 Mar 2023 13:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Wg9+8xkNYQ+BNi3ajTyCa2x1qRCpFr6XXYUbVy6b1i8=;
 b=tvDRJwb8ICN+2G7am/6owxK9h+b/YjrctcJ43tP1NcUR6muAAJMZbr4m1k90Q54gRH+phQkxX6Am
   dB3FvGyChAkoOMQNmJU3LD5nPExmaGaeGBfc+kbtiPKYOHV12Ba4qcWDVBhyJsA5EbltMNMp6U7+
   7lMMIhJ59MUoib7hOLFvo9zMDNV8UXd7PBhkHbe55FdpjvwfGFptuNG9ZKDgI8Lzor3rEy6wxOpc
   uwOqm6T9CJ2snbqiLxWirTRV2APUtV0iuuDW6i1KZRr766AYJToWA1FdPpedxqAI13d550T50DLa
   Fy+gocH8TGx48Z1rJI1Mf9ZP9WUT2PN6Ouvsqw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Wg9+8xkNYQ+BNi3ajTyCa2x1qRCpFr6XXYUbVy6b1i8=;
 b=q+OXf23VcgrvL4aNI3R4C3FiCPodptji/CSE0UyZzbA+yPZdxzWmQsZfwQoV+PHIzQP7M0+E2jvj
   Uq47VDLBnHgFPt+SMVtyRxVM/midpV7pfK8nidkAmOj/+KyDbIGJbTYv9Yh+wzvWgZWX9Xl0arwL
   EU5qLwhvAxFCa4NAUquaTincRpyluicahelAV3/P8Tnndrnfbvp1F906mqwLJd8XwF1PGp2ckfWf
   SGaUoPRQbM76h0PFQOZu4fNuevh2cX/iY/XIq15TxwBhESEP/fCL+idu/vdBiyzSSNZnmoWnR9jX
   ysd1gZMbia1SUqjZ8rK5clXZtbtk6uR3fJ6lPw==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RS800EJOHALPP70@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 28 Mar 2023 13:54:21 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1680011639; bh=KZo/x67Jt+NaRVMlKp+it5whZFOpL6C075tC7CGuusM=;
 h=Subject:To:Cc:From:Date:From;
 b=JCs0nPoYK5Kb/OYBpJjV4ltPOpPS0odoTO2O9/YEA6LxSgIDv7YCdKQSdvsz361Gp
 FWE97/EGk6AEa1YfmQUC/rXfNYJAzGAnhcob6LJgfvBtAj5ZeITRqdB3WePOGRpgE0
 j/CESXzDOHzFdJsi9KwROc2XVvvz5qzbWdXVbtto=
To: akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
 gregkh@linuxfoundation.org, jack@suse.cz, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mark@fasheh.com,
 ocfs2-devel@oss.oracle.com, piaojun@huawei.com
Date: Tue, 28 Mar 2023 15:53:56 +0200
Message-id: <16800116363273@kroah.com>
MIME-version: 1.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10662
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0
 adultscore=0 clxscore=212 mlxlogscore=999 spamscore=0 bulkscore=0
 suspectscore=0 priorityscore=203 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2303280110
Cc: stable-commits@vger.kernel.org
Subject: [Ocfs2-devel] Patch "ocfs2: fix data corruption after failed write"
	has been added to the 4.14-stable tree
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
X-Proofpoint-ORIG-GUID: NoUnj3xhl4QjAzfYbviVLjNrf5w1tNih
X-Proofpoint-GUID: NoUnj3xhl4QjAzfYbviVLjNrf5w1tNih
Reporting-Meta:
 AAEf+mxoT7I1/XangEBjC3mvuBO3UWMjmda/cwGY7d0cZEYA/0iEFvP67bVyFz+n
 RxGESFLh8XliL0v1jFq9k1oo+F8TZEoydadlWo7dxDfSjQnWIy5LYMNcRamLxlLV
 tsLHeHFUiiCZEwEG/OEo0upaqDo0CRyXr9jW77KaZAN6nPAW8o/VahVpmnDXKgRg
 5GtxOB0BjdLMNVE3llOevGLgiKHvnjajPOjEUzXfa4xui0vfsGft5x9xYgBQjbxE
 9l2xRs6gYYpVpa0xuS5WNg4Tzt471s/Tidjy5dvsGfNsnNDpJMhU4a4Ji/VRKqhv
 3VU/JC9G537XzL3A4lTAQgnJVzxdp/WN0E9l+5msTpUaBRVOkrUA+POkHia6WqZj
 cjL4X/tNy6jEqj0OVIMTJK9meRVoRJNqRuXxLw0Rz1PT+PIav8tCenPagPGwi6Q3
 wwhC8cA2PfxghFscE2n0URRijJWcQVEdg8mLLeUjE01xer5hiheVwhY3pMTQgOk+
 i/n78K4xfc5trGcycOWKhPSFhRuXjWxQXPW1Dj+itW1r


This is a note to let you know that I've just added the patch titled

    ocfs2: fix data corruption after failed write

to the 4.14-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ocfs2-fix-data-corruption-after-failed-write.patch
and it can be found in the queue-4.14 subdirectory.

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
@@ -2001,11 +2001,25 @@ int ocfs2_write_end_nolock(struct addres
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

queue-4.14/ocfs2-fix-data-corruption-after-failed-write.patch

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
