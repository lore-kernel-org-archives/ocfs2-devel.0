Received: from new3-smtp.messagingengine.com (new3-smtp.messagingengine.com [66.111.4.229])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2CB4F14C;
	Thu, 28 Sep 2023 15:48:44 +0000 (UTC)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailnew.nyi.internal (Postfix) with ESMTP id 5C6B0581DAC;
	Thu, 28 Sep 2023 11:48:43 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Thu, 28 Sep 2023 11:48:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:sender
	:subject:subject:to:to; s=fm1; t=1695916123; x=1695923323; bh=AE
	M/fDbI9O0BImAELzI+hfXsnObtdXB3nh8ZZCXXqn0=; b=Zb4LJ/iWxs7PYCxfSp
	Mmj7xYkSAgWplciC0+hZqHaIVvkpCb/Wp0lEpODKkSCM40frExHvLz4EZAD1HZJ2
	9ttgDzhZqI1ch1xpfCA8FHvF2/PahtOaTm//TzyXbpTROeAOQjegRsYYeSoWNyYK
	byMO63AHEnUHVIOFCUm+mvxA/KjnXoKo0xnweP/w+dWDOvLPjGksvDhU3ohZT6Yp
	QpiswLlY9kvUQhVEctTQH/u+sDAFDQssEAik0gF+XDqfmAiKXNJoWxztil5xTMTb
	X/lrYQ3vvVFk9wvd6DyfBmvUprhzlzpKTyylDH3eDykTx5H6fgxF/6J3HRQ+0H0e
	vkbw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm2; t=1695916123; x=1695923323; bh=AEM/fDbI9O0BI
	mAELzI+hfXsnObtdXB3nh8ZZCXXqn0=; b=n/Qf6qJXucXyk4LW4CL1tlnrKQD+5
	he13BWxPblPpTww3+/1Dnpdhq7Gwr3a+fNA/QON3ImAoB4q0Q/wz7xwPYTvIh6y4
	pI+Bd8aWYcux+cr2fpJzmkbS+P4O02I2hebi06+hrjnSwnPE23SfqSF4cbFR4hlH
	YaVmK8v0yltudUYq72xKx5sAA01J7qL+ne43uzwAXwT6ryRFwbNVU+Y1mHF2dF66
	agNWj0CMsq4gNWlnonaqngyXaD0pPv6qEhlNb+XbjMdBnMkU2kFvOV0FzP6pW1Jx
	vJR5UdEjaUxDazFxTy4TLY4x736COIBHAoRVIXDZypp4DjDlHgBb2dBag==
X-ME-Sender: <xms:VqAVZehkLTOXwS_xg_6r9_9U7myXUu9Xf4xrZ0lmC-mNKcMCcnNsJw>
    <xme:VqAVZfCC0hBNW-6zWSNUDpimotTv1K_lD4MorQPse5pJgj_jwgOrIpVTd1e1lCsJ4
    CyxiAxCxEI04_Mnbzk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvkedrtddtgdeifecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdetrhhn
    ugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtth
    gvrhhnpeevhfffledtgeehfeffhfdtgedvheejtdfgkeeuvefgudffteettdekkeeufeeh
    udenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:VqAVZWG45Rd33BgqA4LgSTkoIL6Ot1dfOvbe8RgsboLNiKSqszWOAg>
    <xmx:VqAVZXQTxuydNZS_enwE9LlRoOhiuGF9gCIhq3TRrDdNwtGtt6FbIQ>
    <xmx:VqAVZbxEBIkR5teHqxhFLdOZo9wRUGgFdkIYaLd2pyKQSq2CtJDzCg>
    <xmx:W6AVZTZKpR7w9NLRl_L1L6zoNyttDC4RXO7dBXqniz-srYv7BlTPTA>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id BE4B9B60089; Thu, 28 Sep 2023 11:48:38 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-958-g1b1b911df8-fm-20230927.002-g1b1b911d
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-Id: <6020d6e7-b187-4abb-bf38-dc09d8bd0f6d@app.fastmail.com>
In-Reply-To: <20230928110554.34758-2-jlayton@kernel.org>
References: <20230928110554.34758-1-jlayton@kernel.org>
 <20230928110554.34758-2-jlayton@kernel.org>
Date: Thu, 28 Sep 2023 11:48:16 -0400
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Jeff Layton" <jlayton@kernel.org>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Christian Brauner" <brauner@kernel.org>,
 "Linus Torvalds" <torvalds@linux-foundation.org>,
 "David Sterba" <dsterba@suse.cz>, "Amir Goldstein" <amir73il@gmail.com>,
 "Theodore Ts'o" <tytso@mit.edu>,
 "Eric W. Biederman" <ebiederm@xmission.com>,
 "Kees Cook" <keescook@chromium.org>, "Jeremy Kerr" <jk@ozlabs.org>,
 "Michael Ellerman" <mpe@ellerman.id.au>,
 "Nicholas Piggin" <npiggin@gmail.com>,
 "Christophe Leroy" <christophe.leroy@csgroup.eu>,
 "Heiko Carstens" <hca@linux.ibm.com>,
 "Vasily Gorbik" <gor@linux.ibm.com>,
 "Alexander Gordeev" <agordeev@linux.ibm.com>,
 "Christian Borntraeger" <borntraeger@linux.ibm.com>,
 "Sven Schnelle" <svens@linux.ibm.com>,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
 "Todd Kjos" <tkjos@android.com>, "Martijn Coenen" <maco@android.com>,
 "Joel Fernandes" <joel@joelfernandes.org>,
 "Carlos Llamas" <cmllamas@google.com>,
 "Suren Baghdasaryan" <surenb@google.com>,
 "Mattia Dongili" <malattia@linux.it>,
 "Dennis Dalessandro" <dennis.dalessandro@cornelisnetworks.com>,
 "Jason Gunthorpe" <jgg@ziepe.ca>, "Leon Romanovsky" <leon@kernel.org>,
 "Brad Warrum" <bwarrum@linux.ibm.com>,
 "Ritu Agarwal" <rituagar@linux.ibm.com>,
 "Hans de Goede" <hdegoede@redhat.com>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 "Mark Gross" <markgross@kernel.org>, "Jiri Slaby" <jirislaby@kernel.org>,
 "Eric Van Hensbergen" <ericvh@kernel.org>,
 "Latchesar Ionkov" <lucho@ionkov.net>,
 "Dominique Martinet" <asmadeus@codewreck.org>,
 "Christian Schoenebeck" <linux_oss@crudebyte.com>,
 "David Sterba" <dsterba@suse.com>, "David Howells" <dhowells@redhat.com>,
 "Marc Dionne" <marc.dionne@auristor.com>, "Ian Kent" <raven@themaw.net>,
 "Luis de Bethencourt" <luisbg@kernel.org>,
 "Salah Triki" <salah.triki@gmail.com>,
 "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
 "Chris Mason" <clm@fb.com>, "Josef Bacik" <josef@toxicpanda.com>,
 "Xiubo Li" <xiubli@redhat.com>, "Ilya Dryomov" <idryomov@gmail.com>,
 "Jan Harkes" <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
 "Joel Becker" <jlbec@evilplan.org>, "Christoph Hellwig" <hch@lst.de>,
 "Nicolas Pitre" <nico@fluxnic.net>,
 "Rafael J . Wysocki" <rafael@kernel.org>,
 "Ard Biesheuvel" <ardb@kernel.org>, "Gao Xiang" <xiang@kernel.org>,
 "Chao Yu" <chao@kernel.org>, "Yue Hu" <huyue2@coolpad.com>,
 "Jeffle Xu" <jefflexu@linux.alibaba.com>,
 "Namjae Jeon" <linkinjeon@kernel.org>,
 "Sungjong Seo" <sj1557.seo@samsung.com>, "Jan Kara" <jack@suse.com>,
 "Andreas Dilger" <adilger.kernel@dilger.ca>,
 "Jaegeuk Kim" <jaegeuk@kernel.org>,
 "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>,
 "Christoph Hellwig" <hch@infradead.org>,
 "Miklos Szeredi" <miklos@szeredi.hu>,
 "Bob Peterson" <rpeterso@redhat.com>,
 "Andreas Gruenbacher" <agruenba@redhat.com>,
 "Richard Weinberger" <richard@nod.at>,
 "Anton Ivanov" <anton.ivanov@cambridgegreys.com>,
 "Johannes Berg" <johannes@sipsolutions.net>,
 "Mikulas Patocka" <mikulas@artax.karlin.mff.cuni.cz>,
 "Mike Kravetz" <mike.kravetz@oracle.com>,
 "Muchun Song" <muchun.song@linux.dev>, "Jan Kara" <jack@suse.cz>,
 "David Woodhouse" <dwmw2@infradead.org>,
 "Dave Kleikamp" <shaggy@kernel.org>, "Tejun Heo" <tj@kernel.org>,
 "Trond Myklebust" <trond.myklebust@hammerspace.com>,
 "Anna Schumaker" <anna@kernel.org>,
 "Chuck Lever" <chuck.lever@oracle.com>, "Neil Brown" <neilb@suse.de>,
 "Olga Kornievskaia" <kolga@netapp.com>, "Dai Ngo" <Dai.Ngo@oracle.com>,
 "Tom Talpey" <tom@talpey.com>,
 "Ryusuke Konishi" <konishi.ryusuke@gmail.com>,
 "Anton Altaparmakov" <anton@tuxera.com>,
 "Konstantin Komarov" <almaz.alexandrovich@paragon-software.com>,
 "Mark Fasheh" <mark@fasheh.com>,
 "Joseph Qi" <joseph.qi@linux.alibaba.com>,
 "Bob Copeland" <me@bobcopeland.com>,
 "Mike Marshall" <hubcap@omnibond.com>,
 "Martin Brandenburg" <martin@omnibond.com>,
 "Luis Chamberlain" <mcgrof@kernel.org>,
 "Iurii Zaikin" <yzaikin@google.com>, "Tony Luck" <tony.luck@intel.com>,
 "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
 "Anders Larsen" <al@alarsen.net>, "Steve French" <sfrench@samba.org>,
 "Paulo Alcantara" <pc@manguebit.com>,
 "Ronnie Sahlberg" <lsahlber@redhat.com>,
 "Shyam Prasad N" <sprasad@microsoft.com>,
 "Sergey Senozhatsky" <senozhatsky@chromium.org>,
 "Phillip Lougher" <phillip@squashfs.org.uk>,
 "Steven Rostedt" <rostedt@goodmis.org>,
 "Masami Hiramatsu" <mhiramat@kernel.org>,
 "Evgeniy Dushistov" <dushistov@mail.ru>,
 "Chandan Babu R" <chandan.babu@oracle.com>,
 "Darrick J. Wong" <djwong@kernel.org>,
 "Damien Le Moal" <dlemoal@kernel.org>,
 "Naohiro Aota" <naohiro.aota@wdc.com>,
 "Johannes Thumshirn" <jth@kernel.org>,
 "Alexei Starovoitov" <ast@kernel.org>,
 "Daniel Borkmann" <daniel@iogearbox.net>,
 "Andrii Nakryiko" <andrii@kernel.org>,
 "Martin KaFai Lau" <martin.lau@linux.dev>, "Song Liu" <song@kernel.org>,
 "Yonghong Song" <yonghong.song@linux.dev>,
 "John Fastabend" <john.fastabend@gmail.com>,
 "KP Singh" <kpsingh@kernel.org>, "Stanislav Fomichev" <sdf@google.com>,
 "Hao Luo" <haoluo@google.com>, "Jiri Olsa" <jolsa@kernel.org>,
 "Hugh Dickins" <hughd@google.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "David S . Miller" <davem@davemloft.net>,
 "Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>,
 "Paolo Abeni" <pabeni@redhat.com>,
 "John Johansen" <john.johansen@canonical.com>,
 "Paul Moore" <paul@paul-moore.com>, "James Morris" <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>,
 "Stephen Smalley" <stephen.smalley.work@gmail.com>,
 "Eric Paris" <eparis@parisplace.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org, platform-driver-x86@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-serial@vger.kernel.org,
 linux-usb@vger.kernel.org, v9fs@lists.linux.dev,
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
 linux-xfs@vger.kernel.org, bpf@vger.kernel.org,
 Netdev <netdev@vger.kernel.org>, apparmor@lists.ubuntu.com,
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Subject: Re: [PATCH 86/87] fs: switch timespec64 fields in inode to discrete integers
Content-Type: text/plain

On Thu, Sep 28, 2023, at 07:05, Jeff Layton wrote:
> This shaves 8 bytes off struct inode, according to pahole.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

FWIW, this is similar to the approach that Deepa suggested
back in 2016:

https://lore.kernel.org/lkml/1452144972-15802-3-git-send-email-deepa.kernel@gmail.com/

It was NaKed at the time because of the added complexity,
though it would have been much easier to do it then,
as we had to touch all the timespec references anyway.

The approach still seems ok to me, but I'm not sure it's worth
doing it now if we didn't do it then.

     Arnd
