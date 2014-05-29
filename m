From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 29 May 2014 15:42:50 -0700
Subject: [Ocfs2-devel] [PATCH] fs: ocfs2: move_extents.c: Fix to remove
 null pointer checks that could never happen
In-Reply-To: <CAFo99gZm0b8QodT56r+wegY7LM=oWFqLmpE5cnN_MaiBrx1Fqg@mail.gmail.com>
References: <1401222231-21656-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20140529140337.f999bfaaf9ffabce071962ea@linux-foundation.org>
	<20140529212308.GA16353@redhat.com>
	<20140529143840.d6fd12bc4e3cfc8d24730b6d@linux-foundation.org>
	<CAFo99gZm0b8QodT56r+wegY7LM=oWFqLmpE5cnN_MaiBrx1Fqg@mail.gmail.com>
Message-ID: <20140529154250.4be24a07ec68eb2eef41e8e2@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Dave Jones <davej@redhat.com>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jeff Liu <jeff.liu@oracle.com>

On Fri, 30 May 2014 00:39:24 +0200 Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> wrote:

> Hi all!
> 
> First, I'm no expert on this code, but after a patch which I thought
> was most accurate for the current code was written before, which was
> rather something like the code below.
> Then Jeff Liu that this was not something that could happen. So I send
> a patch where the check was removed instead.
> And that's where we are now. :-)
> 

Well if Jeff says that inode==NULL cannot happen then that is the info
I was after, and the original patch is OK.  Please resend, with that
important info in the changelog ;)
