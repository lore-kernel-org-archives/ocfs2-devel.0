Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98115C7EE2E
	for <ocfs2-devel@archiver.kernel.org>; Mon, 22 May 2023 16:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=AeqmTnJIzrUl+X48tHiSzBcpWbBFu8ake0xjeoCLrJ8=;
 b=eHp3EhJURIeAqu7JSzeB1jLuiZlRd8Z5Hz3HKEtgy7KE9pdtZcV3T17ssTxkWJQgfh2HT2Rxxe/E
   K8HGKqfvO0oqw+M+BcPT8plv6IjbemjccMhbXGDJoHcx1bZLgaEOhkNj2wsmYsHc/nv8yVRL4drs
   x+L0NKVafmhX1Bstm+5ky7I2h0Xlme8p71lT1PVKOgBKH22BQlR10pLLC1yyU8y2E9lFFGAQ+5u8
   5UVl7BYdVwfwsTH8BryF32jFLxLhzbZ/7yrYz+ibeoYnnum+WjBoSLT8BpkwPK0u66BblTLnkj1Y
   ASnMfc27tHWKqqV8EU5svUSUCUil2lXhx51A8Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=AeqmTnJIzrUl+X48tHiSzBcpWbBFu8ake0xjeoCLrJ8=;
 b=JQ9DMMpDF/urS1EUhde3L7oOwTIVVekBcD1onziVM8pA8tSLI41feH96pM6+6Wwz6h/WTGnNUZuJ
   YC0gOnGItEm8F9MfxrE1pURC3XKZ9QVbNbfsu86vhWhzpCXEIe5VdmLqrpA8HfkWOq5DN5Uew36E
   ov9FNkJvXOycwVqd8Dol5zKjpWjx9uNLWMLpQLkTWktSk5kwHchtLyH5wgyp7zRT0V8V7UGX2p7d
   fTXRQn/uUX9DNz8VucdL9HebP3CC2O38mcL0ehHiMVS0bOc27hI34opFPOEsDiFvUU1aTbX7hI4h
   viDwtWe0pifdBzPrB0IK0IxyT8N9TJyxtIbIzQ==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RV200GRWJ24WQ90@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 22 May 2023 16:27:40 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
 t=1684751102;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=dK4c6jVfMYUnhpgqtCzFKqCJo27Q90EX9O3znFNrfJ8=;
 b=Bvl8LjGnDdob6XfTE0O/H11rB3dYKccwcJ6uyd1JafLCpggtrml9xk39xpSj5ItgyfMvqk
 SyYVP7qE0Tvvn3KG8D1vrmLZq24iIInCW/0TLuAbIbmBryVj/Vqn6olLR1nCesBdiXmb6G
 2COYy4tGtMqgJ6uqg713Z2FLcqbWxJg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
 s=susede2_ed25519; t=1684751102;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=dK4c6jVfMYUnhpgqtCzFKqCJo27Q90EX9O3znFNrfJ8=;
 b=A9h2RgHLuFWfdKBTk+jbIDMOJUsQzbr5CYAUmlsN7LI5ZoglaxpE8yLh4LJ1ApMCEObDHD
 pf0HpGp22yxlfuDA==
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Mon, 22 May 2023 11:20:30 +0100
Message-id: <20230522102030.8986-1-lhenriques@suse.de>
MIME-version: 1.0
X-Source-IP: 195.135.220.28
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10717
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 clxscore=73 mlxscore=0 malwarescore=0 priorityscore=78 phishscore=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=826 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
X-Proofpoint-GUID: 2622mmgYBqwwjVeeDzJteP48H4qgdknj
X-Proofpoint-ORIG-GUID: 2622mmgYBqwwjVeeDzJteP48H4qgdknj
X-Mailman-Approved-At: Mon, 22 May 2023 16:27:39 +0000
Reporting-Meta:
 AAFp10qswiJgHxnG6tlVl1IwC6nqZrnu753j6m1CkCNHywXzfkkE9WrAr/587d6j
 gsvuRMGZv/SFDPynBTx8BXrI4Dflttn+W68jMZo0cjRgIFgqt0vHAGtKyvO5XVH6
 K/m3M1CNx1J6vHEDiGcAa76WQ8ujgvBdJ+iZyQ8Y0ZftO161YmMH6G3pTO/6JJJr
 T3bTHJxfgDHU5iWsStjjtyPlg5VbM2e4QLDwE7MYnl5icwOao33+mEamEqxWlz6T
 X/mqvl4JX/6TGCKVbKU4vNBAXlEcRFn5bvYGqMtS8M8dFvL8LxeSBjIsGDfn7e6Y
 vOCxjJ/F31bruLwhfdLqYmDl+CoWVpcxlNUTTGyFM35+lL8pfZ4WMkrKByDXwIZm
 Ka7ocMC8C7rfJqBOpZFHgXzxW47+C30+H0iFs7Owcnvefu3L3ZstaQzYdPI3mM0w
 iDEDfH6mrSHqfShP4a4fgOuIUKlokGiQyiysYcr2xctmqRp99+xuqDRMLFM/UlZm
 agDsfqOT5EFbQgTlSZaqG3lNNi/u+o+7YbS4I2EI/4E6

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
