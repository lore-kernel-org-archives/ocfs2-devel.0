Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EAC6C7618A
	for <ocfs2-devel@archiver.kernel.org>; Mon, 20 Mar 2023 11:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=jFg2xtJtKK01IQrvYq0lIv9+gG86SLhuDcI24wEmVoA=;
 b=b7YtDyurp6uiWrMhV/9EpCt1yGy0ddRHnux9ij7GoyvR+wLVyPn+B94quOzSy2aaozHQpOYqhKgp
   mXi3DC2dGvgbIbTQbLedgFJHAAAkGIwKz5oOZftYcc9bcrIcxYvl8Y5LJGSjgHMbwSXEQOs1aw6h
   Vjktvzko6pljZDTzXyHMegfygmKd1lf+4EYynlIktnNGfOws8fuDX6WoozECavzK4bOm6wQx70Kz
   faqf+okfUJx47U4xCX6Xe5AhlV62NgoN2jFv6csTjp3rM2ToQLkuEkMGqN785rzP9fQ4gUxIoR3p
   RCuheIpMqJslU3fXIpMobSBCCE6gntStZuwZ4Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=jFg2xtJtKK01IQrvYq0lIv9+gG86SLhuDcI24wEmVoA=;
 b=FBCj7d6jnH4eKO6BNXxct5/sEUjJSmbDoh1COZ7WQKasDsr154cc3jlE+Dc4JLIUNFbOtKv1FEsd
   znYpdZmKKVDaZx7tfnyUV/NzXhJK2AcpLj3duxF5kf1oBR7SnkRfkspWXKtWskAi+lmnG7FV3sI/
   KSOlvruNCPwMjfigxahWSA7MPYrg/9XmXH+w9yandoRBPi9YzBmhDNMlrHJfYKm6O0UzhyPJHNZN
   29tO4IElpwXUUQGJaWhwrXiSKog3kLOynPqQhbX33MTmdNylTtnUPNi058UlsEyx2nchvMLOb9c/
   6WLI+zB8iHfX+fmbjSIqSCH2YhIeamXJ1oIX7w==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRT002APIK66S90@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 20 Mar 2023 11:57:42 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1679313447; bh=dSpBrIt7NExt7tR+770dbQGhezHBLFPX5qlM0fLZVTM=;
 h=Subject:To:Cc:From:Date:From;
 b=YMpFaUyWHK1CQe7PxTei+UIdGlUg18KZg3k9A3nHQT+drARFmlQeh45IAHcqvGcaa
 FBvQWntH2zgs+sAGO6kWC86K51Uh5rwKNy2/fRv1AbqQwbbWm2S/riJJRJ0dinuTHV
 7fXk5lsegjQfl3uBzkFSCr6SVur8IYGNycqgvH1U=
To: ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org, gechangwei@live.cn,
 ghe@suse.com, jack@suse.cz, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 junxiao.bi@oracle.com, mark@fasheh.com, piaojun@huawei.com,
 stable@vger.kernel.org
Date: Mon, 20 Mar 2023 12:57:24 +0100
Message-id: <16793134449912@kroah.com>
MIME-version: 1.0
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10654
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=228
 lowpriorityscore=0 phishscore=0 adultscore=0 mlxscore=0 priorityscore=258
 impostorscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303200102
Cc: stable@vger.kernel.org
Subject: [Ocfs2-devel] FAILED: patch
 "[PATCH] ocfs2: fix data corruption	after failed write" failed to apply to
 5.15-stable tree
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
X-ServerName: ams.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:72.55.140.81 ip4:52.25.139.140
 ip4:139.178.84.217 ip6:2604:1380:4641:c500::1 ip4:145.40.68.75
 ip6:2604:1380:4601:e00::1 ip4:145.40.73.55 ip6:2604:1380:40e1:4800::1
 include:_spf.google.com include:amazonses.com include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: WfQG_a8EpH5bFktmLp3_DQwTISBfocVW
X-Proofpoint-ORIG-GUID: WfQG_a8EpH5bFktmLp3_DQwTISBfocVW
Reporting-Meta:
 AAFKOViLptl5IykemAKOE22RidErT2qfLTJ9j34bQmiPj6koPst2p7pUCNcUUb2g
 AgmlAxQliUPmmqeuVbsSJvPiNJf4BYGs+oceTBYMYDQtYhdiBomJ2LEIqC6UKN9y
 2pwyGXPbXoXx9V2ZZC/zX4RzJt96BBZX3TI/OCJQQg1ZqtYGM3jZeIenA44dd8UG
 d7I+ZQfHGQm94vn6Bp50fDXM0c/Ih7grKBL1Q4noPqGeGb5ilv7Xwr+57UfK+nbR
 Z7e0tOkWZl3mo6B7qc5fcw8jaV6S4jly89VASGVwXRurJ4cLvL23k2E5jql4VB0w
 yINNQieTW2q+Cw94wucaoI2G2td53UVnIvOYeL1zqJFcm+G39Qy8qJZI9jgq6Nq3
 BjRzPOXGD/yh/DPy8YGOQdYOSecKk3ikBUWfzNfZ2Unh9uS+t2QZohpC2ntlkMda
 Q9hZiKHWAnbToMLCfNGmR03JUgqcgm4Rv9ishe5L34gCCMGRleVj9THkFgGH5D3h
 yGDNnPij9ShwflBKzC6x1dnZDdAiDM3sx71d5sWqWto=


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x 90410bcf873cf05f54a32183afff0161f44f9715
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '16793134449912@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..

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
