Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6B0BC433F5
	for <ocfs2-devel@archiver.kernel.org>; Fri, 21 Jan 2022 01:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=gJlEUH4Kn+ae6FrNa60uv2cuUEgMAbkuJLBfyVQJdRw=;
 b=XH3wp2iHzNmaX+y9FVXIIXCbHVfkkiP7XZXpQ53dJ3omgZAmusHU1JXhQ5Be5HJ7KT7mosorJjXr
   lVLu6w/3GNwe9hVcxX+zDfigGSvjXR/EyJ3kNObKrUZUbAS3FtEjdYvULgb/P3x5aDHsinM+UoDZ
   nvtj0IGd/3cMYWrnZTd092bziiKG3wDpgkiDWMqRAsNTSH9gOSVNLx8JfhyEOs4Jo/OXgk2rWzNU
   1c5cdnac4yCPssZ7Zz2s3Fc+tShBj4+j/847+jIIVisRQ69UFdjhcb87AsWI6yVIgPquNS1iJbWA
   gy1DPW+GaegkCtZtzPBHNrN69H76Jp/GK3vrUQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=gJlEUH4Kn+ae6FrNa60uv2cuUEgMAbkuJLBfyVQJdRw=;
 b=cm/JkilGz2nOAr5GFW4JGwnSVH4d+TwhKByXVM2qg4/urH9wHBuWPexc4CnFm34TvjdzI1lbEmP+
   lGLZZi2SH/E/+Ee5mpnkx+pYR2zz5uHCl7XtyqJWOJYHgZyGnHJmfL3ZtutJX6SWfl4LzImJZd5o
   l/Iv98oM1wyt2TrIwj3W/GMApoNZE/GS6NuMMhu3zwpilr+wxIFIp/caEbO9JJ2taYfd1MJvKyHB
   AeXl3P41F6+MsCn4GPHMUKfH7ZI7nbeBastugwaddaf+8OT38cTPucDkld99irrybIf4k7WpxJUJ
   GJxOTlzA2/GMPbcs5amXQHw1RzldFN5uxwT/pw==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220104 64bit (built Jan  4
 2022))
 with ESMTPS id <0R61007PHE4NO420@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 21 Jan 2022 01:43:35 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=joseph.qi@linux.alibaba.com; dmarc=none
 header.from=linux.alibaba.com
Message-id: <5d98ad12-26c7-3aba-a4bc-79cdca5c77df@linux.alibaba.com>
Date: Fri, 21 Jan 2022 09:43:12 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Content-language: en-US
To: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>,
 ocfs2-devel@oss.oracle.com
References:
 <1642682627-12041-1-git-send-email-gautham.ananthakrishna@oracle.com>
In-reply-to:
 <1642682627-12041-1-git-send-email-gautham.ananthakrishna@oracle.com>
X-Source-IP: 115.124.30.132
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233
 signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=179
 impostorscore=0 phishscore=0 priorityscore=138 mlxscore=0 mlxlogscore=999
 spamscore=0 lowpriorityscore=0 adultscore=0 suspectscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201210009 domainage_hfrom=8317
Cc: rajesh.sivaramasubramaniom@oracle.com
Subject: Re: [Ocfs2-devel] [PATCHC RFC V2 1/1] ocfs2: fix a deadlock when
	commit trans
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R181e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04395;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=4; SR=0;
 TI=SMTPD_---0V2OUJYr_1642729392;
X-ServerName: out30-132.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: 68clUtf_wVulNcqLPS3hxFJYpZ0mLkg4
X-Proofpoint-GUID: 68clUtf_wVulNcqLPS3hxFJYpZ0mLkg4
Reporting-Meta:
 AAHUwdYx7xTIyD/K+buiXzTqXWe4MlEvHLJY/d5B0kwj2gTYEolRMEakRKYbcXlI
 x4Bp+3OuZpNMN8Xlf/udsJMdTW1iZp9G4uk6gQbOJ1yDCPI2+OqYOTHX7Rny+ffk
 7pDjunlruGcLQZBF8tgmqExORRQZiPnTNs/3J/jeHao3BsbaFXeeMY6h2k9S+Heu
 8Tou8130iLazYrU8m57kz+VUSPeOsfx+Dv2XurUyPEc53rOvCkD3OrGL1MfTKaJC
 5k1yiy0x0uXS0aZIoCknmpJ7M+Gb2wfSJXJrF9RGDMm3fiCI7AbUnXeb0RqmphrD
 eCG4D3ZaIUYiZJaIQTO0/O1LTtox6VFMmkTtUzMXpQcbLRJpLnhZiuBY8ktLL2pK
 Nws1EgvRLk/Kk9kxLviLVbwxduUoqdcYXF8WX2Qia2urxuzqxEvqlNkd2GpTfzXn
 om8qA5s2xj/dk5k7ihmTnYWoir2LattmnYDBYSciCD1x0GrOUlYsWHdYz9NYPucA
 EM4OQm1ffuLBCB5yPD1ijqDRSFeV/nkmvHin7J/JTtE=

U2VlbXMgeW91IHN0aWxsIHNlbnQgYSBwYXRjaCB0aGF0IGNvdWxkbid0IGJ1aWxkLgpIYXZlIHlv
dSBjaGVja2VkIG15IHByZXZpb3VzIGNvbW1lbnRzIGFuZCB0cmllZCBteSBzdWdnZXN0ZWQgd2F5
PwoKVGhhbmtzLApKb3NlcGgKCk9uIDEvMjAvMjIgODo0MyBQTSwgR2F1dGhhbSBBbmFudGhha3Jp
c2huYSB3cm90ZToKPiBjb21taXQgNmYxYjIyODUyOWFlNDliMGY4NWFiODliY2RiNmMzNjVkZjQw
MTU1OCBjYXVzZWQgYSBkZWFkbG9jawo+IHdoaWNoIHdhcyB1bmNvdmVyZWQgYnkgb3VyIGludGVy
bmFsIHRlc3RzLiBUaGUgZGVhZGxvY2sgaXMgYXMgZm9vbGxvd3M6Cj4gCj4gVGFzayAxOgo+IEEx
KSBqYmQyX2pvdXJuYWxfY29tbWl0X3RyYW5zYWN0aW9uKCkKPiBBMikgICAgICAgICBzcGluX2xv
Y2soJmpoLT5iX3N0YXRlX2xvY2spOwo+IEEzKSAgICAgICAgIF9famJkMl9qb3VybmFsX3JlbW92
ZV9jaGVja3BvaW50KCkKPiBBNCkgICAgICAgICAgICAgICAgICAgICAgICAgamJkMl9qb3VybmFs
X3B1dF9qb3VybmFsX2hlYWQoKQo+IEE1KSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgamJkX2xvY2tfYmhfam91cm5hbF9oZWFkKCkKPiAKPiBUYXNrIDI6Cj4gQjEpIG9j
ZnMyX3Rlc3RfYmdfYml0X2FsbG9jYXRhYmxlKCkKPiBCMikgICAgICAgICBqYmRfbG9ja19iaF9q
b3VybmFsX2hlYWQoKQo+IEIzKSAgICAgICAgIHNwaW5fbG9jaygmamgtPmJfc3RhdGVfbG9jayk7
Cj4gCj4gQTEtPkEyLT5BMy0+QTQtPkIxLT5CMi0+QjMoYmxvY2tlZCktPkE1KGJsb2NrZWQpCj4g
Cj4gTm93IGNhdXNlIHByb2Nlc3MgMiBoYXMgdGhlIGpiZCBsb2NrLCBpdCBkb2VzbuKAmXQgbGV0
IHByb2Nlc3MgMSB0byBjb250aW51ZSBhZnRlciBBNS4KPiBQcm9jZXNzIDIgbm93IGlzIHdhaXRp
bmcgZm9yIGJfc3RhdGVfbG9jayB0byBiZSByZWxlYXNlZCBieSBwcm9jZXNzIDEuCj4gCj4gVGhp
cyBwYXRjaCByZXNvbHZlcyB0aGUgZGVhZGxvY2suCj4gCj4gU2lnbmVkLW9mZi1ieTogR2F1dGhh
bSBBbmFudGhha3Jpc2huYSA8Z2F1dGhhbS5hbmFudGhha3Jpc2huYUBvcmFjbGUuY29tPgo+IC0t
LQo+ICBmcy9vY2ZzMi9zdWJhbGxvYy5jIHwgNyArKystLS0tCj4gIDEgZmlsZSBjaGFuZ2VkLCAz
IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2ZzL29jZnMy
L3N1YmFsbG9jLmMgYi9mcy9vY2ZzMi9zdWJhbGxvYy5jCj4gaW5kZXggNDgxMDE3ZS4uYTYxODk3
MCAxMDA2NDQKPiAtLS0gYS9mcy9vY2ZzMi9zdWJhbGxvYy5jCj4gKysrIGIvZnMvb2NmczIvc3Vi
YWxsb2MuYwo+IEBAIC0xMjU5LDkgKzEyNTksOCBAQCBzdGF0aWMgaW50IG9jZnMyX3Rlc3RfYmdf
Yml0X2FsbG9jYXRhYmxlKHN0cnVjdCBidWZmZXJfaGVhZCAqYmdfYmgsCj4gIAlpZiAoIWJ1ZmZl
cl9qYmQoYmdfYmgpKQo+ICAJCXJldHVybiAxOwo+ICAKPiAtCWpiZF9sb2NrX2JoX2pvdXJuYWxf
aGVhZChiZ19iaCk7Cj4gLQlpZiAoYnVmZmVyX2piZChiZ19iaCkpIHsKPiAtCQlqaCA9IGJoMmpo
KGJnX2JoKTsKPiArCWpoID0gamJkMl9qb3VybmFsX2dyYWJfam91cm5hbF9oZWFkKGJnX2JoKTsK
PiArCWlmIChqaCkgewo+ICAJCXNwaW5fbG9jaygmamgtPmJfc3RhdGVfbG9jayk7Cj4gIAkJYmcg
PSAoc3RydWN0IG9jZnMyX2dyb3VwX2Rlc2MgKikgamgtPmJfY29tbWl0dGVkX2RhdGE7Cj4gIAkJ
aWYgKGJnKQo+IEBAIC0xMjY5LDggKzEyNjgsOCBAQCBzdGF0aWMgaW50IG9jZnMyX3Rlc3RfYmdf
Yml0X2FsbG9jYXRhYmxlKHN0cnVjdCBidWZmZXJfaGVhZCAqYmdfYmgsCj4gIAkJZWxzZQo+ICAJ
CQlyZXQgPSAxOwo+ICAJCXNwaW5fdW5sb2NrKCZqaC0+Yl9zdGF0ZV9sb2NrKTsKPiArCQlqYmQy
X2pvdXJuYWxfcHV0X2pvdXJuYWxfaGVhZChiZ19iaCk7Cj4gIAl9Cj4gLQlqYmRfdW5sb2NrX2Jo
X2pvdXJuYWxfaGVhZChiZ19iaCk7Cj4gIAo+ICAJcmV0dXJuIHJldDsKPiAgfQoKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KT2NmczItZGV2ZWwgbWFpbGlu
ZyBsaXN0Ck9jZnMyLWRldmVsQG9zcy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20v
bWFpbG1hbi9saXN0aW5mby9vY2ZzMi1kZXZlbA==
