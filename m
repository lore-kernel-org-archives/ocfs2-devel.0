From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 1 Jul 2010 02:12:22 -0700
Subject: [Ocfs2-devel] [PATCH 1/4] ocfs2: Add struct file to
	ocfs2_refcount_cow.
In-Reply-To: <4C2BDEA1.5010902@oracle.com>
References: <4C29AE6C.1050205@oracle.com>
	<1277800541-6844-1-git-send-email-tao.ma@oracle.com>
	<20100629231453.GH4150@mail.oracle.com> <4C2AB5F3.10000@oracle.com>
	<20100630120013.GA14686@mail.oracle.com>
	<4C2BDEA1.5010902@oracle.com>
Message-ID: <20100701091220.GA20973@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jul 01, 2010 at 08:17:37AM +0800, Tao Ma wrote:
> Joel Becker wrote:
> >On Wed, Jun 30, 2010 at 11:11:47AM +0800, Tao Ma wrote:
> >>oh, sorry joel. There does exist one place that we don't have filp.
> >>It is in ocfs2_orphan_for_truncate, we have to CoW the cluster
> >>containing i_size and pass NULL as filp.
> >
> >	Maybe ocfs2_cow_file_pos() needs both, but write_begin_nolock
> >and page_mkwrite do not.
> yes, so what do you mean? I am puzzled, sorry.
> You mean we export 2 different functions from refcountree.c.
> One is ocfs2_refcount_cow_file(struct file *,...)
> and another is ocfs2_refcount_cow_inode(struct inode *,...)?

	No.  Just add have refcount_cow() take both an inode and a file,
and pass the NULL file from orphan_for_truncate().  That's fine.
	But ocfs2_write_begin_nolock() and and ocfs2_page_mkwrite() can
take a file without having to take an inode.

Joel

-- 

Life's Little Instruction Book #252

	"Take good care of those you love."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
