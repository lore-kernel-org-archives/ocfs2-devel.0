From: David Teigland <teigland@redhat.com>
Date: Wed, 8 Jul 2009 09:15:42 -0500
Subject: [Ocfs2-devel] lvb length issue [was Re: [ocfs2-tools-devel]
	question of ocfs2_controld (Jun 27)]
In-Reply-To: <20090707174741.GA24163@mail.oracle.com>
References: <4A451AB5.9070908@suse.de> <20090626193436.GC4478@mail.oracle.com>
	<4A45257C.6040704@suse.de> <20090629080023.GB8373@mail.oracle.com>
	<4A51ED7F.2040105@suse.de> <20090707160113.GA9140@redhat.com>
	<20090707174741.GA24163@mail.oracle.com>
Message-ID: <20090708141542.GA8778@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jul 07, 2009 at 10:47:42AM -0700, Joel Becker wrote:
> On Tue, Jul 07, 2009 at 11:01:13AM -0500, David Teigland wrote:
> > On Mon, Jul 06, 2009 at 08:26:39PM +0800, Coly Li wrote:
> > > DLM_USER_LVB_LEN is defined to 32.
> > 
> > > DLM_LVB_LEN is 64.
> > 
> > Yes, the kernel dlm api allows a variable lvb size, but the user dlm api fixes
> > it at 32.
> > 
> > Do you need to actually use a 64 byte lvb from userspace?  Or do you just need
> > to create the locksapce with a 64 byte lvb?  We could add a flag to work
> > around the later fairly easily.  Changing the dlm user/kernel interface to
> > copy variable size lvb's would take some significant work.
> 
> 	In this case, it's userspace utilities locking to verify no one
> else is doing anything in the cluster.  coly has noticed mkfs.ocfs2, but
> tunefs.ocfs2 and fsck.ocfs2 do the same thing.
> 	While a 64byte user lvb would be ideal, I think a flag to work
> around it would be great.  If the flag says "I know this lockspace may
> have !32byte LVBs, but I promise not to use them", and you can error
> when someone tries to set/get LVBs in that case, I think it works.

OK, I should have a patch for you to try in the next day or two.
Dave
