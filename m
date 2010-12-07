From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 6 Dec 2010 16:45:10 -0800
Subject: [Ocfs2-devel] [RFC] ocfs2: Remove j_trans_barrier
In-Reply-To: <4CEF554E.2060608@oracle.com>
References: <4CBE8751.1060606@oracle.com>
	<20101125100822.GA28616@mail.oracle.com>
	<4CEF554E.2060608@oracle.com>
Message-ID: <20101207004510.GJ16687@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Nov 26, 2010 at 02:35:58PM +0800, Tao Ma wrote:
> Hi Joel,
> 
> On 11/25/2010 06:08 PM, Joel Becker wrote:
> >	First, we don't always checkpoint from a downconvert.  We do it
> >in clear_inode() as well, when we are flushing an inode from cache.
> >This may not have anything to do with the lock we're caring about, eg on
> >other inodes.  What I mean is, the caching info for the inode we care
> >about may not be checkpointing, but the journal as a whole is.  We need
> >to stop all action while that is happening.
> Sorry I don't get your last sentense. Could you please describe it
> in detail? Yes, clear_inode does do checkpointing, but actually the
> whole thing is self-contained. In ocfs2_checkpoint_inode, it can
> checkpoint the inode by itself and has no relationship with
> downconvert.

	I mean that our transaction on the inode might affect other
things (like system files) that are in flux, and they could have open
stuff against them.  Essentially, with JBD, I'm not sure we can trust
the state unless we freeze it.  I really wish Mark could comment here,
but I think he's pretty busy.

Joel

-- 

"Always give your best, never get discouraged, never be petty; always
 remember, others may hate you.  Those who hate you don't win unless
 you hate them.  And then you destroy yourself."
	- Richard M. Nixon

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
