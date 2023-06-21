Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E4EFC001DE
	for <ocfs2-devel@archiver.kernel.org>; Wed, 21 Jun 2023 16:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=atJ8VS+/eZcq0mSmXpgX2UCAhH4CpQPb8NgeGpScMWc=;
 b=vZXD+CVkhNQNGS223XFCf1fT093M1wCaw8ON+7Slusx0nH+PbIWzjS3/+k9iZqdaDQ7kHTTTfi1f
   rHjgFOz7XWZgl9muPbaVopqjEB6OwxK54WtKSqehhBShnlAP+1KaD1gT75BUrovCkdZHOfBYEVmU
   8+KU5R8Gi0ZBcf4kPRCJzXwHRHregolCRo3bXhCbDZIeTyMGpQRi65hbNLF3M4Zd+PX/Z0DKJJKe
   HTG1s7HqqX/2MpXpuhSEgj7CahApqBYo0awSUGpT2LhH0rhyZ0KOKA9vnf20xQ7lAtqlFxLWZo5v
   YtEO38uDV0P8bxcqWKnzMfR61+0wWCey5ldaBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=atJ8VS+/eZcq0mSmXpgX2UCAhH4CpQPb8NgeGpScMWc=;
 b=tUXWdyt/x4HuyG24SeqBIgm3SE5UnvoGxiB5/reZdpAPVcYxP7c3k6nXT5iVWhEDAd2RkQJ66Lv6
   ROi8Nk1bkikj3eoiu55iu6pMAF4354B4J0rD7CXuDL8D3aSOs/h9n1hsPP68HAlwc/3aNqB/ypDT
   XeSs0/n1s9NoJ2ZjE4e4BxiTv197+mgbiH+iwrBDpvzhUXECCIT6WjWyasANPTjcGuiHRknshZ/g
   0E29Fzwce4nI2bWRd545HZC96xbrxWuZpl6tyBRv8+cLGqwH4cIR5DhSL9CcNuCIZs8//fCC35rb
   oR59yJkrv7rFZ+9o6c7wk+my3MtxCfpAEyTVYA==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWM00N2H23SFBD0@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 21 Jun 2023 16:07:04 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1687359018; bh=UjGkh/R6M6s97WmBHUYoIzUz4Kj0pfZWSOmlDakb56A=;
 h=From:To:Subject:Date:In-Reply-To:References:From;
 b=ISOE40fdFmyXRm/TIenvjT5UPIUlRpH8J3VXkqLNmMjonh3PxQUwms01/Yi03EFVs
 0Dbmg3MhBXszxfTG8IN5sJUV51G3yzr2l+xEcTv3UxHsR5GZVBA3Pc/bLeaVRh8Fky
 mQRivsDIFQLvh7PTD0UhMoUYUsH54SQx4XJdGS1uxlALaEHJ41U4mfrNqDh6Z2e9YU
 zstvKFH+ajE4gwTrV3FMYcl2On1Z4hs/04RbZRYmIvx2XCz/kBCMIDiaLQGhT43X6p
 101AKLQSNzXS+wnJ9GtxpEAGEEaK20+moMvm0BbrXzcVctbK1xXBMZeGaKBZrhVORb
 qMhsmnVxb8r6g==
To: Jeremy Kerr <jk@ozlabs.org>, Arnd Bergmann <arnd@arndb.de>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
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
 Jan Kara <jack@suse.com>, "Theodore Ts'o" <tytso@mit.edu>,
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
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
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
Date: Wed, 21 Jun 2023 10:49:58 -0400
Message-id: <20230621144959.57905-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.41.0
In-reply-to: <20230621144507.55591-1-jlayton@kernel.org>
References: <20230621144507.55591-1-jlayton@kernel.org>
MIME-version: 1.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10748
 signatures=596816
Subject: [Ocfs2-devel] [PATCH 79/79] fs: rename i_ctime field to __i_ctime
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
X-Proofpoint-GUID: VgX7gRJBQK_2-rnJVmR49mZbCT1TrjZx
X-Proofpoint-ORIG-GUID: VgX7gRJBQK_2-rnJVmR49mZbCT1TrjZx
X-Mailman-Approved-At: Wed, 21 Jun 2023 16:07:00 +0000
Reporting-Meta:
 AAGlxZP40KsGxSGObkLmWEE6uYu+R02FRcFwQV6s0KOC7rxxIQIUJwC91t0CK9US
 E3mh22n4SQU0COn5pIi0+gshg7YAYLOClAPUsYjRWkxnxK9fLrnCCtXnLkINhAN7
 ZuhZ+nNcO5wJhxJXC5n1KfgQ3M/IbyNOHC5a6rAswDDXcS8i6ipDs/Dgt107SXxC
 6a7NRB/ONCxQT98bEwNi1kR2Xioot2oGtAJhe1vVvD1OFw/JPT9xDMBy6cgzUPj8
 BwAhJRUKmkUYzG+EM6P9mtFAiNdQ9yxmL74ZSSKw8y4czXB6jHD5lNa6WMpxF2pG
 OIggnfjSAzCU1JLNdAh3i2yBCz1Fv5Ci20Y/bN85++/cQavek/vW+6LQrvygN/pe
 63T4FwKMoiO2ADJEk+KZ/XPJOBngCSsQu+AOPqjrGF9qNvw+UDOQsltxAd7NUx6V
 OAEd2XDTkwflECPK0TBDwqXKTk2PT7XTGVeRta/YP/q/y+kc2RWNIm4MfXXiieE2
 TKN1OorWIkDvNlTAu8Jhm0Gs1UpKtvjTgHUp5qrOYpI=

Now that everything in-tree is converted to use the accessor functions,
rename the i_ctime field in the inode to make its accesses more
self-documenting.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/fs.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9afb30606373..2ca46c532b49 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -642,7 +642,7 @@ struct inode {
 	loff_t			i_size;
 	struct timespec64	i_atime;
 	struct timespec64	i_mtime;
-	struct timespec64	i_ctime;
+	struct timespec64	__i_ctime; /* use inode_ctime_* accessors! */
 	spinlock_t		i_lock;	/* i_blocks, i_bytes, maybe i_size */
 	unsigned short          i_bytes;
 	u8			i_blkbits;
@@ -1485,7 +1485,7 @@ struct timespec64 inode_ctime_set_current(struct inode *inode);
  */
 static inline struct timespec64 inode_ctime_peek(const struct inode *inode)
 {
-	return inode->i_ctime;
+	return inode->__i_ctime;
 }
 
 /**
@@ -1497,7 +1497,7 @@ static inline struct timespec64 inode_ctime_peek(const struct inode *inode)
  */
 static inline struct timespec64 inode_ctime_set(struct inode *inode, struct timespec64 ts)
 {
-	inode->i_ctime = ts;
+	inode->__i_ctime = ts;
 	return ts;
 }
 
@@ -1510,7 +1510,7 @@ static inline struct timespec64 inode_ctime_set(struct inode *inode, struct time
  */
 static inline time64_t inode_ctime_set_sec(struct inode *inode, time64_t sec)
 {
-	inode->i_ctime.tv_sec = sec;
+	inode->__i_ctime.tv_sec = sec;
 	return sec;
 }
 
@@ -1523,7 +1523,7 @@ static inline time64_t inode_ctime_set_sec(struct inode *inode, time64_t sec)
  */
 static inline long inode_ctime_set_nsec(struct inode *inode, long nsec)
 {
-	inode->i_ctime.tv_nsec = nsec;
+	inode->__i_ctime.tv_nsec = nsec;
 	return nsec;
 }
 
-- 
2.41.0


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
