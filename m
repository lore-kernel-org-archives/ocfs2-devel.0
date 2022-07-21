Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44A6DC43334
	for <ocfs2-devel@archiver.kernel.org>; Thu, 21 Jul 2022 04:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=z60zg78MBcutnRZpsdcp9deTsNCOcDvVy/+vQlplh5M=;
 b=sNRiL28INb4qWePKXXIF9QN9CiKJ6RNMwCSBRP29/iDmWrC7bb4klp7KTFMrFNp5NqVMjZOEkTM/
   MHx23CHd/h8BtLxfDLx8R45ahhsAhYvNw1q0+vif64In82/yeg78CYVtrh0aN/kT/ohFrX2OoM8a
   FaXWt73evnQhb+2liTX4c/hpPxzO81eiuGYj/iicpH8aHNiNouC0LydJcpcb5qD8nL+5i3G9XATa
   FzFuLfGZsLOoBoRlFQkMpP4oYspZTL/RMe1J0xgCDtdPBJ/Q1OrBKMT1OM8QfZZxqHPNREPhoeVq
   OsKt/+8PIOLcqOLedTSkNhwaOVBYNIK8iGWQdw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=z60zg78MBcutnRZpsdcp9deTsNCOcDvVy/+vQlplh5M=;
 b=aPwmC7cvVP+2uG1PNeYKRFJZb1lAlGu2CvQbiSxMlnO9dqdw3CB1Z+R5ZAziy9afxCj3rnpmNx47
   /p/2n3/Mbi5osRYAy0IbggQR9Y/B2YZv8TRnOxD0eLuJrrJgpDzzG4BStseusPT5pTwE/rsNy+KH
   sdUFlhxgg6+Jkt0Lfhd9QIz3AEZenKadxyVEA7abv0oPu88tdn+xhzTjH0KTccbwNCZYmdKcw8kh
   A+wdmgfW/Pjmia0zLQIRAbTwq84g0VHfW1F76QbNAKMAUW1ojTYyUijV1mxsA3OcsuQmuytogtzg
   malXatgVpQDjSxX8qPj+/i+iUePd8NdhpNk22Q==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220621 64bit (built Jun 21
 2022))
 with ESMTPS id <0RFC00D1ORVXN990@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 21 Jul 2022 04:16:45 +0000 (GMT)
Message-id: <20aa3fe4-0ad1-80b6-ca64-b0bcba884b49@linux.alibaba.com>
Date: Thu, 21 Jul 2022 09:53:18 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Content-language: en-US
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
References:
 <bd6796635e58f9c47cf857573c3b9474a00ce26a.1658224839.git.christophe.jaillet@wanadoo.fr>
 <8ba7004d330cbe5f626539a8a3bff696d0c4285e.1658224839.git.christophe.jaillet@wanadoo.fr>
 <7b644e5d32d74d3d90dfc5b1786ae5b9@AcuMS.aculab.com>
 <29c3fbdd-7695-46c5-bb75-fe358c574ab3@wanadoo.fr>
 <07c924de-78bf-c993-ce73-635af71f4edd@linux.alibaba.com>
 <f313cb6f-de75-2447-eebc-5c240bc243a2@wanadoo.fr>
 <65e6bbcb-2c33-2e43-1826-a62387572310@linux.alibaba.com>
 <a66632a1-9cde-1b3c-afa9-8f63bd4a9cf0@wanadoo.fr>
In-reply-to: <a66632a1-9cde-1b3c-afa9-8f63bd4a9cf0@wanadoo.fr>
X-Source-IP: 115.124.30.57
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10414
 signatures=596000
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=1501 suspectscore=0 impostorscore=0 lowpriorityscore=0
 clxscore=-17 bulkscore=0 adultscore=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207210006 domainage_hfrom=8498
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
 David.Laight@ACULAB.COM, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 2/3] ocfs2: Remove a useless spinlock
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
From: Joseph Qi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Joseph Qi <joseph.qi@linux.alibaba.com>
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: base64
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R731e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018045170;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
 TI=SMTPD_---0VJzMVEo_1658368398;
X-ServerName: out30-57.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: hAwRDNSwg9ru5TFdo7TGlOmibqBl3qur
X-Proofpoint-ORIG-GUID: hAwRDNSwg9ru5TFdo7TGlOmibqBl3qur
Reporting-Meta:
 AAHczefPJYJkUUNOcd/kSbAGu3JnLOJfMDqlOEcbZXATa4B2wmLLY2QhcnX30q2e
 +DuGjaMYu9sv9Tbm9NUhPI0sM0GAYdIhFqSiqpwWzZlROgc6IbX3tm7RzIrhg/Yi
 6T2X0jimpTjD7cvz+WaS6IArxSlc8V/tzWYR69q+okrRE4FG/FNV8iUvXGwD3Xct
 m2M98QGu31QXfWTVoIl8VghpAveJVBx8JE3CaFG2rpm7iz0jDtKymSt/2r404lCX
 ylTmrRP58XEol5wgaM3ApqcUCsyqb9A0b0HMQwGn+FZRWjsQvCcD36SCSt7eMhBO
 TeMqa1KUtVJUN7h1vf3oB0MsNADdXicTxJgRYZCkEnnEqatTWmymrmiU4E24+L3o
 8HhczBYFYRbwj0JlP/0fN4dgkdckqafb2aAVPPheCWkA3nY8GokBxemYerhTacY0
 dJcoiA2KAQWZ7i5j7YgL3DK8CtotXC36XeqRHo9vM+4jx0awibAglfwPD947MnHu
 MhUYO+h7abwXqZUyMdknRZn/PNvGiRyjxnFk13Fd8qE0

CgpPbiA3LzIwLzIyIDk6MzIgUE0sIENocmlzdG9waGUgSkFJTExFVCB3cm90ZToKPiBMZSAyMC8w
Ny8yMDIyIMOgIDExOjQ4LCBKb3NlcGggUWkgYSDDqWNyaXTCoDoKPj4KPj4gVGhlc2UgY29kZSBh
cmUgaW50cm9kdWNlZCBsb25nIHRpbWUgYWdvLi4uCj4+IFJlZmVyIHRvIGNvbW1pdCBiNGRmNmVk
OGRiMGMgIltQQVRDSF0gb2NmczI6IGZpeCBvcnBoYW4gcmVjb3ZlcnkKPj4gZGVhZGxvY2siLCBJ
IGd1ZXNzIGl0IHBsYXlzIGEgcm9sZSAnYmFycmllcicgYW5kIG1ha2Ugc3VyZSB0ZXN0IG5vZGUg
bWFwCj4+IGlzIGV4ZWN1dGVkIHByaW9yIHRoYW4gc2lnbmFsIG9ycGhhbiByZWNvdmVyeSB0aHJl
YWQuIEluIG90aGVyIHdvcmRzLCB0bwo+PiBzZXJpYWxpemUgZXZpY3QgaW5vZGUgYW5kIG9ycGhh
biByZWNvdmVyeS4KPj4KPj4gVGhhbmtzLAo+PiBKb3NlcGgKPj4KPiAKPiBPaywgc28ganVzdCBs
ZWF2ZSBpdCBhcy1pcy4KPiAKPiBTaG91bGQgSSByZXNlbmQgdGhlIHNlcmllIHdpdGhvdXQgdGhp
cyBwYXRjaCwgb3IgY2FuIDEvMyBhbmQgMy8zIGJlIGFwcGxpZWQgYXMtaXM/Cj4gCgpJZiB5b3Ug
ZG9uJ3QgbWluZCwgcGxlYXNlIHJlc2VuZCB3aXRoIG15IHJ2YiBhbmQgaW52b2x2ZSBha3BtIGFz
IHdlbGwuCgpUaGFua3MsCkpvc2VwaAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0Ck9jZnMyLWRldmVsQG9zcy5v
cmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9saXN0aW5mby9vY2ZzMi1k
ZXZlbA==
