Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94548C001DF
	for <ocfs2-devel@archiver.kernel.org>; Wed, 21 Jun 2023 16:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=OFFqPdM8M84uFfzrh0utgNNfoCNf92luAqxWXZa6wP8=;
 b=L92zIGKEz/I+VKeOR7TpjC8KJd9VjSU/OG9vM63tbRsz6UQh2N5A7ZsNO6vBqzd9bBmZyP4bTE8F
   Uzg/6y+vv+fzBZCMte3T5YzX6YAMpUTgN5lZSQ+3tTUm06t/OW/H76HOFuGj3oJMTtJgDo3EIBM/
   9Ob6D9ZLB7zRq9T8QannkDSIfqqW9osPsjvHEOwLuXFdLRQ1ssn/zMdtshjEPWX2riW5t37fsaiZ
   P0QGeSFQ9M5gKnJk4Cq/lWHYrGdofE0Q6mGnqq+n7lZ8283KRPplv+C6ur/PhrmzeAX/Ui/WWF3M
   pQA/i5OMyM2lsqAzAIfF5sjzwNaz6Ro/l9T5aA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=OFFqPdM8M84uFfzrh0utgNNfoCNf92luAqxWXZa6wP8=;
 b=CCUuXuc8Q60Lke/4p9DyTF6umlUzBfv5sG7xX+ZBnUyfmNi6GhUM4rGyG27x0Macu90HQQPEC6iW
   Vl1+wPJxQ9JC18n1CgSWj328IOsovvAdtRqWX0p6E+HuwggR6qjHgZ4IMDqqN+ayXwTOw7UGuj3z
   Pgj3EDWTxa7QPtvwp5oDCIwy4l/ODqui0xd7kmSR4SLBz05Jdxzzde309pXgZZUF0tjnjZe/jm7n
   CA3own2+8qcIGUvDp5lJwzYfTvUxAeZURI4uAS98R4tEf6NmQU9Vh3WzZLbM+BNQhTu563rLCY8k
   fbCggsPBQ5uti8GS3HfB4SkAK7rKhT8Z2naZWQ==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWM00GJL23TGR20@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 21 Jun 2023 16:07:05 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
 s=mail20170921; t=1687355033; bh=SetH/myydi6dk+ldkx72EVQztsegim0VSf5FSMMJW28=;
 h=Date:From:To:CC:Subject:In-Reply-To:References:From;
 b=PTZBv1Kz5BEVObNa7leJ/yxGfQakTivesF5jb6tBj4a7mw0z2DwCV8KG/lz6Htp2A
 zjthU/P8T1sIWZ42nVHC5ArvGqiQK48scKj0Re/P/DwFQFC0M/FPQnfLTFYC/Ucswv
 L2oK3I/5AOGeZQ+wBCu+TIiCshDxA9TJNwfHFkfQ=
Date: Wed, 21 Jun 2023 15:43:48 +0200
To: Jani Nikula <jani.nikula@linux.intel.com>
Message-id: <20230621134348.rcdzl7fi7yq2uj6h@localhost>
MIME-version: 1.0
In-reply-to: <878rcd2by5.fsf@intel.com>
X-Originating-IP: [106.210.248.248]
References: <20230621091000.424843-1-j.granados@samsung.com>
 <CGME20230621094824eucas1p2b6adfbd3f15ff3665674917f419b25d3@eucas1p2.samsung.com>
 <20230621094817.433842-1-j.granados@samsung.com> <87o7l92hg8.fsf@intel.com>
 <20230621130614.s36w4u7dzmb5d5p3@localhost> <878rcd2by5.fsf@intel.com>
X-Source-IP: 210.118.77.11
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10747
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 adultscore=0 priorityscore=442 bulkscore=0 suspectscore=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 impostorscore=0 clxscore=166
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306210115 domainage_hfrom=10431
Cc: Juri Lelli <juri.lelli@redhat.com>, Miaohe Lin <linmiaohe@huawei.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, dri-devel@lists.freedesktop.org,
 Ben Segall <bsegall@google.com>, linux-sctp@vger.kernel.org,
 ocfs2-devel@oss.oracle.com, Miquel Raynal <miquel.raynal@bootlin.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 "K. Y. Srinivasan" <kys@microsoft.com>,
 Stefan Schmidt <stefan@datenfreihafen.org>, Wei Liu <wei.liu@kernel.org>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Michael Ellerman <mpe@ellerman.id.au>, bridge@lists.linux-foundation.org,
 James Morris <jmorris@namei.org>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, Eric Biggers <ebiggers@kernel.org>,
 linux-cachefs@redhat.com, Mel Gorman <mgorman@suse.de>,
 Waiman Long <longman@redhat.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Petr Mladek <pmladek@suse.com>, Martin Schiller <ms@dev.tdt.de>,
 Russ Weight <russell.h.weight@intel.com>,
 Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
 Boqun Feng <boqun.feng@gmail.com>, Nicholas Piggin <npiggin@gmail.com>,
 John Ogness <john.ogness@linutronix.de>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>,
 Remi Denis-Courmont <courmisch@gmail.com>, xen-devel@lists.xenproject.org,
 Thomas Gleixner <tglx@linutronix.de>,
 Trond Myklebust <trond.myklebust@hammerspace.com>,
 Anton Altaparmakov <anton@tuxera.com>, Christian Brauner <brauner@kernel.org>,
 Will Drewry <wad@chromium.org>, Neil Horman <nhorman@tuxdriver.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
 Ralf Baechle <ralf@linux-mips.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, mcgrof@kernel.org,
 Chuck Lever <chuck.lever@oracle.com>, netfilter-devel@vger.kernel.org,
 Masami Hiramatsu <mhiramat@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
 linux-fsdevel@vger.kernel.org, Matthieu Baerts <matthieu.baerts@tessares.net>,
 linux-trace-kernel@vger.kernel.org, linux-wpan@vger.kernel.org,
 Mark Rutland <mark.rutland@arm.com>, linux-aio@kvack.org,
 "Jason A. Donenfeld" <Jason@zx2c4.com>, linux-ia64@vger.kernel.org,
 Naoya Horiguchi <naoya.horiguchi@nec.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Clemens Ladisch <clemens@ladisch.de>, Phillip Potter <phil@philpotter.co.uk>,
 Song Liu <song@kernel.org>, Eric Dumazet <edumazet@google.com>,
 keyrings@vger.kernel.org, John Stultz <jstultz@google.com>,
 Stanislav Fomichev <sdf@google.com>, Jan Karcher <jaka@linux.ibm.com>,
 codalist@telemann.coda.cs.cmu.edu, linux-s390@vger.kernel.org,
 Valentin Schneider <vschneid@redhat.com>,
 Stefano Stabellini <sstabellini@kernel.org>, Corey Minyard <minyard@acm.org>,
 Leon Romanovsky <leon@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 Will Deacon <will@kernel.org>, John Fastabend <john.fastabend@gmail.com>,
 Andrii Nakryiko <andrii@kernel.org>,
 Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
 Mat Martineau <martineau@kernel.org>, Matthew Bobrowski <repnop@google.com>,
 Julian Anastasov <ja@ssi.bg>, coreteam@netfilter.org,
 Roopa Prabhu <roopa@nvidia.com>, Yonghong Song <yhs@fb.com>,
 Iurii Zaikin <yzaikin@google.com>, Sven Schnelle <svens@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Mike Travis <mike.travis@hpe.com>,
 Wenjia Zhang <wenjia@linux.ibm.com>, Simon Horman <horms@verge.net.au>,
 Xin Long <lucien.xin@gmail.com>, linux-arm-kernel@lists.infradead.org,
 fsverity@lists.linux.dev, Hao Luo <haoluo@google.com>,
 Theodore Ts'o <tytso@mit.edu>, Stephen Boyd <sboyd@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Florian Westphal <fw@strlen.de>,
 Robin Holt <robinmholt@gmail.com>, "David S. Miller" <davem@davemloft.net>,
 Jon Maloy <jmaloy@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>,
 Eric Biederman <ebiederm@xmission.com>, Anna Schumaker <anna@kernel.org>,
 Daniel Bristot de Oliveira <bristot@redhat.com>,
 Mike Kravetz <mike.kravetz@oracle.com>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-hams@vger.kernel.org,
 Nikolay Aleksandrov <razor@blackwall.org>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Alexei Starovoitov <ast@kernel.org>, Marc Dionne <marc.dionne@auristor.com>,
 Jiri Slaby <jirislaby@kernel.org>, linux-afs@lists.infradead.org,
 Daniel Borkmann <daniel@iogearbox.net>, linux-rdma@vger.kernel.org,
 Dexuan Cui <decui@microsoft.com>, lvs-devel@vger.kernel.org, coda@cs.cmu.edu,
 Doug Gilbert <dgilbert@interlog.com>,
 "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Paolo Abeni <pabeni@redhat.com>, Pablo Neira Ayuso <pablo@netfilter.org>,
 "Serge E. Hallyn" <serge@hallyn.com>, Kees Cook <keescook@chromium.org>,
 Arnd Bergmann <arnd@arndb.de>, Haiyang Zhang <haiyangz@microsoft.com>,
 intel-gfx@lists.freedesktop.org, Steven Rostedt <rostedt@goodmis.org>,
 linux-crypto@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>,
 openipmi-developer@lists.sourceforge.net, mptcp@lists.linux.dev,
 Jan Harkes <jaharkes@cs.cmu.edu>, linux-nfs@vger.kernel.org,
 linux-mm@kvack.org, Jeff Layton <jlayton@kernel.org>,
 Andy Lutomirski <luto@amacapital.net>, linux-xfs@vger.kernel.org,
 linux-ntfs-dev@lists.sourceforge.net, netdev@vger.kernel.org,
 Ying Xue <ying.xue@windriver.com>, bpf@vger.kernel.org,
 Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Alexander Aring <alex.aring@gmail.com>, Jan Kara <jack@suse.cz>,
 Steve Wahl <steve.wahl@hpe.com>, Peter Zijlstra <peterz@infradead.org>,
 Balbir Singh <bsingharora@gmail.com>, Amir Goldstein <amir73il@gmail.com>,
 KP Singh <kpsingh@kernel.org>, David Howells <dhowells@redhat.com>,
 "H. Peter Anvin" <hpa@zytor.com>, David Airlie <airlied@gmail.com>,
 Steffen Klassert <steffen.klassert@secunet.com>, rds-devel@oss.oracle.com,
 Herbert Xu <herbert@gondor.apana.org.au>, linux-scsi@vger.kernel.org,
 dccp@vger.kernel.org, x86@kernel.org, Russell King <linux@armlinux.org.uk>,
 Jason Gunthorpe <jgg@ziepe.ca>, Ingo Molnar <mingo@redhat.com>,
 Jakub Kicinski <kuba@kernel.org>, "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Joerg Reuter <jreuter@yaina.de>, linux-hyperv@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>,
 Santosh Shilimkar <santosh.shilimkar@oracle.com>, apparmor@lists.ubuntu.com,
 linux-raid@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
 Juergen Gross <jgross@suse.com>, John Johansen <john.johansen@canonical.com>,
 linux-x25@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 David Ahern <dsahern@kernel.org>, kexec@lists.infradead.org,
 linux-security-module@vger.kernel.org, Benjamin LaHaise <bcrl@kvack.org>,
 tipc-discussion@lists.sourceforge.net, Daniel Vetter <daniel@ffwll.ch>,
 Martin KaFai Lau <martin.lau@linux.dev>, Karsten Graul <kgraul@linux.ibm.com>
Subject: Re: [Ocfs2-devel] [PATCH 09/11] sysctl: Remove the end element in
 sysctl table arrays
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
From: Joel Granados via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Joel Granados <j.granados@samsung.com>
Content-type: multipart/mixed; boundary="===============5762931412456102791=="
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-AuditID: cbfec7f4-993ff70000022c38-ba-6492fe983db1
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker:
 H4sIAAAAAAAAA2WTW1BTVxSGZ587aJgj2rpHazvibaYK1lbrcixWKw+now+obacXOxXljFgh
 aCJW61i5WRBEIIRyEeUmFyUIpCGKIlIGQyJyEaigImKIjRhEEJHBSCjx4NSZvn1rrf/fa/0P
 myPdM7hZ3C75PlEh9wv0YFwpvWG00TPVofL/KCbbC8rqexkwtucQkFGiYaD5fBGCEftJEiq0
 OhrCDFk0jKkMLMQ4dBQMhB8lQaMLI6BnrIaBoVLHhFdzl4WWnr8ZSOkNo6BTZWVh/J6VgKEH
 Vhpys1+QMNYey0BVajEDxZWvSNDHTey4dUEA2+lzCCzxZhry7h6joS1/gIGC1hIEaalGBPeH
 zRTUqtNJeGUsY+BefDIFN2KD4HL9MAHlneEMWKviCGjWn6DBUlTOgvplHgnqP8IRaHtu0XC/
 a5SAyismClovZTDQpRmnISo6A0FCdgQJD7NsNAwcNzNQW9JAQfWVTAT2EQcN9QYjBeaSpwQ0
 XSqmISLzGQl57TcJiE1MYaExbpyEwhv/ENCR8BCt9Rda2zYII0dPUILmtAYJ9pcqJPQ3mpBw
 MvQmJWTVbhSGbzcSQk5vKCV05lUgoeS2ihESI/pZoSL9HitEVt1hhSxtiPCqpoz1Xfa962f+
 YuCu/aJi6ZptrgGJCVXUngbPA1E9DXQoapsfg1w4zC/HpsGLdAxy5dz5QoRz04oZqXiOcJLZ
 RDhV7vwQwg8u7H3jKOoZoiRRAcJnHMmEVEyIdFfqJiflCF9LMTBOC8UvwN2Jx18/xfBLcFNf
 J+nkGbwnLu6wvF5O8i2rcJS2FjkH0/nNODInmo1BHCfjV+KebqWzLeOnYVOahXIyyR/AlsYz
 lFNC8rNxgYNzogu/CFtMjHToPNxelTvJh/F13R1C4ttTsbmfl9gHjyZbSYmn48d1Olbi9/B4
 RebrXJhPQviqY4CViiKE88OGJ19ajSPbLJOOddiYc41xHoF5N9zxZJp0phtW6VNIqS3D0b+7
 S+qFuKirj0pA89LfCpb+VrD0/4JJ7SU46/Iz5n/txTg/20ZK7I3Pn39KZSH2HJophiiDdorK
 j+XiL15KvyBliHyn147gIC2a+LT1jrrnF1HB40GvGkRwqAbNnzCbS4ua0SxKHiwXPWbI5mhV
 /u4yf7+Dv4qK4J8UIYGisgbN5iiPmbLF3qYd7vxOv33iblHcIyreTAnOZVYosTqg+VTHWiqy
 qzri2Q7LlqSFtrGywk+8Kw/0lh1pUtu/ePIofDDJNb5PvTdD/UGQm2JTqdYe20Q+mrv5UHLA
 ok6NbaBy69V9hxvmeKcd2xu74uCUIxfclvpTvu+juS6KbaPd3707uPLP/V//BqsfLgiZoVpi
 sPWRqPaH+nVHfHJa1se7kJV5chfllNGXoRvW+xgNZ6H7RRhwLXG+ioPb/rLLSruXi562UaN+
 e/gLeS5XoIwN1q+yfxn2zkjfV9/upkqZQ2cPX1Y/7d9ivV4yHLnix9aN6sLcT+uqZds/13+z
 qY0oD6xes195SZbJW1edWhF6A8WPLLp/a+vP5MzH+dEmHTfVg1IG+C37kFQo/f4FCuwQMC8F AAA=
X-Brightmail-Tracker:
 H4sIAAAAAAAAA2WTe0xTVxzHc+69va3GujtEvSIzrLJsQyiWh/4YymbcsrvNxM0EzXCiHdwp
 QVrWApkaHUKrUMRhEygrpgJaHPbBQ0DFwUxlIHNB5aniHBYUeaNQHGLbtXbLTPbPyed8z/f7
 ze+c5PBwr1quDy9BksLKJOK9AnI+cd3Rcj9I41DHr86f9YGq60MkXOspxeBkhZEES/pauGk2
 IHg2V4TD5ce9BCgvOQm4VF3DgcPNxRywq5u5MD3bywWVo4aAyQwlDsaawxj02y0kTFU6XEtT
 CwkjV58iuGZ0+dr7u0jQDB0m4OTQ71yYKDuG4J56kAvOPwYxOHPtAQYzxtsYXDaPY2C/dBSH
 qQeDHHDWncDhdMkMDo8rjyI4eUNBgL0nh4RGRTWCxkITCeMZcwQ8zKvFoWNgIXTaJkgw1ysx
 V1TBBdPPL3B42GzlQrbVSUJdrutWE5mxcFM7w4HM0xUkdF9gwNLyCxdGdOcQ5Az7QmatDUFB
 1VIoyjuPwcAPVg4UaTIx0Pdmc6CzbJKEsx0VCNSzeeiDXxHT0fkZ80x5nGD+HLUTjFFndEnd
 t3Bm7rkaMXetNpwZb2tFjM54gNGm55JMUfotgilu2sTY7rRhzPPZAKam/A7G5DQN459HxwjX
 yaSpKazfHqk8Zb1guwhChKIIEIaERQhFoWt3vBcSLgiOWhfP7k1IY2XBUbuEexrmfsOTrwd9
 p5lyonTU7q9C83g0FUYb+qcIN3tRekSnGyI9ui9dNd3F8fAi+kW3ilSh+S7PE0TXmBTIs6lF
 9HThDHK7COotuu/EMczNJBVI3xi9h7vZmwqiTbcHOO4ATrVF0IqxTtJ9sIjaQitKs7gqxOPx
 qbV0f5/cU2rA6Jz6updhPvU63frjwMvxcCqNftQwhrn9OLWcPuvguXEe9TY90Ep6Bl1J9zSe
 /ocP0lP2RygPLdK+UqR9pUj7X5FHDqBvO4b+L6+iy0pGcA+vp83mCaIYcc8hbzZVnrQ7SS4S
 ysVJ8lTJbmGcNKkauf5MXfPs+YtIN/xEaEEYD1mQvytprTTcRD6ERCphBd78N6rV8V78ePG+
 /axMulOWupeVW1C46xFP4D6L46SuDyhJ2SlaszpcFLYmYnV4xJpQwVL+J8lZYi9qtziFTWTZ
 ZFb2bw7jzfNJx14rj+b39kWHUfmOwWfLtqZtKGyK2bbxHWnDzMXEzE11On/O05KqRCx0eeQB
 ZXP9l2Oxm6vaskb2ZSyMexRZNmPSKg853/dTHrlq74oZ1dbtutUbW5zNDRgwtK/aMCeub7d2
 bKwONvM+1G1eqf0mkPatXcCUSFZsbeHXLo61Zx+q2h83zbdEPezeVZ4xaFI1bHkQ/ldfiGVs
 27vOj5fs32LjHLm7zP/rLzhj7UFXZj/1zzhlL8hv/Oin7G8XKy/c//7UxX1nkjQamyC49Yq+
 QFauN43qo1dszxO9GT/Sn39wSUJRaWxkSaC5O+as/fHWxEnbAi8/UbI5IumrxDv6hNwd00Jm
 SEDI94hFAbhMLv4bHgGuKMgEAAA=
X-CMS-MailID: 20230621134351eucas1p2fb0148f4fe396dbbd6919e2c6f9d997c
X-Msg-Generator: CA
X-RootMTR: 20230621094824eucas1p2b6adfbd3f15ff3665674917f419b25d3
X-EPHeader: CA
X-CMS-RootMailID: 20230621094824eucas1p2b6adfbd3f15ff3665674917f419b25d3
X-ServerName: mailout1.w1.samsung.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.samsung.com ~all
X-Spam: Clean
X-Proofpoint-GUID: ZS4rH18CKRQcaFIG8xxWsyvIYMSH3D4a
X-Proofpoint-ORIG-GUID: ZS4rH18CKRQcaFIG8xxWsyvIYMSH3D4a
X-Mailman-Approved-At: Wed, 21 Jun 2023 16:07:00 +0000
Reporting-Meta:
 AAETGEIYig83gG/Jw/MgwhuBmoQfw3RN1PXcvGzYTzGO4lZZJ1LLjsT9fC1/Oi9h
 ZS630/Tdf6K2tToIoOfYBGhVcUmi2n2Ko/eHx1Mf4k1ijf/1MXf/DKW6MO6zqocE
 aMqURt062mgNXK0oN/fDSOeeagrd1V1e3pkE7pbZyO121p6/rdWiHj9ChoPUlLZD
 kdbdkDJV5yPDtkIh6lx3yYJ6pPVAyUGNHpjAGGm31UphKtnaejad3SL7MjrnpV9G
 i+Ay84m3pIBIZTXJptNUQNk95GZYOlSjDf5N4mMMcmWP9KttXJBDD0A+qin3KPBL
 2amEOlPpKYleuVfWD/D3vjDRGdG9qzMi9cQa7GbSnxl8DXsSwtwyNErEhU8sbWlB
 MvdVEgcE42ZTw/7kJBXM47j+ySR3LVeB1fM55BnvXp5gcr3GhN3qbWNNYY/SW6m3
 Hf8Ei4WHOReCCSUkrziLikDjzMiT6RcFiVpc5xTe2a4JkJoJVmnWBJQZsRHRGaoD
 5SCR90Fwv9H9ybWlhZLAPRAV2XXglSJWCoVmNZyCIgo=
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20230621134353euoutp018c6ff8dabdeed1eb9c37b5ba647c330d~qsHZ_CVub2580325803euoutp01E
CMS-TYPE: 201P

--===============5762931412456102791==
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="nwcq3i6cyedok5cv"
Content-Disposition: inline

--nwcq3i6cyedok5cv
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 21, 2023 at 04:15:46PM +0300, Jani Nikula wrote:
> On Wed, 21 Jun 2023, Joel Granados <j.granados@samsung.com> wrote:
> > On Wed, Jun 21, 2023 at 02:16:55PM +0300, Jani Nikula wrote:
> >> On Wed, 21 Jun 2023, Joel Granados <j.granados@samsung.com> wrote:
> >> > Remove the empty end element from all the arrays that are passed to =
the
> >> > register sysctl calls. In some files this means reducing the explicit
> >> > array size by one. Also make sure that we are using the size in
> >> > ctl_table_header instead of evaluating the .procname element.
> >>=20
> >> Where's the harm in removing the end elements driver by driver? This is
> >> an unwieldy patch to handle.
> >
> > I totally agree. Its a big one!!! but I'm concerned of breaking bisecti=
bility:
> > * I could for example separate all the removes into separate commits and
> >   then have a final commit that removes the check for the empty element.
> >   But this will leave the tree in a state where the for loop will have
> >   undefined behavior when it looks for the empty end element. It might
> >   or might not work (probably not :) until the final commit where I fix
> >   that.
> >
> > * I could also change the logic that looks for the final element,
> >   commit that first and then remove the empty element one commit per
> >   driver after that. But then for all the arrays that still have an
> >   empty element, there would again be undefined behavior as it would
> >   think that the last element is valid (when it is really the sentinel).
> >
> > Any ideas on how to get around these?
>=20
> First add size to the register calls, and allow the last one to be
> sentinel but do not require the sentinel.
>=20
> Start removing sentinels, adjusting the size passed in.
This is a great idea! and I think I don't even have to adjust the size
because if I change the logic to stop on the sentinel or the size; so when
the sentinel is there, it will stop before the size. And when the
sentinel is not there, it will stop on the correct size.

There might be issues with indirection calls. And there might also be
lots of places where I need to adjust a for loop (as dan has pointed
out) but its worth a try for V2.

Best
>=20
> Once enough sentinels have been removed, add warning if the final entry
> is a sentinel.
>=20
> Never really remove the check? (But surely you can rework the logic to
> not count the number of elements up front, only while iterating.)
>=20
>=20
> BR,
> Jani.
>=20
> >>=20
> >> > diff --git a/drivers/gpu/drm/i915/i915_perf.c b/drivers/gpu/drm/i915=
/i915_perf.c
> >> > index f43950219ffc..e4d7372afb10 100644
> >> > --- a/drivers/gpu/drm/i915/i915_perf.c
> >> > +++ b/drivers/gpu/drm/i915/i915_perf.c
> >> > @@ -4884,24 +4884,23 @@ int i915_perf_remove_config_ioctl(struct drm=
_device *dev, void *data,
> >> > =20
> >> >  static struct ctl_table oa_table[] =3D {
> >> >  	{
> >> > -	 .procname =3D "perf_stream_paranoid",
> >> > -	 .data =3D &i915_perf_stream_paranoid,
> >> > -	 .maxlen =3D sizeof(i915_perf_stream_paranoid),
> >> > -	 .mode =3D 0644,
> >> > -	 .proc_handler =3D proc_dointvec_minmax,
> >> > -	 .extra1 =3D SYSCTL_ZERO,
> >> > -	 .extra2 =3D SYSCTL_ONE,
> >> > -	 },
> >> > +		.procname =3D "perf_stream_paranoid",
> >> > +		.data =3D &i915_perf_stream_paranoid,
> >> > +		.maxlen =3D sizeof(i915_perf_stream_paranoid),
> >> > +		.mode =3D 0644,
> >> > +		.proc_handler =3D proc_dointvec_minmax,
> >> > +		.extra1 =3D SYSCTL_ZERO,
> >> > +		.extra2 =3D SYSCTL_ONE,
> >> > +	},
> >> >  	{
> >> > -	 .procname =3D "oa_max_sample_rate",
> >> > -	 .data =3D &i915_oa_max_sample_rate,
> >> > -	 .maxlen =3D sizeof(i915_oa_max_sample_rate),
> >> > -	 .mode =3D 0644,
> >> > -	 .proc_handler =3D proc_dointvec_minmax,
> >> > -	 .extra1 =3D SYSCTL_ZERO,
> >> > -	 .extra2 =3D &oa_sample_rate_hard_limit,
> >> > -	 },
> >> > -	{}
> >> > +		.procname =3D "oa_max_sample_rate",
> >> > +		.data =3D &i915_oa_max_sample_rate,
> >> > +		.maxlen =3D sizeof(i915_oa_max_sample_rate),
> >> > +		.mode =3D 0644,
> >> > +		.proc_handler =3D proc_dointvec_minmax,
> >> > +		.extra1 =3D SYSCTL_ZERO,
> >> > +		.extra2 =3D &oa_sample_rate_hard_limit,
> >> > +	}
> >> >  };
> >>=20
> >> The existing indentation is off, but fixing it doesn't really belong in
> >> this patch.
> >
> > Agreed. But I actually was trying to fix something that checkpatch
> > flagged. I'll change these back (which will cause this patch to be
> > flagged).
> >
> > An alternative solution would be to fix the indentation as part of the
> > preparation patches. Tell me what you think.
> >
> > Thx
> >
> >>=20
> >> BR,
> >> Jani.
> >>=20
> >>=20
> >> --=20
> >> Jani Nikula, Intel Open Source Graphics Center
>=20
> --=20
> Jani Nikula, Intel Open Source Graphics Center

--=20

Joel Granados

--nwcq3i6cyedok5cv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmSS/pIACgkQupfNUreW
QU8FZgv+NJjIGObr29DU3w9gC84AcnW6dJTp9wHS00NxSXpo+c714JQ2xV0z8i/m
wZbyBR21D/CkjJCTL0pwjCh1xi+PdMHmpB9mDlQSxEg6i+fJXBb7GvWvkOfNagP8
Z2t/NzP/RPP+/BjBP3QOGNyQWgZ4Jl6lMvzlt0aJlHMx7/QD7PRgnNN3KYiFzB+I
FTf5QLbTT85TSPPoGBQCzF6Ych5vKNmIzRZxD2o1zPJFftGIcYOfYOC7vX/1tuOa
1l2+maHSi22uTAHFL3XKvcQBxuLeBCoAIgYOGeO0B+wApLgDVUdHb3PPMw74sOuD
RtgKG6gEgO937g+zKo5xP6M5iLH8xYavJRYPNGH5FBfL7DDROXI6t9tjBpvpUbPS
VQDducT3r8p7hbIhb+3MnRgJri1yF7SjRZF6iewJ9G3Rd7o8PlcLC3aTZLvilO9j
4YYKID1bOqsI9tcLY5oeM6HROqdmLhzFQQlzZCCz4Y/1XVO7ZKpJHP97wqBETkbq
DRVhBHDj
=lxdq
-----END PGP SIGNATURE-----

--nwcq3i6cyedok5cv--


--===============5762931412456102791==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
--===============5762931412456102791==--

