Return-Path: <SRS0=mf1/=N7=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D19CC433F5
	for <ocfs2-devel@archiver.kernel.org>; Thu,  9 Sep 2021 11:07:56 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AB50760E94
	for <ocfs2-devel@archiver.kernel.org>; Thu,  9 Sep 2021 11:07:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AB50760E94
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1898xOPJ016559;
	Thu, 9 Sep 2021 11:07:54 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ayf8a8a40-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Sep 2021 11:07:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 189B6JmE035949;
	Thu, 9 Sep 2021 11:07:53 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3axst5856j-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 09 Sep 2021 11:07:53 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mOHuK-0001pg-4i; Thu, 09 Sep 2021 04:07:52 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1mOHti-0001oZ-C6
	for ocfs2-devel@oss.oracle.com; Thu, 09 Sep 2021 04:07:14 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	189B6HOr113216
	for <ocfs2-devel@oss.oracle.com>; Thu, 9 Sep 2021 11:07:14 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3030.oracle.com with ESMTP id 3axcpq29qs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 09 Sep 2021 11:07:13 +0000
Received: from pps.filterd (m0246575.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	1895Sldc019118
	for <ocfs2-devel@oss.oracle.com>; Thu, 9 Sep 2021 11:07:13 GMT
Received: from out30-131.freemail.mail.aliyun.com
	(out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by mx0b-00069f01.pphosted.com with ESMTP id 3ay58qfr4f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Thu, 09 Sep 2021 11:07:12 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R311e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1;
	HT=alimailimapcm10staff010182156082;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=8; SR=0;
	TI=SMTPD_---0UnnI-.j_1631185626; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0UnnI-.j_1631185626) by smtp.aliyun-inc.com(127.0.0.1);
	Thu, 09 Sep 2021 19:07:07 +0800
To: Wengang Wang <wen.gang.wang@oracle.com>
References: <20210908102055.10168-1-cymi20@fudan.edu.cn>
	<06d9e055-29b9-731c-5a36-d888f2c83188@linux.alibaba.com>
	<6018AF95-3613-4D43-A3E6-7BAA0E0BE009@oracle.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <c48fb54e-0dd9-42c7-f53d-2ea58fb97255@linux.alibaba.com>
Date: Thu, 9 Sep 2021 19:07:06 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <6018AF95-3613-4D43-A3E6-7BAA0E0BE009@oracle.com>
Content-Language: en-US
X-Source-IP: 115.124.30.131
X-ServerName: out30-131.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10101
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
	suspectscore=0
	priorityscore=188 adultscore=0 mlxscore=0 phishscore=0 bulkscore=0
	lowpriorityscore=0 mlxlogscore=999 spamscore=0 clxscore=279
	malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109030001
	definitions=main-2109090068 domainage_hfrom=8183
X-Spam: Clean
X-MIME-Autoconverted: from 8bit to quoted-printable by aserp3030.oracle.com id
	189B6HOr113216
Cc: Chenyuan Mi <cymi20@fudan.edu.cn>, Xin Tan <tanxin.ctf@gmail.com>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        "yuanxzhang@fudan.edu.cn" <yuanxzhang@fudan.edu.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH v2] ocfs2: Fix handle refcount leak in two
 exception handling paths
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10101 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109090068
X-Proofpoint-ORIG-GUID: zGMUFVRQMWtKMgLPM6A0EO0E3beJheY6
X-Proofpoint-GUID: zGMUFVRQMWtKMgLPM6A0EO0E3beJheY6

SGkgV2VuZ2FuZywKCk9uIDkvOS8yMSAxOjEyIEFNLCBXZW5nYW5nIFdhbmcgd3JvdGU6Cj4gSGks
Cj4gCj4gU29ycnkgZm9yIGxhdGUgaW52b2x2aW5nLCBidXQgdGhpcyBkb2VzbuKAmXQgbG9vayBy
aWdodCB0byBtZS4KPiAKPj4gT24gU2VwIDgsIDIwMjEsIGF0IDM6NTEgQU0sIEpvc2VwaCBRaSA8
am9zZXBoLnFpQGxpbnV4LmFsaWJhYmEuY29tPiB3cm90ZToKPj4KPj4KPj4KPj4gT24gOS84LzIx
IDY6MjAgUE0sIENoZW55dWFuIE1pIHdyb3RlOgo+Pj4gVGhlIHJlZmVyZW5jZSBjb3VudGluZyBp
c3N1ZSBoYXBwZW5zIGluIHR3byBleGNlcHRpb24gaGFuZGxpbmcgcGF0aHMKPj4+IG9mIG9jZnMy
X3JlcGxheV90cnVuY2F0ZV9yZWNvcmRzKCkuIFdoZW4gZXhlY3V0aW5nIHRoZXNlIHR3byBleGNl
cHRpb24KPj4+IGhhbmRsaW5nIHBhdGhzLCB0aGUgZnVuY3Rpb24gZm9yZ2V0cyB0byBkZWNyZWFz
ZSB0aGUgcmVmY291bnQgb2YgaGFuZGxlCj4+PiBpbmNyZWFzZWQgYnkgb2NmczJfc3RhcnRfdHJh
bnMoKSwgY2F1c2luZyBhIHJlZmNvdW50IGxlYWsuCj4+Pgo+Pj4gRml4IHRoaXMgaXNzdWUgYnkg
dXNpbmcgb2NmczJfY29tbWl0X3RyYW5zKCkgdG8gZGVjcmVhc2UgdGhlIHJlZmNvdW50Cj4+PiBv
ZiBoYW5kbGUgaW4gdHdvIGhhbmRsaW5nIHBhdGhzLgo+Pj4KPj4+IFNpZ25lZC1vZmYtYnk6IENo
ZW55dWFuIE1pIDxjeW1pMjBAZnVkYW4uZWR1LmNuPgo+Pj4gU2lnbmVkLW9mZi1ieTogWGl5dSBZ
YW5nIDx4aXl1eWFuZzE5QGZ1ZGFuLmVkdS5jbj4KPj4+IFNpZ25lZC1vZmYtYnk6IFhpbiBUYW4g
PHRhbnhpbi5jdGZAZ21haWwuY29tPgo+Pgo+PiBSZXZpZXdlZC1ieTogSm9zZXBoIFFpIDxqb3Nl
cGgucWlAbGludXguYWxpYmFiYS5jb20+Cj4+PiAtLS0KPj4+IGZzL29jZnMyL2FsbG9jLmMgfCAy
ICsrCj4+PiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspCj4+Pgo+Pj4gZGlmZiAtLWdp
dCBhL2ZzL29jZnMyL2FsbG9jLmMgYi9mcy9vY2ZzMi9hbGxvYy5jCj4+PiBpbmRleCBmMWNjODI1
OGQzNGEuLmIwNWZkZTdlZGMzYSAxMDA2NDQKPj4+IC0tLSBhL2ZzL29jZnMyL2FsbG9jLmMKPj4+
ICsrKyBiL2ZzL29jZnMyL2FsbG9jLmMKPj4+IEBAIC01OTQwLDYgKzU5NDAsNyBAQCBzdGF0aWMg
aW50IG9jZnMyX3JlcGxheV90cnVuY2F0ZV9yZWNvcmRzKHN0cnVjdCBvY2ZzMl9zdXBlciAqb3Ni
LAo+Pj4gCQlzdGF0dXMgPSBvY2ZzMl9qb3VybmFsX2FjY2Vzc19kaShoYW5kbGUsIElOT0RFX0NB
Q0hFKHRsX2lub2RlKSwgdGxfYmgsCj4+PiAJCQkJCQkgT0NGUzJfSk9VUk5BTF9BQ0NFU1NfV1JJ
VEUpOwo+Pj4gCQlpZiAoc3RhdHVzIDwgMCkgewo+Pj4gKwkJCW9jZnMyX2NvbW1pdF90cmFucyhv
c2IsIGhhbmRsZSk7Cj4+PiAJCQltbG9nX2Vycm5vKHN0YXR1cyk7Cj4+PiAJCQlnb3RvIGJhaWw7
Cj4+PiAJCX0KPj4+IEBAIC01OTY0LDYgKzU5NjUsNyBAQCBzdGF0aWMgaW50IG9jZnMyX3JlcGxh
eV90cnVuY2F0ZV9yZWNvcmRzKHN0cnVjdCBvY2ZzMl9zdXBlciAqb3NiLAo+Pj4gCQkJCQkJICAg
ICBkYXRhX2FsbG9jX2JoLCBzdGFydF9ibGssCj4+PiAJCQkJCQkgICAgIG51bV9jbHVzdGVycyk7
Cj4+PiAJCQlpZiAoc3RhdHVzIDwgMCkgewo+Pj4gKwkJCQlvY2ZzMl9jb21taXRfdHJhbnMob3Ni
LCBoYW5kbGUpOwo+IAo+IEFzIGEgdHJhbnNhY3Rpb24sIHN0dWZmIGV4cGVjdGVkIHRvIGJlIGlu
IHRoZSBzYW1lIGhhbmRsZSBzaG91bGQgYmUgdHJlYXRlZCBhcyBhdG9taWMuCj4gSGVyZSB0aGUg
c3R1ZmYgaW5jbHVkZXMgdGhlIHRsX2JoIGFuZCBvdGhlciBtZXRhZGF0YSBibG9jayB3aGljaCB3
aWxsIGJlIG1vZGlmaWVkIGluIG9jZnMyX2ZyZWVfY2x1c3RlcnMoKS4KPiBDb21pbmcgaGVyZSwg
c29tZSBvZiByZWxhdGVkIG1ldGEgYmxvY2tzIG1heSBiZSBpbiB0aGUgaGFuZGxlIGJ1dCBvdGhl
cnMgYXJlIG5vdCBkdWUgdG8gdGhlIGVycm9yIGhhcHBlbmVkLgo+IElmIHlvdSBkbyBhIGNvbW1p
dCwgcGFydGlhbCBtZXRhIGJsb2NrcyBhcmUgY29tbWl0dGVkIHRvIGxvZy4g4oCUIHRoYXQgYnJl
YWtzIHRoZSBhdG9taWMgaWRlYSwgaXQgd2lsbCBjYXVzZSBGUyBpbmNvbnNpc3RlbmN5Lgo+IFNv
IHdoYXTigJlzIHJlYXNvbiB5b3Ugd2FudCB0byBjb21taXQgdGhlIG1ldGEgYmxvY2sgY2hhbmdl
cywgd2hpY2ggaXMgbm90IGFsbCBvZiBleHBlY3RlZCwgaW4gdGhpcyBoYW5kbGUgdG8gam91cm5h
bCBsb2c/Cj4gCj4gRG8geW91IHJlYWxseSBzZWUgYSBoaXQgb24gdGhlIGZhaWx1cmU/IG9yIGp1
c3QgeW91IGRldGVjdGVkIHRoZSByZWZjb3VudCBsZWFrIGJ5IGNvZGUgcmV2aWV3Pwo+IAo+IFlv
dSBtYXkgd2FudCB0byBsb29rIGF0IG9jZnMyX2pvdXJuYWxfZGlydHkoKSBmb3IgdGhlIGVycm9y
IGhhbmRsaW5nIHBhcnQuCj4gCgpGb3IgdGhlIGZpcnN0IGVycm9yIGhhbmRsaW5nLCBzaW5jZSB3
ZSBkb24ndCBjYWxsIG9jZnMyX2pvdXJuYWxfZGlydHkoKQp5ZXQsIHNvIHdvbid0IGJlIGEgcHJv
YmxlbS4KRm9yIHRoZSBzZWNvbmQgZXJyb3IgaGFuZGxpbmcsIEkgdGhpbmsgd2UgZG9uJ3QgaGF2
ZSBhIGJldHRlciB3YXkuIExvb2sKYXQgb3RoZXIgY2FsbGVycyBvZiBvY2ZzMl9mcmVlX2NsdXN0
ZXJzKCksIHdlIHNpbXBseSBpZ25vcmUgdGhlIGVycm9yCmNvZGUuCkFueXdheSwgd2Ugc2hvdWxk
IGNvbW1pdCB0cmFuc2FjdGlvbiBpZiBzdGFydHMsIG90aGVyd2lzZSBqb3VybmFsIHdpbGwKYmUg
YWJub3JtYWwuCgpUaGFua3MsCkpvc2VwaAoKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCk9jZnMyLWRldmVsIG1haWxpbmcgbGlzdApPY2ZzMi1kZXZlbEBv
c3Mub3JhY2xlLmNvbQpodHRwczovL29zcy5vcmFjbGUuY29tL21haWxtYW4vbGlzdGluZm8vb2Nm
czItZGV2ZWw=
