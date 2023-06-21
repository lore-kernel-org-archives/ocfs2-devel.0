Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FA1CC001B3
	for <ocfs2-devel@archiver.kernel.org>; Wed, 21 Jun 2023 16:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=rv/BXpMHJ1I8jUfS8Top23b8LI3dJ2f6aR0S3tVsFRI=;
 b=qbIouCZgcVyoMG3IaqKhrC8eCgpgtf2tA+zwBNMQIwDflIq4GSbNOmyCgopjdxJjfBf6QF6Zu00o
   ru1m2hoHqgKXTGjWaiKfMw51vhhZ4bLfl8kZnfDCt4LV7rkLhVJ/QcXlrhYNWwz6blmYS6jLYkoZ
   +tTF4Mj3U2i7ZBTzFShfBlLPjituBMSl/gWr3TqblQ9liAlb80QFA3NYJfSw+JdpcTcUd+Py/MKm
   t2/f1UCOx6pic8r92F8cNriVCxrSAeLarZArgNxQ29jpnkoOgvHKHUynPs+qrBwwAWnXcRjTF2jt
   NYfeEuyKdYeOOb+J3XxK+pI/zVXcdHxuYVRLiw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=rv/BXpMHJ1I8jUfS8Top23b8LI3dJ2f6aR0S3tVsFRI=;
 b=bO3f/K9PX0B0euh8nVFiLKLTIML2eUvl1zf3Bh0Ljz5Hre3hle2e+aH2ALciyFF9acCt1nQev9u2
   J8nEMGlpBhf+UOlsqI8+Uo3Kz3yC0UPlrPx5xaEv6g02znhoIBS9ijKxw4o8fb50RCrrSqBy4+5C
   jBTqUUdvFoajuFQRT5jYccOOjvltP2iUbDtuO3jS5q6xmd0DdnMLVGSua1wXJ0Ue5JiB4RVZR5d1
   3DHczc1UtJdRV0OnRY7ArPXvFNKkHSEY1ka4+v9rnh2jYwpzsUQRGzcXmTPivCZk3j5pa362MvJ/
   aDtU2eX+dLMN9dbp/GoGZjqgjhXZQMAEyEz9hA==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWM00GHX23SGR20@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 21 Jun 2023 16:07:04 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=intel.com; i=@intel.com;
 q=dns/txt; s=Intel; t=1687353446; x=1718889446;
 h=from:to:cc:subject:in-reply-to:references:date: message-id:mime-version;
 bh=9eMWiG7JI6/9oPvFtdl/3iOGYIkGUexXwjKhm4v9hgQ=;
 b=aekgZFGF3DD4VAc2/KVxORdTAcPzaLTmjjOwOaJiw8U2Lb85iLdYhA/+
 nFDgVV4Y0UeY/Q1IeVVWSCpe0HDD/xwOYDysq3k9+gC3TMML6YZ3YnRKi
 MTOPRaxhz7asIGa3GpHBlxtffwRuv3IgcbeG+Gdk8PpgQKfrk1+tG31n3
 m+0qJwh0b9OdmxAWgqW24MngsVPF7SvM+oZWmiHiH1TCO4POp+Rl9Latf
 aZZ0kYgws7JtVaf7IOVeA5SW5kJfxAPjNTlYhvO4+kdyl5o9Uuk1iZtv0
 JZuJw3iyXSkNwVcbOvVPYd3t87nGJBZJynoYfNEE506umu2+74Ws58Xkt w==;
To: Joel Granados <j.granados@samsung.com>
In-reply-to: <20230621130614.s36w4u7dzmb5d5p3@localhost>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20230621091000.424843-1-j.granados@samsung.com>
 <CGME20230621094824eucas1p2b6adfbd3f15ff3665674917f419b25d3@eucas1p2.samsung.com>
 <20230621094817.433842-1-j.granados@samsung.com> <87o7l92hg8.fsf@intel.com>
 <20230621130614.s36w4u7dzmb5d5p3@localhost>
Date: Wed, 21 Jun 2023 16:15:46 +0300
Message-id: <878rcd2by5.fsf@intel.com>
MIME-version: 1.0
X-Source-IP: 192.55.52.43
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10748
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 clxscore=258 malwarescore=0 adultscore=0
 priorityscore=343 suspectscore=0 impostorscore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306210112 domainage_hfrom=13602
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
From: Jani Nikula via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Jani Nikula <jani.nikula@linux.intel.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-IronPort-AV: E=McAfee;i="6600,9927,10747"; a="446546901"
X-IronPort-AV: E=Sophos;i="6.00,260,1681196400"; d="scan'208";a="446546901"
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10747"; a="664658294"
X-IronPort-AV: E=Sophos;i="6.00,260,1681196400"; d="scan'208";a="664658294"
X-ServerName: mga05.intel.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.intel.com -all
X-Spam: Clean
X-Proofpoint-GUID: FgACQ9AMichSA58VFztO2v-aUk0qsZb8
X-Proofpoint-ORIG-GUID: FgACQ9AMichSA58VFztO2v-aUk0qsZb8
X-Mailman-Approved-At: Wed, 21 Jun 2023 16:07:01 +0000
Reporting-Meta:
 AAEXGAYBU7KZGoMveVj7RxAGYiY0iG3AhdcypMPo8VOaLmmIe/aXgyeSBrE3wUEW
 UIzCLkWMQr76m61q9R3zj61IKEbIMr7wYxvIeuliV21n5z+TvzMBGoeVmieeStWP
 PLTyNUBDpQtH15NglH0sxy7Twd8rmWkZAb/aixL0/CrTfsmuAMNBkGBImEVR8o6D
 qDfoWorkUKmlxyxs3uDYo7BShKGqlsIMnRvceE7XINvtwjXuS3TnujWid5NAo0Lm
 g5Y9vtgpTqj7ktzNXprO145a+k6AnQ9RzQvCHj7CelQRn6SwWqjYJxAL/JtHunYY
 QW91l/9mwCERno/k7G6vkwPSuH+Mx6m5VTCRW94rztmjbQdXQmpXF72C5q/kXyAF
 R0/dx0+YXeHBBRoSo9hewrnyN7gBpxqvSMv7TQWM/BJESlyhsW5eqiiSicDmWuTp
 wfjO64NaCh8KaFE5XN3wWj9eR2nDm60sHjIe6jTBgQ3A7P7betkdw1g9Gb/XIUuP
 VicLsT4bkn5UhFWR8tJzfT52fLiWADD5Q5Rczey0LQs=

On Wed, 21 Jun 2023, Joel Granados <j.granados@samsung.com> wrote:
> On Wed, Jun 21, 2023 at 02:16:55PM +0300, Jani Nikula wrote:
>> On Wed, 21 Jun 2023, Joel Granados <j.granados@samsung.com> wrote:
>> > Remove the empty end element from all the arrays that are passed to the
>> > register sysctl calls. In some files this means reducing the explicit
>> > array size by one. Also make sure that we are using the size in
>> > ctl_table_header instead of evaluating the .procname element.
>> 
>> Where's the harm in removing the end elements driver by driver? This is
>> an unwieldy patch to handle.
>
> I totally agree. Its a big one!!! but I'm concerned of breaking bisectibility:
> * I could for example separate all the removes into separate commits and
>   then have a final commit that removes the check for the empty element.
>   But this will leave the tree in a state where the for loop will have
>   undefined behavior when it looks for the empty end element. It might
>   or might not work (probably not :) until the final commit where I fix
>   that.
>
> * I could also change the logic that looks for the final element,
>   commit that first and then remove the empty element one commit per
>   driver after that. But then for all the arrays that still have an
>   empty element, there would again be undefined behavior as it would
>   think that the last element is valid (when it is really the sentinel).
>
> Any ideas on how to get around these?

First add size to the register calls, and allow the last one to be
sentinel but do not require the sentinel.

Start removing sentinels, adjusting the size passed in.

Once enough sentinels have been removed, add warning if the final entry
is a sentinel.

Never really remove the check? (But surely you can rework the logic to
not count the number of elements up front, only while iterating.)


BR,
Jani.

>> 
>> > diff --git a/drivers/gpu/drm/i915/i915_perf.c b/drivers/gpu/drm/i915/i915_perf.c
>> > index f43950219ffc..e4d7372afb10 100644
>> > --- a/drivers/gpu/drm/i915/i915_perf.c
>> > +++ b/drivers/gpu/drm/i915/i915_perf.c
>> > @@ -4884,24 +4884,23 @@ int i915_perf_remove_config_ioctl(struct drm_device *dev, void *data,
>> >  
>> >  static struct ctl_table oa_table[] = {
>> >  	{
>> > -	 .procname = "perf_stream_paranoid",
>> > -	 .data = &i915_perf_stream_paranoid,
>> > -	 .maxlen = sizeof(i915_perf_stream_paranoid),
>> > -	 .mode = 0644,
>> > -	 .proc_handler = proc_dointvec_minmax,
>> > -	 .extra1 = SYSCTL_ZERO,
>> > -	 .extra2 = SYSCTL_ONE,
>> > -	 },
>> > +		.procname = "perf_stream_paranoid",
>> > +		.data = &i915_perf_stream_paranoid,
>> > +		.maxlen = sizeof(i915_perf_stream_paranoid),
>> > +		.mode = 0644,
>> > +		.proc_handler = proc_dointvec_minmax,
>> > +		.extra1 = SYSCTL_ZERO,
>> > +		.extra2 = SYSCTL_ONE,
>> > +	},
>> >  	{
>> > -	 .procname = "oa_max_sample_rate",
>> > -	 .data = &i915_oa_max_sample_rate,
>> > -	 .maxlen = sizeof(i915_oa_max_sample_rate),
>> > -	 .mode = 0644,
>> > -	 .proc_handler = proc_dointvec_minmax,
>> > -	 .extra1 = SYSCTL_ZERO,
>> > -	 .extra2 = &oa_sample_rate_hard_limit,
>> > -	 },
>> > -	{}
>> > +		.procname = "oa_max_sample_rate",
>> > +		.data = &i915_oa_max_sample_rate,
>> > +		.maxlen = sizeof(i915_oa_max_sample_rate),
>> > +		.mode = 0644,
>> > +		.proc_handler = proc_dointvec_minmax,
>> > +		.extra1 = SYSCTL_ZERO,
>> > +		.extra2 = &oa_sample_rate_hard_limit,
>> > +	}
>> >  };
>> 
>> The existing indentation is off, but fixing it doesn't really belong in
>> this patch.
>
> Agreed. But I actually was trying to fix something that checkpatch
> flagged. I'll change these back (which will cause this patch to be
> flagged).
>
> An alternative solution would be to fix the indentation as part of the
> preparation patches. Tell me what you think.
>
> Thx
>
>> 
>> BR,
>> Jani.
>> 
>> 
>> -- 
>> Jani Nikula, Intel Open Source Graphics Center

-- 
Jani Nikula, Intel Open Source Graphics Center

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
