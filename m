From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 27 Aug 2009 18:17:54 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: invalidate dentry if its
 dentry_lock isn't initialized.
In-Reply-To: <1251355616-6779-1-git-send-email-tao.ma@oracle.com>
References: <1251355616-6779-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20090828011754.GH18962@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 27, 2009 at 02:46:56PM +0800, Tao Ma wrote:
> In commit a5a0a630922a2f6a774b6dac19f70cb5abd86bb0, when
> ocfs2_attch_dentry_lock fails, we call an extra iput and reset
> dentry->d_fsdata to NULL. This resolve a bug, but it isn't
> completed and the dentry is still there. When we want to use
> it again, ocfs2_dentry_revalidate doesn't catch it and return
> true. That make future ocfs2_dentry_lock panic out.
> One bug is http://oss.oracle.com/bugzilla/show_bug.cgi?id=1162.
> 
> The resolution is to add a check for dentry->d_fsdata in
> revalidate process and return false if dentry->d_fsdata is NULL,
> so that a new ocfs2_lookup will be called again.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

This is now in the fixes branch of ocfs2.git.

Joel

-- 

"Lately I've been talking in my sleep.
 Can't imagine what I'd have to say.
 Except my world will be right
 When love comes back my way."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
