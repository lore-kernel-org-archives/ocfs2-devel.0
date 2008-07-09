From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 9 Jul 2008 10:35:20 -0700
Subject: [Ocfs2-devel] [PATCH 3/4] ocfs2: Fixes tiny race between
	mount	and recovery
In-Reply-To: <20080708181706.GA13557@mail.oracle.com>
References: <1215462380-12975-1-git-send-email-sunil.mushran@oracle.com>
	<1215462380-12975-4-git-send-email-sunil.mushran@oracle.com>
	<20080707205037.GB8651@mail.oracle.com>
	<4872C7A4.1010507@oracle.com> <48739F16.7000205@oracle.com>
	<20080708181706.GA13557@mail.oracle.com>
Message-ID: <20080709173520.GH28100@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jul 08, 2008 at 11:17:06AM -0700, Joel Becker wrote:
> On Tue, Jul 08, 2008 at 10:08:38AM -0700, Sunil Mushran wrote:
> > Instead of using generation, we could use ij_pad. Renamed to
> > something appropriate.
> 
> 	I like that, as it is specific to the journal part and leaves
> i_generation alone.  Can we see ourselves needing any other use of that
> word?

The only thing that crossed my mind would be journal version (for when we have
JBD2), but I think it's better to use an inode flag for that anyway.
	--Mark

--
Mark Fasheh
