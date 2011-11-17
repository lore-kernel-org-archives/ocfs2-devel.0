From: Joel Becker <jlbec@evilplan.org>
Date: Thu, 17 Nov 2011 01:50:21 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: send correct UUID to cleancache
	initialization
In-Reply-To: <dd238ce4-fe92-4dc0-a4b6-7f273c386366@default>
References: <dd238ce4-fe92-4dc0-a4b6-7f273c386366@default>
Message-ID: <20111117095019.GE7319@noexit.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, Sunil Mushran <sunil.mushran@oracle.com>

On Mon, Oct 17, 2011 at 04:47:17PM -0700, Dan Magenheimer wrote:
> ocfs2: Fix cleancache initialization call to correctly pass uuid
> 
> As reported by Steven Whitehouse in https://lkml.org/lkml/2011/5/27/221 
> the ocfs2 volume UUID is incorrectly passed to cleancache.
> As a result, shared-ephemeral tmem pools will not actually
> be created; instead they will be private (unshared) which
> misses out on a major benefit of tmem.
> 
> Reported-by: Steven Whitehouse <swhiteho@redhat.com>
> Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>

	This patch is now in the 'fixes' branch of ocfs2.git.

Joel

> 
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -2374,7 +2374,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  		mlog_errno(status);
>  		goto bail;
>  	}
> -	cleancache_init_shared_fs((char *)&uuid_net_key, sb);
> +	cleancache_init_shared_fs((char *)&di->id2.i_super.s_uuid, sb);
>  
>  bail:
>  	return status;

-- 

"Well-timed silence hath more eloquence than speech."  
         - Martin Fraquhar Tupper

			http://www.jlbec.org/
			jlbec at evilplan.org
