Return-Path: <SRS0=ohwt=GW=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 015A0C433DB
	for <ocfs2-devel@archiver.kernel.org>; Tue, 19 Jan 2021 20:46:27 +0000 (UTC)
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A7C2523107;
	Tue, 19 Jan 2021 20:46:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A7C2523107
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=chinatelecom.cn
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10JHnv2q096274;
	Tue, 19 Jan 2021 17:54:29 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by userp2130.oracle.com with ESMTP id 363xyhsp0u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Jan 2021 17:54:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10JHobvf172893;
	Tue, 19 Jan 2021 17:54:29 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3661khk66u-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 19 Jan 2021 17:54:29 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l1v9z-0007p1-3J; Tue, 19 Jan 2021 09:51:19 -0800
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <guozh88@chinatelecom.cn>) id 1l1mFx-00030W-0w
	for ocfs2-devel@oss.oracle.com; Tue, 19 Jan 2021 00:20:53 -0800
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10J8KpaI149315
	for <ocfs2-devel@oss.oracle.com>; Tue, 19 Jan 2021 08:20:52 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by aserp3030.oracle.com with ESMTP id 3649qntbm6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 19 Jan 2021 08:20:52 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10J8F9pX020278
	for <ocfs2-devel@oss.oracle.com>; Tue, 19 Jan 2021 08:20:33 GMT
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.227])
	by userp2030.oracle.com with ESMTP id 365rn4t926-1
	for <ocfs2-devel@oss.oracle.com>; Tue, 19 Jan 2021 08:20:30 +0000
HMM_SOURCE_IP: 172.18.0.92:60425.1119872845
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-106.120.220.78?logid-41fe43b94e2b41418182f2b6b23cc585
	(unknown [172.18.0.92])
	by chinatelecom.cn (HERMES) with SMTP id F22C42800D1;
	Tue, 19 Jan 2021 16:18:43 +0800 (CST)
X-189-SAVE-TO-SEND: 71117184@chinatelecom.cn
Received: from  ([172.18.0.92])
	by App0021 with ESMTP id 41fe43b94e2b41418182f2b6b23cc585 for
	akpm@linux-foundation.org; Tue Jan 19 16:18:51 2021
X-Transaction-ID: 41fe43b94e2b41418182f2b6b23cc585
X-filter-score: filter<0>
X-Real-From: guozh88@chinatelecom.cn
X-Receive-IP: 172.18.0.92
X-MEDUSA-Status: 0
Date: Tue, 19 Jan 2021 16:18:23 +0800
From: guozh <guozh88@chinatelecom.cn>
To: akpm <akpm@linux-foundation.org>, joseph.qi <joseph.qi@linux.alibaba.com>,
        ocfs2-devel <ocfs2-devel@oss.oracle.com>
X-Priority: 3
X-Has-Attach: no
X-Mailer: Foxmail 7.2.18.95[cn]
Mime-Version: 1.0
Message-ID: <2021011916182284700534@chinatelecom.cn>
X-PDR: PASS
X-Source-IP: 42.123.76.227
X-ServerName: prt-mail.chinatelecom.cn
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:42.123.76.201/22 -all
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9868
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
	phishscore=0
	lowpriorityscore=0 adultscore=0 priorityscore=30 spamscore=0
	malwarescore=0 impostorscore=0 clxscore=297 mlxlogscore=656 mlxscore=0
	suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2101190049
X-Spam: Clean
X-Mailman-Approved-At: Tue, 19 Jan 2021 09:51:17 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: cleanup some definitions which is not
	used anymore.
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 phishscore=0 mlxscore=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101190101
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9869 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501 spamscore=0
 mlxscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0 clxscore=1034
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101190101

VGhlcmUgYXJlIHNvbWUgZGVmaW5pdGlvbnMgd2hpY2ggaXMgbm90IHVzZWQgYW55bW9yZSBpbiBP
Q0ZTMiBtb2R1bGUsIHNvIGFzIHRvIGJlIHJlbW92ZWQuCgpTaWduZWQtb2ZmLWJ5OiBHdW96aG9u
Z2h1YSA8Z3Vvemg4OEBjaGluYXRlbGVjb20uY24+Ci0tLQrCoGZzL29jZnMyL2RsbS9kbG1hc3Qu
YyDCoCDCoHwgMTAgLS0tLS0tLS0tLQrCoGZzL29jZnMyL2RsbS9kbG1jb21tb24uaCB8IMKgNCAt
LS0tCsKgMiBmaWxlcyBjaGFuZ2VkLCAxNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9v
Y2ZzMi9kbG0vZGxtYXN0LmMgYi9mcy9vY2ZzMi9kbG0vZGxtYXN0LmMKaW5kZXggNmFiYWRlZDNm
ZjZiLi43MGExMDc2NGYyNDkgMTAwNjQ0Ci0tLSBhL2ZzL29jZnMyL2RsbS9kbG1hc3QuYworKysg
Yi9mcy9vY2ZzMi9kbG0vZGxtYXN0LmMKQEAgLTE2NSwxNiArMTY1LDYgQEAgdm9pZCBfX2RsbV9x
dWV1ZV9iYXN0KHN0cnVjdCBkbG1fY3R4dCAqZGxtLCBzdHJ1Y3QgZGxtX2xvY2sgKmxvY2spCsKg
CXNwaW5fdW5sb2NrKCZsb2NrLT5zcGlubG9jayk7CsKgfQrCoAotdm9pZCBkbG1fcXVldWVfYmFz
dChzdHJ1Y3QgZGxtX2N0eHQgKmRsbSwgc3RydWN0IGRsbV9sb2NrICpsb2NrKQotewotCUJVR19P
TighZGxtKTsKLQlCVUdfT04oIWxvY2spOwotCi0Jc3Bpbl9sb2NrKCZkbG0tPmFzdF9sb2NrKTsK
LQlfX2RsbV9xdWV1ZV9iYXN0KGRsbSwgbG9jayk7Ci0Jc3Bpbl91bmxvY2soJmRsbS0+YXN0X2xv
Y2spOwotfQotCsKgc3RhdGljIHZvaWQgZGxtX3VwZGF0ZV9sdmIoc3RydWN0IGRsbV9jdHh0ICpk
bG0sIHN0cnVjdCBkbG1fbG9ja19yZXNvdXJjZSAqcmVzLArCoAkJCSDCoCBzdHJ1Y3QgZGxtX2xv
Y2sgKmxvY2spCsKgewpkaWZmIC0tZ2l0IGEvZnMvb2NmczIvZGxtL2RsbWNvbW1vbi5oIGIvZnMv
b2NmczIvZGxtL2RsbWNvbW1vbi5oCmluZGV4IGM4YTQ0NDYyMmZhYS4uNThkNTdlMjVkMzg0IDEw
MDY0NAotLS0gYS9mcy9vY2ZzMi9kbG0vZGxtY29tbW9uLmgKKysrIGIvZnMvb2NmczIvZGxtL2Rs
bWNvbW1vbi5oCkBAIC0xNywxMCArMTcsNyBAQArCoArCoCNkZWZpbmUgRExNX0xPQ0tJRF9OQU1F
X01BWCDCoCDCoDMyCsKgCi0jZGVmaW5lIERMTV9ET01BSU5fTkFNRV9NQVhfTEVOIMKgIMKgMjU1
CsKgI2RlZmluZSBETE1fTE9DS19SRVNfT1dORVJfVU5LTk9XTiDCoCDCoCBPMk5NX01BWF9OT0RF
UwotI2RlZmluZSBETE1fVEhSRUFEX1NIVUZGTEVfSU5URVJWQUwgwqAgwqA1IMKgIMKgIC8vIGZs
dXNoIGV2ZXJ5dGhpbmcgZXZlcnkgNSBwYXNzZXMKLSNkZWZpbmUgRExNX1RIUkVBRF9NUyDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoDIwMCDCoCAvLyBmbHVzaCBhdCBsZWFzdCBldmVyeSAyMDAg
bXMKwqAKwqAjZGVmaW5lIERMTV9IQVNIX1NJWkVfREVGQVVMVAkoMSA8PCAxNykKwqAjaWYgRExN
X0hBU0hfU0laRV9ERUZBVUxUIDwgUEFHRV9TSVpFCkBAIC05MDIsNyArODk5LDYgQEAgdm9pZCBf
X2RsbV9sb2NrcmVzX2dyYWJfaW5mbGlnaHRfd29ya2VyKHN0cnVjdCBkbG1fY3R4dCAqZGxtLArC
oAkJc3RydWN0IGRsbV9sb2NrX3Jlc291cmNlICpyZXMpOwrCoArCoHZvaWQgZGxtX3F1ZXVlX2Fz
dChzdHJ1Y3QgZGxtX2N0eHQgKmRsbSwgc3RydWN0IGRsbV9sb2NrICpsb2NrKTsKLXZvaWQgZGxt
X3F1ZXVlX2Jhc3Qoc3RydWN0IGRsbV9jdHh0ICpkbG0sIHN0cnVjdCBkbG1fbG9jayAqbG9jayk7
CsKgdm9pZCBfX2RsbV9xdWV1ZV9hc3Qoc3RydWN0IGRsbV9jdHh0ICpkbG0sIHN0cnVjdCBkbG1f
bG9jayAqbG9jayk7CsKgdm9pZCBfX2RsbV9xdWV1ZV9iYXN0KHN0cnVjdCBkbG1fY3R4dCAqZGxt
LCBzdHJ1Y3QgZGxtX2xvY2sgKmxvY2spOwrCoHZvaWQgZGxtX2RvX2xvY2FsX2FzdChzdHJ1Y3Qg
ZGxtX2N0eHQgKmRsbSwKLS3CoAoyLjE4LjQKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0Ck9jZnMyLWRldmVsQG9z
cy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9saXN0aW5mby9vY2Zz
Mi1kZXZlbA==
