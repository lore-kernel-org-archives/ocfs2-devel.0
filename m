From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Mar 22 17:00:18 2004
Subject: [Ocfs2-devel] Tiny fix to remove dead code
In-Reply-To: <405B4213.3090008@intel.com>
References: <405B4213.3090008@intel.com>
Message-ID: <20040322230013.GA10672@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 19, 2004 at 10:55:15AM -0800, John L. Villalovos wrote:
> Since this section of code is wrapped in a
> #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
> it seemed like this was redundant.
Alright, for whatever reason I had to hand patch this one, but it's in
there.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
