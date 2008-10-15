From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Tue, 14 Oct 2008 18:20:37 -0700
Subject: [Ocfs2-devel] [git patches] Ocfs2 features for 2.6.28 (build
	errors)
In-Reply-To: <20081014200319.GK15154@wotan.suse.de>
References: <20081014200319.GK15154@wotan.suse.de>
Message-ID: <20081014182037.38503fd0.randy.dunlap@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Andrew Morton <akpm@linux-foundation.org>

On Tue, 14 Oct 2008 13:03:19 -0700 Mark Fasheh wrote:

> Hi Linus,
> 
> 	The majority of these Ocfs2 patches were sent to the list back in
> September:
> 
> 	http://lkml.org/lkml/2008/9/24/383
> 
> All feedback has been incorporated - my original e-mail describing the
> contents of our tree is attached below.
> 
> The only exception is that I added (after the initial send to lkml) an
> internal api cleanup series from Joel. This doesn't really make any
> functional changes, but simplifies our block I/O handling code in
> anticipation of some features we're planning for 2.6.29. For reference,
> these changes are the topmost 6 patches in the branch. I don't think they're
> are particularly controversial or tricky.
> 	--Mark
> 
> Please pull from 'upstream-linus' branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus


In 2.6.27-git5 I am seeing build errors as follow:

fs/ocfs2/xattr.c: In function 'ocfs2_xattr_bucket_find':
fs/ocfs2/xattr.c:2352: error: 'OCFS2_BH_CACHED' undeclared (first use in this function)
fs/ocfs2/xattr.c:2352: error: (Each undeclared identifier is reported only once
fs/ocfs2/xattr.c:2352: error: for each function it appears in.)
fs/ocfs2/xattr.c: In function 'ocfs2_iterate_xattr_buckets':
fs/ocfs2/xattr.c:2429: error: 'OCFS2_BH_CACHED' undeclared (first use in this function)
fs/ocfs2/xattr.c: In function 'ocfs2_xattr_update_xattr_search':
fs/ocfs2/xattr.c:2697: error: 'OCFS2_BH_CACHED' undeclared (first use in this function)
fs/ocfs2/xattr.c: In function 'ocfs2_defrag_xattr_bucket':
fs/ocfs2/xattr.c:2902: error: 'OCFS2_BH_CACHED' undeclared (first use in this function)
fs/ocfs2/xattr.c: In function 'ocfs2_read_xattr_bucket':
fs/ocfs2/xattr.c:3157: error: 'OCFS2_BH_CACHED' undeclared (first use in this function)
fs/ocfs2/xattr.c: In function 'ocfs2_xattr_set_entry_in_bucket':
fs/ocfs2/xattr.c:4104: error: 'OCFS2_BH_CACHED' undeclared (first use in this function)
make[2]: *** [fs/ocfs2/xattr.o] Error 1


---
~Randy
