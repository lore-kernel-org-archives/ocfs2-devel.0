Return-Path: <SRS0=D8ch=HT=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85A26C433DB
	for <ocfs2-devel@archiver.kernel.org>; Wed, 17 Feb 2021 03:07:44 +0000 (UTC)
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0137A64DE1
	for <ocfs2-devel@archiver.kernel.org>; Wed, 17 Feb 2021 03:07:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0137A64DE1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
	by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11H34Cl3156060;
	Wed, 17 Feb 2021 03:07:42 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by userp2120.oracle.com with ESMTP id 36p7dngu1w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Feb 2021 03:07:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11H363J5104898;
	Wed, 17 Feb 2021 03:07:42 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 36prpxkhke-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 17 Feb 2021 03:07:41 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lCDBk-00087G-CA; Tue, 16 Feb 2021 19:07:40 -0800
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ruansy.fnst@cn.fujitsu.com>) id 1lCDBL-000800-GA
	for ocfs2-devel@oss.oracle.com; Tue, 16 Feb 2021 19:07:15 -0800
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11H35ZGD032949
	for <ocfs2-devel@oss.oracle.com>; Wed, 17 Feb 2021 03:07:14 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by userp3020.oracle.com with ESMTP id 36prhsayt9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 17 Feb 2021 03:07:14 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11H34JYl036928
	for <ocfs2-devel@oss.oracle.com>; Wed, 17 Feb 2021 03:07:14 GMT
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by userp2040.oracle.com with ESMTP id 36qrn13hw2-1
	for <ocfs2-devel@oss.oracle.com>; Wed, 17 Feb 2021 03:07:14 +0000
X-IronPort-AV: E=Sophos;i="5.81,184,1610380800"; d="scan'208";a="104561806"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
	by heian.cn.fujitsu.com with ESMTP; 17 Feb 2021 11:07:08 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
	by cn.fujitsu.com (Postfix) with ESMTP id 8C4954CE6F9B;
	Wed, 17 Feb 2021 11:07:02 +0800 (CST)
Received: from irides.mr (10.167.225.141) by G08CNEXMBPEKD05.g08.fujitsu.local
	(10.167.33.204) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Wed, 17 Feb 2021 11:06:55 +0800
To: <dsterba@suse.cz>, <linux-kernel@vger.kernel.org>,
        <linux-xfs@vger.kernel.org>, <linux-nvdimm@lists.01.org>,
        <linux-fsdevel@vger.kernel.org>, <darrick.wong@oracle.com>,
        <dan.j.williams@intel.com>, <willy@infradead.org>, <jack@suse.cz>,
        <viro@zeniv.linux.org.uk>, <linux-btrfs@vger.kernel.org>,
        <ocfs2-devel@oss.oracle.com>, <david@fromorbit.com>, <hch@lst.de>,
        <rgoldwyn@suse.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>
References: <20210207170924.2933035-1-ruansy.fnst@cn.fujitsu.com>
	<20210207170924.2933035-5-ruansy.fnst@cn.fujitsu.com>
	<20210216131154.GN1993@twin.jikos.cz>
From: Ruan Shiyang <ruansy.fnst@cn.fujitsu.com>
Message-ID: <4e9a79ed-aa99-c57b-6098-f55ef28cc535@cn.fujitsu.com>
Date: Wed, 17 Feb 2021 11:06:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210216131154.GN1993@twin.jikos.cz>
Content-Language: en-US
X-Originating-IP: [10.167.225.141]
X-ClientProxiedBy: G08CNEXCHPEKD04.g08.fujitsu.local (10.167.33.200) To
	G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204)
X-yoursite-MailScanner-ID: 8C4954CE6F9B.AD540
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@cn.fujitsu.com
X-PDR: PASS
X-Source-IP: 183.91.158.132
X-ServerName: mail.cn.fujitsu.com
X-Proofpoint-SPF-Result: None
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9897
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=999
	spamscore=0 mlxscore=0
	suspectscore=0 adultscore=0 bulkscore=0 clxscore=158 priorityscore=0
	impostorscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2102170018
X-Spam: Clean
X-MIME-Autoconverted: from 8bit to quoted-printable by userp3020.oracle.com id
	11H35ZGD032949
Subject: Re: [Ocfs2-devel] [PATCH 4/7] fsdax: Replace mmap entry in case of
	CoW
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.9
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9897 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170018
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9897 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 adultscore=0 clxscore=1034 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102170018

CgpPbiAyMDIxLzIvMTYg5LiL5Y2IOToxMSwgRGF2aWQgU3RlcmJhIHdyb3RlOgo+IE9uIE1vbiwg
RmViIDA4LCAyMDIxIGF0IDAxOjA5OjIxQU0gKzA4MDAsIFNoaXlhbmcgUnVhbiB3cm90ZToKPj4g
V2UgcmVwbGFjZSB0aGUgZXhpc3RpbmcgZW50cnkgdG8gdGhlIG5ld2x5IGFsbG9jYXRlZCBvbmUK
Pj4gaW4gY2FzZSBvZiBDb1cuIEFsc28sIHdlIG1hcmsgdGhlIGVudHJ5IGFzIFBBR0VDQUNIRV9U
QUdfVE9XUklURQo+PiBzbyB3cml0ZWJhY2sgbWFya3MgdGhpcyBlbnRyeSBhcyB3cml0ZXByb3Rl
Y3RlZC4gVGhpcwo+PiBoZWxwcyB1cyBzbmFwc2hvdHMgc28gbmV3IHdyaXRlIHBhZ2VmYXVsdHMg
YWZ0ZXIgc25hcHNob3RzCj4+IHRyaWdnZXIgYSBDb1cuCj4+Cj4+IFNpZ25lZC1vZmYtYnk6IEdv
bGR3eW4gUm9kcmlndWVzIDxyZ29sZHd5bkBzdXNlLmNvbT4KPj4gU2lnbmVkLW9mZi1ieTogU2hp
eWFuZyBSdWFuIDxydWFuc3kuZm5zdEBjbi5mdWppdHN1LmNvbT4KPj4gLS0tCj4+ICAgZnMvZGF4
LmMgfCAzMSArKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tCj4+ICAgMSBmaWxlIGNoYW5n
ZWQsIDIzIGluc2VydGlvbnMoKyksIDggZGVsZXRpb25zKC0pCj4+Cj4+IGRpZmYgLS1naXQgYS9m
cy9kYXguYyBiL2ZzL2RheC5jCj4+IGluZGV4IGIyMTk1Y2JkZjJkYy4uMjk2OThhM2QyZTM3IDEw
MDY0NAo+PiAtLS0gYS9mcy9kYXguYwo+PiArKysgYi9mcy9kYXguYwo+PiBAQCAtNzIyLDYgKzcy
Miw5IEBAIHN0YXRpYyBpbnQgY29weV9jb3dfcGFnZV9kYXgoc3RydWN0IGJsb2NrX2RldmljZSAq
YmRldiwgc3RydWN0IGRheF9kZXZpY2UgKmRheF9kCj4+ICAgCXJldHVybiAwOwo+PiAgIH0KPj4g
ICAKPj4gKyNkZWZpbmUgREFYX0lGX0RJUlRZCQkoMVVMTCA8PCAwKQo+PiArI2RlZmluZSBEQVhf
SUZfQ09XCQkoMVVMTCA8PCAxKQo+IAo+IFRoZSBjb25zdGFudHMgYXJlIFVMTCwgYnV0IEkgc2Vl
IG90aGVyIGZsYWdzIG9ubHkgJ3Vuc2lnbmVkIGxvbmcnCj4gCj4+ICsKPj4gICAvKgo+PiAgICAq
IEJ5IHRoaXMgcG9pbnQgZ3JhYl9tYXBwaW5nX2VudHJ5KCkgaGFzIGVuc3VyZWQgdGhhdCB3ZSBo
YXZlIGEgbG9ja2VkIGVudHJ5Cj4+ICAgICogb2YgdGhlIGFwcHJvcHJpYXRlIHNpemUgc28gd2Ug
ZG9uJ3QgaGF2ZSB0byB3b3JyeSBhYm91dCBkb3duZ3JhZGluZyBQTURzIHRvCj4+IEBAIC03MzEs
MTQgKzczNCwxNiBAQCBzdGF0aWMgaW50IGNvcHlfY293X3BhZ2VfZGF4KHN0cnVjdCBibG9ja19k
ZXZpY2UgKmJkZXYsIHN0cnVjdCBkYXhfZGV2aWNlICpkYXhfZAo+PiAgICAqLwo+PiAgIHN0YXRp
YyB2b2lkICpkYXhfaW5zZXJ0X2VudHJ5KHN0cnVjdCB4YV9zdGF0ZSAqeGFzLAo+PiAgIAkJc3Ry
dWN0IGFkZHJlc3Nfc3BhY2UgKm1hcHBpbmcsIHN0cnVjdCB2bV9mYXVsdCAqdm1mLAo+PiAtCQl2
b2lkICplbnRyeSwgcGZuX3QgcGZuLCB1bnNpZ25lZCBsb25nIGZsYWdzLCBib29sIGRpcnR5KQo+
PiArCQl2b2lkICplbnRyeSwgcGZuX3QgcGZuLCB1bnNpZ25lZCBsb25nIGZsYWdzLCBib29sIGlu
c2VydF9mbGFncykKPiAKPiBpbnNlcnRfZmxhZ3MgaXMgYm9vbAo+IAo+PiAgIHsKPj4gICAJdm9p
ZCAqbmV3X2VudHJ5ID0gZGF4X21ha2VfZW50cnkocGZuLCBmbGFncyk7Cj4+ICsJYm9vbCBkaXJ0
eSA9IGluc2VydF9mbGFncyAmIERBWF9JRl9ESVJUWTsKPiAKPiAiaW5zZXJ0X2ZsYWdzICYgREFY
X0lGX0RJUlRZIiBpcyAiYm9vbCAmIFVMTCIsIHRoaXMgY2FuJ3QgYmUgcmlnaHQKClRoaXMgaXMg
YSBtaXN0YWtlIGNhdXNlZCBieSByZWJhc2luZyBteSBvbGQgdmVyc2lvbiBwYXRjaHNldC4gIFRo
YW5rcyAKZm9yIHBvaW50aW5nIG91dC4gIEknbGwgZml4IHRoaXMgaW4gbmV4dCB2ZXJzaW9uLgo+
IAo+PiArCWJvb2wgY293ID0gaW5zZXJ0X2ZsYWdzICYgREFYX0lGX0NPVzsKPiAKPiBTYW1lCj4g
Cj4+ICAgCj4+ICAgCWlmIChkaXJ0eSkKPj4gICAJCV9fbWFya19pbm9kZV9kaXJ0eShtYXBwaW5n
LT5ob3N0LCBJX0RJUlRZX1BBR0VTKTsKPj4gICAKPj4gLQlpZiAoZGF4X2lzX3plcm9fZW50cnko
ZW50cnkpICYmICEoZmxhZ3MgJiBEQVhfWkVST19QQUdFKSkgewo+PiArCWlmIChjb3cgfHwgKGRh
eF9pc196ZXJvX2VudHJ5KGVudHJ5KSAmJiAhKGZsYWdzICYgREFYX1pFUk9fUEFHRSkpKSB7Cj4+
ICAgCQl1bnNpZ25lZCBsb25nIGluZGV4ID0geGFzLT54YV9pbmRleDsKPj4gICAJCS8qIHdlIGFy
ZSByZXBsYWNpbmcgYSB6ZXJvIHBhZ2Ugd2l0aCBibG9jayBtYXBwaW5nICovCj4+ICAgCQlpZiAo
ZGF4X2lzX3BtZF9lbnRyeShlbnRyeSkpCj4+IEBAIC03NTAsNyArNzU1LDcgQEAgc3RhdGljIHZv
aWQgKmRheF9pbnNlcnRfZW50cnkoc3RydWN0IHhhX3N0YXRlICp4YXMsCj4+ICAgCj4+ICAgCXhh
c19yZXNldCh4YXMpOwo+PiAgIAl4YXNfbG9ja19pcnEoeGFzKTsKPj4gLQlpZiAoZGF4X2lzX3pl
cm9fZW50cnkoZW50cnkpIHx8IGRheF9pc19lbXB0eV9lbnRyeShlbnRyeSkpIHsKPj4gKwlpZiAo
Y293IHx8IGRheF9pc196ZXJvX2VudHJ5KGVudHJ5KSB8fCBkYXhfaXNfZW1wdHlfZW50cnkoZW50
cnkpKSB7Cj4+ICAgCQl2b2lkICpvbGQ7Cj4+ICAgCj4+ICAgCQlkYXhfZGlzYXNzb2NpYXRlX2Vu
dHJ5KGVudHJ5LCBtYXBwaW5nLCBmYWxzZSk7Cj4+IEBAIC03NzQsNiArNzc5LDkgQEAgc3RhdGlj
IHZvaWQgKmRheF9pbnNlcnRfZW50cnkoc3RydWN0IHhhX3N0YXRlICp4YXMsCj4+ICAgCWlmIChk
aXJ0eSkKPj4gICAJCXhhc19zZXRfbWFyayh4YXMsIFBBR0VDQUNIRV9UQUdfRElSVFkpOwo+PiAg
IAo+PiArCWlmIChjb3cpCj4+ICsJCXhhc19zZXRfbWFyayh4YXMsIFBBR0VDQUNIRV9UQUdfVE9X
UklURSk7Cj4+ICsKPj4gICAJeGFzX3VubG9ja19pcnEoeGFzKTsKPj4gICAJcmV0dXJuIGVudHJ5
Owo+PiAgIH0KPj4gQEAgLTEzMTksNiArMTMyNyw3IEBAIHN0YXRpYyB2bV9mYXVsdF90IGRheF9p
b21hcF9wdGVfZmF1bHQoc3RydWN0IHZtX2ZhdWx0ICp2bWYsIHBmbl90ICpwZm5wLAo+PiAgIAl2
b2lkICplbnRyeTsKPj4gICAJcGZuX3QgcGZuOwo+PiAgIAl2b2lkICprYWRkcjsKPj4gKwl1bnNp
Z25lZCBsb25nIGluc2VydF9mbGFncyA9IDA7Cj4+ICAgCj4+ICAgCXRyYWNlX2RheF9wdGVfZmF1
bHQoaW5vZGUsIHZtZiwgcmV0KTsKPj4gICAJLyoKPj4gQEAgLTE0NDQsOCArMTQ1MywxMCBAQCBz
dGF0aWMgdm1fZmF1bHRfdCBkYXhfaW9tYXBfcHRlX2ZhdWx0KHN0cnVjdCB2bV9mYXVsdCAqdm1m
LCBwZm5fdCAqcGZucCwKPj4gICAKPj4gICAJCWdvdG8gZmluaXNoX2lvbWFwOwo+PiAgIAljYXNl
IElPTUFQX1VOV1JJVFRFTjoKPj4gLQkJaWYgKHdyaXRlICYmIGlvbWFwLmZsYWdzICYgSU9NQVBf
Rl9TSEFSRUQpCj4+ICsJCWlmICh3cml0ZSAmJiAoaW9tYXAuZmxhZ3MgJiBJT01BUF9GX1NIQVJF
RCkpIHsKPj4gKwkJCWluc2VydF9mbGFncyB8PSBEQVhfSUZfQ09XOwo+IAo+IEhlcmUncyBhbiBl
eGFtcGxlIG9mICd1bnNpZ25lZCBsb25nID0gdW5zaWduZWQgbG9uZyBsb25nJywgdGhvdWdoIGl0
J2xsCj4gd29yaywgaXQgd291bGQgYmUgYmV0dGVyIHRvIHVuaWZ5IGFsbCB0aGUgdHlwZXMuCgpZ
ZXMsIEknbGwgZml4IGl0LgoKCi0tClRoYW5rcywKUnVhbiBTaGl5YW5nLgo+IAo+PiAgIAkJCWdv
dG8gY293Owo+PiArCQl9Cj4+ICAgCQlmYWxsdGhyb3VnaDsKPj4gICAJY2FzZSBJT01BUF9IT0xF
Ogo+PiAgIAkJaWYgKCF3cml0ZSkgewo+PiBAQCAtMTU1NSw2ICsxNTY2LDcgQEAgc3RhdGljIHZt
X2ZhdWx0X3QgZGF4X2lvbWFwX3BtZF9mYXVsdChzdHJ1Y3Qgdm1fZmF1bHQgKnZtZiwgcGZuX3Qg
KnBmbnAsCj4+ICAgCWludCBlcnJvcjsKPj4gICAJcGZuX3QgcGZuOwo+PiAgIAl2b2lkICprYWRk
cjsKPj4gKwl1bnNpZ25lZCBsb25nIGluc2VydF9mbGFncyA9IDA7Cj4+ICAgCj4+ICAgCS8qCj4+
ICAgCSAqIENoZWNrIHdoZXRoZXIgb2Zmc2V0IGlzbid0IGJleW9uZCBlbmQgb2YgZmlsZSBub3cu
IENhbGxlciBpcwo+PiBAQCAtMTY3MCwxNCArMTY4MiwxNyBAQCBzdGF0aWMgdm1fZmF1bHRfdCBk
YXhfaW9tYXBfcG1kX2ZhdWx0KHN0cnVjdCB2bV9mYXVsdCAqdm1mLCBwZm5fdCAqcGZucCwKPj4g
ICAJCXJlc3VsdCA9IHZtZl9pbnNlcnRfcGZuX3BtZCh2bWYsIHBmbiwgd3JpdGUpOwo+PiAgIAkJ
YnJlYWs7Cj4+ICAgCWNhc2UgSU9NQVBfVU5XUklUVEVOOgo+PiAtCQlpZiAod3JpdGUgJiYgaW9t
YXAuZmxhZ3MgJiBJT01BUF9GX1NIQVJFRCkKPj4gKwkJaWYgKHdyaXRlICYmIChpb21hcC5mbGFn
cyAmIElPTUFQX0ZfU0hBUkVEKSkgewo+PiArCQkJaW5zZXJ0X2ZsYWdzIHw9IERBWF9JRl9DT1c7
Cj4+ICAgCQkJZ290byBjb3c7Cj4+ICsJCX0KPj4gICAJCWZhbGx0aHJvdWdoOwo+PiAgIAljYXNl
IElPTUFQX0hPTEU6Cj4+IC0JCWlmIChXQVJOX09OX09OQ0Uod3JpdGUpKQo+PiArCQlpZiAoIXdy
aXRlKSB7Cj4+ICsJCQlyZXN1bHQgPSBkYXhfcG1kX2xvYWRfaG9sZSgmeGFzLCB2bWYsICZpb21h
cCwgJmVudHJ5KTsKPj4gICAJCQlicmVhazsKPj4gLQkJcmVzdWx0ID0gZGF4X3BtZF9sb2FkX2hv
bGUoJnhhcywgdm1mLCAmaW9tYXAsICZlbnRyeSk7Cj4+IC0JCWJyZWFrOwo+PiArCQl9Cj4+ICsJ
CWZhbGx0aHJvdWdoOwo+PiAgIAlkZWZhdWx0Ogo+PiAgIAkJV0FSTl9PTl9PTkNFKDEpOwo+PiAg
IAkJYnJlYWs7Cj4+IC0tIAo+PiAyLjMwLjAKPj4KPj4KPiAKPiAKCgoKX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0
Ck9jZnMyLWRldmVsQG9zcy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1h
bi9saXN0aW5mby9vY2ZzMi1kZXZlbA==
