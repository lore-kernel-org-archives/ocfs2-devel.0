From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Mar 29 20:44:25 2004
Subject: [Ocfs2-devel] [PATCH]remove ocfs_fill_super and port
	ocfs_read_super
In-Reply-To: <20040329234603.GA19720@penguin.co.intel.com>
References: <200403260259.i2Q2xnp9006458@penguin.co.intel.com>
	<20040326143454.GG18020@ca-server1.us.oracle.com>
	<20040326204638.GA7147@penguin.co.intel.com>
	<20040329212947.GW10672@ca-server1.us.oracle.com>
	<20040329213158.GA12840@penguin.co.intel.com>
	<20040329223754.GA15877@penguin.co.intel.com>
	<20040329230609.GY10672@ca-server1.us.oracle.com>
	<20040329234603.GA19720@penguin.co.intel.com>
Message-ID: <20040330024421.GA10672@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Mar 29, 2004 at 03:46:03PM -0800, Rusty Lynch wrote:
> Here is my previous patch with the ocfs_set_blocksize make inline, and the addition
> of OCFS_MOD_[INC|DEC]_USE_COUNT
Ok, this is in. I fixed a couple of things, one of them being the whole
OCFS_DEC/INC_INODE_COUNT which I removed, and just put the kernel macros in
the 2.4 read_super.

You'll prolly get conflicts when updating :(

Let me know if I messed anything up for 2.6, but I seriously doubt it :)
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
