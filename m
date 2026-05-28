Received: from forward500a.mail.yandex.net (forward500a.mail.yandex.net [178.154.239.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56363BED23
	for <ocfs2-devel@lists.linux.dev>; Thu, 28 May 2026 14:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779979404; cv=none; b=EZaBd3yrrcmHzukOQq1ZJuEXjRDQZ5ocebRDHXq2ECmAlHzrVflFa3esFL6H2AB1LGKyir5bK2NRbLyNLtAHck7NrfrSqqghuOYzofAJvnOIqdWhJIWCEkGXEUbUkxX2Uz3Re+LwBVQI/1pmODYsph2GxNmmfoqKq/y/EveZI/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779979404; c=relaxed/simple;
	bh=nX7X5tL1FjCr3X7ZqZOz8DLinIJrC9StNoUZ2qXeifc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Tdd9RNeLif+6pKYY62T+P7ooGQS2rjWlgjA5yiPxA/Eoz2Z068ozhVxbO1XXh6bcR17gkYZvURKRhfs1fgwYSjmBHDcBXzSd+fEvHsdzTXdmRCl1oCc5qLTH5ahDgJEegwd/G/aAMqPQl9Hgs2KOyXgyerM2ZiGYIt6laSb2M0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=XzNpGjD5; arc=none smtp.client-ip=178.154.239.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="XzNpGjD5"
Received: from mail-nwsmtp-smtp-production-main-72.iva.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-72.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:8c98:0:640:a7fd:0])
	by forward500a.mail.yandex.net (Yandex) with ESMTPS id B7C23C1884;
	Thu, 28 May 2026 17:43:11 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-72.iva.yp-c.yandex.net (smtp) with ESMTPSA id 9hbn9dFfhuQ0-tsBmhNuN;
	Thu, 28 May 2026 17:43:11 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1779979391; bh=gcwLubaLNw5xagnRhDizA4slvBOGbdXhEF9FtmYXRzw=;
	h=References:Date:In-Reply-To:Cc:To:From:Subject:Message-ID;
	b=XzNpGjD5HMhLJEVtkXniFEr5Z/ysuAom1LDXf5bqimF4kNrqI131yE8DL3qXlKJKw
	 Xhg2ObNPvR7M/3iMJMXmAzFmX8q72c6xwddtaKbgkUu6hjplXofmCvJ5pexFTxSqbF
	 wUBM/pQJWMJjz9CUryJelNhLRo5v2FZlNIqPyhSk=
Authentication-Results: mail-nwsmtp-smtp-production-main-72.iva.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <e2032b0aeb857bc8f0c73bbd85a7917d94fd9005.camel@yandex.ru>
Subject: Re: On
 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=775c17386a6fd
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>, Mark Fasheh
	 <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
Date: Thu, 28 May 2026 17:42:39 +0300
In-Reply-To: <db59e9fd-e7e0-4cd0-9dd6-a462e8c21676@linux.alibaba.com>
References: <979042b0a8e9a70189c9195c81dfb9fa26f789ef.camel@yandex.ru>
	 <66faed08-ed79-42ba-a605-3ec8465c89ca@linux.alibaba.com>
	 <dd77ed3f10fafc5b9e412eeecb568bc03129051b.camel@yandex.ru>
	 <db59e9fd-e7e0-4cd0-9dd6-a462e8c21676@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 (3.60.1-1.fc44) 
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2026-05-27 at 15:52 +0800, Joseph Qi wrote:

> ocfs2_validate_dx_root() returns -EROFS
> ocfs2_read_blocks() goto read_failure =E2=86=92 put_bh, bhs[0]=3DNULL, re=
turn -EROFS
> ocfs2_read_block() returns -EROFS
> ocfs2_read_dx_root() returns -EROFS
> ocfs2_find_entry_dx() goto out, returns -EROFS
>=20
> On a second read of the same block, ocfs2_buffer_uptodate(ci, bh)
> returns false (block was never added to the ocfs2 metadata cache because
> the first read failed), so the block is re-read from disk and
> re-validated =E2=80=94 failing again.
>=20
> Am I missing something?

It seems that I've got the point. In ocfs2_read_blocks(), it's wrong
to assume that non-NULL BH returned by sb_getblk() is exclusively
owned by the caller and so put_bh() always drops b_count from 1 to 0.
If it is not so, BH remains on hold and likely to be returned by the
next call to sb_getblk() unchanged - that is, with BH_Uptodate bit set
even if it has failed validation previously. So BH_Uptodate should be
cleared immediately after validate() callback has detected some data
inconsistency, regardless of what may happens next with that BH:

diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index 701d27d908d4..6114299b121e 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -350,8 +350,6 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u6=
4 block, int nr,
 						wait_on_buffer(bh);
 					put_bh(bh);
 					bhs[i] =3D NULL;
-				} else if (bh && buffer_uptodate(bh)) {
-					clear_buffer_uptodate(bh);
 				}
 				continue;
 			}
@@ -380,8 +378,11 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u=
64 block, int nr,
 				BUG_ON(buffer_jbd(bh));
 				clear_buffer_needs_validate(bh);
 				status =3D validate(sb, bh);
-				if (status)
+				if (status) {
+					if (buffer_uptodate(bh))
+						clear_buffer_uptodate(bh);
 					goto read_failure;
+				}
 			}
 		}
=20
Dmitry
