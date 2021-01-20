Return-Path: <SRS0=k8OJ=GX=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C279EC433E0
	for <ocfs2-devel@archiver.kernel.org>; Wed, 20 Jan 2021 01:50:50 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 57D112250E
	for <ocfs2-devel@archiver.kernel.org>; Wed, 20 Jan 2021 01:50:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 57D112250E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10K1iMqO141585;
	Wed, 20 Jan 2021 01:50:49 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2120.oracle.com with ESMTP id 3668qmrbjf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Jan 2021 01:50:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10K1ne3S098588;
	Wed, 20 Jan 2021 01:50:48 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3668rc6qb7-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 20 Jan 2021 01:50:47 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l22dy-0007my-Tr; Tue, 19 Jan 2021 17:50:46 -0800
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1l22dV-0007gM-0k
	for ocfs2-devel@oss.oracle.com; Tue, 19 Jan 2021 17:50:17 -0800
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10K1ibY0060720
	for <ocfs2-devel@oss.oracle.com>; Wed, 20 Jan 2021 01:50:16 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by userp3020.oracle.com with ESMTP id 3668qv665k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 20 Jan 2021 01:50:16 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10K1i7HT012392
	for <ocfs2-devel@oss.oracle.com>; Wed, 20 Jan 2021 01:50:16 GMT
Received: from out30-56.freemail.mail.aliyun.com
	(out30-56.freemail.mail.aliyun.com [115.124.30.56])
	by userp2030.oracle.com with ESMTP id 3668s69xr6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Wed, 20 Jan 2021 01:50:15 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R111e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04400;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
	TI=SMTPD_---0UMHoiin_1611107408; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0UMHoiin_1611107408) by smtp.aliyun-inc.com(127.0.0.1);
	Wed, 20 Jan 2021 09:50:09 +0800
To: guozh <guozh88@chinatelecom.cn>, akpm <akpm@linux-foundation.org>,
        ocfs2-devel <ocfs2-devel@oss.oracle.com>
References: <2021011916182284700534@chinatelecom.cn>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <68478eed-1c1e-6769-54b2-7797a91ce9dc@linux.alibaba.com>
Date: Wed, 20 Jan 2021 09:50:08 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <2021011916182284700534@chinatelecom.cn>
Content-Language: en-US
X-PDR: PASS
X-Source-IP: 115.124.30.56
X-ServerName: out30-56.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9869
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=105
	lowpriorityscore=0
	adultscore=0 spamscore=0 priorityscore=123 mlxscore=0 bulkscore=0
	impostorscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
	phishscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2101200007
X-Spam: Clean
X-MIME-Autoconverted: from 8bit to quoted-printable by userp3020.oracle.com id
	10K1ibY0060720
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: cleanup some definitions which is
 not used anymore.
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
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9869 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101200008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9869 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 adultscore=0 impostorscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1034 bulkscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101200007

CgpPbiAxLzE5LzIxIDQ6MTggUE0sIGd1b3poIHdyb3RlOgo+IFRoZXJlIGFyZSBzb21lIGRlZmlu
aXRpb25zIHdoaWNoIGlzIG5vdCB1c2VkIGFueW1vcmUgaW4gT0NGUzIgbW9kdWxlLCBzbyBhcyB0
byBiZSByZW1vdmVkLgo+IAo+IFNpZ25lZC1vZmYtYnk6IEd1b3pob25naHVhIDxndW96aDg4QGNo
aW5hdGVsZWNvbS5jbj4KCkFja2VkLWJ5OiBKb3NlcGggUWkgPGpvc2VwaC5xaUBsaW51eC5hbGli
YWJhLmNvbT4KPiAtLS0KPiDCoGZzL29jZnMyL2RsbS9kbG1hc3QuYyDCoCDCoHwgMTAgLS0tLS0t
LS0tLQo+IMKgZnMvb2NmczIvZGxtL2RsbWNvbW1vbi5oIHwgwqA0IC0tLS0KPiDCoDIgZmlsZXMg
Y2hhbmdlZCwgMTQgZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2ZzL29jZnMyL2RsbS9k
bG1hc3QuYyBiL2ZzL29jZnMyL2RsbS9kbG1hc3QuYwo+IGluZGV4IDZhYmFkZWQzZmY2Yi4uNzBh
MTA3NjRmMjQ5IDEwMDY0NAo+IC0tLSBhL2ZzL29jZnMyL2RsbS9kbG1hc3QuYwo+ICsrKyBiL2Zz
L29jZnMyL2RsbS9kbG1hc3QuYwo+IEBAIC0xNjUsMTYgKzE2NSw2IEBAIHZvaWQgX19kbG1fcXVl
dWVfYmFzdChzdHJ1Y3QgZGxtX2N0eHQgKmRsbSwgc3RydWN0IGRsbV9sb2NrICpsb2NrKQo+IMKg
CXNwaW5fdW5sb2NrKCZsb2NrLT5zcGlubG9jayk7Cj4gwqB9Cj4gwqAKPiAtdm9pZCBkbG1fcXVl
dWVfYmFzdChzdHJ1Y3QgZGxtX2N0eHQgKmRsbSwgc3RydWN0IGRsbV9sb2NrICpsb2NrKQo+IC17
Cj4gLQlCVUdfT04oIWRsbSk7Cj4gLQlCVUdfT04oIWxvY2spOwo+IC0KPiAtCXNwaW5fbG9jaygm
ZGxtLT5hc3RfbG9jayk7Cj4gLQlfX2RsbV9xdWV1ZV9iYXN0KGRsbSwgbG9jayk7Cj4gLQlzcGlu
X3VubG9jaygmZGxtLT5hc3RfbG9jayk7Cj4gLX0KPiAtCj4gwqBzdGF0aWMgdm9pZCBkbG1fdXBk
YXRlX2x2YihzdHJ1Y3QgZGxtX2N0eHQgKmRsbSwgc3RydWN0IGRsbV9sb2NrX3Jlc291cmNlICpy
ZXMsCj4gwqAJCQkgwqAgc3RydWN0IGRsbV9sb2NrICpsb2NrKQo+IMKgewo+IGRpZmYgLS1naXQg
YS9mcy9vY2ZzMi9kbG0vZGxtY29tbW9uLmggYi9mcy9vY2ZzMi9kbG0vZGxtY29tbW9uLmgKPiBp
bmRleCBjOGE0NDQ2MjJmYWEuLjU4ZDU3ZTI1ZDM4NCAxMDA2NDQKPiAtLS0gYS9mcy9vY2ZzMi9k
bG0vZGxtY29tbW9uLmgKPiArKysgYi9mcy9vY2ZzMi9kbG0vZGxtY29tbW9uLmgKPiBAQCAtMTcs
MTAgKzE3LDcgQEAKPiDCoAo+IMKgI2RlZmluZSBETE1fTE9DS0lEX05BTUVfTUFYIMKgIMKgMzIK
PiDCoAo+IC0jZGVmaW5lIERMTV9ET01BSU5fTkFNRV9NQVhfTEVOIMKgIMKgMjU1Cj4gwqAjZGVm
aW5lIERMTV9MT0NLX1JFU19PV05FUl9VTktOT1dOIMKgIMKgIE8yTk1fTUFYX05PREVTCj4gLSNk
ZWZpbmUgRExNX1RIUkVBRF9TSFVGRkxFX0lOVEVSVkFMIMKgIMKgNSDCoCDCoCAvLyBmbHVzaCBl
dmVyeXRoaW5nIGV2ZXJ5IDUgcGFzc2VzCj4gLSNkZWZpbmUgRExNX1RIUkVBRF9NUyDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoDIwMCDCoCAvLyBmbHVzaCBhdCBsZWFzdCBldmVyeSAyMDAgbXMK
PiDCoAo+IMKgI2RlZmluZSBETE1fSEFTSF9TSVpFX0RFRkFVTFQJKDEgPDwgMTcpCj4gwqAjaWYg
RExNX0hBU0hfU0laRV9ERUZBVUxUIDwgUEFHRV9TSVpFCj4gQEAgLTkwMiw3ICs4OTksNiBAQCB2
b2lkIF9fZGxtX2xvY2tyZXNfZ3JhYl9pbmZsaWdodF93b3JrZXIoc3RydWN0IGRsbV9jdHh0ICpk
bG0sCj4gwqAJCXN0cnVjdCBkbG1fbG9ja19yZXNvdXJjZSAqcmVzKTsKPiDCoAo+IMKgdm9pZCBk
bG1fcXVldWVfYXN0KHN0cnVjdCBkbG1fY3R4dCAqZGxtLCBzdHJ1Y3QgZGxtX2xvY2sgKmxvY2sp
Owo+IC12b2lkIGRsbV9xdWV1ZV9iYXN0KHN0cnVjdCBkbG1fY3R4dCAqZGxtLCBzdHJ1Y3QgZGxt
X2xvY2sgKmxvY2spOwo+IMKgdm9pZCBfX2RsbV9xdWV1ZV9hc3Qoc3RydWN0IGRsbV9jdHh0ICpk
bG0sIHN0cnVjdCBkbG1fbG9jayAqbG9jayk7Cj4gwqB2b2lkIF9fZGxtX3F1ZXVlX2Jhc3Qoc3Ry
dWN0IGRsbV9jdHh0ICpkbG0sIHN0cnVjdCBkbG1fbG9jayAqbG9jayk7Cj4gwqB2b2lkIGRsbV9k
b19sb2NhbF9hc3Qoc3RydWN0IGRsbV9jdHh0ICpkbG0sCj4gLS3CoAo+IDIuMTguNAo+IAoKX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KT2NmczItZGV2ZWwg
bWFpbGluZyBsaXN0Ck9jZnMyLWRldmVsQG9zcy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNs
ZS5jb20vbWFpbG1hbi9saXN0aW5mby9vY2ZzMi1kZXZlbA==
