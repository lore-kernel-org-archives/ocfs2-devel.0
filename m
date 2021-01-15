Return-Path: <SRS0=QGeA=GS=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3296C433DB
	for <ocfs2-devel@archiver.kernel.org>; Fri, 15 Jan 2021 14:04:53 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E3F29223E0
	for <ocfs2-devel@archiver.kernel.org>; Fri, 15 Jan 2021 14:04:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E3F29223E0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=helmholtz-muenchen.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10FE4Kdo147701;
	Fri, 15 Jan 2021 14:04:51 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2120.oracle.com with ESMTP id 360kd050ab-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Jan 2021 14:04:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10FDt6t3085500;
	Fri, 15 Jan 2021 14:02:50 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 360kepwp7x-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 15 Jan 2021 14:02:50 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l0Pgf-0005Rq-LM; Fri, 15 Jan 2021 06:02:49 -0800
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <bernd.lentes@helmholtz-muenchen.de>)
	id 1l0PgQ-0005QN-TA; Fri, 15 Jan 2021 06:02:35 -0800
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10FDt8QQ085844; Fri, 15 Jan 2021 14:02:34 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by userp3030.oracle.com with ESMTP id 360kepwnx2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Jan 2021 14:02:34 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10FDsJSe034499; Fri, 15 Jan 2021 14:02:34 GMT
Received: from mtaextp1.scidom.de (mtaextp1.scidom.de [146.107.3.202])
	by userp2040.oracle.com with ESMTP id 363bwgrdy4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 15 Jan 2021 14:02:32 +0000
Received: from localhost (localhost [127.0.0.1])
	by mtaextp1.scidom.de (Postfix) with ESMTP id 6C6BD18026467;
	Fri, 15 Jan 2021 14:57:49 +0100 (CET)
Received: from mtaextp1.scidom.de ([127.0.0.1])
	by localhost (mtaextp1.scidom.de [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id 8_q6uAnOt0JX; Fri, 15 Jan 2021 14:57:49 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mtaextp1.scidom.de (Postfix) with ESMTP id 472401802B6DA;
	Fri, 15 Jan 2021 14:57:49 +0100 (CET)
X-Amavis-Modified: Mail body modified (using disclaimer) - mtaextp1.scidom.de
X-Virus-Scanned: amavisd-new at mtaextp1.scidom.de
Received: from mtaextp1.scidom.de ([127.0.0.1])
	by localhost (mtaextp1.scidom.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 3rzAjxHQgO4X; Fri, 15 Jan 2021 14:57:49 +0100 (CET)
Received: from mtaintp1.scidom.de (mtaintp1.scidom.de [146.107.8.197])
	by mtaextp1.scidom.de (Postfix) with ESMTPS id 1977918032245;
	Fri, 15 Jan 2021 14:57:49 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mtaintp1.scidom.de (Postfix) with ESMTP id 5AAD5824E9D4;
	Fri, 15 Jan 2021 14:57:53 +0100 (CET)
Received: from mtaintp1.scidom.de ([127.0.0.1])
	by localhost (mtaintp1.scidom.de [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id Zuxq-yN-CfzE; Fri, 15 Jan 2021 14:57:53 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mtaintp1.scidom.de (Postfix) with ESMTP id 3F481824E9D6;
	Fri, 15 Jan 2021 14:57:53 +0100 (CET)
X-Amavis-Modified: Mail body modified (using disclaimer) - mtaintp1.scidom.de
X-Virus-Scanned: amavisd-new at mtaintp1.scidom.de
Received: from mtaintp1.scidom.de ([127.0.0.1])
	by localhost (mtaintp1.scidom.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id PqT2QlfBzRui; Fri, 15 Jan 2021 14:57:53 +0100 (CET)
Received: from mbxp1.scidom.de (mbxp1.scidom.de [146.107.8.207])
	by mtaintp1.scidom.de (Postfix) with ESMTP id 23F64824E9C5;
	Fri, 15 Jan 2021 14:57:53 +0100 (CET)
Date: Fri, 15 Jan 2021 14:57:52 +0100 (CET)
From: "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>
To: herbert van den bergh <HERBERT.VAN.DEN.BERGH@ORACLE.COM>
Message-ID: <175971593.111907716.1610719072839.JavaMail.zimbra@helmholtz-muenchen.de>
In-Reply-To: <F4ED4F31-32F0-4783-A8FD-3CF3453D46C8@ORACLE.COM>
References: <2040150856.105362879.1610376125778.JavaMail.zimbra@helmholtz-muenchen.de>
	<71d2b3a4-8cdd-8d83-c6c3-abb00038b102@suse.com>
	<1400213487.108454266.1610546335237.JavaMail.zimbra@helmholtz-muenchen.de>
	<5dc2903f-d59b-31fb-dda4-3fb0fbe83798@suse.com>
	<1297384989.109460873.1610616679313.JavaMail.zimbra@helmholtz-muenchen.de>
	<F4ED4F31-32F0-4783-A8FD-3CF3453D46C8@ORACLE.COM>
MIME-Version: 1.0
X-Originating-IP: [146.107.127.206]
X-Mailer: Zimbra 8.8.15_GA_3968 (ZimbraWebClient - GC87 (Win)/8.8.15_GA_3968)
Thread-Topic: how to find out the real size of a reflink ?
Thread-Index: 4A8MNTDp0b0wqUBX8kArkjBmWAqCzg==
X-PDR: PASS
X-Source-IP: 146.107.3.202
X-ServerName: mtaextp1.scidom.de
X-Proofpoint-SPF-Result: None
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	lowpriorityscore=0 suspectscore=0
	adultscore=0 clxscore=236 bulkscore=0 priorityscore=0 mlxscore=0
	malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0 impostorscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2101150086
X-Spam: Clean
Cc: OCFS2 ML <ocfs2-users@oss.oracle.com>,
        ocfs2-devel <ocfs2-devel@oss.oracle.com>
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
 definitions=main-2101150087
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 impostorscore=0 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150088

CgotLS0tLSBPbiBKYW4gMTQsIDIwMjEsIGF0IDY6NTIgUE0sIGhlcmJlcnQgdmFuIGRlbiBiZXJn
aCBIRVJCRVJULlZBTi5ERU4uQkVSR0hAT1JBQ0xFLkNPTSB3cm90ZToKCj4gRnJvbSBtYW4gbWtm
cy5vY2ZzMjoKPiAKPiAgICAgICAtQywgLS1jbHVzdGVyLXNpemUgY2x1c3Rlci1zaXplCj4gICAg
ICAgICAgICAgIFZhbGlkIGNsdXN0ZXIgc2l6ZSB2YWx1ZXMgYXJlIDRLLCA4SywgMTZLLCAzMkss
IDY0SywgMTI4SywgIDI1NkssICA1MTJLICBhbmQKPiAgICAgICAgICAgICAgMU0uICBJZiAgb21p
dHRlZCwgIGEgIHZhbHVlICB3aWxsICBiZSAgaGV1cmlzdGljYWxseSBkZXRlcm1pbmVkIGJhc2Vk
IG9uIHRoZQo+ICAgICAgICAgICAgICBleHBlY3RlZCB1c2FnZSBvZiB0aGUgZmlsZSBzeXN0ZW0g
KHNlZSB0aGUgLVQgb3B0aW9uKS4gRm9yIHZvbHVtZXMgIGV4cGVjdGVkCj4gICAgICAgICAgICAg
IHRvICBzdG9yZSAgbGFyZ2UgZmlsZXMsIGxpa2UgZGF0YWJhc2UgZmlsZXMsIHdoaWxlIGEgY2x1
c3RlciBzaXplIG9mIDEyOEsgb3IKPiAgICAgICAgICAgICAgbW9yZSBpcyByZWNvbW1lbmRlZCwg
b25lIGNhbiBvcHQgZm9yIGEgc21hbGxlciBzaXplIGFzIGxvbmcgYXMgdGhhdCB2YWx1ZSBpcwo+
ICAgICAgICAgICAgICBub3Qgc21hbGxlciB0aGFuIHRoZSBkYXRhYmFzZSBibG9jayBzaXplLiAg
Rm9yIG90aGVycywgdXNlIDRLLgo+IAo+IEFuIGV4dGVudCBpcyBhIHNlcmllcyBvZiBibG9ja3Mg
aW4gYSBmaWxlLiBXaGVuIGEgZmlsZSBncm93cywgaXRzIGxhc3QgZXh0ZW50IGlzCj4gZ3Jvd24g
aWYgdGhlcmUgYXJlIGZyZWUgYmxvY2tzIG9uIGRpc2sgZm9sbG93aW5nIHRoZSBleHRlbnQsIG9y
IGEgbmV3IGV4dGVudCBpcwo+IGFkZGVkIHVzaW5nIGZyZWUgYmxvY2tzIGZyb20gc29tZXBsYWNl
IGVsc2Ugb24gdGhlIGRpc2suIFRoZSBmaWxlZnJhZyAtdgo+IGNvbW1hbmQgd2lsbCBsaXN0IGFs
bCBleHRlbnRzIG9mIGEgZmlsZSwgYW5kIHdoZXRoZXIgdGhleeKAmXJlIHNoYXJlZCB3aXRoIG90
aGVyCj4gZmlsZXMgb3Igbm90Lgo+IAoKVGhhbmtzLgoKQmVybmQKSGVsbWhvbHR6IFplbnRydW0g
TcO8bmNoZW4KCkhlbG1ob2x0eiBaZW50cnVtIE11ZW5jaGVuCkRldXRzY2hlcyBGb3JzY2h1bmdz
emVudHJ1bSBmdWVyIEdlc3VuZGhlaXQgdW5kIFVtd2VsdCAoR21iSCkKSW5nb2xzdGFlZHRlciBM
YW5kc3RyLiAxCjg1NzY0IE5ldWhlcmJlcmcKd3d3LmhlbG1ob2x0ei1tdWVuY2hlbi5kZQpBdWZz
aWNodHNyYXRzdm9yc2l0emVuZGU6IE1pbkRpci5pbiBQcm9mLiBEci4gVmVyb25pa2Egdm9uIE1l
c3NsaW5nCkdlc2NoYWVmdHNmdWVocnVuZzogUHJvZi4gRHIuIG1lZC4gRHIuIGguYy4gTWF0dGhp
YXMgVHNjaG9lcCwgS2Vyc3RpbiBHdWVudGhlcgpSZWdpc3RlcmdlcmljaHQ6IEFtdHNnZXJpY2h0
IE11ZW5jaGVuIEhSQiA2NDY2ClVTdC1JZE5yOiBERSAxMjk1MjE2NzEKCgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5nIGxp
c3QKT2NmczItZGV2ZWxAb3NzLm9yYWNsZS5jb20KaHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9tYWls
bWFuL2xpc3RpbmZvL29jZnMyLWRldmVs
