From: Manish Singh <manish.singh@oracle.com>
Date: Fri Feb 13 16:15:41 2004
Subject: [Ocfs2-devel] Request to remove -Wfno-format
In-Reply-To: <20040213054330.GA12076@penguin.co.intel.com>
References: <200402121839.i1CIdRaY027264@penguin.co.intel.com>
	<20040212202959.GA23932@ca-server1.us.oracle.com>
	<20040213015201.GA4171@penguin.co.intel.com>
	<20040213034433.GA1193@ca-server1.us.oracle.com>
	<20040213054330.GA12076@penguin.co.intel.com>
Message-ID: <20040213221537.GA15067@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Feb 12, 2004 at 09:43:30PM -0800, Rusty Lynch wrote:
> On Thu, Feb 12, 2004 at 07:44:34PM -0800, Manish Singh wrote:
> > On Thu, Feb 12, 2004 at 05:52:01PM -0800, Rusty Lynch wrote:
> > > (There are a couple of places where I cast a size_t to int to stop warnings
> > > on 64bit machines... can't think of a cleaner way of printing size_t since 
> > > prink doesn't directly handle the type.)
> > 
> > %Zu works for size_t.
> 
> Ah.. I see that now in the fprintf man page.
> 
> Here is another version of the patch that uses %zu where appropriate.

Well, I really meant "%Zu". 'z' is a modifier that was introduced in C99,
but it's only in very recent 2.4.x printk implementations, i.e. none of 
current AS 2.1, EL3, or UL have it, which means we can't use it. 'Z' is
GNU extension (that's deprecated now in favor of the C99 modifier) that
*is* in all the printks we need to support, so we should use that.
__attribute__ format should know about both anyway.

BTW, are you planning on replacing HI/LO with %L in a later patch?

-Manish
