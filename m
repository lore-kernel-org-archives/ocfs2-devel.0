From: Manish Singh <manish.singh@oracle.com>
Date: Thu Feb 12 21:44:37 2004
Subject: [Ocfs2-devel] Request to remove -Wfno-format
In-Reply-To: <20040213015201.GA4171@penguin.co.intel.com>
References: <200402121839.i1CIdRaY027264@penguin.co.intel.com>
	<20040212202959.GA23932@ca-server1.us.oracle.com>
	<20040213015201.GA4171@penguin.co.intel.com>
Message-ID: <20040213034433.GA1193@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Feb 12, 2004 at 05:52:01PM -0800, Rusty Lynch wrote:
> (There are a couple of places where I cast a size_t to int to stop warnings
> on 64bit machines... can't think of a cleaner way of printing size_t since 
> prink doesn't directly handle the type.)

%Zu works for size_t.

-Manish
