From: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 25 Mar 2016 12:36:35 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: clean up an unused variable
 'wants_rotate' in ocfs2_truncate_rec
In-Reply-To: <56EA74BF.7090201@huawei.com>
References: <56EA74BF.7090201@huawei.com>
Message-ID: <20160325123635.9fd878212c3762c791773ce6@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, 17 Mar 2016 17:11:27 +0800 piaojun <piaojun@huawei.com> wrote:

> Clean up an unused variable 'wants_rotate' in ocfs2_truncate_rec.
> 
> Signed-off-by: Jun Piao <piaojun@huawei.com>
> ---
>  alloc.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/alloc.c b/alloc.c
> index d002579..2b8b721 100644
> --- a/alloc.c
> +++ b/alloc.c

This should be

--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c

please.  `patch -p1' form.
