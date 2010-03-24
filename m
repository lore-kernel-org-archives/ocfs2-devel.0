From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 23 Mar 2010 21:14:09 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Teach truncating and
 punching-hole codes to handle fastsymlink.
In-Reply-To: <4BA97E2C.8030700@oracle.com>
References: <1269331484-21262-1-git-send-email-tristan.ye@oracle.com>
	<20100323195224.GA31783@mail.oracle.com>
	<4BA96675.80506@oracle.com>
	<20100324021306.GH31783@mail.oracle.com>
	<4BA97745.8040009@oracle.com>
	<20100324023246.GI31783@mail.oracle.com>
	<4BA97E2C.8030700@oracle.com>
Message-ID: <20100324041409.GJ31783@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 24, 2010 at 10:51:24AM +0800, tristan wrote:
> > 	It's not OK to be there.  The truncate system call will error if
> > it is not a regular file.  Same with OCFS2_IOC_UNRESVP.  Thus no symlink
> > can get there.  ocfs2_truncate_for_delete() checks i_clusters before
> > calling the real truncate code.  Thus it avoids fast symlinks and inline
> > data.
> 
> Joel,
> 
> I agreed with your point on the fact that truncating for fast symlink 
> may be meaningless, since sys_truncate() will block all none-regular 
> files. while it does make sense for inline data, see 
> ocfs2_truncate_inline(), which was used to deal with inline file 
> separately. that's the way we're treating inline file when doing 
> truncating, how did you say we avoid this? that makes me confused.

	For inline data, we shortcut into ocfs2_truncate_inline() and
never go into the meaty truncate code.  That's all I meant.

Joel

-- 

"Reality is merely an illusion, albeit a very persistent one."
        - Albert Einstien

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
