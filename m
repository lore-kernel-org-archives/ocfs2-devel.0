From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Mon Mar 29 16:42:51 2004
Subject: [Ocfs2-devel] [PATCH]remove ocfs_fill_super and port
	ocfs_read_super
In-Reply-To: <20040329213158.GA12840@penguin.co.intel.com>
References: <200403260259.i2Q2xnp9006458@penguin.co.intel.com>
	<20040326143454.GG18020@ca-server1.us.oracle.com>
	<20040326204638.GA7147@penguin.co.intel.com>
	<20040329212947.GW10672@ca-server1.us.oracle.com>
	<20040329213158.GA12840@penguin.co.intel.com>
Message-ID: <20040329223754.GA15877@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Mar 29, 2004 at 01:31:58PM -0800, Rusty Lynch wrote:
> On Mon, Mar 29, 2004 at 01:29:47PM -0800, Mark Fasheh wrote:
> > On Fri, Mar 26, 2004 at 12:46:38PM -0800, Rusty Lynch wrote:
> > > How about something like...
> > Could you move the MOD_INC_USE_COUNT / MOD_DEC_USE_COUNT macros out of the
> > generic function too?
> 
> Can do
> 
> > 
> > We could make ocfs_set_blocksize an inline, unless you think it's too big
> > for that...
> 
> I should be inline.  Let me change that.

ah... first of all, s/I should be inline/It should be inlined/
hey, it's not like englihs is first (and only) language or anything :->

The only thing left in __ocfs_read_super that requires #if LINUX.../#endif's
is the ocfs_iget/iget4 stuff, which is one of those areas that I have been meaning
to deal with...  ocfs_iget() should be what get's called regardless of 2.4/2.6, 
and then deal with 2.4 verses 2.6 specifics in that function instead of sprinkled
over super/namei/hash.

You mind if I tackle this in the same patch, or do you want two patches?  (It's just
that ocfs_iget needs to be fixed before __ocfs_read_super can be made clean.)

    --rusty 
