From: Manish Singh <manish.singh@oracle.com>
Date: Fri Feb 13 21:05:08 2004
Subject: [Ocfs2-devel] Request to remove -Wfno-format
In-Reply-To: <20040214013748.GA27767@penguin.co.intel.com>
References: <200402121839.i1CIdRaY027264@penguin.co.intel.com>
	<20040212202959.GA23932@ca-server1.us.oracle.com>
	<20040213015201.GA4171@penguin.co.intel.com>
	<20040213034433.GA1193@ca-server1.us.oracle.com>
	<20040213054330.GA12076@penguin.co.intel.com>
	<20040213221537.GA15067@ca-server1.us.oracle.com>
	<20040214000654.GA26945@penguin.co.intel.com>
	<20040214010423.GB18686@ca-server1.us.oracle.com>
	<20040214013748.GA27767@penguin.co.intel.com>
Message-ID: <20040214030500.GA19657@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 13, 2004 at 05:37:48PM -0800, Rusty Lynch wrote:
> On Fri, Feb 13, 2004 at 05:04:24PM -0800, Manish Singh wrote:
> > On Fri, Feb 13, 2004 at 04:06:54PM -0800, Rusty Lynch wrote:
> > > On Fri, Feb 13, 2004 at 02:15:37PM -0800, Manish Singh wrote:
> > > <snip>
> > > > Well, I really meant "%Zu". 'z' is a modifier that was introduced in C99,
> > > > but it's only in very recent 2.4.x printk implementations, i.e. none of 
> > > > current AS 2.1, EL3, or UL have it, which means we can't use it. 'Z' is
> > > > GNU extension (that's deprecated now in favor of the C99 modifier) that
> > > > *is* in all the printks we need to support, so we should use that.
> > > > __attribute__ format should know about both anyway.
> > > 
> > > Any ideas on cleanly printing sector_t? In 2.4 it was always a u32, now it
> > > is architecture dependent (u32 by default but set to u64 by most architectures
> > > including ia32 and ia64.)
> > 
> > I'd suggest always casting to u64 and using %Lu.
> 
> How would you feel about always casting to (unsigned long long)?  u64 is unsigned long
> on some arch's and unsigned long long on others.  Specifically, we get warnings
> on ia64 and ppc64 since they both define u64 as unsigned long.

Ugh. That's going to be a general problem with all u64 values. Talking with
Kurt and Mark here, they prefer a U64C define which expands to an unsigned
long long cast. You're going to need that for the HI/LO removal too.

-Manish
