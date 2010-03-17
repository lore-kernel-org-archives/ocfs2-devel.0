From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 17 Mar 2010 12:26:52 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Change bg_chain check for
 ocfs2_validate_gd_parent.
In-Reply-To: <1267586787-11303-1-git-send-email-tao.ma@oracle.com>
References: <1267586787-11303-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100317192651.GB2930@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 03, 2010 at 11:26:27AM +0800, Tao Ma wrote:
> In ocfs2_validate_gd_parent, we check bg_chain against the
> cl_next_free_rec of the dinode. Actually in resize, we have
> the chance of bg_chain == cl_next_free_rec. So add some
> additional condition check for it.
> 
> I also rename paramter "clean_error" to "resize", since the
> old one is not clearly enough to indicate that we should only
> meet with this case in resize.
> 
> btw, the correpsonding bug is
> http://oss.oracle.com/bugzilla/show_bug.cgi?id=1230.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

	This patch is now in the fixes branch of ocfs2.git.

Joel

-- 

"When choosing between two evils, I always like to try the one
 I've never tried before."
        - Mae West

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
