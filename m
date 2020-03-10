From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Tue, 10 Mar 2020 09:06:31 +0800
Subject: [Ocfs2-devel] [PATCH][next] ocfs2: cluster: Replace zero-length
 array with flexible-array member
In-Reply-To: <20200309201907.GA8005@embeddedor>
References: <20200309201907.GA8005@embeddedor>
Message-ID: <3509c78c-4387-f248-ee66-6218c1264fcf@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org



On 2020/3/10 04:19, Gustavo A. R. Silva wrote:
> The current codebase makes use of the zero-length array language
> extension to the C90 standard, but the preferred mechanism to declare
> variable-length types such as these ones is a flexible array member[1][2],
> introduced in C99:
> 
> struct foo {
>         int stuff;
>         struct boo array[];
> };
> 
> By making use of the mechanism above, we will get a compiler warning
> in case the flexible array does not occur last in the structure, which
> will help us prevent some kind of undefined behavior bugs from being
> inadvertently introduced[3] to the codebase from now on.
> 
> Also, notice that, dynamic memory allocations won't be affected by
> this change:
> 
> "Flexible array members have incomplete type, and so the sizeof operator
> may not be applied. As a quirk of the original implementation of
> zero-length arrays, sizeof evaluates to zero."[1]
> 
> This issue was found with the help of Coccinelle.
> 
> [1] https://urldefense.com/v3/__https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html__;!!GqivPVa7Brio!INdYafacLMiUgRrK-HDy3FhbqtTkRakuBQtEmPbN6cZAHCDBAvGOTj194lmB8udIjmmjqw$ 
> [2] https://urldefense.com/v3/__https://github.com/KSPP/linux/issues/21__;!!GqivPVa7Brio!INdYafacLMiUgRrK-HDy3FhbqtTkRakuBQtEmPbN6cZAHCDBAvGOTj194lmB8ufEoscJWg$ 
> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/cluster/tcp.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/cluster/tcp.h b/fs/ocfs2/cluster/tcp.h
> index de87cbffd175..736338f45c59 100644
> --- a/fs/ocfs2/cluster/tcp.h
> +++ b/fs/ocfs2/cluster/tcp.h
> @@ -32,7 +32,7 @@ struct o2net_msg
>  	__be32 status;
>  	__be32 key;
>  	__be32 msg_num;
> -	__u8  buf[0];
> +	__u8  buf[];
>  };
>  
>  typedef int (o2net_msg_handler_func)(struct o2net_msg *msg, u32 len, void *data,
> 
