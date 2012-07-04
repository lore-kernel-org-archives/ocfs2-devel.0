From: Joel Becker <jlbec@evilplan.org>
Date: Wed, 4 Jul 2012 00:31:36 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Misplaced parens in unlikley
In-Reply-To: <4EE682F3.9070905@gmail.com>
References: <4EE682F3.9070905@gmail.com>
Message-ID: <20120704073136.GB9863@dhcp-172-17-9-228.mtv.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: roel <roel.kluin@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>, moderated for non-subscribers <ocfs2-devel@oss.oracle.com>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>

On Mon, Dec 12, 2011 at 11:40:51PM +0100, roel wrote:
> Fix misplaced parentheses
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

This patch is now (finally) part of the 'fixes' branch of ocfs2.git.

Joel

> ---
>  fs/ocfs2/dlmglue.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 81a4cd2..274529c 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -456,7 +456,7 @@ static void ocfs2_update_lock_stats(struct ocfs2_lock_res *res, int level,
>  	stats->ls_gets++;
>  	stats->ls_total += ktime_to_ns(kt);
>  	/* overflow */
> -	if (unlikely(stats->ls_gets) == 0) {
> +	if (unlikely(stats->ls_gets == 0)) {
>  		stats->ls_gets++;
>  		stats->ls_total = ktime_to_ns(kt);
>  	}

-- 

"There are only two ways to live your life. One is as though nothing
 is a miracle. The other is as though everything is a miracle."
        - Albert Einstein

			http://www.jlbec.org/
			jlbec at evilplan.org
