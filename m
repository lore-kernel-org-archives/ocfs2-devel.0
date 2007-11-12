From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Nov 12 11:37:22 2007
Subject: [Ocfs2-devel] Ocfs2 patch set for Linux v2.6.23 now available,
	2.6.22.6 EOL
Message-ID: <20071112193604.GU28607@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Anyone running Ocfs2 on the 2.6.23 kernel should consider downloading and
applying the patches under the '2.6.23' directory at the following URL:

http://www.kernel.org/pub/linux/kernel/people/mfasheh/ocfs2/backports/

A direct link to the combined patch is:

http://www.kernel.org/pub/linux/kernel/people/mfasheh/ocfs2/backports/2.6.23/ocfs2_2.6.23_fixes-20071106-1.patch


This series includes a patch which fixes a serious performance regression
which was recently introduced into Ocfs2. Anyone experiencing poor write
performance on 2.6.23 is urged to install these patches.


The write performance fix has also been backported to the 2.6.22.6 series of
Ocfs2 patches. I anticipate it to be the last patch I will backport to the
2.6.22.y series. The specific patch against 2.6.22.6 can be found at:

http://www.kernel.org/pub/linux/kernel/people/mfasheh/ocfs2/backports/2.6.22.6/broken-out/0008-ocfs2-fix-write-performance-regression.patch


An explanation of what all this is follows. If all you're doing is running
ocfs2 1.2, feel free to ignore this e-mail. If you run a mainline kernel
with Ocfs2 or are considering it, please read on.


All Ocfs2 bug fixes are sent upstream at the earliest possible date. Some
times however, they don't make it upstream until after a stable kernel is
released.

If a bug is severe enough, I will send the fix to the -stable team which
will review it and put it in an update kernel, if it passes their criteria -
which are rather stringent.

Most fixes fall short of the criteria for -stable, but might still be
useful to folks running Ocfs2 on mainline kernels. This is where my Ocfs2
patch series comes into play.

My goal is to provide a reliable series of bugfix patches for those folks
running "bleeding edge" mainline kernels. This way they can get the most
stable mainline Ocfs2 version possible while also getting access to the
latest file system features.

The way I plan to achieve this is by backporting bug fixes from the current
development kernel into the most recent released kernel. Not all fixes will
be backported, only those which I feel are straightforward and relatively
small.

Once Linus tags the current development kernel as a stable one, it takes
about a month before my first set of patches is ready. Once those have had
some testing and are up on kernel.org, I'll send an e-mail to this list.
Additional patches will be added as they become available.

Typically, any Ocfs2 patches for the initial release of a kernel will apply
to all subsequent versions without any problems. So for example, my '2.6.22'
series should apply fine against 2.6.22.1, 2.6.22.2 and so on. If there is
ever a situation where they _won't_ apply, I'll respin the series under a
directory named for the earliest kernel version on which they should be
used. For example, if a fix from the 2.6.22 series makes it into 2.6.22.4,
the 2.6.22 set of patches will cause a reject when applied to 2.6.22.4. In
that case, I'll add another directory, 2.6.22.4 with a patch series that no
longer includes the conflicting fix (as it will have been included already
in the 2.6.22.4 distribution).


Shortlog of the current set of patches follows:

Mark Fasheh (1):
      ocfs2: fix write() performance regression

Roel Kluin (1):
      Fix priority mistakes in fs/ocfs2/{alloc.c, dlmglue.c}

Srinivas Eeda (1):
      ocfs2: fix rename vs unlink race


Finally, any feedback about this process (positive or negative) would be
greatly appreciated.

Thanks,
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
