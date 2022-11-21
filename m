Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5838C433FE
	for <ocfs2-devel@archiver.kernel.org>; Mon, 21 Nov 2022 01:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=x8xthIVDF3Srp2eegQ5gbJ5/qH7fg4vKIxGoDZotcD0=;
 b=Ozvr6chBgg9iX1BfS+kftzh2W0edJVZ/Mu4msBPUf5gNYk2RSpl780hliz2aufIX/J8u1hbcD9hL
   GNaglIsycJ1nw+GqKXjvkc4Q/F3qXs2Gt+cu/lEDMDd/A/LsJM4YrsKzeJYxKaJ9PgRHApquSIQZ
   /4Dpz0uxiFPgciQNMvFVuZUKz3dUfk4jFs2Sq3MiJoUHWFB+khqQt/C20v8E9Itmz+SltFYmhMUA
   Y4aENZGtlAAxgHamKUaScyWbqT5Bd9rf3EcD/rX/T48pkdg9NbbieHXYacYWeaAwHNoVIKGs3dTm
   yHko1NLgUA2bYT2MsoulMa9NxZdJl8Yc91ThUg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=x8xthIVDF3Srp2eegQ5gbJ5/qH7fg4vKIxGoDZotcD0=;
 b=cUb9XElEfmMGUQR52w7K8/gXONu4QqhU38oCqwFboDX5IaBpE+FIhmHdMJhDopn9vUVutFTOJPvx
   05PY3CXCHgtwvB1sMPt/9kAqRB/dDfRqhUOuB2CmuR9NaPpmxLsT2BZJTG/0ykFnSXlxxVhBV7pY
   ITgWBZyANHHbE+iipK46ytwaB/qW02ylHAZyOAkWOV+d+S1v2FDmG9/lXB778/d8mlJOaTzK/iAw
   1Ui+S2YYO2o4v94czbDSMX2i4d9JBvkG881PtSavNVxJwk8dLPhw6mq1utfdAS5Sd0H0ckkHNowx
   57IdSW/ck7Qeh7/A5LUyeiudv9XpLKFz15sqlQ==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLO00K1FC8W5EF0@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 21 Nov 2022 01:31:44 +0000 (GMT)
Message-id: <911762fa-8fc2-ec01-e767-1ed8ae7e5c38@linux.alibaba.com>
Date: Mon, 21 Nov 2022 09:31:25 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Content-language: en-US
To: "Alexey Asemov (Alex/AT)" <alex@alex-at.net>, ocfs2-devel@oss.oracle.com
References: <d7a1e5ae-c43f-5a6a-c0c6-619a3e22b092@alex-at.net>
In-reply-to: <d7a1e5ae-c43f-5a6a-c0c6-619a3e22b092@alex-at.net>
X-Source-IP: 115.124.30.57
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10537
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 spamscore=0 clxscore=-76 mlxscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 mlxlogscore=999
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211210009 domainage_hfrom=8621
Subject: Re: [Ocfs2-devel] dinode link count inconsistency in
 ocfs2_read_links_count() logic
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R111e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046051;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0VVD3GXk_1668994285;
X-ServerName: out30-57.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: sj8Of-Gss_h4VXdjhvDlaNZtB1gi6Eh-
X-Proofpoint-GUID: sj8Of-Gss_h4VXdjhvDlaNZtB1gi6Eh-
Reporting-Meta:
 AAHJYBml1OofyuK/QsIalatNYQIfrj2pCdNvexu7kaLAyUez0Tb5UNHB0TT6xSQN
 X9sLZ6hqKwWsmX5QfDdeIuUKrHVsjLdIqJlCfiQldcER/npRWbPRDtwE+y2vzowQ
 9XzpwjSCOWbdhO6wR4vKEr+d1sgzC+4JOxoq0yG5CrxHkKYbLqgv4CMHq6RKZs2O
 XS2WNxgxSLANKRZEocr4a+yLDnF2P9Wmh/MpxWjdbAaKnghfD3oPz1LWc4TXW7TR
 3qbOzEHZevCvuO7pdTARyfQTf7uFrF0wHOfb3yIxEEASkZ9cICEMA7KR268yIk7F
 yMe98PzxaW/5hNKXHUPl+rI639GcCBXIC/61ACcH6kRzLPISj+fxVkC2Uyu5U4ug
 wOzjuiK0hpO2lNO66aSK0sy/VvgEndbbBnurT9YQeoN2OPmw2l+GpX4i8SqPYxPZ
 GeLiPc3jM7Soy/B8TDjzsNMx7D8wAr9mCwBqwzboSePiSZm1nIbnVa1X1KR3pBqB
 UXxYDH5xDkWFfM5LL4QqiXHAoEqE7bbJWOGBr3s1l1eo8Q==

SGksCgpvY2ZzMl9ta25vZCgpL29jZnMyX2xpbmsoKS9vY2ZzMl9yZW5hbWUoKSB3aWxsIGFsd2F5
cyBjaGVjawpvY2ZzMl9saW5rX21heCgpLCBzbyBpdCBzZWVtcyB0aGF0IGl0IHdvbid0IG92ZXJm
bG93LgpJIHdvbmRlciBpZiB5b3UndmUgZW5jb3VudGVyIGFub3RoZXIgYnVnIHRoYXQgbGVhZHMg
dG8gZGlub2RlIGxpbmsgY291bnQKbGVha2luZy4KClRoYW5rcywKSm9zZXBoCgpPbiAxMS8xOC8y
MiA1OjQ3IFBNLCBBbGV4ZXkgQXNlbW92IChBbGV4L0FUKSB2aWEgT2NmczItZGV2ZWwgd3JvdGU6
Cj4gSGVsbG8sCj4gCj4gV2hpbGUgZGlhZ25vc2luZyB1bmxpbmsgaGFuZyBpc3N1ZSwgSSBoYXZl
IGZvdW5kIGFuIGluY29uc2lzdGVuY3kgaW4gZGlub2RlIGhhcmRsaW5rIGNvdW50IGhhbmRsaW5n
Lgo+IAo+IElmIHdlIHRha2UgYSBsb29rIGF0IG9jZnMyLmgsIHNlY3Rpb25zIGJlbG93IHRoZSB0
ZXh0LCB3ZSBzZWUgb2NmczJfc2V0X2xpbmtzX2NvdW50KCkgYWx3YXlzIHN0b3JlcyBoaWdoIHBv
cnRpb24gb2YgbGluayBjb3VudCBpbnRvIGRpbm9kZSwgYnV0IG9jZnMyX3JlYWRfbGlua3NfY291
bnQoKSByZXRyaWV2ZXMgYW5kIGFkZHMgaGlnaCBwb3J0aW9uICpvbmx5KiB3aGVuIGlub2RlIGhh
cyBPQ0ZTMl9JTkRFWEVEX0RJUl9GTCBmbGFnIHNldC4KPiAKPiBUaGUgcHJvYmxlbSBpcywgb2Nm
czJfcmVhZF9saW5rc19jb3VudCgpIGlzIHVzZWQgdGhyb3VnaG91dCBhbGwgdGhlIGNvZGUgYW5k
IG5vdCBkaXJlY3RvcmllcyBvbmx5LiBGb3IgZmlsZXMsIE9DRlMyX0lOREVYRURfRElSX0ZMIGZs
YWcgaXMgbmV2ZXIgcHJlc2VudCwgc28gd2hlbiBudW1iZXIgb2YgaGFyZGxpbmtzIGZvciBmaWxl
IHNwaWxscyBvdmVyIDY1NTM1LCBpdCB3aWxsIGJlIHdyaXR0ZW4gYXMgNjU1MzYgY29ycmVjdGx5
IHRvIGRpbm9kZSwgYnV0IHRoZW4gd2lsbCBhbHdheXMgYmUgcmVhZCBhcyAwIHRvIGlub2RlIGR1
ZSB0byB0aGUgY2hlY2suIFRoaXMgY2F1c2VzIHdyb25nIGxpbmsgY291bnQgb2YgMCBpbiBzdGF0
KCkgYW5kIHRvdGFsIGhhbmcgb24gYXR0ZW1wdCB0byB1bmxpbmsgdGhlICdwYXJlbnQnIGlub2Rl
IGRpcmVjdG9yeSBlbnRyeSBzb21laG93ICh0aGlzIGlzIHRoZSBpc3N1ZSBJIGhpdCBidXQgSSBo
YXZlIG5vdCBkaWFnbm9zZWQgaG93IGl0IGhhcHBlbnMgYmVjYXVzZSBJIHN0dW1ibGVkIG9uIHdy
b25nIGxpbmsgY291bnQgaW1tZWRpYXRlbHkgYW5kIGR1ZyB0aGF0IGRpcmVjdGlvbikuCj4gCj4g
V2hpbGUgbm90IHN1cmUgYWJvdXQgdGhlIGludGVybmFscywgSSBzdWdnZXN0IHJlbW92aW5nCj4g
Cj4gLSBpZiAoZGktPmlfZHluX2ZlYXR1cmVzICYgY3B1X3RvX2xlMTYoT0NGUzJfSU5ERVhFRF9E
SVJfRkwpKQo+IAo+IGNoZWNrIGZvciB0aGUgdGltZSBiZWluZyBpbnNpZGUgb2NmczJfcmVhZF9s
aW5rc19jb3VudCgpIHNvIGl0IGFsd2F5cyByZWFkcyB0aGUgY29ycmVjdCBsaW5rIGNvdW50IGZy
b20gZGlub2RlLCBiZSBpdCBmaWxlIG9yIGRpcmVjdG9yeS4KPiAKPiBJIGRvIG5vdCBzZWUgZGlu
b2RlIGxpbmsgY291bnQgcGFydHMgdXNlZCBvdXRzaWRlIG9jZnMyLmggQVBJLCBzbyBpdCBzaG91
bGQgYmUgc2VtYW50aWNhbGx5IGNvcnJlY3QgdGhpbmcgdG8gZG8sIGJ1dCBwbGVhc2Ugc29tZW9u
ZSBhY3F1YWludGVkIHdpdGggdGhlIGxvZ2ljIGNvbmZpcm0uCj4gCj4gS1IsCj4gQWxleAo+IAo+
IC0tLQo+IAo+IHN0YXRpYyBpbmxpbmUgdW5zaWduZWQgaW50IG9jZnMyX3JlYWRfbGlua3NfY291
bnQoc3RydWN0IG9jZnMyX2Rpbm9kZSAqZGkpCj4gewo+IMKgwqDCoMKgwqDCoMKgIHUzMiBubGlu
ayA9IGxlMTZfdG9fY3B1KGRpLT5pX2xpbmtzX2NvdW50KTsKPiDCoMKgwqDCoMKgwqDCoCB1MzIg
aGkgPSBsZTE2X3RvX2NwdShkaS0+aV9saW5rc19jb3VudF9oaSk7Cj4gCj4gwqDCoMKgwqDCoMKg
wqAgaWYgKGRpLT5pX2R5bl9mZWF0dXJlcyAmIGNwdV90b19sZTE2KE9DRlMyX0lOREVYRURfRElS
X0ZMKSkKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbmxpbmsgfD0gKGhpIDw8IE9D
RlMyX0xJTktTX0hJX1NISUZUKTsKPiAKPiDCoMKgwqDCoMKgwqDCoCByZXR1cm4gbmxpbms7Cj4g
fQo+IAo+IHN0YXRpYyBpbmxpbmUgdm9pZCBvY2ZzMl9zZXRfbGlua3NfY291bnQoc3RydWN0IG9j
ZnMyX2Rpbm9kZSAqZGksIHUzMiBubGluaykKPiB7Cj4gwqDCoMKgwqDCoMKgwqAgdTE2IGxvLCBo
aTsKPiAKPiDCoMKgwqDCoMKgwqDCoCBsbyA9IG5saW5rOwo+IMKgwqDCoMKgwqDCoMKgIGhpID0g
bmxpbmsgPj4gT0NGUzJfTElOS1NfSElfU0hJRlQ7Cj4gCj4gwqDCoMKgwqDCoMKgwqAgZGktPmlf
bGlua3NfY291bnQgPSBjcHVfdG9fbGUxNihsbyk7Cj4gwqDCoMKgwqDCoMKgwqAgZGktPmlfbGlu
a3NfY291bnRfaGkgPSBjcHVfdG9fbGUxNihoaSk7Cj4gfQo+IAo+IAo+IF9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCj4gT2NmczItZGV2ZWwgbWFpbGluZyBs
aXN0Cj4gT2NmczItZGV2ZWxAb3NzLm9yYWNsZS5jb20KPiBodHRwczovL29zcy5vcmFjbGUuY29t
L21haWxtYW4vbGlzdGluZm8vb2NmczItZGV2ZWwKCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCk9jZnMyLWRldmVsIG1haWxpbmcgbGlzdApPY2ZzMi1kZXZl
bEBvc3Mub3JhY2xlLmNvbQpodHRwczovL29zcy5vcmFjbGUuY29tL21haWxtYW4vbGlzdGluZm8v
b2NmczItZGV2ZWw=
