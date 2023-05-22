Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1857C7EE30
	for <ocfs2-devel@archiver.kernel.org>; Mon, 22 May 2023 16:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=AeqmTnJIzrUl+X48tHiSzBcpWbBFu8ake0xjeoCLrJ8=;
 b=ZtEyWIuOTUkM3uO1NIZz55vCqbOvzP8itU8jnqj+FSVT6EoJudsjmAuVdl5zah3hmwfRWmkX73xf
   rRg34UIg0j2F2qUlzDGSs7zD3TC8/f8jRvr7mKbIjJSycmUmFt5xrcNI/Y0b/Mhek+IFJAusV6JS
   O0seCTbUIZKwsTGAEJbrZZkbvjiDEd5FfDp8Gypj1RkK0vRW0lXTq6teKyOFbVqDlSMj4vSGyS0T
   RxO6szZz0YeOpzDWTzW3r76tRAs8KnUNsHFHgXqgKo0OBok6qHD1rPyKvE+oAKSqt+IBEdv6QDjK
   ogJI0fiMGEzmw7ai85T3L7vSUGtjJP6cHSFkXg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=AeqmTnJIzrUl+X48tHiSzBcpWbBFu8ake0xjeoCLrJ8=;
 b=khn/mpw3uiZMzW76ntV4hE9ftg6gY98pu3DhGnhLBhTiH5pN3NI4pLQ24txdCnYZ2b69eLh/hChN
   8GfwpiXTO7YwRwX7sFsNKvlu25HiFqHqU4ZxzAUrf7aLcBDpLnxtnTe5X1LSJclEnvHVoi7xF0O9
   lQRfiFDgtnTrTOsrGx61oZJW21WPREAnND0LQmj2ODRqlPd5tlI9f51d0G8UeSAKLW5/C6hLtVJz
   Ku+CjCBQu6zmakXpd1rHpvlNfImrjC7rQFunJn8CXvJrf1oNjnFHJQv8hsGOn5uf0b6suL5wH2WK
   26C93y501WJX7KCm237ihIU+AnzUMcvppWz1dA==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RV200GSIJ24WQ90@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 22 May 2023 16:27:40 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
 t=1684751109;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=dK4c6jVfMYUnhpgqtCzFKqCJo27Q90EX9O3znFNrfJ8=;
 b=wEBufNxlikTs6keMhFbzLqyvC+LK1HS76vxpZ2H8ggbtYTxUhfzHxMS0mzrxESky9yqZb2
 Q5CvaAUuYK7zjXE/J7JpbYT/Gxy7KBiR0LHD+YKr4MIPhHgYlhpoaxa2vPPfEXI2uCPGry
 fevet/40ohb/eWLtuAcYffVLgr/tLOE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
 s=susede2_ed25519; t=1684751109;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=dK4c6jVfMYUnhpgqtCzFKqCJo27Q90EX9O3znFNrfJ8=;
 b=+uD1Et6uHQ5IseYpE/pB3y5xzjN5jILiOJghc5Ccw1zTevgYKlW5ZAk9UMChPLLo2HhIH/
 90Sl0h6U0Z9vHZBQ==
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Mon, 22 May 2023 11:25:06 +0100
Message-id: <20230522102506.9205-1-lhenriques@suse.de>
MIME-version: 1.0
X-Source-IP: 195.135.220.28
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10717
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 mlxlogscore=826 suspectscore=0 priorityscore=90 lowpriorityscore=0 clxscore=65
 malwarescore=0 mlxscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305220088
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix use-after-free when unmounting
	read-only filesystem
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
From: =?UTF-8?q?Lu=C3=ADs=20Henriques?= via Ocfs2-devel
 <ocfs2-devel@oss.oracle.com>
Reply-to: =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: base64
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: smtp-out1.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:195.135.220.0/27
 ip6:2001:67c:2178:6::/120 ~all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: ycQ6ikMpdtMunWQunAEZHTsvyEME1p7S
X-Proofpoint-GUID: ycQ6ikMpdtMunWQunAEZHTsvyEME1p7S
X-Mailman-Approved-At: Mon, 22 May 2023 16:27:39 +0000
Reporting-Meta:
 AAFgYGu87AHz3u15KOOp/DPy7dFbegP5rHfvXADYoIrbQkcgm+vYDObgVVqmM8ql
 D0nkEzwGgssAbbJ2eUR2FLWAZbAeFuyBEIvZYZs58JkSeIcgLiB69GAn+qHAwXUx
 Elo7yffBNaBIDADOmBF9Bi/GjUzOgVcSy0hfCvV9Uc6Wnh7nQnmQWxNgwEXoPbb7
 BmdOlOfk+S0m0Y7cxV7rUtiCfEdBsm6Cemq7y4x586kt2JKfQt53oPsAeEUrEFiv
 OCINc4yjgBKXCC4HwwCKqoLfyL83Yu1Pi/dDSBDfZwHknQPRLvM+fFWHp2mhsCO1
 UI7muU8I8IDxu6eeZOYWg3zDRIjg7uyWRTDGUdbymopkUlbIwQ/4WZwfBfWeGb0G
 69PV46Q8mLeRqGyM4UkRG0etO7CnGN+aXFfHYevmreg5usg7LXNrVu3niIWTRxjR
 R9h6Q0cJ0dP0k1r8f05XhQ1K7/uieBYhCTa7C6K92HFxxAiZ7MZ0t24vZJdMa7Ks
 zOOQYmJBrgPPp5spSyBAlWjWtuZ4gmXXA+gEox1sNSCe

SXQncyB0cml2aWFsIHRvIHRyaWdnZXIgYSB1c2UtYWZ0ZXItZnJlZSBidWcgaW4gdGhlIG9jZnMy
IHF1b3RhcyBjb2RlIHVzaW5nCmZzdGVzdCBnZW5lcmljLzQ1Mi4gIEFmdGVyIG1vdW50aW5nIGEg
ZmlsZXN5c3RlbSBhcyByZWFkLW9ubHksIHF1b3RhcyBhcmUKc3VzcGVuZGVkIGFuZCBvY2ZzMl9t
ZW1fZHFpbmZvIGlzIGZyZWVkIHRocm91Z2ggLT5vY2ZzMl9sb2NhbF9mcmVlX2luZm8oKS4gIFdo
ZW4KdW5tb3VudGluZyB0aGUgZmlsZXN5c3RlbSwgYW4gVUFGIGFjY2VzcyB0byB0aGUgb2luZm8g
d2lsbCBldmVudHVhbGx5IGNhdXNlIGEKY3Jhc2guCgpDYzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5v
cmc+ClNpZ25lZC1vZmYtYnk6IEx1w61zIEhlbnJpcXVlcyA8bGhlbnJpcXVlc0BzdXNlLmRlPgot
LS0KIGZzL29jZnMyL3N1cGVyLmMgfCA2ICsrKystLQogMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0
aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9vY2ZzMi9zdXBlci5jIGIv
ZnMvb2NmczIvc3VwZXIuYwppbmRleCAwYjBlNmExMzIxMDEuLjk4OGQxYzA3Njg2MSAxMDA2NDQK
LS0tIGEvZnMvb2NmczIvc3VwZXIuYworKysgYi9mcy9vY2ZzMi9zdXBlci5jCkBAIC05NTIsOCAr
OTUyLDEwIEBAIHN0YXRpYyB2b2lkIG9jZnMyX2Rpc2FibGVfcXVvdGFzKHN0cnVjdCBvY2ZzMl9z
dXBlciAqb3NiKQogCWZvciAodHlwZSA9IDA7IHR5cGUgPCBPQ0ZTMl9NQVhRVU9UQVM7IHR5cGUr
KykgewogCQlpZiAoIXNiX2hhc19xdW90YV9sb2FkZWQoc2IsIHR5cGUpKQogCQkJY29udGludWU7
Ci0JCW9pbmZvID0gc2JfZHFpbmZvKHNiLCB0eXBlKS0+ZHFpX3ByaXY7Ci0JCWNhbmNlbF9kZWxh
eWVkX3dvcmtfc3luYygmb2luZm8tPmRxaV9zeW5jX3dvcmspOworCQlpZiAoIXNiX2hhc19xdW90
YV9zdXNwZW5kZWQoc2IsIHR5cGUpKSB7CisJCQlvaW5mbyA9IHNiX2RxaW5mbyhzYiwgdHlwZSkt
PmRxaV9wcml2OworCQkJY2FuY2VsX2RlbGF5ZWRfd29ya19zeW5jKCZvaW5mby0+ZHFpX3N5bmNf
d29yayk7CisJCX0KIAkJaW5vZGUgPSBpZ3JhYihzYi0+c19kcXVvdC5maWxlc1t0eXBlXSk7CiAJ
CS8qIFR1cm4gb2ZmIHF1b3Rhcy4gVGhpcyB3aWxsIHJlbW92ZSBhbGwgZHF1b3Qgc3RydWN0dXJl
cyBmcm9tCiAJCSAqIG1lbW9yeSBhbmQgc28gdGhleSB3aWxsIGJlIGF1dG9tYXRpY2FsbHkgc3lu
Y2VkIHRvIGdsb2JhbAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0Ck9jZnMyLWRldmVsQG9zcy5vcmFjbGUuY29t
Cmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9saXN0aW5mby9vY2ZzMi1kZXZlbA==
