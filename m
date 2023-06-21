Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3214EB64D7
	for <ocfs2-devel@archiver.kernel.org>; Wed, 21 Jun 2023 19:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ueuli8tza4mm0wyF5gShhLajYIaShciLh1MqDZqI6xA=;
 b=tGFzR4ZLpxEzd+U2Rpr1q+fYhbRVtBRR1wp7wuWOWXj1kIolrHRV+U56sUGUa2r4qtX+oWmgNPia
   DoDncqBpozvFbK97CZMeWypVA7UL9FaJw4121/5Rp9ObDNy4Qy6L48AA49C1dcvjsiwQisfeIQ8T
   iwTHvgDT9qfvGvw+GXouD7L9m93XRDoXlixELNeyjnL1KBUTkHkU7Leqg5emJHX2i3VRLKZTWG7w
   A2nLUHiI2ocms6RZwceAvnUcWeFJAQjOeAfPBD5J01hgfqPFi+B6p09wEqWMm0CSiHJDjOhJEj6f
   Js1M1EnAlYVmH/mHLOdSDRjBuCspJQZfSdHfLA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ueuli8tza4mm0wyF5gShhLajYIaShciLh1MqDZqI6xA=;
 b=BWRv4iEK7fdRjtOsQfQCCE6zQLYNHaj9h0kGXMOP0+xHxjB+C2YFFflTQR82LDZFFYRKqkO0VsIq
   eVH2SZepCBa+PX/THnprGx7oODpaYlgzA1qeMGkO1QuzuTY1kE+mbZ8ikSE3VJqFsCFdCP65KqQS
   CTPtSykW9eCJxjZiQLIWdicXxGRva3kZjlSH7dun8MLXYizVxySEKC8Fa81/fuvf9rNsFxgYbdtf
   ShUFyz3wQHR7R/51APQj+ouFqHJLf8e0apdSsKw1l9i7mjc+Pm+ec23bbxzDCr7xb1t8d0NSV/ls
   3rOnCSGwX5n7prbt3e6PU5dcqBvUR/noZfEXwg==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWM00743B75HIF0@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 21 Jun 2023 19:23:29 +0000 (GMT)
Date: Wed, 21 Jun 2023 15:21:41 -0400
To: Jeff Layton <jlayton@kernel.org>
Message-id: <20230621152141.5961cf5f@gandalf.local.home>
In-reply-to: <20230621144507.55591-1-jlayton@kernel.org>
References: <20230621144507.55591-1-jlayton@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
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
 Arve =?UTF-8?B?SGrDuG5uZXY=?= =?UTF-8?B?w6Vn?= <arve@android.com>,
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
From: Steven Rostedt via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Steven Rostedt <rostedt@goodmis.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.kernel.org ~all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-GUID: Edgu8G_lSLxfHnI-1f4Mbq5S3N5g2PS8
X-Proofpoint-ORIG-GUID: Edgu8G_lSLxfHnI-1f4Mbq5S3N5g2PS8
X-Mailman-Approved-At: Wed, 21 Jun 2023 19:23:27 +0000
Reporting-Meta:
 AAGzmJaWRVjv5MzB5HBJe+NDv5IMG/YmC0evpO25tn8yfm2Tl93js/w+nPJpIf6v
 keMA5T1pYU33e3MEZBXxcimIguafb0EkKtQe52Qp14fs1nj+DlXZ3XdWxVRPbbKT
 Yd7xkU7e4Ad9QGlAjHmknK21AI7ed9ooTQdMA7wQsx5uUGr4M4WmPgswCrPvzX8d
 Dtn0jKuUHv0U0yWDS9HCvxt5c6/RIULIk6tP5fDfXVyvjt+0o1c4zrabRE+Wvoge
 1+X9mzxcIY90BOqPAlWoxZSACG54Dgf2iUX8CNz97PaHR4lvTKjxIvSVHNNXLFV1
 7YUiGGzyW9y7x9isUAvQ4NGYGGrztW7cnzqmrpIiGpRrYG60DPAh7kreNS2XJGHr
 69oKyBNLjspsprhpn+5yncLgy22IxXK7/QBByCbIzXKLVlpBM1VC6s2k7onwsuVF
 TTVZyGexus0zofcz+O+rUINPr1QmjVgNb6Ukj6hz6xHRk0ZaEaT+HBNEbMc7jwIY
 RQjig48ORaj/uQnbwr8/zZ6sGzIn90G5zL5T5xbQA+pMMg==

On Wed, 21 Jun 2023 10:45:05 -0400
Jeff Layton <jlayton@kernel.org> wrote:

> Most of this conversion was done via coccinelle, with a few of the more
> non-standard accesses done by hand. There should be no behavioral
> changes with this set. That will come later, as we convert individual
> filesystems to use multigrain timestamps.

BTW, Linus has suggested to me that whenever a conccinelle script is used,
it should be included in the change log.

-- Steve

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
