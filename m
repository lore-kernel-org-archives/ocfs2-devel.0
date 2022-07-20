Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E387C43334
	for <ocfs2-devel@archiver.kernel.org>; Wed, 20 Jul 2022 09:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=qH2/onaWEJlEDUsBg/cRgXv4uT4dh2/PdpSs+tZzJs4=;
 b=Gp7KF55AeF4HOQ7ystvJSClb6n5OtV8PAJ9ArB9xozDWdSEY9SiuC6rT9QTzoKDkM++dB+NmiJ/O
   EpGacCEWb87PgnXURGxPB7jQNXAePRcAXK1zOZ2oXcaDb00OTJ2zgpY+QWDGLDo0YmslKPbd8LzR
   Bx5iAT+aTecd2omCNY6nYViODUeLiKUYqwyW9yS3mtydm8tZ5/Jir+eWA6aFf8cxaAVmQBHbcsNf
   o7Y+YwneYTdh1TdOO8JpAYXG8fRixeJHOxM648Vw2iDKiifsZwIR+Gb0VkxjwkmxlsrhCs+QEJdf
   XypGEOle4GtMn4KKjW8HvSf/t8PIswHEUOF31A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=qH2/onaWEJlEDUsBg/cRgXv4uT4dh2/PdpSs+tZzJs4=;
 b=kOq7h3HWlrg9ZhQgjSbPVFHquIHy39yeM3ABE5Q6JxKVLXhLtOMx3KL4kJxwzpDby+qBC/7g+u2S
   mypjQ1IOk1+f2OzkzBSfJvypFG9hAX231BthohxN9px+X6OZgSTgDrw3heqgoSiZQ4JX3i3XdoNp
   waDzGhwvmD3VBcNLBdV2CL1yMDgJczxdC31oGsnoCPPY8QGOzAgXweG49ftLZ2kk6djakagL9B7j
   q3djR+8+9A49gS8CqpCujBrAaX04wRL9APEjiX9+44YsBxs640kNTqMMOt9ZnvFF0DLa9hqwcE+v
   EgTY77FJsj/8tveTLK4vhQbnFD8K3lfOQiqMVA==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220621 64bit (built Jun 21
 2022))
 with ESMTPS id <0RFB006UOCM1ENA0@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 20 Jul 2022 09:49:13 +0000 (GMT)
Message-id: <65e6bbcb-2c33-2e43-1826-a62387572310@linux.alibaba.com>
Date: Wed, 20 Jul 2022 17:48:55 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Content-language: en-US
To: Marion & Christophe JAILLET <christophe.jaillet@wanadoo.fr>
References:
 <bd6796635e58f9c47cf857573c3b9474a00ce26a.1658224839.git.christophe.jaillet@wanadoo.fr>
 <8ba7004d330cbe5f626539a8a3bff696d0c4285e.1658224839.git.christophe.jaillet@wanadoo.fr>
 <7b644e5d32d74d3d90dfc5b1786ae5b9@AcuMS.aculab.com>
 <29c3fbdd-7695-46c5-bb75-fe358c574ab3@wanadoo.fr>
 <07c924de-78bf-c993-ce73-635af71f4edd@linux.alibaba.com>
 <f313cb6f-de75-2447-eebc-5c240bc243a2@wanadoo.fr>
In-reply-to: <f313cb6f-de75-2447-eebc-5c240bc243a2@wanadoo.fr>
X-Source-IP: 115.124.30.130
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10413
 signatures=596000
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 clxscore=129 phishscore=0 mlxlogscore=999 priorityscore=115 impostorscore=0
 bulkscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207200040 domainage_hfrom=8497
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R461e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046050;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
 TI=SMTPD_---0VJwWVRl_1658310535;
X-ServerName: out30-130.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: o7gPtXyYhD2a2Rp_EtUKPKmBC9PSzYkg
X-Proofpoint-ORIG-GUID: o7gPtXyYhD2a2Rp_EtUKPKmBC9PSzYkg
Reporting-Meta:
 AAFFAiCXpSmCzOb3P3Z7amBSZ4SZNWA9ZMv5MFbBPW6WoofoT76D/wdnzhTpSeRv
 OUBrDFEOexaA550OxUN+e9MHGMJjxVLg6u3hGj9nkc7PcauCOSDLKNscRcJLg9fr
 unwqQasgv9xLHRiW4LvQzvO9WTn+HUe19JQgvVQW0tsrIx4LpDBE26elxXYXx8eD
 ZJcTeOeoqSZ+IS6w0vTP1+PRJrIOPCN/rk83tLGqk2Ac7Ii7AzmcWv5iqDg8l6og
 xbFre/VWf04fYaNl/P74+lwKG4kZo7Flr/J/E2utX4WsfzXOYH4AYlxMjNvcMFY1
 S8DXSfdCAbFkF4RWapdFXQGLJgQSKJ+NlXaeToZdZVmRmgw9IwLMim7O/6qC+ONH
 IY8T+U3JdMOyUZ3Z13F9QLj1die/IWGblY+xLusAXrMJK4+PPFrkMdonPts403GA
 THHdx8Q8pAwqYIYwn+Zgnrzopv7EJXlmYPWJWBRPEDdnP68/t0XvrL7P1Bh/QQ5c
 NpFYEDySXZvnGpPgSTf+Ca9x05vYHsdto8nrMZ35YAU=

CgpPbiA3LzIwLzIyIDQ6MjYgUE0sIE1hcmlvbiAmIENocmlzdG9waGUgSkFJTExFVCB3cm90ZToK
PiAKPiBMZSAyMC8wNy8yMDIyIMOgIDAzOjU5LCBKb3NlcGggUWkgYSDDqWNyaXTCoDoKPj4KPj4g
T24gNy8xOS8yMiA5OjI1IFBNLCBDaHJpc3RvcGhlIEpBSUxMRVQgd3JvdGU6Cj4+PiBMZSAxOS8w
Ny8yMDIyIMOgIDEyOjI0LCBEYXZpZCBMYWlnaHQgYSDDqWNyaXTCoDoKPj4+PiBGcm9tOiBDaHJp
c3RvcGhlIEpBSUxMRVQKPj4+Pj4gU2VudDogMTkgSnVseSAyMDIyIDExOjAyCj4+Pj4+Cj4+Pj4+
ICdub2RlX21hcF9sb2NrJyBpcyBhIHNwaW5sb2NrIG9ubHkgdXNlZCB0byBwcm90ZWN0IGNhbGxz
IHRvIHNldF9iaXQoKSwKPj4+Pj4gY2xlYXJfYml0KCkgYW5kIHRlc3RfYml0KCkuCj4+Pj4+Cj4+
Pj4+IHtzZXR8Y2xlYXJ9X2JpdCgpIGFyZSBhbHJlYWR5IGF0b21pYyBhbmQgZG9uJ3QgbmVlZCB0
aGlzIGV4dHJhIHNwaW5sb2NrLgo+Pj4+PiB0ZXN0X2JpdCgpIG9ubHkgcmVhZHMgdGhlIGJpdG1h
cCBmb3IgYSBnaXZlbiBiaXQuCj4+Pj4+Cj4+Pj4+IFJlbW92ZSB0aGlzIHVzZWxlc3Mgc3Bpbmxv
Y2suCj4+Pj4gSXQgbG9va3MgdG8gbWUgbGlrZSB0aGUgY2FsbGluZyBjb2RlIGlzIHJhY3kKPj4+
PiB1bmxlc3MgdGhlcmUgaXMgYW5vdGhlciBsb2NrIGluIHRoZSBjYWxsZXJzLgo+Pj4gVGhlIGNh
bGwgY2hhaW5zIGFyZToKPj4+IMKgwqAgb2NmczJfcmVjb3Zlcl9vcnBoYW5zKCkKPj4+IMKgwqDC
oMKgIG9jZnMyX21hcmtfcmVjb3ZlcmluZ19vcnBoYW5fZGlyKCkKPj4+IMKgwqDCoMKgwqDCoCBz
cGluX2xvY2soJm9zYi0+b3NiX2xvY2spO8KgwqDCoMKgwqDCoMKgIDwtLSBvc2JfbG9jayBzcGlu
bG9jawo+Pj4gwqDCoMKgwqDCoMKgIG9jZnMyX25vZGVfbWFwX3NldF9iaXQoKcKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgPC0tIHVzZXMgbm9kZV9tYXBfbG9jawo+Pj4gwqDCoMKgwqDCoMKgIC4uLgo+
Pj4gwqDCoMKgwqDCoMKgIHNwaW5fdW5sb2NrKCZvc2ItPm9zYl9sb2NrKTsKPj4+IMKgwqDCoMKg
IC4uLgo+Pj4gwqDCoMKgwqAgb2NmczJfY2xlYXJfcmVjb3ZlcmluZ19vcnBoYW5fZGlyKCkKPj4+
IMKgwqDCoMKgwqDCoCBvY2ZzMl9ub2RlX21hcF9jbGVhcl9iaXQoKcKgwqDCoMKgwqDCoMKgIDwt
LSB1c2VzIG5vZGVfbWFwX2xvY2sKPj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIG9zYl9sb2NrIGlzIE5PVCB0YWtlbgo+Pj4KPj4+Cj4+
PiDCoMKgIG9jZnMyX2NoZWNrX29ycGhhbl9yZWNvdmVyeV9zdGF0ZSgpCj4+PiDCoMKgwqDCoCBz
cGluX2xvY2soJm9zYi0+b3NiX2xvY2spO8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgPC0tIG9zYl9s
b2NrIHNwaW5sb2NrCj4+PiDCoMKgwqDCoCAuLi4KPj4+IMKgwqDCoMKgIG9jZnMyX25vZGVfbWFw
X3Rlc3RfYml0KCnCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDwtLSB1c2VzIG5vZGVfbWFwX2xvY2sK
Pj4+IMKgwqDCoMKgIC4uLgo+Pj4gwqDCoMKgwqAgc3Bpbl91bmxvY2soJm9zYi0+b3NiX2xvY2sp
Owo+Pj4KPj4+Cj4+PiBTbyB0aGUgY29kZSBsb29rcyBhbHJlYWR5IHByb3RlY3RlZCBieSB0aGUg
J29zYl9sb2NrJyBzcGlubG9jaywgYnV0IEkgZG9uJ3Qga25vdyB0aGlzIGNvZGUgYW5kIG9jZnMy
X21hcmtfcmVjb3ZlcmluZ19vcnBoYW5fZGlyKCkgbG9va3MgdHJpY2t5IHRvIG1lLiAoc28gc29t
ZSBvdGhlciBleWVzIGFyZSBtdWNoIHdlbGNvbWUpCj4+IMKgIG9zYl9sb2NrIGlzIHRvIHByb3Rl
Y3Qgb3NiIGZpbGVkIHN1Y2ggYXMgJ29zYl9vcnBoYW5fd2lwZXMnLCB3aGlsZQo+PiBub2RlX21h
cF9sb2NrIGlzIHRvIHByb3RlY3QgdGhlIG5vZGUgbWFwICdvc2JfcmVjb3ZlcmluZ19vcnBoYW5f
ZGlycycKPj4gc3BlY2lmaWNhbGx5Lgo+IAo+IFRoYW5rcyBmb3IgdGhpcyBleHBsYW5hdGlvbi4K
PiAKPiBCdXQgZG9lcyAibm9kZV9tYXBfbG9jayIgcmVhbGx5IHByb3RlY3RzIGFueXRoaW5nPwo+
IEl0IGlzIGp1c3QgYXJvdW5kIHNvbWUgYXRvbWljIGZ1bmN0aW9uIGNhbGxzIHdoaWNoIHNob3Vs
ZG4ndCBuZWVkIGFueSwgcmlnaHQ/Cj4gCj4gdGVzdF9iaXQoKSBpcyBub3QgZG9jdW1lbnRlZCBh
cyBhdG9taWMsIGJ1dCB7Y2xlYXJ8c2V0fV9iaXQoKSBjb3VsZCBiZSBleGVjdXRlZCBqdXN0IGJl
Zm9yZSBvciBqdXN0IGFmdGVyIGl0IHdpdGggdGhlIGN1cnJlbnQgbG9ja2luZyBtZWNoYW5pc20s
IHNvIEkgZG9uJ3QgcmVhbGx5IHNlZSBob3cgaXQgd291bGQgbWFrZSBhIGRpZmZlcmVuY2UuCj4g
Cj4gSSBkb24ndCB1bmRlcnN0YW5kIHRoZSBsb2dpYyBvZiB0aGlzIGxvY2sgaGVyZS4KPiAKPiBD
YW4geW91IGVsYWJvcmF0ZT8KClRoZXNlIGNvZGUgYXJlIGludHJvZHVjZWQgbG9uZyB0aW1lIGFn
by4uLgpSZWZlciB0byBjb21taXQgYjRkZjZlZDhkYjBjICJbUEFUQ0hdIG9jZnMyOiBmaXggb3Jw
aGFuIHJlY292ZXJ5CmRlYWRsb2NrIiwgSSBndWVzcyBpdCBwbGF5cyBhIHJvbGUgJ2JhcnJpZXIn
IGFuZCBtYWtlIHN1cmUgdGVzdCBub2RlIG1hcAppcyBleGVjdXRlZCBwcmlvciB0aGFuIHNpZ25h
bCBvcnBoYW4gcmVjb3ZlcnkgdGhyZWFkLiBJbiBvdGhlciB3b3JkcywgdG8Kc2VyaWFsaXplIGV2
aWN0IGlub2RlIGFuZCBvcnBoYW4gcmVjb3ZlcnkuCgpUaGFua3MsCkpvc2VwaAoKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KT2NmczItZGV2ZWwgbWFpbGlu
ZyBsaXN0Ck9jZnMyLWRldmVsQG9zcy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20v
bWFpbG1hbi9saXN0aW5mby9vY2ZzMi1kZXZlbA==
