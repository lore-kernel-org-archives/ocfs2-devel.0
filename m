Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C575FEB64DB
	for <ocfs2-devel@archiver.kernel.org>; Tue, 20 Jun 2023 14:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=+6CYa1VxnTnyEoD8Btq5z6zbIHxpTZex7jvcEwo+oYQ=;
 b=2xF1crSNWhx/kMw7BHGCb3hVh07YFvar04lhSasIZAoTXNIsKciIyk5kKXfPw8r2Z2QjRi2b1NPs
   e5UA3/dI96h1k1hr7reAbZKLSHnoHqUs9KC2AFHJUFVDRrWTa0TA/2nxQgzC4UrpZJ1u3tEatyP7
   QJTnHLu+10Kojf6tW5Bs8ANc8ZfLuhpYD9C/v1HcB7Dt1ereeP6Cyf+LxVHX4uGpEXp35LJTzAOK
   qFGKV8mHSCTQoHaFKvcEoypeu2AjOAzOoHEB8ad5OjeAdZRlJFB0SDtUTVHf+ie9ihP15Ywdpvy8
   tP3jGmkAQETE3LciyrlddyNRC8bGSDu8fYt/1A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=+6CYa1VxnTnyEoD8Btq5z6zbIHxpTZex7jvcEwo+oYQ=;
 b=T0mNfdxa+UHwg2q3X8JHgvCBh0ePkeO0kB8VnCJC6pveCH1J8hch3QtXwRkONpfsBn6wTJC/3UaP
   /kLF00KEaiml9qMuTZzcrZYUjjWR0V0427MJhFU1dpmYr1lVvZgKhwYCl2ituPUnWaz7zpl6wpH7
   oy4Seisf7ZnoJJSE3c8QQnlmJAGocCcpmFxSe/CcMhjWr0MmPtmZArMsprdpu3NyrPhL7pwkCWHv
   1nKGnlBUuzHemHzNxmBkEJwNuqtiZ9KcHa5UpD/Zatpm3jFCDRAcKTzjf9fXrohRxM5yOQMecOax
   lXrT9pNXC2CpcpNC63l2KSLSRKQdI9oSnN/A1g==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWK0049145XPU10@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 20 Jun 2023 14:56:21 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; t=1687123988; cv=none; d=strato.com;
 s=strato-dkim-0002;
 b=tEdXkdk7eABTemTjAU3iVebaYm3Bzh3MWbiQBoyEfdn2aJ2yeIRsy40d61YZQMufmE
 gqAjOYupLuO2sQ7v0KLbNqbFBG78din/tYVrvJ224Tqx10k4g8WWbn3SbOs8CcopWs0l
 pbMHLb23pfZT9K9Xl9XQKoyrtlDWQfrOWmbdO6vpEpSalm6Kz3ZdlLDiJPW0/xzHHR6d
 fNZoZOEKvQ9ITPPJGvcVwYPS5jhXS/91xafwSu0K1IQbA/4ckyi1/iQndKROuK5P4R2j
 xga3ZGIHDKSyepMGAx+n9OWOfKttP8ye/ZHWu/MtADofar2WEFRTVILO3MTH/SFU7C87 EUqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1687123988;
 s=strato-dkim-0002; d=strato.com;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=f2kgEMuIUUrHM5gBc5Sm8qQWNSiMWwhC4tlGu4p/URc=;
 b=mf4ehWkiTNgGioBCJaewTZnI1CdsXpb+P0qZdNlZ5uExOHHr/sHp7Zxxr1HJHRMxsR
 UpyBn8CHIdbcr2GvduRetEJBlLVVz0kIMCoa3yrPnggf5pPtI3hkgw8c4B/zvB5cHH+p
 3WoLtOWkjrPjnvrG1yCS1r9oRveLq8owWXIgI26EuNa0sIrkh1a3X5qIPEcRuUAlWBiP
 PSy1ynNnPl/i5KD5612T3HyUkpOS/re+MtQXCMyHPtKawIs9ItiMovYSY75AjK8RKr1U
 LdIJpXk1G40ViTZsZ8YEqNjVMPSntbzT6nhbgB633z/Ve5LrDl34fhD8F0HQ0d/AexPL WtyQ==
ARC-Authentication-results: i=1; strato.com;    arc=none;    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1687123988;
 s=strato-dkim-0002; d=iokpp.de;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=f2kgEMuIUUrHM5gBc5Sm8qQWNSiMWwhC4tlGu4p/URc=;
 b=bahHsnk+VQ49NmAqeLTyYIKH088rJ1bhhGqTig2deRUwdhreH04FLhPBSzPS8x+yfp
 uPB5yunDDa7hg9ZbQ4mb61q+tnqM851gEjy3lnlnRJUS424IqyqHMEiTXsdCxNksB8C+
 7PQ8fHHwSf/G7IvOFUB5x1BV8pz83J7MBKIr7W24WN3HedKW6h5GEcXW9Ex1CLJfMKA7
 XaLTi1mpIRR36fVGHm/DCtarnG2G6ohYongfl0I62htqcG+jwkOL2D0cZeZVM9aFruMI
 8b1zfnqRKjrul1Zw+r2MTm+s4VdW+cQat0njR4Xf8YG6RUmOrnxn8LzxLN/GWFJrT/ax X1TQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1687123988;
 s=strato-dkim-0003; d=iokpp.de;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=f2kgEMuIUUrHM5gBc5Sm8qQWNSiMWwhC4tlGu4p/URc=;
 b=dBt5lKWS8dqmRtY3qC7MaiFJqdMJFpEDTtsjzVMd/Pp8QsibX0A12xfWvfoG/iAKeA
 R8g9/41dk9kwuat6UcAg==
To: viro@zeniv.linux.org.uk, brauner@kernel.org, akpm@linux-foundation.org,
 jack@suse.cz, jack@suse.com, tytso@mit.edu, adilger.kernel@dilger.ca,
 mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com
Date: Sun, 18 Jun 2023 23:32:50 +0200
Message-id: <20230618213250.694110-6-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
In-reply-to: <20230618213250.694110-1-beanhuo@iokpp.de>
References: <20230618213250.694110-1-beanhuo@iokpp.de>
MIME-version: 1.0
X-Source-IP: 85.215.255.101
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10745
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 bulkscore=0 priorityscore=0 clxscore=72 unknownsenderscore=20 mlxscore=0
 spamscore=0 malwarescore=0 mlxlogscore=671 impostorscore=0 phishscore=0
 suspectscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2305260000 definitions=main-2306180205
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, beanhuo@micron.com
Subject: [Ocfs2-devel] [PATCH v1 5/5] udf: No need to check return value of
	block_commit_write()
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
 ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSedrgBzPc9DUyubU4DD1EQ33bneoxgmq5ARfEwes1hW/CxwfjqKzP/cKnUXGNs35zouFQhI="
X-ServerName: mo4-p03-ob.smtp.rzone.de
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-ORIG-GUID: yJN801ct9zjzAMtDY2jY1F1QPEPv5VdP
X-Proofpoint-GUID: yJN801ct9zjzAMtDY2jY1F1QPEPv5VdP
X-Mailman-Approved-At: Tue, 20 Jun 2023 14:56:20 +0000
Reporting-Meta:
 AAHNECSWBi79Wv0RNZv7GQQmv0noYfTp38F0F9yBFCFU8Fd6qZbTSJRwoqSt+X/8
 EJ1GMbD8xVjoRj3JHSFlNyGWGvE5DytYF1PB9PFsBt6eSP+aeNWWwTpv7xWpoKOx
 jcCUU9fd1F0Cuo80OSfWGBcUjYLWufNXmC4SUQcs94R9DiZy9Z8LAMrZ8bojP+Zg
 B1GOJt2HBUF7Rc+5QwuF2dhkgn6IHaa+h9LBShVptzbszwsFkCBpIbDsLi0VwS2q
 ZCkGK99iCpQHUQqPYY6c2k/yfy1tQ+X30V6VG8J9iwqgtluk70deS7GPAi9HbM25
 ZNegG3l463oIyaC7YnBQRr6ktJeMvD5vmCO7/I2FEL+HPwZpFe6t1k5oyp2m1sWT
 wqG4WP7ZgfXs5jNv/evKTBaZeDCikkYarLU/O4GVSsS39+yYQq5ZjX7LJBD/OWK7
 g0BdL3HnsRij382d9LB18nrRp+IW4MJWBZPkrOxCjPu5JxIeJmCSVMwnS0sa4Rvt
 94nGtCWOSu/4eoKn2hw6XKby2H0ntXMuehqyZnktiX0J

From: Bean Huo <beanhuo@micron.com>

Remove unnecessary check on the return value of block_commit_write().

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 fs/udf/file.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/udf/file.c b/fs/udf/file.c
index 8238f742377b..b1a062922a24 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -67,13 +67,13 @@ static vm_fault_t udf_page_mkwrite(struct vm_fault *vmf)
 	else
 		end = PAGE_SIZE;
 	err = __block_write_begin(page, 0, end, udf_get_block);
-	if (!err)
-		err = block_commit_write(page, 0, end);
-	if (err < 0) {
+	if (err) {
 		unlock_page(page);
 		ret = block_page_mkwrite_return(err);
 		goto out_unlock;
 	}
+
+	block_commit_write(page, 0, end);
 out_dirty:
 	set_page_dirty(page);
 	wait_for_stable_page(page);
-- 
2.34.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
