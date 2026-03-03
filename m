Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D55C375F64
	for <ocfs2-devel@lists.linux.dev>; Tue,  3 Mar 2026 02:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772505028; cv=pass; b=R+oeQwtY9aUTuv0YJrfYuqBsPgFPvpBVs2hNF05Sq8cHiw3EdM5PSK+4qkFMRDMjHf8BFpUwOsKpOEKH4nhk1IILZRDOzXpcXFTOH9Q3IZ0TdW/LKn+q9Yea8XAljUh3yjNT0gh7N46BQlPXpn4oTV8cP5s+ndVQqFF6ZAh1jLY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772505028; c=relaxed/simple;
	bh=dpQSmzkUM5eywQT8MkIz9dqIAPHwbz822026FlJmJ4U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QAlsa1SQfZbSvf2s4qzVxjXel8mP5EThZm+lE1OurGPCbjLepii67d4ikLWuQJyeJ7N1hXpnoEUNioo5XliDrh7JlDQV/Qw5jFkhSYBnLvTa5pyGEStnBpYAvrDp78g52hnbMcNlWKG2rjsELnzukcvnDO4duV1EojdYcsqay7U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=Y20eewbt; arc=pass smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="Y20eewbt"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2a871daa98fso39754855ad.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 02 Mar 2026 18:30:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772505024; cv=none;
        d=google.com; s=arc-20240605;
        b=FzIMtTNT6/2G8bqOqTWqZQV1F3PqQfOknIK7uB/NgA8mkqUjDmBaK81v6W+eIY5Loq
         KJ1Hr4C8URLeX/eYiVh+A8fQK7osfndz1SyI/f0ssaVobavpbm3e/FlYO7+Q7E5kBe+p
         0mGUlgGHxrmckqjBEjDs6l1E7lw4JBoFT225TPxY56ipLgC38puM4UnNEkIef5flQi5q
         8KFc+Keuau7hAc1dQ0dS3lS5LGNhIyQnZfZ9GWQTh86Cdi+6QS4dMtegVcBJOsJT/WMf
         iouI6/Fz+HzOwSyn+R3TCBpHGQNja1BHxQkRbOEF69HVgS1Nv4bsCLP2/ts4UY2sdV2c
         wazg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VKlMqpEd7YBdXym1IpYpN4BFku3eaQLOirqfkrIT+SY=;
        fh=k0pIQuV6hPhKs///btxpj4GckE2NKT7xyBJyGomohFs=;
        b=Mr8CbKCje51syVji/F5eNgtjsxfGVreRNkYtdLBiQ2NwEN0cS+JEQRBoYk6VV0tXiy
         /pwcTj1QsX9Z/Zh3p5f+OzqIWPk+SuOeU9hfCtwBuFRdxvfOnrGylo5LgQTPXtcxbfLK
         kBt0mThQ1OItXwjFc7cYvfM9iZbqIUB6m6qZIK4ivRxcNzzFIYIo79p/DmXfyDjguO+e
         7im+d2emCH1AJr/Mqb3FATvH0QAXdlbAkfm7+NKHzfAJxA0FgiMb2rfkyXuzjj3kVz0Y
         lXGV4g19moqw7DlG0yQbWxo5pDZTLNpPGYT4MqaQXk4tsgA0lO8WpfmuBCBgcR/WhcOL
         OEcQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1772505024; x=1773109824; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VKlMqpEd7YBdXym1IpYpN4BFku3eaQLOirqfkrIT+SY=;
        b=Y20eewbtbz88r0CvB6vcLgaucgAvnBcfx1y7go1deDjXuIV0B6haeoUzjRHKOppOUS
         Chc3uap9Bggfk0yzSzFgn1WGGbygOGS3RD14Vvg/7xXeey2dbQlTZnc/BhSImjvfzsaF
         V+LDv9YRh3Whk+bP1AM/SrpEZmwOuPy78KJCy/hwn553RUPF+bbaJv6Hszca3Lsj8E2N
         oU8pUD7GmxYiwjUP8WIdQtaTEFIKqv4YYScTFs/48QphWDQG+4Ah9Xa+oL4yMkG6NxjN
         zoKUsHpSWxqZpWw3xAWuAhOrYm4nSzag0Psx1Cy0K4HiLA3/kjOTE1qCW2BXlre1OpNw
         jMTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772505024; x=1773109824;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VKlMqpEd7YBdXym1IpYpN4BFku3eaQLOirqfkrIT+SY=;
        b=jbJBPPRcx8ray6KnaMIACxJd0hpNeC2eQu+rZj2CqGa5XSbV2mpjmpgqQv0JOLwJro
         qFMeDHtdEL1CJWX1SpdppzVZ3VENUML61ILgFjELO+0AM7p+iVLYaGptn3YiTxY/epx5
         YrxzKnC0FAle0T/Iw5TKj5ZHgH3dQSOslOjr9IRZ/hrULH2CN/hB18kK7FNs0EopgsdQ
         jdJGdWZ1jirUYJ+eGH51HeNDumOq7ziUUdgL+oGY/wvYb//u3p2YRQNKgIEVfdegMgRJ
         hW5bxnaS6CF1QMMm4jga88fPAtwDW5RniYnmERk7BV3J4oPAew/sucE1qo8+isM7Sttq
         WKmw==
X-Forwarded-Encrypted: i=1; AJvYcCVTthVJW/CnaQZ/RfKwF0GI8UA7TAUNUX0DQeK2qRBAl7tJPKH2Boyj8KArJE6fVg0MViHA+gtE8PyPjw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyQSuI3PCnNs3Jo76i/BLxwKOy28X9SNV5hp2msJlWKg7quzEdH
	s1odHtI+M2QlTrvqBZ0fq3FziQ2MWg5pB/UGhvRCEB1k8ufxmPHwDkfp5MXR5PwYeufFCpi6dcd
	6nCmbZa42K5Aq/AYjbgKkqz8yyNw8XIDzd4rUuASf
X-Gm-Gg: ATEYQzzRo1PJbjJ4BJ/NkeziOtCAZGHFt4ofxUZUyn06qiO+cTMZfmjEX9MKXrI3Tj3
	75PvRmtX8gytshXphgyqE4FRLBumuEThjVHrOoUqFfz2kkQ1+WC2NvddPogZTYcEfcUCzSsjqyf
	qa95ccD5YFLA79WNRyBd5EPGmfSJoHQek3/WkgOZrqMnTlpQxxLTt1yuItzrcBVhtL5Q0Y7HtVx
	hbvO6In7kufuPYPiN9LtH2p9borvfQclwpb/S4U9t4QOQ8SaYSW+3/RhJlEdS3RlTAWdnL5/zNo
	sKSfjo1EU+iQfjCclw==
X-Received: by 2002:a17:903:244a:b0:2ae:56f8:747b with SMTP id
 d9443c01a7336-2ae56f8786cmr37920855ad.57.1772505023451; Mon, 02 Mar 2026
 18:30:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org> <20260302-iino-u64-v2-105-e5388800dae0@kernel.org>
In-Reply-To: <20260302-iino-u64-v2-105-e5388800dae0@kernel.org>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 2 Mar 2026 21:30:10 -0500
X-Gm-Features: AaiRm53tOqTCLn9NgvLgqwCOFo4xSyksjolr8ucn59RQ44Ck0r7mzGeRmSI5U0c
Message-ID: <CAHC9VhSHj7qc-tKxEN45bkfr+Dha59ihzOGiCO2WDYTYoB-LeA@mail.gmail.com>
Subject: Re: [PATCH v2 105/110] security: replace PRIino with %llu/%llx format strings
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

On Mon, Mar 2, 2026 at 3:50=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wro=
te:
>
> Now that i_ino is u64 and the PRIino format macro has been removed,
> replace all uses in security with the concrete format strings.
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

For the LSM framework and SELinux changes ...

Acked-by: Paul Moore <paul@paul-moore.com> (LSM/SELinux)

--=20
paul-moore.com
