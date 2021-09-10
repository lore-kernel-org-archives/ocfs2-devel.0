Return-Path: <SRS0=6dL3=OA=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 333DFC433FE
	for <ocfs2-devel@archiver.kernel.org>; Fri, 10 Sep 2021 01:54:16 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CCBDD610A3
	for <ocfs2-devel@archiver.kernel.org>; Fri, 10 Sep 2021 01:54:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CCBDD610A3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 189LpL6v005251;
	Fri, 10 Sep 2021 01:54:15 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3aytj5gd8t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Sep 2021 01:54:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18A1orfI123183;
	Fri, 10 Sep 2021 01:54:13 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3aytft86wm-1;
	Fri, 10 Sep 2021 01:54:13 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mOVk4-0006zl-Oi; Thu, 09 Sep 2021 18:54:12 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1mOVjz-0006zA-Tw
	for ocfs2-devel@oss.oracle.com; Thu, 09 Sep 2021 18:54:08 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	18A1otlv012722
	for <ocfs2-devel@oss.oracle.com>; Fri, 10 Sep 2021 01:54:07 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3020.oracle.com with ESMTP id 3aytfcrc17-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 10 Sep 2021 01:54:07 +0000
Received: from pps.filterd (m0246574.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	189MQRXA009594
	for <ocfs2-devel@oss.oracle.com>; Fri, 10 Sep 2021 01:54:06 GMT
Received: from out30-45.freemail.mail.aliyun.com
	(out30-45.freemail.mail.aliyun.com [115.124.30.45])
	by mx0b-00069f01.pphosted.com with ESMTP id 3ayu2k1xc2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Fri, 10 Sep 2021 01:54:05 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R781e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04426;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=8; SR=0;
	TI=SMTPD_---0Unqrd8t_1631238837; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0Unqrd8t_1631238837) by smtp.aliyun-inc.com(127.0.0.1);
	Fri, 10 Sep 2021 09:53:58 +0800
To: Wengang Wang <wen.gang.wang@oracle.com>
References: <20210908102055.10168-1-cymi20@fudan.edu.cn>
	<06d9e055-29b9-731c-5a36-d888f2c83188@linux.alibaba.com>
	<6018AF95-3613-4D43-A3E6-7BAA0E0BE009@oracle.com>
	<c48fb54e-0dd9-42c7-f53d-2ea58fb97255@linux.alibaba.com>
	<CED0D2AD-7905-490E-8D36-50D192CD9BF1@oracle.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <ee86ea1a-0348-e975-3c67-8d574eaadbe3@linux.alibaba.com>
Date: Fri, 10 Sep 2021 09:53:57 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CED0D2AD-7905-490E-8D36-50D192CD9BF1@oracle.com>
Content-Language: en-US
X-Source-IP: 115.124.30.45
X-ServerName: out30-45.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10102
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
	priorityscore=104
	impostorscore=0 clxscore=262 mlxscore=0 mlxlogscore=999 phishscore=0
	adultscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0
	malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109030001
	definitions=main-2109100009 domainage_hfrom=8184
X-Spam: Clean
X-MIME-Autoconverted: from 8bit to quoted-printable by userp3020.oracle.com id
	18A1otlv012722
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10102 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 spamscore=0 malwarescore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109100009
X-Proofpoint-GUID: TNfLELKfQpog3V68aax1KpbSXQiiHMwk
X-Proofpoint-ORIG-GUID: TNfLELKfQpog3V68aax1KpbSXQiiHMwk

CgpPbiA5LzEwLzIxIDE6NDggQU0sIFdlbmdhbmcgV2FuZyB3cm90ZToKPiAKPiAKPiBPbiBTZXAg
OSwgMjAyMSwgYXQgNDowNyBBTSwgSm9zZXBoIFFpIDxqb3NlcGgucWlAbGludXguYWxpYmFiYS5j
b208bWFpbHRvOmpvc2VwaC5xaUBsaW51eC5hbGliYWJhLmNvbT4+IHdyb3RlOgo+IAo+IEhpIFdl
bmdhbmcsCj4gCj4gT24gOS85LzIxIDE6MTIgQU0sIFdlbmdhbmcgV2FuZyB3cm90ZToKPiBIaSwK
PiAKPiBTb3JyeSBmb3IgbGF0ZSBpbnZvbHZpbmcsIGJ1dCB0aGlzIGRvZXNu4oCZdCBsb29rIHJp
Z2h0IHRvIG1lLgo+IAo+IE9uIFNlcCA4LCAyMDIxLCBhdCAzOjUxIEFNLCBKb3NlcGggUWkgPGpv
c2VwaC5xaUBsaW51eC5hbGliYWJhLmNvbTxtYWlsdG86am9zZXBoLnFpQGxpbnV4LmFsaWJhYmEu
Y29tPj4gd3JvdGU6Cj4gCj4gCj4gCj4gT24gOS84LzIxIDY6MjAgUE0sIENoZW55dWFuIE1pIHdy
b3RlOgo+IFRoZSByZWZlcmVuY2UgY291bnRpbmcgaXNzdWUgaGFwcGVucyBpbiB0d28gZXhjZXB0
aW9uIGhhbmRsaW5nIHBhdGhzCj4gb2Ygb2NmczJfcmVwbGF5X3RydW5jYXRlX3JlY29yZHMoKS4g
V2hlbiBleGVjdXRpbmcgdGhlc2UgdHdvIGV4Y2VwdGlvbgo+IGhhbmRsaW5nIHBhdGhzLCB0aGUg
ZnVuY3Rpb24gZm9yZ2V0cyB0byBkZWNyZWFzZSB0aGUgcmVmY291bnQgb2YgaGFuZGxlCj4gaW5j
cmVhc2VkIGJ5IG9jZnMyX3N0YXJ0X3RyYW5zKCksIGNhdXNpbmcgYSByZWZjb3VudCBsZWFrLgo+
IAo+IEZpeCB0aGlzIGlzc3VlIGJ5IHVzaW5nIG9jZnMyX2NvbW1pdF90cmFucygpIHRvIGRlY3Jl
YXNlIHRoZSByZWZjb3VudAo+IG9mIGhhbmRsZSBpbiB0d28gaGFuZGxpbmcgcGF0aHMuCj4gCj4g
U2lnbmVkLW9mZi1ieTogQ2hlbnl1YW4gTWkgPGN5bWkyMEBmdWRhbi5lZHUuY248bWFpbHRvOmN5
bWkyMEBmdWRhbi5lZHUuY24+Pgo+IFNpZ25lZC1vZmYtYnk6IFhpeXUgWWFuZyA8eGl5dXlhbmcx
OUBmdWRhbi5lZHUuY248bWFpbHRvOnhpeXV5YW5nMTlAZnVkYW4uZWR1LmNuPj4KPiBTaWduZWQt
b2ZmLWJ5OiBYaW4gVGFuIDx0YW54aW4uY3RmQGdtYWlsLmNvbTxtYWlsdG86dGFueGluLmN0ZkBn
bWFpbC5jb20+Pgo+IAo+IFJldmlld2VkLWJ5OiBKb3NlcGggUWkgPGpvc2VwaC5xaUBsaW51eC5h
bGliYWJhLmNvbTxtYWlsdG86am9zZXBoLnFpQGxpbnV4LmFsaWJhYmEuY29tPj4KPiAtLS0KPiBm
cy9vY2ZzMi9hbGxvYy5jIHwgMiArKwo+IDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKykK
PiAKPiBkaWZmIC0tZ2l0IGEvZnMvb2NmczIvYWxsb2MuYyBiL2ZzL29jZnMyL2FsbG9jLmMKPiBp
bmRleCBmMWNjODI1OGQzNGEuLmIwNWZkZTdlZGMzYSAxMDA2NDQKPiAtLS0gYS9mcy9vY2ZzMi9h
bGxvYy5jCj4gKysrIGIvZnMvb2NmczIvYWxsb2MuYwo+IEBAIC01OTQwLDYgKzU5NDAsNyBAQCBz
dGF0aWMgaW50IG9jZnMyX3JlcGxheV90cnVuY2F0ZV9yZWNvcmRzKHN0cnVjdCBvY2ZzMl9zdXBl
ciAqb3NiLAo+IHN0YXR1cyA9IG9jZnMyX2pvdXJuYWxfYWNjZXNzX2RpKGhhbmRsZSwgSU5PREVf
Q0FDSEUodGxfaW5vZGUpLCB0bF9iaCwKPiAgT0NGUzJfSk9VUk5BTF9BQ0NFU1NfV1JJVEUpOwo+
IGlmIChzdGF0dXMgPCAwKSB7Cj4gKyBvY2ZzMl9jb21taXRfdHJhbnMob3NiLCBoYW5kbGUpOwo+
IG1sb2dfZXJybm8oc3RhdHVzKTsKPiBnb3RvIGJhaWw7Cj4gfQo+IEBAIC01OTY0LDYgKzU5NjUs
NyBAQCBzdGF0aWMgaW50IG9jZnMyX3JlcGxheV90cnVuY2F0ZV9yZWNvcmRzKHN0cnVjdCBvY2Zz
Ml9zdXBlciAqb3NiLAo+ICAgICAgZGF0YV9hbGxvY19iaCwgc3RhcnRfYmxrLAo+ICAgICAgbnVt
X2NsdXN0ZXJzKTsKPiBpZiAoc3RhdHVzIDwgMCkgewo+ICsgb2NmczJfY29tbWl0X3RyYW5zKG9z
YiwgaGFuZGxlKTsKPiAKPiBBcyBhIHRyYW5zYWN0aW9uLCBzdHVmZiBleHBlY3RlZCB0byBiZSBp
biB0aGUgc2FtZSBoYW5kbGUgc2hvdWxkIGJlIHRyZWF0ZWQgYXMgYXRvbWljLgo+IEhlcmUgdGhl
IHN0dWZmIGluY2x1ZGVzIHRoZSB0bF9iaCBhbmQgb3RoZXIgbWV0YWRhdGEgYmxvY2sgd2hpY2gg
d2lsbCBiZSBtb2RpZmllZCBpbiBvY2ZzMl9mcmVlX2NsdXN0ZXJzKCkuCj4gQ29taW5nIGhlcmUs
IHNvbWUgb2YgcmVsYXRlZCBtZXRhIGJsb2NrcyBtYXkgYmUgaW4gdGhlIGhhbmRsZSBidXQgb3Ro
ZXJzIGFyZSBub3QgZHVlIHRvIHRoZSBlcnJvciBoYXBwZW5lZC4KPiBJZiB5b3UgZG8gYSBjb21t
aXQsIHBhcnRpYWwgbWV0YSBibG9ja3MgYXJlIGNvbW1pdHRlZCB0byBsb2cuIOKAlCB0aGF0IGJy
ZWFrcyB0aGUgYXRvbWljIGlkZWEsIGl0IHdpbGwgY2F1c2UgRlMgaW5jb25zaXN0ZW5jeS4KPiBT
byB3aGF04oCZcyByZWFzb24geW91IHdhbnQgdG8gY29tbWl0IHRoZSBtZXRhIGJsb2NrIGNoYW5n
ZXMsIHdoaWNoIGlzIG5vdCBhbGwgb2YgZXhwZWN0ZWQsIGluIHRoaXMgaGFuZGxlIHRvIGpvdXJu
YWwgbG9nPwo+IAo+IERvIHlvdSByZWFsbHkgc2VlIGEgaGl0IG9uIHRoZSBmYWlsdXJlPyBvciBq
dXN0IHlvdSBkZXRlY3RlZCB0aGUgcmVmY291bnQgbGVhayBieSBjb2RlIHJldmlldz8KPiAKPiBZ
b3UgbWF5IHdhbnQgdG8gbG9vayBhdCBvY2ZzMl9qb3VybmFsX2RpcnR5KCkgZm9yIHRoZSBlcnJv
ciBoYW5kbGluZyBwYXJ0Lgo+IAo+IAo+IEZvciB0aGUgZmlyc3QgZXJyb3IgaGFuZGxpbmcsIHNp
bmNlIHdlIGRvbid0IGNhbGwgb2NmczJfam91cm5hbF9kaXJ0eSgpCj4geWV0LCBzbyB3b24ndCBi
ZSBhIHByb2JsZW0uCj4gRm9yIHRoZSBzZWNvbmQgZXJyb3IgaGFuZGxpbmcsIEkgdGhpbmsgd2Ug
ZG9uJ3QgaGF2ZSBhIGJldHRlciB3YXkuIExvb2sKPiBhdCBvdGhlciBjYWxsZXJzIG9mIG9jZnMy
X2ZyZWVfY2x1c3RlcnMoKSwgd2Ugc2ltcGx5IGlnbm9yZSB0aGUgZXJyb3IKPiBjb2RlLgo+IEFu
eXdheSwgd2Ugc2hvdWxkIGNvbW1pdCB0cmFuc2FjdGlvbiBpZiBzdGFydHMsIG90aGVyd2lzZSBq
b3VybmFsIHdpbGwKPiBiZSBhYm5vcm1hbC4KPiAKPiBJIGRvbid0IHRoaW5rIHNvLiBJZiBlcnJv
ciBoYXBwZW5lZCwgd2Ugc2hvdWxkIGZhaWwgb2NmczIsIHJhdGhlciB0aGFuIGRvIGEgcGFydGlh
bCBjb21taXR0aW5nLgo+IAoKVW1tLi4uIG5vdCBleGFjdGx5Li4uClRha2Ugb2NmczJfZnJlZV9j
bHVzdGVycygpIGZvciBleGFtcGxlLCB3aGVuIGl0IGZhaWxzIGluIGNhc2Ugb2YgRUlPIG9yCkVO
T01FTSwgd2UgY2FuJ3QganVzdCBhYm9ydCBqb3VybmFsIGluIHN1Y2ggY2FzZXMsIGJlY2F1c2Ug
aXQgaXMgbm90IHNvCnNlcmlvdXMsIG9ubHkgYSBiaXQgYmxvY2tzIHN0aWxsIG9jY3VwaWVkIGFu
ZCB0aGV5IHdpbGwgcmVjb3ZlcnkgZHVyaW5nCnRoZSBuZXh0IG1vdW50LiAKVGhhdCdzIHdoeSB3
ZSBoYXZlICJlcnJvcnM9Y29udGludWUiIGluIG1vc3QgZmlsZXN5c3RlbXMsIHdlIHNob3VsZCBh
bHdheXMKY29uc2lkZXIgdGhlIGJ1c2luZXNzIGNvbnRpbnVpdHkgZmlyc3QuCkFsc28geW91IGNh
biBsb29rIGF0IGV4dDRfZnJlZV9ibG9ja3MoKSBmb3IgcmVmZXJlbmNlLgoKVGhhbmtzLApKb3Nl
cGgKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCk9jZnMy
LWRldmVsIG1haWxpbmcgbGlzdApPY2ZzMi1kZXZlbEBvc3Mub3JhY2xlLmNvbQpodHRwczovL29z
cy5vcmFjbGUuY29tL21haWxtYW4vbGlzdGluZm8vb2NmczItZGV2ZWw=
