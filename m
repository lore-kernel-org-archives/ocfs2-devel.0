Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A18AAC433EF
	for <ocfs2-devel@archiver.kernel.org>; Tue, 19 Jul 2022 14:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=FWRdOuK5qnqfIJgCKF2o2jRy3GKIXES9AjHdnx8crro=;
 b=ksr32bCQdm0Ow1u6oc2mJSzQ499jLqfp71lrW8Zko1bFG00wNkL2UkiZ+exwdD3Wv020pzsbkNoI
   bhKXgT8ceNh5pb3+3KKFN0mtqGCYgRd1FbFVjv6YWDqw32ZlvI264WpOwt7LkDzwgXycreTKc5uI
   kv/anVx6xCAZhI2K0cO2TWruKzxicTKsekI3jDtp8xSgwin5itjASREUa9RYumTmA5qk7tvF4+Ri
   tgzpvDhw+Ys64+6LQ+ifR4jMhntI4r61gMpZFtRBncsMIIGcOJJpByUnKT2Oz36QzWJs42ID38uP
   Xn1o0fer5JBxHbdd35ao6lhU+qVc9FMYXpiShw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=FWRdOuK5qnqfIJgCKF2o2jRy3GKIXES9AjHdnx8crro=;
 b=VYe74GK+s7S9xxcc4atz61z5TO3ULM/UAZ8yfZKHSbu9RySmNhPEdIyN+WnSRKjDyMRtO0WEaXFj
   bDpHJNcuPgBvhpFLSor4yVOFJJtfYR6+b7AduqdQXavYdahbmEKVupNMUenb2j36bBh8b7tJ8jTc
   +HcSZxXNMIqD8JywPWk+A+BMMOStWWE43nwZcCM4SdGUkqEiusjtnacCsMyQ0eZ/+x+N+7I/+/uQ
   CqjotsDFgKpr7y5XE7XwgqdfApYBYp8YiJeSjos6jL/92pfsk66lHonvJ6nhaYgH9UZn5Bw+47je
   byHVZGvKlFAi3EaTMQKUf/lgNGMgV4+hG0zZhw==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220603 64bit (built Jun  3
 2022))
 with ESMTPS id <0RF9003ZOUGK3Y70@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 19 Jul 2022 14:19:33 +0000 (GMT)
To: 'Christophe JAILLET' <christophe.jaillet@wanadoo.fr>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>
Thread-topic: [PATCH 2/3] ocfs2: Remove a useless spinlock
Thread-index: AQHYm1a23J7AKlhcsUK1MlCgSmBBPK2Fe4YggAAi+oCAAB+pQA==
Date: Tue, 19 Jul 2022 14:19:08 +0000
Message-id: <fe6c86050b3447758c09e1881582405f@AcuMS.aculab.com>
References:
 <bd6796635e58f9c47cf857573c3b9474a00ce26a.1658224839.git.christophe.jaillet@wanadoo.fr>
 <8ba7004d330cbe5f626539a8a3bff696d0c4285e.1658224839.git.christophe.jaillet@wanadoo.fr>
 <7b644e5d32d74d3d90dfc5b1786ae5b9@AcuMS.aculab.com>
 <29c3fbdd-7695-46c5-bb75-fe358c574ab3@wanadoo.fr>
In-reply-to: <29c3fbdd-7695-46c5-bb75-fe358c574ab3@wanadoo.fr>
Accept-Language: en-GB, en-US
X-MS-Has-Attach:
X-Originating-IP: [10.202.205.107]
MIME-version: 1.0
Authentication-results: relay.mimecast.com; auth=pass smtp.auth=C51A453
 smtp.mailfrom=david.laight@aculab.com
Content-language: en-US
X-Source-IP: 185.58.86.151
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10413
 signatures=596000
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 bulkscore=0 adultscore=0 clxscore=102 priorityscore=115 mlxscore=0
 suspectscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=904 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207190060
Cc: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
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
From: David Laight via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: David Laight <David.Laight@ACULAB.COM>
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: base64
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MC-Unique: waRYl-RDNsiysdWy-ANi1Q-1
X-MS-TNEF-Correlator:
x-ms-exchange-transport-fromentityheader: Hosted
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
X-ServerName: eu-smtp-delivery-151.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:eu._netblocks.mimecast.com
 include:servers.mcsv.net include:_spf.act-on.net include:aculabcloud.net -all
X-Spam: Clean
X-Proofpoint-GUID: 9HqFaXWSwmmumEWTpDvEsZshvXiNRB7y
X-Proofpoint-ORIG-GUID: 9HqFaXWSwmmumEWTpDvEsZshvXiNRB7y
Reporting-Meta:
 AAFOU6DAWByH4yiASr6h9/Nq+AQXMsuGe7H+PQ4WLpCUZ9yTHZxERORf5pu9m9mL
 24mmwqfGDK2EbnevwxEukSIclXcSjydlB/kFIQ9yJpaAuMX4P7ptbM+0SD5yxBVt
 PMMeqyjPFlVF+sUOccWFHtppHV6Dc1aLsA65ppct+q6D0IO/Nvf2rqYyXqS5mMAN
 vjvxiD+kKjmj7lH0kCfEolQ9c0Ka9Uf/Tn9Y+eT9YFULP5cSvccyA6nXoren/qzI
 Bl7c4apr8doRG73XhOqSzKGsU6ASkC3HghXGYSmor3GAHuQ98qCKFcAZozjX+TLT
 UHZsLs2rZbTBuB/YmPWQ7qv7B5xwUOVgpJ1YLhy7qjlAdfIHNQeZz8QW7+pg4Fpj
 bU4mxM51RtNwP6PoOMTqA6liVMCUfJ/WC8WnU3WLQgeMRYk1xHxsiyoHTRSTiHpb
 cAAhvbk2e3e/mbMbN0a483+rfRvkC0IPshOPbb/A0nmIZmwB6svLaUwMhOpTvQCw
 F4VqLCBNYj6KnYo0z0gIvJNvPRjN4p1uMF8n/jFuC6dS

RnJvbTogQ2hyaXN0b3BoZSBKQUlMTEVUDQo+IFNlbnQ6IDE5IEp1bHkgMjAyMiAxNDoyNQ0KPiAN
Cj4gTGUgMTkvMDcvMjAyMiDDoCAxMjoyNCwgRGF2aWQgTGFpZ2h0IGEgw6ljcml0wqA6DQo+ID4g
RnJvbTogQ2hyaXN0b3BoZSBKQUlMTEVUDQo+ID4+IFNlbnQ6IDE5IEp1bHkgMjAyMiAxMTowMg0K
PiA+Pg0KPiA+PiAnbm9kZV9tYXBfbG9jaycgaXMgYSBzcGlubG9jayBvbmx5IHVzZWQgdG8gcHJv
dGVjdCBjYWxscyB0byBzZXRfYml0KCksDQo+ID4+IGNsZWFyX2JpdCgpIGFuZCB0ZXN0X2JpdCgp
Lg0KPiA+Pg0KPiA+PiB7c2V0fGNsZWFyfV9iaXQoKSBhcmUgYWxyZWFkeSBhdG9taWMgYW5kIGRv
bid0IG5lZWQgdGhpcyBleHRyYSBzcGlubG9jay4NCj4gPj4gdGVzdF9iaXQoKSBvbmx5IHJlYWRz
IHRoZSBiaXRtYXAgZm9yIGEgZ2l2ZW4gYml0Lg0KPiA+Pg0KPiA+PiBSZW1vdmUgdGhpcyB1c2Vs
ZXNzIHNwaW5sb2NrLg0KPiA+DQo+ID4gSXQgbG9va3MgdG8gbWUgbGlrZSB0aGUgY2FsbGluZyBj
b2RlIGlzIHJhY3kNCj4gPiB1bmxlc3MgdGhlcmUgaXMgYW5vdGhlciBsb2NrIGluIHRoZSBjYWxs
ZXJzLg0KPiANCj4gVGhlIGNhbGwgY2hhaW5zIGFyZToNCj4gICAgb2NmczJfcmVjb3Zlcl9vcnBo
YW5zKCkNCj4gICAgICBvY2ZzMl9tYXJrX3JlY292ZXJpbmdfb3JwaGFuX2RpcigpDQo+ICAgICAg
ICBzcGluX2xvY2soJm9zYi0+b3NiX2xvY2spOwkJPC0tIG9zYl9sb2NrIHNwaW5sb2NrDQo+ICAg
ICAgICBvY2ZzMl9ub2RlX21hcF9zZXRfYml0KCkJCQk8LS0gdXNlcyBub2RlX21hcF9sb2NrDQo+
ICAgICAgICAuLi4NCj4gICAgICAgIHNwaW5fdW5sb2NrKCZvc2ItPm9zYl9sb2NrKTsNCj4gICAg
ICAuLi4NCj4gICAgICBvY2ZzMl9jbGVhcl9yZWNvdmVyaW5nX29ycGhhbl9kaXIoKQ0KPiAgICAg
ICAgb2NmczJfbm9kZV9tYXBfY2xlYXJfYml0KCkJCTwtLSB1c2VzIG5vZGVfbWFwX2xvY2sNCj4g
CQkJCQkJICAgIG9zYl9sb2NrIGlzIE5PVCB0YWtlbg0KPiANCj4gDQo+ICAgIG9jZnMyX2NoZWNr
X29ycGhhbl9yZWNvdmVyeV9zdGF0ZSgpDQo+ICAgICAgc3Bpbl9sb2NrKCZvc2ItPm9zYl9sb2Nr
KTsJCQk8LS0gb3NiX2xvY2sgc3BpbmxvY2sNCj4gICAgICAuLi4NCj4gICAgICBvY2ZzMl9ub2Rl
X21hcF90ZXN0X2JpdCgpCQkJPC0tIHVzZXMgbm9kZV9tYXBfbG9jaw0KPiAgICAgIC4uLg0KPiAg
ICAgIHNwaW5fdW5sb2NrKCZvc2ItPm9zYl9sb2NrKTsNCj4gDQo+IA0KPiBTbyB0aGUgY29kZSBs
b29rcyBhbHJlYWR5IHByb3RlY3RlZCBieSB0aGUgJ29zYl9sb2NrJyBzcGlubG9jaywgYnV0IEkN
Cj4gZG9uJ3Qga25vdyB0aGlzIGNvZGUgYW5kIG9jZnMyX21hcmtfcmVjb3ZlcmluZ19vcnBoYW5f
ZGlyKCkgbG9va3MgdHJpY2t5DQo+IHRvIG1lLiAoc28gc29tZSBvdGhlciBleWVzIGFyZSBtdWNo
IHdlbGNvbWUpDQo+IA0KPiA+IFdoaWxlIG1hcC0+bWFwIGlzIHByb3RlY3RlZCwgdGhlIHJlc3Vs
dCBvZiB0ZXN0X2JpdCgpDQo+ID4gaXMgc3RhbGUgLSBzbyBjYW4ndCBiZSB1c2VkIGZvciBtdWNo
Lg0KPiA+DQo+IA0KPiBBbnl3YXksIHNob3VsZCB0aGVyZSBiZSBhIGxvY2tpbmcgaXNzdWUsIGl0
IGlzIHRoZXJlIHdpdGggb3Igd2l0aG91dCBteQ0KPiBwYXRjaCwgcmlnaHQ/DQoNCkluZGVlZC4N
Cg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2Fk
LCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5v
OiAxMzk3Mzg2IChXYWxlcykNCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fCk9jZnMyLWRldmVsIG1haWxpbmcgbGlzdApPY2ZzMi1kZXZlbEBvc3Mub3JhY2xl
LmNvbQpodHRwczovL29zcy5vcmFjbGUuY29tL21haWxtYW4vbGlzdGluZm8vb2NmczItZGV2ZWw=
