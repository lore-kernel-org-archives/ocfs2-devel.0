Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10190C433F5
	for <ocfs2-devel@archiver.kernel.org>; Thu, 20 Jan 2022 06:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Vd2xf5fMisxzQNEnyd0q7UQkAa2yzplrMlT+VmwyoII=;
 b=h1eYZsYtIsMMnbC+pF/a8geXpoxGo5tRUlL7OtfWP+rT9dMYgqeMtgNPfSB6Od5Pqu8+JAMCKv4b
   xjw4XIhPpRc4Jb3zqW9apznO9a11h+v0k4N8kTOunAY6OnEvCTbm7CyXMKu7cvmFRb5G7o2NG0Yl
   2UTz2FUjonqS+O4jJaGISHdLmd8PMgVAiyPadn9zJFPHv9meItGphPRVzApNrAaJk4xzGkwwS4Zf
   Pj9kLIFWogFp3iBwr68XkIsttzvtWZ63GX6teZQog3bnEFKYUxTrWqH27gJp4aZb9TWmkgnSkUZG
   TG/onhZDVLn12rDXIWwZiHUWC/+gYxfWyOTO5A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Vd2xf5fMisxzQNEnyd0q7UQkAa2yzplrMlT+VmwyoII=;
 b=KDgUAOIe1ZTwGURAJNLt++xj1xYhgT3MO2NS33HrNqFzC25L2clZ17nAudn3cVZDYwpQ7N9vFoLa
   pRA4X9WwhLaGdu4fxe0RzQzSgmBUNIpO6xr5ysc/CG2qL7IExykppaWsnCVZ66ewmICNbvbW4pKU
   6AMUYfNrGBxhxiKbRXZXuvDyLc2DgrHd+4s4roz/RpAMy3Y1gJo9NZypfXMtVeMmy6BIuqxLMMhP
   /nqVFr61xg4UBHqKLCPKceuSbb5g3UFsMQxv+r1+Wbk68zePG8UEOA/+QbZUpOnbLrSKv+7SXHwq
   nM1zNvs4L5CfEKTzAUyF1mWV3CuOKKREh3+ZJw==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220104 64bit (built Jan  4
 2022))
 with ESMTPS id <0R5Z00F9ZVOGWP70@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 20 Jan 2022 06:07:28 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to
 : subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2021-07-09;
 bh=ZRGbFX5P2t/ikOU1zNc2eD2IcxIjNjuP5VmsvmzTJDY=;
 b=qfV2bcMtiA/uVt0vy5SHB+O5gA9sPqfPfeZgaOrfEkQEdZ5e3A5vp/rD4xbo/umavRZm
 zOO7W97u431gIW93ag+0/UwW35rpMeQfvhrpJuyS/uszCH4NIECeJHIgqA6D7jKEfNPw
 j7pDcS/CzOwI05N8jsIozf9LZVeWbLDoCPNAM+E3PUWY2w4ZWQhhfyokFCO/xdgy/eF/
 4jC7pVJJG0dbO5Cp29fjSo9yQAmBV2JaBA2d1w1m9Jr8kP84dAlx2Kv84ji2lBuTd4Vw
 i8sUFhglZ7agTSqbdKNft+OHhc4RZlbSHi2Gb/Jb6DSFfIo1qlWfH4Sdximh2zn2xkSz Jg==
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=gautham.ananthakrishna@oracle.com; dmarc=none
 header.from=oracle.com
To: gautham.ananthakrishna@oracle.com, junxiao.bi@oracle.com,
 rajesh.sivaramasubramaniom@oracle.com, joseph.qi@linux.alibaba.com,
 ocfs2-devel@oss.oracle.com
Date: Thu, 20 Jan 2022 11:37:14 +0530
Message-id:
 <1642658834-18657-1-git-send-email-gautham.ananthakrishna@oracle.com>
X-Mailer: git-send-email 1.8.3.1
MIME-version: 1.0
Subject: [Ocfs2-devel] [PATCH RFC 1/1] ocfs2: fix a deadlock caused by	commit
 6f1b228529ae49b0
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
From: Gautham Ananthakrishna via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: base64
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-GUID: euz1qgvMhHs3ojRS0jYcDHU93hy-NO3k
X-Proofpoint-ORIG-GUID: euz1qgvMhHs3ojRS0jYcDHU93hy-NO3k
Reporting-Meta:
 AAE7t6UTTNjbDtK7gR8L5T2zdOIuRcaZetFIqOA+uc8uD0OET4hdDu6Q1577h04P
 ToYgyDSL+K3euk96r6Rgnu/Timxb3yBjk0ktSyT82Aw5MCcvM1Htv57GMSlpYdYg
 5vEDDwLx0swsq0I8jSaDZVtzRVwM+816S+pLRfJFi5DPnVrPErFEg9m3HJNfAxWQ
 epAVc64m2pk+2lOmqD4S8/tJO0ODYAiY6DsoAnRHNZDkCYV2ePkHGOs/SQ9V91Y5
 oBmPBnKu61E+uqjEoiGMdXZXbHqzpLAGx4NnBgI1LbCklG+no4zkc4AVUoyi/9y5
 JVZ/k68mvpHZNvNesE5yWDLa6N9Tl5EaLa1N1OlbjxjYoXb8gGLC92/kXybeDI9w
 97z32p7YWRg4hm2MZzdw+Of4wt4zaQ6i6UWaPzu87KWRVO5NL1ISC6r/aQk+8H5W
 ZfU4XLEBjuiiVOBKzbBzHGMMoPBvn0itwM+SuufP/fRSGgcj28JgD9K6vnlxhLHu
 ZT8xCnc5ukiVpFQKxqEjovMJ6aHgMRUZQ3TGpJvErWw=

Y29tbWl0IDZmMWIyMjg1MjlhZTQ5YjBmODVhYjg5YmNkYjZjMzY1ZGY0MDE1NTggY2F1c2VkIGEg
ZGVhZGxvY2sKd2hpY2ggd2FzIHVuY292ZXJlZCBieSBvdXIgaW50ZXJuYWwgdGVzdHMuIFRoZSBk
ZWFkbG9jayBpcyBhcyBmb29sbG93czoKClRhc2sgMToKQTEpIGpiZDJfam91cm5hbF9jb21taXRf
dHJhbnNhY3Rpb24oKQpBMikgICAgICAgICBzcGluX2xvY2soJmpoLT5iX3N0YXRlX2xvY2spOwpB
MykgICAgICAgICBfX2piZDJfam91cm5hbF9yZW1vdmVfY2hlY2twb2ludCgpCkE0KSAgICAgICAg
ICAgICAgICAgICAgICAgICBqYmQyX2pvdXJuYWxfcHV0X2pvdXJuYWxfaGVhZCgpCkE1KSAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgamJkX2xvY2tfYmhfam91cm5hbF9o
ZWFkKCkKClRhc2sgMjoKQjEpIG9jZnMyX3Rlc3RfYmdfYml0X2FsbG9jYXRhYmxlKCkKQjIpICAg
ICAgICAgamJkX2xvY2tfYmhfam91cm5hbF9oZWFkKCkKQjMpICAgICAgICAgc3Bpbl9sb2NrKCZq
aC0+Yl9zdGF0ZV9sb2NrKTsKCkExLT5BMi0+QTMtPkE0LT5CMS0+QjItPkIzKGJsb2NrZWQpLT5B
NShibG9ja2VkKQoKTm93IGNhdXNlIHByb2Nlc3MgMiBoYXMgdGhlIGpiZCBsb2NrLCBpdCBkb2Vz
buKAmXQgbGV0IHByb2Nlc3MgMSB0byBjb250aW51ZSBhZnRlciBBNS4KUHJvY2VzcyAyIG5vdyBp
cyB3YWl0aW5nIGZvciBiX3N0YXRlX2xvY2sgdG8gYmUgcmVsZWFzZWQgYnkgcHJvY2VzcyAxLgoK
VGhpcyBwYXRjaCByZXNvbHZlcyB0aGUgZGVhZGxvY2suCgpTaWduZWQtb2ZmLWJ5OiBHYXV0aGFt
IEFuYW50aGFrcmlzaG5hIDxnYXV0aGFtLmFuYW50aGFrcmlzaG5hQG9yYWNsZS5jb20+Ci0tLQog
ZnMvb2NmczIvc3ViYWxsb2MuYyB8IDQgKystLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9u
cygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9vY2ZzMi9zdWJhbGxvYy5jIGIv
ZnMvb2NmczIvc3ViYWxsb2MuYwppbmRleCA0ODEwMTdlLi5mZDk5NTg3MCAxMDA2NDQKLS0tIGEv
ZnMvb2NmczIvc3ViYWxsb2MuYworKysgYi9mcy9vY2ZzMi9zdWJhbGxvYy5jCkBAIC0xMjU5LDcg
KzEyNTksNyBAQCBzdGF0aWMgaW50IG9jZnMyX3Rlc3RfYmdfYml0X2FsbG9jYXRhYmxlKHN0cnVj
dCBidWZmZXJfaGVhZCAqYmdfYmgsCiAJaWYgKCFidWZmZXJfamJkKGJnX2JoKSkKIAkJcmV0dXJu
IDE7CiAKLQlqYmRfbG9ja19iaF9qb3VybmFsX2hlYWQoYmdfYmgpOworCWpiZDJfam91cm5hbF9n
cmFiX2pvdXJuYWxfaGVhZChiZ19iaCk7CiAJaWYgKGJ1ZmZlcl9qYmQoYmdfYmgpKSB7CiAJCWpo
ID0gYmgyamgoYmdfYmgpOwogCQlzcGluX2xvY2soJmpoLT5iX3N0YXRlX2xvY2spOwpAQCAtMTI3
MCw3ICsxMjcwLDcgQEAgc3RhdGljIGludCBvY2ZzMl90ZXN0X2JnX2JpdF9hbGxvY2F0YWJsZShz
dHJ1Y3QgYnVmZmVyX2hlYWQgKmJnX2JoLAogCQkJcmV0ID0gMTsKIAkJc3Bpbl91bmxvY2soJmpo
LT5iX3N0YXRlX2xvY2spOwogCX0KLQlqYmRfdW5sb2NrX2JoX2pvdXJuYWxfaGVhZChiZ19iaCk7
CisJamJkMl9qb3VybmFsX3B1dF9qb3VybmFsX2hlYWQoYmdfYmgpOwogCiAJcmV0dXJuIHJldDsK
IH0KLS0gCjEuOC4zLjEKCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5nIGxpc3QKT2NmczItZGV2ZWxAb3NzLm9yYWNsZS5j
b20KaHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9tYWlsbWFuL2xpc3RpbmZvL29jZnMyLWRldmVs
