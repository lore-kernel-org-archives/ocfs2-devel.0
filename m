From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 10 Nov 2008 15:44:35 -0800
Subject: [Ocfs2-devel] ocfs2: initialize stack_user lvbptr
In-Reply-To: <20081110225507.GC12445@mail.oracle.com>
References: <20081110222457.GE17894@redhat.com>
	<20081110225507.GC12445@mail.oracle.com>
Message-ID: <20081110234435.GQ15154@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Nov 10, 2008 at 02:55:07PM -0800, Joel Becker wrote:
> On Mon, Nov 10, 2008 at 04:24:57PM -0600, David Teigland wrote:
> > commit 3d48397962cdad2aa32df75cfdae980af9bce8cc
> > Author: David Teigland <teigland@redhat.com>
> > Date:   Mon Nov 10 16:16:07 2008 -0600
> > 
> >     ocfs2: initialize stack_user lvbptr
> >     
> >     The locking_state dump, ocfs2_dlm_seq_show, reads the lvb on locks
> >     where it has not yet been initialized by a lock call.
> >     
> >     Signed-off-by: David Teigland <teigland@redhat.com>
> 
> Acked-by: Joel Becker <joel.becker@oracle.com>

Yep, looks good. I'll toss this in ocfs2.git.
	--Mark

--
Mark Fasheh
