Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A53C3AA19B
	for <ocfs2-devel@lists.linux.dev>; Mon, 14 Sep 2026 07:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789371884; cv=none; b=FLutO+VhjtychTbNbZ4xIoJsdaiSxKXv0D2teB3duulJGO/iqugOi/p+dIlZsSrvgDbt0r1OiYGaxGc4VR//l5bUqPjyVIjrUMu2b7wUuu5X9edaQu2YLVHuST47hHTBVOSG4hYlCt4y1VUu2cLJfEV34JJLCBUVRO6LDv+UnFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789371884; c=relaxed/simple;
	bh=QiMHo40nbC3tF69y+eYDGMlq2bioXbNrvSEhKRtNI5A=;
	h=Date:From:To:Cc:Subject:Content-Type:MIME-Version:Message-ID; b=bgtkCfN89SecjVEQCG5ZjaDZ7RtZagxxRwMJDsNv5ZnoRgheHpy84kMfKf3LCWm99lX49KgYd58/lbZiGefGhAkplDP51a4tnp+BMdBNhFfzA59wy8RpvHlIlfdr3uya8pxU7EkD2N7JmG3BuiYFtPIx9PvUpe2Uo7fRT5Ithxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=l8HIgdSY; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="l8HIgdSY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=QiMHo40nbC3tF69y+eYDGMlq2bioXbNrvSEhKRtNI5A=; b=l
	8HIgdSYyr+erleYtLGOeUUfjThg4u25eaW+P87yJl4SFpwDklb1xvCMqQvo8u2vf
	JVDAgytQ3N6uvWstDZSafmCedk2XDO3TO6LDTwWvuq+EcO3MHyiQZFhrorBnDLwY
	eTSzPRKfrE05QQEAf2a+8FUWrLwRFBfCpCTkeXF+k8=
Date: Mon, 14 Sep 2026 15:44:04 +0800 (CST)
From: CJ <firefly0158@163.com>
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: [BUG] ocfs2: WARNING in ocfs2_journal_toggle_dirty on unmount
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20260511(2e539873) Copyright (c) 2002-2026 www.mailtech.cn 163com
X-NTES-SC: AL_Qu2TC/+cvkAv4iOeY+kdmEsTju82UcS4ufQl245Xc98Figbk+QAgeFpPNFDG1NiRKyuJkh+TdQFs6cJxc45/jpdn8I5b2wBH3vr38WBaSA==
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <6587d633.6e53.1a09edf871b.Coremail.firefly0158@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:hygvCgD3_67EpadqHx0PAA--.18418W
X-CM-SenderInfo: piluvw1o1qikqy6rljoofrz/xtbC3gQf0GqnpcTQMQAA3Y
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

SGksCgoKSSBhbSByZXBvcnRpbmcgYSBXQVJOSU5HIGluIHRoZSBvY2ZzMiBqb3VybmFsIHRlYXJk
b3duIHBhdGgsIHRyaWdnZXJlZCBieSBhCnN5emthbGxlciByZXByb2R1Y2VyIHRoYXQgbW91bnRz
IGEgY3JhZnRlZCBvY2ZzMiBpbWFnZS4gIFRoZSBpc3N1ZSBpcwpyZXByb2R1Y2libGUgd2l0aCBI
RUFEIGNvbW1pdCBjZWU5Mzk1YWNkODA0M2JlMDY0NGIyNWMzNGJmYTg2NjIzZjJiOTM1Cih2Ny4z
LXJjMSwgTGludXggNy4zLjAtcmMxKS4KCgpUaGUgcmVwcm9kdWNlciBtb3VudHMgYSBjcmFmdGVk
IG9jZnMyIGltYWdlIG9uIGEgbG9vcCBkZXZpY2UgYW5kIHRoZW4gdW5tb3VudHMKaXQuICBUaGUg
bW91bnQgc3VjY2VlZHM7IHRoZSBmYWlsdXJlIGhhcHBlbnMgZHVyaW5nIHVubW91bnQsIHdoZW4K
b2NmczJfZGlzbW91bnRfdm9sdW1lIHNodXRzIHRoZSBqb3VybmFsIGRvd24uCgoKVGhlIGNvbnNv
bGUgc2hvd3MgIldBUk5JTkc6IGZzL29jZnMyL2pvdXJuYWwuYzoxMDI5IGF0Cm9jZnMyX2pvdXJu
YWxfdG9nZ2xlX2RpcnR5KzB4MzJjLzB4M2EwIiwgcmVhY2hlZCBmcm9tCm9jZnMyX2pvdXJuYWxf
c2h1dGRvd24gYW5kIHRoZW4gb2NmczJfZGlzbW91bnRfdm9sdW1lLiAgVGhlIHdhcm5pbmcgZmly
ZXMgd2hpbGUKdGhlIHRlYXJkb3duIGlzIHRyeWluZyB0byB0b2dnbGUgdGhlIGpvdXJuYWwgZGly
dHkgZmxhZyBvbiBhIGhhbmRsZSB0aGF0IHRoZQpsb2cgaGFzIGFscmVhZHkgc3RvcHBlZC4KCgpP
biB0aGUga2VybmVsIHdoZXJlIHRoaXMgd2FzIGZpcnN0IHJlcG9ydGVkIHRoZSBzYW1lIHNpdGUg
d2FzIGEgQlVHKCkgYXQKZnMvb2NmczIvam91cm5hbC5jOjk3Mzsgb24gdjcuMy1yYzEgaXQgaXMg
cmVwb3J0ZWQgYXMgYSBXQVJOSU5HIGF0IGxpbmUgMTAyOQppbnN0ZWFkLCBzbyB0aGUgaW52YXJp
YW50IHN0aWxsIGhvbGRzIGJ1dCB0aGUgY29uc2VxdWVuY2UgaGFzIGJlZW4gZG93bmdyYWRlZC4K
QmVjYXVzZSB0aGUgZmFpbHVyZSBjbGFzcyBkaWZmZXJzIGJldHdlZW4gdGhlIHR3byByZXBvcnRz
LCBJIGFtIGRlc2NyaWJpbmcgdGhpcwphcyB0aGUgc2FtZSBpbnZhcmlhbnQgcmF0aGVyIHRoYW4g
Y2xhaW1pbmcgYSBieXRlLWZvci1ieXRlIGlkZW50aWNhbCBzcGxhdC4KT25lIHBvc3NpYmxlIGNh
dXNlIGlzIHRoYXQgdGhlIGNyYWZ0ZWQgaW1hZ2UgbGVhdmVzIHRoZSBvbi1kaXNrIGpvdXJuYWwK
c3VwZXJibG9jayBzdGF0ZSBpbmNvbnNpc3RlbnQgd2l0aCB0aGUgaW4tbWVtb3J5IGpvdXJuYWws
IHNvIHRoZSB0b2dnbGUgaXMKYXR0ZW1wdGVkIGFmdGVyIHRoZSBqb3VybmFsIGhhcyBiZWVuIG1h
cmtlZCBzdG9wcGVkLiAgSSBhbSByZXBvcnRpbmcgdGhlCnJlcHJvZHVjdGlvbjsgaWYgdGhlIGRv
d25ncmFkZWQgd2FybmluZyBpcyB0aGUgaW50ZW5kZWQgb3V0Y29tZSBmb3IgYSBjb3JydXB0Cmlt
YWdlLCBwbGVhc2UgZGlzcmVnYXJkIHRoaXMuCgoKVGhpcyBhcHBlYXJzIHRvIGJlIGEgcmVjdXJy
ZW5jZSBvZiB0aGUgc3l6Ym90IGlzc3VlIHdob3NlIGV4dGVybmFsIGlkIGlzCjNhYmEzNWY4MDk3
MGM2ZTUzNmIyLiAgSXQgcmVtYWlucyByZXByb2R1Y2libGUgb24gdjcuMy1yYzEuCgoKUmVwcm9k
dWNlcjoKCgpzeXogcmVwcm9kdWNlcjogaHR0cHM6Ly9wYXN0ZWJpbi5jb20vcmF3L1pldjNQcjZa
CmNvbnNvbGUgb3V0cHV0OiBodHRwczovL3Bhc3RlYmluLmNvbS9yYXcvakVETG00UGoKa2VybmVs
IGNvbmZpZzogaHR0cHM6Ly9wYXN0ZWJpbi5jb20vcmF3L0d2Q0tyaGpaCgoKS2VybmVsOgoKCkhF
QUQgY29tbWl0OiBjZWU5Mzk1YWNkODA0M2JlMDY0NGIyNWMzNGJmYTg2NjIzZjJiOTM1CmdpdCB0
cmVlOiB1cHN0cmVhbSAobGludXguZ2l0KSwgdGVzdGVkIHRocm91Z2ggdGhlIHY3LjMtcmMxIGFu
bm90YXRlZCB0YWcgb2JqZWN0CsKgIMKgIMKgIMKgIMKgIMKgZTVlMDQ3MjZjZGQwNDNlMzA5Njc3
MDcxYWIxYjY1YTRiMThmNDIyYgprZXJuZWwgdmVyc2lvbjogNy4zLjAtcmMxICMxIFBSRUVNUFQo
ZnVsbCkKdGVzdGVkIHRhZzogdjcuMy1yYzEgKExpbnV4IDcuMy1yYzEsIDIwMjYtMDgtMzApCgoK
TGV0IG1lIGtub3cgaWYgeW91IG5lZWQgbW9yZSBkZXRhaWxzIG9yIHRlc3RpbmcuCgoKQmVzdCBy
ZWdhcmRzLApDaGFuZ2ppYW4KCgoK
