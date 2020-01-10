From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 9 Jan 2020 16:27:13 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: remove unneeded header include
 path in fs/ocfs2/Makefile
In-Reply-To: <20200105070023.27806-1-masahiroy@kernel.org>
References: <20200105070023.27806-1-masahiroy@kernel.org>
Message-ID: <20200109162713.2054e05ff4545c30b0fa168f@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Sun,  5 Jan 2020 16:00:23 +0900 Masahiro Yamada <masahiroy@kernel.org> wrote:

> You can build fs/ocfs2 without this.
> 
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> ---
> 
>  fs/ocfs2/Makefile | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
> index cc9b32b9db7c..46381d9dd890 100644
> --- a/fs/ocfs2/Makefile
> +++ b/fs/ocfs2/Makefile
> @@ -1,5 +1,4 @@
>  # SPDX-License-Identifier: GPL-2.0
> -ccflags-y := -I$(src)
>  
>  obj-$(CONFIG_OCFS2_FS) += 	\
>  	ocfs2.o			\

I get

fs/ocfs2/alloc.c:21:10: fatal error: cluster/masklog.h: No such file or directory
 #include <cluster/masklog.h>
