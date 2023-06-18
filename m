Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55577EB64D7
	for <ocfs2-devel@archiver.kernel.org>; Tue, 20 Jun 2023 14:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=HG04bPFdVs+rAboOuerMNA7+8HUVz6VInazUKj8dzWI=;
 b=lRMgBCx35fVs5DEFRKGmNtsRtseANonZvYSW/FnoNZrTDkbhcv32ITeVEwO/qayaGcFBxfXRDwGf
   dcEAIU716CmH7hdEbuXzV3AaVxqOSySYn7aItGeG6XtIaQwP6p3s6EXUfWvwlc9QNam05TVAiZ8F
   H4/iukdRqX1o+NvtjdCGlmwuus25jLqIirxHLaamtYb2Eu5WN9UrW8YM7KWnXgK60bVbI5BbOuzu
   Phrq/dTDDiMDkS/cDX021jHfpz8D+9ABy/QmCPewT4LhFvyc0jQ2RmnKNZmsRKhXhFkdI/Ea3+GZ
   MPL0tYCmtOG4jKT6PbLyQbyAEOpmBTVKgPlkCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=HG04bPFdVs+rAboOuerMNA7+8HUVz6VInazUKj8dzWI=;
 b=tfED4C/zMgLQq2Me8hWLxV48LliXdjl6GRop7qX4n/v2NbMsWlnbOT3aGSGwyXFIA4av33WAPF8C
   jXfPqUkH6UN8L7gwcEy/SNzExSiNeKbL4gXRG4yaiA7UfuIDWyKe008GzC1/nj0Pfs3BxmTzQfOS
   Y1DzMLYE34avhCsfGhPcbk84IEs/qPLYCBcDR5ZasXQUIy44IVjgaUNnNfZbsH+rPhhVxQ/T5pIt
   ZFER6oGMDQZx5TCIVwPQsIQoPV7OYv1+4SGGRKSMx8nxYIxWo6kMqkhTdYGmLK6EBNOohyg3vgeB
   Fd4V+9ucVWk+WY36n0J/PZsjanoXsBSEVlmspQ==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWK00BN145YFLB0@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 20 Jun 2023 14:56:22 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; t=1687123985; cv=none; d=strato.com;
 s=strato-dkim-0002;
 b=LAE7q86rzAmU2pmXqjpSY5LwGTLo9P9aKtp2cfOqbFI7RHUOCTI1MF8XsU9Xo1JDhB
 x0VW2OQuZbbIMP+ZN0+3pA5GjoydH5L1RIvFShJdJEy4b7CGTKYCR6jFoKDOk11jrXZA
 gt7bkgHWcCWa7txlU32h5nil+W8SXK5ICLKy5RZ5AsKthjcYLuvhFl5JV1AvWGzkMx1j
 hVxh/DWjuM8m2y+JNcU3ulC+yELs1eCViYbY7BKrvhbLo0bI0iXYEhnmUOH/1R/E3B8U
 FtVhrMYMxm4Tzr8OyTwl0UWD9NZez1bAbH91ZbcNoP7QV2ZZ0LB+HY1uY6PdTfy7QRrB 61Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1687123985;
 s=strato-dkim-0002; d=strato.com;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=5B5W+5M4yQ6bKG+vVuzoT4Vp+ARdlHL0dQxj+aWT0y4=;
 b=EkKDqpIujVv3I9++MhPh7JUlKKRJ0pywsM2CI93xwU/UvZDUWISWNdraw42ycr1XV6
 s4n5FghXNYSo6FE0C4bAtzHTCkxqyB/GGm6mZs/FmS2IEYw6pmYcDYsCTRA/i17Z8sZ4
 ACN4NQhvgXJV2zGPCbsgVKQ/6zCQOHsigwk3nwUsf63ZUl5Bxz1A8KSELEMsC19dFafT
 IBXoY5RDjbdYcdoYHFBSBAXXW09I1mvZI4e2USLcxhyRCtafdnBkhtGKDY4oR+ftOkYO
 OtRjyRH0jMnq1ZNUTH9BPlkyj87JUOfRKilqHUFVNTyE9H6uFNGfW9/u4kGIWQ25UxMy dluA==
ARC-Authentication-results: i=1; strato.com;    arc=none;    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1687123985;
 s=strato-dkim-0002; d=iokpp.de;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=5B5W+5M4yQ6bKG+vVuzoT4Vp+ARdlHL0dQxj+aWT0y4=;
 b=URFyVNhQkk1WjaPApLrqX+adaZWYjOiIlbBXdl5kGUI1gANR/SZnEzs0y7UwoLUMyz
 2CaLiyiOFD21kVRK4dj+u4WgDsU7x/8t4/a2tX+vB0v8b8VSaS+9fFzh/beuQlggg1Kq
 2FOYq9d0EJJT4OaD21oNgY/KXWHuExtzJnG3ir73wn/H1yHplydNUlu5FoM5KZC7w+3e
 ngGjAcdydG/4fvpL0Rfv7QZxi3EBnbdw9rBtXN3XPV2vn15NRvNCJVDO7Q9JFOC5vpDT
 sfFBhipbowiV+iE9Tg0Xu7lf8cgTz8FDJ78kpOnSPsVPnf9H1KQ/1F/3mK7fgw2Hav3y XyLg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1687123985;
 s=strato-dkim-0003; d=iokpp.de;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=5B5W+5M4yQ6bKG+vVuzoT4Vp+ARdlHL0dQxj+aWT0y4=;
 b=rXH0HnCIuKZMAhQT/dfven9avZ8tIBFI/MJ5WxYXnufXmubYzYnocg+OMHaFyQiJjL
 zL5crck9utfsfqmr1GAA==
To: viro@zeniv.linux.org.uk, brauner@kernel.org, akpm@linux-foundation.org,
 jack@suse.cz, jack@suse.com, tytso@mit.edu, adilger.kernel@dilger.ca,
 mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com
Date: Sun, 18 Jun 2023 23:32:47 +0200
Message-id: <20230618213250.694110-3-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
In-reply-to: <20230618213250.694110-1-beanhuo@iokpp.de>
References: <20230618213250.694110-1-beanhuo@iokpp.de>
MIME-version: 1.0
X-Source-IP: 85.215.255.84
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10745
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 bulkscore=0 priorityscore=0 clxscore=82 unknownsenderscore=20 mlxscore=0
 spamscore=0 malwarescore=0 mlxlogscore=578 impostorscore=0 phishscore=0
 suspectscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2305260000 definitions=main-2306180205
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, beanhuo@micron.com
Subject: [Ocfs2-devel] [PATCH v1 2/5] fs/buffer.c: convert	block_commit_write
 to return void
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
From: Bean Huo via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Bean Huo <beanhuo@iokpp.de>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-RZG-CLASS-ID: mo02
X-RZG-AUTH:
 ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSedrgBzPc9DUyubU4DD1EQ33bneoxgmq5ARfEwes1hW/CxwfjqKzP/cKnUXGNs35zouFQhI="
X-ServerName: mo4-p02-ob.smtp.rzone.de
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: LTS0n4l7rGuy6mfDBMC_WyqetxMDOzp5
X-Proofpoint-ORIG-GUID: LTS0n4l7rGuy6mfDBMC_WyqetxMDOzp5
X-Mailman-Approved-At: Tue, 20 Jun 2023 14:56:20 +0000
Reporting-Meta:
 AAHBm2dhZkqxGMPhVgKVVMPrwHf1IzTVNHmpJCmcsH1m2xW86YRvw1zA0aMZ+RF5
 cksZuV59ngq9laUef9e+lR/jWHJXCmFKywznMIShCrLf4gOAYNNKipnp1bD447i/
 +FNMGWvlzqYrIPqdPA3jwxWI81ihzsZo8+5wPZUomlrwRWPWE3J5RD2jJ/t3VK7o
 XhifeAzbYcfPJiAqB4SHrPEa9ckfI6NgRshVd9t82yyswJchO8GKKY4HzAC2Pvbf
 hLGbcukXf3FyYABNNNs/z/OwaZP/nWzgkbkClhvgVr8kqzPszaisgvuvNudqeedg
 FrjmjoSqvz3h3OqLDUGSQU+mykgMGFgzRUE85tR9sMHaJbAF0OAdS7Yy69EC9O7j
 1DPagInoVutoRmwy089BGC3kz9zIjqDU/e4+crgf513PPQw6o45h+aOg1scOWzqO
 NwG2hUZkKMMm3MxTJXy99zwPzwJzcQN7qkUbpl4gK4+s66RuuM3Bmb3x7VO2NWMD
 29vbO+UsvhGTYqiJINwqwybm/q1zirPCpdqCzg6KgF9L

From: Bean Huo <beanhuo@micron.com>

block_commit_write() always returns 0, this patch changes it to
return void.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 fs/buffer.c                 | 11 +++++------
 include/linux/buffer_head.h |  2 +-
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index b88bb7ec38be..fa09cf94f771 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2116,7 +2116,7 @@ int __block_write_begin(struct page *page, loff_t pos, unsigned len,
 }
 EXPORT_SYMBOL(__block_write_begin);
 
-int block_commit_write(struct page *page, unsigned int from, unsigned int to)
+void block_commit_write(struct page *page, unsigned int from, unsigned int to)
 {
 	unsigned block_start, block_end;
 	int partial = 0;
@@ -2151,7 +2151,6 @@ int block_commit_write(struct page *page, unsigned int from, unsigned int to)
 	 */
 	if (!partial)
 		SetPageUptodate(page);
-	return 0;
 }
 EXPORT_SYMBOL(block_commit_write);
 
@@ -2577,11 +2576,11 @@ int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 		end = PAGE_SIZE;
 
 	ret = __block_write_begin(page, 0, end, get_block);
-	if (!ret)
-		ret = block_commit_write(page, 0, end);
-
-	if (unlikely(ret < 0))
+	if (unlikely(ret))
 		goto out_unlock;
+
+	block_commit_write(page, 0, end);
+
 	set_page_dirty(page);
 	wait_for_stable_page(page);
 	return 0;
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 1520793c72da..873653d2f1aa 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -284,7 +284,7 @@ int cont_write_begin(struct file *, struct address_space *, loff_t,
 			unsigned, struct page **, void **,
 			get_block_t *, loff_t *);
 int generic_cont_expand_simple(struct inode *inode, loff_t size);
-int block_commit_write(struct page *page, unsigned from, unsigned to);
+void block_commit_write(struct page *page, unsigned int from, unsigned int to);
 int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 				get_block_t get_block);
 /* Convert errno to return value from ->page_mkwrite() call */
-- 
2.34.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
