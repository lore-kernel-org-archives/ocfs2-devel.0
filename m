From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 18 May 2010 12:03:48 -0700
Subject: [Ocfs2-devel] [PATCH 4/4] Ocfs2: Optimize punching-hole codes
	v5.
In-Reply-To: <1273571685-28000-5-git-send-email-tristan.ye@oracle.com>
References: <1273571685-28000-1-git-send-email-tristan.ye@oracle.com>
	<1273571685-28000-5-git-send-email-tristan.ye@oracle.com>
Message-ID: <20100518190348.GK20644@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, May 11, 2010 at 05:54:45PM +0800, Tristan Ye wrote:
> V5 patch simplifies the logic of handling existing holes and procedures
> for skipping extent blocks, and removed most of confusing comments.
> 
> V5 patch has survived with fill_verify_holes testcase in ocfs2-test,
> it also passed my manual sanity check and stress tests with enormous
> extent records.

Ok, this looks good too.


> Currently punching hole on a file with 3+ extent tree depth was
> really a performance disaster, it even caused several hours to
> go, though we may not hit this in real life with such a huge extent
> number.
> 
> One simple way to improve the performance is quite straightforward,
> by learning the logic of truncating codes, means we'd punch hole from
> hole_end to hole_start, which reduce the overhead of btree operation
> in a significant way, such as tree rotation and moving.

Right, so by punching from right to left, we're optimizing away rotations
for at least those calls which are asking for a hole at the tail of the
file. What is the performance change if we consider the other cases
(punching in the middle or beginning of a file) only?


Code-wise everything looks sane. I won't lie - it helps me to be comfortable
the changes knowing that you tested regularly with our tools  ;)

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
	--Mark

--
Mark Fasheh
