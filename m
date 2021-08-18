Return-Path: <SRS0=nImK=NJ=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4339FC4338F
	for <ocfs2-devel@archiver.kernel.org>; Wed, 18 Aug 2021 11:21:00 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C026160EFE
	for <ocfs2-devel@archiver.kernel.org>; Wed, 18 Aug 2021 11:20:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C026160EFE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17IBGUlI013038;
	Wed, 18 Aug 2021 11:20:58 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3age7mtece-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Aug 2021 11:20:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17IBF5iF170416;
	Wed, 18 Aug 2021 11:20:57 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3aeqkw28y4-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 18 Aug 2021 11:20:57 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mGJcu-0003CQ-7t; Wed, 18 Aug 2021 04:20:56 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1mGJcs-0003C0-03
	for ocfs2-devel@oss.oracle.com; Wed, 18 Aug 2021 04:20:54 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17IBEw72131714
	for <ocfs2-devel@oss.oracle.com>; Wed, 18 Aug 2021 11:20:53 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3030.oracle.com with ESMTP id 3ae3vh9vxw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 18 Aug 2021 11:20:53 +0000
Received: from pps.filterd (m0246576.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	17IBHHSa020508
	for <ocfs2-devel@oss.oracle.com>; Wed, 18 Aug 2021 11:20:52 GMT
Received: from out30-44.freemail.mail.aliyun.com
	(out30-44.freemail.mail.aliyun.com [115.124.30.44])
	by mx0b-00069f01.pphosted.com with ESMTP id 3agdk2vg2p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Wed, 18 Aug 2021 11:20:52 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R121e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04400;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
	TI=SMTPD_---0UjhxFsf_1629285645; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0UjhxFsf_1629285645) by smtp.aliyun-inc.com(127.0.0.1);
	Wed, 18 Aug 2021 19:20:46 +0800
To: Gang He <ghe@suse.com>, mark@fasheh.com, jlbec@evilplan.org,
        Wengang Wang <wen.gang.wang@oracle.com>
References: <20210729110230.18983-1-ghe@suse.com>
	<5821fd0f-2018-dc1b-a5c0-f948a7debff4@linux.alibaba.com>
	<c7e1f0a7-e75c-d1e0-870d-dc480d070079@suse.com>
	<71608a14-58f4-dba0-d695-fee65de89192@linux.alibaba.com>
	<801438f5-655a-c708-aa25-343d54a2f11e@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <86e3d724-3147-ccaa-998f-0f857c575f7e@linux.alibaba.com>
Date: Wed, 18 Aug 2021 19:20:45 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <801438f5-655a-c708-aa25-343d54a2f11e@suse.com>
Content-Language: en-US
X-Source-IP: 115.124.30.44
X-ServerName: out30-44.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10079
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
	adultscore=0
	bulkscore=0 suspectscore=0 spamscore=0 lowpriorityscore=0 clxscore=273
	priorityscore=120 mlxscore=0 mlxlogscore=999 phishscore=0
	malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000
	definitions=main-2108180071 domainage_hfrom=8161
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10079
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	adultscore=0 mlxscore=0
	malwarescore=0 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108180071
X-MIME-Autoconverted: from 8bit to quoted-printable by aserp3030.oracle.com id
	17IBEw72131714
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10079 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108180071
X-Proofpoint-ORIG-GUID: wtyT2fov34c9vQs_WNP1IBcKM8uH25Ox
X-Proofpoint-GUID: wtyT2fov34c9vQs_WNP1IBcKM8uH25Ox

CgpPbiA4LzE4LzIxIDU6MjAgUE0sIEdhbmcgSGUgd3JvdGU6Cj4gCj4gCj4gT24gMjAyMS84LzEz
IDE3OjU0LCBKb3NlcGggUWkgd3JvdGU6Cj4+Cj4+Cj4+IE9uIDgvOS8yMSA2OjA4IFBNLCBHYW5n
IEhlIHdyb3RlOgo+Pj4gSGkgSm9zZXBoIGFuZCBBbGwsCj4+Pgo+Pj4gVGhlIGRlYWRsb2NrIGlz
IGNhdXNlZCBieSBzZWxmLWxvY2tpbmcgb24gb25lIG5vZGUuCj4+PiBUaGVyZSBpcyB0aHJlZSBu
b2RlIGNsdXN0ZXIgKG1vdW50ZWQgdG8gL21udC9zaGFyZWQpLCB0aGUgdXNlciBydW4gcmVmbGlu
ayBjb21tYW5kIHRvIGNsb25lIHRoZSBmaWxlIHRvIHRoZSBzYW1lIGRpcmVjdG9yeSByZXBlYXRl
ZGx5LAo+Pj4gZS5nLgo+Pj4gwqDCoHJlZmxpbmsgIi9tbnQvc2hhcmVkL3Rlc3QiIFwKPj4+IMKg
wqAiL21udC9zaGFyZWQvLnNuYXBzaG90cy90ZXN0LmBkYXRlICslbSVkJUglTSVTYC5gaG9zdG5h
bWVgIgo+Pj4KPj4+IEFmdGVyIGEgd2hpbGUsIHRoZSByZWZsaW5rIHByb2Nlc3Mgb24gZWFjaCBu
b2RlIGlzIGh1bmcsIHRoZSBmaWxlIHN5c3RlbSBjYW5ub3QgYmUgbGlzdGVkLgo+Pj4gVGhlIHBy
b2JsZW1hdGljIHJlZmxpbmsgY29tbWFuZCBwcm9jZXNzIGlzIGJsb2NrZWQgYnkgaXRzZWxmLCBl
LmcuIHRoZSByZWZsaW5rIHByb2Nlc3MgaXMgaHVuZyBhdCBnaGUtc2xlMTVzcDItbmQyLAo+Pj4g
a2VybmVsOiB0YXNrOnJlZmxpbmvCoMKgwqDCoMKgwqDCoMKgIHN0YXRlOkQgc3RhY2s6wqDCoMKg
IDAgcGlkOjE2OTkyIHBwaWQ6wqAgNDUzMAo+Pj4ga2VybmVsOiBDYWxsIFRyYWNlOgo+Pj4ga2Vy
bmVsOsKgIF9fc2NoZWR1bGUrMHgyZmQvMHg3NTAKPj4+IGtlcm5lbDrCoCA/IHRyeV90b193YWtl
X3VwKzB4MTdiLzB4NGUwCj4+PiBrZXJuZWw6wqAgc2NoZWR1bGUrMHgyZi8weGEwCj4+PiBrZXJu
ZWw6wqAgc2NoZWR1bGVfdGltZW91dCsweDFjYy8weDMxMAo+Pj4ga2VybmVsOsKgID8gX193YWtl
X3VwX2NvbW1vbisweDc0LzB4MTIwCj4+PiBrZXJuZWw6wqAgd2FpdF9mb3JfY29tcGxldGlvbisw
eGJhLzB4MTQwCj4+PiBrZXJuZWw6wqAgPyB3YWtlX3VwX3ErMHhhMC8weGEwCj4+PiBrZXJuZWw6
wqAgX19vY2ZzMl9jbHVzdGVyX2xvY2suaXNyYS40MSsweDNiNS8weDgyMCBbb2NmczJdCj4+PiBr
ZXJuZWw6wqAgPyBvY2ZzMl9pbm9kZV9sb2NrX2Z1bGxfbmVzdGVkKzB4MWZjLzB4OTYwIFtvY2Zz
Ml0KPj4+IGtlcm5lbDrCoCBvY2ZzMl9pbm9kZV9sb2NrX2Z1bGxfbmVzdGVkKzB4MWZjLzB4OTYw
IFtvY2ZzMl0KPj4+IGtlcm5lbDrCoCBvY2ZzMl9pbml0X3NlY3VyaXR5X2FuZF9hY2wrMHhiZS8w
eDFkMCBbb2NmczJdCj4+PiBrZXJuZWw6wqAgb2NmczJfcmVmbGluaysweDQzNi8weDRjMCBbb2Nm
czJdCj4+PiBrZXJuZWw6wqAgPyBvY2ZzMl9yZWZsaW5rX2lvY3RsKzB4MmNhLzB4MzYwIFtvY2Zz
Ml0KPj4+IGtlcm5lbDrCoCBvY2ZzMl9yZWZsaW5rX2lvY3RsKzB4MmNhLzB4MzYwIFtvY2ZzMl0K
Pj4+IGtlcm5lbDrCoCBvY2ZzMl9pb2N0bCsweDI1ZS8weDY3MCBbb2NmczJdCj4+PiBrZXJuZWw6
wqAgZG9fdmZzX2lvY3RsKzB4YTAvMHg2ODAKPj4+IGtlcm5lbDrCoCBrc3lzX2lvY3RsKzB4NzAv
MHg4MAo+Pj4KPj4+IEluIGZhY3QsIHRoZSBkZXN0aW5hdGlvbiBkaXJlY3RvcnkoLnNuYXBzaG90
cykgaW5vZGUgZGxtIGxvY2sgd2FzIGFjcXVpcmVkIGJ5IGdoZS1zbGUxNXNwMi1uZDIsIG5leHQg
dGhlcmUgaXMgYmFzdCBtZXNzYWdlIGZyb20gb3RoZXIgbm9kZXMgdG8gYXNrIGdoZS1zbGUxNXNw
Mi1uZDIgZG93bmNvbnZlcnQgbG9jaywgYnV0IHRoZSBvcGVyYXRpb24gZmFpbGVkLCB0aGUga2Vy
bmVsIG1lc3NhZ2UgaXMgcHJpbnRlZCBsaWtlLAo+Pj4ga2VybmVsOiAob2NmczJkYy1BQTM1REQ5
LDI1NjAsMyk6b2NmczJfZG93bmNvbnZlcnRfbG9jazozNjYwIEVSUk9SOiBETE0gZXJyb3IgLTE2
IHdoaWxlIGNhbGxpbmcgb2NmczJfZGxtX2xvY2sgb24gcmVzb3VyY2UgTTAwMDAwMDAwMDAwMDAw
MDAwNDZlMDIwMDAwMDAwMAo+Pj4ga2VybmVsOiAob2NmczJkYy1BQTM1REQ5LDI1NjAsMyk6b2Nm
czJfdW5ibG9ja19sb2NrOjM5MDQgRVJST1I6IHN0YXR1cyA9IC0xNgo+Pj4ga2VybmVsOiAob2Nm
czJkYy1BQTM1REQ5LDI1NjAsMyk6b2NmczJfcHJvY2Vzc19ibG9ja2VkX2xvY2s6NDMwMyBFUlJP
Ujogc3RhdHVzID0gLTE2Cj4+Pgo+Pj4gVGhlbiwgdGhlIHJlZmxpbmsgcHJvY2VzcyB0cmllcyB0
byBhY3F1aXJlIHRoaXMgZGlyZWN0b3J5IGlub2RlIGRsbSBsb2NrLCB0aGUgcHJvY2VzcyBpcyBi
bG9ja2VkLCB0aGUgZGxtIGxvY2sgcmVzb3VyY2UgaW4gbWVtb3J5IGxvb2tzIGxpa2UKPj4+Cj4+
PiDCoMKgwqDCoCBsX25hbWUgPSAiTTAwMDAwMDAwMDAwMDAwMDAwNDZlMDIwMDAwMDAwMCIsCj4+
PiDCoMKgwqDCoCBsX3JvX2hvbGRlcnMgPSAwLAo+Pj4gwqDCoMKgwqAgbF9leF9ob2xkZXJzID0g
MCwKPj4+IMKgwqDCoMKgIGxfbGV2ZWwgPSA1ICdcMDA1JywKPj4+IMKgwqDCoMKgIGxfcmVxdWVz
dGVkID0gMCAnXDAwMCcsCj4+PiDCoMKgwqDCoCBsX2Jsb2NraW5nID0gNSAnXDAwNScsCj4+PiDC
oMKgwqDCoCBsX3R5cGUgPSAwICdcMDAwJywKPj4+IMKgwqDCoMKgIGxfYWN0aW9uID0gMCAnXDAw
MCcsCj4+PiDCoMKgwqDCoCBsX3VubG9ja19hY3Rpb24gPSAwICdcMDAwJywKPj4+IMKgwqDCoMKg
IGxfcGVuZGluZ19nZW4gPSA2NDU5NDgsCj4+Pgo+Pj4KPj4+IFNvIGZhciwgSSBkbyBub3Qga25v
dyB3aGF0IG1ha2VzIGRsbSBsb2NrIGZ1bmN0aW9uIGZhaWxlZCwgaXQgYWxzbyBsb29rcyB3ZSBk
byBub3QgaGFuZGxlIHRoaXMgZmFpbHVyZSBjYXNlIGluIGRsbWdsdWUgbGF5ZXIsIGJ1dCBJIGFs
d2F5cyByZXByb2R1Y2UgdGhpcyBoYW5nIHdpdGggbXkgdGVzdCBzY3JpcHQsIGUuZy4KPj4+Cj4+
PiDCoMKgIGxvb3A9MQo+Pj4gwqDCoCB3aGlsZSAoKGxvb3ArKykpIDsgZG8KPj4+IMKgwqDCoMKg
wqDCoMKgwqAgZm9yIGkgaW4gYHNlcSAxIDEwMGA7IGRvCj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDC
oCByZWZsaW5rICIvbW50L3NoYXJlZC90ZXN0IiAiL21udC9zaGFyZWQvLnNuYXBzaG90cyAvdGVz
dC4ke2xvb3B9LiR7aX0uYGRhdGUgKyVtJWQlSCVNJVNgLmBob3N0bmFtZWAiCj4+PiDCoMKgwqDC
oMKgwqDCoMKgIGRvbmUKPj4+IMKgwqDCoMKgwqDCoMKgwqAgdXNsZWVwIDUwMDAwMAo+Pj4gwqDC
oMKgwqDCoMKgwqDCoCBybSAtZiAvbW50L3NoYXJlZC8uc25hcHNob3RzL3Rlc3Rub2RlMS5xY293
Mi4qLmBob3N0bmFtZWAKPj4+IMKgwqAgZG9uZQo+Pj4KPj4+IE15IHBhdGNoIGNoYW5nZXMgbXVs
dGlwbGUgYWNxdWlyaW5nIGRlc3QgZGlyZWN0b3J5IGlub2RlIGRsbSBsb2NrIGR1cmluZyBpbiBv
Y2ZzMl9yZWZsaW5rIGZ1bmN0aW9uLCBpdCBhdm9pZHMgdGhlIGhhbmcgaXNzdWUgaGFwcGVuIGFn
YWluLlRoZSBjb2RlIGNoYW5nZSBhbHNvIGNhbiBpbXByb3ZlIHJlZmxpbmsgcGVyZm9ybWFuY2Ug
aW4gdGhpcyBjYXNlLgo+Pj4KPj4+IFRoYW5rcwo+Pj4gR2FuZwo+Pgo+PiAnc3RhdHVzID0gLTE2
JyBpbXBsaWVzIERMTV9DQU5DRUxHUkFOVC4KPj4gRG8geW91IHVzZSBzdGFjayB1c2VyIGluc3Rl
YWQgb2YgbzJjYj8gSWYgeWVzLCBjYW4geW91IHRyeSBvMmNiIHdpdGgKPj4geW91ciByZXByb2R1
Y2VyPwo+IAo+IEkgc2V0dXAgbzJjYiBiYXNlZCBvY2ZzMiBjbHVzdGVycyB3aXRoIHNsZTE1c3Ay
IGFuZCBvcmFjbGVMaW51eDh1NC4KPiBBZnRlciB0d28gZGF5IHRlc3Rpbmcgd2l0aCB0aGUgc2Ft
ZSBzY3JpcHQsIEkgZGlkIG5vdCBlbmNvdW50ZXIgZGxtX2xvY2sgZG93bmNvbnZlcnQgZmFpbHVy
ZSwgdGhlIGhhbmcgaXNzdWUgZGlkIG5vdCBoYXBwZW4uCj4gQWZ0ZXIgbXkgcGF0Y2ggd2FzIGFw
cGxpZWQsIHRoZXJlIHdhcyBub3QgYW55IHNpZGUgZWZmZWN0LCB0aGUgcmVmbGluayBwZXJmb3Jt
YW5jZSB3YXMgZG91YmxlZCBpbiB0aGUgY2FzZS4KPiAKCkRvIHlvdSBtZWFuIHRoZSBoYW5nIG9u
bHkgaGFwcGVucyBvbiBzdGFjayB1c2VyPwpJTU8sIHdlJ2QgYmV0dGVyIGRpcmVjdGx5IGZpeCB0
aGUgc3RhY2sgdXNlciBoYW5nIGZpcnN0LCBhbmQgdGhlbiBvcHRpbWl6ZQpyZWZsaW5rIHBlcmZv
cm1hbmNlLgoKVGhhbmtzLApKb3NlcGgKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCk9jZnMyLWRldmVsIG1haWxpbmcgbGlzdApPY2ZzMi1kZXZlbEBvc3Mu
b3JhY2xlLmNvbQpodHRwczovL29zcy5vcmFjbGUuY29tL21haWxtYW4vbGlzdGluZm8vb2NmczIt
ZGV2ZWw=
