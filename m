From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 22 Sep 2010 16:42:20 -0700
Subject: [Ocfs2-devel] [PATCH 1/3] shared-du: add the rbtree source and
 header file to lib v4
In-Reply-To: <1284966691-24902-1-git-send-email-jeff.liu@oracle.com>
References: <> <1284966691-24902-1-git-send-email-jeff.liu@oracle.com>
Message-ID: <4C9A945C.2070209@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 09/20/2010 12:11 AM, Jie Liu wrote:
> Add the rbtree stuff to lib.
>
> * lib/rbtree.c: Source file of rbtree.
> * lib/rbtree.h: Header file of rbtree.
> * lib/Makefile.am (libcoreutils_a_SOURCES): Add both of them.
> * lib/Makefile.in (libcoreutils_a_SOURCES): Add both of them for workaround.
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
>    

Thanks Jeff. I have pushed the patches into the git repo.
