Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3039EC0015E
	for <ocfs2-devel@archiver.kernel.org>; Wed, 21 Jun 2023 16:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=2iLgJpOhgtKMbCfDckRM3au3qR6S+4knF3xs9G146mc=;
 b=K4EdxgAE9hj3yCk3e4w6OgL/92q52UFQ/i+W7LAafSqD7LfAkU1hOtsY4KKvBpqPfbC/9YHV7Moi
   MhMHjG7gZeERZZfKTizaNrafjGYw0YXVR3AjjwKGo7RyivUYAO7iC8KtU6Upl8VB77t5dhrlMjAR
   rOFt17IGVVsQWZglJeTHIUp7Ok48QItMPHaVlO/uXdd0ioarBvJpF6zJPoHYaHMXhGHa6iOrj3Vi
   8T4gOcr6wds3KuJPgxfKBjFpMcwPxz3Szu3kz0PN7YUc9XPCEHCKw1lbPTxIjt6x10rTdLHd9RfR
   yWt6yjHuB1qJOEYySvp4/lo1NiovnVlMFtbVGA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=2iLgJpOhgtKMbCfDckRM3au3qR6S+4knF3xs9G146mc=;
 b=Il+FOEZQpMAIURiBusLKxaEpHnKlR5aJZk/DcmoZsXFcBwMzGzyXAlkYGUj0a0RoLjQjzFAGblMu
   kTS189VvapjmuB6iu2SC8SeCQ1xxDkCSlx1o4u71v2mubtwpH6uVUQPhXz+E4wMQa2W1VHIU9b5l
   VG5uP57BM3Qai9pKtp274tWqkwTCI4mBIQdiFqKCXR/pb4N/8TDpT2cuuxw/POdyKBtS+/97Bfqv
   tvpS99ri4HtvJCsvdRuzu9y3N3i2klHdRRI6BApENt5Dnnaolnw0YRSXKmIcQhTclkRbcmxN1i1b
   jVF7vuJv6EMXWczgefhNubJqbVm/GISaKc/0vw==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWM00N1X23SFBD0@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 21 Jun 2023 16:07:04 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1687358744; bh=QciNdEX/PyL764MrYn7o3dC/r/b/XxL6Z8WOkZZO2JI=;
 h=From:To:Subject:Date:In-Reply-To:References:From;
 b=DW9+xZXPreiGHhWDzQhz3WX3mGR/hoBV4BdoUSGdAv1SFIQY2OlFGsFXe5YTCbCFz
 BR15LO6X+8VOz4uI3dADGbD0uhm8s2+O+4j7MgHyXZKIB90uQDbsYuepPjRyFF3B0B
 2S88vZc4u+0i13yohGMjh5aUO1xiGWGRa8WmDwIn7xIa6Wp2KMcljJfg3hIVIsXtwI
 PnOnQteXv2+zJ1j2KyYyBXTgj5whBFg1lvMWJyIj6Iu0U45Bl7KlDPY9zxLJTnkEzM
 WVhRqOkZnv8t+Jqrh38ZBCXmUl4Pasq/CpzYkhAM57nQJPwjZQCbu6T7NzstnyDGUj
 O9Kd+RU2DNxhA==
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
Date: Wed, 21 Jun 2023 10:45:06 -0400
Message-id: <20230621144507.55591-2-jlayton@kernel.org>
X-Mailer: git-send-email 2.41.0
In-reply-to: <20230621144507.55591-1-jlayton@kernel.org>
References: <20230621144507.55591-1-jlayton@kernel.org>
MIME-version: 1.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10748
 signatures=596816
Subject: [Ocfs2-devel] [PATCH 01/79] fs: add ctime accessors infrastructure
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
X-Proofpoint-GUID: Bjp9uvi1s1kZ-Kd0P1BBzOpjxknRRyse
X-Proofpoint-ORIG-GUID: Bjp9uvi1s1kZ-Kd0P1BBzOpjxknRRyse
X-Mailman-Approved-At: Wed, 21 Jun 2023 16:07:00 +0000
Reporting-Meta:
 AAFiIrD5wyxYdKb4pS9aYe7eajHl96r2BSUdWYPN2f+twrVpZHG+wbs/GPMPfv6O
 +/mV+H60eMbn6k9UOEqjQ2DvaaJBH+aHYHLUFhcwyihfWj/HuimeB/nnhY9UonIL
 0ykg+wiz7Js2BUniNhClzz73I6Wg5N3CAQEEnZKfSkn2b9DGYJhH5qZhh17igaX8
 OdmswVdLXUB5D5bRY3bClkg+xjf8UeysgBEBh5Bp3eOv47RGhoLV5IRIPo0GhErl
 qt7vfLops/A0M5AkO9irS31yyjglJmUw7APOvlLCqPdax018s0q8gSUUxALaBxsL
 4o2QxXXJLeyl2PHodXChl3GupxzHORNwLD0BcZ7D5MXAcey2Si6yaacbD+GSSVbC
 2/o7e6o1Xoi7kOVoIevX2SjX95DBG2TYvwe+sj62N76lm+Uk5567MC/aOMKUVYIw
 42Ol8V0WtesMoTxHxCGCZbXBPtfgNNtumaaASR8URh2RY8qJKIq/dnwYTe/g9hQj
 YjgsnegyPIckRmRcjpuC0nmDUyy/gt2XS/gQvkEEyx8=

struct timespec64 has unused bits in the tv_nsec field that can be used
for other purposes. In future patches, we're going to change how the
inode->i_ctime is accessed in certain inodes in order to make use of
them. In order to do that safely though, we'll need to eradicate raw
accesses of the inode->i_ctime field from the kernel.

Add new accessor functions for the ctime that we can use to replace them.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/inode.c         | 16 ++++++++++++++
 include/linux/fs.h | 53 +++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/fs/inode.c b/fs/inode.c
index d37fad91c8da..c005e7328fbb 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2499,6 +2499,22 @@ struct timespec64 current_time(struct inode *inode)
 }
 EXPORT_SYMBOL(current_time);
 
+/**
+ * inode_ctime_set_current - set the ctime to current_time
+ * @inode: inode
+ *
+ * Set the inode->i_ctime to the current value for the inode. Returns
+ * the current value that was assigned to i_ctime.
+ */
+struct timespec64 inode_ctime_set_current(struct inode *inode)
+{
+	struct timespec64 now = current_time(inode);
+
+	inode_set_ctime(inode, now);
+	return now;
+}
+EXPORT_SYMBOL(inode_ctime_set_current);
+
 /**
  * in_group_or_capable - check whether caller is CAP_FSETID privileged
  * @idmap:	idmap of the mount @inode was found from
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6867512907d6..9afb30606373 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1474,7 +1474,58 @@ static inline bool fsuidgid_has_mapping(struct super_block *sb,
 	       kgid_has_mapping(fs_userns, kgid);
 }
 
-extern struct timespec64 current_time(struct inode *inode);
+struct timespec64 current_time(struct inode *inode);
+struct timespec64 inode_ctime_set_current(struct inode *inode);
+
+/**
+ * inode_ctime_peek - fetch the current ctime from the inode
+ * @inode: inode from which to fetch ctime
+ *
+ * Grab the current ctime from the inode and return it.
+ */
+static inline struct timespec64 inode_ctime_peek(const struct inode *inode)
+{
+	return inode->i_ctime;
+}
+
+/**
+ * inode_ctime_set - set the ctime in the inode to the given value
+ * @inode: inode in which to set the ctime
+ * @ts: timespec value to set the ctime
+ *
+ * Set the ctime in @inode to @ts.
+ */
+static inline struct timespec64 inode_ctime_set(struct inode *inode, struct timespec64 ts)
+{
+	inode->i_ctime = ts;
+	return ts;
+}
+
+/**
+ * inode_ctime_set_sec - set only the tv_sec field in the inode ctime
+ * @inode: inode in which to set the ctime
+ * @sec:  value to set the tv_sec field
+ *
+ * Set the sec field in the ctime. Returns @sec.
+ */
+static inline time64_t inode_ctime_set_sec(struct inode *inode, time64_t sec)
+{
+	inode->i_ctime.tv_sec = sec;
+	return sec;
+}
+
+/**
+ * inode_ctime_set_nsec - set only the tv_nsec field in the inode ctime
+ * @inode: inode in which to set the ctime
+ * @nsec:  value to set the tv_nsec field
+ *
+ * Set the nsec field in the ctime. Returns @nsec.
+ */
+static inline long inode_ctime_set_nsec(struct inode *inode, long nsec)
+{
+	inode->i_ctime.tv_nsec = nsec;
+	return nsec;
+}
 
 /*
  * Snapshotting support.
-- 
2.41.0


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
