Return-Path: <SRS0=bLRF=KU=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3F8CC2B9F7
	for <ocfs2-devel@archiver.kernel.org>; Tue, 25 May 2021 02:05:21 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 52A2A6113B
	for <ocfs2-devel@archiver.kernel.org>; Tue, 25 May 2021 02:05:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 52A2A6113B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14P25KsO079641;
	Tue, 25 May 2021 02:05:20 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2120.oracle.com with ESMTP id 38rne4064f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 May 2021 02:05:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14P1u9j2023246;
	Tue, 25 May 2021 02:05:19 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 38qbqrs2w0-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 25 May 2021 02:05:18 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1llMRZ-0001zH-Ni; Mon, 24 May 2021 19:05:17 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1llMRA-0001yS-JV
	for ocfs2-devel@oss.oracle.com; Mon, 24 May 2021 19:04:52 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14P1tBAM103982
	for <ocfs2-devel@oss.oracle.com>; Tue, 25 May 2021 02:04:52 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by userp3030.oracle.com with ESMTP id 38pq2tu857-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 25 May 2021 02:04:52 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14P24Dtg046506
	for <ocfs2-devel@oss.oracle.com>; Tue, 25 May 2021 02:04:51 GMT
Received: from out30-45.freemail.mail.aliyun.com
	(out30-45.freemail.mail.aliyun.com [115.124.30.45])
	by userp2040.oracle.com with ESMTP id 38rnjn9yxk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Tue, 25 May 2021 02:04:51 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R451e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04426;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=4; SR=0;
	TI=SMTPD_---0Ua0e85D_1621908284; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0Ua0e85D_1621908284) by smtp.aliyun-inc.com(127.0.0.1);
	Tue, 25 May 2021 10:04:44 +0800
To: Junxiao Bi <junxiao.bi@oracle.com>, ocfs2-devel@oss.oracle.com
References: <20210521233612.75185-1-junxiao.bi@oracle.com>
	<35a1d32b-b8d7-ea9b-d28c-6b4fd837605d@linux.alibaba.com>
	<8aa90f5d-e4db-5107-1d3c-383294871196@oracle.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <21d8b289-541d-50f5-6f86-de3ee69c56c5@linux.alibaba.com>
Date: Tue, 25 May 2021 10:04:44 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <8aa90f5d-e4db-5107-1d3c-383294871196@oracle.com>
Content-Language: en-US
X-PDR: PASS
X-Source-IP: 115.124.30.45
X-ServerName: out30-45.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9994
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
	mlxscore=0 clxscore=227
	malwarescore=0 spamscore=0 phishscore=0 bulkscore=0 adultscore=0
	suspectscore=0 lowpriorityscore=0 priorityscore=0 mlxlogscore=999
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2105250012
X-Spam: Clean
X-MIME-Autoconverted: from 8bit to quoted-printable by userp3030.oracle.com id
	14P1tBAM103982
Cc: linux-fsdevel@vger.kernel.org, jack@suse.cz
Subject: Re: [Ocfs2-devel] [PATCH v2] ocfs2: fix data corruption by fallocate
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9994 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250011
X-Proofpoint-ORIG-GUID: yQsETSLRAxsk-plQkUic9QgCJxUBbEAr
X-Proofpoint-GUID: yQsETSLRAxsk-plQkUic9QgCJxUBbEAr
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9994 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 adultscore=0 clxscore=1034
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105250012

VGhhbmtzIGZvciB0aGUgZXhwbGFuYXRpb25zLgpBIHRpbnkgY2xlYW51cCwgd2UgY2FuIHVzZSAn
b3JpZ19pc2l6ZScgaW5zdGVhZCBvZiBpX3NpemVfcmVhZCgpIGxhdGVyCmluIF9fb2NmczJfY2hh
bmdlX2ZpbGVfc3BhY2UoKS4KT3RoZXIgbG9va3MgZ29vZCB0byBtZS4KUmV2aWV3ZWQtYnk6IEpv
c2VwaCBRaSA8am9zZXBoLnFpQGxpbnV4LmFsaWJhYmEuY29tPgoKT24gNS8yNS8yMSAxMjoyMyBB
TSwgSnVueGlhbyBCaSB3cm90ZToKPiBUaGF0IHdpbGwgbm90IHdvcmssIGJ1ZmZlciB3cml0ZSB6
ZXJvIGZpcnN0LCB0aGVuIHVwZGF0ZSBpX3NpemUsIGluIGJldHdlZW4gd3JpdGViYWNrIGNvdWxk
IGJlIGtpY2tlZCBpbiBhbmQgY2xlYXIgdGhvc2UgZGlydHkgYnVmZmVycyBiZWNhdXNlIHRoZXkg
d2VyZSBvdXQgb2YgaV9zaXplLiBCZXNpZGUgdGhhdCwgT0NGUzJfSU9DX1JFU1ZTUDY0IHdhcyBu
ZXZlciBkb2luZyByaWdodCBqb2IsIGl0IGRpZG4ndCB0YWtlIGNhcmUgZW9mIGJsb2NrcyBpbiB0
aGUgbGFzdCBjbHVzdGVyLCB0aGF0IG1hZGUgZXZlbiBhIHNpbXBsZSBmYWxsb2NhdGUgdG8gZXh0
ZW5kIGZpbGUgc2l6ZSBjb3VsZCBjYXVzZSBjb3JydXB0aW9uLiBUaGlzIHBhdGNoIGZpeGVkIGJv
dGggaXNzdWVzLgo+IAo+IFRoYW5rcywKPiAKPiBKdW54aWFvLgo+IAo+IE9uIDUvMjMvMjEgNDo1
MiBBTSwgSm9zZXBoIFFpIHdyb3RlOgo+PiBIaSBKdW54aWFvLAo+PiBJZiBjaGFuZ2Vfc2l6ZSBp
cyB0cnVlICghRkFMTE9DX0ZMX0tFRVBfU0laRSksIGl0IHdpbGwgdXBkYXRlIGlzaXplCj4+IGlu
IF9fb2NmczJfY2hhbmdlX2ZpbGVfc3BhY2UoKS4gV2h5IGRvIHdlIGhhdmUgdG8gemVyb291dCBm
aXJzdD8KPj4KPj4gVGhhbmtzLAo+PiBKb3NlcGgKPj4KPj4gT24gNS8yMi8yMSA3OjM2IEFNLCBK
dW54aWFvIEJpIHdyb3RlOgo+Pj4gV2hlbiBmYWxsb2NhdGUgcHVuY2hlcyBob2xlcyBvdXQgb2Yg
aW5vZGUgc2l6ZSwgaWYgb3JpZ2luYWwgaXNpemUgaXMgaW4KPj4+IHRoZSBtaWRkbGUgb2YgbGFz
dCBjbHVzdGVyLCB0aGVuIHRoZSBwYXJ0IGZyb20gaXNpemUgdG8gdGhlIGVuZCBvZiB0aGUKPj4+
IGNsdXN0ZXIgd2lsbCBiZSB6ZXJvZWQgd2l0aCBidWZmZXIgd3JpdGUsIGF0IHRoYXQgdGltZSBp
c2l6ZSBpcyBub3QKPj4+IHlldCB1cGRhdGVkIHRvIG1hdGNoIHRoZSBuZXcgc2l6ZSwgaWYgd3Jp
dGViYWNrIGlzIGtpY2tlZCBpbiwgaXQgd2lsbAo+Pj4gaW52b2tlIG9jZnMyX3dyaXRlcGFnZSgp
LT5ibG9ja193cml0ZV9mdWxsX3BhZ2UoKSB3aGVyZSB0aGUgcGFnZXMgb3V0Cj4+PiBvZiBpbm9k
ZSBzaXplIHdpbGwgYmUgZHJvcHBlZC4gVGhhdCB3aWxsIGNhdXNlIGZpbGUgY29ycnVwdGlvbi4g
Rml4Cj4+PiB0aGlzIGJ5IHplcm8gb3V0IGVvZiBibG9ja3Mgd2hlbiBleHRlbmRpbmcgdGhlIGlu
b2RlIHNpemUuCj4+Pgo+Pj4gUnVubmluZyB0aGUgZm9sbG93aW5nIGNvbW1hbmQgd2l0aCBxZW11
LWltYWdlIDQuMi4xIGNhbiBnZXQgYSBjb3JydXB0ZWQKPj4+IGNvdmVydGVkIGltYWdlIGZpbGUg
ZWFzaWx5Lgo+Pj4KPj4+IMKgwqDCoMKgIHFlbXUtaW1nIGNvbnZlcnQgLXAgLXQgbm9uZSAtVCBu
b25lIC1mIHFjb3cyICRxY293X2ltYWdlIFwKPj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IC1PIHFjb3cyIC1vIGNvbXBhdD0xLjEgJHFjb3dfaW1hZ2UuY29udgo+Pj4KPj4+IFRoZSB1c2Fn
ZSBvZiBmYWxsb2NhdGUgaW4gcWVtdSBpcyBsaWtlIHRoaXMsIGl0IGZpcnN0IHB1bmNoZXMgaG9s
ZXMgb3V0IG9mCj4+PiBpbm9kZSBzaXplLCB0aGVuIGV4dGVuZCB0aGUgaW5vZGUgc2l6ZS4KPj4+
Cj4+PiDCoMKgwqDCoCBmYWxsb2NhdGUoMTEsIEZBTExPQ19GTF9LRUVQX1NJWkV8RkFMTE9DX0ZM
X1BVTkNIX0hPTEUsIDIyNzYxOTYzNTIsIDY1NTM2KSA9IDAKPj4+IMKgwqDCoMKgIGZhbGxvY2F0
ZSgxMSwgMCwgMjI3NjE5NjM1MiwgNjU1MzYpID0gMAo+Pj4KPj4+IHYxOiBodHRwczovL3d3dy5z
cGluaWNzLm5ldC9saXN0cy9saW51eC1mc2RldmVsL21zZzE5Mzk5OS5odG1sCj4+Pgo+Pj4gQ2M6
IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPgo+Pj4gQ2M6IEphbiBLYXJhIDxqYWNrQHN1c2UuY3o+
Cj4+PiBTaWduZWQtb2ZmLWJ5OiBKdW54aWFvIEJpIDxqdW54aWFvLmJpQG9yYWNsZS5jb20+Cj4+
PiAtLS0KPj4+Cj4+PiBDaGFuZ2VzIGluIHYyOgo+Pj4gLSBzdWdnZXN0ZWQgYnkgSmFuIEthcmEs
IHVzaW5nIHNiX2lzc3VlX3plcm9vdXQgdG8gemVybyBlb2YgYmxvY2tzIGluIGRpc2sgZGlyZWN0
bHkuCj4+Pgo+Pj4gwqAgZnMvb2NmczIvZmlsZS5jIHwgNDkgKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKystLQo+Pj4gwqAgMSBmaWxlIGNoYW5nZWQsIDQ3IGlu
c2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCj4+Pgo+Pj4gZGlmZiAtLWdpdCBhL2ZzL29jZnMy
L2ZpbGUuYyBiL2ZzL29jZnMyL2ZpbGUuYwo+Pj4gaW5kZXggZjE3YzNkMzNmYjE4Li4xNzQ2OWZj
N2IyMGUgMTAwNjQ0Cj4+PiAtLS0gYS9mcy9vY2ZzMi9maWxlLmMKPj4+ICsrKyBiL2ZzL29jZnMy
L2ZpbGUuYwo+Pj4gQEAgLTE4NTUsNiArMTg1NSw0NSBAQCBpbnQgb2NmczJfcmVtb3ZlX2lub2Rl
X3JhbmdlKHN0cnVjdCBpbm9kZSAqaW5vZGUsCj4+PiDCoMKgwqDCoMKgIHJldHVybiByZXQ7Cj4+
PiDCoCB9Cj4+PiDCoCArLyoKPj4+ICsgKiB6ZXJvIG91dCBwYXJ0aWFsIGJsb2NrcyBvZiBvbmUg
Y2x1c3Rlci4KPj4+ICsgKgo+Pj4gKyAqIHN0YXJ0OiBmaWxlIG9mZnNldCB3aGVyZSB6ZXJvIHN0
YXJ0cywgd2lsbCBiZSBtYWRlIHVwcGVyIGJsb2NrIGFsaWduZWQuCj4+PiArICogbGVuOiBpdCB3
aWxsIGJlIHRyaW1tZWQgdG8gdGhlIGVuZCBvZiBjdXJyZW50IGNsdXN0ZXIgaWYgInN0YXJ0ICsg
bGVuIgo+Pj4gKyAqwqDCoMKgwqDCoCBpcyBiaWdnZXIgdGhhbiBpdC4KPj4+ICsgKi8KPj4+ICtz
dGF0aWMgaW50IG9jZnMyX3plcm9vdXRfcGFydGlhbF9jbHVzdGVyKHN0cnVjdCBpbm9kZSAqaW5v
ZGUsCj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdTY0IHN0YXJ0
LCB1NjQgbGVuKQo+Pj4gK3sKPj4+ICvCoMKgwqAgaW50IHJldDsKPj4+ICvCoMKgwqAgdTY0IHN0
YXJ0X2Jsb2NrLCBlbmRfYmxvY2ssIG5yX2Jsb2NrczsKPj4+ICvCoMKgwqAgdTY0IHBfYmxvY2ss
IG9mZnNldDsKPj4+ICvCoMKgwqAgdTMyIGNsdXN0ZXIsIHBfY2x1c3RlciwgbnJfY2x1c3RlcnM7
Cj4+PiArwqDCoMKgIHN0cnVjdCBzdXBlcl9ibG9jayAqc2IgPSBpbm9kZS0+aV9zYjsKPj4+ICvC
oMKgwqAgdTY0IGVuZCA9IG9jZnMyX2FsaWduX2J5dGVzX3RvX2NsdXN0ZXJzKHNiLCBzdGFydCk7
Cj4+PiArCj4+PiArwqDCoMKgIGlmIChzdGFydCArIGxlbiA8IGVuZCkKPj4+ICvCoMKgwqDCoMKg
wqDCoCBlbmQgPSBzdGFydCArIGxlbjsKPj4+ICsKPj4+ICvCoMKgwqAgc3RhcnRfYmxvY2sgPSBv
Y2ZzMl9ibG9ja3NfZm9yX2J5dGVzKHNiLCBzdGFydCk7Cj4+PiArwqDCoMKgIGVuZF9ibG9jayA9
IG9jZnMyX2Jsb2Nrc19mb3JfYnl0ZXMoc2IsIGVuZCk7Cj4+PiArwqDCoMKgIG5yX2Jsb2NrcyA9
IGVuZF9ibG9jayAtIHN0YXJ0X2Jsb2NrOwo+Pj4gK8KgwqDCoCBpZiAoIW5yX2Jsb2NrcykKPj4+
ICvCoMKgwqDCoMKgwqDCoCByZXR1cm4gMDsKPj4+ICsKPj4+ICvCoMKgwqAgY2x1c3RlciA9IG9j
ZnMyX2J5dGVzX3RvX2NsdXN0ZXJzKHNiLCBzdGFydCk7Cj4+PiArwqDCoMKgIHJldCA9IG9jZnMy
X2dldF9jbHVzdGVycyhpbm9kZSwgY2x1c3RlciwgJnBfY2x1c3RlciwKPj4+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgJm5yX2NsdXN0ZXJzLCBOVUxMKTsKPj4+ICvCoMKgwqAgaWYg
KHJldCkKPj4+ICvCoMKgwqDCoMKgwqDCoCByZXR1cm4gcmV0Owo+Pj4gK8KgwqDCoCBpZiAoIXBf
Y2x1c3RlcikKPj4+ICvCoMKgwqDCoMKgwqDCoCByZXR1cm4gMDsKPj4+ICsKPj4+ICvCoMKgwqAg
b2Zmc2V0ID0gc3RhcnRfYmxvY2sgLSBvY2ZzMl9jbHVzdGVyc190b19ibG9ja3Moc2IsIGNsdXN0
ZXIpOwo+Pj4gK8KgwqDCoCBwX2Jsb2NrID0gb2NmczJfY2x1c3RlcnNfdG9fYmxvY2tzKHNiLCBw
X2NsdXN0ZXIpICsgb2Zmc2V0Owo+Pj4gK8KgwqDCoCByZXR1cm4gc2JfaXNzdWVfemVyb291dChz
YiwgcF9ibG9jaywgbnJfYmxvY2tzLCBHRlBfTk9GUyk7Cj4+PiArfQo+Pj4gKwo+Pj4gwqAgLyoK
Pj4+IMKgwqAgKiBQYXJ0cyBvZiB0aGlzIGZ1bmN0aW9uIHRha2VuIGZyb20geGZzX2NoYW5nZV9m
aWxlX3NwYWNlKCkKPj4+IMKgwqAgKi8KPj4+IEBAIC0xODY1LDcgKzE5MDQsNyBAQCBzdGF0aWMg
aW50IF9fb2NmczJfY2hhbmdlX2ZpbGVfc3BhY2Uoc3RydWN0IGZpbGUgKmZpbGUsIHN0cnVjdCBp
bm9kZSAqaW5vZGUsCj4+PiDCoCB7Cj4+PiDCoMKgwqDCoMKgIGludCByZXQ7Cj4+PiDCoMKgwqDC
oMKgIHM2NCBsbGVuOwo+Pj4gLcKgwqDCoCBsb2ZmX3Qgc2l6ZTsKPj4+ICvCoMKgwqAgbG9mZl90
IHNpemUsIG9yaWdfaXNpemU7Cj4+PiDCoMKgwqDCoMKgIHN0cnVjdCBvY2ZzMl9zdXBlciAqb3Ni
ID0gT0NGUzJfU0IoaW5vZGUtPmlfc2IpOwo+Pj4gwqDCoMKgwqDCoCBzdHJ1Y3QgYnVmZmVyX2hl
YWQgKmRpX2JoID0gTlVMTDsKPj4+IMKgwqDCoMKgwqAgaGFuZGxlX3QgKmhhbmRsZTsKPj4+IEBA
IC0xODk2LDYgKzE5MzUsNyBAQCBzdGF0aWMgaW50IF9fb2NmczJfY2hhbmdlX2ZpbGVfc3BhY2Uo
c3RydWN0IGZpbGUgKmZpbGUsIHN0cnVjdCBpbm9kZSAqaW5vZGUsCj4+PiDCoMKgwqDCoMKgwqDC
oMKgwqAgZ290byBvdXRfaW5vZGVfdW5sb2NrOwo+Pj4gwqDCoMKgwqDCoCB9Cj4+PiDCoCArwqDC
oMKgIG9yaWdfaXNpemUgPSBpX3NpemVfcmVhZChpbm9kZSk7Cj4+PiDCoMKgwqDCoMKgIHN3aXRj
aCAoc3ItPmxfd2hlbmNlKSB7Cj4+PiDCoMKgwqDCoMKgIGNhc2UgMDogLypTRUVLX1NFVCovCj4+
PiDCoMKgwqDCoMKgwqDCoMKgwqAgYnJlYWs7Cj4+PiBAQCAtMTkwMyw3ICsxOTQzLDcgQEAgc3Rh
dGljIGludCBfX29jZnMyX2NoYW5nZV9maWxlX3NwYWNlKHN0cnVjdCBmaWxlICpmaWxlLCBzdHJ1
Y3QgaW5vZGUgKmlub2RlLAo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgIHNyLT5sX3N0YXJ0ICs9IGZf
cG9zOwo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgIGJyZWFrOwo+Pj4gwqDCoMKgwqDCoCBjYXNlIDI6
IC8qU0VFS19FTkQqLwo+Pj4gLcKgwqDCoMKgwqDCoMKgIHNyLT5sX3N0YXJ0ICs9IGlfc2l6ZV9y
ZWFkKGlub2RlKTsKPj4+ICvCoMKgwqDCoMKgwqDCoCBzci0+bF9zdGFydCArPSBvcmlnX2lzaXpl
Owo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgIGJyZWFrOwo+Pj4gwqDCoMKgwqDCoCBkZWZhdWx0Ogo+
Pj4gwqDCoMKgwqDCoMKgwqDCoMKgIHJldCA9IC1FSU5WQUw7Cj4+PiBAQCAtMTk1Nyw2ICsxOTk3
LDExIEBAIHN0YXRpYyBpbnQgX19vY2ZzMl9jaGFuZ2VfZmlsZV9zcGFjZShzdHJ1Y3QgZmlsZSAq
ZmlsZSwgc3RydWN0IGlub2RlICppbm9kZSwKPj4+IMKgwqDCoMKgwqAgZGVmYXVsdDoKPj4+IMKg
wqDCoMKgwqDCoMKgwqDCoCByZXQgPSAtRUlOVkFMOwo+Pj4gwqDCoMKgwqDCoCB9Cj4+PiArCj4+
PiArwqDCoMKgIC8qIHplcm9vdXQgZW9mIGJsb2NrcyBpbiB0aGUgY2x1c3Rlci4gKi8KPj4+ICvC
oMKgwqAgaWYgKCFyZXQgJiYgY2hhbmdlX3NpemUgJiYgb3JpZ19pc2l6ZSA8IHNpemUpCj4+PiAr
wqDCoMKgwqDCoMKgwqAgcmV0ID0gb2NmczJfemVyb291dF9wYXJ0aWFsX2NsdXN0ZXIoaW5vZGUs
IG9yaWdfaXNpemUsCj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
c2l6ZSAtIG9yaWdfaXNpemUpOwo+Pj4gwqDCoMKgwqDCoCB1cF93cml0ZSgmT0NGUzJfSShpbm9k
ZSktPmlwX2FsbG9jX3NlbSk7Cj4+PiDCoMKgwqDCoMKgIGlmIChyZXQpIHsKPj4+IMKgwqDCoMKg
wqDCoMKgwqDCoCBtbG9nX2Vycm5vKHJldCk7Cj4+PgoKX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0Ck9jZnMyLWRl
dmVsQG9zcy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9saXN0aW5m
by9vY2ZzMi1kZXZlbA==
