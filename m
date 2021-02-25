Return-Path: <SRS0=/Yqq=H3=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88EDEC433DB
	for <ocfs2-devel@archiver.kernel.org>; Thu, 25 Feb 2021 20:48:53 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E65BF60201
	for <ocfs2-devel@archiver.kernel.org>; Thu, 25 Feb 2021 20:48:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E65BF60201
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=helmholtz-muenchen.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11PKmm7H090993;
	Thu, 25 Feb 2021 20:48:52 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2130.oracle.com with ESMTP id 36vr62a83c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Feb 2021 20:48:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11PKeb8r057328;
	Thu, 25 Feb 2021 20:48:51 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 36ucc1qrs2-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 25 Feb 2021 20:48:50 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lFNZ3-00027h-2A; Thu, 25 Feb 2021 12:48:49 -0800
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <bernd.lentes@helmholtz-muenchen.de>)
	id 1lFNYy-00027G-4K
	for ocfs2-devel@oss.oracle.com; Thu, 25 Feb 2021 12:48:44 -0800
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11PKehvD053183
	for <ocfs2-devel@oss.oracle.com>; Thu, 25 Feb 2021 20:48:44 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by aserp3020.oracle.com with ESMTP id 36ucb2hvgm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 25 Feb 2021 20:48:44 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11PKj7ix025589
	for <ocfs2-devel@oss.oracle.com>; Thu, 25 Feb 2021 20:48:43 GMT
Received: from mtaextp1.scidom.de (mtaextp1.scidom.de [146.107.3.202])
	by userp2040.oracle.com with ESMTP id 36wskfcd66-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Thu, 25 Feb 2021 20:48:43 +0000
Received: from localhost (localhost [127.0.0.1])
	by mtaextp1.scidom.de (Postfix) with ESMTP id 21094180346BE;
	Thu, 25 Feb 2021 21:48:25 +0100 (CET)
Received: from mtaextp1.scidom.de ([127.0.0.1])
	by localhost (mtaextp1.scidom.de [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id g7m_Ci6sOD9B; Thu, 25 Feb 2021 21:48:25 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mtaextp1.scidom.de (Postfix) with ESMTP id F0B8D181DF62A;
	Thu, 25 Feb 2021 21:48:24 +0100 (CET)
X-Amavis-Modified: Mail body modified (using disclaimer) - mtaextp1.scidom.de
X-Virus-Scanned: amavisd-new at mtaextp1.scidom.de
Received: from mtaextp1.scidom.de ([127.0.0.1])
	by localhost (mtaextp1.scidom.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id dQoIco6sYFQH; Thu, 25 Feb 2021 21:48:24 +0100 (CET)
Received: from mtaintp1.scidom.de (mtaintp1.scidom.de [146.107.8.197])
	by mtaextp1.scidom.de (Postfix) with ESMTPS id BF212180346BE;
	Thu, 25 Feb 2021 21:48:24 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mtaintp1.scidom.de (Postfix) with ESMTP id 2EB1B8694CB6;
	Thu, 25 Feb 2021 21:48:39 +0100 (CET)
Received: from mtaintp1.scidom.de ([127.0.0.1])
	by localhost (mtaintp1.scidom.de [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id 8YBXApKgXSIM; Thu, 25 Feb 2021 21:48:39 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mtaintp1.scidom.de (Postfix) with ESMTP id 124AB8694CCB;
	Thu, 25 Feb 2021 21:48:39 +0100 (CET)
X-Amavis-Modified: Mail body modified (using disclaimer) - mtaintp1.scidom.de
X-Virus-Scanned: amavisd-new at mtaintp1.scidom.de
Received: from mtaintp1.scidom.de ([127.0.0.1])
	by localhost (mtaintp1.scidom.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id DE66qNNe_ehn; Thu, 25 Feb 2021 21:48:38 +0100 (CET)
Received: from mbxp1.scidom.de (mbxp1.scidom.de [146.107.8.207])
	by mtaintp1.scidom.de (Postfix) with ESMTP id EB7A88694CB6;
	Thu, 25 Feb 2021 21:48:38 +0100 (CET)
Date: Thu, 25 Feb 2021 21:48:38 +0100 (CET)
From: "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>
To: Wengang Wang <wen.gang.wang@oracle.com>
Message-ID: <603384094.63786431.1614286118678.JavaMail.zimbra@helmholtz-muenchen.de>
In-Reply-To: <4CCBAF2C-837A-41B9-BA87-825C5AEC0501@oracle.com>
References: <1884783914.58523079.1614110913964.JavaMail.zimbra@helmholtz-muenchen.de>
	<01866DBC-59D3-4D41-B404-C76FCA6B6221@oracle.com>
	<834203578.59367045.1614157887078.JavaMail.zimbra@helmholtz-muenchen.de>
	<B8316D3D-A4CB-4248-9596-C26FB7B914FB@oracle.com>
	<923372681.62923711.1614256785266.JavaMail.zimbra@helmholtz-muenchen.de>
	<4CCBAF2C-837A-41B9-BA87-825C5AEC0501@oracle.com>
MIME-Version: 1.0
X-Originating-IP: [146.107.158.232]
X-Mailer: Zimbra 8.8.15_GA_3968 (ZimbraWebClient - GC88 (Win)/8.8.15_GA_3968)
Thread-Topic: error message in log: ocfs2_reflink_ioctl:4431 ERROR: status =
	-17
Thread-Index: g5xUhHWN9KIR5CmwxPJXuTW4kSHzTvVrXEYA5yqc6AqY1uuggJ91S3cq4IvxYgCW2S0/DQ==
X-PDR: PASS
X-Source-IP: 146.107.3.202
X-ServerName: mtaextp1.scidom.de
X-Proofpoint-SPF-Result: None
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
	adultscore=0
	lowpriorityscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
	priorityscore=0 suspectscore=0 malwarescore=0 clxscore=206
	impostorscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2102250159
X-Spam: Clean
Cc: ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] error message in log: ocfs2_reflink_ioctl:4431
 ERROR:	status = -17
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102250159
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 impostorscore=0 adultscore=0 mlxscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102250160

CgotLSAKCkJlcm5kIExlbnRlcyAKU3lzdGVtIEFkbWluaXN0cmF0b3IgCkluc3RpdHV0ZSBmb3Ig
TWV0YWJvbGlzbSBhbmQgQ2VsbCBEZWF0aCAoTUNEKSAKQnVpbGRpbmcgMjUgLSBvZmZpY2UgMTIy
IApIZWxtaG9sdHpaZW50cnVtIE3DvG5jaGVuIApiZXJuZC5sZW50ZXNAaGVsbWhvbHR6LW11ZW5j
aGVuLmRlIApwaG9uZTogKzQ5IDg5IDMxODcgMTI0MSAKcGhvbmU6ICs0OSA4OSAzMTg3IDM4Mjcg
CmZheDogKzQ5IDg5IDMxODcgMjI5NCAKaHR0cDovL3d3dy5oZWxtaG9sdHotbXVlbmNoZW4uZGUv
bWNkCgotLS0tLSBPbiBGZWIgMjUsIDIwMjEsIGF0IDU6NDMgUE0sIFdlbmdhbmcgV2FuZyB3ZW4u
Z2FuZy53YW5nQG9yYWNsZS5jb20gd3JvdGU6Cgo+PiBPbiBGZWIgMjUsIDIwMjEsIGF0IDQ6Mzkg
QU0sIExlbnRlcywgQmVybmQgPCBbCj4+IG1haWx0bzpiZXJuZC5sZW50ZXNAaGVsbWhvbHR6LW11
ZW5jaGVuLmRlIHwgYmVybmQubGVudGVzQGhlbG1ob2x0ei1tdWVuY2hlbi5kZQo+PiBdID4gd3Jv
dGU6Cgo+PiAtLS0tLSBPbiBGZWIgMjQsIDIwMjEsIGF0IDEwOjQ5IFBNLCBXZW5nYW5nIFdhbmcg
Wwo+PiBtYWlsdG86d2VuLmdhbmcud2FuZ0BvcmFjbGUuY29tIHwgd2VuLmdhbmcud2FuZ0BvcmFj
bGUuY29tIF0gd3JvdGU6Cgo+Pj4+IE9uIEZlYiAyNCwgMjAyMSwgYXQgMToxMSBBTSwgTGVudGVz
LCBCZXJuZCA8IFsKPj4+PiBtYWlsdG86YmVybmQubGVudGVzQGhlbG1ob2x0ei1tdWVuY2hlbi5k
ZSB8IGJlcm5kLmxlbnRlc0BoZWxtaG9sdHotbXVlbmNoZW4uZGUKPj4+PiBdID4KPj4+PiB3cm90
ZToKCj4+Pj4gLS0tLS0gT24gRmViIDIzLCAyMDIxLCBhdCAxMToyNCBQTSwgV2VuZ2FuZyBXYW5n
IFsKPj4+PiBtYWlsdG86d2VuLmdhbmcud2FuZ0BvcmFjbGUuY29tIHwKPj4+PiB3ZW4uZ2FuZy53
YW5nQG9yYWNsZS5jb20gXSB3cm90ZToKCj4+Pj4+ICNkZWZpbmUgRUVYSVNUIDE3IC8qIEZpbGUg
ZXhpc3RzICovCgo+Pj4+PiBZb3UgbWF5IGFscmVhZHkgaGF2ZSB0aGUgZmlsZSBjcmVhdGVkIGZy
b20gdGhlIG90aGVyIG5vZGUuCgo+Pj4+PiB3ZW5nYW5nCgo+Pj4+IEhpIFdlbmdhbmcsCgo+Pj4+
IHRoYW5rcyBmb3IgeW91ciBoZWxwLgoKPj4+PiBUaGUgcmVmbGluayBpcyBjcmVhdGVkIHZpYToK
Pj4+PiByZWZsaW5rIC1mdiAvcGF0aC90by9kb21haW4ucmF3IC9tbnQvb2NmczIvcmVmbGluawoK
Pj4+PiBPZiBjb3Vyc2UgdGhpcyBmaWxlIGV4aXN0cyBhbHJlYWR5IGJlY2F1c2UgdGhlIHNrcmlw
dCByYW4gYWxzbyBvbmUgZGF5IGJlZm9yZS4KPj4+PiBCdXQgZnJvbSB3aGljaCBub2RlIHRoZSBw
cmV2aW91cyBvbmUgd2FzIGNyZWF0ZWQgaXMgdW5wcmVkaWN0YWJsZSwgaXQgbWlnaHQgYmUKPj4+
PiB0aGUgc2FtZQo+Pj4+IGJ1dCBhbHNvIHRoZSBvdGhlciBvbmUuCgo+Pj4+IElzIHRoZSBtZXNz
YWdlIHNldmVyZSBvciBkb24ndCBpIGhhdmUgdG8gYm90aGVyIGFib3V0IGl0ID8KCj4+PiBPQ0ZT
MiBpcyBhIHNoYXJlZC1zdG9yYWdlIGNsdXN0ZXIgRlMuIEZvciB0aGUgcmVmbGlua3MsIHlvdSBu
ZWVkIGFuZCBzaG91bGQKPj4+IGNyZWF0ZSB0aGVtIG9ubHkgZnJvbSBvbmUgb2YgdGhlIG5vZGVz
LiBEb27igJl0IGRvIGR1cGxpY2F0ZWQgd29yayAocmVmbGluaykgb24KPj4+IG90aGVyIG5vZGVz
LgoKPj4gSGkgV2VuZ2FuZywKCj4+IHRoYW5rcyBmb3IgeW91ciBoZWxwLgo+PiBKdXN0IHRvIGJl
IHN1cmUgdGhhdCBpIHVuZGVyc3RhbmQgeW91IGNvbXBsZXRlbHk6Cj4+IHdlIHJlZmxpbmsgc29t
ZSByYXcgZmlsZSBmcm9tIGhvc3QgMSBhbmQgT1RIRVIgcmF3IGZpbGVzIChub3QgdGhlIHNhbWUg
ISkgZnJvbQo+PiBob3N0IDIuCj4+IElzIHRoYXQgYWxyZWFkeSBhIHByb2JsZW0gPyBPciBhcmUg
eW91IHRhbGtpbmcgYWJvdXQgcmVmbGlua2luZyB0aGUgU0FNRSBmaWxlCj4+IGNvbmN1cnJlbnRs
eSBmcm9tIGJvdGggbm9kZXMgPwoKPiBObywgdGhhdOKAmXMgbm90IGEgcHJvYmxlbS4gTWFrZSBz
dXJlIHlvdXIgYXBwbGljYXRpb25zIGRvZXMgdGhlIHNhbWUgYXMgeW91IHdhbnQuCj4gRnJvbSB0
aGUgZXJyb3IgbWVzc2FnZSwgeW91ciBhcHAgY291bGQgYmUgY3JlYXRpbmcgZHVwbGljYXRlZCBy
ZWZsaW5rcyBmcm9tIG9uZQo+IG9yIHR3byBub2Rlcy4KPiBUaGF04oCZcyB3aGF0IHdlIGNhbiBr
bm93IGJ5IHRoZSBlcnJvciBtZXNzYWdlLiBJIGFtIHN1c3BlY3RpbmcgdGhlIHByb2JsZW0gaXMg
aW4KPiB5b3VyIGFwcCwgeW91IGNvdWxkIHRyeSB0byBkZWJ1ZyBpdC4KCj4gdGhhbmtzLAo+IHdl
bmdhbmcKCkhpLAoKd2hhdCB3ZSBkbyBpcyB0byBvdmVyd3JpdGUgdGhlIHJlZmxpbmsgZnJvbSB0
aGUgZGF5IGJlZm9yZSB3aXRoIHRoZSBjdXJyZW50IG9uZSwgd2l0aCB0aGUgc2FtZSBuYW1lLgpG
b3IgdGhpcyB3ZSB1c2UgcmVmbGluayAtZi4gQ291bGQgdGhhdCBiZSB0aGUgY3VscHJpdCA/ClNo
b3VsZCB3ZSBkZWxldGUgdGhlIG9sZCBvbmUgYmVmb3JlID8gT3IgbWF5YmUgdXNlIHVuaXF1ZSBu
YW1lcyBmb3IgZWFjaCByZWZsaW5rID8KClRoYW5rcy4KCkJlcm5kCkhlbG1ob2x0eiBaZW50cnVt
IE3DvG5jaGVuCgpIZWxtaG9sdHogWmVudHJ1bSBNdWVuY2hlbgpEZXV0c2NoZXMgRm9yc2NodW5n
c3plbnRydW0gZnVlciBHZXN1bmRoZWl0IHVuZCBVbXdlbHQgKEdtYkgpCkluZ29sc3RhZWR0ZXIg
TGFuZHN0ci4gMQo4NTc2NCBOZXVoZXJiZXJnCnd3dy5oZWxtaG9sdHotbXVlbmNoZW4uZGUKQXVm
c2ljaHRzcmF0c3ZvcnNpdHplbmRlOiBNaW5EaXIuaW4gUHJvZi4gRHIuIFZlcm9uaWthIHZvbiBN
ZXNzbGluZwpHZXNjaGFlZnRzZnVlaHJ1bmc6IFByb2YuIERyLiBtZWQuIERyLiBoLmMuIE1hdHRo
aWFzIFRzY2hvZXAsIEtlcnN0aW4gR3VlbnRoZXIKUmVnaXN0ZXJnZXJpY2h0OiBBbXRzZ2VyaWNo
dCBNdWVuY2hlbiBIUkIgNjQ2NgpVU3QtSWROcjogREUgMTI5NTIxNjcxCgoKX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBs
aXN0Ck9jZnMyLWRldmVsQG9zcy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFp
bG1hbi9saXN0aW5mby9vY2ZzMi1kZXZlbA==
