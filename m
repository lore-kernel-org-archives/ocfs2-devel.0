From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 2 Jul 2008 12:44:31 -0700
Subject: [Ocfs2-devel] Add --force option in tunefs
In-Reply-To: <20080702094655.GA6088@baloo.nue.novell.com>
References: <20080702094655.GA6088@baloo.nue.novell.com>
Message-ID: <20080702194431.GH29916@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jul 02, 2008 at 03:18:04PM +0530, Goldwyn Rodrigues wrote:

	Hey, there.  Tools changes belong on
ocfs2-tools-devel at oss.oracle.com, so I've copied that mailing list.

> This patch enable --force option in tunefs.ocfs2
> Like mkfs, the --force option ignores cluster initialization 
> and locking.

	Thanks for the patch, but we decided long ago that we didn't
want tunefs run without the cluster.  That's why there is no force
option.  It's intentional.

Joel

-- 

"Born under a bad sign.
 I been down since I began to crawl.
 If it wasn't for bad luck,
 I wouldn't have no luck at all."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
