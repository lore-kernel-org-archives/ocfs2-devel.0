Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46B50C77B75
	for <ocfs2-devel@archiver.kernel.org>; Mon, 22 May 2023 16:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=AeqmTnJIzrUl+X48tHiSzBcpWbBFu8ake0xjeoCLrJ8=;
 b=uzd/EbFjY14OLZU3caD/wgT9BTQYTIagNVtA8prUZAO4nAy9uSm1D8ktDbSrIceZhu62Gl2Vzzwo
   kmGgO8AAsVipI+M84gFsB+meOCEuekwjWno97Yhhuz30bmljsaZ64svmE3y/u7Yu6u3ohctCj15H
   uN6Q5JVJ5qzsHCJONPawjwTqaaXS+c1isi8wYURh5AEasRkMD3Ka+RwQU+E3GoJQbPtugcpoL6aH
   H07NB99Vv7mq0oVdK13iaMRBaFkhrUIf2l+nNwPh1O3FsTztBRvabSX4YzlQu+tdapQOanQCByL5
   2DYtRh/YPdxtg38XPYe/hB+eNOpCzkLI5GudWg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=AeqmTnJIzrUl+X48tHiSzBcpWbBFu8ake0xjeoCLrJ8=;
 b=rC6b+wyE3wp19nsio/opQe7NnJlR5QKD8dFqJ72wUlffxsXR4yYiTf2dsxqBPSC2vxqbWZM/6mk7
   opG+i5C7Bo7nREOLgDD7Ye/jM6WmA3tHKV7YF7hLKWRxkgUypEXM7chMb7pjfPEriQFhEJmvHFVQ
   9p/6MKa0+D0DTdcXxrJoW25KHClQufi/SIZssJO4wafcy5h9IpuBI0zAl41Q9ZRenjguAXadqN+e
   nmAfMWyidfRMs+mPnM3d7UN7Z0SwKm45RbrkbB1yj3mc2Ck7waBjeCdbEMwXuDVgxg3DEtitAPAD
   eHLWm9wbP8QakZ3bmw2i0koNXHgnWGQCa3BU4w==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RV200G1OJ24AY00@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 22 May 2023 16:27:40 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
 t=1684751102;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=dK4c6jVfMYUnhpgqtCzFKqCJo27Q90EX9O3znFNrfJ8=;
 b=RUIDfgjGdB4roKiq70eIUUi4e42W+sJEtM6HEElpYci2XV8365hLC9TaGOzbzgp6oaoA3/
 mhYqHF2tnmdf1CrQvjo0TCC3Mlg9tE89h7KFtRWK214d+gsULzaVbUbmaE0kR4OgAfC1gQ
 omSr7NgcELAvIlk0N470BHg4DsVmGds=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
 s=susede2_ed25519; t=1684751102;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=dK4c6jVfMYUnhpgqtCzFKqCJo27Q90EX9O3znFNrfJ8=;
 b=Prfnr9peCZaBiM7Mx6W9w43JlGHOIAF9CKFEufQgAMYetD0nyeDCAD69Ng0HaY+NjRmp/6
 2JKKMbKSywdc96AQ==
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Mon, 22 May 2023 11:21:12 +0100
Message-id: <20230522102112.9031-1-lhenriques@suse.de>
MIME-version: 1.0
X-Source-IP: 195.135.220.29
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10717
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 clxscore=64 impostorscore=0 malwarescore=0 suspectscore=0
 adultscore=0 spamscore=0 priorityscore=30 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=826 classifier=spam adjust=0 reason=mlx scancount=1
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
X-ServerName: smtp-out2.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:195.135.220.0/27
 ip6:2001:67c:2178:6::/120 ~all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: Rgmma8RnfVcBNhe2T5HYsH64_42hyFiN
X-Proofpoint-GUID: Rgmma8RnfVcBNhe2T5HYsH64_42hyFiN
X-Mailman-Approved-At: Mon, 22 May 2023 16:27:38 +0000
Reporting-Meta:
 AAGHOl1exYgh41fKVa9/LnVA0KG9znVAEpcL1Oqw7aLQQNPGhIVuegbvW1ikWYSp
 alkWDK18/1PFV1Iu8TpPzbM+pfWFCkxvIjtmxbcwUHQRoeKluD8/71rE1ZgLRUCM
 IPN5YFAYIi4HXz8snKWrOYRvQxHpbhCTDdOZPyV1/EgOFvrXRiXbwBL6YYy5FhPl
 lueQsFReeW9bBbKuXYYibSxu5+4tvkGcPKxjNXj++EmSygHk9XjNUt/80xso0v25
 qGRO+fdNWt7MBf8JbZVlJSqoq8gpGPlaH5jSKz38ZZFb7z9gcZ6dsqMLR3qYTrfj
 KfoakpVeWtnnQcRABSLx0SZdyExSsQBMQ9m6ZJnR2alygT26wTVr9JnFN7eOTkco
 o3OwzV1toiB/C61+m0Asj3PVbOsJspMjWS5ao61j/aH4a3vXhQf57eHVb6Gy7rwu
 5ypEN+IcqqIfGXYsjxGzgadsOYjoYiQPvfWj4lJjWt4TVVljlKdHcm1jzTzPLUR0
 HqXrCfPWJnfJz7piC7Fnb8vy2svTovgfCzlKYyFAElQ=

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
