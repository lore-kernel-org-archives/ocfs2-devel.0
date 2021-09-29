Return-Path: <SRS0=i0E0=OT=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CC20C433FE
	for <ocfs2-devel@archiver.kernel.org>; Wed, 29 Sep 2021 02:42:24 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A8FF460EBB
	for <ocfs2-devel@archiver.kernel.org>; Wed, 29 Sep 2021 02:42:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A8FF460EBB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T0xjPN027787;
	Wed, 29 Sep 2021 02:42:23 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bbj90tgxx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Sep 2021 02:42:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18T2e9Da187380;
	Wed, 29 Sep 2021 02:42:21 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3bc3cdgup3-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 29 Sep 2021 02:42:21 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mVPV1-00043Z-CW; Tue, 28 Sep 2021 19:39:11 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1mVPUy-000439-7z
	for ocfs2-devel@oss.oracle.com; Tue, 28 Sep 2021 19:39:08 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	18T2aRiI137091
	for <ocfs2-devel@oss.oracle.com>; Wed, 29 Sep 2021 02:39:07 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3030.oracle.com with ESMTP id 3bc3bj8cyf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 29 Sep 2021 02:39:07 +0000
Received: from pps.filterd (m0246577.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	18T2KhWP030504
	for <ocfs2-devel@oss.oracle.com>; Wed, 29 Sep 2021 02:39:06 GMT
Received: from out30-131.freemail.mail.aliyun.com
	(out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bc4kfjmdh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Wed, 29 Sep 2021 02:39:06 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R191e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04423;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=5; SR=0;
	TI=SMTPD_---0UpzQBf1_1632883139; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0UpzQBf1_1632883139) by smtp.aliyun-inc.com(127.0.0.1);
	Wed, 29 Sep 2021 10:39:00 +0800
To: =?UTF-8?Q?Valentin_Vidi=c4=87?= <vvidic@valentin-vidic.from.hr>
References: <20210927154459.15976-1-vvidic@valentin-vidic.from.hr>
	<00850aed-2027-a0ab-e801-c6498a5a49f8@linux.alibaba.com>
	<20210928131450.GM28341@valentin-vidic.from.hr>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <212f878e-1bbe-347c-ba43-e4ffb9b4afbe@linux.alibaba.com>
Date: Wed, 29 Sep 2021 10:38:59 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210928131450.GM28341@valentin-vidic.from.hr>
Content-Language: en-US
X-Source-IP: 115.124.30.131
X-ServerName: out30-131.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10121
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
	mlxscore=0 bulkscore=0
	spamscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
	priorityscore=78 clxscore=182 phishscore=0 mlxlogscore=999 adultscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001
	definitions=main-2109290012 domainage_hfrom=8203
X-Spam: Clean
X-MIME-Autoconverted: from 8bit to quoted-printable by userp3030.oracle.com id
	18T2aRiI137091
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109290013
X-Proofpoint-GUID: u3PY4DnBy2LFEGeZcid_jmGisa3Kf6zc
X-Proofpoint-ORIG-GUID: u3PY4DnBy2LFEGeZcid_jmGisa3Kf6zc

T2theSwgeW91IGFyZSByaWdodCwgc3RybGVuKHNyYykgaXMgaW5kZWVkIHdyb25nIGhlcmUuCgpC
dXQgcGxlYXNlIG5vdGUgdGhhdCBpbiBzdHJsY3B5KCk6CmlmIChzaXplKSB7CglzaXplX3QgbGVu
ID0gKHJldCA+PSBzaXplKSA/IHNpemUgLSAxIDogcmV0OwoJbWVtY3B5KGRlc3QsIHNyYywgbGVu
KTsKCWRlc3RbbGVuXSA9ICdcMCc7Cn0KClRha2UgY2lfc3RhY2sgIm8yY2IiIGZvciBleGFtcGxl
LCBzdHJsZW4oIm8yY2IiKSBtYXkgcmV0dXJuIHdyb25nIGlmIHRoZQpjb21pbmcgYnl0ZSBpcyBu
b3QgbnVsbCwgc2F5IGl0IGlzIDEwLgpUaGUgaW5wdXQgc2l6ZSBpcyA1LCBzbyBsZW4gd2lsbCBm
aW5hbGx5IGJlIDQuClNvIGRlc3QgaXMgc3RpbGwgY29ycmVjdCBlbmRpbmcgd2l0aCBudWxsIGJ5
dGUuIE5vIG92ZXJmbG93IGhhcHBlbnMuClNvIHRoZSBwcm9ibGVtIGhlcmUgaXMgdGhlIHdyb25n
IHJldHVybiB2YWx1ZSwgYnV0IGl0IGlzIGRpc2NhcmRlZCBpbgpvY2ZzMl9pbml0aWFsaXplX3N1
cGVyKCkuCgpUaGFua3MsCkpvc2VwaAoKT24gOS8yOC8yMSA5OjE0IFBNLCBWYWxlbnRpbiBWaWRp
xIcgd3JvdGU6Cj4gT24gVHVlLCBTZXAgMjgsIDIwMjEgYXQgMDg6MDU6MjJQTSArMDgwMCwgSm9z
ZXBoIFFpIHdyb3RlOgo+PiBzdHJsY3B5IGluIG9jZnMyX2luaXRpYWxpemVfc3VwZXIoKSBpcyBp
bnRyb2R1Y2VkIDggeWVhcnMgYWdvLCBzbyBJCj4+IGRvbid0IHVuZGVyc3RhbmQgd2h5IHlvdSd2
ZSBtZW50aW9uZWQgdGhhdCB0aGUgaXNzdWVzIHN0YXJ0cyBmcm9tCj4+IHY1LjExLgo+IAo+IHY1
LjExIGludHJvZHVjZWQgdGhlIG92ZXJmbG93IGNoZWNrcyB0byBzdHJpbmcgZnVuY3Rpb25zIHNv
IHRoYXQgaXMKPiB3aGVuIHRoZSBtb3VudCBzdGFydGVkIHRvIGZhaWwuCj4gCj4+IG9zYi0+b3Ni
X2NsdXN0ZXJfc3RhY2sgYW5kIG9zYi0+b3NiX2NsdXN0ZXJfbmFtZSBpcyBhbHdheXMgbGFyZ2Vy
IGJ5Cj4+IDEgdGhhbiB3aGljaCBpbiBvY2ZzMl9jbHVzdGVyX2luZm8sIGFuZCB0aGUgaW5wdXQg
c2l6ZSBvZiBzdHJsY3B5IGRvZXMKPj4gdGhlIHNhbWUsIHNvIEkgZG9uJ3Qgc2VlIGhvdyBpdCBv
dmVyZmxvd3MuCj4gCj4gc3RybGNweSBpbnRlcm5hbGx5IGNhbGxzIHN0cmxlbiBvbiB0aGUgc291
cmNlIGFyZ3VtZW50LCBpbiB0aGlzIGNhc2UKPiB0aGF0IGlzIGNpX3N0YWNrIGFycmF5IHdpdGgg
c2l6ZSBvZiA0LiBUaGF0IGFycmF5IHN0b3JlcyB0aGUgdmFsdWUKPiAibzJjYiIgc28gdGhlIHN0
cmxlbiBjb250aW51ZXMgcmVhZGluZyBpbnRvIHRoZSB1bmlvbiB1bnRpbCBpdCByZWFjaGVzCj4g
YSB6ZXJvIGJ5dGUgc29tZXdoZXJlLiBUaGUgc2FtZSB3b3VsZCBoYXBwZW4gd2l0aCBjaV9jbHVz
dGVyIGlmIHRoZQo+IGNsdXN0ZXIgbmFtZSBpcyBsb25nIGVub3VnaC4KPiAKPiBzdHJ1Y3Qgb2Nm
czJfY2x1c3Rlcl9pbmZvIHsKPiAvKjAwKi8JX191OCAgIGNpX3N0YWNrW09DRlMyX1NUQUNLX0xB
QkVMX0xFTl07Cj4gCXVuaW9uIHsKPiAJCV9fbGUzMiBjaV9yZXNlcnZlZDsKPiAJCXN0cnVjdCB7
Cj4gCQkJX191OCBjaV9zdGFja2ZsYWdzOwo+IAkJCV9fdTggY2lfcmVzZXJ2ZWQxOwo+IAkJCV9f
dTggY2lfcmVzZXJ2ZWQyOwo+IAkJCV9fdTggY2lfcmVzZXJ2ZWQzOwo+IAkJfTsKPiAJfTsKPiAv
KjA4Ki8JX191OCAgIGNpX2NsdXN0ZXJbT0NGUzJfQ0xVU1RFUl9OQU1FX0xFTl07Cj4gLyoxOCov
Cj4gfTsKPiAKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Ck9jZnMyLWRldmVsIG1haWxpbmcgbGlzdApPY2ZzMi1kZXZlbEBvc3Mub3JhY2xlLmNvbQpodHRw
czovL29zcy5vcmFjbGUuY29tL21haWxtYW4vbGlzdGluZm8vb2NmczItZGV2ZWw=
