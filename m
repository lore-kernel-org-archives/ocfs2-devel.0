From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri Mar 26 08:35:06 2004
Subject: [Ocfs2-devel] [PATCH]remove ocfs_fill_super and port
	ocfs_read_super
In-Reply-To: <200403260259.i2Q2xnp9006458@penguin.co.intel.com>
References: <200403260259.i2Q2xnp9006458@penguin.co.intel.com>
Message-ID: <20040326143454.GG18020@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Mar 25, 2004 at 06:59:49PM -0800, Rusty Lynch wrote:
> The 2.6 version of ocfs_read_super (known as ocfs_fill_super) had
> a bug where it wasn't unmounting on error.  There really isn't a lot
> different between the 2.4 and 2.5 functions, so here is a patch that
> adds 2.6 support to the existing ocfs_read_super, and nukes the old
> ocfs_fill_super.

	Ugh ugh ugh.  I see what you are trying to do here, but you are
peppering one function with multiple #ifdefs.  Better to make the guts
be an #ifdef ocfs_generic_fill_super(), with:

#if KERNEL_VERSION < LINUX_VERSION_CODE(2,6,0)
static int ocfs_read_super(...)
{
    /* 2.6 specific */
    ocfs_generic_fill_super();
    /* 2.6 specific */
}
#else
static struct super_block *ocfs_read_super(...)
{
    /* 2.4 specific */
    ocfs_generic_fill_super();
    /* 2.4 specific */
}
#endif

Joel

-- 

"Under capitalism, man exploits man.  Under Communism, it's just 
   the opposite."
				 - John Kenneth Galbraith

Joel Becker
Senior Member of Technical Staff
Oracle Corporation
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
