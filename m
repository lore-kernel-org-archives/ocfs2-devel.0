Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25723750CD
	for <ocfs2-devel@lists.linux.dev>; Tue,  3 Mar 2026 02:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772504911; cv=pass; b=lC5yULmGtqUt9NCAlA8z09RpOuTlIr8xKzWhJcqGEPrK/ss5Lpj+357eHG9CfBqc/7T11e4LKO8Cs+1iAXACglOz4v4BwKMet/cKctNqbWruKacyBkORNUnrQEweHRV7v9urr5uo3qhU/6E6YRCQ0x/UKOEaBGhOPxL+rDuSJYg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772504911; c=relaxed/simple;
	bh=CmpPLTDLjoziZGQueGxnmQI7O2xObKPRhPekUhrY70I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FWV0jSjvhVMe72veqT0ymUUCpe9BXnYJPO6aAPaRfbEyyptJTdey6ul8kKmjfhAKSzISXbtsZjZzH6WTuKsdVo7e8rVIDYEe0yvx3wK9gL74mMvHSLgUgjyMyuhCMS8snI3hRSJBqgbs/l5Vu5a/NyQ7437AMjtvnIXXjs+Rz68=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=NQ/tr48s; arc=pass smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="NQ/tr48s"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-35990245493so968939a91.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 02 Mar 2026 18:28:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772504909; cv=none;
        d=google.com; s=arc-20240605;
        b=kao/zWdUR8crgmqDaTYxaHWHRe7dGOWzFJD+n1D/9JIw/iHs0BpT7uJOonaJs75rWD
         n7DeUIjIjAH1EB6qFB835Mz+auc5XD+btVk+JC3LM/SyRs+Qykv+7EkKaBbRShbj6nGV
         vb1pUsq1AFbu32n/BmZmRNxIX5fudJz9F5WFuI/EYjgLiZbgYlbi5/sXVDvfwSUVGrmE
         cNKlQHeCQvD9EMT87JNiWIrXlbcRolxRaX6TuLYc4hTcwpJSdMUFrFf+bFY6rXjSI0PT
         s4OkOOfcgwwmoi0MLi2t3t8TMh0X3oasa40qTLL605fb3F3GKeF8bGCbk/h30StPe3lp
         AOfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=C1bg6xiI4y6+7k2tjKhPvGRGK3TFDQKnfwBJ+EjIYKA=;
        fh=sLdp8jcxOH+i3PqheQTBihnCntqyeRJRpQap8wC62Us=;
        b=BzMjWBTB1qso/6ZDUvbBYzXEVpUbVTevOSXkPWAre6EXRJ4gPmOH4jxKU2GVulNuyf
         mPHDBv5i7mnJSOMBJ7H0y54F7hgvKkPpTOQPwKXvIgCnKXiK/4mZ29QxgkHgVtgj5Q+V
         pirg6cm71oWCBtTlm1aXbKQUGsADD2zr5sX6HG2tF2X4UK9HGyVjWvdx7KvpgUCkn5MX
         BcCjkgjxRxIc+VGXTuV2lpD3DYiQcWdtws0zstDGWPJLp+6pkb/bGDjEl1ALsOg3qOzV
         TaXU0VcPVcwjxJY1a3+Wzm007UufnGlRkYsv2bk4YWIW1dHJq4jNdUhDZqAUSuEUqVyI
         7yKw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1772504909; x=1773109709; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C1bg6xiI4y6+7k2tjKhPvGRGK3TFDQKnfwBJ+EjIYKA=;
        b=NQ/tr48sJ+m2o5jcGhgvlRuFY8k21269ikWTle7tUnB9GPFxykpO2zAB+xcEfoHL/t
         wCz43zqn2gDMgEsZ/mc98F4Ltsd72IkrsoWIyQ4sxBAEV7o70DFQMRS05dvfNuJLa5Ll
         dPlBbM7xI+jPgJp9HaIk/gxqLDVLYMP5tb1jQcLG5EahbizYVqzR09jcUopiWsg4204m
         T4mwPzpHjols2IpwMzTE1IDu0FL1TkF1osChYY1qg+l2MYVFEqy1c8PoIfIPlljTKFZT
         m+SU0fKR0KiVUTLCCw8JOJFXerm/HteDJz7igoNW1ZcMOAMr7QgXqSq5skMH6ENixcXv
         jIuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772504909; x=1773109709;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=C1bg6xiI4y6+7k2tjKhPvGRGK3TFDQKnfwBJ+EjIYKA=;
        b=xIpLdXuCi/rU4vrT1jWhZAaKw4Z6MXPptlq3ZAWCu/Uh4/r/lZcR545TNOx243GPVc
         YQC0hTivyKk1tqEyy3/2QALTle+2WDi+T9d8aIviUedMrZI4MVzpPGJlZLqkKYJjap4G
         iud4GfnGsXBYq+q0YhP8tDubTXVJcv32tmNiioY0f2gDfS2SAOlww1eTcukfhdytzHMx
         ivBUSlhu6F2Q0OsgzHjBgBNI4ZVyL5ecU6C56P4+qeqOEDSVISzKhRJlhRAOg7062a3Z
         EXIkn4lwA/H44iK3vGLAn6E+urIuLYh3OYlUDuTrbX/UUfo/WNvZy0AXKjVNqthj+i7a
         Uy+w==
X-Forwarded-Encrypted: i=1; AJvYcCXG0y8mf5tOOc7J91hV+AWRq/Y0XGH/zJGDRAJRxCPxhApggXvyFCDI7LKHNcdWbWSC0/u6kHvXGhDvLA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw+/yUGGH+RGAxAnMsiPKKyWaYSIybnJoTDGXBmpzLcOLsRFEfJ
	JnI/pQvxB22ebziCkvPLPW1SjZ5bRmTzx0uYDlN0JzqGrmCqJkOr48m7aGvsDpWRbdQkxMt8yoR
	9xPboOf3pSzz773KDiF+3bjh5RN/yFgh5SMJfyi8l
X-Gm-Gg: ATEYQzxtXzpdqFrdFPZfaVikBvqCUXPnXW96v2fYnrZ1IWSX8STvg1SGimC6LTrT9Ng
	ZNkGDmIsesNeh69MaATvv3/ZxYbwYD+fyszSGQaWox0bEZ/2qUq8w0DdTENSIxb8rCdDoHWLhor
	E5gr+E2P/h/B1siT+Ex45o0g+1q/SIgGzGx9Jueixpr3dkfaEfP20xIZEXr/0Bx2LeLyB1OYbo2
	mQf9Zpy0/ehdUjGuvUBT423unoNVTwZd+HGIDmZaAKQO2Mpna2QhEWhAxBahWFbV+YfK3INQLdg
	I3rW9Sw=
X-Received: by 2002:a17:90a:7f93:b0:356:1db4:8fe5 with SMTP id
 98e67ed59e1d1-35965cc714fmr9453563a91.29.1772504909127; Mon, 02 Mar 2026
 18:28:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org> <20260302-iino-u64-v2-49-e5388800dae0@kernel.org>
In-Reply-To: <20260302-iino-u64-v2-49-e5388800dae0@kernel.org>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 2 Mar 2026 21:28:17 -0500
X-Gm-Features: AaiRm53ToDAKLnqMzF7h_Rr5obeE3dnKPI4TQkaY52RSs5vb8oGyabc3Zmeif9I
Message-ID: <CAHC9VhRLAhMYL1ax3+LCeLLhnK0XGnvs0kGPGgHaptTaDynroA@mail.gmail.com>
Subject: Re: [PATCH v2 049/110] security: use PRIino format for i_ino
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Dan Williams <dan.j.williams@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Eric Biggers <ebiggers@kernel.org>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	David Howells <dhowells@redhat.com>, Paulo Alcantara <pc@manguebit.org>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Steve French <sfrench@samba.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>, 
	Alexander Aring <alex.aring@gmail.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Eric Van Hensbergen <ericvh@kernel.org>, 
	Latchesar Ionkov <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>, 
	Christian Schoenebeck <linux_oss@crudebyte.com>, David Sterba <dsterba@suse.com>, 
	Marc Dionne <marc.dionne@auristor.com>, Ian Kent <raven@themaw.net>, 
	Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, Ilya Dryomov <idryomov@gmail.com>, 
	Alex Markuze <amarkuze@redhat.com>, Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, 
	Nicolas Pitre <nico@fluxnic.net>, Tyler Hicks <code@tyhicks.com>, Amir Goldstein <amir73il@gmail.com>, 
	Christoph Hellwig <hch@infradead.org>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Yangtao Li <frank.li@vivo.com>, 
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, David Woodhouse <dwmw2@infradead.org>, 
	Richard Weinberger <richard@nod.at>, Dave Kleikamp <shaggy@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Anders Larsen <al@alarsen.net>, 
	Zhihao Cheng <chengzhihao1@huawei.com>, Damien Le Moal <dlemoal@kernel.org>, 
	Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, 
	John Johansen <john.johansen@canonical.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Roberto Sassu <roberto.sassu@huawei.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
	Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	Casey Schaufler <casey@schaufler-ca.com>, Alex Deucher <alexander.deucher@amd.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Eric Dumazet <edumazet@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	Martin Schiller <ms@dev.tdt.de>, Eric Paris <eparis@redhat.com>, Joerg Reuter <jreuter@yaina.de>, 
	Marcel Holtmann <marcel@holtmann.org>, Johan Hedberg <johan.hedberg@gmail.com>, 
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>, Oliver Hartkopp <socketcan@hartkopp.net>, 
	Marc Kleine-Budde <mkl@pengutronix.de>, David Ahern <dsahern@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Steffen Klassert <steffen.klassert@secunet.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Remi Denis-Courmont <courmisch@gmail.com>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Xin Long <lucien.xin@gmail.com>, 
	Magnus Karlsson <magnus.karlsson@intel.com>, 
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>, Stanislav Fomichev <sdf@fomichev.me>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	fsverity@lists.linux.dev, linux-mm@kvack.org, netfs@lists.linux.dev, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-nilfs@vger.kernel.org, 
	v9fs@lists.linux.dev, linux-afs@lists.infradead.org, autofs@vger.kernel.org, 
	ceph-devel@vger.kernel.org, codalist@coda.cs.cmu.edu, 
	ecryptfs@vger.kernel.org, linux-mtd@lists.infradead.org, 
	jfs-discussion@lists.sourceforge.net, ntfs3@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, devel@lists.orangefs.org, 
	linux-unionfs@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, 
	selinux@vger.kernel.org, amd-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
	linaro-mm-sig@lists.linaro.org, netdev@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-hams@vger.kernel.org, 
	linux-x25@vger.kernel.org, audit@vger.kernel.org, 
	linux-bluetooth@vger.kernel.org, linux-can@vger.kernel.org, 
	linux-sctp@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 2, 2026 at 3:36=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wro=
te:
>
> Convert security i_ino format strings to use the PRIino format
> macro in preparation for the widening of i_ino via kino_t.
>
> Also correct signed format specifiers to unsigned, since inode
> numbers are unsigned values.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  security/apparmor/apparmorfs.c       |  4 ++--
>  security/integrity/integrity_audit.c |  2 +-
>  security/ipe/audit.c                 |  2 +-
>  security/lsm_audit.c                 | 10 +++++-----
>  security/selinux/hooks.c             | 10 +++++-----
>  security/smack/smack_lsm.c           | 12 ++++++------
>  6 files changed, 20 insertions(+), 20 deletions(-)

No comment on the PRIino specifier, but the LSM framework and SELinux
changes seem complete.

Acked-by: Paul Moore <paul@paul-moore.com> (LSM/SELinux)

--=20
paul-moore.com
