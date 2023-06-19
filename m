Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCDCFEB64DB
	for <ocfs2-devel@archiver.kernel.org>; Tue, 20 Jun 2023 14:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=QbB7VUVipyx5vQRD3VmFIIoA7FojekIxRnB4gSiziyw=;
 b=XV4TsbApWs1foDgxke/PXwhruM01Lw7rs761J6XmlZ3O2KJPdoEiMTOzN3UwIPk27rbT2/RSrigu
   tU9Fs7955+d/tIktY/s+nNHcB/7amLU1AB2CAb5hLnAvDYKKPHEDA2+XW2PAj9bwv7rgfi/lBSWI
   jxCYdA2mJ8WfqTe0m+wT2WSyYKm1niTfkobIHqQDQyWeV3OjtsWD5nYJJBb5xoUY1SllRzRiSbjj
   xcTQ6sYu/0rR9qu/Kl1ExW4UzKyLu5/v3+9mARu5HQkT05bmuax1A2ebhKfvSzDP/hZdeRXdrVMv
   qE8Znd5Lsja4cRDPDO/+Utct8nvawo837AOoWw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=QbB7VUVipyx5vQRD3VmFIIoA7FojekIxRnB4gSiziyw=;
 b=LA9th0Lc4mekFAbofb3HomHKmkysVSK4ScrTlartADd4fGjj8heFLIwXNVNgi1TrHdTgPYed2Tpb
   DD3/Y1haVciNKPmb6XNw4E0kVCht7o5qqUD7k05OaoN8Jj5JWV/2UaGtBrV6OpDmxbK8n2P8eerD
   AmfaTyEF01vkDqG0xaUWP62CavxWWPCa4asWiwTAO/tPKgd6b7CKUswOErVLSRkPZUT2X1IQqPs3
   jwsCoyhbHW2JQSfWi0r6wHd2uYr8o4p9RWeHUQ6oIVmibX642L8iebFUAYarH0ESZuv77UXRudo/
   Pp1btWGVc//V6N2aimJkhh093H0X6A4MFv0Bbg==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWK00L4945YM9B0@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 20 Jun 2023 14:56:22 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; t=1687209525; cv=none; d=strato.com;
 s=strato-dkim-0002;
 b=bwDqLgqKnOIMa/KblGf7DCSOdomLj8qYLhRv9zU+ahqAVFoKEz5MFu0kXcY8KfhAXH
 tHC35vZ8b79c/wGpvuuwH2QAaTfqAoLCrBrZuHJJxWbHerBhq4PUi7Vxha3Lt8BBT++a
 OKVlUPZx2OqKhR369+AJkjCvIKU41m/VrYs2EeUKGffe4ZoycTYRomCfx4Cxb4nkBfob
 KFzO1JtbymOdSs9rmP9sHp/HzaLQpEkbXDikDDwi92tnabyBRhSnzBjy4mUV9h9H0BmU
 ZZEguartBN4n56Vgd2iftbjGb/E/g0Hu7r1bdkURzOMI+R21jP1xUByJNPN4IFLifAGU 6Z4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1687209525;
 s=strato-dkim-0002; d=strato.com;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=u8a2OuOvxT1/oVmGmWM7pshVQC/wQv12L8jJddp76/w=;
 b=gZvQrwnarG0oeqM2lTZmo1obElmXryHEiGl5rTaOMytcF5GV6qb10JQRUSTlk78ZBr
 my2uhiRb7tODlRKlJfZGIMoWNHPtrxmySJWu32wwNlOkOy/CgjyhF3rfjwRPYzKdUJyA
 Y9Jp/f6lEFTd98Lm3aTZ3eAiF2SAjfE6536aVxKU4p82uao+Cjm5vpmj4aiCg5/w4OAz
 vXyLTe5Cqi4B70Mwo6078rUhPgHS/Nw9w8zI6M49hVkhWreHqAwDLzEl5Z+N3kyK3Ewk
 YnnuTk4NqUi55Ri4legQKGcYEdb3sVl6poNHO7b+6p22wVKdoRjfzekB9cuh1zcYyOaA /vBQ==
ARC-Authentication-results: i=1; strato.com;    arc=none;    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1687209525;
 s=strato-dkim-0002; d=iokpp.de;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=u8a2OuOvxT1/oVmGmWM7pshVQC/wQv12L8jJddp76/w=;
 b=NWHvLYHVBE3vESRJ/FKFx1BobgaCF60h+WBAXiODGLsXtceWhYn7PgNv3MV5MXctni
 FK/8gdXtnsHydylzQbFCYdTwzC4MZmRWSP6OYqsFThJ0kysIE4SDRaLDFxoaXFZLA1xC
 XckGwVvQhj63Lc9eVAzGHMasn7FQiEPnYraBh8/Ygwm7C3hujqBNPYoJp/F04jznI2Qz
 OnQixCQPT3StmDtCX5MrkWLj67MM9yggscCU3RdXslVV0bNEHGn/bYstka/MGSE5IKVe
 QK2OuVNkugRG7bF3ujpI8fK653bXfGgH3fyF2pfZIilyQ7l6tkBDYI3BaO8mzAzaxnGp vZQQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1687209525;
 s=strato-dkim-0003; d=iokpp.de;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=u8a2OuOvxT1/oVmGmWM7pshVQC/wQv12L8jJddp76/w=;
 b=4rKvSZyKZJICpIQNJpD8yX06uHxBEBD8VbMS0AWhaOLUZImM7784EgsI2s7KDFBrz/
 ua48CzseU5n1lhgMvhAA==
To: viro@zeniv.linux.org.uk, brauner@kernel.org, akpm@linux-foundation.org,
 jack@suse.cz, jack@suse.com, tytso@mit.edu, adilger.kernel@dilger.ca,
 mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com
Date: Mon, 19 Jun 2023 23:18:26 +0200
Message-id: <20230619211827.707054-5-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
In-reply-to: <20230619211827.707054-1-beanhuo@iokpp.de>
References: <20230619211827.707054-1-beanhuo@iokpp.de>
MIME-version: 1.0
X-Source-IP: 85.215.255.82
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10746
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=140 phishscore=0 adultscore=0 mlxlogscore=579
 unknownsenderscore=20 lowpriorityscore=0 suspectscore=0 bulkscore=0
 clxscore=118 impostorscore=0 spamscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306190196
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, beanhuo@micron.com
Subject: [Ocfs2-devel] [PATCH v2 4/5] udf: No need to check return value of
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
X-RZG-CLASS-ID: mo02
X-RZG-AUTH:
 ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSedrgBzPc9DUyubU4DD1EQ33bneoxgmq7ABeEwyjghc0WGLJ+05px4XK4px0+bSzE8qij5Q="
X-ServerName: mo4-p02-ob.smtp.rzone.de
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: Uu9HfpMo4o42gzeANpjgv-Xdiy7ckaOZ
X-Proofpoint-ORIG-GUID: Uu9HfpMo4o42gzeANpjgv-Xdiy7ckaOZ
X-Mailman-Approved-At: Tue, 20 Jun 2023 14:56:20 +0000
Reporting-Meta:
 AAHAtckAKFi1UxcRjLIJBvtI9yXX2DEYEQ8aAG/WoXG6qJbuYAXwL/Lb+twLNtON
 7rbh37hFE+lKFzvq6RR8Lu3K1ToOKZDEuJgthQpm6Fx+89bvLurLZsX88ThbGqLx
 XrkGABMA+4p33ln+oIy0ws34FbqjK38IDYJPgvEhQZRSzkEDHdOxhTpxqIjMRNcF
 0X6eascLXrdbvQEfyEDk/fREU01SQst5Fiuax7NMgjSxwuL+yby/+xDGGaw1KnZk
 P4nRiJhLyW0OqQ+ro/aO/f/xLuTEOfh9gGRNfua0Ig7iRbx5gP4/7TGdRa5lRfMw
 KHqghy08fSPjT8kfSRKT4HPYIZa2VI/gtRpw1uodeNQrFDP4bGh3wTQBiq3MUjjP
 mL4VbKC/Dth5Pb4Ez+xSrO4Wb99ITnZ4pLyJW7eHBoE8JgbuTMYPV/KgFcVMbup0
 IdL9+8VjluZHeVpLrX8hkdBrKcmzo/vwfeVyyqoYjPRnztTCbkgq2VoC28GiPX6u
 Y9dVvdofaaTVH3PgnPMCN9tK4x2Tx8Pqx9uooKdRQsA=

From: Bean Huo <beanhuo@micron.com>

Remove unnecessary check on the return value of block_commit_write(),
because it always returns 0.

Signed-off-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Jan Kara <jack@suse.cz>
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
