Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E1E9EB64D7
	for <ocfs2-devel@archiver.kernel.org>; Sat, 24 Jun 2023 02:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ZQfFDt+G5LrO6m7h4QWdhyaygF4a9tVq1bNaVr1jqyM=;
 b=FuT1eK8PlEHbtgG5/OGXCpm5EpBxo6CwPY10ZXYhdde+r+toQkg1CoCr1wXRu0b5jvEfZVfauo2k
   xpgC/KQGWTH3gHuwtV6kZJVWiMQcekcElNBzVNzIfTaPbPg+0Q9QQ4esDMbB633RSdwGIHmprp2A
   divDfzrXOUDDcXt2a5DFgf/uksjXSB7/M51OWH3Cbtt+W0dwyB09v2VKX7pB2o6rcjsBBswPaTRJ
   Yz3OqB/K0Z+HgQttTamsRD1kI7F/2T6tu3j1ivJzOffQUW7gHet+bE6ajtD2zsdPbOhrTMWf3kFT
   7jzkvM8iidwFw1GqIJc8d/mpV8iCg4/ARsMFvw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ZQfFDt+G5LrO6m7h4QWdhyaygF4a9tVq1bNaVr1jqyM=;
 b=Apl/Snja+j51Ljoj2rC9r92Lb3y/PP4ajcoHWM6Yhy++6Gm6NYk+CPc+gitOtFGvv4mVEbBcgPvp
   5LXO7+gK3IqQFlAs7ZrMXW2oKfzRAOO64u52eQmJK8BvpPdWZooqkxozmIAzsKvJXEa6NFkRXxj0
   52wIK6wJVEQzRQJjBCcjj8vEyogWpfGe3Dlx5Qn9VklE+1pgAatprerh+hQ7tyJwFBoUhe/OLm76
   QmHOdz9rMBOqpBkMJFmD/FZ3f4oSEvuBfTSFp9EXOXCaWk3XxoeoWTUFhvSIsRdMcjDYXKkpEZM6
   JTujUcqfBqjJFG5NaMewT6w7e9FxtHX/kxNglA==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWQ00OJWLEMR350@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 24 Jun 2023 02:54:22 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1687524146; bh=ljQRDIRYG4TydFhjD0LuSn8BREerPmb4Ipkpa2QAq6Q=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=apfm6xvoeO6UvUfxPwNSOl0FaLWJ7ShkzzPeuSOb0bank70626+jFCCnlqxUCd2NX
 mV+Eb3SlbyeKtShM0cPnGoccCVrProiQPYgaM4HyeW5epsbNbu8US+O9nrIP4r+ghW
 Y8FmG2CVOdPNZ1eNovI71PsOzsGS/p5EOkEcjtA4zTWfFdhpQkNKBq1hEMuzxsWytK
 w9zTBeB4xmhiyjllhLtRaoNC8lgBTTH19xNIsLsgb+18yFVUlxxLoSku7XQ5A1i1lR
 WF4IRekFC21BVGIj1AxyqNGVCxMph3jwY74VjiaGchsSc5v31PlBNGYvRkbk2aFmu+
 9KQZIm3JpdS0g==
Date: Fri, 23 Jun 2023 14:41:42 +0200
To: Jeff Layton <jlayton@kernel.org>
Message-id: <20230623-wegelagerei-kanzlei-45cdcf5da157@brauner>
References: <20230621144507.55591-1-jlayton@kernel.org>
 <20230621152141.5961cf5f@gandalf.local.home>
 <2a5a069572b46b59dd16fe8d54e549a9b5bbb6eb.camel@kernel.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <2a5a069572b46b59dd16fe8d54e549a9b5bbb6eb.camel@kernel.org>
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10750
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
 Eric Van Hensbergen <ericvh@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Trond Myklebust <trond.myklebust@hammerspace.com>,
 Anton Altaparmakov <anton@tuxera.com>,
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
 Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
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
 Steven Rostedt <rostedt@goodmis.org>, Yifei Liu <yifeliu@cs.stonybrook.edu>,
 Damien Le Moal <dlemoal@kernel.org>, Eric Paris <eparis@parisplace.org>,
 ceph-devel@vger.kernel.org, Gao Xiang <xiang@kernel.org>,
 Jiangshan Yi <yijiangshan@kylinos.cn>, David Howells <dhowells@redhat.com>,
 linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 Song Liu <song@kernel.org>, samba-technical@lists.samba.org,
 Steve French <sfrench@samba.org>, Jeremy Kerr <jk@ozlabs.org>,
 netdev@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
 linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org, ntfs3@lists.linux.dev,
 linux-erofs@lists.ozlabs.org, "David S. Miller" <davem@davemloft.net>,
 ocfs2-devel@oss.oracle.com, jfs-discussion@lists.sourceforge.net,
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
 linux-karma-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>
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
From: Christian Brauner via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Christian Brauner <brauner@kernel.org>
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: base64
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.kernel.org ~all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-GUID: Fwf1mSLZcxm91kd3v9aayF_tNjZPi_Qn
X-Proofpoint-ORIG-GUID: Fwf1mSLZcxm91kd3v9aayF_tNjZPi_Qn
X-Mailman-Approved-At: Fri, 23 Jun 2023 17:16:23 +0000
Reporting-Meta:
 AAGNQhxZ1qI8mzhrNFcrOUhgTi+Ua563zQxOt0CFvn/QxLxv5lNz6YIFnhbBr20Q
 Xh1QGDWamipyMkbHG3kxO3XgqlI6wUM5mUpLcqWjap65898fHc2fHxuO5NTYNRKv
 YYjV7EBs8mFuEbXM/M9UVLlgKQelpcJfewZhyI1uL3gbwVKJuyuY/Da/Mm4j4DBj
 naV0XI4pURn/a/PRYDR+xGmhh9NLTgjP2pyLnmViuL5vKxAU80GC6HFO8vZx+Cfo
 +Ejci5+Am3yNyIEySX0+3APZ0kjCrd0ge2lQoFcuXAQ94Jo/zQReDadjFiKJVKbY
 XJGJTWhYx+A334kEUPsR14Tm+72CWBbPcZY53EREYqr7Y5br0DtQbfkvI3clK+Bh
 M17d0qD9T77oiyOkiQN8jamQuPfLjpjPVYr5vhwH7XqAU9G7pF4M/mhbrYuDamXp
 oeDlZ4h6saglPGoDaTHtw2ZOGTlQDwif74CqZfngUjpAjeZGA7dDh6niFQ8ytURa
 /MD0aP0KNpGxOicxB0870aiUFLlVBEn0svKmTPhALKk=

T24gV2VkLCBKdW4gMjEsIDIwMjMgYXQgMDM6NTI6MjdQTSAtMDQwMCwgSmVmZiBMYXl0b24gd3Jv
dGU6Cj4gT24gV2VkLCAyMDIzLTA2LTIxIGF0IDE1OjIxIC0wNDAwLCBTdGV2ZW4gUm9zdGVkdCB3
cm90ZToKPiA+IE9uIFdlZCwgMjEgSnVuIDIwMjMgMTA6NDU6MDUgLTA0MDAKPiA+IEplZmYgTGF5
dG9uIDxqbGF5dG9uQGtlcm5lbC5vcmc+IHdyb3RlOgo+ID4gCj4gPiA+IE1vc3Qgb2YgdGhpcyBj
b252ZXJzaW9uIHdhcyBkb25lIHZpYSBjb2NjaW5lbGxlLCB3aXRoIGEgZmV3IG9mIHRoZSBtb3Jl
Cj4gPiA+IG5vbi1zdGFuZGFyZCBhY2Nlc3NlcyBkb25lIGJ5IGhhbmQuIFRoZXJlIHNob3VsZCBi
ZSBubyBiZWhhdmlvcmFsCj4gPiA+IGNoYW5nZXMgd2l0aCB0aGlzIHNldC4gVGhhdCB3aWxsIGNv
bWUgbGF0ZXIsIGFzIHdlIGNvbnZlcnQgaW5kaXZpZHVhbAo+ID4gPiBmaWxlc3lzdGVtcyB0byB1
c2UgbXVsdGlncmFpbiB0aW1lc3RhbXBzLgo+ID4gCj4gPiBCVFcsIExpbnVzIGhhcyBzdWdnZXN0
ZWQgdG8gbWUgdGhhdCB3aGVuZXZlciBhIGNvbmNjaW5lbGxlIHNjcmlwdCBpcyB1c2VkLAo+ID4g
aXQgc2hvdWxkIGJlIGluY2x1ZGVkIGluIHRoZSBjaGFuZ2UgbG9nLgo+ID4gCj4gCj4gT2ssIGhl
cmUncyB3aGF0IEkgaGF2ZS4gSSBub3RlIGFnYWluIHRoYXQgbXkgdXNhZ2Ugb2YgY29jY2luZWxs
ZSBpcwo+IHByZXR0eSBwcmltaXRpdmUsIHNvIEkgZW5kZWQgdXAgZG9pbmcgYSBmYWlyIGJpdCBv
ZiBieS1oYW5kIGZpeGluZyBhZnRlcgo+IGFwcGx5aW5nIHRoZXNlLgo+IAo+IEdpdmVuIHRoZSB3
YXkgdGhhdCB0aGlzIGNoYW5nZSBpcyBicm9rZW4gdXAgaW50byA3NyBwYXRjaGVzIGJ5Cj4gc3Vi
c3lzdGVtLCB0byB3aGljaCBjaGFuZ2Vsb2dzIHNob3VsZCBJIGFkZCBpdD8gSSBjb3VsZCBhZGQg
aXQgdG8gdGhlCj4gImluZnJhc3RydWN0dXJlIiBwYXRjaCwgYnV0IHRoYXQncyB0aGUgb25lIHdo
ZXJlIEkgX2RpZG4ndF8gdXNlIGl0LsKgCj4gCj4gTWF5YmUgdG8gcGF0Y2ggIzc5ICh0aGUgb25l
IHRoYXQgcmVuYW1lcyBpX2N0aW1lKT8KClRoYXQgd29ya3MuIEkgY2FuIGFsc28gcHV0IHRoaXMg
aW50byBhIG1lcmdlIGNvbW1pdCBvciBwciBtZXNzYWdlLgoKX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0Ck9jZnMy
LWRldmVsQG9zcy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9saXN0
aW5mby9vY2ZzMi1kZXZlbA==
