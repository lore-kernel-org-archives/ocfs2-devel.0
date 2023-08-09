Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A94724508
	for <ocfs2-devel@lists.linux.dev>; Wed,  9 Aug 2023 18:38:18 +0000 (UTC)
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-40ffa784eaeso336441cf.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 09 Aug 2023 11:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=omnibond-com.20221208.gappssmtp.com; s=20221208; t=1691606298; x=1692211098;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9EcmI8Rpl1R+tuyjPLJAOGmabIt197aKHT+nbD52Q1I=;
        b=BfdYdGlaV7wDLoLR9yjOQKYaMVK5G+sZo2gR8ietMzxK6/hhzrKBhXntyWFMe+Yo8W
         pXAEKi27jKY+o1GSIwlWHKByFh7VJx8vdxyzXfnpCla9dyz3P+vZbtPjJCJ8F75v4t++
         cENDUCMzciHiNczMnx810YrXJp7LJHfpO0BqiOVkILP4ZM1XP/NHiA5CqbEHPLNAnApb
         4blc5R+dkjgksSq2+K5JK9IBlHetg1olYAUJU7H7u688LciEb+01exSGkI+DT+Of4VXY
         kkHfq0UcUl8GdzevovO/osm+1AaLFSn4iK2zXa30egAa3a76m/vMuRq9Hke6KAEMMcTX
         y7cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691606298; x=1692211098;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9EcmI8Rpl1R+tuyjPLJAOGmabIt197aKHT+nbD52Q1I=;
        b=BgXKJjUveX4JfMDj94IDDs7R+9F6A3T8ZxhiZ1MFi3Awg9yCOBgq3nQXX4KK5WeL6m
         H3psjAyipVQUnpeDxA0pTUq/MoeUSEk9uLo55L0giWC0RcjsNHnAMleeCukwjkmg9oGV
         nVxthTf+wk9o0W8x12d5lS1K/qRT88glc5dBwIGyPvj/Ow99Pv05CHFHIQui686xXyAJ
         dgZHmWD4hA/wAUcZL9B13s0nlkM30oT3b+EIEyxbAk2rkarXVMmY9ILVXt0cyZqd5S/K
         eazlBEGl4uix84uYqszDytwtyPzkTvUV6lOleAQMeoZtbHHqTZ1jyqQ5ck2qc3MwpHnx
         SYJw==
X-Gm-Message-State: AOJu0YyTdBWjxZG81A3gQE4TcgbWr1h3vI8Rju6l5YZBfYndPgwhongl
	nIAoSM/KzpA+40qDz0BxNdj9hSi9QgFUUhin2G0vmA==
X-Google-Smtp-Source: AGHT+IH2sTR1ARtIFCpkS6vqthNwZFelmGu0RmLRp1wcx6mBBfZ3SQAFevZE8DnhGTo57OILWEQYl9skWtT3uKB51ZE=
X-Received: by 2002:ac8:4e47:0:b0:3f9:c207:3123 with SMTP id
 e7-20020ac84e47000000b003f9c2073123mr166690qtw.45.1691606297822; Wed, 09 Aug
 2023 11:38:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230807-mgctime-v7-0-d1dec143a704@kernel.org>
 <20230807-mgctime-v7-8-d1dec143a704@kernel.org> <20230809-segeln-pflaumen-460b81bd2d3a@brauner>
In-Reply-To: <20230809-segeln-pflaumen-460b81bd2d3a@brauner>
From: Mike Marshall <hubcap@omnibond.com>
Date: Wed, 9 Aug 2023 14:38:07 -0400
Message-ID: <CAOg9mST=WFAjEwS9eNi_huoUpBvPy3R3fbFVTLUeFZAv6BJEEQ@mail.gmail.com>
Subject: Re: [PATCH v7 08/13] fs: drop the timespec64 argument from update_time
To: Christian Brauner <brauner@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>, 
	Dominique Martinet <asmadeus@codewreck.org>, Christian Schoenebeck <linux_oss@crudebyte.com>, 
	David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>, Chris Mason <clm@fb.com>, 
	Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, Xiubo Li <xiubli@redhat.com>, 
	Ilya Dryomov <idryomov@gmail.com>, Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, 
	Tyler Hicks <code@tyhicks.com>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Yue Hu <huyue2@coolpad.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, Jan Kara <jack@suse.com>, 
	"Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Miklos Szeredi <miklos@szeredi.hu>, Bob Peterson <rpeterso@redhat.com>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Tejun Heo <tj@kernel.org>, Trond Myklebust <trond.myklebust@hammerspace.com>, 
	Anna Schumaker <anna@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Martin Brandenburg <martin@omnibond.com>, Luis Chamberlain <mcgrof@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Iurii Zaikin <yzaikin@google.com>, 
	Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Richard Weinberger <richard@nod.at>, Hans de Goede <hdegoede@redhat.com>, Hugh Dickins <hughd@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Amir Goldstein <amir73il@gmail.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, Benjamin Coddington <bcodding@redhat.com>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, v9fs@lists.linux.dev, 
	linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org, 
	ceph-devel@vger.kernel.org, codalist@coda.cs.cmu.edu, 
	ecryptfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	cluster-devel@redhat.com, linux-nfs@vger.kernel.org, ntfs3@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, devel@lists.orangefs.org, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-mtd@lists.infradead.org, linux-mm@kvack.org, 
	linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I've been following this patch on fsdevel... is there a
remote I could fetch with a branch that has this in it?

-Mike

On Wed, Aug 9, 2023 at 8:32=E2=80=AFAM Christian Brauner <brauner@kernel.or=
g> wrote:
>
> On Mon, Aug 07, 2023 at 03:38:39PM -0400, Jeff Layton wrote:
> > Now that all of the update_time operations are prepared for it, we can
> > drop the timespec64 argument from the update_time operation. Do that an=
d
> > remove it from some associated functions like inode_update_time and
> > inode_needs_update_time.
> >
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/bad_inode.c           |  3 +--
> >  fs/btrfs/inode.c         |  3 +--
> >  fs/btrfs/volumes.c       |  4 +---
> >  fs/fat/fat.h             |  3 +--
> >  fs/fat/misc.c            |  2 +-
> >  fs/gfs2/inode.c          |  3 +--
> >  fs/inode.c               | 30 +++++++++++++-----------------
> >  fs/overlayfs/inode.c     |  2 +-
> >  fs/overlayfs/overlayfs.h |  2 +-
> >  fs/ubifs/file.c          |  3 +--
> >  fs/ubifs/ubifs.h         |  2 +-
> >  fs/xfs/xfs_iops.c        |  1 -
> >  include/linux/fs.h       |  4 ++--
>
> This was missing the conversion of fs/orangefs orangefs_update_time()
> causing the build to fail. So at some point kbuild will yell here.
> Fwiw, I've fixed that up in-tree.
