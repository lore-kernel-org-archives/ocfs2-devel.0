From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 12 Mar 2010 17:19:22 +0800
Subject: [Ocfs2-devel] [PATCH 4/4] ocfs2-1.6: add splice read/write
	support
In-Reply-To: <1268384856-3929-1-git-send-email-tiger.yang@oracle.com>
References: <1268384742-3861-1-git-send-email-tiger.yang@oracle.com>
	<1268384856-3929-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <4B9A071A.3030706@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi tiger,

Tiger Yang wrote:
> This patch copied splice code in mainline 2.6.29
> to allow support for splice io with enterprise
> kernels based on 2.6.18.
> 
> Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
> ---
>  Config.make.in               |    1 +
>  configure.in                 |   10 ++-
>  fs/ocfs2/Makefile            |    7 +
>  fs/ocfs2/compat_splice.c     |  251 ++++++++++++++++++++++++++++++++++++++++++
>  fs/ocfs2/file.c              |   90 ++++-----------
>  fs/ocfs2/xattr.c             |    2 +-
>  kapi-compat/include/splice.h |   21 ++++
>  7 files changed, 314 insertions(+), 68 deletions(-)
>  create mode 100644 fs/ocfs2/compat_splice.c
>  create mode 100644 kapi-compat/include/splice.h
>  ifdef SKIP_BUFFER_TRIGGERS
> diff --git a/fs/ocfs2/compat_splice.c b/fs/ocfs2/compat_splice.c
> new file mode 100644
> index 0000000..9533d37
> --- /dev/null
> +++ b/fs/ocfs2/compat_splice.c
> @@ -0,0 +1,251 @@
> +/*
> + * compat_splice.c
> + *
> + * This code has been copied from mainline linux kernel 2.6.29
> + * to allow ocfs2 to build against older kernels. For license,
> + * refer to fs/splice.c in mainline linux kernel.
> + */
> +
> +void pipe_wait(struct pipe_inode_info *pipe)
I just see that el5 already has splice support, see 
http://www.redhat.com/rhel/features/

So we still need to copy these functions back? At least in el5u2, I see 
these functions like pipe_wait, pipe_to_file etc.

Regards,
Tao
