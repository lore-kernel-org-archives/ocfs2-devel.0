Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D97FEB64D8
	for <ocfs2-devel@archiver.kernel.org>; Wed, 21 Jun 2023 19:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=9+U7/hUsQ5IY3+q/o3/QvJumVqWs0wKOW8RGYqcGdv8=;
 b=2Wo1fT2nmOMyCtpZKWsW+9fK6NUvS+zKRQb99az6sJASMuYkc9PEsDQQpDDm2CMlIM0mHwbdV+LG
   GfkXthwe6wXjuzHqUio6tAzYp7tzuVWvBHcX7BQFcofU6cztRGdnoSZX9vf1Uu75oIPwfqYShhIq
   IWEU7uJI81SKR/xd9IKYAJeKBBclmotGjslv1GUk//2lo342jKqiE3CU+PxzthCYmV2x8KzB8a18
   ch62AiRHelQhnf/gcTThbxNTRyD3EJM/FXgwYNktnJs7VSaOHGjFy85Bje41W2ufW9kJuip2tQlX
   qpW9dzp82NUO69I450A3EWx1iPqYnnPYUWHPgw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=9+U7/hUsQ5IY3+q/o3/QvJumVqWs0wKOW8RGYqcGdv8=;
 b=k+rZ/1Et96jZdpRpUTRtCN176GigsO7aDKuUp9wH5BoabSLTI2I3CxZsw4mRELB/AXaiZWGXrcr0
   nIjsQCbI7NM3AY8XZaWWhSjH7bE53KwCbDp2bdQwmDBZkoZSUL4AsdAcFuQzESZ8B7Ied7soS3WK
   1VOJiGKpkYSHnHCxhwYY1F1aYPxBuUxqn5Xhkq9BP35YZFUGgO8+RTYGt3yupWZ9neHwaRVWWohT
   OtJXyxGHdciG5i0IMG3n98N/JOUK9az6bY80wQwAB8CYd/uUaUS0P2QXwnHCi/lbJxotAn2RsImF
   gcQSy1UNvlgigK0sTieFsvBiSqNON+qlUrl66g==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWM0044PAEE1F30@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 21 Jun 2023 19:06:14 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1687373315; bh=a5OpkE0TU4uPAvSOWcyUKhr2U/OaDDTahqvZpyNm/D4=;
 h=Subject:From:To:Date:In-Reply-To:References:From;
 b=PiPk49g+MFOu/O2ZwDxO/8QAjKIZGlhjql5KOg56o+z0jsrDavO9BiaXOtkYto876
 fJ7qYzZ7aATc9kPncdP1kCdlY5wqINNGdYK2LGj2HmV63uWD5NHZ4+OFVQ4t30vFE9
 rYDpgx917Jc/lUMtGxdnWxKlhyndYbn3MftPxoStquXW6wJVzxk1ZBM8Z7BTbv2h/U
 qJjwHaLWN8lUJ3h6C5OcO+D166wrcNaWoWGX2W/vO7mNHZJIsw6euWqEIeYa7S4lF3
 jaX3jg20U9mjcF803nObNGAx9i1QbKIM3FZeyHr6EhjkD9DNtiQVqDSkHfY1GNj8rV
 9eRPHwtyQHGGQ==
Message-id: <c376703f26442b3310f173219c37c7b7ae4fe61b.camel@kernel.org>
To: Tom Talpey <tom@talpey.com>, Jeremy Kerr <jk@ozlabs.org>,
 Arnd Bergmann <arnd@arndb.de>, Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
 Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>,
 Joel Fernandes <joel@joelfernandes.org>,
 Christian Brauner <brauner@kernel.org>, Carlos Llamas <cmllamas@google.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Brad Warrum <bwarrum@linux.ibm.com>, Ritu Agarwal <rituagar@linux.ibm.com>,
 Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>,
 Dominique Martinet <asmadeus@codewreck.org>,
 Christian Schoenebeck <linux_oss@crudebyte.com>,
 David Sterba <dsterba@suse.com>, David Howells <dhowells@redhat.com>,
 Marc Dionne <marc.dionne@auristor.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Ian Kent <raven@themaw.net>,
 Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>,
 "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
 Eric Biederman <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>,
 Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
 Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
 Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
 Joel Becker <jlbec@evilplan.org>, Christoph Hellwig <hch@lst.de>,
 Nicolas Pitre <nico@fluxnic.net>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Tyler Hicks <code@tyhicks.com>, Ard Biesheuvel <ardb@kernel.org>,
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
 Yue Hu <huyue2@coolpad.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
 Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>,
 Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>,
 Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>,
 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
 Miklos Szeredi <miklos@szeredi.hu>, Bob Peterson <rpeterso@redhat.com>,
 Andreas Gruenbacher <agruenba@redhat.com>,
 Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
 Mike Kravetz <mike.kravetz@oracle.com>, Muchun Song <muchun.song@linux.dev>,
 David Woodhouse <dwmw2@infradead.org>, Dave Kleikamp <shaggy@kernel.org>,
 Tejun Heo <tj@kernel.org>, Trond Myklebust <trond.myklebust@hammerspace.com>,
 Anna Schumaker <anna@kernel.org>, Chuck Lever <chuck.lever@oracle.com>,
 Ryusuke Konishi <konishi.ryusuke@gmail.com>,
 Anton Altaparmakov <anton@tuxera.com>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 Mark Fasheh <mark@fasheh.com>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Bob Copeland <me@bobcopeland.com>, Mike Marshall <hubcap@omnibond.com>,
 Martin Brandenburg <martin@omnibond.com>,
 Luis Chamberlain <mcgrof@kernel.org>, Iurii Zaikin <yzaikin@google.com>,
 Tony Luck <tony.luck@intel.com>, "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
 Anders Larsen <al@alarsen.net>, Steve French <sfrench@samba.org>,
 Paulo Alcantara <pc@manguebit.com>, Ronnie Sahlberg <lsahlber@redhat.com>,
 Shyam Prasad N <sprasad@microsoft.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Phillip Lougher <phillip@squashfs.org.uk>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Evgeniy Dushistov <dushistov@mail.ru>, Hans de Goede <hdegoede@redhat.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
 Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>,
 Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
 John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>,
 Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>,
 Jiri Olsa <jolsa@kernel.org>, Hugh Dickins <hughd@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 John Johansen <john.johansen@canonical.com>, Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 Eric Paris <eparis@parisplace.org>, Juergen Gross <jgross@suse.com>,
 Ruihan Li <lrh2000@pku.edu.cn>,
 Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
 Wolfram Sang <wsa+renesas@sang-engineering.com>,
 Udipto Goswami <quic_ugoswami@quicinc.com>,
 Linyu Yuan <quic_linyyuan@quicinc.com>, John Keeping <john@keeping.me.uk>,
 Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
 Dan Carpenter <error27@gmail.com>, Yuta Hayama <hayama@lineo.co.jp>,
 Jozef Martiniak <jomajm@gmail.com>, Jens Axboe <axboe@kernel.dk>,
 Alan Stern <stern@rowland.harvard.edu>, Sandeep Dhavale <dhavale@google.com>,
 Dave Chinner <dchinner@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
 ZhangPeng <zhangpeng362@huawei.com>, Viacheslav Dubeyko <slava@dubeyko.com>,
 Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 Aditya Garg <gargaditya08@live.com>, Erez Zadok <ezk@cs.stonybrook.edu>,
 Yifei Liu <yifeliu@cs.stonybrook.edu>, Yu Zhe <yuzhe@nfschina.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Oleg Kanatov <okanatov@gmail.com>,
 "Dr. David Alan Gilbert" <linux@treblig.org>,
 Jiangshan Yi <yijiangshan@kylinos.cn>, xu xin <cgel.zte@gmail.com>,
 Stefan Roesch <shr@devkernel.io>, Zhihao Cheng <chengzhihao1@huawei.com>,
 "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
 Alexey Dobriyan <adobriyan@gmail.com>, Minghao Chi <chi.minghao@zte.com.cn>,
 Seth Forshee <sforshee@digitalocean.com>,
 Zeng Jingxiang <linuszeng@tencent.com>, Bart Van Assche <bvanassche@acm.org>,
 Mimi Zohar <zohar@linux.ibm.com>, Roberto Sassu <roberto.sassu@huawei.com>,
 Zhang Yi <yi.zhang@huawei.com>, Tom Rix <trix@redhat.com>,
 "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
 Chen Zhongjin <chenzhongjin@huawei.com>,
 Zhengchao Shao <shaozhengchao@huawei.com>, Rik van Riel <riel@surriel.com>,
 Jingyu Wang <jingyuwang_vip@163.com>, Hangyu Hua <hbh25y@gmail.com>,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-usb@vger.kernel.org, v9fs@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-afs@lists.infradead.org,
 autofs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
 ceph-devel@vger.kernel.org, codalist@coda.cs.cmu.edu,
 ecryptfs@vger.kernel.org, linux-efi@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
 linux-um@lists.infradead.org, linux-mtd@lists.infradead.org,
 jfs-discussion@lists.sourceforge.net, linux-nfs@vger.kernel.org,
 linux-nilfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net,
 ntfs3@lists.linux.dev, ocfs2-devel@oss.oracle.com,
 linux-karma-devel@lists.sourceforge.net, devel@lists.orangefs.org,
 linux-unionfs@vger.kernel.org, linux-hardening@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-trace-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
 apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org,
 selinux@vger.kernel.org
Date: Wed, 21 Jun 2023 14:48:17 -0400
In-reply-to: <e513d856-3a6f-3a32-40fe-6c728e7b5ec8@talpey.com>
References: <20230621144507.55591-1-jlayton@kernel.org>
 <20230621144507.55591-2-jlayton@kernel.org>
 <1f97d595-e035-46ce-6269-eebfe922cf35@talpey.com>
 <6f4bcd7d79f688120d80e96e86d7c521854d8e84.camel@kernel.org>
 <e513d856-3a6f-3a32-40fe-6c728e7b5ec8@talpey.com>
User-Agent: Evolution 3.48.3 (3.48.3-1.fc38)
MIME-version: 1.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10748
 signatures=596816
Subject: Re: [Ocfs2-devel] [PATCH 01/79] fs: add ctime accessors	infrastructure
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
From: Jeff Layton via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Jeff Layton <jlayton@kernel.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.kernel.org ~all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-ORIG-GUID: Hw2YBoEXxeD9Z6JLg28BxdWNBkRTEsl8
X-Proofpoint-GUID: Hw2YBoEXxeD9Z6JLg28BxdWNBkRTEsl8
X-Mailman-Approved-At: Wed, 21 Jun 2023 19:06:12 +0000
Reporting-Meta:
 AAGlxZP40KsGxSGObkLmWEE6uYu+R02FRcFwQV6s0KOC7rxxIQIUJwC91t0CK9US
 E3mh22n4SQU0COn5pIi8Hwwhg7YAYLOClAOmqzaM7Ld1gY1DMZQJO2FgcjLnh7te
 Kj8by9PeJQpmxO8Yuu7iq5IbBY3nQ2LEng/AF+K+ny7kesHt4yg/mRgZ1dAIk6hg
 c+L/mAzwdTrN06dv+vorHfDYkDC6gQKCqvR1BbPgPwPyHpk9g+B/4ypwgnCP+7PD
 PjQlhDlRgoAOUQR7YTlYAr/xrYKetQB1YNXVsrIGGqLu1oAnL+dJDbKjpbQbhfVL
 qx51/PaMyNmhOoVxkvfL63anwymVC2FA3JJtRPYs3QwaZgbwroOsmvz47RhKHfQK
 e77dV1MFeyhOKD5fOwIHWCi/g0zO7aIjiY2H1LRTpk4I6XqwTJX/DpuETt7fFTm1
 sHDCCM8PLsnpu0nvJ0CYEIi/cuuRVC/zcuwSGtgFZuBQek3CzIGUOsVsLIKSZCOP
 4GKxzs8QP/piMix/5bFjI/xastlpc3gWgnO5qSu6u8o=

On Wed, 2023-06-21 at 14:19 -0400, Tom Talpey wrote:
> On 6/21/2023 2:01 PM, Jeff Layton wrote:
> > On Wed, 2023-06-21 at 13:29 -0400, Tom Talpey wrote:
> > > On 6/21/2023 10:45 AM, Jeff Layton wrote:
> > > > struct timespec64 has unused bits in the tv_nsec field that can be used
> > > > for other purposes. In future patches, we're going to change how the
> > > > inode->i_ctime is accessed in certain inodes in order to make use of
> > > > them. In order to do that safely though, we'll need to eradicate raw
> > > > accesses of the inode->i_ctime field from the kernel.
> > > > 
> > > > Add new accessor functions for the ctime that we can use to replace them.
> > > > 
> > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > ---
> > > >    fs/inode.c         | 16 ++++++++++++++
> > > >    include/linux/fs.h | 53 +++++++++++++++++++++++++++++++++++++++++++++-
> > > >    2 files changed, 68 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/fs/inode.c b/fs/inode.c
> > > > index d37fad91c8da..c005e7328fbb 100644
> > > > --- a/fs/inode.c
> > > > +++ b/fs/inode.c
> > > > @@ -2499,6 +2499,22 @@ struct timespec64 current_time(struct inode *inode)
> > > >    }
> > > >    EXPORT_SYMBOL(current_time);
> > > >    
> > > > +/**
> > > > + * inode_ctime_set_current - set the ctime to current_time
> > > > + * @inode: inode
> > > > + *
> > > > + * Set the inode->i_ctime to the current value for the inode. Returns
> > > > + * the current value that was assigned to i_ctime.
> > > > + */
> > > > +struct timespec64 inode_ctime_set_current(struct inode *inode)
> > > > +{
> > > > +	struct timespec64 now = current_time(inode);
> > > > +
> > > > +	inode_set_ctime(inode, now);
> > > > +	return now;
> > > > +}
> > > > +EXPORT_SYMBOL(inode_ctime_set_current);
> > > > +
> > > >    /**
> > > >     * in_group_or_capable - check whether caller is CAP_FSETID privileged
> > > >     * @idmap:	idmap of the mount @inode was found from
> > > > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > > > index 6867512907d6..9afb30606373 100644
> > > > --- a/include/linux/fs.h
> > > > +++ b/include/linux/fs.h
> > > > @@ -1474,7 +1474,58 @@ static inline bool fsuidgid_has_mapping(struct super_block *sb,
> > > >    	       kgid_has_mapping(fs_userns, kgid);
> > > >    }
> > > >    
> > > > -extern struct timespec64 current_time(struct inode *inode);
> > > > +struct timespec64 current_time(struct inode *inode);
> > > > +struct timespec64 inode_ctime_set_current(struct inode *inode);
> > > > +
> > > > +/**
> > > > + * inode_ctime_peek - fetch the current ctime from the inode
> > > > + * @inode: inode from which to fetch ctime
> > > > + *
> > > > + * Grab the current ctime from the inode and return it.
> > > > + */
> > > > +static inline struct timespec64 inode_ctime_peek(const struct inode *inode)
> > > > +{
> > > > +	return inode->i_ctime;
> > > > +}
> > > > +
> > > > +/**
> > > > + * inode_ctime_set - set the ctime in the inode to the given value
> > > > + * @inode: inode in which to set the ctime
> > > > + * @ts: timespec value to set the ctime
> > > > + *
> > > > + * Set the ctime in @inode to @ts.
> > > > + */
> > > > +static inline struct timespec64 inode_ctime_set(struct inode *inode, struct timespec64 ts)
> > > > +{
> > > > +	inode->i_ctime = ts;
> > > > +	return ts;
> > > > +}
> > > > +
> > > > +/**
> > > > + * inode_ctime_set_sec - set only the tv_sec field in the inode ctime
> > > 
> > > I'm curious about why you choose to split the tv_sec and tv_nsec
> > > set_ functions. Do any callers not set them both? Wouldn't a
> > > single call enable a more atomic behavior someday?
> > > 
> > >     inode_ctime_set_sec_nsec(struct inode *, time64_t, time64_t)
> > > 
> > > (or simply initialize a timespec64 and use inode_ctime_spec() )
> > > 
> > 
> > Yes, quite a few places set the fields individually. For example, when
> > loading a value from disk that doesn't have sufficient granularity to
> > set the nsecs field to anything but 0.
> 
> Well, they still need to set the tv_nsec so they could just pass 0.
> But ok.
> 

Sure. The difficulty is in trying to do this in an automated way. For
instance, look at the hfsplus patch; it has separate assignments in
place already:

-       result->i_ctime.tv_sec = result->i_mtime.tv_sec = result->i_atime.tv_sec = local_to_gmt(dir->i_sb, le32_to_cpu(dee.creation_date));
-       result->i_ctime.tv_nsec = 0;
+       inode_ctime_set_sec(result,
+                           result->i_mtime.tv_sec = result->i_atime.tv_sec = local_to_gmt(dir->i_sb, le32_to_cpu(dee.creation_date)));
+       inode_ctime_set_nsec(result, 0);

Granted the new code is pretty ugly, but it compiles!

Transforming that into what you're suggesting is a tougher proposition
to do with coccinelle. I didn't see a way to conditionally catch cases
like this, declare a new variable in the appropriate spot and then
transform two assignments (that may not be next to one another!) into a
single one.

Maybe it's possible, but my grasp of SMPL is not that great. The docs
and examples (including Kees' vey helpful ones!) cover fairly simple
changes well, but I didn't quite grasp how to do that complex an
evolution.

> > Could I have done it by declaring a local timespec64 variable and just
> > use the inode_ctime_set function in these places? Absolutely.
> > 
> > That's a bit more difficult to handle with coccinelle though. If someone
> > wants to suggest a way to do that without having to change all of these
> > call sites manually, then I'm open to redoing the set.
> > 
> > That might be better left for a later cleanup though.
> 
> Acked-by: Tom Talpey <tom@talpey.com>
> 

Many thanks!

> > > > + * @inode: inode in which to set the ctime
> > > > + * @sec:  value to set the tv_sec field
> > > > + *
> > > > + * Set the sec field in the ctime. Returns @sec.
> > > > + */
> > > > +static inline time64_t inode_ctime_set_sec(struct inode *inode, time64_t sec)
> > > > +{
> > > > +	inode->i_ctime.tv_sec = sec;
> > > > +	return sec;
> > > > +}
> > > > +
> > > > +/**
> > > > + * inode_ctime_set_nsec - set only the tv_nsec field in the inode ctime
> > > > + * @inode: inode in which to set the ctime
> > > > + * @nsec:  value to set the tv_nsec field
> > > > + *
> > > > + * Set the nsec field in the ctime. Returns @nsec.
> > > > + */
> > > > +static inline long inode_ctime_set_nsec(struct inode *inode, long nsec)
> > > > +{
> > > > +	inode->i_ctime.tv_nsec = nsec;
> > > > +	return nsec;
> > > > +}
> > > >    
> > > >    /*
> > > >     * Snapshotting support.
> > 

-- 
Jeff Layton <jlayton@kernel.org>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
