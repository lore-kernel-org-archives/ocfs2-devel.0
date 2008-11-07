From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 7 Nov 2008 14:46:14 -0800
Subject: [Ocfs2-devel] [PATCH 05/15] ocfs2/xattr: Merge xattr
	set	transaction.
In-Reply-To: <1225345335-11527-5-git-send-email-tao.ma@oracle.com>
References: <49099B13.9030802@oracle.com>
	<1225345335-11527-5-git-send-email-tao.ma@oracle.com>
Message-ID: <20081107224614.GB28338@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Oct 30, 2008 at 01:42:15PM +0800, Tao Ma wrote:
> In current ocfs2/xattr, the whole xattr set is divided into
> many steps are many transaction are used, this make the
> xattr set process isn't like a real transaction, so this
> patch try to merge all the transaction into one. Another
> benefit is that acl can use it easily now.

	There's nothing in this patch that looks horribly wrong.  I will
admit, I don't have enough of a grasp of this code to evaluate it
deeply.  I think we should apply it, and as I finish up my bucket work
on the new _set() path I'll mention anything I see as a go there.

> I don't merge the transaction of deleting xattr when we
> remove an inode. The reason is that if we have a large number
> of xattrs and every xattrs has large values(large enough
> for outside storage), the whole transaction will be very
> huge and it looks like jbd can't handle it(I meet with a
> jbd complain once). And the old inode removal is also divided
> into many steps, so I'd like to leave as it is.

	I think this is the right way to go.

Joel

-- 

"When ideas fail, words come in very handy." 
         - Goethe

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
