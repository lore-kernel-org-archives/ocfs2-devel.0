Received: from tarta.nabijaczleweli.xyz (tarta.nabijaczleweli.xyz [139.28.40.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26E02F85DC
	for <ocfs2-devel@lists.linux.dev>; Thu,  3 Jul 2025 18:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.28.40.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751566891; cv=none; b=j05iO2qXYr6/bUvaBemny4SNqCvVCfzGzTzuOyhPjn5973wr/7QP/+mVrAsL/EbK2nZzvIrrNlDGuO06pBdpffn3/xKkB22BCjGMdScFz/YENH/CkhcnUWvOjoKMV2xGIy16IKGgahvHDNi9eqncoLQvE806pLcxeMu2vSImhtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751566891; c=relaxed/simple;
	bh=iNgJ1c1N+p8hzYxh9DMoKTuXLNIRUisQ0c5h97Jk1jE=;
	h=Date:From:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=hkl6Mf8uGClgOfdw9Y8GWY7VkmSQg38DePkdflkBkpKPqPfE+ud8c1RVk+wNkE0H51gtlleZSkxviGvAc4F09wCStTqkUgxbNWhapWEbmZpZEa1Ik/Udq/2v0N4f6BPRtoTE8DQAk2SKyzjPN3G8fWHyq117UHOI1T4kGI+LS38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nabijaczleweli.xyz; spf=pass smtp.mailfrom=nabijaczleweli.xyz; dkim=pass (2048-bit key) header.d=nabijaczleweli.xyz header.i=@nabijaczleweli.xyz header.b=T8Ry0BPA; arc=none smtp.client-ip=139.28.40.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nabijaczleweli.xyz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabijaczleweli.xyz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabijaczleweli.xyz header.i=@nabijaczleweli.xyz header.b="T8Ry0BPA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nabijaczleweli.xyz;
	s=202505; t=1751566887;
	bh=iNgJ1c1N+p8hzYxh9DMoKTuXLNIRUisQ0c5h97Jk1jE=;
	h=Date:From:Cc:Subject:From;
	b=T8Ry0BPARMg5MsjZsLPy9Nplgp5zGclU5WpEwf+Q7kL1rasZZp54KKhDvIrYKMTYo
	 8a4b0lOKp9HO1XpG7sF87PcSLfWYIkxUrly120cikOVlFOHhlmUGvtSJ/nUkIaGsWj
	 OI5cf7cghzrv8aF/aHm002mzV+JLVUvUPnmo/4KV8by38grIjsAs96sE06OaZTiZ5X
	 tHbLR98WvwaV5XivVHduw2Yf12+8gqt7A2v2qZYolKQvsianQFqDMaVtcpTUB9D/ZG
	 14nMsZUafPi/EKCpZCokDWAEgL/B4Cn+dP6vETxLw0SQU3PGyWrp3tefZZFbfNePLO
	 6xdktHlCkSUHA==
Received: from tarta.nabijaczleweli.xyz (unknown [192.168.1.250])
	by tarta.nabijaczleweli.xyz (Postfix) with ESMTPSA id E50C843A;
	Thu,  3 Jul 2025 20:21:27 +0200 (CEST)
Date: Thu, 3 Jul 2025 20:21:27 +0200
From: 
	Ahelenia =?utf-8?Q?Ziemia=C5=84ska?= <nabijaczleweli@nabijaczleweli.xyz>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: [PATCH v2] ocfs2/dlm: fix "take a while" typo
Message-ID: <a2ofgf5pl4wtlavirjzliau6dfldycztufaerjah5dqtca266k@tarta.nabijaczleweli.xyz>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="axct5epngspydsxa"
Content-Disposition: inline
User-Agent: NeoMutt/20231221-2-4202cf-dirty


--axct5epngspydsxa
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Signed-off-by: Ahelenia Ziemia=C5=84ska <nabijaczleweli@nabijaczleweli.xyz>
---
v1: https://lore.kernel.org/lkml/h2ieddqja5jfrnuh3mvlxt6njrvp352t5rfzp2cvnr=
ufop6tch@tarta.nabijaczleweli.xyz/t/#u

 fs/ocfs2/dlm/dlmrecovery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 67fc62a49a76..00f52812dbb0 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -2632,7 +2632,7 @@ static int dlm_pick_recovery_master(struct dlm_ctxt *=
dlm)
 					 dlm_reco_master_ready(dlm),
 					 msecs_to_jiffies(1000));
 		if (!dlm_reco_master_ready(dlm)) {
-			mlog(0, "%s: reco master taking awhile\n",
+			mlog(0, "%s: reco master taking a while\n",
 			     dlm->name);
 			goto again;
 		}
--=20
2.39.5

--axct5epngspydsxa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfWlHToQCjFzAxEFjvP0LAY0mWPEFAmhmyicACgkQvP0LAY0m
WPFZ2A//TINMRJzTGkZBWEjwXeKBhnAbmXtWUFUOC8gPR8epQEoI8Q3D04Az+KnU
tEJghkTnN8jfaRNfZPKI/FWFT+yxOWHzxrb5PTEyMANtzvMErc1AGNRKYefWIkgm
40SnxYfWeklKcTuokOeomoRGsh3f41nE1bkomtBMyhyt5w5/y4oh0wNqmdmDoll6
SvnS5cbAhGbEU7a4quFjNoV+o5lnYCiz+ndSZ/2Udf/rBXaexZUosC8dAugKGKde
9WkXeKT9ZZRlFlEfgT8S4HIKgTxqM2383FFWgI8/BpBp/ZF9MLDRxXLIXtEkXhDY
A7cNtM/bES3x4mqOo7XCl6qr/sx0umrT3PWZzS+pM1271fpU9vVe8tHJbYAFjhj4
f9IJZfrfo9N9lYyMtM4Cc7lHBgnNAeeZ2mfiaYUu1xt5B9RKR6zNlWzoFRan/dHw
QjUvF8DPiWaSJRN3yuiXBlTAqoCJEkLYxPCgnZN4mQMB5Q57limmRDyxmHDePtLX
eJmrlFhv0x56AdkE2248RFAVt3mqd0M8IYtAwZUJAtj0MZ/N6exsQDPDL9ZK6RN2
LVSv1ByrvyX8D6DmWeo9S1EUXk5oOig9G4I6smL0Ay44Wxuib8zfrCPMZPrTv3dI
GYckDvJGeBjou0dPlutkeNSlAC/TXNkrZXo+4YaGr0XCAiwKZnM=
=W94E
-----END PGP SIGNATURE-----

--axct5epngspydsxa--
