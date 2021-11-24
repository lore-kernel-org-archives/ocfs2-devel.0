Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4E8BC433F5
	for <ocfs2-devel@archiver.kernel.org>; Wed, 24 Nov 2021 09:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=bhNAzp03MSwDikd/3E2/49iHPI9uEItw44ZO4VSlzjM=;
 b=eNmq+sq/3BDXjnHhVm8QBJfWf+gxVAZW1smH1Owt7EZNNKZwsBMBpQqSiIW+drvgMTBtsPrwd/4b
   JlfK/UPLw3ZPowcvp+CfMuC3DmbZwnyvRVq5W6ZSCpxFeGR+cLWKwwMGVewYuB1dBm2NrFo2wFiZ
   pEuRxd7OSdLdlXJexYsq8db2ADJRCwCYyRPsrZr8ueJwTq0d8Srut0VLPuRI019lPgLYGWEVd1/Y
   AvyJTL1ZxhE1m3QfYqyDb1F1YFrxhlDIadBvSneQzBBDyrG85APHLsJyB/P8ft4O9OpmUcnIVgne
   /WtifnG4GnxtyWxAz+AgpWiODiYz7QBc5pGkjQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=bhNAzp03MSwDikd/3E2/49iHPI9uEItw44ZO4VSlzjM=;
 b=rsidpqzi4TJvV+6fBvYx/uh57OZ6MpI12RZInUdgBNEtt/6FRD1pTzyTRj/VH/3340w33uk4Hq4P
   eFG5GhTAucWdcG+Sy79ZSQUMVw1eUZfvkRqqO4I7/LOfPIKM7IvhF9BHAcqLGSgvCnFKghGqHWr8
   LgXWMIxFd9fp5mA7IeicLItPelZ8g0+Wo02fxNV1caKg2s8GJnBcxZybtn9z49qFqdL8UotW6iOY
   ydoyQuq3VVyBj1vlbXIDysrHh246sMHiJoRqqtWq4LXlKOtjsY2uHmGSFQ9Y2Bo+860Uu1rr0jUM
   4XSMd90Y/57PD8D8E/Ura/dRr0K0yr+/xP0Pog==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20211026 64bit (built Oct 26
 2021))
 with ESMTP id <0R32001LWLQ73PF0@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 24 Nov 2021 09:44:31 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=jack@suse.cz; dkim=pass header.d=suse.cz header.s=susede2_rsa;
 dkim=permerror header.d=suse.cz header.s=susede2_ed25519; dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1637747050;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=xjctS9e3aLk//fWwNzII/UY4G5OnovggWZdyEKD1t34=;
 b=Fa3DfqPoxkPRyFtLFipUAPsRoQ7583RIvIkjGcirn+ZDIVuZJxTkgHZCWQWJkaYcgx/XTF
 6Tg+qvMREmzgGwP+y0PqF0I8yljZj0emBD/1N75E2fyVfhSwuHdlW27Cq87y3T4+dKDpTg
 m3CDIAdfVxCay7j/D++92R/TIMACYbw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1637747050;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=xjctS9e3aLk//fWwNzII/UY4G5OnovggWZdyEKD1t34=;
 b=jBk0LyCfiE1g4jR+z/f8PsVbXLRirmoGyBWY3eutEhQ8eC54ZtfGnQdZjQkRNSqRSaajn0
 YL6WjUHTxaO0ZHAA==
Date: Wed, 24 Nov 2021 10:44:09 +0100
To: Luis Chamberlain <mcgrof@kernel.org>
Message-id: <20211124094409.GF8583@quack2.suse.cz>
References: <20211123202422.819032-1-mcgrof@kernel.org>
 <20211123202422.819032-7-mcgrof@kernel.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20211123202422.819032-7-mcgrof@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Source-IP: 195.135.220.28
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10177
 signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 spamscore=0 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=898
 suspectscore=0 clxscore=299 bulkscore=0 lowpriorityscore=0 mlxscore=0
 priorityscore=270 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111240054
Cc: jack@suse.cz, airlied@linux.ie, benh@kernel.crashing.org,
 amir73il@gmail.com, clemens@ladisch.de, dri-devel@lists.freedesktop.org,
 phil@philpotter.co.uk, yzaikin@google.com, joonas.lahtinen@linux.intel.com,
 keescook@chromium.org, arnd@arndb.de, intel-gfx@lists.freedesktop.org,
 jani.nikula@linux.intel.com, viro@zeniv.linux.org.uk, rodrigo.vivi@intel.com,
 nixiaoming@huawei.com, tvrtko.ursulin@linux.intel.com,
 gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
 julia.lawall@inria.fr, ebiederm@xmission.com, linux-fsdevel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 6/8] inotify: simplify subdirectory
 registration with register_sysctl()
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
From: Jan Kara via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Jan Kara <jack@suse.cz>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: smtp-out1.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:137.65.0.0/16 ip4:151.155.28.0/17
 ip4:149.44.0.0/16 ip4:147.2.0.0/16 ip4:164.99.0.0/16 ip4:130.57.0.0/16
 ip4:192.31.114.0/24 ip4:195.135.221.0/24 ip4:195.135.220.0/24
 ip4:69.7.179.0/24 ip4:150.215.214.0/24 include:mailcontrol.com ~all
X-Spam: Clean
X-Proofpoint-GUID: 11G63GYGjijuQh8PwRz706KmLzPznAZB
X-Proofpoint-ORIG-GUID: 11G63GYGjijuQh8PwRz706KmLzPznAZB
Reporting-Meta:
 AAHR9XZxIzIhXyvWNcsjtiiAbLB15qhI3xa23BMWryO29qJPwq0E4DTWdiZs4dou
 QOHM/CiF9bLENokQakGDK65YzAeAVHYdonpkI7/M9Vr26q6xxllnUBr3Gu4nZquW
 vV4IyqGdP7yp+vYcZOaiugWskVkOPHqNvvjZj+WzmmHYNeBNOy+rBovi90ALdEcA
 f6v3cPKo/SkG0/AufozgnG8GHcVi7JQ53ZnR4eTWuDUmTObgkAJ+sKZ0WSd/YiB4
 +itcxvUx4nUaDeweJL7bV2J4pXv8Cl+QVWCKM14MZ7nWS11zJk8DFrooV4pumsal
 B8DNAQpL6P3GgBeFDNt76ffWho0o0ExW9SGLly+9ELPoTWu7Cm4McZN7G6bjGc8U
 bJiO+hBi8ZHRtsCt3CwCFpWKWbF7xENrF1HWTjJxoiwY9OIf+JunOuM3giyqdTis
 lU/DWf4gDyPUKgCZATTwAnjkK0IA1M9aSFoY4yd8u9LpTitUJ8D0pUbxKqA+bzid
 gVLXeTbSDd/BsO0li5sVIlPhVMDY1vX1hHvJ1iLc06Y=

On Tue 23-11-21 12:24:20, Luis Chamberlain wrote:
> From: Xiaoming Ni <nixiaoming@huawei.com>
> 
> There is no need to user boiler plate code to specify a set of base
> directories we're going to stuff sysctls under. Simplify this by using
> register_sysctl() and specifying the directory path directly.
> 
> Move inotify_user sysctl to inotify_user.c while at it to remove clutter
> from kernel/sysctl.c.
> 
> Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
> [mcgrof: update commit log to reflect new path we decided to take]
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>

This looks fishy. You register inotify_table but not fanotify_table and
remove both...

								Honza

> ---
>  fs/notify/inotify/inotify_user.c | 11 ++++++++++-
>  include/linux/inotify.h          |  3 ---
>  kernel/sysctl.c                  | 21 ---------------------
>  3 files changed, 10 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
> index 29fca3284bb5..54583f62dc44 100644
> --- a/fs/notify/inotify/inotify_user.c
> +++ b/fs/notify/inotify/inotify_user.c
> @@ -58,7 +58,7 @@ struct kmem_cache *inotify_inode_mark_cachep __read_mostly;
>  static long it_zero = 0;
>  static long it_int_max = INT_MAX;
>  
> -struct ctl_table inotify_table[] = {
> +static struct ctl_table inotify_table[] = {
>  	{
>  		.procname	= "max_user_instances",
>  		.data		= &init_user_ns.ucount_max[UCOUNT_INOTIFY_INSTANCES],
> @@ -87,6 +87,14 @@ struct ctl_table inotify_table[] = {
>  	},
>  	{ }
>  };
> +
> +static void __init inotify_sysctls_init(void)
> +{
> +	register_sysctl("fs/inotify", inotify_table);
> +}
> +
> +#else
> +#define inotify_sysctls_init() do { } while (0)
>  #endif /* CONFIG_SYSCTL */
>  
>  static inline __u32 inotify_arg_to_mask(struct inode *inode, u32 arg)
> @@ -849,6 +857,7 @@ static int __init inotify_user_setup(void)
>  	inotify_max_queued_events = 16384;
>  	init_user_ns.ucount_max[UCOUNT_INOTIFY_INSTANCES] = 128;
>  	init_user_ns.ucount_max[UCOUNT_INOTIFY_WATCHES] = watches_max;
> +	inotify_sysctls_init();
>  
>  	return 0;
>  }
> diff --git a/include/linux/inotify.h b/include/linux/inotify.h
> index 6a24905f6e1e..8d20caa1b268 100644
> --- a/include/linux/inotify.h
> +++ b/include/linux/inotify.h
> @@ -7,11 +7,8 @@
>  #ifndef _LINUX_INOTIFY_H
>  #define _LINUX_INOTIFY_H
>  
> -#include <linux/sysctl.h>
>  #include <uapi/linux/inotify.h>
>  
> -extern struct ctl_table inotify_table[]; /* for sysctl */
> -
>  #define ALL_INOTIFY_BITS (IN_ACCESS | IN_MODIFY | IN_ATTRIB | IN_CLOSE_WRITE | \
>  			  IN_CLOSE_NOWRITE | IN_OPEN | IN_MOVED_FROM | \
>  			  IN_MOVED_TO | IN_CREATE | IN_DELETE | \
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 7a90a12b9ea4..6aa67c737e4e 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -125,13 +125,6 @@ static const int maxolduid = 65535;
>  static const int ngroups_max = NGROUPS_MAX;
>  static const int cap_last_cap = CAP_LAST_CAP;
>  
> -#ifdef CONFIG_INOTIFY_USER
> -#include <linux/inotify.h>
> -#endif
> -#ifdef CONFIG_FANOTIFY
> -#include <linux/fanotify.h>
> -#endif
> -
>  #ifdef CONFIG_PROC_SYSCTL
>  
>  /**
> @@ -3099,20 +3092,6 @@ static struct ctl_table fs_table[] = {
>  		.proc_handler	= proc_dointvec,
>  	},
>  #endif
> -#ifdef CONFIG_INOTIFY_USER
> -	{
> -		.procname	= "inotify",
> -		.mode		= 0555,
> -		.child		= inotify_table,
> -	},
> -#endif
> -#ifdef CONFIG_FANOTIFY
> -	{
> -		.procname	= "fanotify",
> -		.mode		= 0555,
> -		.child		= fanotify_table,
> -	},
> -#endif
>  #ifdef CONFIG_EPOLL
>  	{
>  		.procname	= "epoll",
> -- 
> 2.33.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
