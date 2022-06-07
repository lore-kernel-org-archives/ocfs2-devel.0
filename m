Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8EA0C43334
	for <ocfs2-devel@archiver.kernel.org>; Tue,  7 Jun 2022 06:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=fsUzRFyl6xQanhF2ulrOQSRR378s/FpojEuk2nRA5qY=;
 b=NpI+Ed/08zeB+W1mwhkcIK8cLhr2IbUptR5ctfSISZj302v3NuHc/0BaEkrFJnN0CMMATQzQJbPh
   NnrhPkvhOgd9JhfM/fo7IlOGe1++dFNzDAMK9B7aBLjGCwYeG8qd9CrzU2jvrYws4iQLXQnJ7GYf
   5iMA1gXcXN3WO/a9TqFG0F2+vZFLUkHxnjFmhgCvdGPERLxFmWp2pCUA2kxtuOBWis6BpwDXnH19
   DkMICX4tGNITZvKWE2Rg3xZ7RSbuAEpBj20KOWgXKLbQroGKKLwlMxJ7NV8WXpdXCpO+7XjbuMR+
   iDxBJ0vEbmgvuWLEe6tXUycdFY/yg1ZdkFNBCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=fsUzRFyl6xQanhF2ulrOQSRR378s/FpojEuk2nRA5qY=;
 b=lj8bWBr1Pu9L4rlP9uegoprHmMgl/Iz8fxWCLZV4+Kg7340WzyDShHWAgQ8GOsvPeU1/6u63ce9S
   tJkaQSCJT8tClUPz9wYEl1Z6NFR14gBqSQruxUf2q7Yxhg+lq8XpjJ8kuNmq9pM4wHXCDIXt49UY
   8wX+klAk+hP8r1isKPojeZLCUXD5sBulLBbRgPfiNlWT62ly2YJ0AQJIFSHXA1tCoLTZGedouOBL
   2q0cc4PVRYSeHMLaV4KrtLfXJcg2tF4opPWiDLBGiGdXbyuvOcY2mpfD55oyGBJs90yqxzTV8tcU
   m4oZSgLuAFG4BcYEGiUYd2sMSqUsydlK7d0MVw==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD300BXSGSKJ210@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 07 Jun 2022 06:31:32 +0000 (GMT)
Message-id: <6f72c61f-fae4-9fa3-bcd9-5aa3f03db6ac@linux.alibaba.com>
Date: Tue, 7 Jun 2022 14:31:01 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Content-language: en-US
To: Junxiao Bi <junxiao.bi@oracle.com>,
 "heming.zhao@suse.com" <heming.zhao@suse.com>
References: <20220606020853.alh64eunicx5sjgs@c73>
 <11b0492d-37e0-3061-6c79-81610ad0312c@oracle.com>
 <5286c029-f9bc-7945-94f3-e38cd5220329@suse.com>
 <edba6791-5088-50d3-f417-f9639f05d012@linux.alibaba.com>
 <4F248A4D-0075-4039-8A63-27FADFBE07F1@oracle.com>
 <b2b5227e-257d-7171-e5b3-fa378b5caf5d@suse.com>
 <41AD73F0-1692-4CCB-95FC-AC65272081D0@oracle.com>
In-reply-to: <41AD73F0-1692-4CCB-95FC-AC65272081D0@oracle.com>
X-Source-IP: 115.124.30.132
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10370
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 priorityscore=0 mlxscore=0 malwarescore=0 phishscore=0 clxscore=103
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206070025 domainage_hfrom=8454
Cc: "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH] Revert
 "ocfs2: mount shared volume without ha stack"
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Joseph Qi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Joseph Qi <joseph.qi@linux.alibaba.com>
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: base64
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R201e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04400;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
 TI=SMTPD_---0VFczweN_1654583461;
X-ServerName: out30-132.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: AKQ8HFXCfgfjHz6w_7E3nNSt_TkwbC9a
X-Proofpoint-ORIG-GUID: AKQ8HFXCfgfjHz6w_7E3nNSt_TkwbC9a
Reporting-Meta:
 AAGtLfagokR2kbBcUa7s4J92+BhQaHC9xO4xdCcjMCSiOdUEJjSjc280RuJ5ZWaF
 s8E786sajTuGIOdiKOciZBP0mIHAbLROr4LM738dUNzbV1hdOXL4tZRh5f1g11az
 k7hCBmteGVLfMKmwb1xL3qMh3lUfohTlQlYIl6zbALbUkXecGY54avDaZ0xSU0DR
 BV157FyuGbWrFiWoIWWsNlCTZiudMnW1UkQ7+n69Zfym3J7zEXj43CnLP2nBEyzv
 1rqYjyDsPufG7a4pu8/MRFCSSFLldgDbYhuUis4ychpB4udRGwH1AvKExzAbrq8E
 /5yilLhic4BNc40TzwsPJ1BcZMqCnpuzHP5xZwrR+WC4FeuhCmLxtu2NaZyD5tf7
 HQAndBXf+XhIdRGG1J5RNzEsOx1xZqE/n/Kx8m6K9lthWbqUlPoxS7MFwVdKhbUL
 ks4nV4l82UpBIyihmrNPP8J3Zq+wrd5kvhG/WhA54lbC97d9KJ1zQumFeaEmkDRm
 usLMOgpOJnu61ymbsdVIcG6WWbf9yVp6Me/jNNV4u5Se

CgpPbiA2LzcvMjIgMTE6MDYgQU0sIEp1bnhpYW8gQmkgd3JvdGU6Cj4+Pj4gU2VlbXMgSSBhbSBt
aXNzaW5nIHNvbWUgbWFpbHMgZm9yIHRoaXMgdGhyZWFkLgo+Pj4+IFRoZSAnbm9jbHVzdGVyJyBt
b3VudCBpcyBpbnRyb2R1Y2VkIGJ5IEdhbmcgYW5kIEkgdGhpbmsgaXQgaGFzIHJlYWwKPj4+PiB1
c2VyIHNjZW5hcmlvcy4gSSBhbSBjdXJpb3VzIGFib3V0IHNpbmNlIG5vZGUgMCBpcyBjb21tb25s
eSB1c2VkIGluCj4+Pj4gbzJjYiwgd2h5IHRoZXJlIGlzIG5vIGFueSBidWcgcmVwb3J0IGJlZm9y
ZS4KPj4+PiBTbyBsZXQncyB0cnkgdG8gZml4IHRoZSByZWdyZXNzaW9uIGZpcnN0Lgo+Pj4gUmVh
bCB1c2VyIGNhc2UgZG9lc27igJl0IG1lYW4gdGhpcyBoYXMgdG8gYmVlbiBkb25lIHRocm91Z2gg
a2VybmVsPyBUaGlzIHNvdW5kcyBsaWtlIGRvaW5nIHNvbWV0aGluZyBpbiBrZXJuZWwgdGhhdCBp
cyB0byB3b3JrYXJvdW5kIHNvbWUgaXNzdWUgdGhhdCBjYW4gYmUgZG9uZSBmcm9tIHVzZXIgc3Bh
Y2UuCj4+PiBJIGRpZG7igJl0IHNlZSBhIFJldmlld2VkLWJ5IGZvciB0aGUgcGF0Y2gsIGhvdyBk
aWQgaXQgZ2V0IG1lcmdlZD8KPj4gR2FuZyBoYWQgbGVmdCBTVVNFIGZvciBzb21lIHRpbWUsIGFu
ZCBidXN5IHdpdGggaGlzIG5ldyBqb2IuCj4+IEkgaGF2ZSB2YWd1ZSBtZW1vcnksIGhlIHNhaWQg
dGhpcyBjb21taXQgYXBwcm92ZWQgJiBtZXJnZWQgZGlyZWN0bHkgYnkgQW5kcmV3IE1vcnRvbi4K
Pj4gR2FuZyBkZWRpY2F0ZWQgdG8gY29udHJpYnV0ZSBvY2ZzMiBjb21tdW5pdHkgbWFueSB5ZWFy
cywgYW5kIHNldCB1cCBoaXMgY29tcGV0ZW5jZQo+PiB0byBvdGhlciBtYWludGFpbmVycyAmIHJl
dmlld2Vycy4KPj4KPj4gSWYgSnVueGlhbyBkaXNsaWtlIHRoaXMgZmVhdHVyZSwgYW5kIGRvbid0
IHdhbnQgdG8gZml4IGl0IGFzIGEgYnVnLgo+PiBJIGFtIHdpbGxpbmcgdG8gZmlsZSBhIHBhdGNo
Lgo+IFRvIGZpeCwgaXTigJlzIG5vdCBvbmx5IHRoZSByZWdyZXNzaW9uIGl0IGNhdXNlcywgYnV0
IGFsc28gZG8gc29tZXRoaW5nIGluIG1vdW50Lm9jZnMyIHRvIGNoZWNrIHdoZXRoZXIgYW55IG5v
ZGUgaXMgbW91bnRpbmcgdGhlIHZvbHVtZSBiZWZvcmUgbm9jbHVzdGVyIG1vdW50IGFuZCBhbHNv
IHN0b3Agb3RoZXIgbm9kZXMgbW91bnRpbmcgYmVmb3JlICBub2NsdXN0ZXIgbW91bnQgaXMgdW5t
b3VudGVkLiBUaGF04oCZcyB0byBzaW11bGF0ZSB3aGF0IGZzY2sub2NmczIvbWtmcy5vY2ZzMiBk
by4gV2l0aG91dCB0aGF0IGd1YXJkLCB0aGlzIGZlYXR1cmUganVzdCBwcm92aWRlcyBhIG5ldyB3
YXkgZm9yIGN1c3RvbWVyIHRvIGNvcnJ1cHQgdGhlaXIgZGF0YS4gSXTigJlzIGp1c3QgdGltZSBz
b21lIGN1c3RvbWVyIHdvdWxkIGRvIHNvbWV0aGluZyBiYWQgYW5kIGxvc3QgdGhlaXIgZGF0YS4g
Cj4gSSB3aWxsIGxlYXZlIGhvdyB0byBoYW5kbGUgdGhpcyB0byB5b3UgYW5kIEpvc2VwaCwgd2Ug
YWxyZWFkeSByZXZlcnRlZCB0aGlzIHBhdGNoLgoKU2VhcmNoZWQgdGhlIG1haWxsaXN0IGFuZCBm
aW5kIHRoZSBvcmlnaW5hbCB0aHJlYWQgZm9yIHJlZmVyZW5jZToKaHR0cHM6Ly9sb3JlLmtlcm5l
bC5vcmcvb2NmczItZGV2ZWwvQ0gyUFIxOE1CMzIwNjRDQ0Q4MEZFOThGMDNCODJBODE2Q0ZBQzBA
Q0gyUFIxOE1CMzIwNi5uYW1wcmQxOC5wcm9kLm91dGxvb2suY29tLwoKSSBzdWdnZXN0IHdlIGxl
YXZlIG5vY2x1c3RlciBtb3VudCBhcyBhIHNwZWNpYWwgbW9kZSBhbmQgbWFrZSBpdHMgbG9naWMK
d29uJ3QgaW1wYWN0IG90aGVyIG1vZGUgbGlrZSBjbHVzdGVyIG9yIGxvY2FsIG1vdW50LgpBZ3Jl
ZSB3aXRoIEp1bnhpYW8sIHdlIGhhdmUgdG8gdHJ5IG91ciBiZXN0IHRvIHByZXZlbnQgZGF0YSBj
b3JydXB0aW9uCmV2ZW4gbWlzdGFrZW5seSB1c2VkIGJ5IGN1c3RvbWVyLgoKVGhhbmtzLApKb3Nl
cGgKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCk9jZnMy
LWRldmVsIG1haWxpbmcgbGlzdApPY2ZzMi1kZXZlbEBvc3Mub3JhY2xlLmNvbQpodHRwczovL29z
cy5vcmFjbGUuY29tL21haWxtYW4vbGlzdGluZm8vb2NmczItZGV2ZWw=
