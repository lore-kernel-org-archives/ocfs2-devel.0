From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Aug 31 20:06:35 2006
Subject: [Ocfs2-devel] a patch for ocfs2_link
In-Reply-To: <44F79A94.3040101@oracle.com>
References: <44F79A94.3040101@oracle.com>
Message-ID: <20060901030633.GX7715@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Sep 01, 2006 at 10:27:32AM +0800, Tiger Yang wrote:
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index 0673862..719a8d2 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -643,11 +643,6 @@ static int ocfs2_link(struct dentry *old
>                goto bail;
>        }
> 
> -       if (inode->i_nlink >= OCFS2_LINK_MAX) {
> -               err = -EMLINK;
> -               goto bail;
> -       }
> -

	Why is this redundant?  Is someone doing it for us?  I see we
check the fe->i_links_count below, but that's after the expense of a
cluster lock.  Don't we save some effort here?

> @@ -661,6 +656,11 @@ static int ocfs2_link(struct dentry *old
>                goto bail;
>        }
> 
> +       if (!dir->i_nlink) {
> +               err = -ENOENT;
> +               goto bail;
> +       }
> +

	And what does this do?  If a directory...oh, wait, is this to
check for a directory that's going away?  Can this actually happen?  I'd
think that the VFS would protect it.

Joel

-- 

"Well-timed silence hath more eloquence than speech."  
         - Martin Fraquhar Tupper

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
