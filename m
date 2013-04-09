From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 8 Apr 2013 17:04:09 -0700
Subject: [Ocfs2-devel] [patch 1/2 v2] Ocfs2/move_extents: fix error
 handling in ioctl
In-Reply-To: <515D6984.9030204@oracle.com>
References: <20130404114030.GA25020@longonot.mountain>
	<515D6984.9030204@oracle.com>
Message-ID: <20130408170409.b16252fc16e9cdc8abfc91eb@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, 04 Apr 2013 19:52:36 +0800 Jeff Liu <jeff.liu@oracle.com> wrote:

> On 04/04/2013 07:40 PM, Dan Carpenter wrote:
> > Smatch complains that if we hit an error (for example if the file is
> > immutable) then "range" has uninitialized stack data and we copy it to
> > the user.
> > 
> > I've re-written the error handling to avoid this problem and make it a
> > little cleaner as well.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Reviewed-by: Jie Liu <jeff.liu@oracle.com>

I can't find either of Dan's emails anywhere.  Confused.

Resend both, please?
