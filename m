Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6595C433F5
	for <ocfs2-devel@archiver.kernel.org>; Wed, 12 Jan 2022 08:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Z4288Jr7thEVvkn1dZSMz5nXYP6pseXS4AkHms6wJy0=;
 b=MxwCmue4A83Z5JiyaXNRkg063VaOaZmE9VKWebVsTf97sGpGo8RDnm2QLNOOTlcUQSuMxeox8XrY
   rJGgs1hnaR+kBS3Yfv56SoTPrLAtVV2vxmFr+Di6r9JCXzSOSwz8FKfn6gZSGAGBRVqQLBNaKvuR
   ETqEk6ogr9D9n5Bqf0pfp4xfxWRpqIqhU0puxJxbmLxvZ9u/wsTCPRuJ2zw0gx4IO1S/dvWW0Qd0
   zKhGfpa4vHcs80E1CSpMsB55N1jqtQAI/Tf9C/6vdaZ9UYH5cgJ7tGqSBGFrNfWVxyY5n4F4+m3j
   K7Q0Yt5T8IFLSI0U6aVAyGHS7Chl+hz7WkQlpQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Z4288Jr7thEVvkn1dZSMz5nXYP6pseXS4AkHms6wJy0=;
 b=I80DdQ3a0RZPzmPgHGMPKEyVbtl1M+8ksr1sUiuWVhDuhYGxcq6aw+LKHR/WLHauUlgLs/vOt1GN
   CV1qejJbMEgHYbOTSLPJq792Q3zOPCnF87m4127KJLWihocgNdNighzl4Xdsf9KWUKPptUe+ijwJ
   BEih6UPEtg0P0z3HGgmgUVKBA3ehudOMH2wn0i4DHqAC4Zjw7JGoWOBt6bX08eD/yw9reYrs5ZGw
   OnAwYpnulcJPjG239QpgBJ68eTPeDZKE0RIVPfJNUCotXpn/FZIG16iU3marYBtdiWt0Q3p9qWuF
   +e7zwsM1l4Y58z7tx5vhPtnNFQS11+C4r62KhQ==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20211209 64bit (built Dec  9
 2021))
 with ESMTP id <0R5L0016L883TH50@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 12 Jan 2022 08:14:27 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=cgel.zte@gmail.com; dkim=pass header.d=gmail.com
 header.s=20210112; dmarc=pass header.from=gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=from:to:cc:subject:date:message-id:mime-version :content-transfer-encoding;
 bh=iR0lUnzAD3Q4l81+MH9jHlQ80I7ebpkxiYExJYSnlE0=;
 b=gTzQAHAm6MZssV7h1/4i/QnrghPm6YFhsce53+RPOhbQVFNspioZ6cj9CjIKqp/aZF
 Xvae4avqdqM5aDrVvRXQcJP9qJD34QQ3G7esOhEf2wy0hXqf8wxY3V97Cno0kv0Bfh00
 UHwFgAq27v533l53NjVblm+vQVBzxd25GvEY4vnftwpMAy8hlLp2qdflyPObB0nfg7Uo
 bFt50AWQ48S9ckMac/y/mJMrGHSnaD0Q0OSuYk+HalBPEUuDvdetQUaYZa5VUrkY7NNL
 iGKiIBqpIlwbEhB0hE/qkcnvAYbDY93+zpnQZHv6lVf4dIbdlQMFRh1Fr8IGIhAfC5uM W1rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding; bh=iR0lUnzAD3Q4l81+MH9jHlQ80I7ebpkxiYExJYSnlE0=;
 b=b3CY/b5xkutNzpc4/oAF9hr/ZLxqNK+SN6UXZFrv4eTLPcOGChEgSPs3mfFio4ZZoX
 CKr6YLauJpYzYZ3aJtTIg+vaQckXgL9DcwPPTowPSrWrN9c2/HEeXOMIu4W/e40cOc5m
 Hz23gde1oKg97Tqut1BZbbVt7JPZDuNz9n788qZ8QKL+iNEsivpDI692ZQgUKN7oLKO6
 GgLXiiQ+1Ats68UWzAX6h+o/GU9+Kz4EByIEV1YOfaIp+gj1xZFP9BYirMCUqfwvPmd8
 Bl305x0UFFAhnHmJR0qF1GZbUl/uHJQEJG2NZWevHvM6D9+nm3704b2SgGjPEzU1Ecgu gSGA==
X-Gm-Message-State: AOAM533kG1g2hfe2c6Hpy3cqf1cZ8l/EUoPdVXLtziyNXonauVTV1aC3
 IMVr3qSQVKxSK6eqwkVeRiU=
X-Received: by 2002:a05:6214:c45:: with SMTP id
 r5mr7010672qvj.111.1641975255148; Wed, 12 Jan 2022 00:14:15 -0800 (PST)
To: mark@fasheh.com
Date: Wed, 12 Jan 2022 08:14:08 +0000
Message-id: <20220112081408.667411-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-version: 1.0
X-Source-IP: 209.85.219.44
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10224
 signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 priorityscore=465 phishscore=0 clxscore=236 mlxscore=0 suspectscore=0
 adultscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201120051 domainage_hfrom=9649
Cc: CGEL ZTE <cgel.zte@gmail.com>, Zeal Robot <zealci@zte.com.cn>,
 linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH] fs/ocfs2: remove redundant ret variable
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
From: "cgel.zte--- via Ocfs2-devel" <ocfs2-devel@oss.oracle.com>
Reply-to: cgel.zte@gmail.com
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Google-Smtp-Source:
 ABdhPJzOoaH7o0MsxeXn2LqP9mesagpesw1w3+gHERyG7I/2Jjen9r+pRgfBBbflphqx4ttLGAVLVw==
X-Google-Original-From: chi.minghao@zte.com.cn
X-ServerName: mail-qv1-f44.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Spam: Clean
X-Proofpoint-GUID: FPSZ4u0xK2CaMBWr7aDu2AXPGGZWS-uZ
X-Proofpoint-ORIG-GUID: FPSZ4u0xK2CaMBWr7aDu2AXPGGZWS-uZ
Reporting-Meta:
 AAHUzFVid6KcysDg6NSAF9Xg8UYExGiNQcNuF9Tgg5hdkMlgglFh2/ApR7xEXLlm
 Gp5SCagDc0drKhrHBagaJj25o9ujS6b+lKfzXMxwVH9t3q/1ssqLUiR/lV65Rfo/
 rocN3hMFXuzOMJb6oq0iPbqTOC5gV+UTgmRaPv1FDPr/uq2O0gBYFU+7sW7gWlL4
 Gj/K1IjQ7cMw3dwRZBTzANrp7g2SfsfjxUmp24vPStWpQCn84T16nJ3J6uh4OjKx
 FZ8aji+mdjCtPqvPHkIqNQSWfT6Ai+/tdVfrQGCTuSvoyecmKVky4wdWtiegixEw
 WJt33UkH1HX/QiQbi7aizAEoqcupLq3eZl41+unEOe+snurHR4nDbtWSOr5xO3TP
 +su/Zw7rPSYMoJA2/hRNC4WTsBXUhjvqUPra9PIIN7ld+5aD2Rd/VOyG+lf7hVJi
 1pmvNP33QDyUqCg48PnL+f9tvETSygDhXorQVBS+JefnQ5lT7rOn9opsWhTaQQac
 Vd9PhLATAZDmDLIrf0XLX9oBzx2G7B+u5FlYZ4ziS84=

From: Minghao Chi <chi.minghao@zte.com.cn>

Return value from ocfs2_add_clusters_in_btree() directly instead
of taking this in another redundant variable.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
---
 fs/ocfs2/file.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index fc5f780fa235..9a46dcef448c 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -540,15 +540,11 @@ int ocfs2_add_inode_data(struct ocfs2_super *osb,
 			 struct ocfs2_alloc_context *meta_ac,
 			 enum ocfs2_alloc_restarted *reason_ret)
 {
-	int ret;
 	struct ocfs2_extent_tree et;
 
-	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), fe_bh);
-	ret = ocfs2_add_clusters_in_btree(handle, &et, logical_offset,
+	return ocfs2_add_clusters_in_btree(handle, &et, logical_offset,
 					  clusters_to_add, mark_unwritten,
 					  data_ac, meta_ac, reason_ret);
-
-	return ret;
 }
 
 static int ocfs2_extend_allocation(struct inode *inode, u32 logical_start,
-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
