From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 18 May 2010 12:32:41 -0700
Subject: [Ocfs2-devel] [PATCH 8/10] fs/ocfs2/dlm: Use kstrdup
In-Reply-To: <Pine.LNX.4.64.1005142130310.28935@ask.diku.dk>
References: <Pine.LNX.4.64.1005142130310.28935@ask.diku.dk>
Message-ID: <20100518193241.GE3239@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Julia Lawall <julia@diku.dk>
Cc: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

On Fri, May 14, 2010 at 09:30:48PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Use kstrdup when the goal of an allocation is copy a string into the
> allocated region.
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression from,to;
> expression flag,E1,E2;
> statement S;
> @@
> 
> -  to = kmalloc(strlen(from) + 1,flag);
> +  to = kstrdup(from, flag);
>    ... when != \(from = E1 \| to = E1 \)
>    if (to==NULL || ...) S
>    ... when != \(from = E2 \| to = E2 \)
> -  strcpy(to, from);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

This patch is now in the merge-window branch of ocfs2.git.

Joel

-- 

"If you are ever in doubt as to whether or not to kiss a pretty girl, 
 give her the benefit of the doubt"
                                        -Thomas Carlyle

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
