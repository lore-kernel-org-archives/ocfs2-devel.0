From: Joel Becker <jlbec@evilplan.org>
Date: Sat, 26 Mar 2011 14:42:47 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2-tools: support strictatime in
	ocfs2
In-Reply-To: <1299065437-6594-1-git-send-email-tiger.yang@oracle.com>
References: <4D6E2994.1050302@oracle.com>
	<1299065437-6594-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <20110326214246.GA8837@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 02, 2011 at 07:30:37PM +0800, Tiger Yang wrote:
> Strictatime was introduced into vfs, so this patch adding support
> to it in ocfs2. Now we have three types behavior about update atime,
> noatime, relatime and strictatime. With strictatime, the minimum
> update interval is specified by atime_quantum, which defaults to 60 secs.

<snip>

> diff --git a/mount.ocfs2/opts.c b/mount.ocfs2/opts.c
> index 5ecd36b..96037da 100644
> --- a/mount.ocfs2/opts.c
> +++ b/mount.ocfs2/opts.c
> @@ -78,12 +78,12 @@ static const struct opt_map opt_map[] = {
>    { "mand",	0, 0, MS_MANDLOCK },	/* Allow mandatory locks on this FS */
>    { "nomand",	0, 1, MS_MANDLOCK },	/* Forbid mandatory locks on this FS */
>    { "loop",	1, 0, MS_LOOP	},	/* use a loop device */
> -  { "atime",	0, 1, MS_NOATIME },	/* Update access time */

	Won't this break people saying 'mount -o noatime'?

Joel

-- 

"Maybe the time has drawn the faces I recall.
 But things in this life change very slowly,
 If they ever change at all."

			http://www.jlbec.org/
			jlbec at evilplan.org
