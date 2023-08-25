Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371A318050
	for <ocfs2-devel@lists.linux.dev>; Fri, 25 Aug 2023 18:18:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC86C433C8;
	Fri, 25 Aug 2023 18:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1692987528;
	bh=Tb9IAeZ7wUBkaE34M2HBL7CqEE4h643Sj+ns9NzVydQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=p0Fy1sgSeZm+qa7+TSiaMK6SZSLBieQOezV3XiXS7drUxYuwT28awcVrAUDlrkjl7
	 U7MI5h5uYeeYGG3YYtHoYCIzu/e+cYrC8kO8K3MNp/VEgnRJBcZmjFZajTpYPAt4uz
	 p5Ylynb+AoTZDu3CScziYtdeNHYpp9APVdB3T4iZadJ9/rXYxAJQQ5HO0DCWitSE8t
	 AQ33Rg6wT9vKiK1p/682/nmyXmpPIWEOI9swv6g76CYFzyE6nNQIAm8KZG3tVjSv+R
	 /NrhTE7F18x7+s2DXLqKl01/lPglYMfCEppaUXVCrBl2wFORH6eHtSjiWxwd1PA4aE
	 8oUfkQuKFSNxw==
Message-ID: <9a8ead64cdd32fdad29cae3aff0bd447f33a32c2.camel@kernel.org>
Subject: Re: [PATCH 6/7] dlm: use FL_SLEEP to determine blocking vs
 non-blocking
From: Jeff Layton <jlayton@kernel.org>
To: Alexander Aring <aahringo@redhat.com>, linux-nfs@vger.kernel.org
Cc: cluster-devel@redhat.com, ocfs2-devel@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, teigland@redhat.com, rpeterso@redhat.com, 
	agruenba@redhat.com, trond.myklebust@hammerspace.com, anna@kernel.org, 
	chuck.lever@oracle.com
Date: Fri, 25 Aug 2023 14:18:46 -0400
In-Reply-To: <20230823213352.1971009-7-aahringo@redhat.com>
References: <20230823213352.1971009-1-aahringo@redhat.com>
	 <20230823213352.1971009-7-aahringo@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2023-08-23 at 17:33 -0400, Alexander Aring wrote:
> This patch uses the FL_SLEEP flag in struct file_lock to determine if
> the lock request is a blocking or non-blocking request. Before dlm was
> using IS_SETLKW() was being used which is not usable for lock requests
> coming from lockd when EXPORT_OP_SAFE_ASYNC_LOCK inside the export flags
> is set.
>=20
> Signed-off-by: Alexander Aring <aahringo@redhat.com>
> ---
>  fs/dlm/plock.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/dlm/plock.c b/fs/dlm/plock.c
> index 0094fa4004cc..0c6ed5eeb840 100644
> --- a/fs/dlm/plock.c
> +++ b/fs/dlm/plock.c
> @@ -140,7 +140,7 @@ int dlm_posix_lock(dlm_lockspace_t *lockspace, u64 nu=
mber, struct file *file,
>  	op->info.optype		=3D DLM_PLOCK_OP_LOCK;
>  	op->info.pid		=3D fl->fl_pid;
>  	op->info.ex		=3D (fl->fl_type =3D=3D F_WRLCK);
> -	op->info.wait		=3D IS_SETLKW(cmd);
> +	op->info.wait		=3D !!(fl->fl_flags & FL_SLEEP);
>  	op->info.fsid		=3D ls->ls_global_id;
>  	op->info.number		=3D number;
>  	op->info.start		=3D fl->fl_start;

Not sure you really need the !!, but ok...

Reviewed-by: Jeff Layton <jlayton@kernel.org>
