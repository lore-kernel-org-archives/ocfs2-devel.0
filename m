Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C257F746A;
	Thu, 28 Sep 2023 11:35:25 +0000 (UTC)
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-4542d7e9bcfso3921666137.3;
        Thu, 28 Sep 2023 04:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695900924; x=1696505724; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c3oHHfr+yAdtkrxVkV3qE0VFTbMzK/MU2TZf7sFiWp8=;
        b=I+ku/y4A7a6pn5X/zmmcE3muyLePzfnppDwkXxFFaBIfXrfDQjinNdct1j6Amr4PZ1
         Gl8RMOAV4VAX2RIGjz7GaEIEoURQn4ct8+QyB8MzBeDoRQpRkNNVtGXYAZZDuIEwG1gC
         MQWZxjWpEjFOkdcVK3ufT3N2gSW72Cvy2G6w3b3f7b9Zg22s9A1GNVrn4RAfUBpFVbS6
         DZ6B6cazpcH5tBcCTfGOgJ+YMLOt8AnoJTM08q2h5IqloNe4RxZh+o5uQkEv1M2MaaYm
         WFPovzZv8w8xMIZZJ932KAvf53ej06IYZHJlJxip76N0YZwO0LkqBproJbDDo7eHiskE
         qa1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695900924; x=1696505724;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c3oHHfr+yAdtkrxVkV3qE0VFTbMzK/MU2TZf7sFiWp8=;
        b=XdVib2M8KepGK6FSTdikrqGoAnAy0c9iSGSZkhGS2CfcpetuusOEGoPWSaThME16ok
         5v8XsldqXRzFkkEfeeAFM1yaFtmiB7aBsItk09u3U7lwhLz1AmsqiV+06aBgOLM0NeK6
         BIad4u5ExuwFQyOIyECTOw/0t7L6TYzboGmabFD6Llt5zsdgBlKLU1iMVxv6Vcy+pyck
         44oMWsv2IjSejUbXG3PAV848WAxwkf3D6I0bwljfbYAVGQsoH6ZN/OFTqejY2qndcJVM
         CwV9chYIVx4xZKvM1Mp3HXMqbK3fFwrUJxysQY6PUA2fNMh2h7e3xRlwP2HLXXGKGOUj
         FnjQ==
X-Gm-Message-State: AOJu0YxeKO+1z5HEvXtfpEPYFltXgl4JTsQRnWz/Cpi7Xmu2Lxm++JTc
	7hyJnPyB1W0r5boCkkRWwQG4B4qsq7KpiO0k5ZI=
X-Google-Smtp-Source: AGHT+IHhHz7xARweFavd1XDLqmOlGZR89qjTYiX4UH69lO2YZAJePIkqF9BJYGYmOq/G1/CVWLpaXpMDMsrrAqgyB+o=
X-Received: by 2002:a67:ec16:0:b0:452:63b7:2f6d with SMTP id
 d22-20020a67ec16000000b0045263b72f6dmr830755vso.34.1695900924494; Thu, 28 Sep
 2023 04:35:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230928110554.34758-1-jlayton@kernel.org> <20230928110554.34758-3-jlayton@kernel.org>
In-Reply-To: <20230928110554.34758-3-jlayton@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 28 Sep 2023 14:35:13 +0300
Message-ID: <CAOQ4uxjSrgGr+6UOs4ADGYCderpQ7hAaPjNmB1DExAPLQQsHSg@mail.gmail.com>
Subject: Re: [PATCH 87/87] fs: move i_blocks up a few places in struct inode
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, David Sterba <dsterba@suse.cz>, 
	"Theodore Ts'o" <tytso@mit.edu>, Eric Biederman <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, 
	Jeremy Kerr <jk@ozlabs.org>, Arnd Bergmann <arnd@arndb.de>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	=?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, 
	Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>, 
	Joel Fernandes <joel@joelfernandes.org>, Carlos Llamas <cmllamas@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Mattia Dongili <malattia@linux.it>, 
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Brad Warrum <bwarrum@linux.ibm.com>, 
	Ritu Agarwal <rituagar@linux.ibm.com>, Hans de Goede <hdegoede@redhat.com>, 
	=?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
	Mark Gross <markgross@kernel.org>, Jiri Slaby <jirislaby@kernel.org>, 
	Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>, 
	Dominique Martinet <asmadeus@codewreck.org>, Christian Schoenebeck <linux_oss@crudebyte.com>, 
	David Sterba <dsterba@suse.com>, David Howells <dhowells@redhat.com>, 
	Marc Dionne <marc.dionne@auristor.com>, Ian Kent <raven@themaw.net>, 
	Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, Chris Mason <clm@fb.com>, 
	Josef Bacik <josef@toxicpanda.com>, Xiubo Li <xiubli@redhat.com>, 
	Ilya Dryomov <idryomov@gmail.com>, Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, 
	Joel Becker <jlbec@evilplan.org>, Christoph Hellwig <hch@lst.de>, Nicolas Pitre <nico@fluxnic.net>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Yue Hu <huyue2@coolpad.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Jan Kara <jack@suse.com>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Christoph Hellwig <hch@infradead.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Bob Peterson <rpeterso@redhat.com>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, Mike Kravetz <mike.kravetz@oracle.com>, 
	Muchun Song <muchun.song@linux.dev>, Jan Kara <jack@suse.cz>, 
	David Woodhouse <dwmw2@infradead.org>, Dave Kleikamp <shaggy@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Trond Myklebust <trond.myklebust@hammerspace.com>, Anna Schumaker <anna@kernel.org>, 
	Chuck Lever <chuck.lever@oracle.com>, Neil Brown <neilb@suse.de>, 
	Olga Kornievskaia <kolga@netapp.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Mark Fasheh <mark@fasheh.com>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Bob Copeland <me@bobcopeland.com>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, 
	Luis Chamberlain <mcgrof@kernel.org>, Iurii Zaikin <yzaikin@google.com>, Tony Luck <tony.luck@intel.com>, 
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>, Anders Larsen <al@alarsen.net>, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.com>, Ronnie Sahlberg <lsahlber@redhat.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Phillip Lougher <phillip@squashfs.org.uk>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Evgeniy Dushistov <dushistov@mail.ru>, 
	Chandan Babu R <chandan.babu@oracle.com>, "Darrick J. Wong" <djwong@kernel.org>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, John Fastabend <john.fastabend@gmail.com>, 
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>, 
	Jiri Olsa <jolsa@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	John Johansen <john.johansen@canonical.com>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Eric Paris <eparis@parisplace.org>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
	platform-driver-x86@vger.kernel.org, linux-rdma@vger.kernel.org, 
	linux-serial@vger.kernel.org, linux-usb@vger.kernel.org, v9fs@lists.linux.dev, 
	linux-afs@lists.infradead.org, autofs@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	codalist@coda.cs.cmu.edu, linux-efi@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, gfs2@lists.linux.dev, 
	linux-um@lists.infradead.org, linux-mtd@lists.infradead.org, 
	jfs-discussion@lists.sourceforge.net, linux-nfs@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, 
	ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
	linux-karma-devel@lists.sourceforge.net, devel@lists.orangefs.org, 
	linux-unionfs@vger.kernel.org, linux-hardening@vger.kernel.org, 
	reiserfs-devel@vger.kernel.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-trace-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 28, 2023 at 2:06=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> The recent change to use discrete integers instead of struct timespec64
> in struct inode shaved 8 bytes off of it, but it also moves the i_lock
> into the previous cacheline, away from the fields that it protects.
>
> Move i_blocks up above the i_lock, which moves the new 4 byte hole to
> just after the timestamps, without changing the size of the structure.
>

Instead of creating an implicit hole, can you please move i_generation
to fill the 4 bytes hole.

It makes sense in the same cache line with i_ino and I could
use the vacant 4 bytes hole above i_fsnotify_mask to expand the
mask to 64bit (the 32bit event mask space is running out).

Thanks,
Amir.

> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  include/linux/fs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index de902ff2938b..3e0fe0f52e7c 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -677,11 +677,11 @@ struct inode {
>         u32                     i_atime_nsec;
>         u32                     i_mtime_nsec;
>         u32                     i_ctime_nsec;
> +       blkcnt_t                i_blocks;
>         spinlock_t              i_lock; /* i_blocks, i_bytes, maybe i_siz=
e */
>         unsigned short          i_bytes;
>         u8                      i_blkbits;
>         u8                      i_write_hint;
> -       blkcnt_t                i_blocks;
>
>  #ifdef __NEED_I_SIZE_ORDERED
>         seqcount_t              i_size_seqcount;
> --
> 2.41.0
>
