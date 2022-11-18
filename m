Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56A15C433FE
	for <ocfs2-devel@archiver.kernel.org>; Fri, 18 Nov 2022 15:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=TtnYNkx9mbr5xtRQkT5Fv7j6MJlDZSZyFgHozg6ZVHE=;
 b=VVXFn1ZTgvBBlmxUm8AKQYvaR+tn0cBRsT/YYbUqLwZZmk6VLS+rFslArMDyhcVvnEQjMrJZRmjc
   0DcCJuBxm0LKz4HqlTeay1Cvj2X5HJv2NqJ3T+SokocM+nvWjWGnJLfYHY6vA4tvnlPjquZaFAuG
   fuOwJkClUEMwyjpGxL6G4Tw4y6JuzB+bO2VwvQQkjWQFFiFFKSnnBJs79SofA/XotqVFlJG00Tv9
   zyBqWAuSM0qGhs0Grivxk8EtJDBYts+EmK+Wc4qEJXQDVepm6Y3i3cHf0zIqvXpF5THdEWg/PjL6
   rnXqa2cEZ5ArT6ifHMpipQJV8CzyPuCi2CM2fQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=TtnYNkx9mbr5xtRQkT5Fv7j6MJlDZSZyFgHozg6ZVHE=;
 b=uYMDu20aaPhSJ1DP7nz7a9Hfr53FGYhLbagtK65BMpU9v4BvrjptgSFZUNfDf2BgVh3QRzZdCqT5
   8xNyFO37j0r9msJY70IjL4MD8pV+vdRRB1Jc56g5b7o2J//gjxDBkQ10FjGrUI9oDK60WjULu9z4
   BN4D5ynM5nfTk2wmvYF8O4ambhLRcWV+fUrBCGzved9FgXzQga+G96DuF7A76TgrMTrOgmql7bDq
   DXtpsx0CpBsy3gR59/ZQNQYBIN47eKqFR0YRPt5Q6IPI4OWGuYWWkhPkbiBVY7I+GpEY1g+GZ89N
   NfGMle6p4FwDhqwzs+c8mpbh7nQowMrTlm3Sqw==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLJ00CJHVX96XA0@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 18 Nov 2022 15:48:45 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=alex-at.net; s=default;
 t=1668764830; bh=3URRL+UlOHaG3BpU6oP53f4eZ6Rgbm4RlFuhcX8/5hg=;
 h=Date:To:From:Subject;
 b=yamrj+JIhD26z8mA4P63Uxo6iu7Q/Gke2rv+/fZlWRRNtqd/7Hm3C1aEQTX1ZkI/V
 wMW9KEcjfTYI6PPiAEasVDRlVI53dUiVHrAnx5JNHvqispJcQFKKjarCTBeIr9s1Tn
 Zc5iXWT0PbvynCzbOJmsxp6ctq0sg5gEvzS2WMmU=
Message-id: <d7a1e5ae-c43f-5a6a-c0c6-619a3e22b092@alex-at.net>
Date: Fri, 18 Nov 2022 12:47:09 +0300
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Content-language: en-US
To: ocfs2-devel@oss.oracle.com
X-Source-IP: 51.195.137.138
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10534
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 mlxlogscore=787 clxscore=70 impostorscore=0 spamscore=0 lowpriorityscore=0
 suspectscore=0 adultscore=0 priorityscore=0 malwarescore=0 mlxscore=0
 phishscore=0 unknownsenderscore=20 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2211180058
Subject: [Ocfs2-devel] dinode link count inconsistency in
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
From: "Alexey Asemov \(Alex/AT\) via Ocfs2-devel" <ocfs2-devel@oss.oracle.com>
Reply-to: "Alexey Asemov \(Alex/AT\)" <alex@alex-at.net>
Content-transfer-encoding: base64
Content-type: text/plain; charset="utf-8"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: mail.alex-at.net
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 a mx a:home.alex-at.net a:sphynx.alex-at.net
 a:mail.alex-at.net a:mx.alex-at.net a:home.alex-at.net a:sphynx.alex-at.net
 a:mail.alex-at.net a:mx.alex-at.net ~all
X-Spam: Clean
X-Proofpoint-GUID: Xmgo-Q2MnT8OCMcDS-eAT997rSWQH2bV
X-Proofpoint-ORIG-GUID: Xmgo-Q2MnT8OCMcDS-eAT997rSWQH2bV
X-Mailman-Approved-At: Fri, 18 Nov 2022 15:48:44 +0000
Reporting-Meta:
 AAEoQVbQidp7F8D8mz3QJWpgoY3qI744tjk/FwGG2w1ZRuLT1zQRhQTqLc+Ca6Kr
 THwBebzHIrvUTB6lT3pVsd/dINsZw2iW2XaatXF2F3BR32q+iA0CCrLodpBSlv2Z
 kCBxJHAQZQQr7oYnG9ErdGtc8lBINxw6PIQom7UKdSNAmAxBgIFsbnF3nK/mdCMm
 YGLQDHnbkzrULbIQJOEhRQ12HBKVbgT6tFR341M5V/h1IAnFiPNSpELaMb4atzQY
 Y9WmkXI4wVNItaei/T/EnF96aLQ41SDAF9YGZ85xilo+4voK2/wSgxAR1RvQm9QD
 h5S23KyScfDZGP8ww/cfTwwk5Ih4ams9hfOfbk9QHxrpWCfCqg3PaW+h2Z9VTwm8
 b+cvBXIhjx+lUb9nSmn29isgmXNpTOMCGLWsCSbaB+26hmLEmlS4D+ERs4PuXd89
 9oyMcOwZq/Ono7HL5HLOz5IVds4MoNEmS9KZO4rQosUWlHgqhHeEHj1mRKjNAqUe
 YcsPr+nrgwTrIcdfMha/GOTZpTyGuh0F/a1TBJQAor1V

SGVsbG8sCgpXaGlsZSBkaWFnbm9zaW5nIHVubGluayBoYW5nIGlzc3VlLCBJIGhhdmUgZm91bmQg
YW4gaW5jb25zaXN0ZW5jeSBpbiAKZGlub2RlIGhhcmRsaW5rIGNvdW50IGhhbmRsaW5nLgoKSWYg
d2UgdGFrZSBhIGxvb2sgYXQgb2NmczIuaCwgc2VjdGlvbnMgYmVsb3cgdGhlIHRleHQsIHdlIHNl
ZSAKb2NmczJfc2V0X2xpbmtzX2NvdW50KCkgYWx3YXlzIHN0b3JlcyBoaWdoIHBvcnRpb24gb2Yg
bGluayBjb3VudCBpbnRvIApkaW5vZGUsIGJ1dCBvY2ZzMl9yZWFkX2xpbmtzX2NvdW50KCkgcmV0
cmlldmVzIGFuZCBhZGRzIGhpZ2ggcG9ydGlvbiAKKm9ubHkqIHdoZW4gaW5vZGUgaGFzIE9DRlMy
X0lOREVYRURfRElSX0ZMIGZsYWcgc2V0LgoKVGhlIHByb2JsZW0gaXMsIG9jZnMyX3JlYWRfbGlu
a3NfY291bnQoKSBpcyB1c2VkIHRocm91Z2hvdXQgYWxsIHRoZSBjb2RlIAphbmQgbm90IGRpcmVj
dG9yaWVzIG9ubHkuIEZvciBmaWxlcywgT0NGUzJfSU5ERVhFRF9ESVJfRkwgZmxhZyBpcyBuZXZl
ciAKcHJlc2VudCwgc28gd2hlbiBudW1iZXIgb2YgaGFyZGxpbmtzIGZvciBmaWxlIHNwaWxscyBv
dmVyIDY1NTM1LCBpdCB3aWxsIApiZSB3cml0dGVuIGFzIDY1NTM2IGNvcnJlY3RseSB0byBkaW5v
ZGUsIGJ1dCB0aGVuIHdpbGwgYWx3YXlzIGJlIHJlYWQgYXMgCjAgdG8gaW5vZGUgZHVlIHRvIHRo
ZSBjaGVjay4gVGhpcyBjYXVzZXMgd3JvbmcgbGluayBjb3VudCBvZiAwIGluIHN0YXQoKSAKYW5k
IHRvdGFsIGhhbmcgb24gYXR0ZW1wdCB0byB1bmxpbmsgdGhlICdwYXJlbnQnIGlub2RlIGRpcmVj
dG9yeSBlbnRyeSAKc29tZWhvdyAodGhpcyBpcyB0aGUgaXNzdWUgSSBoaXQgYnV0IEkgaGF2ZSBu
b3QgZGlhZ25vc2VkIGhvdyBpdCBoYXBwZW5zIApiZWNhdXNlIEkgc3R1bWJsZWQgb24gd3Jvbmcg
bGluayBjb3VudCBpbW1lZGlhdGVseSBhbmQgZHVnIHRoYXQgZGlyZWN0aW9uKS4KCldoaWxlIG5v
dCBzdXJlIGFib3V0IHRoZSBpbnRlcm5hbHMsIEkgc3VnZ2VzdCByZW1vdmluZwoKLSBpZiAoZGkt
PmlfZHluX2ZlYXR1cmVzICYgY3B1X3RvX2xlMTYoT0NGUzJfSU5ERVhFRF9ESVJfRkwpKQoKY2hl
Y2sgZm9yIHRoZSB0aW1lIGJlaW5nIGluc2lkZSBvY2ZzMl9yZWFkX2xpbmtzX2NvdW50KCkgc28g
aXQgYWx3YXlzIApyZWFkcyB0aGUgY29ycmVjdCBsaW5rIGNvdW50IGZyb20gZGlub2RlLCBiZSBp
dCBmaWxlIG9yIGRpcmVjdG9yeS4KCkkgZG8gbm90IHNlZSBkaW5vZGUgbGluayBjb3VudCBwYXJ0
cyB1c2VkIG91dHNpZGUgb2NmczIuaCBBUEksIHNvIGl0IApzaG91bGQgYmUgc2VtYW50aWNhbGx5
IGNvcnJlY3QgdGhpbmcgdG8gZG8sIGJ1dCBwbGVhc2Ugc29tZW9uZSAKYWNxdWFpbnRlZCB3aXRo
IHRoZSBsb2dpYyBjb25maXJtLgoKS1IsCkFsZXgKCi0tLQoKc3RhdGljIGlubGluZSB1bnNpZ25l
ZCBpbnQgb2NmczJfcmVhZF9saW5rc19jb3VudChzdHJ1Y3Qgb2NmczJfZGlub2RlICpkaSkKewog
wqDCoMKgwqDCoMKgwqAgdTMyIG5saW5rID0gbGUxNl90b19jcHUoZGktPmlfbGlua3NfY291bnQp
OwogwqDCoMKgwqDCoMKgwqAgdTMyIGhpID0gbGUxNl90b19jcHUoZGktPmlfbGlua3NfY291bnRf
aGkpOwoKIMKgwqDCoMKgwqDCoMKgIGlmIChkaS0+aV9keW5fZmVhdHVyZXMgJiBjcHVfdG9fbGUx
NihPQ0ZTMl9JTkRFWEVEX0RJUl9GTCkpCiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
bmxpbmsgfD0gKGhpIDw8IE9DRlMyX0xJTktTX0hJX1NISUZUKTsKCiDCoMKgwqDCoMKgwqDCoCBy
ZXR1cm4gbmxpbms7Cn0KCnN0YXRpYyBpbmxpbmUgdm9pZCBvY2ZzMl9zZXRfbGlua3NfY291bnQo
c3RydWN0IG9jZnMyX2Rpbm9kZSAqZGksIHUzMiBubGluaykKewogwqDCoMKgwqDCoMKgwqAgdTE2
IGxvLCBoaTsKCiDCoMKgwqDCoMKgwqDCoCBsbyA9IG5saW5rOwogwqDCoMKgwqDCoMKgwqAgaGkg
PSBubGluayA+PiBPQ0ZTMl9MSU5LU19ISV9TSElGVDsKCiDCoMKgwqDCoMKgwqDCoCBkaS0+aV9s
aW5rc19jb3VudCA9IGNwdV90b19sZTE2KGxvKTsKIMKgwqDCoMKgwqDCoMKgIGRpLT5pX2xpbmtz
X2NvdW50X2hpID0gY3B1X3RvX2xlMTYoaGkpOwp9CgoKX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0Ck9jZnMyLWRl
dmVsQG9zcy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9saXN0aW5m
by9vY2ZzMi1kZXZlbA==
