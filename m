From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Sun, 26 Jan 2020 09:47:06 +0800
Subject: [Ocfs2-devel] [PATCH] OCFS2: use OCFS2_SEC_BITS in macro
In-Reply-To: <1579577840-251956-1-git-send-email-alex.shi@linux.alibaba.com>
References: <1579577840-251956-1-git-send-email-alex.shi@linux.alibaba.com>
Message-ID: <ac7f6b5e-f62a-38a8-2511-e254c282e012@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org



On 20/1/21 11:37, Alex Shi wrote:
> This macros should be used as it.
> 
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Cc: Mark Fasheh <mark@fasheh.com> 
> Cc: Joel Becker <jlbec@evilplan.org> 
> Cc: Joseph Qi <joseph.qi@linux.alibaba.com> 
> Cc: ocfs2-devel at oss.oracle.com 
> Cc: linux-kernel at vger.kernel.org

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/dlmglue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index cda1027d0819..0d6daf49b72a 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -2133,7 +2133,7 @@ static void ocfs2_downconvert_on_unlock(struct ocfs2_super *osb,
>  }
>  
>  #define OCFS2_SEC_BITS   34
> -#define OCFS2_SEC_SHIFT  (64 - 34)
> +#define OCFS2_SEC_SHIFT  (64 - OCFS2_SEC_BITS)
>  #define OCFS2_NSEC_MASK  ((1ULL << OCFS2_SEC_SHIFT) - 1)
>  
>  /* LVB only has room for 64 bits of time here so we pack it for
> 
