Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A666BC433F5
	for <ocfs2-devel@archiver.kernel.org>; Thu, 14 Apr 2022 15:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=hScCZiZlXqDs655G5gngNMuChySvOA8AIbJmmUydGX4=;
 b=UDkE1NbRUSe1WqWztfStJYucz59Ruh4r5kiUDCr/s5qOucfT72pzGxn1wibMyw2M83la+6+37oK9
   4xq93relnKroc3aW2/98UGqHQHXnW+FM8vXThJe6837KFo6CsDTrbsI/j8FXKmHvXDldgVkAh2YW
   WQ7i4qF/O/8q8EvqZFcx6NDDDujMpVi1aHprKSeCiC+wHkb3pL3HbHkDZarVkuYVKY8F/eJFueMo
   RcmXJlyqd70bYsDiYUe3+bkWyMpxIbKBAl2fJmVFVsTD72tDtCTUSafFxk9POnXJOdFQ5LAwX7Sx
   A+w6T0QERpJi6VOLwQX2g1LOEhCLkvcYyxkwqg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=hScCZiZlXqDs655G5gngNMuChySvOA8AIbJmmUydGX4=;
 b=hpi4igtKnZPHtVobWwqh8KJKuIwnWPp9K5A98qnMexSdwYDkRY4w9Zn3dryUvoPx/hsTDAdjOlMu
   7WAwAw71XtaMggVQlJmxcl9CH9ktUchqkMnzemb/05XQKXSKQGrfz5LtuTTPPrGnYsC412IOI+em
   dEyRu+9kzH79fJb8uTP0CdtCKzrXmpJkLDngjHdl4/u9MqDo82mabY3rhNS171q88AHPiDQ+0ele
   R0UbDmlRR0nzasa3R+mL5g84M+Jr918U2Zbp//SymfXIaVS7ilBb71hi9t+FI3YzL5kzbF7nf2m1
   hRBu9dU1du09TeF720vFumN41XzY3ZoMaalUoQ==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RAC00C8Y6ZKF020@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 14 Apr 2022 15:57:20 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1649951827; bh=rrDdBBie/SEw36K0QoVtzDbxKHphhFpbtbr+NG2+3Q8=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=SYYMtGHckNqbSD1lSXiWuexcwApUy6g53BtBbGzY47dAMQ9IjC4usLJlZoZ9dhOL2
 dMhPVWvBeDVFwibTG7LCKv91HLJs5FtrgA1VSoej4Sa4/Iw/7qxmNGMUG+vSfVgtRJ
 XujcplpCKVO1XTde7RAZArv2zar8JTOeUTarUVVh6tDvmbgcpIrwxR36dbq0pHNkOn
 DB+X2+fBJPECr3bKjJrqVhwfHwiwt7uT33TNtPbLARVGt5IYifZ1rfwHSLnyLEQkm8
 r4yjbYuIx3kouzlHwp6mw6z0Ou+Ts6eKzMTZarC/ehO0LLX5RZB5beKyQfAsQqzdz3
 Xyvhn0/FxfVCg==
Date: Thu, 14 Apr 2022 08:57:07 -0700
To: Yang Xu <xuyang2018.jy@fujitsu.com>
Message-id: <20220414155707.GA17059@magnolia>
References: <1649923039-2273-1-git-send-email-xuyang2018.jy@fujitsu.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <1649923039-2273-1-git-send-email-xuyang2018.jy@fujitsu.com>
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10317
 signatures=695566
Cc: brauner@kernel.org, jlayton@kernel.org, david@fromorbit.com,
 viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
 ceph-devel@vger.kernel.org, ocfs2-devel@oss.oracle.com
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
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.kernel.org ~all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-GUID: 5BR6AQ1MZUTzvkwCoEE1poFkZBIW3kcJ
X-Proofpoint-ORIG-GUID: 5BR6AQ1MZUTzvkwCoEE1poFkZBIW3kcJ
Reporting-Meta:
 AAEKFnC6+0c8YQlEZuOrjHNBC+MGoTbhkLgMIuMIiKc8P/GDE383zVIHhfBL+P+3
 xBJ+desD1eYSD0BnLTZifLrEaPi0NGU/6p4DUfGtjoRyuwePw4fy9/KOfy1rhPtw
 MvN8ZT5zz0s0YgaQscpcvS11yUKGh9WdgOzJQdXQDCyAzq5f7aQZ5YfgTQfsxDmK
 baveIw0GbM8Q+WrKxZO8OOToUmpzZjckrgpZjHkVuRTMffTYhtB2KxyblD97hQ0W
 eqj6c60gNq4m3d6eIdbatt/ti/5uiZ3WwdCmX3bj84b027D4d+ArNjYHjZ9gG4vp
 wx43DYpQRyrOEDdoYEIZ47g0KfS4uUPhprKvYjIm7z6f/Wf5EgbHSHPghTZlmbd5
 nAGDANgNg56Bznc/x0cCn06lL8bLJq5ixDhnFz0GGjSz0QG8eGtdulVJaiWoP7YC
 qCRbOLriDjMI/YeDEpZWJhkwR76eRXvrVpOIzK+VOW58SmoaoeFK2ibnuRr535pY
 QgYMNCHfLkfsq15CmgkhLaB6yT1RGnvj4LelOBXL2EK7OA==

On Thu, Apr 14, 2022 at 03:57:17PM +0800, Yang Xu wrote:
> inode_sgid_strip() function is used to strip S_ISGID mode
> when creat/open/mknod file.
> 
> Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
> Signed-off-by: Yang Xu <xuyang2018.jy@fujitsu.com>
> ---
>  fs/inode.c         | 18 ++++++++++++++++++
>  include/linux/fs.h |  3 ++-
>  2 files changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index 9d9b422504d1..d63264998855 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -2405,3 +2405,21 @@ struct timespec64 current_time(struct inode *inode)
>  	return timestamp_truncate(now, inode);
>  }
>  EXPORT_SYMBOL(current_time);
> +
> +void inode_sgid_strip(struct user_namespace *mnt_userns, struct inode *dir,
> +		      umode_t *mode)
> +{
> +	if (!dir || !(dir->i_mode & S_ISGID))
> +		return;
> +	if ((*mode & (S_ISGID | S_IXGRP)) != (S_ISGID | S_IXGRP))
> +		return;
> +	if (S_ISDIR(*mode))
> +		return;
> +	if (in_group_p(i_gid_into_mnt(mnt_userns, dir)))
> +		return;
> +	if (capable_wrt_inode_uidgid(mnt_userns, dir, CAP_FSETID))
> +		return;
> +
> +	*mode &= ~S_ISGID;
> +}

Thanks for cleaning up the multiple if statements from last time.

I still would like to see patch 1 replace the code in inode_init_owner
so that we can compare before and after in the same patch.  Patch 2 can
then be solely about moving the callsite around the VFS.

--D

> +EXPORT_SYMBOL(inode_sgid_strip);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index bbde95387a23..94d94219fe7c 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1897,7 +1897,8 @@ extern long compat_ptr_ioctl(struct file *file, unsigned int cmd,
>  void inode_init_owner(struct user_namespace *mnt_userns, struct inode *inode,
>  		      const struct inode *dir, umode_t mode);
>  extern bool may_open_dev(const struct path *path);
> -
> +void inode_sgid_strip(struct user_namespace *mnt_userns, struct inode *dir,
> +		      umode_t *mode);
>  /*
>   * This is the "filldir" function type, used by readdir() to let
>   * the kernel specify what kind of dirent layout it wants to have.
> -- 
> 2.27.0
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
