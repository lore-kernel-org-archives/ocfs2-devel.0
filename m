Return-Path: <SRS0=/Yqq=H3=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08F85C433E0
	for <ocfs2-devel@archiver.kernel.org>; Thu, 25 Feb 2021 12:40:22 +0000 (UTC)
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1D52B64F0F
	for <ocfs2-devel@archiver.kernel.org>; Thu, 25 Feb 2021 12:40:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1D52B64F0F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=helmholtz-muenchen.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
	by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11PCdIdG077587;
	Thu, 25 Feb 2021 12:40:19 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by userp2120.oracle.com with ESMTP id 36ugq3n6ja-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Feb 2021 12:40:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11PCKbRV061886;
	Thu, 25 Feb 2021 12:40:18 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 36ucc160dv-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 25 Feb 2021 12:40:18 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lFFwG-0004T9-R9; Thu, 25 Feb 2021 04:40:16 -0800
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <bernd.lentes@helmholtz-muenchen.de>)
	id 1lFFvs-0004Mt-EK
	for ocfs2-devel@oss.oracle.com; Thu, 25 Feb 2021 04:39:52 -0800
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11PCKdd1079976
	for <ocfs2-devel@oss.oracle.com>; Thu, 25 Feb 2021 12:39:52 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by aserp3030.oracle.com with ESMTP id 36v9m77h8p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 25 Feb 2021 12:39:52 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11PCMuGL019331
	for <ocfs2-devel@oss.oracle.com>; Thu, 25 Feb 2021 12:39:51 GMT
Received: from mtaextp1.scidom.de (mtaextp1.scidom.de [146.107.3.202])
	by userp2030.oracle.com with ESMTP id 36wqdy59jg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Thu, 25 Feb 2021 12:39:49 +0000
Received: from localhost (localhost [127.0.0.1])
	by mtaextp1.scidom.de (Postfix) with ESMTP id E4FBE18046756;
	Thu, 25 Feb 2021 13:39:31 +0100 (CET)
Received: from mtaextp1.scidom.de ([127.0.0.1])
	by localhost (mtaextp1.scidom.de [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id eFHruKnZ6KCH; Thu, 25 Feb 2021 13:39:31 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mtaextp1.scidom.de (Postfix) with ESMTP id C251518046759;
	Thu, 25 Feb 2021 13:39:31 +0100 (CET)
X-Amavis-Modified: Mail body modified (using disclaimer) - mtaextp1.scidom.de
X-Virus-Scanned: amavisd-new at mtaextp1.scidom.de
Received: from mtaextp1.scidom.de ([127.0.0.1])
	by localhost (mtaextp1.scidom.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id hts7Y_0B_sX8; Thu, 25 Feb 2021 13:39:31 +0100 (CET)
Received: from mtaintp1.scidom.de (mtaintp1.scidom.de [146.107.8.197])
	by mtaextp1.scidom.de (Postfix) with ESMTPS id 9FE9418046756;
	Thu, 25 Feb 2021 13:39:31 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mtaintp1.scidom.de (Postfix) with ESMTP id C16348642CCE;
	Thu, 25 Feb 2021 13:39:45 +0100 (CET)
Received: from mtaintp1.scidom.de ([127.0.0.1])
	by localhost (mtaintp1.scidom.de [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id BH-0XsfPTQ9A; Thu, 25 Feb 2021 13:39:45 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mtaintp1.scidom.de (Postfix) with ESMTP id A6D3A8642CD0;
	Thu, 25 Feb 2021 13:39:45 +0100 (CET)
X-Amavis-Modified: Mail body modified (using disclaimer) - mtaintp1.scidom.de
X-Virus-Scanned: amavisd-new at mtaintp1.scidom.de
Received: from mtaintp1.scidom.de ([127.0.0.1])
	by localhost (mtaintp1.scidom.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id dYzEksCkcOyE; Thu, 25 Feb 2021 13:39:45 +0100 (CET)
Received: from mbxp1.scidom.de (mbxp1.scidom.de [146.107.8.207])
	by mtaintp1.scidom.de (Postfix) with ESMTP id 8AC778642CCE;
	Thu, 25 Feb 2021 13:39:45 +0100 (CET)
Date: Thu, 25 Feb 2021 13:39:45 +0100 (CET)
From: "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>
To: ocfs2-devel <ocfs2-devel@oss.oracle.com>
Message-ID: <923372681.62923711.1614256785266.JavaMail.zimbra@helmholtz-muenchen.de>
In-Reply-To: <B8316D3D-A4CB-4248-9596-C26FB7B914FB@oracle.com>
References: <1884783914.58523079.1614110913964.JavaMail.zimbra@helmholtz-muenchen.de>
	<01866DBC-59D3-4D41-B404-C76FCA6B6221@oracle.com>
	<834203578.59367045.1614157887078.JavaMail.zimbra@helmholtz-muenchen.de>
	<B8316D3D-A4CB-4248-9596-C26FB7B914FB@oracle.com>
MIME-Version: 1.0
X-Originating-IP: [146.107.158.232]
X-Mailer: Zimbra 8.8.15_GA_3968 (ZimbraWebClient - GC88 (Win)/8.8.15_GA_3968)
Thread-Topic: error message in log: ocfs2_reflink_ioctl:4431 ERROR: status =
	-17
Thread-Index: g5xUhHWN9KIR5CmwxPJXuTW4kSHzTvVrXEYA5yqc6AqY1uuggJ91S3cq
X-PDR: PASS
X-Source-IP: 146.107.3.202
X-ServerName: mtaextp1.scidom.de
X-Proofpoint-SPF-Result: None
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9905
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	lowpriorityscore=0 spamscore=0
	malwarescore=0 bulkscore=0 impostorscore=0 mlxscore=0 adultscore=0
	suspectscore=0 priorityscore=0 mlxlogscore=999 phishscore=0
	clxscore=206
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2102250098
X-Spam: Clean
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9905 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102250098
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9905 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102250099

CgotLS0tLSBPbiBGZWIgMjQsIDIwMjEsIGF0IDEwOjQ5IFBNLCBXZW5nYW5nIFdhbmcgd2VuLmdh
bmcud2FuZ0BvcmFjbGUuY29tIHdyb3RlOgoKPj4gT24gRmViIDI0LCAyMDIxLCBhdCAxOjExIEFN
LCBMZW50ZXMsIEJlcm5kIDxiZXJuZC5sZW50ZXNAaGVsbWhvbHR6LW11ZW5jaGVuLmRlPgo+PiB3
cm90ZToKPj4gCj4+IAo+PiAtLS0tLSBPbiBGZWIgMjMsIDIwMjEsIGF0IDExOjI0IFBNLCBXZW5n
YW5nIFdhbmcgd2VuLmdhbmcud2FuZ0BvcmFjbGUuY29tIHdyb3RlOgo+PiAKPj4+ICNkZWZpbmUg
RUVYSVNUIDE3IC8qIEZpbGUgZXhpc3RzICovCj4+IAo+Pj4gWW91IG1heSBhbHJlYWR5IGhhdmUg
dGhlIGZpbGUgY3JlYXRlZCBmcm9tIHRoZSBvdGhlciBub2RlLgo+PiAKPj4+IHdlbmdhbmcKPj4g
Cj4+IAo+PiBIaSBXZW5nYW5nLAo+PiAKPj4gdGhhbmtzIGZvciB5b3VyIGhlbHAuCj4+IAo+PiBU
aGUgcmVmbGluayBpcyBjcmVhdGVkIHZpYToKPj4gcmVmbGluayAtZnYgL3BhdGgvdG8vZG9tYWlu
LnJhdyAvbW50L29jZnMyL3JlZmxpbmsKPj4gCj4+IE9mIGNvdXJzZSB0aGlzIGZpbGUgZXhpc3Rz
IGFscmVhZHkgYmVjYXVzZSB0aGUgc2tyaXB0IHJhbiBhbHNvIG9uZSBkYXkgYmVmb3JlLgo+PiBC
dXQgZnJvbSB3aGljaCBub2RlIHRoZSBwcmV2aW91cyBvbmUgd2FzIGNyZWF0ZWQgaXMgdW5wcmVk
aWN0YWJsZSwgaXQgbWlnaHQgYmUKPj4gdGhlIHNhbWUKPj4gYnV0IGFsc28gdGhlIG90aGVyIG9u
ZS4KPj4gCj4+IElzIHRoZSBtZXNzYWdlIHNldmVyZSBvciBkb24ndCBpIGhhdmUgdG8gYm90aGVy
IGFib3V0IGl0ID8KPj4gCj4gCj4gT0NGUzIgaXMgYSBzaGFyZWQtc3RvcmFnZSBjbHVzdGVyIEZT
LiAgRm9yIHRoZSByZWZsaW5rcywgeW91IG5lZWQgYW5kIHNob3VsZAo+IGNyZWF0ZSB0aGVtIG9u
bHkgZnJvbSBvbmUgb2YgdGhlIG5vZGVzLiBEb27igJl0IGRvIGR1cGxpY2F0ZWQgd29yayAocmVm
bGluaykgb24KPiBvdGhlciBub2Rlcy4KCkhpIFdlbmdhbmcsCgp0aGFua3MgZm9yIHlvdXIgaGVs
cC4KSnVzdCB0byBiZSBzdXJlIHRoYXQgaSB1bmRlcnN0YW5kIHlvdSBjb21wbGV0ZWx5Ogp3ZSBy
ZWZsaW5rIHNvbWUgcmF3IGZpbGUgZnJvbSBob3N0IDEgYW5kIE9USEVSIHJhdyBmaWxlcyAobm90
IHRoZSBzYW1lICEpIGZyb20gaG9zdCAyLgpJcyB0aGF0IGFscmVhZHkgYSBwcm9ibGVtID8gT3Ig
YXJlIHlvdSB0YWxraW5nIGFib3V0IHJlZmxpbmtpbmcgdGhlIFNBTUUgZmlsZSBjb25jdXJyZW50
bHkgZnJvbSBib3RoIG5vZGVzID8KCkJlcm5kCkhlbG1ob2x0eiBaZW50cnVtIE3DvG5jaGVuCgpI
ZWxtaG9sdHogWmVudHJ1bSBNdWVuY2hlbgpEZXV0c2NoZXMgRm9yc2NodW5nc3plbnRydW0gZnVl
ciBHZXN1bmRoZWl0IHVuZCBVbXdlbHQgKEdtYkgpCkluZ29sc3RhZWR0ZXIgTGFuZHN0ci4gMQo4
NTc2NCBOZXVoZXJiZXJnCnd3dy5oZWxtaG9sdHotbXVlbmNoZW4uZGUKQXVmc2ljaHRzcmF0c3Zv
cnNpdHplbmRlOiBNaW5EaXIuaW4gUHJvZi4gRHIuIFZlcm9uaWthIHZvbiBNZXNzbGluZwpHZXNj
aGFlZnRzZnVlaHJ1bmc6IFByb2YuIERyLiBtZWQuIERyLiBoLmMuIE1hdHRoaWFzIFRzY2hvZXAs
IEtlcnN0aW4gR3VlbnRoZXIKUmVnaXN0ZXJnZXJpY2h0OiBBbXRzZ2VyaWNodCBNdWVuY2hlbiBI
UkIgNjQ2NgpVU3QtSWROcjogREUgMTI5NTIxNjcxCgoKX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0Ck9jZnMyLWRl
dmVsQG9zcy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9saXN0aW5m
by9vY2ZzMi1kZXZlbA==
