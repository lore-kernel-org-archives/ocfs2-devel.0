Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34FC5EB64D8
	for <ocfs2-devel@archiver.kernel.org>; Wed, 21 Jun 2023 16:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=52IxTfg6LENuevF0oB7JrZBvlSqVCHr4JqptpQj0qG8=;
 b=k127nSZlL9SnIyZPLcFtaeMD0RWtacDE8hk1zN3bu46VBcjxjcwnkqKyTfAjWbkSJ5j63THrptem
   ASuyoee/TRYRDMmJJxRSqqOjYmC5GrNGYYBo5DXjGSNcwOfIEMKSj2WnnRiM8A4vy62loNljYYhH
   FFkBtTOrUNf80uuvThuTJ4L6QgAjgvnHSAnDH51u0Bs2rghT0/qzMipy60QrUA+Q2OD49IZyvQfu
   IigGOHIn0uIbgLPQurRNOCyINL+pz1ODfgAsekyoYl/8OJv8fkZLmQHUTeuiVAb6Z+iyllPq3jpi
   5AL6i53kt4SClxblE1FfIWVTxPWp0FzEP6Uusw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=52IxTfg6LENuevF0oB7JrZBvlSqVCHr4JqptpQj0qG8=;
 b=PzkljMti08URJMDmcaUUVNCBXhEjsnvrkyfMMhmYw+qB9i+zAZ9MfKlvUHJPNPuSs8H/ia+UXtmU
   9LrWb4iW1Dnwz71pr4AjbYXeFePY6XYTR6FLFdXMSEc21BreXDgYhJlljV8m7xMtaFSDT/B+lu2b
   dpXb022VGhzfMs/B0fGCynZbH/f36v5W/3ql+5IC3uk1lJJnZ2Nz4vvNPwXS5XqpeO1GB/Rxm46m
   TOZaOPOsA3UZmTS0bjwchbAt99S0+5MOWvnmb6O29lL3eGFj5WJ5FPP0PCJ77xMyRK+12oCZTXrJ
   KB2RyDpOkA687V2Wg/lwWgLfO9+MxVy8JGxZEA==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWM00GGN23RGR20@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 21 Jun 2023 16:07:03 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=intel.com; i=@intel.com;
 q=dns/txt; s=Intel; t=1687346280; x=1718882280;
 h=from:to:cc:subject:in-reply-to:references:date: message-id:mime-version;
 bh=bNOOeYVCQ7poh+/POpUoy8h5Fc7oKKTV5NlBm31y8T8=;
 b=ApPnOFBrcbHpM84lXIkCPfg0CKRe5U6lh5Egd+pmdnRJ053x/pZmvifj
 L9zQN5xw2jTVPSHtNLsCbwOH0EXE++jHjHqeMprK8V8AqJE/2pLM3qkU5
 bALMAYsUgD5vnw66cPikASRkto+gmSlghN+No+2l/uWrnzUEy7YCaIj5a
 oJrW5uJ5gravNGKNq1OrCs1BpmI3e0qmDedn4A6Wx79EKERJzh21rZGRU
 pOTLzK6VGxhg4OIluix62/F+WZ32hqFp2o4ef9X7p4vrjnjtP4fOVkud0
 LX5EF4FhtdKluO7APTGGBlDqPv1Yq7LxlvCI37Z0vJTlkIA+/zH2gKuPw w==;
To: Joel Granados <j.granados@samsung.com>, mcgrof@kernel.org,
 Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Russ Weight <russell.h.weight@intel.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Phillip Potter <phil@philpotter.co.uk>, Clemens Ladisch <clemens@ladisch.de>,
 Arnd Bergmann <arnd@arndb.de>, Corey Minyard <minyard@acm.org>,
 Theodore Ts'o <tytso@mit.edu>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
 David Airlie <airlied@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
 "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>, Song Liu <song@kernel.org>,
 Robin Holt <robinmholt@gmail.com>, Steve Wahl <steve.wahl@hpe.com>,
 David Ahern <dsahern@kernel.org>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
 Mark Rutland <mark.rutland@arm.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Doug Gilbert <dgilbert@interlog.com>, Jiri Slaby <jirislaby@kernel.org>,
 Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Benjamin LaHaise <bcrl@kvack.org>,
 David Howells <dhowells@redhat.com>, Jan Harkes <jaharkes@cs.cmu.edu>,
 coda@cs.cmu.edu, Trond Myklebust <trond.myklebust@hammerspace.com>,
 Anna Schumaker <anna@kernel.org>, Chuck Lever <chuck.lever@oracle.com>,
 Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>,
 Anton Altaparmakov <anton@tuxera.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Kees Cook <keescook@chromium.org>, Iurii Zaikin <yzaikin@google.com>,
 Eric Biggers <ebiggers@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Balbir Singh <bsingharora@gmail.com>,
 Eric Biederman <ebiederm@xmission.com>,
 "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
 Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
 Masami Hiramatsu <mhiramat@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Petr Mladek <pmladek@suse.com>, Sergey Senozhatsky <senozhatsky@chromium.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 John Stultz <jstultz@google.com>, Steven Rostedt <rostedt@goodmis.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Mike Kravetz <mike.kravetz@oracle.com>, Muchun Song <muchun.song@linux.dev>,
 Naoya Horiguchi <naoya.horiguchi@nec.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Joerg Reuter <jreuter@yaina.de>, Ralf Baechle <ralf@linux-mips.org>,
 Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Roopa Prabhu <roopa@nvidia.com>, Nikolay Aleksandrov <razor@blackwall.org>,
 Alexander Aring <alex.aring@gmail.com>,
 Stefan Schmidt <stefan@datenfreihafen.org>,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Steffen Klassert <steffen.klassert@secunet.com>,
 Matthieu Baerts <matthieu.baerts@tessares.net>,
 Mat Martineau <martineau@kernel.org>, Simon Horman <horms@verge.net.au>,
 Julian Anastasov <ja@ssi.bg>, Remi Denis-Courmont <courmisch@gmail.com>,
 Santosh Shilimkar <santosh.shilimkar@oracle.com>,
 Marc Dionne <marc.dionne@auristor.com>, Neil Horman <nhorman@tuxdriver.com>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Xin Long <lucien.xin@gmail.com>, Karsten Graul <kgraul@linux.ibm.com>,
 Wenjia Zhang <wenjia@linux.ibm.com>, Jan Karcher <jaka@linux.ibm.com>,
 Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>,
 Martin Schiller <ms@dev.tdt.de>, John Johansen <john.johansen@canonical.com>,
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>, Jarkko Sakkinen <jarkko@kernel.org>
In-reply-to: <20230621094817.433842-1-j.granados@samsung.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20230621091000.424843-1-j.granados@samsung.com>
 <CGME20230621094824eucas1p2b6adfbd3f15ff3665674917f419b25d3@eucas1p2.samsung.com>
 <20230621094817.433842-1-j.granados@samsung.com>
Date: Wed, 21 Jun 2023 14:16:55 +0300
Message-id: <87o7l92hg8.fsf@intel.com>
MIME-version: 1.0
X-Source-IP: 192.55.52.136
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10747
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 priorityscore=202 impostorscore=0 clxscore=284 suspectscore=0 bulkscore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=641 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306210094 domainage_hfrom=13602
Cc: Joel Granados <j.granados@samsung.com>, Miaohe Lin <linmiaohe@huawei.com>,
 linux-hyperv@vger.kernel.org, linux-ia64@vger.kernel.org,
 "Rafael J. Wysocki" <rafael@kernel.org>, linux-aio@kvack.org,
 Amir Goldstein <amir73il@gmail.com>, mptcp@lists.linux.dev,
 KP Singh <kpsingh@kernel.org>, dri-devel@lists.freedesktop.org,
 Ben Segall <bsegall@google.com>, linux-mm@kvack.org,
 linux-sctp@vger.kernel.org, keyrings@vger.kernel.org,
 Stanislav Fomichev <sdf@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
 linux-afs@lists.infradead.org, linux-s390@vger.kernel.org,
 Valentin Schneider <vschneid@redhat.com>, xen-devel@lists.xenproject.org,
 linux-scsi@vger.kernel.org, dccp@vger.kernel.org, linux-rdma@vger.kernel.org,
 bridge@lists.linux-foundation.org, John Fastabend <john.fastabend@gmail.com>,
 linux-ntfs-dev@lists.sourceforge.net,
 Christophe Leroy <christophe.leroy@csgroup.eu>, codalist@coda.cs.cmu.edu,
 lvs-devel@vger.kernel.org, Matthew Bobrowski <repnop@google.com>,
 linux-cachefs@redhat.com, Mel Gorman <mgorman@suse.de>,
 tipc-discussion@lists.sourceforge.net, Yonghong Song <yhs@fb.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 intel-gfx@lists.freedesktop.org, linux-crypto@vger.kernel.org,
 linux-wpan@vger.kernel.org, coreteam@netfilter.org,
 John Ogness <john.ogness@linutronix.de>, Mike Travis <mike.travis@hpe.com>,
 Boqun Feng <boqun.feng@gmail.com>, apparmor@lists.ubuntu.com,
 linuxppc-dev@lists.ozlabs.org, Nicholas Piggin <npiggin@gmail.com>,
 rds-devel@oss.oracle.com, linux-raid@vger.kernel.org,
 Waiman Long <longman@redhat.com>, linux-hams@vger.kernel.org,
 openipmi-developer@lists.sourceforge.net,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 linux-arm-kernel@lists.infradead.org, fsverity@lists.linux.dev,
 Hao Luo <haoluo@google.com>, linux-nfs@vger.kernel.org,
 Will Drewry <wad@chromium.org>, linux-x25@vger.kernel.org,
 Stephen Boyd <sboyd@kernel.org>,
 Daniel Bristot de Oliveira <bristot@redhat.com>, kexec@lists.infradead.org,
 linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
 linux-xfs@vger.kernel.org,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 linux-security-module@vger.kernel.org, netfilter-devel@vger.kernel.org,
 Sven Schnelle <svens@linux.ibm.com>, Jiri Olsa <jolsa@kernel.org>,
 netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, Martin KaFai Lau <martin.lau@linux.dev>,
 ocfs2-devel@oss.oracle.com
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
X-IronPort-AV: E=McAfee;i="6600,9927,10747"; a="339757987"
X-IronPort-AV: E=Sophos;i="6.00,260,1681196400"; d="scan'208";a="339757987"
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10747"; a="664623042"
X-IronPort-AV: E=Sophos;i="6.00,260,1681196400"; d="scan'208";a="664623042"
X-ServerName: mga12.intel.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.intel.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: AoxsWRc1oW1fhQhnUDsRX8F4Ig_LQ3O0
X-Proofpoint-GUID: AoxsWRc1oW1fhQhnUDsRX8F4Ig_LQ3O0
X-Mailman-Approved-At: Wed, 21 Jun 2023 16:07:01 +0000
Reporting-Meta:
 AAHJUWYrXSBVZXvJTWkXH4EPs7V7RGtvVe3Ceq/Ks6PJSx8e0xD5hQvotON6KA1x
 FVPJkQe9oSIaPOHsS//NPZvVrnbgtSiY1wVhjQ72QkFy4J673uhNSTmeTbG4Fv3y
 lZv9KTC7/8T2K8SorVwAbUd9ezsuEfJbAaC8kWkNuwkIurpcpK+qlpUtXgbYtPNy
 5cmLwg5S+EY9Dhkhs2s/WpncmdErumBdxQ4H9qNPLI3/pUDsf1RRK3z+b2pRwhdn
 vsYGFArr4Y3DhkveAApl7+0i7WsXOgAPHlTjEo5YzPTbxiq4Oxe5OoVCKMu4PxIZ
 eXBI6GRY7SVLHrE2zPyEKyB+kQQht89v6cMa+wK+lP2oLy/Xk3kQNUAZYw/KoUKR
 dlHgfMKQV7xSmA2PdChCWzas3qUxTZTf6Y1GdYu55EstzgIjLI3qCHO+he828H6J
 GjSqcQVYMCHUxGYgca6yOl5x5MfvdkAB5Wi0rkcyhM0VGuAlC2BMK80KhiLdVmAF
 w+zkaEPiarUkuF/JaKpEAf4x0b1zgClxjMYAAoLrGA==

On Wed, 21 Jun 2023, Joel Granados <j.granados@samsung.com> wrote:
> Remove the empty end element from all the arrays that are passed to the
> register sysctl calls. In some files this means reducing the explicit
> array size by one. Also make sure that we are using the size in
> ctl_table_header instead of evaluating the .procname element.

Where's the harm in removing the end elements driver by driver? This is
an unwieldy patch to handle.

> diff --git a/drivers/gpu/drm/i915/i915_perf.c b/drivers/gpu/drm/i915/i915_perf.c
> index f43950219ffc..e4d7372afb10 100644
> --- a/drivers/gpu/drm/i915/i915_perf.c
> +++ b/drivers/gpu/drm/i915/i915_perf.c
> @@ -4884,24 +4884,23 @@ int i915_perf_remove_config_ioctl(struct drm_device *dev, void *data,
>  
>  static struct ctl_table oa_table[] = {
>  	{
> -	 .procname = "perf_stream_paranoid",
> -	 .data = &i915_perf_stream_paranoid,
> -	 .maxlen = sizeof(i915_perf_stream_paranoid),
> -	 .mode = 0644,
> -	 .proc_handler = proc_dointvec_minmax,
> -	 .extra1 = SYSCTL_ZERO,
> -	 .extra2 = SYSCTL_ONE,
> -	 },
> +		.procname = "perf_stream_paranoid",
> +		.data = &i915_perf_stream_paranoid,
> +		.maxlen = sizeof(i915_perf_stream_paranoid),
> +		.mode = 0644,
> +		.proc_handler = proc_dointvec_minmax,
> +		.extra1 = SYSCTL_ZERO,
> +		.extra2 = SYSCTL_ONE,
> +	},
>  	{
> -	 .procname = "oa_max_sample_rate",
> -	 .data = &i915_oa_max_sample_rate,
> -	 .maxlen = sizeof(i915_oa_max_sample_rate),
> -	 .mode = 0644,
> -	 .proc_handler = proc_dointvec_minmax,
> -	 .extra1 = SYSCTL_ZERO,
> -	 .extra2 = &oa_sample_rate_hard_limit,
> -	 },
> -	{}
> +		.procname = "oa_max_sample_rate",
> +		.data = &i915_oa_max_sample_rate,
> +		.maxlen = sizeof(i915_oa_max_sample_rate),
> +		.mode = 0644,
> +		.proc_handler = proc_dointvec_minmax,
> +		.extra1 = SYSCTL_ZERO,
> +		.extra2 = &oa_sample_rate_hard_limit,
> +	}
>  };

The existing indentation is off, but fixing it doesn't really belong in
this patch.

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Graphics Center

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
