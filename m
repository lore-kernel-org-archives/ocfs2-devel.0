Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82A35C7618A
	for <ocfs2-devel@archiver.kernel.org>; Mon, 20 Mar 2023 11:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=2XSY1r/FVx0+AqHAbglN1SheOHGXfgSGAOcwblInnOY=;
 b=GOzP8icUCOoCTa+1+pFlDtBCAIZCFYU+wTDF5aLz3XQrFB+9Ft1yG/heGkBGrD/8txrsMtn7EDZ2
   8VPX9eBiWboNWs2w11/lAi6fL8EBk9w0AcmFZTyaH9DUDvRrEInSTqASweSWpClSrMvUZADO7XBu
   nrj8BdCtBbN1V4HMAhKQRfsDxNgYPoJNDc/l6zhCTBdqI0joordIdRtrAERGEqhCePBD4tw80+wT
   HHXUuBGovueuehTejvPGvM/ycqHi+TtClQnRV0zYQoN07DYF7v0vrrC9Fnt8dVUZ/UqlegEtcMhr
   v6WZm2xjQQgjqj3de5nvsOCnp2EnHhb9QmxTVQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=2XSY1r/FVx0+AqHAbglN1SheOHGXfgSGAOcwblInnOY=;
 b=PjBpjff0AupIHcqUK0peyrt9YJ6XjDSirjJVPCgBRdSZlCBiargCx+XPe2/YActtgBNJUblPEl0N
   3hAnhyUubM352FnAGfR+gLlnjcf+AFhef3Szf1caBD6qGJmVAF8M2f54guOE64r4gpRNRsf7DySJ
   NaM5T33fyz6Y7XyFY2KmZ+pIiln+P1FP09z9xV9Cd/lWX1iLOCpi06meSKnaE7Cv882eLEefjkC9
   9OrHgHlb3W6F0mZynuUERXqRLDZ1VHCWv1qE03P8Kw7vtICpbzyp1DA+pnJ59m8vB614yuZfuiLK
   0awzFkEbbpPQGDqAFpAg9Y0YL2Ty6Sa5c8qTQA==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRT00L10IKGF240@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 20 Mar 2023 11:57:52 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1679313461; bh=829y0RbP54vfyPHnu8eJDis9PYKUlp41V5lGew2EjeY=;
 h=Subject:To:Cc:From:Date:From;
 b=u9vO018VwYUeU4df+KcxSCxerXsxXXeSVwB6betuWvrrYxNcwzmDsT6uweMMmdF/E
 PR/OgMgMzBSwX7tzFTbCr8DWQYYRkYsr7YidR2I43Y/MUyr96y4xDDITrn/D0X52HB
 vJmcBslBFLVMCkG04sCTjqD0cDtxBlNamZX3C3TQ=
To: ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org, gechangwei@live.cn,
 ghe@suse.com, jack@suse.cz, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 junxiao.bi@oracle.com, mark@fasheh.com, piaojun@huawei.com,
 stable@vger.kernel.org
Date: Mon, 20 Mar 2023 12:57:28 +0100
Message-id: <167931344833141@kroah.com>
MIME-version: 1.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10654
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=208 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 lowpriorityscore=0 impostorscore=0 bulkscore=0 phishscore=0 adultscore=0
 clxscore=217 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303200102
Cc: stable@vger.kernel.org
Subject: [Ocfs2-devel] FAILED: patch
 "[PATCH] ocfs2: fix data corruption	after failed write" failed to apply to
 4.14-stable tree
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
X-Proofpoint-ORIG-GUID: AgAmrdA87ZE2MsweNBW9E7c-CC_cVL2O
X-Proofpoint-GUID: AgAmrdA87ZE2MsweNBW9E7c-CC_cVL2O
Reporting-Meta:
 AAFOio1/NkhTkyiCQj6IVqjI7yDOPqEncwz1jjPKwR6sAuLEfnzP3gOWZTXywU3y
 msyT3W+KcFY301vTeFbVCPJmnLHVa+YgHfut8+Q8d1LeMXvp1hfHoM+8GI8+QxEQ
 s1h6xCG9oyvCkuMq9H0XsG7ILSImHHDsLs3AaT2RcoOMZLnJupAx0ZgwinsccsBI
 41vnNq9YlPPsx1PJ5noEpxCNnF8Z2X1vQNKbN9HK0ZkrJxYeHtrDQnDLWaPXnMqx
 RW/y7UBFqRAYudm7K7q0gpB4zQ44n+kf3k4zJIPV2uaZG6S9TQI8H9BVsEz/e+V8
 pEu5+hf/ehmCSvL8r57Fx5wJKxU/KAQDK21dF2Vu1h85DcpNYvNcswxhFOrd+Mf+
 E2bmLRTM9weboxc3npIeJcpbYiCH/OdtYXTG745MXKrFNggwecNx7D40YNcNO4cU
 xawNmUZtlXk/9YCvW/DMC+QIAGW4QZn3CaOSu66QvpCSTImMCJ1/z0LmdJar5OPQ
 ZaD0/Yp205ShRV8HSeWF6Gl6sc1mqqUrGJiQIpr1Njw=


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.14.y
git checkout FETCH_HEAD
git cherry-pick -x 90410bcf873cf05f54a32183afff0161f44f9715
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167931344833141@kroah.com' --subject-prefix 'PATCH 4.14.y' HEAD^..

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
