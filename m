From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 14 Jul 2010 19:31:56 -0700
Subject: [Ocfs2-devel] [PATCH 0/5 v2] Add readahead support in CoW for
 reflinked files.
In-Reply-To: <4C3D6CBA.10401@oracle.com>
References: <4C3D6CBA.10401@oracle.com>
Message-ID: <20100715023156.GB14909@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jul 14, 2010 at 03:52:26PM +0800, Tao Ma wrote:
> 	When we try to CoW some clusters for a reflinked file, we have to
> read the contents first, allocate some clusters and then map these
> pages to the new clusters. Currently, we use block_read_full_page to
> read it, but it is a little bit slower.
> 	So this patch set try to add readahead support for CoW. Before we
> start, we call readahead first so that the pages can be read at the
> very first. And during CoW, when we find a readahead page, we know
> that we need to move the readahead window, so a new asyncreadahead
> is called.

	I think this looks good.  Can you create a branch in your git
tree for it?  I'll pull when I build merge-window.

Joel

-- 

"Conservative, n.  A statesman who is enamoured of existing evils,
 as distinguished from the Liberal, who wishes to replace them
 with others."
	- Ambrose Bierce, The Devil's Dictionary

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
