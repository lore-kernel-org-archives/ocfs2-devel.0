Return-Path: <SRS0=tkcu=NR=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62301C432BE
	for <ocfs2-devel@archiver.kernel.org>; Thu, 26 Aug 2021 09:58:59 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0FF85610D0
	for <ocfs2-devel@archiver.kernel.org>; Thu, 26 Aug 2021 09:58:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0FF85610D0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17Q7dSWw006447;
	Thu, 26 Aug 2021 09:58:58 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ap1r5gsvn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Aug 2021 09:58:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17Q9w6O4154681;
	Thu, 26 Aug 2021 09:58:57 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3ajpm28tcs-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 26 Aug 2021 09:58:56 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mJC77-00025I-J7; Thu, 26 Aug 2021 02:56:01 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1mJC71-00024r-IX
	for ocfs2-devel@oss.oracle.com; Thu, 26 Aug 2021 02:55:55 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17Q9tVB9010554
	for <ocfs2-devel@oss.oracle.com>; Thu, 26 Aug 2021 09:55:55 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3020.oracle.com with ESMTP id 3akb8yq8b6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 26 Aug 2021 09:55:54 +0000
Received: from pps.filterd (m0246577.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	17Q8W2sf000898
	for <ocfs2-devel@oss.oracle.com>; Thu, 26 Aug 2021 09:55:53 GMT
Received: from out30-57.freemail.mail.aliyun.com
	(out30-57.freemail.mail.aliyun.com [115.124.30.57])
	by mx0b-00069f01.pphosted.com with ESMTP id 3ap0s4vc18-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Thu, 26 Aug 2021 09:55:52 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R191e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04420;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=6; SR=0;
	TI=SMTPD_---0Um47hnD_1629971747; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0Um47hnD_1629971747) by smtp.aliyun-inc.com(127.0.0.1);
	Thu, 26 Aug 2021 17:55:48 +0800
To: Gang He <ghe@suse.com>, mark@fasheh.com, jlbec@evilplan.org
References: <20210826061038.22295-1-ghe@suse.com>
	<b3f498eb-7de5-8a7f-0f52-01c1e2caa5d8@linux.alibaba.com>
	<7795ed72-8b77-14ea-cf18-78870e58f429@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <0a8db668-b6f4-4b33-086a-2b522b343cf1@linux.alibaba.com>
Date: Thu, 26 Aug 2021 17:55:47 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <7795ed72-8b77-14ea-cf18-78870e58f429@suse.com>
Content-Language: en-US
X-Source-IP: 115.124.30.57
X-ServerName: out30-57.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10087
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
	impostorscore=0
	lowpriorityscore=0 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
	phishscore=0 malwarescore=0 clxscore=236 priorityscore=181
	mlxlogscore=999
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000
	definitions=main-2108260060 domainage_hfrom=8169
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10087
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	phishscore=0 spamscore=0
	bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108260060
X-MIME-Autoconverted: from 8bit to quoted-printable by userp3020.oracle.com id
	17Q9tVB9010554
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: ocfs2_downconvert_lock failure
	results in deadlock
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10087 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108260060
X-Proofpoint-GUID: Hz3Yys9vdObNPZLGZUOtB4PK9PY-yyzF
X-Proofpoint-ORIG-GUID: Hz3Yys9vdObNPZLGZUOtB4PK9PY-yyzF

CgpPbiA4LzI2LzIxIDQ6NDUgUE0sIEdhbmcgSGUgd3JvdGU6Cj4gSGkgSm9zZXBoLAo+IAo+IE9u
IDIwMjEvOC8yNiAxNjoyMywgSm9zZXBoIFFpIHdyb3RlOgo+Pgo+Pgo+PiBPbiA4LzI2LzIxIDI6
MTAgUE0sIEdhbmcgSGUgd3JvdGU6Cj4+PiBVc3VhbGx5LCBvY2ZzMl9kb3duY29udmVydF9sb2Nr
KCkgZnVuY3Rpb24gYWx3YXlzIGRvd25jb252ZXJ0cwo+Pj4gZGxtIGxvY2sgdG8gdGhlIGV4cGVj
dGVkIGxldmVsIGZvciBzYXRpc2Z5IGRsbSBiYXN0IHJlcXVlc3RzCj4+Cj4+IHMvZm9yL3RvCj4+
Cj4+PiBmcm9tIHRoZSBvdGhlciBub2Rlcy4KPj4+IEJ1dCB0aGVyZSBpcyBhIHJhcmUgc2l0dWF0
aW9uLiBXaGVuIGRsbSBsb2NrIGNvbnZlcnNpb24gaXMgYmVpbmcKPj4+IGNhbmNlbGVkLCBvY2Zz
Ml9kb3duY29udmVydF9sb2NrKCkgZnVuY3Rpb24gd2lsbCByZXR1cm4gLUVCVVNZLgo+Pj4gWW91
IG5lZWQgdG8gYmUgYXdhcmUgdGhhdCBvY2ZzMl9jYW5jZWxfY29udmVydCgpIGZ1bmN0aW9uIGlz
Cj4+PiBhc3luY2hyb25vdXMgaW4gZnNkbG0gaW1wbGVtZW50YXRpb24uCj4+PiBJZiB3ZSBkb2Vz
IG5vdCByZXF1ZXVlIHRoaXMgbG9ja3JlcyBlbnRyeSwgb2NmczIgZG93bmNvbnZlcnQKPj4+IHRo
cmVhZCBubyBsb25nZXIgaGFuZGxlcyB0aGlzIGRsbSBsb2NrIGJhc3QgcmVxdWVzdC4gVGhlbiwg
dGhlCj4+PiBvdGhlciBub2RlcyB3aWxsIG5vdCBnZXQgdGhlIGRsbSBsb2NrIGFnYWluLCB0aGUg
Y3VycmVudCBub2RlJ3MKPj4+IHByb2Nlc3Mgd2lsbCBiZSBibG9ja2VkIHdoZW4gYWNxdWlyZSB0
aGlzIGRsbSBsb2NrIGFnYWluLgo+Pj4KPj4+IFNpZ25lZC1vZmYtYnk6IEdhbmcgSGUgPGdoZUBz
dXNlLmNvbT4KPj4+IC0tLQo+Pj4gwqAgZnMvb2NmczIvZGxtZ2x1ZS5jIHwgMTMgKysrKysrKysr
LS0tLQo+Pj4gwqAgMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMo
LSkKPj4+Cj4+PiBkaWZmIC0tZ2l0IGEvZnMvb2NmczIvZGxtZ2x1ZS5jIGIvZnMvb2NmczIvZGxt
Z2x1ZS5jCj4+PiBpbmRleCA0OGZkMzY5YzI5YTQuLmM0NTRjMjE4ZmJmZSAxMDA2NDQKPj4+IC0t
LSBhL2ZzL29jZnMyL2RsbWdsdWUuYwo+Pj4gKysrIGIvZnMvb2NmczIvZGxtZ2x1ZS5jCj4+PiBA
QCAtMzY3MSwxMyArMzY3MSwxMSBAQCBzdGF0aWMgaW50IG9jZnMyX2Rvd25jb252ZXJ0X2xvY2so
c3RydWN0IG9jZnMyX3N1cGVyICpvc2IsCj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgT0NGUzJfTE9DS19JRF9NQVhfTEVOIC0gMSk7Cj4+PiDCoMKgwqDCoMKgIGxvY2ty
ZXNfY2xlYXJfcGVuZGluZyhsb2NrcmVzLCBnZW5lcmF0aW9uLCBvc2IpOwo+Pj4gwqDCoMKgwqDC
oCBpZiAocmV0KSB7Cj4+PiAtwqDCoMKgwqDCoMKgwqAgb2NmczJfbG9nX2RsbV9lcnJvcigib2Nm
czJfZGxtX2xvY2siLCByZXQsIGxvY2tyZXMpOwo+Pj4gK8KgwqDCoMKgwqDCoMKgIGlmIChyZXQg
IT0gLUVCVVNZKQo+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgb2NmczJfbG9nX2RsbV9lcnJv
cigib2NmczJfZGxtX2xvY2siLCByZXQsIGxvY2tyZXMpOwo+Pgo+PiBEbyB3ZSBoYXZlIHRvIHRy
ZWF0IEVCVVNZIGFzIGEgbm9ybWFsIGNhc2U/Cj4gWWVzLCB0aGlzIHJldHVybiBjb2RlIGlzIGV4
cGVjdGVkIHdoZW4gY2FsbCBkbG1fbG9jaygpIHRvIGNvbnZlcnQgYSBkbG0gbG9jayB0byBhbm90
aGVyIGxldmVsLCBidXQgdGhpcyBkbG0gbG9jayBpcyBiZWluZyBjYW5jZWxsZWQuCj4gQXMgSSBz
YWlkIGluIGFub3RoZXIgbWFpbCwgZm9yIGZzZGxtIGltcGxlbWVudGF0aW9uLG9jZnMyX2NhbmNl
bF9jb252ZXJ0Cj4gd2lsbCByZXR1cm4gaW1tZWRpYXRlbHksIGJ1dCB0aGUgcmVsYXRlZCBkbG0g
bG9jayB3aWxsKGlzKSBiZSBjYW5jZWxsZWQgaW4gYmFja2dyb3VuZC4gRm9yIG8yZGxtIGltcGxl
bWVudGF0aW9uLG9jZnMyX2NhbmNlbF9jb252ZXJ0IHdpbGwgcmV0dXJuIGFmdGVyIHRoZSBkbG0g
bG9jayBpcyBjYW5jZWxsZWQgYW5kIGl0J3MgYXN0IGlzIGludm9rZWQsIHRoYXQgaXMgd2h5IG8y
Y2IgYmFzZWQgb2NmczIgZG9lcyBub3QgZW5jb3VudGVyIC1FQlVTWSByZXR1cm4gY29kZSBpbiBt
eSB0ZXN0IHNjcmlwdCwgb2YgY291cnNlLCB0aGlzIGtpbmQgb2YgaW1wbGVtZW50YXRpb24gd2ls
bCBibG9jayBvdGhlciBsb2NrcmVzIGVudHJpZXMgdG8gYmUgaGFuZGxlZCBmb3IgYSBsaXR0bGUg
dGltZSBpbiBkb3duLWNvbnZlcnQgdGhyZWFkLgoKQmV0dGVyIHRvIGxlYXZlIHRoaXMgbG9nIGZv
ciBsYXRlciBpc3N1ZSB0cmFja2luZy4KSSdtIHdvcnJ5aW5nIGFib3V0IGlmIHRoZXJlIGFyZSBv
dGhlciBjYXNlcyBoZXJlLgoKPiAKPj4KPj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBvY2ZzMl9yZWNv
dmVyX2Zyb21fZGxtX2Vycm9yKGxvY2tyZXMsIDEpOwo+Pj4gLcKgwqDCoMKgwqDCoMKgIGdvdG8g
YmFpbDsKPj4+IMKgwqDCoMKgwqAgfQo+Pj4gwqAgLcKgwqDCoCByZXQgPSAwOwo+Pj4gLWJhaWw6
Cj4+PiDCoMKgwqDCoMKgIHJldHVybiByZXQ7Cj4+PiDCoCB9Cj4+PiDCoCBAQCAtMzkxMiw2ICsz
OTEwLDEzIEBAIHN0YXRpYyBpbnQgb2NmczJfdW5ibG9ja19sb2NrKHN0cnVjdCBvY2ZzMl9zdXBl
ciAqb3NiLAo+Pj4gwqDCoMKgwqDCoCBzcGluX3VubG9ja19pcnFyZXN0b3JlKCZsb2NrcmVzLT5s
X2xvY2ssIGZsYWdzKTsKPj4+IMKgwqDCoMKgwqAgcmV0ID0gb2NmczJfZG93bmNvbnZlcnRfbG9j
ayhvc2IsIGxvY2tyZXMsIG5ld19sZXZlbCwgc2V0X2x2YiwKPj4+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGdlbik7Cj4+PiArwqDCoMKgIC8qIG9jZnMyX2Nh
bmNlbF9jb252ZXJ0KCkgaXMgaW4gcHJvZ3Jlc3MsIHRyeSBhZ2FpbiBsYXRlciAqLwo+Pj4gK8Kg
wqDCoCBpZiAocmV0ID09IC1FQlVTWSkgewo+Pj4gK8KgwqDCoMKgwqDCoMKgIGN0bC0+cmVxdWV1
ZSA9IDE7Cj4+PiArwqDCoMKgwqDCoMKgwqAgbWxvZyhNTF9CQVNUUywgImxvY2tyZXMgJXMsIFJl
UTogRG93bmNvbnZlcnQgYnVzeVxuIiwKPj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbG9j
a3Jlcy0+bF9uYW1lKTsKPj4+ICvCoMKgwqDCoMKgwqDCoCByZXQgPSAwOwo+Pgo+PiBEaXR0by4g
SWYgRUJVU1kgaXMgbm90IGEgbm9ybWFsIGNhc2UsIEknZCBsaWtlIGp1c3QgcmVxdWV1ZSBpdCBi
dXQgbm90Cj4+IGNoYW5nZSBpdCB0byBub3JtYWwgcmV0dXJuIGNvZGUuCj4+IFlvdSBrbm93IE1M
X0JBU1RTIGlzIGFsd2F5cyBzd2l0Y2hlZCBvZmYgaW4gcHJvZHVjdGlvbiBlbnZpcm9ubWVudC4K
PiBTaW5jZSB0aGlzIGNhc2Ugc2hvdWxkIGJlIGNvbnNpZGVyZWQgYXMgYSBub3JtYWwgY2FzZSwg
YWx0aG91Z2ggaXQncyByYXJlLgo+IFdlIHNob3VsZCBub3QgcHJpbnQgYW55IGVycm9yIG1lc3Nh
Z2UgdG8ga2VybmVsIGpvdXJuYWwsIGJ1dCBpZiB0aGUgdXNlcgo+IHR1cm4gb24gdGhlIEJBU1RT
IHRyYWNlLCBoZSBzaG91bGQgd2F0Y2ggdGhpcyB0cmFjZSBmb3IgZGVidWdnaW5nLgo+IAoKT2th
eSwgc2luY2Ugd2UgbGVhdmUgYW4gZXJyb3IgbWVzc2FnZSBhYm92ZSwgd2UgY2FuIHJldHVybiBu
b3JtYWwgdG8KY2FsbGVyLiBBbmQgbm93IGNhbGxlciBvbmx5IHByaW50IGEgc2ltcGxlIGVycm9y
IHdoaWNoIGRvZXNuJ3QgaGF2ZQptdWNoIG1lYW5pbmcuCgpCVFcsIGNvdWxkIHdlIGNoYW5nZSBp
dCBsaWtlOgoKcmV0ID0gb2NmczJfZG93bmNvbnZlcnRfbG9jaygpOwppZiAocmV0ID09IC1FQlVT
WSkgewoJbWxvZyhNTF9CQVNUUywgLi4uKTsKCS8qIERlc2NyaWJlIHRoZSBjYXNlIHdoeSB3ZSBo
YXZlIHRvIHJlcXVldWUgKi8KCWdvdG8gcmVxdWV1ZTsKfQoKLi4uCnJlcXVldWU6CgljdGwtPnJl
cXVldWUgPSAxOwoJcmV0dXJuIDA7CgoKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCk9jZnMyLWRldmVsIG1haWxpbmcgbGlzdApPY2ZzMi1kZXZlbEBvc3Mu
b3JhY2xlLmNvbQpodHRwczovL29zcy5vcmFjbGUuY29tL21haWxtYW4vbGlzdGluZm8vb2NmczIt
ZGV2ZWw=
