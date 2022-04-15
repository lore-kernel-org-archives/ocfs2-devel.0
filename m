Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC428C433EF
	for <ocfs2-devel@archiver.kernel.org>; Fri, 15 Apr 2022 01:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=bnIwOZ74l3IZIcmhcZgow8ARP4EG85o7+lznEABSI28=;
 b=BVgy2t+zeo4WQCz3VNWCODlUqM4pTFMz+owxO2T5FHkpQrRDMMp3lCF2zoK4HLcyMjecMbY0pJUh
   7Bpg3UH6t4yqBjAAxuL6hls6sY8NA7CQG/jBqXXM9MC3UL8rsdhnpiqZPb8RuPZRfIhZ71FlSoqs
   Qya/LR8quaZn/KqUP5VJhqCI/Q74W3tixl0xvb6eE57I+A1kv+teTF47AgwVePoh1DzMPRoxUB88
   8PHAV+A2c2bRYUIhjA7mUrBpk8JJATcjt7EQwk8qwd+ki1hfQ1J4S3Lpf8m+hapNkdPEds9jbQ/c
   XonIm2K53JUM/P4WYBSi65IApKKv0cpdJqWYig==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=bnIwOZ74l3IZIcmhcZgow8ARP4EG85o7+lznEABSI28=;
 b=jvhvmml/UYPA4UD3xhCEnwwju6PQKwc9SsDQpf2O+ID9JEKK4Z/5tpb8sc/6Jm9Wu54Tszp5Ae62
   OnyqLSQPhqTJm6fvl//guvdwRJ53Ev1ZXmBks1VisVnb4otcMwEoZFkh4QdcquDrAooDvwDrFmai
   TVZMJYaoyv4CbFfEoNLLPDfA6VGKVhVdq6H5J9iGmYkxgfRIml/l3pGRHiRoaiobGApxJPY8zAxO
   JAoRJge667RVc9VD4j4vAiDnWakVsDTc/IN9XFGBesETfjaI2y54MPHo5odX2sZW7rwjdpLEjXYE
   aSTNvXsG0l7QSbf97A7kXtkPk9ID95xgYXMI6g==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RAC002H7Y08GFA0@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 15 Apr 2022 01:40:56 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1649986836; bh=8pwyMPDhcPpKw9NOfMifzIJtH3N0yh7dJbmJbueDwTE=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=cknh+559PwDLi2srJSH1eAtUacipDpYtBQhV3ITV1dpWa1LC8taXWjFLk3YK/uAVQ
 yyM53otqKSZk59Ih4NB3AYDLfZR0B2ETq2YxjW+AWxTuL0ju/caYS9UYZsJmm5/ThG
 GRdnMpX+KVZj3bRqmsOJcV+rG4uXDM2uIaVsDuFO+Ha/kE9OokByaORK0A4Uf4+tUG
 Wk6f+yYpKZG1kx6pYQEhQxqcZ9TIJMql2Nnd8gThXhz04vYPh6ibfn9QNatrLNfTyG
 2XeSwd1XjqioJZRkeTKerjzinBZQeDODMkYo99HuR7DZCezVOerDhsosCBFW/HlbzM
 9T1NC/K0lK+xQ==
Date: Thu, 14 Apr 2022 18:40:35 -0700
To: "xuyang2018.jy@fujitsu.com" <xuyang2018.jy@fujitsu.com>
Message-id: <20220415014035.GA16996@magnolia>
References: <1649923039-2273-1-git-send-email-xuyang2018.jy@fujitsu.com>
 <20220414155707.GA17059@magnolia> <6258D64F.8030903@fujitsu.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <6258D64F.8030903@fujitsu.com>
X-Source-IP: 145.40.73.55
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10317
 signatures=695566
Cc: "brauner@kernel.org" <brauner@kernel.org>,
 "jlayton@kernel.org" <jlayton@kernel.org>,
 "david@fromorbit.com" <david@fromorbit.com>,
 "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
 "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH v2 1/3] vfs: Add inode_sgid_strip() api
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
From: "Darrick J. Wong via Ocfs2-devel" <ocfs2-devel@oss.oracle.com>
Reply-to: "Darrick J. Wong" <djwong@kernel.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: sin.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.kernel.org ~all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-GUID: uDwzrUlfFqcJQcwAae_BUcWMXADLxYwV
X-Proofpoint-ORIG-GUID: uDwzrUlfFqcJQcwAae_BUcWMXADLxYwV
Reporting-Meta:
 AAGmT7YoHVSLSUo+QpsTe7YJn2yYxzrACFPY5gBWqagAA4Z7BAAS22OKzxHJoZ91
 57loe5qvvNYXXSVW/1W5iTssgML5aWbG6FyS+BVuF1zKKphBvGfKmxMLkN2z0ebv
 mVsAff96Gg8xmSgk3a989THshM8/9hnj6gG/YF+8HTIVduMIs7mEPsUO8/XvWLTY
 3zJpju2eWNVeo4Eo2EOMlyWQcFfQxs7M+wEn+aX+qiumaHpncaWZMdE4gDpfHFXl
 MQY6tsXqogkVjAUDEVXv39Mmtc3szWUCIAFYFK25q0ggj1MBYxXy8FfMdeC0MrYn
 oyFpyxyJ5WXJqq+8sz0aaC0bAGbateH8forALxia/32ePJwJgbmotAEgb85L0L/h
 s7MF+AXGY0/HXGS9KWS3wTk3NQ7Go5n46qsGHa24e0t2WjGnawhqBn5Qt+HbvBEl
 J4PlGn5eZJ3Mh4YG+e7J7rdB0NaXeiwhUiBamS8cfQJPBqFDJpn35fLxNWzhxJB1
 RBQ7htZGeZYhcKcb+SWezngN9/1BGxh4QIvQ5Eo3uVDniw==

On Fri, Apr 15, 2022 at 01:18:57AM +0000, xuyang2018.jy@fujitsu.com wrote:
> on 2022/4/14 23:57, Darrick J. Wong wrote:
> > On Thu, Apr 14, 2022 at 03:57:17PM +0800, Yang Xu wrote:
> >> inode_sgid_strip() function is used to strip S_ISGID mode
> >> when creat/open/mknod file.
> >>
> >> Reviewed-by: Christian Brauner (Microsoft)<brauner@kernel.org>
> >> Signed-off-by: Yang Xu<xuyang2018.jy@fujitsu.com>
> >> ---
> >>   fs/inode.c         | 18 ++++++++++++++++++
> >>   include/linux/fs.h |  3 ++-
> >>   2 files changed, 20 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/fs/inode.c b/fs/inode.c
> >> index 9d9b422504d1..d63264998855 100644
> >> --- a/fs/inode.c
> >> +++ b/fs/inode.c
> >> @@ -2405,3 +2405,21 @@ struct timespec64 current_time(struct inode *inode)
> >>   	return timestamp_truncate(now, inode);
> >>   }
> >>   EXPORT_SYMBOL(current_time);
> >> +
> >> +void inode_sgid_strip(struct user_namespace *mnt_userns, struct inode *dir,
> >> +		      umode_t *mode)
> >> +{
> >> +	if (!dir || !(dir->i_mode&  S_ISGID))
> >> +		return;
> >> +	if ((*mode&  (S_ISGID | S_IXGRP)) != (S_ISGID | S_IXGRP))
> >> +		return;
> >> +	if (S_ISDIR(*mode))
> >> +		return;
> >> +	if (in_group_p(i_gid_into_mnt(mnt_userns, dir)))
> >> +		return;
> >> +	if (capable_wrt_inode_uidgid(mnt_userns, dir, CAP_FSETID))
> >> +		return;
> >> +
> >> +	*mode&= ~S_ISGID;
> >> +}
> >
> > Thanks for cleaning up the multiple if statements from last time.
> >
> > I still would like to see patch 1 replace the code in inode_init_owner
> > so that we can compare before and after in the same patch.  Patch 2 can
> > then be solely about moving the callsite around the VFS.
> >
> Ok, then patch 1 can named as"fs/inode: move inode sgid strip operation 
> from inode_init_owner into inode_sgid_strip".  What do you think about it?

Sounds good to me.

--D

> 
> Best Regards
> Yang Xu
> > --D
> >
> >> +EXPORT_SYMBOL(inode_sgid_strip);
> >> diff --git a/include/linux/fs.h b/include/linux/fs.h
> >> index bbde95387a23..94d94219fe7c 100644
> >> --- a/include/linux/fs.h
> >> +++ b/include/linux/fs.h
> >> @@ -1897,7 +1897,8 @@ extern long compat_ptr_ioctl(struct file *file, unsigned int cmd,
> >>   void inode_init_owner(struct user_namespace *mnt_userns, struct inode *inode,
> >>   		      const struct inode *dir, umode_t mode);
> >>   extern bool may_open_dev(const struct path *path);
> >> -
> >> +void inode_sgid_strip(struct user_namespace *mnt_userns, struct inode *dir,
> >> +		      umode_t *mode);
> >>   /*
> >>    * This is the "filldir" function type, used by readdir() to let
> >>    * the kernel specify what kind of dirent layout it wants to have.
> >> --
> >> 2.27.0
> >>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
