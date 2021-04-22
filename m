Return-Path: <SRS0=okW4=JT=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABD6FC433B4
	for <ocfs2-devel@archiver.kernel.org>; Thu, 22 Apr 2021 16:46:21 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 24EDE613DC
	for <ocfs2-devel@archiver.kernel.org>; Thu, 22 Apr 2021 16:46:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 24EDE613DC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MGjGq8015064;
	Thu, 22 Apr 2021 16:46:19 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2120.oracle.com with ESMTP id 37yqmnp2hs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Apr 2021 16:46:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MGdx65050155;
	Thu, 22 Apr 2021 16:46:18 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 383cg99enu-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 22 Apr 2021 16:46:18 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lZcT3-0002Iy-OY; Thu, 22 Apr 2021 09:46:17 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <djwong@kernel.org>) id 1lZcT1-0002Id-Ao
	for ocfs2-devel@oss.oracle.com; Thu, 22 Apr 2021 09:46:15 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	13MGeClU188179
	for <ocfs2-devel@oss.oracle.com>; Thu, 22 Apr 2021 16:46:15 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by userp3030.oracle.com with ESMTP id 383cdrsm1w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 22 Apr 2021 16:46:15 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	13MGjZ8V026640
	for <ocfs2-devel@oss.oracle.com>; Thu, 22 Apr 2021 16:46:14 GMT
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by userp2030.oracle.com with ESMTP id 383as2kc2v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Thu, 22 Apr 2021 16:46:13 +0000
Received: by mail.kernel.org (Postfix) with ESMTPSA id D574361409;
	Thu, 22 Apr 2021 16:46:05 +0000 (UTC)
Date: Thu, 22 Apr 2021 09:46:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Wengang Wang <wen.gang.wang@oracle.com>
Message-ID: <20210422164605.GA1251862@magnolia>
References: <20210421162953.GA13863@quack2.suse.cz>
	<c4d119be-e263-366c-c2c2-6c58ee852977@linux.alibaba.com>
	<20210422104425.GC26221@quack2.suse.cz>
	<3A2B19E3-3DFF-454E-BFC9-A6B48629509F@oracle.com>
	<20210422160608.GB547183@magnolia>
	<7C502B8A-F978-4DB3-897B-9E726D39F08E@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <7C502B8A-F978-4DB3-897B-9E726D39F08E@oracle.com>
X-PDR: PASS
X-Source-IP: 198.145.29.99
X-ServerName: mail.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx include:_spf.kernel.org ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_safe policy=tap score=0 classifier=
	adjust=0 reason=safe
	scancount=1 engine=8.12.0-2104060000 definitions=main-2104220125
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-MIME-Autoconverted: from 8bit to quoted-printable by userp3030.oracle.com id
	13MGeClU188179
Cc: Jan Kara <jack@suse.cz>, ocfs2-devel ML <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] Possible fs corruption when hole punch races with
 other ops
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220125
X-Proofpoint-ORIG-GUID: cXf6YW6LlQquy_QYqkk9s7IGYy6VJxRz
X-Proofpoint-GUID: cXf6YW6LlQquy_QYqkk9s7IGYy6VJxRz
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 impostorscore=0 spamscore=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104220125

T24gVGh1LCBBcHIgMjIsIDIwMjEgYXQgMDQ6MzY6MjNQTSArMDAwMCwgV2VuZ2FuZyBXYW5nIHdy
b3RlOgo+IAo+IAo+ID4gT24gQXByIDIyLCAyMDIxLCBhdCA5OjA2IEFNLCBEYXJyaWNrIEouIFdv
bmcgPGRqd29uZ0BrZXJuZWwub3JnPiB3cm90ZToKPiA+IAo+ID4gT24gVGh1LCBBcHIgMjIsIDIw
MjEgYXQgMDM6NTY6MTVQTSArMDAwMCwgV2VuZ2FuZyBXYW5nIHdyb3RlOgo+ID4+IEhpIEhvbnph
LAo+ID4+IAo+ID4+IEJ5IOKAnGhvbGUgcHVuY2hpbmcgb3BlcmF0aW9u4oCdLCB5b3UgbWVhbnQg
ZGVhbGxvY2F0ZSBzb21lIGRhdGEgYmxvY2tzCj4gPj4gZnJvbSBhIGZpbGUgYW5kIGtlZXAgdGhl
IGZpbGUgc2l6ZSB1bmNoYW5nZWQsIGFmdGVyIHRoYXQgb3BlcmF0aW9uCj4gPj4gc29tZSDigJxo
b2xlcyIgYXJlIG1hZGUgaW4gdGhhdCBmaWxlLCByaWdodD8KPiA+PiBJIGFtIGp1c3QgY3VyaW91
cyB0aGF0IGRvIHdlIHJlYWxseSBoYXZlIGVuZCB1c2VyIHByb2dyYW1zIHRoYXQgZG8KPiA+PiBo
b2xlIHB1bmNoaW5nIG9uIGZpbGVzPyBPciBob2xlIHB1bmNoaW5nIGlzIG9ubHkgdXNlZCBmb3Ig
ZGV2ZWxvcG1lbnQKPiA+PiBwdXJwb3NlPwo+ID4gCj4gPiBZZXMsIHdlIGRvLiAgUUVNVSBkb2Vz
IGl0IHRvIGltYWdlIGZpbGVzLCB2YXJpb3VzICRkYXRhYmFzZSBwcm9kdWN0cywKPiAKPiBIbSwg
dG8gcnVuIGEgaG9sZSBwdW5jaGluZywgdGhhdCBtZWFucyB0aGUgZGF0YSBibG9ja3MgdG8gZGVh
bGxvY2F0ZQo+IHdlcmUgdXNlZnVsIGJ1dCBub3cgYXJlIG5vIGxvbmdlciB1c2VmdWwuIAo+IEZv
ciBRRU1VLCBpdCBkb2VzIGhvbGUgcHVuY2hpbmcgYXQgZ3Vlc3QgcnVuIHRpbWUgZm9yIGd1ZXN0
IEZTIHRyaW1zPwoKWWVzLiAgU0NTSSBkaXNjYXJkIGNvbW1hbmRzIGFyZSBpbXBsZW1lbnRlZCBh
cyBob2xlIHB1bmNoaW5nIGlmIHRoZQpiYWNraW5nIGRldmljZSBpcyBhIHJhdyBmaWxlIG9uIGEg
ZmlsZXN5c3RlbS4KCi0tRAoKPiBEb27igJl0IGtub3cgaW4gd2hhdCBjYXNlcyBEQnMgbWFrZSB1
c2Ugb2YgaG9sZSBwdW5jaGluZy4KPiBXZWxsLCBnb29kIHRvIGtub3cuCj4gCj4gVGhhbmtzIERh
cnJpY2suCj4gCj4gd2VuZ2FuZwo+IAo+ID4gZXRjLi4uCj4gPiAKPiA+IC0tRAo+ID4gCj4gPj4g
Cj4gPj4gdGhhbmtzLAo+ID4+IHdlbmdhbmcKPiA+PiAKPiA+PiBPbiBBcHIgMjIsIDIwMjEsIGF0
IDM6NDQgQU0sIEphbiBLYXJhIDxqYWNrQHN1c2UuY3o8bWFpbHRvOmphY2tAc3VzZS5jej4+IHdy
b3RlOgo+ID4+IAo+ID4+IEhlbGxvIQo+ID4+IAo+ID4+IE9uIFRodSAyMi0wNC0yMSAxMToyMjow
NywgSm9zZXBoIFFpIHdyb3RlOgo+ID4+IENoZWNrZWQgdGhlIGNvZGUgZmxvdywgaXQgc2VlbXMg
dGhlIHJhY2UgeW91IHdvcnJpZWQgdHJ1bHkgZXhpc3RzLgo+ID4+IFdlIGhhdmUgdG8gdGFrZSBp
cF9hbGxvY19zZW0gYmVmb3JlIGNhbGxpbmcgaW50byBvY2ZzMl9nZXRfYmxvY2soKS4KPiA+PiAK
PiA+PiBPSywgdGhhdCdzIHdoYXQgSSBhc3N1bWVkIGJ1dCB0aGlzIHdvbid0IGJlIGVhc3kuIEJl
Y2F1c2Ugb2NmczJfd3JpdGVwYWdlKCkKPiA+PiBpcyBjYWxsZWQgd2l0aCBhIHBhZ2UgbG9ja2Vk
IGJ1dCBvY2ZzMl9yZW1vdmVfaW5vZGVfcmFuZ2UoKSBnZXRzIGNhbGxlZAo+ID4+IHVuZGVyIGlw
X2FsbG9jX3NlbSBhbmQgbG9ja3MgcGFnZXMgaW4gb2NmczJfdHJ1bmNhdGVfY2x1c3Rlcl9wYWdl
cygpIC0+Cj4gPj4gdHJ1bmNhdGVfaW5vZGVfcGFnZXNfcmFuZ2UoKS4gV2hpY2ggY3JlYXRlcyBB
QkJBIGRlYWRsb2NrLiBTbyB5b3UnbGwKPiA+PiBwcm9iYWJseSBuZWVkIHRvIGNvbWUgdXAgd2l0
aCBhIHNpbWlsYXIgZGFuY2UgbGlrZSBpbiBvY2ZzMl9yZWFkcGFnZSgpLgo+ID4+IAo+ID4+IEJ1
dCBhZnRlciBmaXhpbmcgdGhpcywgaXBfYWxsb2Nfc2VtIHNob3VsZCBwcm92aWRlIHlvdSB3aXRo
IGVub3VnaAo+ID4+IHByb3RlY3Rpb24gc28gdGhhdCBvY2ZzMiBpc24ndCBwcm9uZSB0byByYWNl
cyBiZXR3ZWVuIGhvbGUgcHVuY2ggYW5kCj4gPj4gcmVhZGFoZWFkIC8gZmF1bHQgbXkgd29yayB3
aWxsIGJlIG1vc3RseSBpcnJlbGV2YW50IGZvciBPQ0ZTMi4KPiA+PiAKPiA+PiBUaGFua3MgZm9y
IGNvbmZpcm1hdGlvbiEKPiA+PiAKPiA+PiBIb256YQo+ID4+IAo+ID4+IE9uIDQvMjIvMjEgMTI6
MjkgQU0sIEphbiBLYXJhIHdyb3RlOgo+ID4+IEhlbGxvLAo+ID4+IAo+ID4+IEknbSB1bmlmeWlu
ZyBwcm90ZWN0aW9uIHZhcmlvdXMgZmlsZXN5c3RlbXMgdXNlIHRvIHByb3RlY3QgaG9sZSBwdW5j
aAo+ID4+IG9wZXJhdGlvbnMgZnJvbSByYWNpbmcgd2l0aCBvdGhlciBvcGVyYXRpb25zIChsaWtl
IHJlYWRhaGVhZCwgcGFnZSBmYXVsdCwKPiA+PiB3cml0ZXBhZ2UgZXRjLikuIEkgd2FzIGxvb2tp
bmcgaW50byBPQ0ZTMiBhbmQgSSB0aGluayBpdCBpcyBwcm9uZSB0byBhCj4gPj4gZm9sbG93aW5n
IHJhY2Ugd2hpY2ggY2FuIHBvc3NpYmx5IGxlYWQgdG8gZmlsZXN5c3RlbSBjb3JydXB0aW9uLiBC
dXQgbWF5YmUKPiA+PiBJIG1pc3Mgc29tZXRoaW5nIHNvIHRoYXQncyB3aHkgSSdtIHdyaXRpbmcg
aGVyZS4gVGhlIHNjZW5hcmlvIEknbSBjb25jZXJuZWQKPiA+PiBhYm91dCBpczoKPiA+PiAKPiA+
PiBDUFUxIENQVTIKPiA+PiBvY2ZzMl9yZW1vdmVfaW5vZGVfcmFuZ2UoKSBvY2ZzMl93cml0ZXBh
Z2UoKQo+ID4+IC4uLiAgIGJsb2NrX3dyaXRlX2Z1bGxfcGFnZSgpCj4gPj4gb2NmczJfcmVtb3Zl
X2J0cmVlX3JhbmdlKCkgICAgIG9jZnMyX2V4dGVudF9tYXBfZ2V0X2Jsb2NrcygpCj4gPj4gCj4g
Pj4gTm93IG9jZnMyX2V4dGVudF9tYXBfZ2V0X2Jsb2NrcygpIHJ1bnMgd2l0aG91dCBwcm90ZWN0
aW9uIG9mIGlwX2FsbG9jX3NlbQo+ID4+IEFGQUlDVCBhbmQgc28gYm90aCB0aGVzZSBvcGVyYXRp
b25zIGNhbiBiZSBtb2RpZnlpbmcgZXh0ZW50IG1hcCBhdCB0aGUgc2FtZQo+ID4+IHRpbWU/IFdo
YXQgYW0gSSBtaXNzaW5nPwo+ID4+IAo+ID4+IEhvbnphCj4gPj4gCj4gPj4gLS0KPiA+PiBKYW4g
S2FyYSA8amFja0BzdXNlLmNvbTxtYWlsdG86amFja0BzdXNlLmNvbT4+Cj4gPj4gU1VTRSBMYWJz
LCBDUgo+ID4+IAo+ID4+IF9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCj4gPj4gT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0Cj4gPj4gT2NmczItZGV2ZWxAb3Nz
Lm9yYWNsZS5jb208bWFpbHRvOk9jZnMyLWRldmVsQG9zcy5vcmFjbGUuY29tPgo+ID4+IGh0dHBz
Oi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9saXN0aW5mby9vY2ZzMi1kZXZlbAo+ID4+IAo+ID4g
Cj4gPj4gX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KPiA+
PiBPY2ZzMi1kZXZlbCBtYWlsaW5nIGxpc3QKPiA+PiBPY2ZzMi1kZXZlbEBvc3Mub3JhY2xlLmNv
bQo+ID4+IGh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9saXN0aW5mby9vY2ZzMi1kZXZl
bAo+ID4gCj4gCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
XwpPY2ZzMi1kZXZlbCBtYWlsaW5nIGxpc3QKT2NmczItZGV2ZWxAb3NzLm9yYWNsZS5jb20KaHR0
cHM6Ly9vc3Mub3JhY2xlLmNvbS9tYWlsbWFuL2xpc3RpbmZvL29jZnMyLWRldmVs
