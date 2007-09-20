From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Sep 20 11:47:27 2007
Subject: [Ocfs2-devel] [PATCH 08/15] ocfs2: Provide convenience
	function for ino lookup
In-Reply-To: <200709192012.l8JKCGXI029319@rgmgw2.us.oracle.com>
References: <200709192012.l8JKCGXI029319@rgmgw2.us.oracle.com>
Message-ID: <20070920184651.GK30391@tasint.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Sep 11, 2007 at 03:22:06PM -0700, Mark Fasheh wrote:
> A couple paths which needed to just match a parent dir + name pair to an
> inode number were a bit messy because they had to deal with
> ocfs2_find_files_on_disk() which returns a larger number of values. Provide
> a convenience function, ocfs2_lookup_ino_from_name() which internalizes all
> the extra accounting.
> 
> Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

Signed-off-by: Joel Becker <joel.becker@oracle.com>


-- 

Life's Little Instruction Book #3

	"Watch a sunrise at least once a year."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
