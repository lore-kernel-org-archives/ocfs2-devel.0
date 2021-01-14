Return-Path: <SRS0=aUy8=GR=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B89C433DB
	for <ocfs2-devel@archiver.kernel.org>; Thu, 14 Jan 2021 16:37:10 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 50FE323A04
	for <ocfs2-devel@archiver.kernel.org>; Thu, 14 Jan 2021 16:37:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 50FE323A04
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=helmholtz-muenchen.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10EGXlqU062368;
	Thu, 14 Jan 2021 16:37:09 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2130.oracle.com with ESMTP id 360kg2147a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Jan 2021 16:37:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10EGYrdK009312;
	Thu, 14 Jan 2021 16:37:08 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 360kenf6nj-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 14 Jan 2021 16:37:07 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l05cQ-0005JC-Us; Thu, 14 Jan 2021 08:37:06 -0800
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <bernd.lentes@helmholtz-muenchen.de>)
	id 1kzyyU-0007y9-EP; Thu, 14 Jan 2021 01:31:26 -0800
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10E9UmbG158324; Thu, 14 Jan 2021 09:31:26 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by userp3030.oracle.com with ESMTP id 360kemwk80-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Jan 2021 09:31:25 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10E9DpSW040027; Thu, 14 Jan 2021 09:31:25 GMT
Received: from mtaextp1.scidom.de (mtaextp1.scidom.de [146.107.3.202])
	by userp2040.oracle.com with ESMTP id 362jq71ckg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Thu, 14 Jan 2021 09:31:24 +0000
Received: from localhost (localhost [127.0.0.1])
	by mtaextp1.scidom.de (Postfix) with ESMTP id B8DE4181DF009;
	Thu, 14 Jan 2021 10:31:16 +0100 (CET)
Received: from mtaextp1.scidom.de ([127.0.0.1])
	by localhost (mtaextp1.scidom.de [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id BN_DI4RA5-bt; Thu, 14 Jan 2021 10:31:16 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mtaextp1.scidom.de (Postfix) with ESMTP id 95029181DF00B;
	Thu, 14 Jan 2021 10:31:16 +0100 (CET)
X-Amavis-Modified: Mail body modified (using disclaimer) - mtaextp1.scidom.de
X-Virus-Scanned: amavisd-new at mtaextp1.scidom.de
Received: from mtaextp1.scidom.de ([127.0.0.1])
	by localhost (mtaextp1.scidom.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Ey5istrTg-OK; Thu, 14 Jan 2021 10:31:16 +0100 (CET)
Received: from mtaintp1.scidom.de (mtaintp1.scidom.de [146.107.8.197])
	by mtaextp1.scidom.de (Postfix) with ESMTPS id 70160181DF008;
	Thu, 14 Jan 2021 10:31:16 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mtaintp1.scidom.de (Postfix) with ESMTP id C0CCF824E9A7;
	Thu, 14 Jan 2021 10:31:19 +0100 (CET)
Received: from mtaintp1.scidom.de ([127.0.0.1])
	by localhost (mtaintp1.scidom.de [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id 64a75yM9cSRF; Thu, 14 Jan 2021 10:31:19 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mtaintp1.scidom.de (Postfix) with ESMTP id A56BD824E9AC;
	Thu, 14 Jan 2021 10:31:19 +0100 (CET)
X-Amavis-Modified: Mail body modified (using disclaimer) - mtaintp1.scidom.de
X-Virus-Scanned: amavisd-new at mtaintp1.scidom.de
Received: from mtaintp1.scidom.de ([127.0.0.1])
	by localhost (mtaintp1.scidom.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ujSuRmm-grn4; Thu, 14 Jan 2021 10:31:19 +0100 (CET)
Received: from mbxp1.scidom.de (mbxp1.scidom.de [146.107.8.207])
	by mtaintp1.scidom.de (Postfix) with ESMTP id 8B668824E9A7;
	Thu, 14 Jan 2021 10:31:19 +0100 (CET)
Date: Thu, 14 Jan 2021 10:31:19 +0100 (CET)
From: "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>
To: Gang He <ghe@suse.com>
Message-ID: <1297384989.109460873.1610616679313.JavaMail.zimbra@helmholtz-muenchen.de>
In-Reply-To: <5dc2903f-d59b-31fb-dda4-3fb0fbe83798@suse.com>
References: <2040150856.105362879.1610376125778.JavaMail.zimbra@helmholtz-muenchen.de>
	<71d2b3a4-8cdd-8d83-c6c3-abb00038b102@suse.com>
	<1400213487.108454266.1610546335237.JavaMail.zimbra@helmholtz-muenchen.de>
	<5dc2903f-d59b-31fb-dda4-3fb0fbe83798@suse.com>
MIME-Version: 1.0
X-Originating-IP: [146.107.127.87]
X-Mailer: Zimbra 8.8.15_GA_3968 (ZimbraWebClient - GC87 (Win)/8.8.15_GA_3968)
Thread-Topic: how to find out the real size of a reflink ?
Thread-Index: mLM1NJCiLPVb5NzCjO5bUHwNSzLXqQ==
X-PDR: PASS
X-Source-IP: 146.107.3.202
X-ServerName: mtaextp1.scidom.de
X-Proofpoint-SPF-Result: None
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9863
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
	spamscore=0 suspectscore=0
	impostorscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0
	clxscore=183
	mlxscore=0 mlxlogscore=838 malwarescore=0 priorityscore=0
	classifier=spam
	adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
	definitions=main-2101140053
X-Spam: Clean
X-MIME-Autoconverted: from 8bit to quoted-printable by userp3030.oracle.com id
	10E9UmbG158324
X-Mailman-Approved-At: Thu, 14 Jan 2021 08:37:05 -0800
Cc: OCFS2 ML <ocfs2-users@oss.oracle.com>, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [Ocfs2-users] how to find out the real size of a
	reflink ?
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
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101140094
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 clxscore=1011 impostorscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101140094

CgotLS0tLSBPbiBKYW4gMTQsIDIwMjEsIGF0IDI6NTAgQU0sIEdhbmcgSGUgZ2hlQHN1c2UuY29t
IHdyb3RlOgoKPiBIaSBMZW50ZXMsCj4gCj4gc2VlIG15IGNvbW1lbnRzIGlubGluZS4KCj4+IAo+
PiBTb21lIHF1ZXN0aW9uczoKPj4gCj4+IFdoYXQgaXMgYSBjbHVzdGVyID8KPj4gV2hhdCBpcyBh
biBleHRlbnQgPwo+IEluIHRoZSB0cmFkaXRpb25hbCBmaWxlIHN5c3RlbSwgYSBmaWxlIGNvbnNp
c3RzIG9mIG1ldGEtZGF0YSBibG9ja3MgYW5kCj4gZGF0YSBibG9ja3MsIGJ1dCBmb3Igb2NmczIg
ZmlsZSBzeXN0ZW0sIGEgZmlsZSBjb25zaXN0cyBvZiBtZXRhLWRhdGEKPiBibG9ja3MgYW5kIGRh
dGEgY2x1c3RlcnMsIHRoZSBjbHVzdGVyIHNpemUgY2FuIGdyZWF0ZXIgdGhhbiB0aGUgYmxvY2sK
PiBzaXplIHRvIHNhdmUgbWV0YS1kYXRhIGJsb2NrIGNvbnN1bXB0aW9uLgo+IFRoZSBmaWxlIGRh
dGEgaXMgY29udGFpbmVkIGJ5IGNsdXN0ZXJzLCB0aGUgZmlsZSBtZXRhIGRhdGEgaXMgY29udGFp
bmVkCj4gYnkgYmxvY2tzLCB0aGVyZSBhcmUgZmV3IGtpbmQgb2YgbWV0YS1kYXRhIGJsb2Nrcywg
ZS5nLiBleHRlbnQgYmxvY2tzCj4gbG9va3MgbGlrZSB0byBzdG9yZSBjbHVzdGVyIHBvaW50ZXJz
Lgo+IAoKV2hhdCBpcyB0aGUgc2l6ZSBvZiBhIGNsdXN0ZXIgPyAxTUIgPwpBbmQgd2hhdCBpcyBh
biBleHRlbnQgPwoKVGhhbmtzLgoKQmVybmQKSGVsbWhvbHR6IFplbnRydW0gTcO8bmNoZW4KCkhl
bG1ob2x0eiBaZW50cnVtIE11ZW5jaGVuCkRldXRzY2hlcyBGb3JzY2h1bmdzemVudHJ1bSBmdWVy
IEdlc3VuZGhlaXQgdW5kIFVtd2VsdCAoR21iSCkKSW5nb2xzdGFlZHRlciBMYW5kc3RyLiAxCjg1
NzY0IE5ldWhlcmJlcmcKd3d3LmhlbG1ob2x0ei1tdWVuY2hlbi5kZQpBdWZzaWNodHNyYXRzdm9y
c2l0emVuZGU6IE1pbkRpci5pbiBQcm9mLiBEci4gVmVyb25pa2Egdm9uIE1lc3NsaW5nCkdlc2No
YWVmdHNmdWVocnVuZzogUHJvZi4gRHIuIG1lZC4gRHIuIGguYy4gTWF0dGhpYXMgVHNjaG9lcCwg
S2Vyc3RpbiBHdWVudGhlcgpSZWdpc3RlcmdlcmljaHQ6IEFtdHNnZXJpY2h0IE11ZW5jaGVuIEhS
QiA2NDY2ClVTdC1JZE5yOiBERSAxMjk1MjE2NzEKCgpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5nIGxpc3QKT2NmczItZGV2
ZWxAb3NzLm9yYWNsZS5jb20KaHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9tYWlsbWFuL2xpc3RpbmZv
L29jZnMyLWRldmVs
