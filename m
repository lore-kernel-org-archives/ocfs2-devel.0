From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Mar 29 15:29:53 2004
Subject: [Ocfs2-devel] [PATCH]remove ocfs_fill_super and port
	ocfs_read_super
In-Reply-To: <20040326204638.GA7147@penguin.co.intel.com>
References: <200403260259.i2Q2xnp9006458@penguin.co.intel.com>
	<20040326143454.GG18020@ca-server1.us.oracle.com>
	<20040326204638.GA7147@penguin.co.intel.com>
Message-ID: <20040329212947.GW10672@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 26, 2004 at 12:46:38PM -0800, Rusty Lynch wrote:
> How about something like...
Could you move the MOD_INC_USE_COUNT / MOD_DEC_USE_COUNT macros out of the
generic function too?

We could make ocfs_set_blocksize an inline, unless you think it's too big
for that...
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
