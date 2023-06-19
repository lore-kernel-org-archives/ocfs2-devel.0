Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 884FAC001DE
	for <ocfs2-devel@archiver.kernel.org>; Tue, 20 Jun 2023 14:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=TPj0QLgMgJU0TQxXsIm7wKCuUV87gpo1POs+coGoqmM=;
 b=LcszkaXGnnS22Q9Fws+EKvtKGSzurRauOz0Idx58RF2BHFmm3mKsDRphx7fNeBEdd60umZXtMup1
   +C9f164jQleJy2jRocqsBAQaVETmVxNb+pk0/Ys2TKgo/JXZ73L7re83nDIrxkze9cAveTVY6dDm
   LQnXM4D2K9Pk1k4qdh0zBGW8dxFoN9lH1PN806xl9kq5LXhoVO+R55i0srr8hPNYndVs3GBTCi1d
   qa54MaKPzqAnpqR52FguG/GllJON+rnRa1pef6ByuxEPG7kHE/ylSAU9yI+hUA6s04nToK19i+MH
   Hvt2I5q6EBVWoy5XO4h6adCD7xaBgUTROaOweg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=TPj0QLgMgJU0TQxXsIm7wKCuUV87gpo1POs+coGoqmM=;
 b=gOWvQLagJjsjxIaqbpz4gp/EuylnUAqQXokaD6DdfWDyh/KAOKrOvUP3ICGFXnXxtjF752azRLMY
   wxSlhXhDzKtl1yBLOpelNSxoAUcv6lwrMNKeBCw+Tyd5aVyrCq7zvgESTEBJ51idgpMbnuZdgj4l
   ablg/WzWwoBRqkViHeFIuAT+fKaKVd8rHA3iGuSjiemAr06rPZzmqWIvIKyt2x+/adJqfrSD7eck
   nm2A9+n2Hm9iumbxvllMHJfdzAVvkE3AjQ3zz1W7Gqi/NOJZkfiibmgjDMhSLDUDR/mABGv1vjZn
   vkIhGSef/67P1AH9XRTy6voKxUxJC4ytOMBXig==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWK0034345ZUH60@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 20 Jun 2023 14:56:23 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; t=1687209526; cv=none; d=strato.com;
 s=strato-dkim-0002;
 b=m14ydInAO32RSNeBAEUmo5VtS9IdNsIE1lEAXPUqN3jpWhmRIQgK47Y/rbAT3wMzzQ
 zFtEMz7KVxS3NSfPnKVhU8xUFPgcXLrgGIWN2Mu6997FuL8lqVsKbxqkA5fE3gv3MDvZ
 JWD0zt4m7taKUiiTj/MHW/kGwq6EOfjUlaUH7tbWkr4Af8BIy7xIimnnWnFOzHZDScLt
 3eQQywEXNYQ+IC988XlH/CzjqwE7RWPjci5ZMT3eKpmQ4AYgRzTbVvGQ14Z3slHIt375
 Yy3e8mWPjZSUhmyrItczO8JH8++rOTMjFybtj/1ToabmROD6JBE3b3hIRI6t4sFE0TtU aoQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1687209526;
 s=strato-dkim-0002; d=strato.com;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=4VoCJCkUkGyuMs9ktPD9dGvwPKJ6aIyifN3L5LWABx8=;
 b=JvbswYT1Nxu/3JVFow4AGCMKUY/2XH05O3KHS/AN8d5uMp/6ohrS1PkKNW1d/qNfgx
 ehqaHoKJtUwJelBXbn8r72WycTsEtzleB3hRsAdSOiMxKKKUyyzM1b0QCThREEAj4AVl
 q5Zch4h3R7Uu5hmKzx0c67sYBQ7RCDzOg2GeGoQXN0rqERPliWUQ7yvIll/pNLS86+kk
 ycpoPF2xhfADP3mWfL3TWsU3V7nm1cIVk4/xiq4xy4rgcMqi+C1ZDffmzSuCPuUy2QbM
 /SnVisX5HcQFQW9BMmEdDPGdYuiBwFgNDv/UpoVl9iqq0weeChmJvaYg58IuIMlqC5Qo pzxA==
ARC-Authentication-results: i=1; strato.com;    arc=none;    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1687209526;
 s=strato-dkim-0002; d=iokpp.de;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=4VoCJCkUkGyuMs9ktPD9dGvwPKJ6aIyifN3L5LWABx8=;
 b=GQuLI20iuo/3e3+FcTWN+gW33eL6iyjV5edlrwBquBLU1yKxMk3gJO7CkF6DC8eUq6
 gHTqB7hfa+ATxhvaPSMfQF2q1ieLcDoBiT59Fsr1IPCYkHAsKStHGpL5+2bmwDdUy5o6
 wWcaHwSe4L7bsjHTc+Z2xsLCyrvZnNGEpGXihjQrDj+pGs7x89Ywj1dSAEhZdOzDw30X
 xBQqWzsXqNbS7+ugJ5EL0MiFGcZuz8DhcDB1mRCCRnQFkCb9JzLKyz9t7rn+bd+LO1cC
 bPTxr2ni/HsxkQCdCwk6SUJrBKWPg4dVvZ6emoZsJFm5HNNbg2fpUBWqLP/n/eSdf1Eq JkWg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1687209526;
 s=strato-dkim-0003; d=iokpp.de;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=4VoCJCkUkGyuMs9ktPD9dGvwPKJ6aIyifN3L5LWABx8=;
 b=Fi7GsifBZj+G9wnlO1nTmf1xXDrGLocv0iS6G3hKSGfd89rdXROo90SMzMsF39I5um
 2ld4NTWy8oTessFRFiCw==
To: viro@zeniv.linux.org.uk, brauner@kernel.org, akpm@linux-foundation.org,
 jack@suse.cz, jack@suse.com, tytso@mit.edu, adilger.kernel@dilger.ca,
 mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com
Date: Mon, 19 Jun 2023 23:18:27 +0200
Message-id: <20230619211827.707054-6-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
In-reply-to: <20230619211827.707054-1-beanhuo@iokpp.de>
References: <20230619211827.707054-1-beanhuo@iokpp.de>
MIME-version: 1.0
X-Source-IP: 81.169.146.172
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10746
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=60
 phishscore=0 adultscore=0 mlxlogscore=474 unknownsenderscore=20
 lowpriorityscore=0 suspectscore=0 bulkscore=0 clxscore=58 impostorscore=0
 spamscore=0 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2305260000 definitions=main-2306190196
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, beanhuo@micron.com
Subject: [Ocfs2-devel] [PATCH v2 5/5] fs/buffer.c: convert	block_commit_write
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
X-RZG-CLASS-ID: mo03
X-RZG-AUTH:
 ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSedrgBzPc9DUyubU4DD1EQ33bneoxgmq7ABeEwyjghc0WGLJ+05px4XK4px0+bSzE8qij5Q="
X-ServerName: mo4-p03-ob.smtp.rzone.de
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: LLsJJfqcuWFxKHfAZfeGBtRwE3DFRjdd
X-Proofpoint-ORIG-GUID: LLsJJfqcuWFxKHfAZfeGBtRwE3DFRjdd
X-Mailman-Approved-At: Tue, 20 Jun 2023 14:56:20 +0000
Reporting-Meta:
 AAH8OawfXXtrWR3BsHCvBi0VQOlWCZZ0yWR6DNXLm8a5g9v2u0Xf5iEWujwSsL+r
 WihQMj4vQHeg6ezQifvnx/XkIs//8pNB6x77fcrt0lNh5JxjZ7w15oh+egIlpUv7
 FJGjmanlch23H/iUwo2yw8P7kGNgdllgdsQonC0+3uVEnyGE6kfQBnU3HhdZP3V0
 p/xtt8wkCX09E30JVtsZ0SDshMsjEvuVbP9bwkO35QWheyJYeAAxueZYN6viQlvw
 QUkBIHRFEj1DLgS+g5GfmNGYCFwg9CmwoMEZNzhVFsbPn4/tivkf+Ks0o6XaTAem
 dEBULmeqIpXKXq5vD6PXbIstDUkjk6zOijq+nGM0WcvJXdAjOmzMwavgFIWwVD5+
 j6tu4OYEtO/Vdt6wRHrYypAJkSRJHWnPk5Cc0/b07QLSA2e+mOkL0kJfR1sBDJ67
 JXRzbiAPDJt7HvkuvdX9OOdnluNN/AIgjsFqCkLn8ZU+4RaImg4Iv0tql4TDgIoX
 7kiBh2Xs9n4YRW0lqymH0bNDcZEI/4h8LTebf1D9zzw=

From: Bean Huo <beanhuo@micron.com>

block_commit_write() always returns 0, this patch changes it to
return void.

Signed-off-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Jan Kara <jack@suse.cz>
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
