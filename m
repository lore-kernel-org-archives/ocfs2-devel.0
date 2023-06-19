Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F280BEB64DD
	for <ocfs2-devel@archiver.kernel.org>; Tue, 20 Jun 2023 14:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=J5Q2nMxTPEGbx91acjM+/Ecm9L6znh5S3h7V1f1w6Mw=;
 b=tDi4oBfl07OJJ3tp0i2JcLAu6cE4syHtmOcokLd9UPEYe1QBmifUsvXXvai04XIMtYXKgcImWrZ3
   rob4yJI7UUB3oLPz3g/Zs2mp3J/+hL7yLpSF1xaZAcKBvCFfd0p/PztPQKhgFPKHh2ZBUh9KrUDx
   bGYoQsCWuKSNDxIBySt8ELY1B/i8B6Zt5bPpRlyW+duS+qcDt7ekoeHhdbSUFGwPaSwLt845YujC
   +Tz8oGjKgWMQScrpMnKH0qijeQ6mC7Ewj/RaEb8UbYt+QFEk3oDLu9EcnRs07Qi0xGzZZldAzAeY
   A2RaJ0onrRUDxiJGRv2CWxTHqH4V65pdsg6sjQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=J5Q2nMxTPEGbx91acjM+/Ecm9L6znh5S3h7V1f1w6Mw=;
 b=OIUyYN1rkBuKLyDVD/K2FnAUAbUqcnXpJfic55+0sWdj1EF2qCP2wCUAHMITIjPID50LUqBu+0US
   B2ne4rSYo7Y6yMp94iERqgJBRM6BuM6Vp8McKv0FO4JUgfHdVgDXWfVgJa3jxFN/joH3vYN6fuwK
   Sy0JTE0Zex20BlQMQexrCYIoxEfkbzpkNWfHTvZ26TxPRNlyTd3OyNG6a0j0wsd31GVr8fEm437i
   CIa29vzxmN7Yy43TZH4wq3HZv8Nq5rFFMJJ+5CIQBLTdQlo9QqksYma8wdYiK6shcroeaiICQMuI
   HqUvgd59/75XhH/arY9m1HrF2fAsY4HNo2VRrQ==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWK00L7645YR5B0@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 20 Jun 2023 14:56:22 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; t=1687209521; cv=none; d=strato.com;
 s=strato-dkim-0002;
 b=LFVXYnZJP3AC4ueU5OSFywkBghrWBMJoaPp1Nr786WBT4H25sdRZekQJto2nthGHHl
 1omr2W+S6zVlnSVtcyAW/YdVI9zlNiyjATrEYkcU71j6CtA346ESRbk3UwBGZjHTUo/a
 JiCy1BwEWoief1uGdfq0aJGOJR/1llf87lIJtGUFoNVkEj/0qxY8x4yYZ/ZwKxa2z/89
 vJyUkfkTLHe+Yw+4c6ka4IzxyuTPz68FbAytIlF9/75kd23AQIpmnMIZkt2pQ4Pl1ZUV
 mUWumFY6Fp4wNkrzM/Sdfod2a1ui+wZkE7jsZVtrhZkUvIQkQyCd4q4Cx+qPd0jZJNK+ eMLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1687209521;
 s=strato-dkim-0002; d=strato.com;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=NGBMcxhHLHH11bvOk7/wD+Xn9RcgMORp7BCVCyG5YE0=;
 b=AmoXSgTVG1F6LCKvW6LHTtlBOukQR3A7nuDxN8+LBG7M15CyW1KdJuR42QHlzHEqJx
 hXvHMHoYFOEsxZ/bZJwDcnxhl06tuw8EXsmoShxmel3WkGFQjzbeMpdGeeeVHTdM2RZ1
 rrLB1+BQ8gVcW4CUd8f9ctiUTuDCfQsRgWabhYkfge5JLkttFrQXxtEd+tXWVtGbSzo5
 qDd5sZAD1xBsZEdIFb4x5VyJEs8msvDVbzNTkDWFQomAx19x4CcI2x/rA8ZDTh8ZS6YL
 RuxWZeeT/2J8qRAa/JvuPLO7ls1FKeb39iIi0p4SARtsnVoIcGUpgFjhiFF+z6pBENyB eL0w==
ARC-Authentication-results: i=1; strato.com;    arc=none;    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1687209521;
 s=strato-dkim-0002; d=iokpp.de;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=NGBMcxhHLHH11bvOk7/wD+Xn9RcgMORp7BCVCyG5YE0=;
 b=fjfTtql55O5eGJWVBFn9vZgvbB6aFpEsu1u1CJBfw2sCVF2CQyHS3QTOcEIoaUef/m
 DMmTxrRdiKmdgn6f3t8nMGFmUoLZhaKk429s3JuidosIF4uHOc6bQCBd+BkuHbJQZBUJ
 6oW7TZEbzK+myWi7R+bRHSYM5fUxTQsFFc9Hz0ozKdCv7zAtUv4caiswcOCNFAYxUC5B
 BTBfEMTo3gx/EbJamvuYWrMR1gyXSO2UsS8Ack7H3oYCUi7ZA9bfC394OoesAXpaOUl5
 KyRJozJ1VZLUcTjInUbe/Xk+g/o3J9w2RYq6B4tpd8PoiL23dVlHBwCaEX6Vq5X4b227 4tvA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1687209521;
 s=strato-dkim-0003; d=iokpp.de;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=NGBMcxhHLHH11bvOk7/wD+Xn9RcgMORp7BCVCyG5YE0=;
 b=jHNcYo6tA2Qyd2g4wy+0S9wCS4sVfUGddQdOOD7Ivi00xskuQrYie0D6cGE0F9UYt0
 edZbZL70/elm5QDN0fBg==
To: viro@zeniv.linux.org.uk, brauner@kernel.org, akpm@linux-foundation.org,
 jack@suse.cz, jack@suse.com, tytso@mit.edu, adilger.kernel@dilger.ca,
 mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com
Date: Mon, 19 Jun 2023 23:18:23 +0200
Message-id: <20230619211827.707054-2-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
In-reply-to: <20230619211827.707054-1-beanhuo@iokpp.de>
References: <20230619211827.707054-1-beanhuo@iokpp.de>
MIME-version: 1.0
X-Source-IP: 81.169.146.170
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10746
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 priorityscore=0 bulkscore=0 clxscore=50 phishscore=0 impostorscore=0
 mlxlogscore=478 adultscore=0 mlxscore=0 malwarescore=0 unknownsenderscore=20
 spamscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306190196
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, beanhuo@micron.com
Subject: [Ocfs2-devel] [PATCH v2 1/5] fs/buffer: clean up block_commit_write
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
 ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSedrgBzPc9DUyubU4DD1EQ33bneoxgmq7ABeEwyjghc0WGLJ+05px4XK4px0+bSzE8qij5Q="
X-ServerName: mo4-p02-ob.smtp.rzone.de
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: 3sjJmE3yFbVZ2yJmtFbjRbZMkUh3YjMJ
X-Proofpoint-ORIG-GUID: 3sjJmE3yFbVZ2yJmtFbjRbZMkUh3YjMJ
X-Mailman-Approved-At: Tue, 20 Jun 2023 14:56:20 +0000
Reporting-Meta:
 AAEmdgMBAEAP8qGQGTm2UMxULcQPjD4bGQ9MBk0jQmq+tVfixqm/+9Awh/VIUHev
 pCQ5SQwHEwJNzRxq4N1tPnlKzg7x4ouo/4IpR5VeRyEwNFvEYFH47eGiANrRwffG
 FzhFoCF0fx+t9aOdBJBW2a9Ig2YHDtXGjtg4NNIE11nHiOHQDyBmMshxpfJjtdwZ
 LvMWc5NqfOZUE0j8VgofGsotNtsAlARwVwMx/ExJXn0ICHmaWaKKrXqlLhBxVB9Z
 GQa3v+S10YmOICQDww/lUtRgh9n7pTG0RoJisq0xs+9qGri8zlP2dvXWIqEuUkue
 TX5IP8IE7DNoc1X+e0v/iZjTW+WQ7B3ZmsrVI5TTPtH+SbFXD2Vx4FbYeP9aQqyV
 XXRanZTHBMm9p+efchELJdKhzanL9ZrrpGGNbuu1KattnbWRMES+8Mn6yWZ++pk/
 H1UKMn1wgq1Dl1gaZ7S/Cb1We54+v/RHU9EOKHWkjaH6Ic5LKhFrNKNGznEBmPRC
 mD7zNa/ZZfNL0ATyVvUg01u4VXqdZAh5vTXVTd+xs4gb

From: Bean Huo <beanhuo@micron.com>

Originally inode is used to get blksize, after commit 45bce8f3e343
("fs/buffer.c: make block-size be per-page and protected by the page lock"),
__block_commit_write no longer uses this parameter inode, this patch is to
remove inode and clean up block_commit_write.

Signed-off-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index a7fc561758b1..b88bb7ec38be 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2116,8 +2116,7 @@ int __block_write_begin(struct page *page, loff_t pos, unsigned len,
 }
 EXPORT_SYMBOL(__block_write_begin);
 
-static int __block_commit_write(struct inode *inode, struct page *page,
-		unsigned from, unsigned to)
+int block_commit_write(struct page *page, unsigned int from, unsigned int to)
 {
 	unsigned block_start, block_end;
 	int partial = 0;
@@ -2154,6 +2153,7 @@ static int __block_commit_write(struct inode *inode, struct page *page,
 		SetPageUptodate(page);
 	return 0;
 }
+EXPORT_SYMBOL(block_commit_write);
 
 /*
  * block_write_begin takes care of the basic task of block allocation and
@@ -2188,7 +2188,6 @@ int block_write_end(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned copied,
 			struct page *page, void *fsdata)
 {
-	struct inode *inode = mapping->host;
 	unsigned start;
 
 	start = pos & (PAGE_SIZE - 1);
@@ -2214,7 +2213,7 @@ int block_write_end(struct file *file, struct address_space *mapping,
 	flush_dcache_page(page);
 
 	/* This could be a short (even 0-length) commit */
-	__block_commit_write(inode, page, start, start+copied);
+	block_commit_write(page, start, start+copied);
 
 	return copied;
 }
@@ -2535,14 +2534,6 @@ int cont_write_begin(struct file *file, struct address_space *mapping,
 }
 EXPORT_SYMBOL(cont_write_begin);
 
-int block_commit_write(struct page *page, unsigned from, unsigned to)
-{
-	struct inode *inode = page->mapping->host;
-	__block_commit_write(inode,page,from,to);
-	return 0;
-}
-EXPORT_SYMBOL(block_commit_write);
-
 /*
  * block_page_mkwrite() is not allowed to change the file size as it gets
  * called from a page fault handler when a page is first dirtied. Hence we must
-- 
2.34.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
