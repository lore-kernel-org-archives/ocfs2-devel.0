Return-Path: <SRS0=nYl/=OI=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83168C433EF
	for <ocfs2-devel@archiver.kernel.org>; Sat, 18 Sep 2021 02:47:14 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 10D4060240
	for <ocfs2-devel@archiver.kernel.org>; Sat, 18 Sep 2021 02:47:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 10D4060240
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18HLlpTF009299;
	Sat, 18 Sep 2021 02:47:13 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3b4u8st99v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 18 Sep 2021 02:47:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18I2jxow037675;
	Sat, 18 Sep 2021 02:47:11 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3b57ejr89h-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Sat, 18 Sep 2021 02:47:11 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mRQKf-00045y-39; Fri, 17 Sep 2021 19:44:01 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1mRQKA-000453-Sm
	for ocfs2-devel@oss.oracle.com; Fri, 17 Sep 2021 19:43:30 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	18I2aa9d150755
	for <ocfs2-devel@oss.oracle.com>; Sat, 18 Sep 2021 02:43:30 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3020.oracle.com with ESMTP id 3b0m9bme3u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sat, 18 Sep 2021 02:43:30 +0000
Received: from pps.filterd (m0246576.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	18I0vIcB005938
	for <ocfs2-devel@oss.oracle.com>; Sat, 18 Sep 2021 02:43:29 GMT
Received: from out30-56.freemail.mail.aliyun.com
	(out30-56.freemail.mail.aliyun.com [115.124.30.56])
	by mx0b-00069f01.pphosted.com with ESMTP id 3b56188sd7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Sat, 18 Sep 2021 02:43:29 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R111e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e01424;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
	TI=SMTPD_---0UojpA.t_1631933002; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0UojpA.t_1631933002) by smtp.aliyun-inc.com(127.0.0.1);
	Sat, 18 Sep 2021 10:43:23 +0800
To: Wengang Wang <wen.gang.wang@oracle.com>, akpm <akpm@linux-foundation.org>
References: <20210903012631.6099-1-wen.gang.wang@oracle.com>
	<9e8cbfe1-527f-0e75-ba9b-8bcea674645d@linux.alibaba.com>
	<85B74B11-37F6-4FA1-A072-515DF41AE29A@oracle.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <5538daf4-2563-c529-a6ee-8431094187fc@linux.alibaba.com>
Date: Sat, 18 Sep 2021 10:43:22 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <85B74B11-37F6-4FA1-A072-515DF41AE29A@oracle.com>
Content-Language: en-US
X-Source-IP: 115.124.30.56
X-ServerName: out30-56.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10110
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
	bulkscore=0 phishscore=0
	spamscore=0 mlxscore=0 adultscore=0 clxscore=216 mlxlogscore=999
	suspectscore=0 lowpriorityscore=0 impostorscore=0 priorityscore=138
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109030001
	definitions=main-2109180015 domainage_hfrom=8192
X-Spam: Clean
X-MIME-Autoconverted: from 8bit to quoted-printable by aserp3020.oracle.com id
	18I2aa9d150755
Cc: ocfs2-devel ML <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: drop acl cache for directories too
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10110 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109180016
X-Proofpoint-ORIG-GUID: 4kOydKFVPs9k0iAdQEzWe9KmoQByfreC
X-Proofpoint-GUID: 4kOydKFVPs9k0iAdQEzWe9KmoQByfreC

SXQgaGFzIGFscmVhZHkgYmVlbiBhZGRlZCBpbiAtbW0gdHJlZS4KClRoYW5rcywKSm9zZXBoCgpP
biA5LzE4LzIxIDEyOjQ2IEFNLCBXZW5nYW5nIFdhbmcgd3JvdGU6Cj4gSGkgQW5kcmV3LAo+IAo+
IENhbiB5b3UgcGxzIG1lcmdlIHRoaXMgcGF0Y2ggaWYgaXTigJlzIG5vdCBhbHJlYWR5IG9uIHRo
ZSB3YXk/Cj4gCj4gdGhhbmtzLAo+IHdlbmdhbmcKPiAKPiBPbiBTZXAgNiwgMjAyMSwgYXQgNDo0
MiBBTSwgSm9zZXBoIFFpIDxqb3NlcGgucWlAbGludXguYWxpYmFiYS5jb208bWFpbHRvOmpvc2Vw
aC5xaUBsaW51eC5hbGliYWJhLmNvbT4+IHdyb3RlOgo+IAo+IAo+IAo+IE9uIDkvMy8yMSA5OjI2
IEFNLCBXZW5nYW5nIFdhbmcgd3JvdGU6Cj4gb2NmczJfZGF0YV9jb252ZXJ0X3dvcmtlcigpIGlz
IGN1cnJlbnRseSBkcm9wcGluZyBhbnkgY2FjaGVkIGFjbCBpbmZvCj4gZm9yIEZJTEUgYmVmb3Jl
IGRvd24tY29udmVydGluZyBtZXRhIGxvY2suIEl0IHNob3VsZCBhbHNvIGRyb3AgZm9yIERJUkVD
VE9SWS4KPiBPdGhlcndpc2UgdGhlIHNlY29uZCBhY2wgbG9va3VwIHJldHVybnMgdGhlIGNhY2hl
ZCBvbmUgKGZyb20gVkZTIGxheWVyKSB3aGljaAo+IGNvdWxkIGJlIGFscmVhZHkgc3RhbGUuCj4g
Cj4gVGhlIHByb2JsZW0gd2UgYXJlIHNlZWluZyBpcyB0aGF0IHRoZSBhY2wgY2hhbmdlcyBvbiBv
bmUgbm9kZSBkb2Vzbid0IGdldAo+IHJlZnJlc2hlZCBvbiBvdGhlciBub2RlcyBpbiB0aGUgZm9s
bG93aW5nIGNhc2U6Cj4gCj4gIE5vZGUgMSAgICAgICAgICAgICAgICAgICAgTm9kZSAyCj4gLS0t
LS0tLS0tLS0tLS0gICAgICAgICAgICAtLS0tLS0tLS0tLS0tLS0tCj4gZ2V0ZmFjbCBkaXIxCj4g
Cj4gICBnZXRmYWNsIGRpcjEgICAgPC0tIHRoaXMgaXMgT0sKPiAKPiBzZXRmYWNsIC1tIHU6dXNl
cjE6cndYIGRpcjEKPiBnZXRmYWNsIGRpcjEgICA8LS0gc2VlIHRoZSBjaGFuZ2UgZm9yIHVzZXIx
Cj4gCj4gICBnZXRmYWNsIGRpcjEgICAgPC0tIGNhbid0IHNlZSBjaGFuZ2UgZm9yIHVzZXIxCj4g
Cj4gU2lnbmVkLW9mZi1ieTogV2VuZ2FuZyBXYW5nIDx3ZW4uZ2FuZy53YW5nQG9yYWNsZS5jb208
bWFpbHRvOndlbi5nYW5nLndhbmdAb3JhY2xlLmNvbT4+Cj4gCj4gTG9va3Mgc2FuZSB0byBtZS4K
PiBSZXZpZXdlZC1ieTogSm9zZXBoIFFpIDxqb3NlcGgucWlAbGludXguYWxpYmFiYS5jb208bWFp
bHRvOmpvc2VwaC5xaUBsaW51eC5hbGliYWJhLmNvbT4+Cj4gCj4gLS0tCj4gZnMvb2NmczIvZGxt
Z2x1ZS5jIHwgMyArKy0KPiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0
aW9uKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2ZzL29jZnMyL2RsbWdsdWUuYyBiL2ZzL29jZnMyL2Rs
bWdsdWUuYwo+IGluZGV4IDUwYTg2M2ZjMTc3OS4uMjA3ZWM2MTU2OWVhIDEwMDY0NAo+IC0tLSBh
L2ZzL29jZnMyL2RsbWdsdWUuYwo+ICsrKyBiL2ZzL29jZnMyL2RsbWdsdWUuYwo+IEBAIC0zOTMz
LDcgKzM5MzMsNyBAQCBzdGF0aWMgaW50IG9jZnMyX2RhdGFfY29udmVydF93b3JrZXIoc3RydWN0
IG9jZnMyX2xvY2tfcmVzICpsb2NrcmVzLAo+IG9pID0gT0NGUzJfSShpbm9kZSk7Cj4gb2ktPmlw
X2Rpcl9sb2NrX2dlbisrOwo+IG1sb2coMCwgImdlbmVyYXRpb246ICV1XG4iLCBvaS0+aXBfZGly
X2xvY2tfZ2VuKTsKPiAtIGdvdG8gb3V0Owo+ICsgZ290byBvdXRfZm9yZ2V0Owo+IH0KPiAKPiBp
ZiAoIVNfSVNSRUcoaW5vZGUtPmlfbW9kZSkpCj4gQEAgLTM5NjQsNiArMzk2NCw3IEBAIHN0YXRp
YyBpbnQgb2NmczJfZGF0YV9jb252ZXJ0X3dvcmtlcihzdHJ1Y3Qgb2NmczJfbG9ja19yZXMgKmxv
Y2tyZXMsCj4gZmlsZW1hcF9mZGF0YXdhaXQobWFwcGluZyk7Cj4gfQo+IAo+ICtvdXRfZm9yZ2V0
Ogo+IGZvcmdldF9hbGxfY2FjaGVkX2FjbHMoaW5vZGUpOwo+IAo+IG91dDoKPiAKCl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCk9jZnMyLWRldmVsIG1haWxp
bmcgbGlzdApPY2ZzMi1kZXZlbEBvc3Mub3JhY2xlLmNvbQpodHRwczovL29zcy5vcmFjbGUuY29t
L21haWxtYW4vbGlzdGluZm8vb2NmczItZGV2ZWw=
