Return-Path: <SRS0=i0E0=OT=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84E2EC433F5
	for <ocfs2-devel@archiver.kernel.org>; Wed, 29 Sep 2021 09:13:02 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DF45860F58
	for <ocfs2-devel@archiver.kernel.org>; Wed, 29 Sep 2021 09:13:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DF45860F58
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T8HpRY017406;
	Wed, 29 Sep 2021 09:13:01 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bcg3hhr73-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Sep 2021 09:13:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18T9ASBN133866;
	Wed, 29 Sep 2021 09:12:59 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3bc3bjn39b-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 29 Sep 2021 09:12:59 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mVVe6-00086N-GH; Wed, 29 Sep 2021 02:12:58 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1mVVe5-000861-RP
	for ocfs2-devel@oss.oracle.com; Wed, 29 Sep 2021 02:12:57 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	18T9Bec3040945
	for <ocfs2-devel@oss.oracle.com>; Wed, 29 Sep 2021 09:12:57 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3020.oracle.com with ESMTP id 3bceu55c9g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 29 Sep 2021 09:12:57 +0000
Received: from pps.filterd (m0246574.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	18T8LKCw014284
	for <ocfs2-devel@oss.oracle.com>; Wed, 29 Sep 2021 09:12:56 GMT
Received: from out30-57.freemail.mail.aliyun.com
	(out30-57.freemail.mail.aliyun.com [115.124.30.57])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bc4ke6pt8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Wed, 29 Sep 2021 09:12:56 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R171e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04423;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=5; SR=0;
	TI=SMTPD_---0Uq0BRJ3_1632906770; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0Uq0BRJ3_1632906770) by smtp.aliyun-inc.com(127.0.0.1);
	Wed, 29 Sep 2021 17:12:50 +0800
To: =?UTF-8?Q?Valentin_Vidi=c4=87?= <vvidic@valentin-vidic.from.hr>
References: <20210927154459.15976-1-vvidic@valentin-vidic.from.hr>
	<00850aed-2027-a0ab-e801-c6498a5a49f8@linux.alibaba.com>
	<20210928131450.GM28341@valentin-vidic.from.hr>
	<212f878e-1bbe-347c-ba43-e4ffb9b4afbe@linux.alibaba.com>
	<20210929062434.GN28341@valentin-vidic.from.hr>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <1ab61ba3-8c9b-092c-7843-9c45b58e3987@linux.alibaba.com>
Date: Wed, 29 Sep 2021 17:12:50 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210929062434.GN28341@valentin-vidic.from.hr>
Content-Language: en-US
X-Source-IP: 115.124.30.57
X-ServerName: out30-57.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10121
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
	spamscore=0 mlxscore=0
	phishscore=0 priorityscore=180 clxscore=299 lowpriorityscore=0
	suspectscore=0 bulkscore=0 mlxlogscore=999 impostorscore=0 adultscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001
	definitions=main-2109290055 domainage_hfrom=8203
X-Spam: Clean
X-MIME-Autoconverted: from 8bit to quoted-printable by aserp3020.oracle.com id
	18T9Bec3040945
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: mount fails with buffer overflow
	in strlen
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10121 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109290055
X-Proofpoint-GUID: ZE-j6-9MTnuYjAYxJ3_V0Xe4R-XdwZb-
X-Proofpoint-ORIG-GUID: ZE-j6-9MTnuYjAYxJ3_V0Xe4R-XdwZb-

CgpPbiA5LzI5LzIxIDI6MjQgUE0sIFZhbGVudGluIFZpZGnEhyB3cm90ZToKPiBPbiBXZWQsIFNl
cCAyOSwgMjAyMSBhdCAxMDozODo1OUFNICswODAwLCBKb3NlcGggUWkgd3JvdGU6Cj4+IE9rYXks
IHlvdSBhcmUgcmlnaHQsIHN0cmxlbihzcmMpIGlzIGluZGVlZCB3cm9uZyBoZXJlLgo+Pgo+PiBC
dXQgcGxlYXNlIG5vdGUgdGhhdCBpbiBzdHJsY3B5KCk6Cj4+IHNpemVfdCByZXQgPSBzdHJsZW4o
c3JjKTsKPj4gaWYgKHNpemUpIHsKPj4gCXNpemVfdCBsZW4gPSAocmV0ID49IHNpemUpID8gc2l6
ZSAtIDEgOiByZXQ7Cj4+IAltZW1jcHkoZGVzdCwgc3JjLCBsZW4pOwo+PiAJZGVzdFtsZW5dID0g
J1wwJzsKPj4gfQo+Pgo+PiBUYWtlIGNpX3N0YWNrICJvMmNiIiBmb3IgZXhhbXBsZSwgc3RybGVu
KCJvMmNiIikgbWF5IHJldHVybiB3cm9uZyBpZiB0aGUKPj4gY29taW5nIGJ5dGUgaXMgbm90IG51
bGwsIHNheSBpdCBpcyAxMC4KPj4gVGhlIGlucHV0IHNpemUgaXMgNSwgc28gbGVuIHdpbGwgZmlu
YWxseSBiZSA0Lgo+PiBTbyBkZXN0IGlzIHN0aWxsIGNvcnJlY3QgZW5kaW5nIHdpdGggbnVsbCBi
eXRlLiBObyBvdmVyZmxvdyBoYXBwZW5zLgo+PiBTbyB0aGUgcHJvYmxlbSBoZXJlIGlzIHRoZSB3
cm9uZyByZXR1cm4gdmFsdWUsIGJ1dCBpdCBpcyBkaXNjYXJkZWQgaW4KPj4gb2NmczJfaW5pdGlh
bGl6ZV9zdXBlcigpLgo+IAo+IHN0cmxjcHkgc3RhcnRzIHdpdGggYSBjYWxsIHRvIHN0cmxlbihz
cmMpIGFuZCB0aGlzIGlzIHdoZXJlIHRoZSByZWFkIG92ZXJmbG93Cj4gaGFwcGVucy4gSWYgdGhl
IGtlcm5lbCBpcyBjb21waWxlZCB3aXRoIENPTkZJR19GT1JUSUZZX1NPVVJDRSB0aGlzIGdldHMK
PiBleGVjdXRlZCBpbnN0ZWFkIChpbmNsdWRlL2xpbnV4L2ZvcnRpZnktc3RyaW5nLmgpOgo+IAo+
IF9fRk9SVElGWV9JTkxJTkUgX19rZXJuZWxfc2l6ZV90IHN0cmxlbihjb25zdCBjaGFyICpwKQo+
IHsKPiAgICAgICAgIF9fa2VybmVsX3NpemVfdCByZXQ7Cj4gICAgICAgICBzaXplX3QgcF9zaXpl
ID0gX19idWlsdGluX29iamVjdF9zaXplKHAsIDEpOwo+IAo+ICAgICAgICAgLyogV29yayBhcm91
bmQgZ2NjIGV4Y2VzcyBzdGFjayBjb25zdW1wdGlvbiBpc3N1ZSAqLwo+ICAgICAgICAgaWYgKHBf
c2l6ZSA9PSAoc2l6ZV90KS0xIHx8Cj4gICAgICAgICAgICAgICAgIChfX2J1aWx0aW5fY29uc3Rh
bnRfcChwW3Bfc2l6ZSAtIDFdKSAmJiBwW3Bfc2l6ZSAtIDFdID09ICdcMCcpKQo+ICAgICAgICAg
ICAgICAgICByZXR1cm4gX191bmRlcmx5aW5nX3N0cmxlbihwKTsKPiAgICAgICAgIHJldCA9IHN0
cm5sZW4ocCwgcF9zaXplKTsKPiAgICAgICAgIGlmIChwX3NpemUgPD0gcmV0KQo+ICAgICAgICAg
ICAgICAgICBmb3J0aWZ5X3BhbmljKF9fZnVuY19fKTsKPiAgICAgICAgIHJldHVybiByZXQ7Cj4g
fQo+IAo+IFNvIHdoaWxlIHN0cmxjcHkgZGlkIHdvcmsgYmVmb3JlIHRoaXMgZm9ydGlmeSBjaGVj
aywgaXQgaXMgcHJvYmFibHkgbm90IHRoZQo+IGJlc3Qgb3B0aW9uIGFueW1vcmUgZHVlIHRvIHRo
ZSBtaXNzaW5nIG51bGwgdGVybWluYXRvciBpbiB0aGUgc291cmNlLgo+IApHb3QgaXQsIGl0IHJl
YWxseSB0cmlnZ2VycyBwYW5pYyBpbiBzdHJsZW4oKS4KU28gY291bGQgeW91IHBsZWFzZSB1cGRh
dGUgdGhlIGNvbW1pdCBsb2c/IEkgdGhpbmsgQ09ORklHX0ZPUlRJRllfU09VUkNFCmlzIG5lY2Vz
c2FyeSBpbmZvcm1hdGlvbiBzaW5jZSBpdCBpcyBub3QgZGVmYXVsdCBlbmFibGVkLgpBbmQgYWRk
IGNvbW1lbnRzIHdpdGggeW91ciBjaGFuZ2VzLCBlLmcuCgovKgogKiBjaV9zdGFjayBhbmQgY2lf
Y2x1c3RlciBpbiBvY2ZzMl9jbHVzdGVyX2luZm8gbWF5IG5vdCBudWxsCiAqIHRlcm1pbmF0ZWQs
IG1ha2Ugc3VyZSBubyBvdmVyZmxvdyBoYXBwZW5zIGhlcmUuCiAqLwoKQlRXLCBzaW5jZSB3ZSB1
c2Uga3phbGxvYyB0byBhbGxvYyBvc2IsIHNvIHdlIGRvbid0IGhhdmUgdG8gbWFudWFsbHkKc2V0
IHRoZSBsYXN0IG51bGwgYnl0ZS4KClRoYW5rcywKSm9zZXBoCgpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5nIGxpc3QKT2Nm
czItZGV2ZWxAb3NzLm9yYWNsZS5jb20KaHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9tYWlsbWFuL2xp
c3RpbmZvL29jZnMyLWRldmVs
