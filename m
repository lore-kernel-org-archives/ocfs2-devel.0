Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 430C6EB64DA
	for <ocfs2-devel@archiver.kernel.org>; Thu, 22 Jun 2023 04:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=IkhR7odNE2TGSd0ZBBaB2kT1efnxyH93xtgr2nFZHxY=;
 b=V7V+qMel/XVWzy04ZYIRWlRO5gybmoVRsiCEz5fvCZkLuetzz2GofS1w1eCkKDD8/jKXNj0JKkCp
   GDnz/CXKOxFnNl53wM7cHEVXZpxP3cpW6lFIM7Pktb2xjTBSclwXV1klSFdKHvWmGLwNH38dOhZg
   UEGo1+1549NI/I2lsEdYYZvbAdwr5leHWB6cP7ZhlHgKquLsBDT3nZphmS0+JEJQrMPn5NmdnsPw
   6y21dG2Htx+J/44XEZRWVOsVc3keU1xb297GI0LOxViilvRpsY9RUjDrqiYW+NGRCh+wZIFzTF8J
   SzWigpCq76IlYiTrnA/DcD3G72yusq8g3w3U+w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=IkhR7odNE2TGSd0ZBBaB2kT1efnxyH93xtgr2nFZHxY=;
 b=kGO/sd3eWNDqg8inPkDpG4g5c5ExHp0Pn1ZksHzdmeQcafrN5VmQwks7JYSsaWGSDD91hemGnCU3
   FnEJFgRNEl4QmvdLRDIhxNrs/qkM8WDvAi1/vyFyoSy4+C9fhQWTSLWJeLKIEqfCSefu6nsssh1M
   s9drjxrIzJSzwc8/A7ydPerf2i7Ev5WPUIb9SbyL2pAA8Lnuecm0aP5wHxmoFsWzbFs7bJm4KTag
   HgE068dKbzl47IlKOU1ed8JoC9rTyZB45nAT8B39HqeamJ9Ov4hUlSbED3GDvjBqlNKUSR/rbuDd
   K4WIZwiRnQxf3Rr1E3DZGDZQ0Js6LwyEybIIDQ==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWM00N05ZLT3Y50@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 22 Jun 2023 04:10:41 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1687377165; bh=vTL4Y8a8sFEsX3Xqt4OIZCRU2/7UfNvPDdjp0N/3dJE=;
 h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
 b=tBqvzi0BueVyLSEbesqZv6Z2lEPP3VHDK/0ro+NhJgrWCN7POU/GnsfWmg+au/I1/
 qhi//1NZGnRyBWC+DfSRBIODYBQomanDaEsbNql7Uti143OqrGRxW4LYitKm3HOUFm
 3AFCsCq6C4olFaFCKGiCtIGy0tLgZnX0NusQlw4HgjVra9Ac5A8Ylg7+9/P0lUpR5a
 +VLBtjm16h891O76lVM1Ta8bhTOaRz+hamckCGdfcbzLfSMEYWZEagHpIq+7Dm+VlU
 f0RFgH+s7zmUzeMyOo6a8vBaboDD6pPbvwZcf5WIVyOhAezSg+L8WY3I+kat7Le9is
 Pb20wj8vyk/yg==
Message-id: <2a5a069572b46b59dd16fe8d54e549a9b5bbb6eb.camel@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Date: Wed, 21 Jun 2023 15:52:27 -0400
In-reply-to: <20230621152141.5961cf5f@gandalf.local.home>
References: <20230621144507.55591-1-jlayton@kernel.org>
 <20230621152141.5961cf5f@gandalf.local.home>
User-Agent: Evolution 3.48.3 (3.48.3-1.fc38)
MIME-version: 1.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10748
 signatures=596816
Cc: Latchesar Ionkov <lucho@ionkov.net>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Anders Larsen <al@alarsen.net>,
 Carlos Llamas <cmllamas@google.com>, Andrii Nakryiko <andrii@kernel.org>,
 Hugh Dickins <hughd@google.com>, John Johansen <john.johansen@canonical.com>,
 Seth Forshee <sforshee@digitalocean.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Mike Marshall <hubcap@omnibond.com>, Paulo Alcantara <pc@manguebit.com>,
 linux-xfs@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
 Michael Ellerman <mpe@ellerman.id.au>, John Keeping <john@keeping.me.uk>,
 Zhang Yi <yi.zhang@huawei.com>, James Morris <jmorris@namei.org>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Tyler Hicks <code@tyhicks.com>, Alan Stern <stern@rowland.harvard.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>, devel@lists.orangefs.org,
 Shyam Prasad N <sprasad@microsoft.com>, Jan Harkes <jaharkes@cs.cmu.edu>,
 linux-um@lists.infradead.org, Nicholas Piggin <npiggin@gmail.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Eric Van Hensbergen <ericvh@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Trond Myklebust <trond.myklebust@hammerspace.com>,
 Anton Altaparmakov <anton@tuxera.com>, Christian Brauner <brauner@kernel.org>,
 Wolfram Sang <wsa+renesas@sang-engineering.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Stephen Smalley <stephen.smalley.work@gmail.com>, linux-usb@vger.kernel.org,
 linux-kernel@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Luis Chamberlain <mcgrof@kernel.org>, Chuck Lever <chuck.lever@oracle.com>,
 Sven Schnelle <svens@linux.ibm.com>, Jiri Olsa <jolsa@kernel.org>,
 Jan Kara <jack@suse.com>, Tejun Heo <tj@kernel.org>,
 linux-trace-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
 Dave Kleikamp <shaggy@kernel.org>, Sandeep Dhavale <dhavale@google.com>,
 Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 Mimi Zohar <zohar@linux.ibm.com>, linux-mm@kvack.org,
 Joel Fernandes <joel@joelfernandes.org>, Eric Dumazet <edumazet@google.com>,
 Stanislav Fomichev <sdf@google.com>,
 Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
 Hangyu Hua <hbh25y@gmail.com>, linux-s390@vger.kernel.org,
 linux-nilfs@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
 Leon Romanovsky <leon@kernel.org>, John Fastabend <john.fastabend@gmail.com>,
 Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
 Minghao Chi <chi.minghao@zte.com.cn>, codalist@coda.cs.cmu.edu,
 selinux@vger.kernel.org, ZhangPeng <zhangpeng362@huawei.com>,
 Udipto Goswami <quic_ugoswami@quicinc.com>, Yonghong Song <yhs@fb.com>,
 Iurii Zaikin <yzaikin@google.com>, Namjae Jeon <linkinjeon@kernel.org>,
 Masami Hiramatsu <mhiramat@kernel.org>, ecryptfs@vger.kernel.org,
 Todd Kjos <tkjos@android.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Yu Zhe <yuzhe@nfschina.com>, linuxppc-dev@lists.ozlabs.org,
 reiserfs-devel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>,
 Yue Hu <huyue2@coolpad.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
 Aditya Garg <gargaditya08@live.com>, Martijn Coenen <maco@android.com>,
 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Hao Luo <haoluo@google.com>,
 Tony Luck <tony.luck@intel.com>, Theodore Ts'o <tytso@mit.edu>,
 Nicolas Pitre <nico@fluxnic.net>, linux-ntfs-dev@lists.sourceforge.net,
 Muchun Song <muchun.song@linux.dev>, Roberto Sassu <roberto.sassu@huawei.com>,
 linux-f2fs-devel@lists.sourceforge.net,
 "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
 Jozef Martiniak <jomajm@gmail.com>, Eric Biederman <ebiederm@xmission.com>,
 Anna Schumaker <anna@kernel.org>, xu xin <cgel.zte@gmail.com>,
 Brad Warrum <bwarrum@linux.ibm.com>, Mike Kravetz <mike.kravetz@oracle.com>,
 Jingyu Wang <jingyuwang_vip@163.com>, linux-efi@vger.kernel.org,
 Dan Carpenter <error27@gmail.com>, Martin Brandenburg <martin@omnibond.com>,
 Tom Rix <trix@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
 Chris Mason <clm@fb.com>, linux-mtd@lists.infradead.org,
 Marc Dionne <marc.dionne@auristor.com>, linux-afs@lists.infradead.org,
 Ian Kent <raven@themaw.net>, Naohiro Aota <naohiro.aota@wdc.com>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
 linux-rdma@vger.kernel.org, Linyu Yuan <quic_linyyuan@quicinc.com>,
 coda@cs.cmu.edu, Viacheslav Dubeyko <slava@dubeyko.com>,
 Ilya Dryomov <idryomov@gmail.com>, Paolo Abeni <pabeni@redhat.com>,
 Alexey Dobriyan <adobriyan@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>,
 Zhihao Cheng <chengzhihao1@huawei.com>, Jens Axboe <axboe@kernel.dk>,
 Zeng Jingxiang <linuszeng@tencent.com>, Kees Cook <keescook@chromium.org>,
 Arnd Bergmann <arnd@arndb.de>, autofs@vger.kernel.org,
 Yifei Liu <yifeliu@cs.stonybrook.edu>, Damien Le Moal <dlemoal@kernel.org>,
 Eric Paris <eparis@parisplace.org>, ceph-devel@vger.kernel.org,
 Gao Xiang <xiang@kernel.org>, Jiangshan Yi <yijiangshan@kylinos.cn>,
 David Howells <dhowells@redhat.com>, linux-nfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, Song Liu <song@kernel.org>,
 samba-technical@lists.samba.org, Steve French <sfrench@samba.org>,
 Jeremy Kerr <jk@ozlabs.org>, netdev@vger.kernel.org,
 Bob Peterson <rpeterso@redhat.com>, linux-fsdevel@vger.kernel.org,
 bpf@vger.kernel.org, ntfs3@lists.linux.dev, linux-erofs@lists.ozlabs.org,
 "David S. Miller" <davem@davemloft.net>, ocfs2-devel@oss.oracle.com,
 jfs-discussion@lists.sourceforge.net,
 Dominique Martinet <asmadeus@codewreck.org>,
 Christian Schoenebeck <linux_oss@crudebyte.com>,
 Bob Copeland <me@bobcopeland.com>, KP Singh <kpsingh@kernel.org>,
 Oleg Kanatov <okanatov@gmail.com>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 Yuta Hayama <hayama@lineo.co.jp>, Andreas Dilger <adilger.kernel@dilger.ca>,
 Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
 Zhengchao Shao <shaozhengchao@huawei.com>,
 Chen Zhongjin <chenzhongjin@huawei.com>, Ard Biesheuvel <ardb@kernel.org>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
 Andreas Gruenbacher <agruenba@redhat.com>,
 Richard Weinberger <richard@nod.at>, Stefan Roesch <shr@devkernel.io>,
 cluster-devel@redhat.com, Jason Gunthorpe <jgg@ziepe.ca>,
 Jakub Kicinski <kuba@kernel.org>, Rik van Riel <riel@surriel.com>,
 Salah Triki <salah.triki@gmail.com>, Evgeniy Dushistov <dushistov@mail.ru>,
 linux-cifs@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
 Chao Yu <chao@kernel.org>, apparmor@lists.ubuntu.com,
 Josef Bacik <josef@toxicpanda.com>,
 "Liam R. Howlett" <Liam.Howlett@Oracle.com>, Tom Talpey <tom@talpey.com>,
 Hans de Goede <hdegoede@redhat.com>,
 "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
 Dave Chinner <dchinner@redhat.com>, David Sterba <dsterba@suse.com>,
 Xiubo Li <xiubli@redhat.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>,
 Juergen Gross <jgross@suse.com>, Johannes Thumshirn <jth@kernel.org>,
 Ritu Agarwal <rituagar@linux.ibm.com>,
 Luis de Bethencourt <luisbg@kernel.org>,
 Martin KaFai Lau <martin.lau@linux.dev>, v9fs@lists.linux.dev,
 "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
 linux-unionfs@vger.kernel.org, Ruihan Li <lrh2000@pku.edu.cn>,
 linux-security-module@vger.kernel.org, Erez Zadok <ezk@cs.stonybrook.edu>,
 Jeffle Xu <jefflexu@linux.alibaba.com>,
 "Dr. David Alan Gilbert" <linux@treblig.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Phillip Lougher <phillip@squashfs.org.uk>,
 Johannes Berg <johannes@sipsolutions.net>,
 Sungjong Seo <sj1557.seo@samsung.com>, David Woodhouse <dwmw2@infradead.org>,
 linux-karma-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 00/79] fs: new accessors for inode->i_ctime
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
Content-type: text/plain; charset="iso-8859-15"
Content-transfer-encoding: quoted-printable
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.kernel.org ~all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-GUID: 2IlbGBIpMEy2KeOvLLxW3mxg8GMfVy2J
X-Proofpoint-ORIG-GUID: 2IlbGBIpMEy2KeOvLLxW3mxg8GMfVy2J
X-Mailman-Approved-At: Thu, 22 Jun 2023 04:10:39 +0000
Reporting-Meta:
 AAGqbSy1pxusJ/YtaOVuTvO47SI+jqKWUixLsRAXSXhbDsr/SjvsGQt+4A2wiyLk
 6V/iYRBHegAXjG74mR2bcudPxCnUYFiVO7/dlGXln8k7xs+y7gdBgB18N7gCK75e
 BZZZaD0vP6SOrbye1owdr2Ixiu8MthOyyquo1RDQOpNw4ZlqGdJ4enmF99ZHKlYl
 cD6kxxQvpS/TPd1ld6092iT6O1iIX7wygd+grFN5vd5J8ScsKgexgdfrxKoJ1O6g
 cgVaSjV0RXJC1ytdAmVNyDGJl3KbGR3Fyb8GWGVCeaChAEAf+0Nk2dDAN4bRvqW5
 nBDQYPi4WpWM71//E/bFYC/rKnXNOqv8TFXFWZRCqNic45JzA/vMFpt5NAB1gOb6
 qotpjOJld5/Up2SRf2vsZ1rZSQPohkglIDGdwuJN9OLh1IDY0WiTTl2wAKHIGTVN
 CLBiAslXFE6UXS8AVuRI1T45HiCdwtQPRR5GR9edIK8GEACSu+cRmJ6tMl69odsX
 +KnpyFeXKKk6NbLBk1sTLOHke+7LainKNw83zqQNTKtt

On Wed, 2023-06-21 at 15:21 -0400, Steven Rostedt wrote:
> On Wed, 21 Jun 2023 10:45:05 -0400
> Jeff Layton <jlayton@kernel.org> wrote:
> =

> > Most of this conversion was done via coccinelle, with a few of the more
> > non-standard accesses done by hand. There should be no behavioral
> > changes with this set. That will come later, as we convert individual
> > filesystems to use multigrain timestamps.
> =

> BTW, Linus has suggested to me that whenever a conccinelle script is used,
> it should be included in the change log.
> =


Ok, here's what I have. I note again that my usage of coccinelle is
pretty primitive, so I ended up doing a fair bit of by-hand fixing after
applying these.

Given the way that this change is broken up into 77 patches by
subsystem, to which changelogs should I add it? I could add it to the
"infrastructure" patch, but that's the one where I _didn't_ use it.=A0

Maybe to patch #79 (the one that renames i_ctime)?


------------------------8<------------------------------
@@
expression inode;
@@

- inode->i_ctime =3D current_time(inode)
+ inode_set_current_ctime(inode)

@@
expression inode;
@@

- inode->i_ctime =3D inode->i_mtime =3D current_time(inode)
+ inode->i_mtime =3D inode_set_current_ctime(inode)

@@
struct inode *inode;
expression value;
@@

- inode->i_ctime =3D value;
+ inode_set_ctime(inode, value);

@@
struct inode *inode;
expression val;
@@
- inode->i_ctime.tv_sec =3D val
+ inode_set_ctime_sec(inode, val)

@@
struct inode *inode;
expression val;
@@
- inode->i_ctime.tv_nsec =3D val
+ inode_set_ctime_nsec(inode, val)

@@
struct inode *inode;
@@
- inode->i_ctime
+ inode_ctime_peek(inode)


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
