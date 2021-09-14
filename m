Return-Path: <SRS0=S4JQ=OE=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B945BC433EF
	for <ocfs2-devel@archiver.kernel.org>; Tue, 14 Sep 2021 02:13:11 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 43C9561151
	for <ocfs2-devel@archiver.kernel.org>; Tue, 14 Sep 2021 02:13:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 43C9561151
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18E1UWK3024039;
	Tue, 14 Sep 2021 02:13:10 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3b2j4s82h1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Sep 2021 02:13:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18E25Ale020766;
	Tue, 14 Sep 2021 02:13:09 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3b0hjucjtf-1;
	Tue, 14 Sep 2021 02:13:08 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mPxwa-00045U-3j; Mon, 13 Sep 2021 19:13:08 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1mPxw2-00043m-Fi
	for ocfs2-devel@oss.oracle.com; Mon, 13 Sep 2021 19:12:34 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	18E26MLj017709
	for <ocfs2-devel@oss.oracle.com>; Tue, 14 Sep 2021 02:12:34 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3020.oracle.com with ESMTP id 3b0m95k2jp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 14 Sep 2021 02:12:34 +0000
Received: from pps.filterd (m0246574.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	18DLN2Xq014308
	for <ocfs2-devel@oss.oracle.com>; Tue, 14 Sep 2021 02:12:33 GMT
Received: from out4436.biz.mail.alibaba.com (out4436.biz.mail.alibaba.com
	[47.88.44.36])
	by mx0b-00069f01.pphosted.com with ESMTP id 3b2egajy8f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Tue, 14 Sep 2021 02:12:32 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R171e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04407;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=8; SR=0;
	TI=SMTPD_---0UoK3sb3_1631585538; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0UoK3sb3_1631585538) by smtp.aliyun-inc.com(127.0.0.1);
	Tue, 14 Sep 2021 10:12:18 +0800
To: Wengang Wang <wen.gang.wang@oracle.com>
References: <20210908102055.10168-1-cymi20@fudan.edu.cn>
	<06d9e055-29b9-731c-5a36-d888f2c83188@linux.alibaba.com>
	<6018AF95-3613-4D43-A3E6-7BAA0E0BE009@oracle.com>
	<c48fb54e-0dd9-42c7-f53d-2ea58fb97255@linux.alibaba.com>
	<CED0D2AD-7905-490E-8D36-50D192CD9BF1@oracle.com>
	<ee86ea1a-0348-e975-3c67-8d574eaadbe3@linux.alibaba.com>
	<70C24A61-6E9C-43D8-BB43-1D56A8081E19@oracle.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <7545fe52-98f2-e845-c40d-706fada8252f@linux.alibaba.com>
Date: Tue, 14 Sep 2021 10:12:17 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <70C24A61-6E9C-43D8-BB43-1D56A8081E19@oracle.com>
Content-Language: en-US
X-Source-IP: 47.88.44.36
X-ServerName: out4436.biz.mail.alibaba.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10106
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=185
	phishscore=0 adultscore=0
	spamscore=0 mlxscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
	impostorscore=0 priorityscore=0 lowpriorityscore=0 malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109030001
	definitions=main-2109140012 domainage_hfrom=8188
X-Spam: Clean
X-MIME-Autoconverted: from 8bit to quoted-printable by aserp3020.oracle.com id
	18E26MLj017709
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10106 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109140012
X-Proofpoint-ORIG-GUID: KqraL9TVEUS8FLOs1NkpzCw87wUpgTHU
X-Proofpoint-GUID: KqraL9TVEUS8FLOs1NkpzCw87wUpgTHU

CgpPbiA5LzExLzIxIDE6MDAgQU0sIFdlbmdhbmcgV2FuZyB3cm90ZToKPiAKPiAKPj4gT24gU2Vw
IDksIDIwMjEsIGF0IDY6NTMgUE0sIEpvc2VwaCBRaSA8am9zZXBoLnFpQGxpbnV4LmFsaWJhYmEu
Y29tPiB3cm90ZToKPj4KPj4KPj4KPj4gT24gOS8xMC8yMSAxOjQ4IEFNLCBXZW5nYW5nIFdhbmcg
d3JvdGU6Cj4+Pgo+Pj4KPj4+IE9uIFNlcCA5LCAyMDIxLCBhdCA0OjA3IEFNLCBKb3NlcGggUWkg
PGpvc2VwaC5xaUBsaW51eC5hbGliYWJhLmNvbTxtYWlsdG86am9zZXBoLnFpQGxpbnV4LmFsaWJh
YmEuY29tPj4gd3JvdGU6Cj4+Pgo+Pj4gSGkgV2VuZ2FuZywKPj4+Cj4+PiBPbiA5LzkvMjEgMTox
MiBBTSwgV2VuZ2FuZyBXYW5nIHdyb3RlOgo+Pj4gSGksCj4+Pgo+Pj4gU29ycnkgZm9yIGxhdGUg
aW52b2x2aW5nLCBidXQgdGhpcyBkb2VzbuKAmXQgbG9vayByaWdodCB0byBtZS4KPj4+Cj4+PiBP
biBTZXAgOCwgMjAyMSwgYXQgMzo1MSBBTSwgSm9zZXBoIFFpIDxqb3NlcGgucWlAbGludXguYWxp
YmFiYS5jb208bWFpbHRvOmpvc2VwaC5xaUBsaW51eC5hbGliYWJhLmNvbT4+IHdyb3RlOgo+Pj4K
Pj4+Cj4+Pgo+Pj4gT24gOS84LzIxIDY6MjAgUE0sIENoZW55dWFuIE1pIHdyb3RlOgo+Pj4gVGhl
IHJlZmVyZW5jZSBjb3VudGluZyBpc3N1ZSBoYXBwZW5zIGluIHR3byBleGNlcHRpb24gaGFuZGxp
bmcgcGF0aHMKPj4+IG9mIG9jZnMyX3JlcGxheV90cnVuY2F0ZV9yZWNvcmRzKCkuIFdoZW4gZXhl
Y3V0aW5nIHRoZXNlIHR3byBleGNlcHRpb24KPj4+IGhhbmRsaW5nIHBhdGhzLCB0aGUgZnVuY3Rp
b24gZm9yZ2V0cyB0byBkZWNyZWFzZSB0aGUgcmVmY291bnQgb2YgaGFuZGxlCj4+PiBpbmNyZWFz
ZWQgYnkgb2NmczJfc3RhcnRfdHJhbnMoKSwgY2F1c2luZyBhIHJlZmNvdW50IGxlYWsuCj4+Pgo+
Pj4gRml4IHRoaXMgaXNzdWUgYnkgdXNpbmcgb2NmczJfY29tbWl0X3RyYW5zKCkgdG8gZGVjcmVh
c2UgdGhlIHJlZmNvdW50Cj4+PiBvZiBoYW5kbGUgaW4gdHdvIGhhbmRsaW5nIHBhdGhzLgo+Pj4K
Pj4+IFNpZ25lZC1vZmYtYnk6IENoZW55dWFuIE1pIDxjeW1pMjBAZnVkYW4uZWR1LmNuPG1haWx0
bzpjeW1pMjBAZnVkYW4uZWR1LmNuPj4KPj4+IFNpZ25lZC1vZmYtYnk6IFhpeXUgWWFuZyA8eGl5
dXlhbmcxOUBmdWRhbi5lZHUuY248bWFpbHRvOnhpeXV5YW5nMTlAZnVkYW4uZWR1LmNuPj4KPj4+
IFNpZ25lZC1vZmYtYnk6IFhpbiBUYW4gPHRhbnhpbi5jdGZAZ21haWwuY29tPG1haWx0bzp0YW54
aW4uY3RmQGdtYWlsLmNvbT4+Cj4+Pgo+Pj4gUmV2aWV3ZWQtYnk6IEpvc2VwaCBRaSA8am9zZXBo
LnFpQGxpbnV4LmFsaWJhYmEuY29tPG1haWx0bzpqb3NlcGgucWlAbGludXguYWxpYmFiYS5jb20+
Pgo+Pj4gLS0tCj4+PiBmcy9vY2ZzMi9hbGxvYy5jIHwgMiArKwo+Pj4gMSBmaWxlIGNoYW5nZWQs
IDIgaW5zZXJ0aW9ucygrKQo+Pj4KPj4+IGRpZmYgLS1naXQgYS9mcy9vY2ZzMi9hbGxvYy5jIGIv
ZnMvb2NmczIvYWxsb2MuYwo+Pj4gaW5kZXggZjFjYzgyNThkMzRhLi5iMDVmZGU3ZWRjM2EgMTAw
NjQ0Cj4+PiAtLS0gYS9mcy9vY2ZzMi9hbGxvYy5jCj4+PiArKysgYi9mcy9vY2ZzMi9hbGxvYy5j
Cj4+PiBAQCAtNTk0MCw2ICs1OTQwLDcgQEAgc3RhdGljIGludCBvY2ZzMl9yZXBsYXlfdHJ1bmNh
dGVfcmVjb3JkcyhzdHJ1Y3Qgb2NmczJfc3VwZXIgKm9zYiwKPj4+IHN0YXR1cyA9IG9jZnMyX2pv
dXJuYWxfYWNjZXNzX2RpKGhhbmRsZSwgSU5PREVfQ0FDSEUodGxfaW5vZGUpLCB0bF9iaCwKPj4+
IE9DRlMyX0pPVVJOQUxfQUNDRVNTX1dSSVRFKTsKPj4+IGlmIChzdGF0dXMgPCAwKSB7Cj4+PiAr
IG9jZnMyX2NvbW1pdF90cmFucyhvc2IsIGhhbmRsZSk7Cj4+PiBtbG9nX2Vycm5vKHN0YXR1cyk7
Cj4+PiBnb3RvIGJhaWw7Cj4+PiB9Cj4+PiBAQCAtNTk2NCw2ICs1OTY1LDcgQEAgc3RhdGljIGlu
dCBvY2ZzMl9yZXBsYXlfdHJ1bmNhdGVfcmVjb3JkcyhzdHJ1Y3Qgb2NmczJfc3VwZXIgKm9zYiwK
Pj4+ICAgICBkYXRhX2FsbG9jX2JoLCBzdGFydF9ibGssCj4+PiAgICAgbnVtX2NsdXN0ZXJzKTsK
Pj4+IGlmIChzdGF0dXMgPCAwKSB7Cj4+PiArIG9jZnMyX2NvbW1pdF90cmFucyhvc2IsIGhhbmRs
ZSk7Cj4+Pgo+Pj4gQXMgYSB0cmFuc2FjdGlvbiwgc3R1ZmYgZXhwZWN0ZWQgdG8gYmUgaW4gdGhl
IHNhbWUgaGFuZGxlIHNob3VsZCBiZSB0cmVhdGVkIGFzIGF0b21pYy4KPj4+IEhlcmUgdGhlIHN0
dWZmIGluY2x1ZGVzIHRoZSB0bF9iaCBhbmQgb3RoZXIgbWV0YWRhdGEgYmxvY2sgd2hpY2ggd2ls
bCBiZSBtb2RpZmllZCBpbiBvY2ZzMl9mcmVlX2NsdXN0ZXJzKCkuCj4+PiBDb21pbmcgaGVyZSwg
c29tZSBvZiByZWxhdGVkIG1ldGEgYmxvY2tzIG1heSBiZSBpbiB0aGUgaGFuZGxlIGJ1dCBvdGhl
cnMgYXJlIG5vdCBkdWUgdG8gdGhlIGVycm9yIGhhcHBlbmVkLgo+Pj4gSWYgeW91IGRvIGEgY29t
bWl0LCBwYXJ0aWFsIG1ldGEgYmxvY2tzIGFyZSBjb21taXR0ZWQgdG8gbG9nLiDigJQgdGhhdCBi
cmVha3MgdGhlIGF0b21pYyBpZGVhLCBpdCB3aWxsIGNhdXNlIEZTIGluY29uc2lzdGVuY3kuCj4+
PiBTbyB3aGF04oCZcyByZWFzb24geW91IHdhbnQgdG8gY29tbWl0IHRoZSBtZXRhIGJsb2NrIGNo
YW5nZXMsIHdoaWNoIGlzIG5vdCBhbGwgb2YgZXhwZWN0ZWQsIGluIHRoaXMgaGFuZGxlIHRvIGpv
dXJuYWwgbG9nPwo+Pj4KPj4+IERvIHlvdSByZWFsbHkgc2VlIGEgaGl0IG9uIHRoZSBmYWlsdXJl
PyBvciBqdXN0IHlvdSBkZXRlY3RlZCB0aGUgcmVmY291bnQgbGVhayBieSBjb2RlIHJldmlldz8K
Pj4+Cj4+PiBZb3UgbWF5IHdhbnQgdG8gbG9vayBhdCBvY2ZzMl9qb3VybmFsX2RpcnR5KCkgZm9y
IHRoZSBlcnJvciBoYW5kbGluZyBwYXJ0Lgo+Pj4KPj4+Cj4+PiBGb3IgdGhlIGZpcnN0IGVycm9y
IGhhbmRsaW5nLCBzaW5jZSB3ZSBkb24ndCBjYWxsIG9jZnMyX2pvdXJuYWxfZGlydHkoKQo+Pj4g
eWV0LCBzbyB3b24ndCBiZSBhIHByb2JsZW0uCj4+PiBGb3IgdGhlIHNlY29uZCBlcnJvciBoYW5k
bGluZywgSSB0aGluayB3ZSBkb24ndCBoYXZlIGEgYmV0dGVyIHdheS4gTG9vawo+Pj4gYXQgb3Ro
ZXIgY2FsbGVycyBvZiBvY2ZzMl9mcmVlX2NsdXN0ZXJzKCksIHdlIHNpbXBseSBpZ25vcmUgdGhl
IGVycm9yCj4+PiBjb2RlLgo+Pj4gQW55d2F5LCB3ZSBzaG91bGQgY29tbWl0IHRyYW5zYWN0aW9u
IGlmIHN0YXJ0cywgb3RoZXJ3aXNlIGpvdXJuYWwgd2lsbAo+Pj4gYmUgYWJub3JtYWwuCj4+Pgo+
Pj4gSSBkb24ndCB0aGluayBzby4gSWYgZXJyb3IgaGFwcGVuZWQsIHdlIHNob3VsZCBmYWlsIG9j
ZnMyLCByYXRoZXIgdGhhbiBkbyBhIHBhcnRpYWwgY29tbWl0dGluZy4KPj4+Cj4+Cj4+IFVtbS4u
LiBub3QgZXhhY3RseS4uLgo+PiBUYWtlIG9jZnMyX2ZyZWVfY2x1c3RlcnMoKSBmb3IgZXhhbXBs
ZSwgd2hlbiBpdCBmYWlscyBpbiBjYXNlIG9mIEVJTyBvcgo+PiBFTk9NRU0sIHdlIGNhbid0IGp1
c3QgYWJvcnQgam91cm5hbCBpbiBzdWNoIGNhc2VzLCBiZWNhdXNlIGl0IGlzIG5vdCBzbwo+PiBz
ZXJpb3VzLCBvbmx5IGEgYml0IGJsb2NrcyBzdGlsbCBvY2N1cGllZCBhbmQgdGhleSB3aWxsIHJl
Y292ZXJ5IGR1cmluZwo+PiB0aGUgbmV4dCBtb3VudC4gCj4gCj4gU28gYXJlIHlvdSBzdXJlIGEg
cGFydGlhbCBqb3VybmFsIGNvbW1pdG1lbnQgd29u4oCZdCBjYXVzZSBGUyBpbmNvbnNpc3RlbmN5
PyBhbnkgcHJvb2YgZm9yIHRoYXQ/Cj4gUHJvYmxlbSBpcyBub3QganVzdCBpZiB3ZSBjYW4gdHJ5
IHRvIGZyZWUgdGhlIGJsb2NrcyBhZ2FpbiBvciBub3QuIFRoZSBwcm9ibGVtIGlzIEZTIGluIGlu
Y29uc2lzdGVudCBzdGF0ZS4KPiAKPiBJIGRpZG7igJl0IGxvb2sgaW50byBvY2ZzMl9mcmVlX2Ns
dXN0ZXJzKCkgZnVydGhlciwgYnV0IGNhbiBpbWFnZSB0aGlzIGNhc2U6Cj4gCj4gMSkgV2UgYXJl
IGdvaW5nIHRvIGZyZWUgc29tZSBjbHVzdGVycy9ibG9ja3MuIAo+IDIpIFdlIG1heSBuZWVkIGEg
bmV3IChub3QgbWVyZ2luZyBpbnRvIGV4aXN0aW5nKSByZWNvcmQgdG8gcmVtZW1iZXIgdGhlIG5l
dyBmcmVlIGV4dGVudC4gCj4gMykgVGhlIG5ldyByZWNvcmQgbmVlZHMgdG8gYmUgaW5zZXJ0ZWQg
aW50byBmcmVlIGV4dGVudCB0cmVlLgo+IDQpIHRoZSBibG9jayAoYmxvY2sgQSkgd2hlcmUgdGhl
IG5ldyByZWNvcmQgdG8gYmUgaW5zZXJ0ZWQgY291bGQgYmUgYWxyZWFkeSBmdWxsIHRodXMgbm8g
c3BhY2UgZm9yIHRoZSBuZXcgcmVjb3JkLgo+IDUpIHRoZW4gd2UgbmVlZCBhdCBsZWFzdCBhIG5l
dyBibG9jayAoYmxvY2sgQikgdG8gc3RvcmUgdGhlIG5ldyByZWNvcmQuICh0byBtYWludGFpbiB0
aGUgZnJlZSBibG9jayBidHJlZSwgbWF5YmUgYW5vdGhlciBibG9jaywgYmxvY2sgQyBpcyBuZWVk
ZWQgdG9vKS4KPiA2KSBTbyB3ZSBuZWVkIHRvIHNhdmUgdGhlIHBvaW50ZXIgKGJsb2NrIG51bWJl
cikgb2YgYmxvY2sgQiBpbiBibG9jayBBIGFuZCBzdG9yZSB0aGUgbmV3IHJlY29yZCBpbiBibG9j
ayBCLgo+IDcpIEluIHRoaXMgY2FzZSB3ZSBuZWVkIHRvIG1ha2Ugc3VyZSBibG9jayBBIGFuZCBi
bG9jayBCIGVpdGhlciBib3RoIGluIGpvdXJuYWwgbG9nLCBvciBub25lIG9mIHRoZW0gaW4gam91
cm5hbCBsb2cuICBXZSBkb27igJl0IGFsbG93IGJsb2NrIEEgaXMgaW4gam91cm5hbCBib3QgYmxv
Y2sgQiBpcyBub3QsIHJpZ2h0Pwo+IAo+IGdvIGJhY2sgdG8gcXVlc3Rpb24sICAgRXJyb3IgY291
bGQgYWZ0ZXIgYmxvY2sgQiBpcyBhZGRlZCB0byBqb3VybmFsIGhhbmRsZSBidXQgYmVmb3JlIGJs
b2NrIEEgaXMgYWRkZWQuIEluIGNhc2Ugd2UgZG8gYSBqb3VybmFsIGNvbW1pdCB3aGVuIGhpdHRp
bmcgdGhhdCBlcnJvciwgd2UgYXJlIGNvbW1pdHRpbmcgYmxvY2sgQiB0byBqb3VybmFsIGJ1dCBs
ZWF2aW5nIGJsb2NrIEEgbm90IGluLgo+IElmIHBhbmljIGhhcHBlbmVkLCBibG9jayBBIGNvdWxk
IG5ldmVyIGhhcyB0aGUgcG9pbnRlciBwb2ludGluZyB0byBibG9jayBCLiBUaGUgcmVzdWx0IGlz
IGJsb2NrIEIgaXMgcGVybWFuZW50bHkgbG9zdCAod2UgY2FuIG5ldmVyIHJldXNlIHRoaXMgYmxv
Y2sgYWdhaW4pLiAKPiBPciBpZiB3ZSBhZGQgYmxvY2sgQSB0byBqb3VybmFsIGZpcnN0IGJlZm9y
ZSBhZGRpbmcgYmxvY2sgQiBhbmQgZXJyb3IgaGFwcGVucyBBZnRlciBibG9jayBBIGlzIGFkZGVk
IGFuZCBiZWZvcmUgYmxvY2sgQiBpcyBhZGRlZC4gIFRoZW4gd2UgaGF2ZSB0aGUgcG9pbnRlciBw
b2ludGluZyB0byBibG9jayBCIGluIGJsb2NrIEEgYWZ0ZXIgcGFuaWMsIGJ1dCBibG9jayBCIGRv
ZXNu4oCZdCBjb250YWluIHZhbGlkIGNvbnRlbnRzLiBUaGUgcmVzdWx0IGlzIHRoYXQgd2Ugd2ls
bCBoaXQgcHJvYmxlbSB3aGVuIHZpc2l0aW5nIGJsb2NrIEIgYXMgYSB2YWxpZCBidHJlZSBibG9j
ay4KPiAKPiAKPj4gVGhhdCdzIHdoeSB3ZSBoYXZlICJlcnJvcnM9Y29udGludWUiIGluIG1vc3Qg
ZmlsZXN5c3RlbXMsIHdlIHNob3VsZCBhbHdheXMKPj4gY29uc2lkZXIgdGhlIGJ1c2luZXNzIGNv
bnRpbnVpdHkgZmlyc3QuCj4+IEFsc28geW91IGNhbiBsb29rIGF0IGV4dDRfZnJlZV9ibG9ja3Mo
KSBmb3IgcmVmZXJlbmNlLgo+IAo+IE9DRlMyIGRvZXNu4oCZdCBzdXBwb3J0IEVSUk9SU19DT05U
LCBvciB0byBzYXkgaXQganVzdCBpZ25vcmUgdGhhdCBvcHRpb24uICBObyBtYXR0ZXIgRVJST1JT
X0NPTlQgaXMgc3VwcG9ydGVkIG9yIG5vdCBieSBPQ0ZTMiwKPiBUaGUga2V5IGlzIG5vdCB0byBs
ZWF2ZSB0aGUgRlMgaW4gaW5jb25zaXN0ZW50IHN0YXRlLgo+IAoKSSBkaWRuJ3Qgc2F5IGl0IHdv
bid0IGNhdXNlIGluY29uc2lzdGVuY3ksIGJ1dCAiZG9uJ3QgaGF2ZSBhIGJldHRlciB3YXkiLgpJ
SVVDLCBvY2ZzMl9mcmVlX2NsdXN0ZXIoKSBtYWlubHkgY2xlYXJzIHRoZSBiaXRtYXAgYW5kIG1h
cmsgdGhlbSBmcmVlIGFnYWluLgpTbyB0aGUgbG9zdCBzcGFjZSBpcyBzb21lIHdoYXQgYSBjb3N0
IGZvciAicGxlYXNlIGRvbid0IGFib3J0IGJ1c2luZXNzIGlmCmVycm9yIGhhcHBlbnMgYnV0IG5v
dCBiZSBzbyBzZXJpb3VzIi4gSSB0aGluayB0aGF0J3Mgd2h5IG90aGVyIGNhbGxlcnMgd2lsbAph
bHNvIGNvbW1pdCB0cmFuc2FjdGlvbiBldmVuIG9jZnMyX2ZyZWVfY2x1c3RlcigpIGZhaWxzLgoK
VGhhbmtzLApKb3NlcGgKCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5nIGxpc3QKT2NmczItZGV2ZWxAb3NzLm9yYWNsZS5j
b20KaHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9tYWlsbWFuL2xpc3RpbmZvL29jZnMyLWRldmVs
