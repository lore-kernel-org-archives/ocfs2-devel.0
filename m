From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri Feb 13 21:18:44 2004
Subject: [Ocfs2-devel] Request to remove -Wfno-format
In-Reply-To: <20040214030940.GA12892@penguin.co.intel.com>
References: <20040212202959.GA23932@ca-server1.us.oracle.com>
	<20040213015201.GA4171@penguin.co.intel.com>
	<20040213034433.GA1193@ca-server1.us.oracle.com>
	<20040213054330.GA12076@penguin.co.intel.com>
	<20040213221537.GA15067@ca-server1.us.oracle.com>
	<20040214000654.GA26945@penguin.co.intel.com>
	<20040214010423.GB18686@ca-server1.us.oracle.com>
	<20040214013748.GA27767@penguin.co.intel.com>
	<20040214030500.GA19657@ca-server1.us.oracle.com>
	<20040214030940.GA12892@penguin.co.intel.com>
Message-ID: <20040214031841.GH26331@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 13, 2004 at 07:09:40PM -0800, Rusty Lynch wrote:
> I have something here that instead of doing crazy cast, with define a U64_MODIFIER
> that will expand appropriatly.  So... it's always correct and much easier on the eyes.
> 
> printk's would look something like:
> 
> printk(KERN_DEBUG "size_t is %Zu, and a u64 is " U64_MODIFIER "\n", asize, au64value);
> 
> Let me do one more verification on the patch and I will send it out.
> 
>     --rusty

Have you seen how often we print out __u64's? I predict that chopping up our
format strings with that will be much uglier than a cast macro ;)
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
