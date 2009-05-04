From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 4 May 2009 14:18:54 -0700
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2)
	system	call.
In-Reply-To: <20090504182552.GF31249@mail.oracle.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
	<20090503234518.GB17044@mit.edu> <49FE4880.3010208@oracle.com>
	<20090504182552.GF31249@mail.oracle.com>
Message-ID: <20090504211854.GC25313@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tao Ma <tao.ma@oracle.com>, Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Mon, May 04, 2009 at 11:25:52AM -0700, Joel Becker wrote:
> On Mon, May 04, 2009 at 09:44:32AM +0800, Tao Ma wrote:
> > Theodore Tso wrote:
> >> On Sat, May 02, 2009 at 11:15:01PM -0700, Joel Becker wrote:
> >> How should quota handle reflinks?  Since there are separate inodes,
> >> the two files could be owned by different user ID's.  Since the data
> >> blocks exist only once, I can imagine a number of different ways of
> >> handling it:
> <snip>
> > yeah, agree. So I will pick #3 in my ocfs2 reflink implementation.
> 
> 	While at first I was all "sure, this makes sense," now I'm
> thinking otherwise.  Because reflink() means the file attributes are
> unmodified.  So the original owner owns the new file, and thus the quota
> charge doesn't matter.  If and when the new file is changed to another
> owner, then the normal quota code will adjust the quotas.

	More thinking.  It looks like we'll restrict reflink() to owners
or people with CAP_FCHOWN.  This prevents some quota DoS behavior.
	We need to pre-charge all quota.  That means a reflink must be
charged the entire size of the file.  So, if I do:

  # dd if=/dev/zero bs=1M count=1 of=foo
  # reflink foo bar

I am now charged 2MB of quota, even though foo and bar share the same
1MB of space.
	Why?  Because if I only mark 1M of quota and then do "chown
tao.tao bar", we can't sanely keep track of fractional quota.  Wheras if
we charge the 2MB up front, the chown just moves the quota over to tao.
Copy-on-write is even cleaner - since you were pre-charged for the
quota, you don't do any quota adjustments for the data blocks in the CoW
operation (though any new metadata is a new charge).

Joel  

-- 

"The whole principle is wrong; it's like demanding that grown men 
 live on skim milk because the baby can't eat steak."
        - author Robert A. Heinlein on censorship

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
