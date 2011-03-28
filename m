From: Tiger Yang <tiger.yang@oracle.com>
Date: Mon, 28 Mar 2011 16:37:48 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2-tools: support strictatime in
	ocfs2
In-Reply-To: <20110326214246.GA8837@noexit>
References: <4D6E2994.1050302@oracle.com>
	<1299065437-6594-1-git-send-email-tiger.yang@oracle.com>
	<20110326214246.GA8837@noexit>
Message-ID: <4D9048DC.4090707@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 03/27/2011 05:42 AM, Joel Becker wrote:
> diff --git a/mount.ocfs2/opts.c b/mount.ocfs2/opts.c
> index 5ecd36b..96037da 100644
> --- a/mount.ocfs2/opts.c
> +++ b/mount.ocfs2/opts.c
> @@ -78,12 +78,12 @@ static const struct opt_map opt_map[] = {
>     { "mand",	0, 0, MS_MANDLOCK },	/* Allow mandatory locks on this FS */
>     { "nomand",	0, 1, MS_MANDLOCK },	/* Forbid mandatory locks on this FS */
>     { "loop",	1, 0, MS_LOOP	},	/* use a loop device */
> -  { "atime",	0, 1, MS_NOATIME },	/* Update access time */
> 	Won't this break people saying 'mount -o noatime'?
No, It would not affect "-o noatime", actually it just disallowed "-o 
atime".

Thanks,
Tiger
