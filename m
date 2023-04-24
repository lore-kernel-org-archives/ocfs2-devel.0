Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48B29C77B61
	for <ocfs2-devel@archiver.kernel.org>; Mon, 24 Apr 2023 08:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=mbP22A0FUJXQrz9+cpNgCHkdwUkJn0L7k2vd6A0hOBw=;
 b=0NpdPLEPANDYd5FU2pD5I302H2BKzfGj9tVNjNtxy5rdu0KqAdJ+RAsR5sRBjRavC8DLbTXxsT+a
   Ue6S2hoVzZQjM1n2vZgBIsuy6VzfYc8xldacSgBQ8Sn65oHDBi97dI/ssale1hR+1ie50i7KOPEY
   +Fg1B57VS5JXWixKeoKDaMafEsbW+veD9V4+bP30Rm5q9Gi+ySn170ZERaeU3FFL2Byn471e3o41
   oojoRM6Ydkirnfqh77Ge8hRjoy+Qirpp2pvsMGZCM4zD6Hey6UU4OBiKr3aesSpbj9B8fi7b3ohP
   DXZHPDJ5Bih4B27wJVeF/7DV6Fc9HwdMv6u20A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=mbP22A0FUJXQrz9+cpNgCHkdwUkJn0L7k2vd6A0hOBw=;
 b=C94Qn6A4CsV5Xd7/z4iV6n/L3d1AE1Z1XNIXWd8tHOOVCLU+ma2YeUGTnvUmh8YFB71BTzZeUzdk
   OK3zUBPoJ6l31nE2fcExdj5/1aJUDOqGlI4d0mnYd1KO35R3WLf7Y2reNR5B91Q3ptpY36f3I1ij
   lk34099aZUkKSrfiqHPDcsFRsmPFB2H5vDbozB4KG2ACA2gDDDHWwFlwYN8S2naQ4NZ1HT8/W1gK
   i0JQ9o15vRj/3K6BKdyH5kEkf0XVgr6LBae/tvy6ceWI29ExvOzq4dXSyKX08W2P9gqmGCay983l
   QUmg5HpoixuZ7eWYH0x2a6kV0R2/8618lkZZhA==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230407 64bit (built Apr  7
 2023))
 with ESMTPS id <0RTM00O8J224EG30@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 24 Apr 2023 08:25:16 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1682324700; bh=wahJLGCz8Bnc65p1CGkD+QO9uiDS+OKs7I3XjdFSkCU=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=gvU0XbXG6BVYRHvo7RsTVk1wlXJ3HWyeE4iueTCKb8m6t7R/ImPOubXDT0YTqzR3I
 ta2AahQW1ApoZdcHUrW2zQmVJsh90sbxOKMsF3GateURBZ4kbFecf7tf0sUjWlBzYb
 gE0KHdK3H80cf+XEkg8+G2l3ZrYel6kvv7UvqYvr2+Ze43yurL/RgH5ir34Ctvjyt1
 rOj0jyjREhWZfhxEJmb8j69ml/I13xy3i8fT7JA52GU6ryIElfLMdOXnZsBblAU5+Z
 3IasPqBUfd5oRTBMy0CaqgW+v3rDEE2FX7hlnn7oGPM+8L0g6K6rXfz363ho7p6Yyd
 kRCQUqgqBDoRA==
Date: Mon, 24 Apr 2023 10:24:55 +0200
To: Mark Fasheh <mark@fasheh.com>
Message-id: <20230424-handtaschen-armut-91885793ecf1@brauner>
References: <20230417205631.1956027-1-arnd@kernel.org>
 <20230418-fortgehen-inkubationszeit-5d3db3f0c2b1@brauner>
 <7555eaf9-b195-5189-3928-c7292e4a0ba5@linux.alibaba.com>
 <20230418-vielmehr-nominieren-7f2adb0f6703@brauner>
 <d1e719ea-95bf-bb96-62db-e550cefe0a80@linux.alibaba.com>
 <20230419142159.fd5ca2e91658fe304e317a72@linux-foundation.org>
 <20230420-wetten-aneignen-8324959e629d@brauner>
 <CAGe7X7mLU0JOftGVA+NHabu-9a=fuaofy+KhpvCJFnkRz5ANtQ@mail.gmail.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to:
 <CAGe7X7mLU0JOftGVA+NHabu-9a=fuaofy+KhpvCJFnkRz5ANtQ@mail.gmail.com>
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10689
 signatures=596816
Cc: Arnd Bergmann <arnd@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: reduce ioctl stack usage
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
From: Christian Brauner via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Christian Brauner <brauner@kernel.org>
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: base64
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.kernel.org ~all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-GUID: UwPFS17dRgbcm3UZinTeQTpTEW5tdRye
X-Proofpoint-ORIG-GUID: UwPFS17dRgbcm3UZinTeQTpTEW5tdRye
Reporting-Meta:
 AAGSzP5ofl6/quyr61RHQFNMOsPkKR0Etce1O6AU7eltVPC+Z4KAg5HVZG7BIz3N
 /Fz+lL3/REUc/PXaDdAZ+afao260DaDgWbKZLfjkkmLeFuKV6VNG+1DHmQ24UKyS
 3/JGLIb+3GiXp2pjk8zQsXeCUs4XQbPLwjp2ZOkdmMJXuiuIp0qYpUgNK6apZDYW
 U/7W8/kRgcR82wKQ+7+UiL1HlUMfIiUymhlVoScONLPUwIWqrdN2K8JWtLYiPOnA
 hd09JNt8wOWpcdwvNdrRGgeTbW8Cp9OtC5yNnFBIyGG0zmMlX0mpIZLh4HUxktVN
 ZCcNUHrySdd/QAuOfvUXpSeOqUhb2H7xxnQDzuewZldrXdQGr0OVz6ZZDwRT/Wx/
 2LxZT3zNzFylZw6knCLbZ0hA3ccuqIc7qrrdVpRfPRkMLN78xBxdo5FvGn/6sxYo
 0fC/+SnlUUhqfxnvha9kJ05Pc9/WnPUbbaAjFYd0llWqpOWcEb9YyX2aEvHTiWgV
 9NFLRiTSZfk1bQ1XzcfYFNInf4pzv1Imo26BQPT0+xg=

T24gVGh1LCBBcHIgMjAsIDIwMjMgYXQgMTA6MDE6MTJBTSAtMDcwMCwgTWFyayBGYXNoZWggd3Jv
dGU6Cj4gT24gVGh1LCBBcHIgMjAsIDIwMjMgYXQgMjozNOKAr0FNIENocmlzdGlhbiBCcmF1bmVy
IDxicmF1bmVyQGtlcm5lbC5vcmc+IHdyb3RlOgo+ID4gSSB0aGluayBJIG1pZ2h0IG5vdCBoYXZl
IGNvbW11bmljYXRlZCBhcyBjbGVhcmx5IGFzIEkgc2hvdWxkIGhhdmUuCj4gPiBTaW1wbHkgYmVj
YXVzZSBJIG5haXZlbHkgYXNzdW1lZCB0aGF0IHRoaXMgaXMgdW5wcm9ibGVtYXRpYy4KPiA+Cj4g
PiBCeSAid2UiIEkgbWVhbiBwZW9wbGUgcmVzcG9uc2libGUgZm9yICJmcy8iIHdoaWNoIG5vdyBo
YXBwZW5zIHRvIGFsc28KPiA+IGluY2x1ZGUgbWUuIFNvIHRoZSBnb2FsIG9mIHRoaXMgaXMgZm9y
IHBhdGNoZXMgZmFsbGluZyB1bmRlciBmcy8gdG8gZ2V0Cj4gPiBwaWNrZWQgdXAgbW9yZSBxdWlj
a2x5IGFuZCBicm9hZGx5IGFuZCBzaGFyZSB0aGUgbWFpbnRlbmFuY2UgYnVyZGVuLgo+IAo+IERp
ZCB5b3UgZ2V0IGJ1eS1pbiBmcm9tIG90aGVyIGZvbGtzIGluICdmcy8nPyBXaGF0IG90aGVyIHBy
b2plY3RzIGFyZQo+IHlvdSBjYXJyeWluZz8gR3JhbnRlZCBJJ20gYSBiaXQgb3V0IG9mIHRoZSBs
b29wIHRoZXNlIGRheXMgYnV0IHRoaXMgaXMKPiB0aGUgZmlyc3QgSSdtIGhlYXJpbmcgb2YgdGhp
cy4KPiAKPiBBbmRyZXcgaGFzIGEgd2VsbCBvaWxlZCBtYWNoaW5lIGdvaW5nLCBzbyBpZiBoZSdz
IHN0aWxsIG9rIGNhcnJ5aW5nCj4gdGhlIHBhdGNoZXMgdGhlbiB0aGF0J3Mgd2hlcmUgSSdkIGxp
a2UgdGhlbSB1bnRpbCBzdWNoIHRpbWUgdGhhdCB5b3UKPiBjYW4gcHJvdmlkZSBhIHRhbmdpYmxl
IGJlbmVmaXQuCgpBIHBhdGNoIGlzIHNlbnQgZm9yIHNvbWV0aGluZyB0aGF0IGZhbGxzIHVuZGVy
IHRoZSBmcy8gZGlyZWN0b3J5LiBJbgp0aGlzIGNhc2UgZnMvb2NmczIvLiBUaGUgbWFpbnRhaW5l
cidzIG9mIGZzL29jZnMyLyBwcm92aWRlIHRoZWlyIGFja3MuCgpBIG1haW50YWluZXIgLSBJbiB0
aGlzIGNhc2UgbXkgc29ycnkgYXNzIC0gb2YgZnMvIGxvb2tzIGludG8gdGhlCm1haW50YWluZXIn
cyBmaWxlIHRvIG1ha2Ugc3VyZSB0aGF0IHNvbWVvbmUgd2lsbCBwaWNrIHVwIHRob3NlIHBhdGNo
ZXMKYnkgbG9va2luZyBmb3IgYSB0cmVlIGVudHJ5IHVuZGVyIHRoZSByZXNwZWN0aXZlIGZzL29j
ZnMyLyBlbnRyeS4KClRoZXJlIGlzIG5vIHRyZWUgZW50cnkuCgpTbyB0aGUgcGF0Y2ggaXMgcGlj
a2VkIHVwIGJ5IGEgcmVzcGVjdGl2ZSBtYWludGFpbmVyIG9mIGZzLyB0byBlbnN1cmUKdGhhdCBm
aXhlcyBsYW5kIGluIG1haW5saW5lLgoKU28sIGlmIHlvdSBoYXZlIGEgdHJlZSB0aGF0IHlvdSB0
aGluayBmcy9vY2ZzMi8gYmVsb25ncyB0byB0aGVuIHBsZWFzZQpzZW5kIGEgcGF0Y2ggdG8gYWRk
IHRoZSByZXNwZWN0aXZlIHRyZWUgaW50byB0aGUgbWFpbnRhaW5lcidzIGZpbGUuCgpUaGlzIGlz
IGVzcGVjaWFsbHkgdHJ1ZSB3aGVuIGZzLyBzdHVmZiBzdXJwcmlzaW5nbHkgZ29lcyB2aWEgbW0v
LiBJCmRvbid0IHdhbnQgdG8gaGF2ZSB0byBndWVzcyB3aGF0IHRyZWUgeW91J3JlIGdvaW5nIHRo
cm91Z2ggZXZlbiBpZiBpdCdzCmJlZW4gZ29pbmcgb24gZm9yIGEgbG9uZyB0aW1lLgoKVGhlcmUg
YXJlIG5vIGJhZCBpbnRlbnRpb25zIGhlcmUgYnV0IHBsZWFzZSBjbGFyaWZ5IHRoZSBvY2ZzMiBl
bnRyeSBpbgp0aGUgbWFpbnRhaW5lcidzIGZpbGUuCgpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5nIGxpc3QKT2NmczItZGV2
ZWxAb3NzLm9yYWNsZS5jb20KaHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9tYWlsbWFuL2xpc3RpbmZv
L29jZnMyLWRldmVs
