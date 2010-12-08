From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 7 Dec 2010 17:58:18 -0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: Try to free truncate log when
 meeting ENOSPC in write.
In-Reply-To: <1288854851-25989-1-git-send-email-tao.ma@oracle.com>
References: <1288078148-6343-1-git-send-email-tao.ma@oracle.com>
	<1288854851-25989-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20101208015818.GB22293@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Nov 04, 2010 at 03:14:11PM +0800, Tao Ma wrote:
> Recently, one of our colleagues meet with a problem that if we
> write/delete a 32mb files repeatly, we will get an ENOSPC in
> the end. And the corresponding bug is 1288.
> http://oss.oracle.com/bugzilla/show_bug.cgi?id=1288
> 
> The real problem is that although we have freed the clusters,
> they are in truncate log and they will be summed up so that
> we can free them once in a whole.
> 
> So this patch just try to resolve it. In case we see -ENOSPC
> in ocfs2_write_begin_no_lock, we will check whether the truncate
> log has enough clusters for our need, if yes, we will try to
> flush the truncate log at that point and try again. This method
> is inspired by Mark Fasheh <mfasheh@suse.com>. Thanks.

	I think I like this.  Anyone have any objections?

Joel

-- 

"Every new beginning comes from some other beginning's end."

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
