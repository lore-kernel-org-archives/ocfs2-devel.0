From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 9 Jul 2008 11:29:43 -0700
Subject: [Ocfs2-devel] [PATCH 3/4] ocfs2: Fixes tiny race between
	mount	and recovery
In-Reply-To: <20080709173520.GH28100@wotan.suse.de>
References: <1215462380-12975-1-git-send-email-sunil.mushran@oracle.com>
	<1215462380-12975-4-git-send-email-sunil.mushran@oracle.com>
	<20080707205037.GB8651@mail.oracle.com>
	<4872C7A4.1010507@oracle.com> <48739F16.7000205@oracle.com>
	<20080708181706.GA13557@mail.oracle.com>
	<20080709173520.GH28100@wotan.suse.de>
Message-ID: <20080709182943.GA4384@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jul 09, 2008 at 10:35:20AM -0700, Mark Fasheh wrote:
> On Tue, Jul 08, 2008 at 11:17:06AM -0700, Joel Becker wrote:
> > On Tue, Jul 08, 2008 at 10:08:38AM -0700, Sunil Mushran wrote:
> > > Instead of using generation, we could use ij_pad. Renamed to
> > > something appropriate.
> > 
> > 	I like that, as it is specific to the journal part and leaves
> > i_generation alone.  Can we see ourselves needing any other use of that
> > word?
> 
> The only thing that crossed my mind would be journal version (for when we have
> JBD2), but I think it's better to use an inode flag for that anyway.

	Don't we have extra flag space on journal1.ij_flags?  That seems
like the right place for OCFS2_JOURNAL_FLAG_JBD2.

Joel

-- 

"I'm drifting and drifting
 Just like a ship out on the sea.
 Cause I ain't got nobody, baby,
 In this world to care for me."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
