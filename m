Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FAD9C433F5
	for <ocfs2-devel@archiver.kernel.org>; Thu, 20 Jan 2022 02:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=yjG9QCwzOTaKPqQ354uGxrZR5gZbzR/8gsl7sPOjYHA=;
 b=NlZTx8/vUa5cRyChKe4EN/Gyi0AN+h70FFmi8q4eU68doERwjZPLfO3DouYCyPaBktr4Aa9EYF6i
   XihJ4ZWHCkMgR6Z+ZKIZ2Wbno9KB9H+DWy3i+M9EZhxVdm1IHfPZxKjEOfRgXWFRm+Jsc6rMFSMA
   yBMFudWyjuvjhaBe5iXyhv1ZmutyyJMJQMbBq65IubA3O71ZVaO61LmzwLRvRiIz4XmutCjDANJc
   hQdRhkjWjPl7qIliBpB7HVp8p6S6HyDRouv2mMLnVms/+k/utPfeKt0+/PHJ9PeFdvoQ/gbwS/uX
   KlhseEpyXVGEB0E6ETbxlX3TT9oALfOdROlguw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=yjG9QCwzOTaKPqQ354uGxrZR5gZbzR/8gsl7sPOjYHA=;
 b=nS3K1m3LDFV5wasBO2OVpg0WSS8QblONfoRDJ8KtoQO94c74aNTsr+iGGTa/XR8J1yDeke0iexUN
   k8YmL7t7qd9bLP/AgfV+i76xnvnxuA5LtJv6dweV3b3HUgLO9YinGR7kV5pg3BqC5/rHR8Yr0CJe
   Wq41/XUuOd9Ktbp+O6f2/hvnZzewKBcbEq1lMF+0uM/rbhKyne02I243qvowPsKGcmXu1BUBsiu0
   GhOMroRZT7JRKqXmuo9iVXjvbjdkLz1NbIIy1lLyoTLTMqmj7ta+/jG70MUQ3ZsjATIoVxRhSJuV
   5Anc+ZXCF9VxOkf/mAAlABWPYIV3xcTbMbQ//A==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220104 64bit (built Jan  4
 2022))
 with ESMTPS id <0R5Z00BCKKVHHKF0@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 20 Jan 2022 02:14:05 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=joseph.qi@linux.alibaba.com; dmarc=none
 header.from=linux.alibaba.com
Message-id: <bf115905-28ce-867d-8772-563536987052@linux.alibaba.com>
Date: Thu, 20 Jan 2022 10:13:46 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Content-language: en-US
To: Dan Carpenter <dan.carpenter@oracle.com>, ocfs2-devel@oss.oracle.com
References: <20220119112936.GA8111@kili>
In-reply-to: <20220119112936.GA8111@kili>
X-Source-IP: 115.124.30.130
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10232
 signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=0
 spamscore=0 malwarescore=0 mlxscore=0 bulkscore=0 impostorscore=0 clxscore=178
 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201200012 domainage_hfrom=8316
Subject: Re: [Ocfs2-devel] [bug report] ocfs2/cluster: Pin/unpin o2hb regions
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R841e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04394;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0V2JWoUS_1642644826;
X-ServerName: out30-130.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: rvvaD3vzYQwrNe4scVljaoaDDeDCXVkK
X-Proofpoint-ORIG-GUID: rvvaD3vzYQwrNe4scVljaoaDDeDCXVkK
Reporting-Meta:
 AAEVEWPIG0bhJX2MJj4P5Xn5XZAJf2ujk3ivrzL8w/VzfltkOIDrPvyxgjuuhblQ
 Ux+An9g4FLdbwjRcW6Qvb8pEQX257k5Yb4g/PYmqzHSzYSn6luNWYGietT4oSr4F
 NTLflfwrAwsRlPHC9hsJ3utm0jqbxNln2VuxDFx75D7gErSF1xatq3wo+epD2LNh
 uRs+6RVHIzMssooRA+i01cwZAodK2sGkh+D0CgqhgEmvFo08Of+DnucBWlV4aCYT
 ZlyN+l8/xalZPzbsRtODQ1fjYSjKW3lv3R6RK11gZ8lpHfo9wReyzUJ6n/4APv+8
 sO29XaR+5OvCm5q1DAgBIsyujLXBXz8nyBJaHFcyOb9QYpu+QVhKvtM3GIpaB5iT
 OtRgSnoLpTnlIcHXkmgrwpNOnYo/Am2JvMZJETGGfqDJHgqcUplDLWuuhV6e6gdD
 c5pLH4WLCX7Fvt+7HtlLJVd6LcOAy8AEohq0ECdV3vVmXjd7b0Bw7MiMx13i3tKG
 siXHOz0GYzx/+LnOZGN6zTpMJf6k4CIFVZgZzLyxXZFi

SGkgRGFuIENhcnBlbnRlciwKClRoYW5rcyBmb3IgdGhlIHJlcG9ydGluZy4KSXQgc2VlbXMgdGhl
IGJ1ZyB0cnVseSBleGlzdHMsIGJ1dCBjdXJyZW50bHkgSSBkb24ndCBoYXZlIGFuIGVhc3kgd2F5
IHRvCmZpeCBpdC4gSSdsbCBsb29rIGl0IGRlZXBseSBsYXRlci4KClRoYW5rc++8jApKb3NlcGgK
Ck9uIDEvMTkvMjIgNzoyOSBQTSwgRGFuIENhcnBlbnRlciB2aWEgT2NmczItZGV2ZWwgd3JvdGU6
Cj4gSGVsbG8gT0NGUzIgZGV2ZWxvcGVycywKPiAKPiBUaGUgcGF0Y2ggNThhMzE1OGE1ZDE3OiAi
b2NmczIvY2x1c3RlcjogUGluL3VucGluIG8yaGIgcmVnaW9ucyIgZnJvbQo+IERlYyAxNCwgMjAx
MCwgbGVhZHMgdG8gdGhlIGZvbGxvd2luZyBTbWF0Y2ggc3RhdGljIGNoZWNrZXIgd2FybmluZzoK
PiAKPiAJLi9pbmNsdWRlL2xpbnV4L2ZzLmg6Nzc3IGlub2RlX2xvY2soKQo+IAl3YXJuOiBzbGVl
cGluZyBpbiBhdG9taWMgY29udGV4dAo+IAo+IFRoZSBjYWxsIHRyZWUgaXM6Cj4gCj4gbzJoYl9o
ZWFydGJlYXRfZ3JvdXBfZHJvcF9pdGVtKCkgPC0gZGlzYWJsZXMgcHJlZW1wdAo+IG8yaGJfcmVn
aW9uX2luY191c2VyKCkgPC0gZGlzYWJsZXMgcHJlZW1wdAo+IC0+IG8yaGJfcmVnaW9uX3Bpbigp
Cj4gICAgLT4gbzJubV9kZXBlbmRfaXRlbSgpCj4gICAgICAgLT4gY29uZmlnZnNfZGVwZW5kX2l0
ZW0oKQo+ICAgICAgICAgIC0+IGlub2RlX2xvY2soKQo+IAo+IGZzL29jZnMyL2NsdXN0ZXIvaGVh
cnRiZWF0LmMKPiAgIDIyNjUgICAgICAgIHN0YXRpYyBpbnQgbzJoYl9yZWdpb25fcGluKGNvbnN0
IGNoYXIgKnJlZ2lvbl91dWlkKQo+ICAgMjI2NiAgICAgICAgewo+ICAgMjI2NyAgICAgICAgICAg
ICAgICBpbnQgcmV0ID0gMCwgZm91bmQgPSAwOwo+ICAgMjI2OCAgICAgICAgICAgICAgICBzdHJ1
Y3QgbzJoYl9yZWdpb24gKnJlZzsKPiAgIDIyNjkgICAgICAgICAgICAgICAgY2hhciAqdXVpZDsK
PiAgIDIyNzAKPiAgIDIyNzEgICAgICAgICAgICAgICAgYXNzZXJ0X3NwaW5fbG9ja2VkKCZvMmhi
X2xpdmVfbG9jayk7Cj4gICAgICAgICAgICAgICAgICAgICAgIF5eXl5eXl5eXl5eXl5eXl5eXgo+
IAo+IFRoaXMgY29kZSBpcyBob2xkaW5nIGEgc3BpbiBsb2NrLgo+IAo+ICAgMjI3Mgo+ICAgMjI3
MyAgICAgICAgICAgICAgICBsaXN0X2Zvcl9lYWNoX2VudHJ5KHJlZywgJm8yaGJfYWxsX3JlZ2lv
bnMsIGhyX2FsbF9pdGVtKSB7Cj4gICAyMjc0ICAgICAgICAgICAgICAgICAgICAgICAgaWYgKHJl
Zy0+aHJfaXRlbV9kcm9wcGVkKQo+ICAgMjI3NSAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgY29udGludWU7Cj4gICAyMjc2Cj4gICAyMjc3ICAgICAgICAgICAgICAgICAgICAgICAgdXVp
ZCA9IGNvbmZpZ19pdGVtX25hbWUoJnJlZy0+aHJfaXRlbSk7Cj4gICAyMjc4Cj4gICAyMjc5ICAg
ICAgICAgICAgICAgICAgICAgICAgLyogbG9jYWwgaGVhcnRiZWF0ICovCj4gICAyMjgwICAgICAg
ICAgICAgICAgICAgICAgICAgaWYgKHJlZ2lvbl91dWlkKSB7Cj4gICAyMjgxICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBpZiAoc3RyY21wKHJlZ2lvbl91dWlkLCB1dWlkKSkKPiAgIDIy
ODIgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY29udGludWU7Cj4gICAy
MjgzICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBmb3VuZCA9IDE7Cj4gICAyMjg0ICAg
ICAgICAgICAgICAgICAgICAgICAgfQo+ICAgMjI4NQo+ICAgMjI4NiAgICAgICAgICAgICAgICAg
ICAgICAgIGlmIChyZWctPmhyX2l0ZW1fcGlubmVkIHx8IHJlZy0+aHJfaXRlbV9kcm9wcGVkKQo+
ICAgMjI4NyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZ290byBza2lwX3BpbjsKPiAg
IDIyODgKPiAgIDIyODkgICAgICAgICAgICAgICAgICAgICAgICAvKiBJZ25vcmUgRU5PRU5UIG9u
bHkgZm9yIGxvY2FsIGhiICh1c2VyZGxtIGRvbWFpbikgKi8KPiAgIDIyOTAgICAgICAgICAgICAg
ICAgICAgICAgICByZXQgPSBvMm5tX2RlcGVuZF9pdGVtKCZyZWctPmhyX2l0ZW0pOwo+ICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIF5eXl5eXl5eXl5eXl5eXl4KPiBUaGUgbzJu
bV9kZXBlbmRfaXRlbSgpIGZ1Y250aW9uIGNhbm5vdCBzdWNjZWVkIHdpdGhvdXQgdGFraW5nIGEg
bXV0ZXguCj4gCj4gICAyMjkxICAgICAgICAgICAgICAgICAgICAgICAgaWYgKCFyZXQpIHsKPiAg
IDIyOTIgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIG1sb2coTUxfQ0xVU1RFUiwgIlBp
biByZWdpb24gJXNcbiIsIHV1aWQpOwo+ICAgMjI5MyAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgcmVnLT5ocl9pdGVtX3Bpbm5lZCA9IDE7Cj4gICAyMjk0ICAgICAgICAgICAgICAgICAg
ICAgICAgfSBlbHNlIHsKPiAgIDIyOTUgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGlm
IChyZXQgPT0gLUVOT0VOVCAmJiBmb3VuZCkKPiAgIDIyOTYgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgcmV0ID0gMDsKPiAgIDIyOTcgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIGVsc2Ugewo+ICAgMjI5OCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBtbG9nKE1MX0VSUk9SLCAiUGluIHJlZ2lvbiAlcyBmYWlscyB3aXRoICVkXG4iLAo+
ICAgMjI5OSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHV1aWQs
IHJldCk7Cj4gICAyMzAwICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJy
ZWFrOwo+ICAgMjMwMSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfQo+ICAgMjMwMiAg
ICAgICAgICAgICAgICAgICAgICAgIH0KPiAgIDIzMDMgICAgICAgIHNraXBfcGluOgo+ICAgMjMw
NCAgICAgICAgICAgICAgICAgICAgICAgIGlmIChmb3VuZCkKPiAgIDIzMDUgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIGJyZWFrOwo+ICAgMjMwNiAgICAgICAgICAgICAgICB9Cj4gICAy
MzA3Cj4gICAyMzA4ICAgICAgICAgICAgICAgIHJldHVybiByZXQ7Cj4gICAyMzA5ICAgICAgICB9
Cj4gCj4gcmVnYXJkcywKPiBkYW4gY2FycGVudGVyCj4gCj4gX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KPiBPY2ZzMi1kZXZlbCBtYWlsaW5nIGxpc3QKPiBP
Y2ZzMi1kZXZlbEBvc3Mub3JhY2xlLmNvbQo+IGh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1h
bi9saXN0aW5mby9vY2ZzMi1kZXZlbAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0Ck9jZnMyLWRldmVsQG9zcy5v
cmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9saXN0aW5mby9vY2ZzMi1k
ZXZlbA==
