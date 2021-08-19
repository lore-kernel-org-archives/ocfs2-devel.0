Return-Path: <SRS0=eOWJ=NK=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2CA3C4338F
	for <ocfs2-devel@archiver.kernel.org>; Thu, 19 Aug 2021 02:03:08 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3B51B60EB5
	for <ocfs2-devel@archiver.kernel.org>; Thu, 19 Aug 2021 02:03:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3B51B60EB5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17J1uZfI006067;
	Thu, 19 Aug 2021 02:03:07 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3age7mv603-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Aug 2021 02:03:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17J217n3075852;
	Thu, 19 Aug 2021 02:03:06 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3aeqkxfah4-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 19 Aug 2021 02:03:05 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mGXOa-00030E-Se; Wed, 18 Aug 2021 19:03:04 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1mGXOY-0002zr-Mw
	for ocfs2-devel@oss.oracle.com; Wed, 18 Aug 2021 19:03:02 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17J2152W075744
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 02:03:02 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3020.oracle.com with ESMTP id 3aeqkxfacm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 02:03:01 +0000
Received: from pps.filterd (m0246577.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	17J1vPLm004090
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 02:03:00 GMT
Received: from out30-43.freemail.mail.aliyun.com
	(out30-43.freemail.mail.aliyun.com [115.124.30.43])
	by mx0b-00069f01.pphosted.com with ESMTP id 3ah6vnc54r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 02:03:00 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R481e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04420;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
	TI=SMTPD_---0UjtBWdz_1629338576; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0UjtBWdz_1629338576) by smtp.aliyun-inc.com(127.0.0.1);
	Thu, 19 Aug 2021 10:02:56 +0800
To: Gang He <ghe@suse.com>, mark@fasheh.com, jlbec@evilplan.org,
        Wengang Wang <wen.gang.wang@oracle.com>
References: <20210729110230.18983-1-ghe@suse.com>
	<5821fd0f-2018-dc1b-a5c0-f948a7debff4@linux.alibaba.com>
	<c7e1f0a7-e75c-d1e0-870d-dc480d070079@suse.com>
	<71608a14-58f4-dba0-d695-fee65de89192@linux.alibaba.com>
	<801438f5-655a-c708-aa25-343d54a2f11e@suse.com>
	<86e3d724-3147-ccaa-998f-0f857c575f7e@linux.alibaba.com>
	<a0a9710f-461a-99c8-92f6-a99bb11b3a4e@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <4ba3b404-824b-90a3-ef43-9ab6510ee073@linux.alibaba.com>
Date: Thu, 19 Aug 2021 10:02:55 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <a0a9710f-461a-99c8-92f6-a99bb11b3a4e@suse.com>
Content-Language: en-US
X-Source-IP: 115.124.30.43
X-ServerName: out30-43.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10080
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
	clxscore=215 bulkscore=0
	mlxscore=0 phishscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
	spamscore=0 lowpriorityscore=0 priorityscore=90 impostorscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000
	definitions=main-2108190008 domainage_hfrom=8162
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10080
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
	bulkscore=0 malwarescore=0
	mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108190008
X-MIME-Autoconverted: from 8bit to quoted-printable by userp3020.oracle.com id
	17J2152W075744
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10080 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108190008
X-Proofpoint-ORIG-GUID: hehDpbxAJWYLNdsmw-Cy4UjC77rVbyf-
X-Proofpoint-GUID: hehDpbxAJWYLNdsmw-Cy4UjC77rVbyf-

CgpPbiA4LzE5LzIxIDk6NTEgQU0sIEdhbmcgSGUgd3JvdGU6Cj4gCj4gCj4gT24gMjAyMS84LzE4
IDE5OjIwLCBKb3NlcGggUWkgd3JvdGU6Cj4+Cj4+Cj4+IE9uIDgvMTgvMjEgNToyMCBQTSwgR2Fu
ZyBIZSB3cm90ZToKPj4+Cj4+Pgo+Pj4gT24gMjAyMS84LzEzIDE3OjU0LCBKb3NlcGggUWkgd3Jv
dGU6Cj4+Pj4KPj4+Pgo+Pj4+IE9uIDgvOS8yMSA2OjA4IFBNLCBHYW5nIEhlIHdyb3RlOgo+Pj4+
PiBIaSBKb3NlcGggYW5kIEFsbCwKPj4+Pj4KPj4+Pj4gVGhlIGRlYWRsb2NrIGlzIGNhdXNlZCBi
eSBzZWxmLWxvY2tpbmcgb24gb25lIG5vZGUuCj4+Pj4+IFRoZXJlIGlzIHRocmVlIG5vZGUgY2x1
c3RlciAobW91bnRlZCB0byAvbW50L3NoYXJlZCksIHRoZSB1c2VyIHJ1biByZWZsaW5rIGNvbW1h
bmQgdG8gY2xvbmUgdGhlIGZpbGUgdG8gdGhlIHNhbWUgZGlyZWN0b3J5IHJlcGVhdGVkbHksCj4+
Pj4+IGUuZy4KPj4+Pj4gwqDCoMKgcmVmbGluayAiL21udC9zaGFyZWQvdGVzdCIgXAo+Pj4+PiDC
oMKgwqAiL21udC9zaGFyZWQvLnNuYXBzaG90cy90ZXN0LmBkYXRlICslbSVkJUglTSVTYC5gaG9z
dG5hbWVgIgo+Pj4+Pgo+Pj4+PiBBZnRlciBhIHdoaWxlLCB0aGUgcmVmbGluayBwcm9jZXNzIG9u
IGVhY2ggbm9kZSBpcyBodW5nLCB0aGUgZmlsZSBzeXN0ZW0gY2Fubm90IGJlIGxpc3RlZC4KPj4+
Pj4gVGhlIHByb2JsZW1hdGljIHJlZmxpbmsgY29tbWFuZCBwcm9jZXNzIGlzIGJsb2NrZWQgYnkg
aXRzZWxmLCBlLmcuIHRoZSByZWZsaW5rIHByb2Nlc3MgaXMgaHVuZyBhdCBnaGUtc2xlMTVzcDIt
bmQyLAo+Pj4+PiBrZXJuZWw6IHRhc2s6cmVmbGlua8KgwqDCoMKgwqDCoMKgwqAgc3RhdGU6RCBz
dGFjazrCoMKgwqAgMCBwaWQ6MTY5OTIgcHBpZDrCoCA0NTMwCj4+Pj4+IGtlcm5lbDogQ2FsbCBU
cmFjZToKPj4+Pj4ga2VybmVsOsKgIF9fc2NoZWR1bGUrMHgyZmQvMHg3NTAKPj4+Pj4ga2VybmVs
OsKgID8gdHJ5X3RvX3dha2VfdXArMHgxN2IvMHg0ZTAKPj4+Pj4ga2VybmVsOsKgIHNjaGVkdWxl
KzB4MmYvMHhhMAo+Pj4+PiBrZXJuZWw6wqAgc2NoZWR1bGVfdGltZW91dCsweDFjYy8weDMxMAo+
Pj4+PiBrZXJuZWw6wqAgPyBfX3dha2VfdXBfY29tbW9uKzB4NzQvMHgxMjAKPj4+Pj4ga2VybmVs
OsKgIHdhaXRfZm9yX2NvbXBsZXRpb24rMHhiYS8weDE0MAo+Pj4+PiBrZXJuZWw6wqAgPyB3YWtl
X3VwX3ErMHhhMC8weGEwCj4+Pj4+IGtlcm5lbDrCoCBfX29jZnMyX2NsdXN0ZXJfbG9jay5pc3Jh
LjQxKzB4M2I1LzB4ODIwIFtvY2ZzMl0KPj4+Pj4ga2VybmVsOsKgID8gb2NmczJfaW5vZGVfbG9j
a19mdWxsX25lc3RlZCsweDFmYy8weDk2MCBbb2NmczJdCj4+Pj4+IGtlcm5lbDrCoCBvY2ZzMl9p
bm9kZV9sb2NrX2Z1bGxfbmVzdGVkKzB4MWZjLzB4OTYwIFtvY2ZzMl0KPj4+Pj4ga2VybmVsOsKg
IG9jZnMyX2luaXRfc2VjdXJpdHlfYW5kX2FjbCsweGJlLzB4MWQwIFtvY2ZzMl0KPj4+Pj4ga2Vy
bmVsOsKgIG9jZnMyX3JlZmxpbmsrMHg0MzYvMHg0YzAgW29jZnMyXQo+Pj4+PiBrZXJuZWw6wqAg
PyBvY2ZzMl9yZWZsaW5rX2lvY3RsKzB4MmNhLzB4MzYwIFtvY2ZzMl0KPj4+Pj4ga2VybmVsOsKg
IG9jZnMyX3JlZmxpbmtfaW9jdGwrMHgyY2EvMHgzNjAgW29jZnMyXQo+Pj4+PiBrZXJuZWw6wqAg
b2NmczJfaW9jdGwrMHgyNWUvMHg2NzAgW29jZnMyXQo+Pj4+PiBrZXJuZWw6wqAgZG9fdmZzX2lv
Y3RsKzB4YTAvMHg2ODAKPj4+Pj4ga2VybmVsOsKgIGtzeXNfaW9jdGwrMHg3MC8weDgwCj4+Pj4+
Cj4+Pj4+IEluIGZhY3QsIHRoZSBkZXN0aW5hdGlvbiBkaXJlY3RvcnkoLnNuYXBzaG90cykgaW5v
ZGUgZGxtIGxvY2sgd2FzIGFjcXVpcmVkIGJ5IGdoZS1zbGUxNXNwMi1uZDIsIG5leHQgdGhlcmUg
aXMgYmFzdCBtZXNzYWdlIGZyb20gb3RoZXIgbm9kZXMgdG8gYXNrIGdoZS1zbGUxNXNwMi1uZDIg
ZG93bmNvbnZlcnQgbG9jaywgYnV0IHRoZSBvcGVyYXRpb24gZmFpbGVkLCB0aGUga2VybmVsIG1l
c3NhZ2UgaXMgcHJpbnRlZCBsaWtlLAo+Pj4+PiBrZXJuZWw6IChvY2ZzMmRjLUFBMzVERDksMjU2
MCwzKTpvY2ZzMl9kb3duY29udmVydF9sb2NrOjM2NjAgRVJST1I6IERMTSBlcnJvciAtMTYgd2hp
bGUgY2FsbGluZyBvY2ZzMl9kbG1fbG9jayBvbiByZXNvdXJjZSBNMDAwMDAwMDAwMDAwMDAwMDA0
NmUwMjAwMDAwMDAwCj4+Pj4+IGtlcm5lbDogKG9jZnMyZGMtQUEzNUREOSwyNTYwLDMpOm9jZnMy
X3VuYmxvY2tfbG9jazozOTA0IEVSUk9SOiBzdGF0dXMgPSAtMTYKPj4+Pj4ga2VybmVsOiAob2Nm
czJkYy1BQTM1REQ5LDI1NjAsMyk6b2NmczJfcHJvY2Vzc19ibG9ja2VkX2xvY2s6NDMwMyBFUlJP
Ujogc3RhdHVzID0gLTE2Cj4+Pj4+Cj4+Pj4+IFRoZW4sIHRoZSByZWZsaW5rIHByb2Nlc3MgdHJp
ZXMgdG8gYWNxdWlyZSB0aGlzIGRpcmVjdG9yeSBpbm9kZSBkbG0gbG9jaywgdGhlIHByb2Nlc3Mg
aXMgYmxvY2tlZCwgdGhlIGRsbSBsb2NrIHJlc291cmNlIGluIG1lbW9yeSBsb29rcyBsaWtlCj4+
Pj4+Cj4+Pj4+IMKgwqDCoMKgwqAgbF9uYW1lID0gIk0wMDAwMDAwMDAwMDAwMDAwMDQ2ZTAyMDAw
MDAwMDAiLAo+Pj4+PiDCoMKgwqDCoMKgIGxfcm9faG9sZGVycyA9IDAsCj4+Pj4+IMKgwqDCoMKg
wqAgbF9leF9ob2xkZXJzID0gMCwKPj4+Pj4gwqDCoMKgwqDCoCBsX2xldmVsID0gNSAnXDAwNScs
Cj4+Pj4+IMKgwqDCoMKgwqAgbF9yZXF1ZXN0ZWQgPSAwICdcMDAwJywKPj4+Pj4gwqDCoMKgwqDC
oCBsX2Jsb2NraW5nID0gNSAnXDAwNScsCj4+Pj4+IMKgwqDCoMKgwqAgbF90eXBlID0gMCAnXDAw
MCcsCj4+Pj4+IMKgwqDCoMKgwqAgbF9hY3Rpb24gPSAwICdcMDAwJywKPj4+Pj4gwqDCoMKgwqDC
oCBsX3VubG9ja19hY3Rpb24gPSAwICdcMDAwJywKPj4+Pj4gwqDCoMKgwqDCoCBsX3BlbmRpbmdf
Z2VuID0gNjQ1OTQ4LAo+Pj4+Pgo+Pj4+Pgo+Pj4+PiBTbyBmYXIsIEkgZG8gbm90IGtub3cgd2hh
dCBtYWtlcyBkbG0gbG9jayBmdW5jdGlvbiBmYWlsZWQsIGl0IGFsc28gbG9va3Mgd2UgZG8gbm90
IGhhbmRsZSB0aGlzIGZhaWx1cmUgY2FzZSBpbiBkbG1nbHVlIGxheWVyLCBidXQgSSBhbHdheXMg
cmVwcm9kdWNlIHRoaXMgaGFuZyB3aXRoIG15IHRlc3Qgc2NyaXB0LCBlLmcuCj4+Pj4+Cj4+Pj4+
IMKgwqDCoCBsb29wPTEKPj4+Pj4gwqDCoMKgIHdoaWxlICgobG9vcCsrKSkgOyBkbwo+Pj4+PiDC
oMKgwqDCoMKgwqDCoMKgwqAgZm9yIGkgaW4gYHNlcSAxIDEwMGA7IGRvCj4+Pj4+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgcmVmbGluayAiL21udC9zaGFyZWQvdGVzdCIgIi9tbnQvc2hhcmVkLy5z
bmFwc2hvdHMgL3Rlc3QuJHtsb29wfS4ke2l9LmBkYXRlICslbSVkJUglTSVTYC5gaG9zdG5hbWVg
Igo+Pj4+PiDCoMKgwqDCoMKgwqDCoMKgwqAgZG9uZQo+Pj4+PiDCoMKgwqDCoMKgwqDCoMKgwqAg
dXNsZWVwIDUwMDAwMAo+Pj4+PiDCoMKgwqDCoMKgwqDCoMKgwqAgcm0gLWYgL21udC9zaGFyZWQv
LnNuYXBzaG90cy90ZXN0bm9kZTEucWNvdzIuKi5gaG9zdG5hbWVgCj4+Pj4+IMKgwqDCoCBkb25l
Cj4+Pj4+Cj4+Pj4+IE15IHBhdGNoIGNoYW5nZXMgbXVsdGlwbGUgYWNxdWlyaW5nIGRlc3QgZGly
ZWN0b3J5IGlub2RlIGRsbSBsb2NrIGR1cmluZyBpbiBvY2ZzMl9yZWZsaW5rIGZ1bmN0aW9uLCBp
dCBhdm9pZHMgdGhlIGhhbmcgaXNzdWUgaGFwcGVuIGFnYWluLlRoZSBjb2RlIGNoYW5nZSBhbHNv
IGNhbiBpbXByb3ZlIHJlZmxpbmsgcGVyZm9ybWFuY2UgaW4gdGhpcyBjYXNlLgo+Pj4+Pgo+Pj4+
PiBUaGFua3MKPj4+Pj4gR2FuZwo+Pj4+Cj4+Pj4gJ3N0YXR1cyA9IC0xNicgaW1wbGllcyBETE1f
Q0FOQ0VMR1JBTlQuCj4+Pj4gRG8geW91IHVzZSBzdGFjayB1c2VyIGluc3RlYWQgb2YgbzJjYj8g
SWYgeWVzLCBjYW4geW91IHRyeSBvMmNiIHdpdGgKPj4+PiB5b3VyIHJlcHJvZHVjZXI/Cj4+Pgo+
Pj4gSSBzZXR1cCBvMmNiIGJhc2VkIG9jZnMyIGNsdXN0ZXJzIHdpdGggc2xlMTVzcDIgYW5kIG9y
YWNsZUxpbnV4OHU0Lgo+Pj4gQWZ0ZXIgdHdvIGRheSB0ZXN0aW5nIHdpdGggdGhlIHNhbWUgc2Ny
aXB0LCBJIGRpZCBub3QgZW5jb3VudGVyIGRsbV9sb2NrIGRvd25jb252ZXJ0IGZhaWx1cmUsIHRo
ZSBoYW5nIGlzc3VlIGRpZCBub3QgaGFwcGVuLgo+Pj4gQWZ0ZXIgbXkgcGF0Y2ggd2FzIGFwcGxp
ZWQsIHRoZXJlIHdhcyBub3QgYW55IHNpZGUgZWZmZWN0LCB0aGUgcmVmbGluayBwZXJmb3JtYW5j
ZSB3YXMgZG91YmxlZCBpbiB0aGUgY2FzZS4KPj4+Cj4+Cj4+IERvIHlvdSBtZWFuIHRoZSBoYW5n
IG9ubHkgaGFwcGVucyBvbiBzdGFjayB1c2VyPwo+IFllcy4KPiBXaHk/IHNpbmNlIG8yY2IgYmFz
ZWQgZGxtX2xvY2sgZGlkIG5vdCByZXR1cm4gZXJyb3IgLTE2IHdoZW4gZG93bmNvdmVydCBkbG0g
bG9jayBkdXJpbmcgdGhlIHdob2xlIHRlc3RpbmcuCj4gQnV0IHBtY2sgYmFzZWQgZGxtX2xvY2sg
cmV0dW5lZCBlcnJvciAtMTYgZHVyaW5nIHRoZSB0ZXN0aW5nLCB0aGVuIHdlIGRpZCBub3QgaGFu
ZGxlIHRoaXMgZXJyb3IgZnVydGhlciBpbiBkbG1nbHVlIGxheWVyLCBuZXh0IGVuY291bnRlciB0
aGUgaGFuZyBpc3N1ZSB3aGVuIGRsbV9sb2NrIGFjcXVpcmUgdGhlIGxvY2suIE1heWJlIHRoZXJl
IGlzIGEgcmFjZSBjb25kaXRpb24gd2hlbiB1c2luZyBkbG1fbG9jay9kbG1fdW5sb2NrKGNhbmNl
bCkgaW4gZGxtZ2x1ZSBsYXllci4KPiBBbnl3YXksIHRoZSBwcm9ibGVtIGJlbG9uZ3MgdG8gb2Nm
czIgb3duIHBhcnRzLgo+IApJIG1lYW50IGlmIERMTV9DQU5DRUxHUkFOVCBpcyBub3QgdGhlIGV4
cGVjdGVkIHJldHVybiBjb2RlLCB3ZSdkCmJldHRlciBmaXggdGhlIGlzc3VlIGluIHN0YWNrX3Vz
ZXIuYyBidXQgbm90IGRsbWdsdWUsIGUuZy4gc29tZSBzcGVjaWZpYwp3cmFwcGVyLgoKVGhhbmtz
LApKb3NlcGgKCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
XwpPY2ZzMi1kZXZlbCBtYWlsaW5nIGxpc3QKT2NmczItZGV2ZWxAb3NzLm9yYWNsZS5jb20KaHR0
cHM6Ly9vc3Mub3JhY2xlLmNvbS9tYWlsbWFuL2xpc3RpbmZvL29jZnMyLWRldmVs
