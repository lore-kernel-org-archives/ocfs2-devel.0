From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 5 Sep 2008 03:05:43 -0700
Subject: [Ocfs2-devel] [PATCH 0/3] ocfs2: Switch over to JBD2.
In-Reply-To: <1220497421-8606-1-git-send-email-joel.becker@oracle.com>
References: <1220497421-8606-1-git-send-email-joel.becker@oracle.com>
Message-ID: <20080905100542.GN4563@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Sep 03, 2008 at 08:03:38PM -0700, Joel Becker wrote:
> ocfs2 currently uses the Journaled Block Device (JBD) for its
> journaling.  This is a very stable and tested codebase.  However, JBD
> is limited by architecture to 32bit block numbers.  This means an ocfs2
> filesystem is limited to 2^32 blocks.  With a 4K blocksize, that's 16TB.
> People want larger volumes.
> 
> Fortunately, there is now JBD2.  JBD2 adds 64bit block number support
> and some other features.  JBD2 is backwards compatible, so it can be
> used with existing filesystems.  The new features won't be accessed
> until the ocfs2-tools turn them on.
> 
> Before we support JBD2, however, we need to ensure that inode blocks are
> allocated below that 32bit boundary.  stat(2) cannot handle larger inode
> numbers on 32bit machines.  With that limit in place, we can fully
> support JBD2 in the kernel filesystem.  Like XFS, we provide the
> 'inode64' option to remove that limit.  
> 
> A config option is provided (OCFS2_COMPAT_JBD) to force ocfs2 to use the
> old JBD.  This is for the paranoid while we test JBD2.
> 
> The kernel code is available on the 'jbd2' branch of my git repository.
> 
> View:
> http://oss.oracle.com/git/?p=jlbec/linux-2.6.git;a=shortlog;h=jbd2
> Pull:
> git pull git://oss.oracle.com/git/jlbec/linux-2.6.git jbd2

Ok, these look great. A couple of notes:

- I removed an ML_NOTICE in the 1st patch
- I added information to Documentation/filesystems/ocfs2.txt in the 2nd
  patch
- Unsurprisingly, the last patch conflicted with lots of things:

CONFLICT (content): Merge conflict in fs/ocfs2/ocfs2.h
CONFLICT (content): Merge conflict in fs/ocfs2/suballoc.c
CONFLICT (content): Merge conflict in fs/ocfs2/super.c

They were fairly easy to fix - please double check my work. I created a
branch 'feature_merge' in which I pulled in xattrs, dyn_la, and then jbd2
(purposfully keeping it on top). I'll just pull that into linux-next for
now, since linux-next is throwaway and I don't want to have to re-merge
every time I create it.
	--Mark

--
Mark Fasheh
