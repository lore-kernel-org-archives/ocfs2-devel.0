Return-Path: <SRS0=aUy8=GR=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46B28C433E0
	for <ocfs2-devel@archiver.kernel.org>; Thu, 14 Jan 2021 17:57:15 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CA68123B4B
	for <ocfs2-devel@archiver.kernel.org>; Thu, 14 Jan 2021 17:57:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA68123B4B
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=ORACLE.COM
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10EHnvSM035130;
	Thu, 14 Jan 2021 17:57:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version : from :
 in-reply-to : date : message-id : references : to : cc : subject : list-id
 : list-unsubscribe : list-archive : list-post : list-help : list-subscribe
 : content-type : content-transfer-encoding : sender; s=corp-2020-01-29;
 bh=NANUWgN2CgAfI8U2WYzWtdDGS+UmEBsfov3vP2SxVcY=;
 b=Wh8rVyPc77X85f1qrWt46C4oRlPrY9yceOv0BdJ9OoYDra/I5QcuiPMJewcuQIvkboe/
 UaLN0BP8m3S6+hutrFTeMymGPu3n3YIu0J1dMz1cqcrBCG1iyienr23weToAdqApAOKd
 VhAYKlPLgNGvfX9bgdOrPUhOoKI1hoXemMl5zGn/NCKj56+cNp3wIgU9nZSaM9LtlQO5
 Tyrg/3l/KS6m9g7Uz1HnTixFJc/KsSUApUU2l4uh/5L3NN0bRusnjbktHz/yiX53CKuH
 I+83hfrQiaSbEJ1Uji57guzoMLaGypHdhoDoXUNoRkcebv8TexkCP0ZpdlRkAAkDROU7 gQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2120.oracle.com with ESMTP id 360kd01eu8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Jan 2021 17:57:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10EHorfU067141;
	Thu, 14 Jan 2021 17:57:12 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 360kenj2vb-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 14 Jan 2021 17:57:12 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l06rv-0001c2-NK; Thu, 14 Jan 2021 09:57:11 -0800
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <HERBERT.VAN.DEN.BERGH@ORACLE.COM>)
	id 1l06nY-0001T2-C7; Thu, 14 Jan 2021 09:52:40 -0800
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10EHoGub067797; Thu, 14 Jan 2021 17:52:40 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by aserp3030.oracle.com with ESMTP id 360kf2eukd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Jan 2021 17:52:40 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
	by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10EHqd3w075389;
	Thu, 14 Jan 2021 17:52:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
	by aserp3030.oracle.com with ESMTP id 360kf2eujs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Jan 2021 17:52:39 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
	by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10EHqaAl025104;
	Thu, 14 Jan 2021 17:52:36 GMT
Received: from hbergh-mac.attlocal.net (/99.117.119.34)
	by default (Oracle Beehive Gateway v4.0)
	with ESMTP ; Thu, 14 Jan 2021 09:52:36 -0800
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
From: Herbert Van Den Bergh <HERBERT.VAN.DEN.BERGH@ORACLE.COM>
In-Reply-To: <1297384989.109460873.1610616679313.JavaMail.zimbra@helmholtz-muenchen.de>
Date: Thu, 14 Jan 2021 09:52:35 -0800
Message-Id: <F4ED4F31-32F0-4783-A8FD-3CF3453D46C8@ORACLE.COM>
References: <2040150856.105362879.1610376125778.JavaMail.zimbra@helmholtz-muenchen.de>
	<71d2b3a4-8cdd-8d83-c6c3-abb00038b102@suse.com>
	<1400213487.108454266.1610546335237.JavaMail.zimbra@helmholtz-muenchen.de>
	<5dc2903f-d59b-31fb-dda4-3fb0fbe83798@suse.com>
	<1297384989.109460873.1610616679313.JavaMail.zimbra@helmholtz-muenchen.de>
To: "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Mailman-Approved-At: Thu, 14 Jan 2021 09:57:09 -0800
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
 definitions=main-2101140104
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 impostorscore=0 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1011 mlxlogscore=999 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101140104

RnJvbSBtYW4gbWtmcy5vY2ZzMjoKCiAgICAgICAtQywgLS1jbHVzdGVyLXNpemUgY2x1c3Rlci1z
aXplCiAgICAgICAgICAgICAgVmFsaWQgY2x1c3RlciBzaXplIHZhbHVlcyBhcmUgNEssIDhLLCAx
NkssIDMySywgNjRLLCAxMjhLLCAgMjU2SywgIDUxMksgIGFuZAogICAgICAgICAgICAgIDFNLiAg
SWYgIG9taXR0ZWQsICBhICB2YWx1ZSAgd2lsbCAgYmUgIGhldXJpc3RpY2FsbHkgZGV0ZXJtaW5l
ZCBiYXNlZCBvbiB0aGUKICAgICAgICAgICAgICBleHBlY3RlZCB1c2FnZSBvZiB0aGUgZmlsZSBz
eXN0ZW0gKHNlZSB0aGUgLVQgb3B0aW9uKS4gRm9yIHZvbHVtZXMgIGV4cGVjdGVkCiAgICAgICAg
ICAgICAgdG8gIHN0b3JlICBsYXJnZSBmaWxlcywgbGlrZSBkYXRhYmFzZSBmaWxlcywgd2hpbGUg
YSBjbHVzdGVyIHNpemUgb2YgMTI4SyBvcgogICAgICAgICAgICAgIG1vcmUgaXMgcmVjb21tZW5k
ZWQsIG9uZSBjYW4gb3B0IGZvciBhIHNtYWxsZXIgc2l6ZSBhcyBsb25nIGFzIHRoYXQgdmFsdWUg
aXMKICAgICAgICAgICAgICBub3Qgc21hbGxlciB0aGFuIHRoZSBkYXRhYmFzZSBibG9jayBzaXpl
LiAgRm9yIG90aGVycywgdXNlIDRLLgoKQW4gZXh0ZW50IGlzIGEgc2VyaWVzIG9mIGJsb2NrcyBp
biBhIGZpbGUuIFdoZW4gYSBmaWxlIGdyb3dzLCBpdHMgbGFzdCBleHRlbnQgaXMgZ3Jvd24gaWYg
dGhlcmUgYXJlIGZyZWUgYmxvY2tzIG9uIGRpc2sgZm9sbG93aW5nIHRoZSBleHRlbnQsIG9yIGEg
bmV3IGV4dGVudCBpcyBhZGRlZCB1c2luZyBmcmVlIGJsb2NrcyBmcm9tIHNvbWVwbGFjZSBlbHNl
IG9uIHRoZSBkaXNrLiBUaGUgZmlsZWZyYWcgLXYgY29tbWFuZCB3aWxsIGxpc3QgYWxsIGV4dGVu
dHMgb2YgYSBmaWxlLCBhbmQgd2hldGhlciB0aGV54oCZcmUgc2hhcmVkIHdpdGggb3RoZXIgZmls
ZXMgb3Igbm90LgoKVGhhbmtzLApIZXJiZXJ0LgoKCj4gT24gSmFuIDE0LCAyMDIxLCBhdCAxOjMx
IEFNLCBMZW50ZXMsIEJlcm5kIDxiZXJuZC5sZW50ZXNAaGVsbWhvbHR6LW11ZW5jaGVuLmRlPiB3
cm90ZToKPiAKPiAKPiAKPiAtLS0tLSBPbiBKYW4gMTQsIDIwMjEsIGF0IDI6NTAgQU0sIEdhbmcg
SGUgZ2hlQHN1c2UuY29tIHdyb3RlOgo+IAo+PiBIaSBMZW50ZXMsCj4+IAo+PiBzZWUgbXkgY29t
bWVudHMgaW5saW5lLgo+IAo+Pj4gCj4+PiBTb21lIHF1ZXN0aW9uczoKPj4+IAo+Pj4gV2hhdCBp
cyBhIGNsdXN0ZXIgPwo+Pj4gV2hhdCBpcyBhbiBleHRlbnQgPwo+PiBJbiB0aGUgdHJhZGl0aW9u
YWwgZmlsZSBzeXN0ZW0sIGEgZmlsZSBjb25zaXN0cyBvZiBtZXRhLWRhdGEgYmxvY2tzIGFuZAo+
PiBkYXRhIGJsb2NrcywgYnV0IGZvciBvY2ZzMiBmaWxlIHN5c3RlbSwgYSBmaWxlIGNvbnNpc3Rz
IG9mIG1ldGEtZGF0YQo+PiBibG9ja3MgYW5kIGRhdGEgY2x1c3RlcnMsIHRoZSBjbHVzdGVyIHNp
emUgY2FuIGdyZWF0ZXIgdGhhbiB0aGUgYmxvY2sKPj4gc2l6ZSB0byBzYXZlIG1ldGEtZGF0YSBi
bG9jayBjb25zdW1wdGlvbi4KPj4gVGhlIGZpbGUgZGF0YSBpcyBjb250YWluZWQgYnkgY2x1c3Rl
cnMsIHRoZSBmaWxlIG1ldGEgZGF0YSBpcyBjb250YWluZWQKPj4gYnkgYmxvY2tzLCB0aGVyZSBh
cmUgZmV3IGtpbmQgb2YgbWV0YS1kYXRhIGJsb2NrcywgZS5nLiBleHRlbnQgYmxvY2tzCj4+IGxv
b2tzIGxpa2UgdG8gc3RvcmUgY2x1c3RlciBwb2ludGVycy4KPj4gCj4gCj4gV2hhdCBpcyB0aGUg
c2l6ZSBvZiBhIGNsdXN0ZXIgPyAxTUIgPwo+IEFuZCB3aGF0IGlzIGFuIGV4dGVudCA/Cj4gCj4g
VGhhbmtzLgo+IAo+IEJlcm5kCj4gSGVsbWhvbHR6IFplbnRydW0gTcO8bmNoZW4KPiAKPiBIZWxt
aG9sdHogWmVudHJ1bSBNdWVuY2hlbgo+IERldXRzY2hlcyBGb3JzY2h1bmdzemVudHJ1bSBmdWVy
IEdlc3VuZGhlaXQgdW5kIFVtd2VsdCAoR21iSCkKPiBJbmdvbHN0YWVkdGVyIExhbmRzdHIuIDEK
PiA4NTc2NCBOZXVoZXJiZXJnCj4gd3d3LmhlbG1ob2x0ei1tdWVuY2hlbi5kZQo+IEF1ZnNpY2h0
c3JhdHN2b3JzaXR6ZW5kZTogTWluRGlyLmluIFByb2YuIERyLiBWZXJvbmlrYSB2b24gTWVzc2xp
bmcKPiBHZXNjaGFlZnRzZnVlaHJ1bmc6IFByb2YuIERyLiBtZWQuIERyLiBoLmMuIE1hdHRoaWFz
IFRzY2hvZXAsIEtlcnN0aW4gR3VlbnRoZXIKPiBSZWdpc3RlcmdlcmljaHQ6IEFtdHNnZXJpY2h0
IE11ZW5jaGVuIEhSQiA2NDY2Cj4gVVN0LUlkTnI6IERFIDEyOTUyMTY3MQo+IAo+IAo+IF9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCj4gT2NmczItdXNlcnMg
bWFpbGluZyBsaXN0Cj4gT2NmczItdXNlcnNAb3NzLm9yYWNsZS5jb20KPiBodHRwczovL29zcy5v
cmFjbGUuY29tL21haWxtYW4vbGlzdGluZm8vb2NmczItdXNlcnMKCgpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5nIGxpc3QK
T2NmczItZGV2ZWxAb3NzLm9yYWNsZS5jb20KaHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9tYWlsbWFu
L2xpc3RpbmZvL29jZnMyLWRldmVs
