From: Manish Singh <manish.singh@oracle.com>
Date: Tue Feb 10 20:06:47 2004
Subject: [Ocfs2-devel] Patch to add some error checking to super.c
In-Reply-To: <40298266.6040503@intel.com>
References: <40298266.6040503@intel.com>
Message-ID: <20040211020642.GA21358@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Feb 10, 2004 at 05:16:22PM -0800, John Villalovos wrote:
> I am starting to explore the code and I started at super.c.
> 
> Here is a patch to add some error checking.  It also removes a redundant 
> INIT_LIST_HEAD call.

Cool.
 
> +	if ( !OcfsGlobalCtxt.oin_cache ) return -ENOMEM;

When dealing with a code base, it's best to use the style the rest of the
file uses. So stuff like:

	if (!OcfsGlobalCtxt.oin_cache)
		return -ENOMEM;

is preferred, or even OcfsGlobalCtxt.oin_cache == NULL

-Manish
