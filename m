Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6EA4C43334
	for <ocfs2-devel@archiver.kernel.org>; Wed, 20 Jul 2022 19:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=9Cxg8aQPu5uXhZwXIULNK8NU+L9aNCDb88djJwefH/g=;
 b=zSNPOB8amWddhLdTZZrI5SfQMpd0WJCDWtGMm1AR46npdJRLirrylE0VwtS00k/qFrnk4VBc5ybn
   RkE8QwYuc6wUpB4B4MomK6OyeEdFVuev42xunZFCacpcR75wDqwqCM4xSAqz0sQrVt3JolnTdg6/
   tFa3+4FKqNWMe+WZQL8Z6FvE2rAxrJO2urLFI4ov0YcFSaR/58ktgvCM9ANwQyXfREVPhIJ75eS4
   LJAr7Zc+YJGitafnbz6I1CLxbk51YL3MUVVFLBZEvUd08rhfEotzcv/kcy8KjneC+pD8iVm+eVVh
   NB7E95l+ymMjvPCuh9yqktz3bMAY+MUydNmvfw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=9Cxg8aQPu5uXhZwXIULNK8NU+L9aNCDb88djJwefH/g=;
 b=q/ujqxZb9r305ODpV/gkblm54XH7utI+KwDIz7avzrJFDHDBqpx4riG/68/KmTCzyfBA/vGiNjuR
   nbw0xdWD7T6uu+NaNpX8hFME7JBhN7ckdi+A/JEc2OUh6URFnf8cLdACu52hVPKODGRnMKjDWpGq
   y/3/In5ampJMaCq5tHoFLL6p1yZm8AYpyjClm027q7NTMTu4oaYFZJarywxN25PhU/E0cJ10u+3x
   lJTsfoU6s7KHJFpe03UyyK1UmZzSsavzqaFh5Q+AKWmIo7VpWga9acb1oH3PUcxrFwtjzOK0vEM1
   iHIltHOWHH539rblXw7iyPddJocnLg01Iq41Cw==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220621 64bit (built Jun 21
 2022))
 with ESMTPS id <0RFC00LYV4S4MM30@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 20 Jul 2022 19:57:40 +0000 (GMT)
Message-id: <a66632a1-9cde-1b3c-afa9-8f63bd4a9cf0@wanadoo.fr>
Date: Wed, 20 Jul 2022 15:32:07 +0200
MIME-version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>
References:
 <bd6796635e58f9c47cf857573c3b9474a00ce26a.1658224839.git.christophe.jaillet@wanadoo.fr>
 <8ba7004d330cbe5f626539a8a3bff696d0c4285e.1658224839.git.christophe.jaillet@wanadoo.fr>
 <7b644e5d32d74d3d90dfc5b1786ae5b9@AcuMS.aculab.com>
 <29c3fbdd-7695-46c5-bb75-fe358c574ab3@wanadoo.fr>
 <07c924de-78bf-c993-ce73-635af71f4edd@linux.alibaba.com>
 <f313cb6f-de75-2447-eebc-5c240bc243a2@wanadoo.fr>
 <65e6bbcb-2c33-2e43-1826-a62387572310@linux.alibaba.com>
In-reply-to: <65e6bbcb-2c33-2e43-1826-a62387572310@linux.alibaba.com>
X-Source-IP: 80.12.242.23
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10414
 signatures=596000
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 adultscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=649
 clxscore=-11 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207200055
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
From: Christophe JAILLET via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Content-transfer-encoding: base64
Content-type: text/plain; charset="utf-8"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ME-Helo: [192.168.1.18]
X-ME-Auth:
 YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Wed, 20 Jul 2022 15:32:15 +0200
X-ME-IP: 90.11.190.129
X-ServerName: smtp-23.smtpout.orange.fr
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf_gp.wanadoo.fr
 include:spf.email-control.orange-business.com include:_spf_gpf.wanadoo.fr
 include:_spf_other.wanadoo.fr ?all
X-Spam: Clean
X-Proofpoint-GUID: yRp3ZlJQE_U1JoQIPuc-D8h8BQxxRfwm
X-Proofpoint-ORIG-GUID: yRp3ZlJQE_U1JoQIPuc-D8h8BQxxRfwm
Reporting-Meta:
 AAFJODOdCYe9DCUtj/VsjpX8RNu3irgoQvIEJhYLwXqJsHtGtixJeotYU+ft2guK
 fIPwh/7yMB4kbYQ1YoNCtUShJ01EJ7l2fWwyCmuVdfNvlf1IHZkzV292/2JcyZmT
 P8EvhQX7w9vaQ5vfAZbmYKmywSEGgIzN17w9aokHOHwQ5GC9j6ak449SgfNnj+lV
 Mb4IK0Epu2/ZQU0fONZLttDMulQf/CUdS4dgeAw8H29DelUY9n+QgViB1CR7Iel1
 FDeiFL1QBQBjlN2XxP0FszxJMPE2z7br7Fa4IU0CRKlgG+rWZTmO9xPidOWzkFYO
 78+w6YX0HfTsjgRtjKx8xvKcE1UYnlW8aka0t5COS6uBtgtXLGrxiwqj5mlKpubW
 xQoc/WtVRcOtjKg37/MPTiteo/VO7+0AAhuq9gV5SvsiLn/AM/xaym6byPQtQzXT
 rX12DaEbmv6zSEfnQ3JdLEtQ6gvj5e5mxhvaXqRIWyDt9++m9wQnibq6EUZ0euea
 61SjxJ9eSPQsqRyvZRoVfMicST/ni+ml70dIKP9EcOJQ

TGUgMjAvMDcvMjAyMiDDoCAxMTo0OCwgSm9zZXBoIFFpIGEgw6ljcml0wqA6Cj4gCj4gVGhlc2Ug
Y29kZSBhcmUgaW50cm9kdWNlZCBsb25nIHRpbWUgYWdvLi4uCj4gUmVmZXIgdG8gY29tbWl0IGI0
ZGY2ZWQ4ZGIwYyAiW1BBVENIXSBvY2ZzMjogZml4IG9ycGhhbiByZWNvdmVyeQo+IGRlYWRsb2Nr
IiwgSSBndWVzcyBpdCBwbGF5cyBhIHJvbGUgJ2JhcnJpZXInIGFuZCBtYWtlIHN1cmUgdGVzdCBu
b2RlIG1hcAo+IGlzIGV4ZWN1dGVkIHByaW9yIHRoYW4gc2lnbmFsIG9ycGhhbiByZWNvdmVyeSB0
aHJlYWQuIEluIG90aGVyIHdvcmRzLCB0bwo+IHNlcmlhbGl6ZSBldmljdCBpbm9kZSBhbmQgb3Jw
aGFuIHJlY292ZXJ5Lgo+IAo+IFRoYW5rcywKPiBKb3NlcGgKPiAKCk9rLCBzbyBqdXN0IGxlYXZl
IGl0IGFzLWlzLgoKU2hvdWxkIEkgcmVzZW5kIHRoZSBzZXJpZSB3aXRob3V0IHRoaXMgcGF0Y2gs
IG9yIGNhbiAxLzMgYW5kIDMvMyBiZSAKYXBwbGllZCBhcy1pcz8KCkNKCgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5nIGxp
c3QKT2NmczItZGV2ZWxAb3NzLm9yYWNsZS5jb20KaHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9tYWls
bWFuL2xpc3RpbmZvL29jZnMyLWRldmVs
