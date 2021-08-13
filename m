Return-Path: <SRS0=0EHx=NE=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E086C432BE
	for <ocfs2-devel@archiver.kernel.org>; Fri, 13 Aug 2021 09:55:31 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B06A760F51
	for <ocfs2-devel@archiver.kernel.org>; Fri, 13 Aug 2021 09:55:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B06A760F51
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17D9q7NH000581;
	Fri, 13 Aug 2021 09:55:30 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ad2ajjfsc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Aug 2021 09:55:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17D9oJWB058902;
	Fri, 13 Aug 2021 09:55:28 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3abjwaakd5-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 13 Aug 2021 09:55:28 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mETuR-0002Av-BC; Fri, 13 Aug 2021 02:55:27 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1mETtv-00029t-1u
	for ocfs2-devel@oss.oracle.com; Fri, 13 Aug 2021 02:54:55 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17D9ohpV033406
	for <ocfs2-devel@oss.oracle.com>; Fri, 13 Aug 2021 09:54:54 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3030.oracle.com with ESMTP id 3abx40ev3w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 13 Aug 2021 09:54:54 +0000
Received: from pps.filterd (m0246576.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	17D9qktG002828
	for <ocfs2-devel@oss.oracle.com>; Fri, 13 Aug 2021 09:54:53 GMT
Received: from out30-45.freemail.mail.aliyun.com
	(out30-45.freemail.mail.aliyun.com [115.124.30.45])
	by mx0b-00069f01.pphosted.com with ESMTP id 3adckpvvxu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Fri, 13 Aug 2021 09:54:53 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R101e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1;
	HT=alimailimapcm10staff010182156082;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
	TI=SMTPD_---0UisZLmz_1628848487; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0UisZLmz_1628848487) by smtp.aliyun-inc.com(127.0.0.1);
	Fri, 13 Aug 2021 17:54:47 +0800
To: Gang He <ghe@suse.com>, mark@fasheh.com, jlbec@evilplan.org,
        Wengang Wang <wen.gang.wang@oracle.com>
References: <20210729110230.18983-1-ghe@suse.com>
	<5821fd0f-2018-dc1b-a5c0-f948a7debff4@linux.alibaba.com>
	<c7e1f0a7-e75c-d1e0-870d-dc480d070079@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <71608a14-58f4-dba0-d695-fee65de89192@linux.alibaba.com>
Date: Fri, 13 Aug 2021 17:54:47 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <c7e1f0a7-e75c-d1e0-870d-dc480d070079@suse.com>
Content-Language: en-US
X-Source-IP: 115.124.30.45
X-ServerName: out30-45.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10074
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
	spamscore=0
	priorityscore=123 lowpriorityscore=0 phishscore=0 malwarescore=0
	adultscore=0 mlxscore=0 clxscore=178 impostorscore=0 suspectscore=0
	mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108130059
	domainage_hfrom=8156
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10074
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
	mlxscore=0 bulkscore=0
	spamscore=0 phishscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108130059
X-MIME-Autoconverted: from 8bit to quoted-printable by aserp3030.oracle.com id
	17D9ohpV033406
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: reflink deadlock when clone file
 to the same directory simultaneously
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10074 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108130059
X-Proofpoint-ORIG-GUID: glvAy00IHjhu0Sj7DWpBaXv8NMXxntfe
X-Proofpoint-GUID: glvAy00IHjhu0Sj7DWpBaXv8NMXxntfe

CgpPbiA4LzkvMjEgNjowOCBQTSwgR2FuZyBIZSB3cm90ZToKPiBIaSBKb3NlcGggYW5kIEFsbCwK
PiAKPiBUaGUgZGVhZGxvY2sgaXMgY2F1c2VkIGJ5IHNlbGYtbG9ja2luZyBvbiBvbmUgbm9kZS4K
PiBUaGVyZSBpcyB0aHJlZSBub2RlIGNsdXN0ZXIgKG1vdW50ZWQgdG8gL21udC9zaGFyZWQpLCB0
aGUgdXNlciBydW4gcmVmbGluayBjb21tYW5kIHRvIGNsb25lIHRoZSBmaWxlIHRvIHRoZSBzYW1l
IGRpcmVjdG9yeSByZXBlYXRlZGx5LAo+IGUuZy4KPiDCoHJlZmxpbmsgIi9tbnQvc2hhcmVkL3Rl
c3QiIFwKPiDCoCIvbW50L3NoYXJlZC8uc25hcHNob3RzL3Rlc3QuYGRhdGUgKyVtJWQlSCVNJVNg
LmBob3N0bmFtZWAiCj4gCj4gQWZ0ZXIgYSB3aGlsZSwgdGhlIHJlZmxpbmsgcHJvY2VzcyBvbiBl
YWNoIG5vZGUgaXMgaHVuZywgdGhlIGZpbGUgc3lzdGVtIGNhbm5vdCBiZSBsaXN0ZWQuCj4gVGhl
IHByb2JsZW1hdGljIHJlZmxpbmsgY29tbWFuZCBwcm9jZXNzIGlzIGJsb2NrZWQgYnkgaXRzZWxm
LCBlLmcuIHRoZSByZWZsaW5rIHByb2Nlc3MgaXMgaHVuZyBhdCBnaGUtc2xlMTVzcDItbmQyLAo+
IGtlcm5lbDogdGFzazpyZWZsaW5rwqDCoMKgwqDCoMKgwqDCoCBzdGF0ZTpEIHN0YWNrOsKgwqDC
oCAwIHBpZDoxNjk5MiBwcGlkOsKgIDQ1MzAKPiBrZXJuZWw6IENhbGwgVHJhY2U6Cj4ga2VybmVs
OsKgIF9fc2NoZWR1bGUrMHgyZmQvMHg3NTAKPiBrZXJuZWw6wqAgPyB0cnlfdG9fd2FrZV91cCsw
eDE3Yi8weDRlMAo+IGtlcm5lbDrCoCBzY2hlZHVsZSsweDJmLzB4YTAKPiBrZXJuZWw6wqAgc2No
ZWR1bGVfdGltZW91dCsweDFjYy8weDMxMAo+IGtlcm5lbDrCoCA/IF9fd2FrZV91cF9jb21tb24r
MHg3NC8weDEyMAo+IGtlcm5lbDrCoCB3YWl0X2Zvcl9jb21wbGV0aW9uKzB4YmEvMHgxNDAKPiBr
ZXJuZWw6wqAgPyB3YWtlX3VwX3ErMHhhMC8weGEwCj4ga2VybmVsOsKgIF9fb2NmczJfY2x1c3Rl
cl9sb2NrLmlzcmEuNDErMHgzYjUvMHg4MjAgW29jZnMyXQo+IGtlcm5lbDrCoCA/IG9jZnMyX2lu
b2RlX2xvY2tfZnVsbF9uZXN0ZWQrMHgxZmMvMHg5NjAgW29jZnMyXQo+IGtlcm5lbDrCoCBvY2Zz
Ml9pbm9kZV9sb2NrX2Z1bGxfbmVzdGVkKzB4MWZjLzB4OTYwIFtvY2ZzMl0KPiBrZXJuZWw6wqAg
b2NmczJfaW5pdF9zZWN1cml0eV9hbmRfYWNsKzB4YmUvMHgxZDAgW29jZnMyXQo+IGtlcm5lbDrC
oCBvY2ZzMl9yZWZsaW5rKzB4NDM2LzB4NGMwIFtvY2ZzMl0KPiBrZXJuZWw6wqAgPyBvY2ZzMl9y
ZWZsaW5rX2lvY3RsKzB4MmNhLzB4MzYwIFtvY2ZzMl0KPiBrZXJuZWw6wqAgb2NmczJfcmVmbGlu
a19pb2N0bCsweDJjYS8weDM2MCBbb2NmczJdCj4ga2VybmVsOsKgIG9jZnMyX2lvY3RsKzB4MjVl
LzB4NjcwIFtvY2ZzMl0KPiBrZXJuZWw6wqAgZG9fdmZzX2lvY3RsKzB4YTAvMHg2ODAKPiBrZXJu
ZWw6wqAga3N5c19pb2N0bCsweDcwLzB4ODAKPiAKPiBJbiBmYWN0LCB0aGUgZGVzdGluYXRpb24g
ZGlyZWN0b3J5KC5zbmFwc2hvdHMpIGlub2RlIGRsbSBsb2NrIHdhcyBhY3F1aXJlZCBieSBnaGUt
c2xlMTVzcDItbmQyLCBuZXh0IHRoZXJlIGlzIGJhc3QgbWVzc2FnZSBmcm9tIG90aGVyIG5vZGVz
IHRvIGFzayBnaGUtc2xlMTVzcDItbmQyIGRvd25jb252ZXJ0IGxvY2ssIGJ1dCB0aGUgb3BlcmF0
aW9uIGZhaWxlZCwgdGhlIGtlcm5lbCBtZXNzYWdlIGlzIHByaW50ZWQgbGlrZSwKPiBrZXJuZWw6
IChvY2ZzMmRjLUFBMzVERDksMjU2MCwzKTpvY2ZzMl9kb3duY29udmVydF9sb2NrOjM2NjAgRVJS
T1I6IERMTSBlcnJvciAtMTYgd2hpbGUgY2FsbGluZyBvY2ZzMl9kbG1fbG9jayBvbiByZXNvdXJj
ZSBNMDAwMDAwMDAwMDAwMDAwMDA0NmUwMjAwMDAwMDAwCj4ga2VybmVsOiAob2NmczJkYy1BQTM1
REQ5LDI1NjAsMyk6b2NmczJfdW5ibG9ja19sb2NrOjM5MDQgRVJST1I6IHN0YXR1cyA9IC0xNgo+
IGtlcm5lbDogKG9jZnMyZGMtQUEzNUREOSwyNTYwLDMpOm9jZnMyX3Byb2Nlc3NfYmxvY2tlZF9s
b2NrOjQzMDMgRVJST1I6IHN0YXR1cyA9IC0xNgo+IAo+IFRoZW4sIHRoZSByZWZsaW5rIHByb2Nl
c3MgdHJpZXMgdG8gYWNxdWlyZSB0aGlzIGRpcmVjdG9yeSBpbm9kZSBkbG0gbG9jaywgdGhlIHBy
b2Nlc3MgaXMgYmxvY2tlZCwgdGhlIGRsbSBsb2NrIHJlc291cmNlIGluIG1lbW9yeSBsb29rcyBs
aWtlCj4gCj4gwqDCoMKgIGxfbmFtZSA9ICJNMDAwMDAwMDAwMDAwMDAwMDA0NmUwMjAwMDAwMDAw
IiwKPiDCoMKgwqAgbF9yb19ob2xkZXJzID0gMCwKPiDCoMKgwqAgbF9leF9ob2xkZXJzID0gMCwK
PiDCoMKgwqAgbF9sZXZlbCA9IDUgJ1wwMDUnLAo+IMKgwqDCoCBsX3JlcXVlc3RlZCA9IDAgJ1ww
MDAnLAo+IMKgwqDCoCBsX2Jsb2NraW5nID0gNSAnXDAwNScsCj4gwqDCoMKgIGxfdHlwZSA9IDAg
J1wwMDAnLAo+IMKgwqDCoCBsX2FjdGlvbiA9IDAgJ1wwMDAnLAo+IMKgwqDCoCBsX3VubG9ja19h
Y3Rpb24gPSAwICdcMDAwJywKPiDCoMKgwqAgbF9wZW5kaW5nX2dlbiA9IDY0NTk0OCwKPiAKPiAK
PiBTbyBmYXIsIEkgZG8gbm90IGtub3cgd2hhdCBtYWtlcyBkbG0gbG9jayBmdW5jdGlvbiBmYWls
ZWQsIGl0IGFsc28gbG9va3Mgd2UgZG8gbm90IGhhbmRsZSB0aGlzIGZhaWx1cmUgY2FzZSBpbiBk
bG1nbHVlIGxheWVyLCBidXQgSSBhbHdheXMgcmVwcm9kdWNlIHRoaXMgaGFuZyB3aXRoIG15IHRl
c3Qgc2NyaXB0LCBlLmcuCj4gCj4gwqAgbG9vcD0xCj4gwqAgd2hpbGUgKChsb29wKyspKSA7IGRv
Cj4gwqDCoMKgwqDCoMKgwqAgZm9yIGkgaW4gYHNlcSAxIDEwMGA7IGRvCj4gwqDCoMKgwqDCoMKg
wqDCoMKgIHJlZmxpbmsgIi9tbnQvc2hhcmVkL3Rlc3QiICIvbW50L3NoYXJlZC8uc25hcHNob3Rz
IC90ZXN0LiR7bG9vcH0uJHtpfS5gZGF0ZSArJW0lZCVIJU0lU2AuYGhvc3RuYW1lYCIKPiDCoMKg
wqDCoMKgwqDCoCBkb25lCj4gwqDCoMKgwqDCoMKgwqAgdXNsZWVwIDUwMDAwMAo+IMKgwqDCoMKg
wqDCoMKgIHJtIC1mIC9tbnQvc2hhcmVkLy5zbmFwc2hvdHMvdGVzdG5vZGUxLnFjb3cyLiouYGhv
c3RuYW1lYAo+IMKgIGRvbmUKPiAKPiBNeSBwYXRjaCBjaGFuZ2VzIG11bHRpcGxlIGFjcXVpcmlu
ZyBkZXN0IGRpcmVjdG9yeSBpbm9kZSBkbG0gbG9jayBkdXJpbmcgaW4gb2NmczJfcmVmbGluayBm
dW5jdGlvbiwgaXQgYXZvaWRzIHRoZSBoYW5nIGlzc3VlIGhhcHBlbiBhZ2Fpbi5UaGUgY29kZSBj
aGFuZ2UgYWxzbyBjYW4gaW1wcm92ZSByZWZsaW5rIHBlcmZvcm1hbmNlIGluIHRoaXMgY2FzZS4K
PiAKPiBUaGFua3MKPiBHYW5nCgonc3RhdHVzID0gLTE2JyBpbXBsaWVzIERMTV9DQU5DRUxHUkFO
VC4KRG8geW91IHVzZSBzdGFjayB1c2VyIGluc3RlYWQgb2YgbzJjYj8gSWYgeWVzLCBjYW4geW91
IHRyeSBvMmNiIHdpdGgKeW91ciByZXByb2R1Y2VyPwoKVGhhbmtzLApKb3NlcGgKCgpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpPY2ZzMi1kZXZlbCBtYWls
aW5nIGxpc3QKT2NmczItZGV2ZWxAb3NzLm9yYWNsZS5jb20KaHR0cHM6Ly9vc3Mub3JhY2xlLmNv
bS9tYWlsbWFuL2xpc3RpbmZvL29jZnMyLWRldmVs
