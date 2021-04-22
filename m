Return-Path: <SRS0=okW4=JT=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C82E9C433B4
	for <ocfs2-devel@archiver.kernel.org>; Thu, 22 Apr 2021 16:06:51 +0000 (UTC)
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 40833613ED
	for <ocfs2-devel@archiver.kernel.org>; Thu, 22 Apr 2021 16:06:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 40833613ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MFo3je195526;
	Thu, 22 Apr 2021 16:06:50 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by userp2130.oracle.com with ESMTP id 37yveanjqm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Apr 2021 16:06:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MFo3EG005171;
	Thu, 22 Apr 2021 16:06:49 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 383acyxmgk-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 22 Apr 2021 16:06:49 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lZbqq-00011w-9n; Thu, 22 Apr 2021 09:06:48 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <djwong@kernel.org>) id 1lZbqo-00011Z-Us
	for ocfs2-devel@oss.oracle.com; Thu, 22 Apr 2021 09:06:47 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	13MFowGT151036
	for <ocfs2-devel@oss.oracle.com>; Thu, 22 Apr 2021 16:06:46 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by userp3030.oracle.com with ESMTP id 3809m2gswe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 22 Apr 2021 16:06:46 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	13MFtNsR030119
	for <ocfs2-devel@oss.oracle.com>; Thu, 22 Apr 2021 16:06:46 GMT
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by userp2030.oracle.com with ESMTP id 383as2jgs0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Thu, 22 Apr 2021 16:06:46 +0000
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7F81613FA;
	Thu, 22 Apr 2021 16:06:08 +0000 (UTC)
Date: Thu, 22 Apr 2021 09:06:08 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Wengang Wang <wen.gang.wang@oracle.com>
Message-ID: <20210422160608.GB547183@magnolia>
References: <20210421162953.GA13863@quack2.suse.cz>
	<c4d119be-e263-366c-c2c2-6c58ee852977@linux.alibaba.com>
	<20210422104425.GC26221@quack2.suse.cz>
	<3A2B19E3-3DFF-454E-BFC9-A6B48629509F@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3A2B19E3-3DFF-454E-BFC9-A6B48629509F@oracle.com>
X-PDR: PASS
X-Source-IP: 198.145.29.99
X-ServerName: mail.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx include:_spf.kernel.org ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_safe policy=tap score=0 classifier=
	adjust=0 reason=safe
	scancount=1 engine=8.12.0-2104060000 definitions=main-2104220122
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-MIME-Autoconverted: from 8bit to quoted-printable by userp3030.oracle.com id
	13MFowGT151036
Cc: Jan Kara <jack@suse.cz>, ocfs2-devel ML <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] Possible fs corruption when hole punch races
	with	other ops
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220122
X-Proofpoint-GUID: HnOTkSzi8CL3FOywgF9NbMVlv3ErkE0c
X-Proofpoint-ORIG-GUID: HnOTkSzi8CL3FOywgF9NbMVlv3ErkE0c
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0 mlxscore=0
 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 adultscore=0 malwarescore=0 clxscore=1011 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220122

T24gVGh1LCBBcHIgMjIsIDIwMjEgYXQgMDM6NTY6MTVQTSArMDAwMCwgV2VuZ2FuZyBXYW5nIHdy
b3RlOgo+IEhpIEhvbnphLAo+IAo+IEJ5IOKAnGhvbGUgcHVuY2hpbmcgb3BlcmF0aW9u4oCdLCB5
b3UgbWVhbnQgZGVhbGxvY2F0ZSBzb21lIGRhdGEgYmxvY2tzCj4gZnJvbSBhIGZpbGUgYW5kIGtl
ZXAgdGhlIGZpbGUgc2l6ZSB1bmNoYW5nZWQsIGFmdGVyIHRoYXQgb3BlcmF0aW9uCj4gc29tZSDi
gJxob2xlcyIgYXJlIG1hZGUgaW4gdGhhdCBmaWxlLCByaWdodD8KPiBJIGFtIGp1c3QgY3VyaW91
cyB0aGF0IGRvIHdlIHJlYWxseSBoYXZlIGVuZCB1c2VyIHByb2dyYW1zIHRoYXQgZG8KPiBob2xl
IHB1bmNoaW5nIG9uIGZpbGVzPyBPciBob2xlIHB1bmNoaW5nIGlzIG9ubHkgdXNlZCBmb3IgZGV2
ZWxvcG1lbnQKPiBwdXJwb3NlPwoKWWVzLCB3ZSBkby4gIFFFTVUgZG9lcyBpdCB0byBpbWFnZSBm
aWxlcywgdmFyaW91cyAkZGF0YWJhc2UgcHJvZHVjdHMsCmV0Yy4uLgoKLS1ECgo+IAo+IHRoYW5r
cywKPiB3ZW5nYW5nCj4gCj4gT24gQXByIDIyLCAyMDIxLCBhdCAzOjQ0IEFNLCBKYW4gS2FyYSA8
amFja0BzdXNlLmN6PG1haWx0bzpqYWNrQHN1c2UuY3o+PiB3cm90ZToKPiAKPiBIZWxsbyEKPiAK
PiBPbiBUaHUgMjItMDQtMjEgMTE6MjI6MDcsIEpvc2VwaCBRaSB3cm90ZToKPiBDaGVja2VkIHRo
ZSBjb2RlIGZsb3csIGl0IHNlZW1zIHRoZSByYWNlIHlvdSB3b3JyaWVkIHRydWx5IGV4aXN0cy4K
PiBXZSBoYXZlIHRvIHRha2UgaXBfYWxsb2Nfc2VtIGJlZm9yZSBjYWxsaW5nIGludG8gb2NmczJf
Z2V0X2Jsb2NrKCkuCj4gCj4gT0ssIHRoYXQncyB3aGF0IEkgYXNzdW1lZCBidXQgdGhpcyB3b24n
dCBiZSBlYXN5LiBCZWNhdXNlIG9jZnMyX3dyaXRlcGFnZSgpCj4gaXMgY2FsbGVkIHdpdGggYSBw
YWdlIGxvY2tlZCBidXQgb2NmczJfcmVtb3ZlX2lub2RlX3JhbmdlKCkgZ2V0cyBjYWxsZWQKPiB1
bmRlciBpcF9hbGxvY19zZW0gYW5kIGxvY2tzIHBhZ2VzIGluIG9jZnMyX3RydW5jYXRlX2NsdXN0
ZXJfcGFnZXMoKSAtPgo+IHRydW5jYXRlX2lub2RlX3BhZ2VzX3JhbmdlKCkuIFdoaWNoIGNyZWF0
ZXMgQUJCQSBkZWFkbG9jay4gU28geW91J2xsCj4gcHJvYmFibHkgbmVlZCB0byBjb21lIHVwIHdp
dGggYSBzaW1pbGFyIGRhbmNlIGxpa2UgaW4gb2NmczJfcmVhZHBhZ2UoKS4KPiAKPiBCdXQgYWZ0
ZXIgZml4aW5nIHRoaXMsIGlwX2FsbG9jX3NlbSBzaG91bGQgcHJvdmlkZSB5b3Ugd2l0aCBlbm91
Z2gKPiBwcm90ZWN0aW9uIHNvIHRoYXQgb2NmczIgaXNuJ3QgcHJvbmUgdG8gcmFjZXMgYmV0d2Vl
biBob2xlIHB1bmNoIGFuZAo+IHJlYWRhaGVhZCAvIGZhdWx0IG15IHdvcmsgd2lsbCBiZSBtb3N0
bHkgaXJyZWxldmFudCBmb3IgT0NGUzIuCj4gCj4gVGhhbmtzIGZvciBjb25maXJtYXRpb24hCj4g
Cj4gSG9uemEKPiAKPiBPbiA0LzIyLzIxIDEyOjI5IEFNLCBKYW4gS2FyYSB3cm90ZToKPiBIZWxs
bywKPiAKPiBJJ20gdW5pZnlpbmcgcHJvdGVjdGlvbiB2YXJpb3VzIGZpbGVzeXN0ZW1zIHVzZSB0
byBwcm90ZWN0IGhvbGUgcHVuY2gKPiBvcGVyYXRpb25zIGZyb20gcmFjaW5nIHdpdGggb3RoZXIg
b3BlcmF0aW9ucyAobGlrZSByZWFkYWhlYWQsIHBhZ2UgZmF1bHQsCj4gd3JpdGVwYWdlIGV0Yy4p
LiBJIHdhcyBsb29raW5nIGludG8gT0NGUzIgYW5kIEkgdGhpbmsgaXQgaXMgcHJvbmUgdG8gYQo+
IGZvbGxvd2luZyByYWNlIHdoaWNoIGNhbiBwb3NzaWJseSBsZWFkIHRvIGZpbGVzeXN0ZW0gY29y
cnVwdGlvbi4gQnV0IG1heWJlCj4gSSBtaXNzIHNvbWV0aGluZyBzbyB0aGF0J3Mgd2h5IEknbSB3
cml0aW5nIGhlcmUuIFRoZSBzY2VuYXJpbyBJJ20gY29uY2VybmVkCj4gYWJvdXQgaXM6Cj4gCj4g
Q1BVMSBDUFUyCj4gb2NmczJfcmVtb3ZlX2lub2RlX3JhbmdlKCkgb2NmczJfd3JpdGVwYWdlKCkK
PiAgLi4uICAgYmxvY2tfd3JpdGVfZnVsbF9wYWdlKCkKPiAgb2NmczJfcmVtb3ZlX2J0cmVlX3Jh
bmdlKCkgICAgIG9jZnMyX2V4dGVudF9tYXBfZ2V0X2Jsb2NrcygpCj4gCj4gTm93IG9jZnMyX2V4
dGVudF9tYXBfZ2V0X2Jsb2NrcygpIHJ1bnMgd2l0aG91dCBwcm90ZWN0aW9uIG9mIGlwX2FsbG9j
X3NlbQo+IEFGQUlDVCBhbmQgc28gYm90aCB0aGVzZSBvcGVyYXRpb25zIGNhbiBiZSBtb2RpZnlp
bmcgZXh0ZW50IG1hcCBhdCB0aGUgc2FtZQo+IHRpbWU/IFdoYXQgYW0gSSBtaXNzaW5nPwo+IAo+
IEhvbnphCj4gCj4gLS0KPiBKYW4gS2FyYSA8amFja0BzdXNlLmNvbTxtYWlsdG86amFja0BzdXNl
LmNvbT4+Cj4gU1VTRSBMYWJzLCBDUgo+IAo+IF9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCj4gT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0Cj4gT2NmczItZGV2
ZWxAb3NzLm9yYWNsZS5jb208bWFpbHRvOk9jZnMyLWRldmVsQG9zcy5vcmFjbGUuY29tPgo+IGh0
dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9saXN0aW5mby9vY2ZzMi1kZXZlbAo+IAoKPiBf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwo+IE9jZnMyLWRl
dmVsIG1haWxpbmcgbGlzdAo+IE9jZnMyLWRldmVsQG9zcy5vcmFjbGUuY29tCj4gaHR0cHM6Ly9v
c3Mub3JhY2xlLmNvbS9tYWlsbWFuL2xpc3RpbmZvL29jZnMyLWRldmVsCgoKX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBs
aXN0Ck9jZnMyLWRldmVsQG9zcy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFp
bG1hbi9saXN0aW5mby9vY2ZzMi1kZXZlbA==
