From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 18 May 2010 12:32:05 -0700
Subject: [Ocfs2-devel] [PATCH 4/5] fs/ocfs2/dlm: Drop memory allocation
	cast
In-Reply-To: <Pine.LNX.4.64.1005112027000.4330@ask.diku.dk>
References: <Pine.LNX.4.64.1005112027000.4330@ask.diku.dk>
Message-ID: <20100518193205.GD3239@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Julia Lawall <julia@diku.dk>
Cc: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

On Tue, May 11, 2010 at 08:28:14PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Drop cast on the result of kmalloc and similar functions.
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> type T;
> @@
> 
> - (T *)
>   (\(kmalloc\|kzalloc\|kcalloc\|kmem_cache_alloc\|kmem_cache_zalloc\|
>    kmem_cache_alloc_node\|kmalloc_node\|kzalloc_node\)(...))
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

This patch is now in the merge-window branch of ocfs2.git.

Joel

-- 

Viro's Razor:
	Any race condition, no matter how unlikely, will occur just
	often enough to bite you.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
