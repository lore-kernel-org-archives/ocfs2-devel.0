Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3ABEC433EF
	for <ocfs2-devel@archiver.kernel.org>; Thu, 20 Jan 2022 10:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=RbJSbl3gsxqLSjO8WQfPeioUJom36sKcGcMS9uujEA4=;
 b=GdfmqzYtxwrH5+nebr0/M0rLK5pIt5pUeCd6Y9bmjtuPpLt3Vj9R/bjEA9I/p5lmNeEh245d+bof
   O3bBx3mu76CjsDN49Do7ES/2hw3EFY2ES6uzVIUIGli/TbMvtaYruXOi1eu8mDCd6FglAH3xNfnC
   +iHrFuF6R4DA/NY30gQsa+C0lVAxfy4D8LJSDlW5E8SdN+mZGTjCMsRAFqt3MJFiZ7fyuSzzPxT7
   zTnWMBAkDz73KlfkLIMdZGPLGwaKJ2HK/ioOTDBufPldCEorp3ZiX/eQzk0tJ/0dt8VT9HrEaUCq
   wL+PtQScUxrjQ8vvkSwundFxUSkQ82N5ydTUXg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=RbJSbl3gsxqLSjO8WQfPeioUJom36sKcGcMS9uujEA4=;
 b=tMlsvC2gesnNdlmXFD+Gw8JmMbsacDB72+CchaAW5pPyprtzMv4cmCPOJN8QjJihranoSXql+h5b
   c4mtokLCYtmsitHiBEpa66l+qFPsKeHDTlVB6JiRQE7+PMfJDbfnWwhU6Ysh58fTf5nVHLxDSQlq
   mowmXZBt1OOO4RQ6bEXeEjhLt4zxVD2q5AChSCkzXIl2OydqJbqUx3oj5+4R+lcPuy40897GPqRU
   Zx2RmeE1qtC1hYiWCfzHxYzak4IAumXkwzMWPyRtFnz3n9Yn4PJNbK6A4UYE3famgCvVboHf419R
   CCci/cr6geOaKR5NyPN+g3AzatONQ50QtCMRmg==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220104 64bit (built Jan  4
 2022))
 with ESMTPS id <0R6000FZP6SOWPE0@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 20 Jan 2022 10:07:36 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to
 : subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2021-07-09;
 bh=5EVQk7DeK5O+ezHFVJ38s6qRGdAmJwr5OBn9+f8tBMQ=;
 b=EMKm9+s1xGYx4qR5vj6js44jj/Pm3LJY2zF85TkEKrSdJqgF6SoVNM/aEe/2niePUZdI
 rpsCkR6x+7B2qVfBE1rMP8sWyenO0yDX+tKmobaeYANo0J2aTVvuHQOGpbh7DsZvgGMC
 FBIPOlwEczYAR37Ud6DsjBQ5Xrzvv2JBwpmJk5QLjhTB8pRfqi+5aZg+Sqd54Cej9VK6
 s3Dy7+hcwOdzXHgNeocSnVmzheHFpg09upXuc78WUC3sq4I6WDeGT+j5PmJu68h3QHAy
 SIy6fT4UMRBBMt/R5gOCTyRg+87Nzz/2mxcBg32Z0OIL42N9Ok866z27SgnZUcJka9in VA==
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=gautham.ananthakrishna@oracle.com; dmarc=none
 header.from=oracle.com
To: gautham.ananthakrishna@oracle.com, junxiao.bi@oracle.com,
 rajesh.sivaramasubramaniom@oracle.com, joseph.qi@linux.alibaba.com,
 ocfs2-devel@oss.oracle.com
Date: Thu, 20 Jan 2022 15:37:22 +0530
Message-id: <1642673242-1522-1-git-send-email-gautham.ananthakrishna@oracle.com>
X-Mailer: git-send-email 1.8.3.1
MIME-version: 1.0
Subject: [Ocfs2-devel] [PATCH RFC V1 1/1] ocfs2: fix a deadlock caused by
	commit 6f1b228529ae49b0
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
X-Proofpoint-GUID: Yv73dcS_pQjuNk1TjiylIGZNJ1Hz8Hhj
X-Proofpoint-ORIG-GUID: Yv73dcS_pQjuNk1TjiylIGZNJ1Hz8Hhj
Reporting-Meta:
 AAFZAoYHqutrfkDee89Q7jdC4mDNbgThFxWf/MEiI442OYxSTRVNUog9X8sKAanD
 uc/wIERl1jlrVkbzcA9XSl+wVxlevKTNpNbCVdHPjDQ7l7sAHBifNcw2ie6EXO5T
 4xiUN+l/XnxqrxWRJoLiXNmlqkG3j8Jwqt93G0AKPoJJW5mFNWechR74HQjcEZE2
 zmxiRd+IXew8efvE04lQ8DiiCBjdOq01u2BS/CLaorPPS0AKB4zlbbMGRrnCsbOG
 Wy5LmaWwD0lDkurTaP6fTFY11f+d6bCfGSWc94rJdbI3mvlH8l6yB4AA+lv9LIMT
 QRVAdNuS2YlDyWnTOtuioj9hanE+az4SjuC6OEMbL1yyYpsANL8NRklfMg6X7dOj
 oaRJnKin2AOXWtsqNOHoRt9ctBS/6g3EnNiKSjLAM1Vs0lpm0BEo0ZTy7+J9J8AF
 jUDL/q6ULpxjk+wpAXKfCJigQbq/dNZ4lkcTZdHePjznxM1B6gZLLot/qyIT8pEw
 yMouNpTpADjjjaAZdnGnb+xzzpsZ6L7Nmtwzcika6Z4=

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
