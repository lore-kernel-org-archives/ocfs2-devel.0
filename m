Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F91BC433EF
	for <ocfs2-devel@archiver.kernel.org>; Thu, 20 Jan 2022 12:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=RbJSbl3gsxqLSjO8WQfPeioUJom36sKcGcMS9uujEA4=;
 b=MaMpAM0ttLTI3S6C1xPqkCHpeW9Z83CwXAa1v1gKpIq+BgT3AjD1i8U35Ko7MeKhasqxokhzJVou
   ch2I3oJhQT4nC+tyI9+DGpjf0HJEymJUE/Z+wU63FGyomRSPgmZWs3JNzxjPcNqn8eN8e2e1n3tg
   F00B7HASI2StWzvVfheUHexJP1udFA9YAFLeYe4Iuc8VD5fYCBqwYgmooch2NF5NtQYgn57l99ui
   Vs8Ciw447K/2Dl2dq0NEzirBsE8SC+dl/ZmQeLXArzEt9aZS/iu9OPSY4b/vguyalugovc/hOgAm
   H0c7bLx4neytFv9YYM6ik0k0y17F6rJReR7I0w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=RbJSbl3gsxqLSjO8WQfPeioUJom36sKcGcMS9uujEA4=;
 b=rzbgGaA4Jz78yitfjpmPfArWYWkbaCmsJ0J0l8/fpu5GX805TyyHpge0eXJQjX669s0pBf5+vtws
   gzKIFoRpVNnwYbA8j9SC2C05xTZGAsYRoafHha0UGTt+X/kLlZTSLT7+qitThZDxQPXAnbBMAwRf
   VTn5+MSojJsaqn3KfDVVklewGbo+4oxjbPvqT1yGOW5+pR6vhyDDMDn6Y/RroXME3naWvh7UUEsm
   iRsjP66DM+BETjJs+slF5tge5p1/oPdib7LUF0MBJXeXzSA+GWp4buGbjAxYe8nYdQKJxv1KW6mk
   1pZ3nAYb0IShe63qojgZzNBjYDSbMmY7XyNidQ==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220104 64bit (built Jan  4
 2022))
 with ESMTPS id <0R6000OPAE1EDS40@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 20 Jan 2022 12:44:02 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to
 : cc : subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2021-07-09;
 bh=5EVQk7DeK5O+ezHFVJ38s6qRGdAmJwr5OBn9+f8tBMQ=;
 b=nB5P2/W/L0W+WhhKZk+zMI2ao3nnPwATNAdHL6mxHOALFzFXFNZhdApscwi6CENCsXUE
 qq+jwEfFamgea/qYBEhPGCdZZYpmMBnP/XdKeDq+bdkPGeJk1mShLJhkhngU//sXQFKF
 Z3TevN8Y7PFuQr6ZmJuGiohbyUqIaKu+FqN2bTrH51GhhF3HseB4LmLk5BFeOsEVjarp
 BXe5KQOYjcjxXIkAj8XXg3ekjoYC1cOc53oOn5UQ4N0Hj+g5DHSxdid+xZUkL6GXJoSw
 MJy5jyM5vz7PS/iBF5h4uF5UyoC/rg0OsMEBZT/FFCMbRRDMWtMXPOxrD5A6xzfq/MFh Mw==
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=gautham.ananthakrishna@oracle.com; dmarc=none
 header.from=oracle.com
To: ocfs2-devel@oss.oracle.com, joseph.qi@linux.alibaba.com
Date: Thu, 20 Jan 2022 18:13:47 +0530
Message-id:
 <1642682627-12041-1-git-send-email-gautham.ananthakrishna@oracle.com>
X-Mailer: git-send-email 1.8.3.1
MIME-version: 1.0
Cc: rajesh.sivaramasubramaniom@oracle.com, gautham.ananthakrishna@oracle.com
Subject: [Ocfs2-devel] [PATCHC RFC V2 1/1] ocfs2: fix a deadlock when commit
	trans
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
X-Proofpoint-GUID: KwboEhAd9ELOvYC6v_3b0V8k408qicnh
X-Proofpoint-ORIG-GUID: KwboEhAd9ELOvYC6v_3b0V8k408qicnh
Reporting-Meta:
 AAFPx5IXvphoQu/gubm9UV106jEMTctUc/RP6c8vH4LqDT6CCLMlG34h31zYIu+6
 HOm7UrnDfBz3wyySG7BnZL85o5hxgq7CIkTEL4GU/RDQxTI9cr6dvlF5XyEuprKZ
 5JgtUR6vEtgIfTmoPcdgbMvWmT8J2oEIzBB5nKyJK1FrJI3PfUgQsdMEl2D1UK9U
 yIUKWnfrJLXo8dEWYfjqg630mkLd4gBvDkZulw3p4dmsNzRqvnDNxdrcCIG6oTx/
 vTMHrk6gt2HZkOWHR0YuUdwmM8aIaWnAX6J4xPscwuz49iU8yIx8cz7C8QuNZD01
 L826USEFqYqFl3BKWKrDHfaZfx4rjitM1qSnZ8wO1v8mBHidekQEVt2Lz4JiLPao
 WzSc5nDb2G3OSQFg/y5+gdnkE0D3SB0n3ebHhdP6T7fJ6KYgVlWqYJDMkleJok+k
 kbWjZSgOZ44NzDSmwg1YMUgPhS94nZfKESCoJf/B/FJmfS5wcibOlq4ksfhBjd01
 IOm/+rKunvCaqjxch9O5MmZoH6dvqrOakCBCaF8VS8Y=

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
ZnMvb2NmczIvc3ViYWxsb2MuYyB8IDcgKysrLS0tLQogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0
aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9vY2ZzMi9zdWJhbGxvYy5j
IGIvZnMvb2NmczIvc3ViYWxsb2MuYwppbmRleCA0ODEwMTdlLi5hNjE4OTcwIDEwMDY0NAotLS0g
YS9mcy9vY2ZzMi9zdWJhbGxvYy5jCisrKyBiL2ZzL29jZnMyL3N1YmFsbG9jLmMKQEAgLTEyNTks
OSArMTI1OSw4IEBAIHN0YXRpYyBpbnQgb2NmczJfdGVzdF9iZ19iaXRfYWxsb2NhdGFibGUoc3Ry
dWN0IGJ1ZmZlcl9oZWFkICpiZ19iaCwKIAlpZiAoIWJ1ZmZlcl9qYmQoYmdfYmgpKQogCQlyZXR1
cm4gMTsKIAotCWpiZF9sb2NrX2JoX2pvdXJuYWxfaGVhZChiZ19iaCk7Ci0JaWYgKGJ1ZmZlcl9q
YmQoYmdfYmgpKSB7Ci0JCWpoID0gYmgyamgoYmdfYmgpOworCWpoID0gamJkMl9qb3VybmFsX2dy
YWJfam91cm5hbF9oZWFkKGJnX2JoKTsKKwlpZiAoamgpIHsKIAkJc3Bpbl9sb2NrKCZqaC0+Yl9z
dGF0ZV9sb2NrKTsKIAkJYmcgPSAoc3RydWN0IG9jZnMyX2dyb3VwX2Rlc2MgKikgamgtPmJfY29t
bWl0dGVkX2RhdGE7CiAJCWlmIChiZykKQEAgLTEyNjksOCArMTI2OCw4IEBAIHN0YXRpYyBpbnQg
b2NmczJfdGVzdF9iZ19iaXRfYWxsb2NhdGFibGUoc3RydWN0IGJ1ZmZlcl9oZWFkICpiZ19iaCwK
IAkJZWxzZQogCQkJcmV0ID0gMTsKIAkJc3Bpbl91bmxvY2soJmpoLT5iX3N0YXRlX2xvY2spOwor
CQlqYmQyX2pvdXJuYWxfcHV0X2pvdXJuYWxfaGVhZChiZ19iaCk7CiAJfQotCWpiZF91bmxvY2tf
Ymhfam91cm5hbF9oZWFkKGJnX2JoKTsKIAogCXJldHVybiByZXQ7CiB9Ci0tIAoxLjguMy4xCgoK
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KT2NmczItZGV2
ZWwgbWFpbGluZyBsaXN0Ck9jZnMyLWRldmVsQG9zcy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9y
YWNsZS5jb20vbWFpbG1hbi9saXN0aW5mby9vY2ZzMi1kZXZlbA==
